hook.Add( "PlayerCanHearPlayersVoice", "Maximum Range", function( listener, talker )
    if listener:GetPos():DistToSqr( talker:GetPos() ) > 250000 then
		return false
	end
end )

util.AddNetworkString("ProximityTextChat")

function texting(targets, messageTable)
	net.Start("ProximityTextChat")
	net.WriteTable(messageTable)
	if targets then
		net.Send(targets)
	else
		net.Broadcast()
	end
end

local chatcomm = {}

chatcomm["/ooc"] = {
	prefix = "[OOC] ",
	prefixColor = Color(150, 150, 150),
	textColor = Color(255, 255, 255),
	ranged = 0
}

chatcomm["//"] = {
	prefix = "[OOC] ",
	prefixColor = Color(150, 150, 150),
	textColor = Color(255, 255, 255),
	ranged = 0
}

chatcomm["/looc"] = {
	prefix = "[LOOC] ",
	prefixColor = Color(100, 100, 255),
	textColor = Color(255, 255, 255),
	ranged = 300
}

chatcomm["[["] = {
	prefix = "[LOOC] ",
	prefixColor = Color(100, 100, 255),
	textColor = Color(255, 255, 255),
	ranged = 300
}

chatcomm["/comms"] = {
	prefix = "[COMMS] ",
	prefixColor = Color(255,255,0),
	textColor = Color(255, 255, 255),
	ranged = 0,
	teamOnly = true
}

chatcomm["/me"] = {
	prefix = "* ",
	prefixColor = Color(200, 100, 50),
	textColor = Color(255, 255, 255),
	ranged = 300
}

chatcomm["/advert"] = {
	prefix = "[ADVERT] ",
	prefixColor = Color(20, 200, 255),
	textColor = Color(9, 255, 255),
	ranged = 0
}

function findByName(partialName)
    partialName = string.lower(partialName)
    for _, ply in ipairs(player.GetAll()) do
        if string.find(string.lower(ply:Nick()), partialName, 1, true) then
            return ply
        end
    end
    return nil -- No player found
end

local commands = {}

commands["/friend"] = function(ply, blob)
	local id = blob[2] or ""
	local tar = findByName(id or "")
	if tar ~= ply then
		if getVar("invite_" .. ply:SteamID64(), "") == "" then
			if IsValid(tar) and string.len(id) >= 3 then
				ply:addXP("Force", 50000)
				ply:addXP("Melee", 50000)
				ply:addXP("Defense", 50000)
				
				tar:addXP("Force", 50000)
				tar:addXP("Melee", 50000)
				tar:addXP("Defense", 50000)
				
				setVar("invite_" .. ply:SteamID64(), "yes")
				v:addLog("INVITE_SENT", "%s has been invited by %s and recieved 50k xp.", {ply:Nick(), tar:Nick()})
				v:addLog("INVITE_REC", "%s has recieved 50k xp for inviting %s", {tar:Nick(), ply:Nick()})
				
				tar:NotifyLocalized("+50k XP for you and your buddy! Invite others with the same command to get more!")
				ply:NotifyLocalized("+50k XP for you and your buddy! Invite others with the same command to get more!")
			else
				ply:NotifyLocalized("Unabled to find anyone by the name of, or with partial name " .. id)
			end
		else
			ply:NotifyLocalized("You have already been invited by someone else, you ding dong!")
		end
	else
		ply:NotifyLocalized("You can't do that..")
	end
end

commands["/trainer"] = function(ply, blob)
	local id = blob[2] or ""
	local tar = findByName(id or "")
	if tar ~= ply then
		if getVar("train_" .. ply:SteamID64(), "") == "" then
			if IsValid(tar) and string.len(id) >= 3 then
				ply:addXP("Force", 10000)
				ply:addXP("Melee", 10000)
				ply:addXP("Defense", 10000)
				
				tar:addXP("Force", 10000)
				tar:addXP("Melee", 10000)
				tar:addXP("Defense", 10000)
				setVar("train_" .. ply:SteamID64(), "yes")
				v:addLog("TRAIN_SENT", "%s has been trained by %s and recieved 50k xp.", {ply:Nick(), tar:Nick()})
				v:addLog("TRAIN_REC", "%s has recieved 50k xp for training %s", {tar:Nick(), ply:Nick()})
				
				tar:NotifyLocalized("+50k XP for you and your buddy! Invite others with the same command to get more!")
				ply:NotifyLocalized("+50k XP for you and your buddy! Invite others with the same command to get more!")
			else
				ply:NotifyLocalized("Unabled to find anyone by the name of, or with partial name " .. id)
			end
		else
			ply:NotifyLocalized("You have already been trained by someone else, you ding dong!")
		end
	else
		ply:NotifyLocalized("You can't do that..")
	end
end

commands["/mercy"] = function(ply, blob)
	if ply:IsSuperAdmin() then
		local id = blob[2] or ""
		local tar = findByName(id or "")
		if IsValid(tar) then
			tar:setVar("mmrLOSS", 0)
			tar:setVar("mmrWIN", 0)
			ply:NotifyLocalized("You have granted mercy to " .. tar:Nick())
		else
			ply:NotifyLocalized("No target found.")
		end
	end
end

commands["/unfuck"] = function(ply, blob)
	if ply:IsSuperAdmin() then
		local id = blob[2] or ""
		local tar = findByName(id or "")
		if IsValid(tar) then
			tar:addXP("Force", 50*10000)
			--tar:addXP("Melee", 15*10000)
			--tar:addXP("Defense", 15*10000)
			ply:NotifyLocalized("You have unfucked " .. tar:Nick())
		else
			ply:NotifyLocalized("No target found.")
		end
	end
end

util.AddNetworkString("lts.event")
hook.Add("PlayerSay", "ProximityTextChat", function(ply, text)
	local maxDistance = 500 -- Adjust for the local chat range
	local colorOOC = Color(150, 150, 150)
	local colorLOOC = Color(100, 100, 255)
	local colorAction = Color(200, 100, 50)
	local colorDefault = Color(255, 255, 255)
	
	local plyColor = Color(100,100,0)
	
	local pcpc = {}
	pcpc["Sith"] = Color(200,0,0)
	pcpc["Jedi"] = Color(0,200,200)
	
	if pcpc[ply:GetNW2String("team", "")] then
		plyColor = pcpc[ply:GetNW2String("team", "")]
	end
	
	local blob = string.Explode(" ",text)
	
	if ply:IsAdmin() then
		if blob[1] == "/event" then
			table.remove(blob, 1)
			local t = table.concat(blob, " ")
			net.Start("lts.event")
				net.WriteString(t)
			net.Broadcast()
			return ""
		end
	end
	if commands[blob[1]] then
		commands[blob[1]](ply, blob)
		return ""
	else
		if chatcomm[blob[1]] then
			local messageTable = {chatcomm[blob[1]].prefixColor, chatcomm[blob[1]].prefix, plyColor, ply:Nick() .. ": ", chatcomm[blob[1]].textColor, string.sub(text, string.len(blob[1])+1)}
			
			if chatcomm[blob[1]].teamOnly ~= true then
				if chatcomm[blob[1]].ranged > 0 then
					local targets = {}
					for _, player in ipairs(player.GetAll()) do
						if player:GetPos():Distance(ply:GetPos()) <= chatcomm[blob[1]].ranged then
							table.insert(targets, player)
						end
					end
					texting(targets, messageTable)
				else
					texting(nil, messageTable)
				end
			else
				local targets = {}
				for _, player in ipairs(player.GetAll()) do
					if ply:GetNW2String("team", "") == player:GetNW2String("team", "") then
						table.insert(targets, player)
					end
				end
				texting(targets, messageTable)
			end
			
			
			return ""
		else
			if string.sub(text, 1, 1) == "!" or string.sub(text, 1, 1) == "/" then
			
			else
				local messageTable = {plyColor, ply:Nick() .. ": ", colorDefault, text}
				local targets = {}
				for _, player in ipairs(player.GetAll()) do
					if player:GetPos():Distance(ply:GetPos()) <= maxDistance then
						table.insert(targets, player)
					end
				end
				texting(targets, messageTable)
				return ""
			end
		end
	end
end)
