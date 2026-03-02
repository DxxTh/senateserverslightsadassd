local payloads = {}

function addPayloader(data)
    table.insert(payloads, data)
end

local p = 0
hook.Add("Think", "24809", function()
	if p <= CurTime() then
		for k,v in pairs(ents.FindByClass("payload")) do
			v:Remove()
		end
		for k,data in pairs(payloads) do
			local ent = ents.Create("payload")
			ent:SetPos(data.position)
			ent:SetAngles(data.angle)

			ent.ModelPath = data.model or "models/props_c17/oildrum001.mdl"
			ent.message = data.message
			ent.payload = data.payload -- function with ply as argument
			
			if data.anim then ent.anim = data.anim end
			
			-- Set the title using SetNW2String
			ent:SetNW2String("Title", data.title or "Payload")

			ent:Spawn()
			ent:Activate()

			-- Freeze the entity
			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
				phys:EnableMotion(false)
			end
		end
		p = CurTime() + 90
	end
end)

addPayloader({
    title = "Teleport Station",
    position = Vector(842,-241, -144),
    angle = Angle(0, 90, 0),
    model = "models/Combine_Helicopter/helicopter_bomb01.mdl",
	message = "",
    payload = function(ply)
        local playerTeam = ply:GetNW2String("team", "Loading")
        local availablePlanets = lts.teleportPositions or {}

        net.Start("OpenTeleportMenu")
        net.WriteTable(availablePlanets)
        net.Send(ply)
    end,
})

addPayloader({
    title = "Ranked PvP",
    position = Vector(837,-338, -144),
    angle = Angle(0, 90, 0),
    model = "models/player/alyx.mdl",
    message = "",
    anim = "idle_passive",
    payload = function(ply)
        local messages = {
			"Every kill you gain on a player grants you an MMR rating,",
			"Killing higher ranked players grants you a lot of MMR!",
        }
        
		net.Start("BroadcastAlert")
			net.WriteString("Starter Tutorial")
			net.WriteTable(messages)
		net.Send(ply)
		ply:EmitSound("starsound/click.mp3")
    end,
})



addPayloader({
    title = "Auspicious Book",
    position = Vector(834,-426, -144),
    angle = Angle(0, 0, 0),
    model = "models/Combine_Helicopter/helicopter_bomb01.mdl",
    message = "",
    anim = "idle_passive",
    payload = function(ply)
        ply:learn()
		ply:EmitSound("starsound/click.mp3")
    end,
})

addPayloader({
    title = "Take the Bloodpact Bind",
    position = Vector(829,-528, -144),
    angle = Angle(0, 90, 0),
    model = "models/player/alyx.mdl",
    message = "",
    anim = "idle_passive",
    payload = function(ply)
        local totalLevel = ply:getLevel("Melee") + ply:getLevel("Force") + ply:getLevel("Defense")
		if totalLevel >= 250 then
			if ply:getVar("sub-class", "") == "" then
				local highestRank = 0
				for k,v in pairs(ents.FindInSphere(ply:GetPos(), 64)) do
					if v:IsPlayer() then
						if v ~= ply then
							lts.ranks[v:GetNW2String("role", "")] = lts.ranks[v:GetNW2String("role", "")] or 0
							if highestRank < lts.ranks[v:GetNW2String("role", "")] then
								highestRank = lts.ranks[v:GetNW2String("role", "")]
							end
						end
					end
				end
				
				lts.ranks[ply:GetNW2String("role", "")] = lts.ranks[ply:GetNW2String("role", "")] or 0
				local rankedNear = lts.ranks[ply:GetNW2String("role", "")] < highestRank
				
				if rankedNear then
					local rewards = {}
					rewards["Sorcerer"] = "Dark Transfer"
					rewards["Assassin"] = "Force Horror"
					rewards["Marauder"] = "Force Stalk"
					rewards["Juggernaut"] = "Dark Shield"
					rewards["Sentinel"] = "Force Sense"
					rewards["Guardian"] = "Force Guard"
					rewards["Sage"] = "Force Rejuvinate"
					rewards["Shadow"] = "Force Fear"
					
					local class = ply:GetNW2String("subclass", "")
					
					local pwr = rewards[class]
					
					ply:grantPower(pwr)
					
					ply:NotifyLocalized("You have chosen to embrace the " .. class .. " class, as such, you have learned " .. pwr)
					
				else
					ply:NotifyLocalized("You must have someone higher ranked near you. " .. lts.ranks[ply:GetNW2String("role", "")] .. " vs " .. highestRank)
				end
				
			else
				ply:NotifyLocalized("You must be Total Level 250 or higher.")
			end
		end
    end,
})


addPayloader({
    title = "Dedicate yourself",
    position = Vector(826,-617, -144),
    angle = Angle(0, 0, 0),
    model = "models/player/alyx.mdl",
    message = "",
    anim = "idle_passive",
    payload = function(ply)
        local totalLevel = ply:getLevel("Melee") + ply:getLevel("Force") + ply:getLevel("Defense")
		if totalLevel >= 250 then
			if ply:getVar("sub-class", "") == "" then
				local highestRank = 0
				for k,v in pairs(ents.FindInSphere(ply:GetPos(), 64)) do
					if v:IsPlayer() then
						if v ~= ply then
							lts.ranks[v:GetNW2String("role", "")] = lts.ranks[v:GetNW2String("role", "")] or 0
							if highestRank < lts.ranks[v:GetNW2String("role", "")] then
								highestRank = lts.ranks[v:GetNW2String("role", "")]
							end
						end
					end
				end
				
				lts.ranks[ply:GetNW2String("role", "")] = lts.ranks[ply:GetNW2String("role", "")] or 0
				local rankedNear = lts.ranks[ply:GetNW2String("role", "")] < highestRank
				
				if rankedNear then
					local rewards = {}
					rewards["Sorcerer"] = "Dark Transfer"
					rewards["Assassin"] = "Force Horror"
					rewards["Marauder"] = "Force Stalk"
					rewards["Juggernaut"] = "Dark Shield"
					rewards["Sentinel"] = "Force Sense"
					rewards["Guardian"] = "Force Guard"
					rewards["Sage"] = "Force Rejuvinate"
					rewards["Shadow"] = "Force Fear"
					
					local class = ply:GetNW2String("subclass", "")
					
					local pwr = rewards[class]
					
					ply:grantPower(pwr)
					
					ply:NotifyLocalized("You have chosen to embrace the " .. class .. " class, as such, you have learned " .. pwr)
					
				else
					ply:NotifyLocalized("You must have someone higher ranked near you.")
				end
				
			else
				ply:NotifyLocalized("You must be Total Level 250 or higher.")
			end
		end
    end,
})



