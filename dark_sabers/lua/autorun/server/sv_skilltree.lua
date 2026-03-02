local meta = FindMetaTable("Player")

util.AddNetworkString("lts.skilltree")
util.AddNetworkString("lts.powerbar")
util.AddNetworkString("lts.skilltree.req")

net.Receive("lts.skilltree", function(len,ply)
	
	local power = net.ReadString()
	local powers = ply:getPowers()
	local points = ply:getSkillPoints()
	if points > 0 then
		if not powers[power] then
			if lts.getPower(power) then
				local pwr = lts.getPower(power)
				
				local canLearn = true
				local isAllowed = false
			
				for a,b in pairs(pwr.requires) do
					if not powers[b] then
						canLearn = false
						break
					end
				end
			
				for a,b in pairs(pwr.allowed) do
					if b == ply:GetNW2String("team", "") then
						isAllowed = true
					end
				end
				
				if canLearn and isAllowed then
					ply:takeSkillPoints(1)
					ply:grantPower(power)
					ply:addLog("SKILLTREE_GRANTPOWER", "%s has unlocked %s", {ply:Nick(), power})
					ply:NotifyLocalized("You have now learned " .. power)
					net.Start("lts.skilltree")
						net.WriteTable(ply:getPowers())
					net.Send(ply)
				else
					ply:NotifyLocalized("You are missing the required powers to learn this ability.")
				end
				
			else
				ply:NotifyLocalized("That isn't a real power, account flagged for illegal activity.")
			end
		else
			ply:NotifyLocalized("You already have that power learned.")
		end
	else
		ply:NotifyLocalized("You do not have enough skill points.")
	end
end)

function meta:networkSkillPoints()
	self:SetNWInt("skillpoints", self:getSkillPoints())
end

function meta:setSkillPoints(a)
	self:setVar("skillpoints", a)
	self:networkSkillPoints()
end

function meta:addSkillPoints(a)
	local b = self:getSkillPoints()
	self:setVar("skillpoints", b+a)
	self:networkSkillPoints()
end

function meta:getSkillPoints()
	return self:getVar("skillpoints", 0)
end

function meta:takeSkillPoints(a)
	local b = self:getSkillPoints()
	self:setVar("skillpoints", b-a)
	self:networkSkillPoints()
end

function meta:attemptLearn(masterNear, rankedNear)
	local mod = 0
	if rankedNear then mod = 3 end
	
	local dc = 10
	
	local rng = math.random(1,20)
	local rng2 = math.random(1,20)
	
	if self:GetNW2String("team", "") == "Jedi" then
		dc = dc - 3
	end
	
	local die = rng
	
	if rankedNear then
		if rng2 > rng then die = rng2 end
	end
	
	if die+mod >= dc then
		self:NotifyLocalized("You have learned enough to gain an ability point. " .. die+mod .. " vs " .. dc)
		self:addSkillPoints(1)
		self:setVar("spentSkillPoints", self:getVar("spentSkillPoints", 0) + 1)
		--self:addLog("%s rolled a %s and gained an ability point.", {self:Nick(), tostring(die+mod)})
	else
		self:NotifyLocalized("You fail to learn, " .. die+mod .. " vs " .. dc)
		--self:addLog("%s rolled a %s and gained an ability point.", {self:Nick(), tostring(die+mod)})
	end
end

learnedCD = learnedCD or {}

function meta:learn()
	local totalLevel = self:getLevel("Force") +self:getLevel("Melee") + self:getLevel("Defense")
	local availableSkillPoints = math.floor(totalLevel/50) + 4
	
	if self:getVar("spentSkillPoints", 0) < availableSkillPoints then
		learnedCD[self:SteamID64()] = learnedCD[self:SteamID64()] or 0
		
		if learnedCD[self:SteamID64()] <= CurTime() then
			
			local highestRank = 0
			for k,v in pairs(ents.FindInSphere(self:GetPos(), 512)) do
				if v:IsPlayer() then
					if v ~= self then
						lts.ranks[v:GetNW2String("role", "")] = lts.ranks[v:GetNW2String("role", "")] or 0
						if highestRank < lts.ranks[v:GetNW2String("role", "")] then
							highestRank = lts.ranks[v:GetNW2String("role", "")]
						end
					end
				end
			end
			
			lts.ranks[self:GetNW2String("role", "")] = lts.ranks[self:GetNW2String("role", "")] or 0
			local rankedNear = lts.ranks[self:GetNW2String("role", "")] < highestRank
			
			self:attemptLearn(false, rankedNear)
			
			learnedCD[self:SteamID64()] = CurTime() + 3
		else
			self:NotifyLocalized("Your head hurts, you can learn in " .. math.Round(learnedCD[self:SteamID64()] - CurTime()) .. " seconds")
		end
		
	else
		self:NotifyLocalized("You have learned enough for your rank.")
	end
end



concommand.Add("lts.powerbar", function(ply, cmd, args)
	net.Start("lts.powerbar")
		net.WriteTable(ply:getPowers())
	net.Send(ply)
end)