lts = lts or {}

local meta = FindMetaTable("Player")

util.AddNetworkString("lts.stamina")
util.AddNetworkString("lts.stamina.max")

function meta:getStamina()
    return self.staminaPool or 0
end

function meta:getMaxStamina()
    return self.maxStaminaPool or 0
end

function meta:hasStamina(a)
    return self:getStamina() >= a
end

function meta:setMaxStamina(a)
    net.Start("lts.stamina.max")
        net.WriteInt(a, 32)
    net.Send(self)
    self.maxStaminaPool = a
end

function meta:addStamina(a)
    self.staminaPool = self.staminaPool or 0
    self.maxStaminaPool = self.maxStaminaPool or 0
    self.staminaPool = math.Clamp(self.staminaPool + a, 0, self.maxStaminaPool)
    net.Start("lts.stamina")
        net.WriteInt(self.staminaPool, 32)
    net.Send(self)
end

function meta:takeStamina(a)
    self.staminaPool = self.staminaPool or 0
    self.maxStaminaPool = self.maxStaminaPool or 0
    self.staminaPool = math.Clamp(self.staminaPool - a, 0, self.maxStaminaPool)
    net.Start("lts.stamina")
        net.WriteInt(self.staminaPool, 32)
    net.Send(self)
	self.staminaRegen = CurTime() + 15
end

local tick = 0
hook.Add("Think", "StaminaAndForceRegen", function()
    if tick <= CurTime() then
        for _, ply in ipairs(player.GetAll()) do
            ply.staminaRegen = ply.staminaRegen or 0
            if ply.staminaRegen <= CurTime() then
                ply:addStamina(math.Round(ply:getMaxStamina() * 0.05))
            end

            ply.forceRegen = ply.forceRegen or 0
            if ply.forceRegen <= CurTime() then
				ply:addForce(math.Round(ply:getMaxForce() * 0.05))
			end
        end
        tick = CurTime() + 3
    end
end)