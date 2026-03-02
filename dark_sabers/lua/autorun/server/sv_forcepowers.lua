lts = lts or {}

local meta = FindMetaTable("Player")

util.AddNetworkString("lts.force")
util.AddNetworkString("lts.pool")
util.AddNetworkString("lts.pool.max")
util.AddNetworkString("lts.power.swap")

util.AddNetworkString("lts.fear")
util.AddNetworkString("lts.ring")
util.AddNetworkString("lts.light")
util.AddNetworkString("lts.esp")
util.AddNetworkString("lts.blind")

net.Receive("lts.power.swap", function(len,ply)
	local slot = math.Clamp(net.ReadInt(8),0,LTS_MAX_FORCE_POWER)
	local pwr = net.ReadString()
	
	ply.powers = ply.powers or {}
	
	if pwr == "" then
		ply.powers[slot] = nil
	else
		if ply:hasPower(pwr) then
			if lts.forcePowers[pwr] then
				ply.powers[slot] = pwr
			else
				ply:NotifyLocalized("Power does not exist in this context!")
			end
		else
			ply:NotifyLocalized("You are not whitelisted for this power.")
		end
	end
end)

function meta:setPower(slot,power)
	self.powers = self.powers or {}
	self.powers[slot] = power
	net.Start("lts.force")
		net.WriteInt(slot,9)
		net.WriteString(power)
	net.Send(self)
end

function meta:grantPower(p)
	local a = self:getVar("forcePowers", {})
	a[p]=true
	self:setVar("forcePowers", a)
	--self:save()
end

function meta:takePower(p)
	local a = self:getVar("forcePowers", {})
	a[p]=false
	self:setVar("forcePowers", a)
	self:save()
end
function meta:resetPowers()
	self:setVar("forcePowers", {})
	self:save()
end

function meta:hasPower(p)
	local a = self:getVar("forcePowers", {})
	return a[p]
end

function meta:getPowers()
	local a = self:getVar("forcePowers", {})
	return a
end

function meta:getForce()
	return self.forcePool or 0
end

function meta:getMaxForce()
	return self.maxForcePool or 0
end

function meta:setMaxForce(a)
	net.Start("lts.pool.max")
		net.WriteInt(a,32)
	net.Send(self)
	self.maxForcePool = a
end

function meta:addForce(a)
	self.forcePool = self.forcePool or 0
	self.maxForcePool = self.maxForcePool or 0
	self.forcePool = math.Clamp(self.forcePool + a, 0, self.maxForcePool)
	net.Start("lts.pool")
		net.WriteInt(self.forcePool,32)
	net.Send(self)
end

function meta:takeForce(a)
	self.forcePool = self.forcePool or 0
	self.maxForcePool = self.maxForcePool or 0
	self.forcePool = math.Clamp(self.forcePool - a, 0, self.maxForcePool)
	net.Start("lts.pool")
		net.WriteInt(self.forcePool,32)
	net.Send(self)
	self.forceRegen = CurTime() + 15
end

util.AddNetworkString("lts.cooldown")
function meta:setCooldown(a,b)
	self.cooldowns[a] = CurTime() + b
	net.Start("lts.cooldown")
		net.WriteString(a)
		net.WriteInt(b, 32)
	net.Send(self)
end

function meta:getCooldown(a)
	return self.cooldowns[a] or 0
end

function meta:getCooldownRemaining(a)
	return math.Clamp(self:getCooldown(a) - CurTime(),0,9999)
end

hook.Add("Think", "4j80912", function(ply)
	for _,ply in pairs(player.GetAll()) do
		ply.hasCasted = ply.hasCasted or {}
		for pwr,t in pairs(ply.hasCasted) do
			if t <= CurTime() then
				local faction = ply:GetNWString("team", "")
				local forceLevel = ply:GetNWInt("forceLevel", 0)
				local saberLevel = ply:GetNWInt("saberLevel", 0)
				local defenseLevel = ply:GetNWInt("defenseLevel", 0)
				local power = lts.forcePowers[pwr]
				--power.done(ply, faction, forceLevel, saberLevel, defenseLevel)
				ply.hasCasted[pwr] = nil
			end
		end
	end
end)

local blacklistedPowers = {}

blacklistedPowers["Force Restore"] = true
blacklistedPowers["Battle Meditation"] = true
blacklistedPowers["Force Seethe"] = true

net.Receive("lts.force", function(len, ply)
	local slot = net.ReadInt(9)
	slot = math.Clamp(slot,1,LTS_MAX_FORCE_POWER)
	ply.hasCasted = ply.hasCasted or {}
	ply.powers = ply.powers or {}
	ply.cooldowns = ply.cooldowns or {}
	if ply:Alive() then
		if ply.powers[slot] then
			local pwr = ply.powers[slot]
			ply.cooldowns[pwr] = ply.cooldowns[pwr] or 0
			if ply.cooldowns[ply.powers[slot]] <= CurTime() then
				local power = lts.forcePowers[pwr]
				if power then
					if ply:getForce() >= power.cost then
						ply:takeForce(power.cost)
							
						local faction = ply:GetNWString("team", "")
						local forceLevel = ply:getLevel("Force")
						local saberLevel = ply:getLevel("Melee")
						local defenseLevel = ply:getLevel("Defense")
						
						power.func(ply, faction, forceLevel, saberLevel, defenseLevel)
						
						if not blacklistedPowers[power.name] then
							ply.antiChatSpam = ply.antiChatSpam or {}
							ply.antiChatSpam[power.name] = ply.antiChatSpam[power.name] or 0
							if ply.antiChatSpam[power.name] <= CurTime() then
								local plyColor = Color(100,100,0)
		
								local pcpc = {}
								pcpc["Sith"] = Color(200,0,0)
								pcpc["Jedi"] = Color(0,200,200)
								
								if pcpc[ply:GetNW2String("team", "")] then
									plyColor = pcpc[ply:GetNW2String("team", "")]
								end
							
								local messageTable = {Color(200, 100, 50), "* ", plyColor, ply:Nick(), Color(255, 255, 255), " casts " .. power.name}
								
								local targets = {}
								for _, player in ipairs(player.GetAll()) do
									if player:GetPos():Distance(ply:GetPos()) <= 300 then
										table.insert(targets, player)
									end
								end
								texting(targets, messageTable)
								ply.antiChatSpam[power.name] = CurTime() + 5
							end
						end
						
						ply:addLog("FORCEPOWER", "%s casted %s.", {ply:Nick(), pwr})
						
						ply:setCooldown(pwr,power.cooldown)
						ply.hasCasted[pwr] = CurTime() + power.cooldown + 0.25
						ply.cooldowns[pwr] = CurTime() + power.cooldown + 0.1
					end
				end
			end
		end
	end
end)

concommand.Add("lts.bones", function(ply, cmd, args)
	for i=0,ply:GetBoneCount() - 1 do
        ply:ChatPrint(i .. " - " .. ply:GetBoneName(i))
    end
end)