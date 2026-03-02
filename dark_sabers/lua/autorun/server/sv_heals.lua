local meta = FindMetaTable("Player")
util.AddNetworkString("lts.heal")

-- Add Healing
function meta:heal(healAmount, color)
    if not IsValid(self) or not self:Alive() then return end
	color = color or Color(0,255,0)
    local newHealth = math.min(self:Health() + healAmount, self:GetMaxHealth())
    self:SetHealth(newHealth)
	net.Start("lts.heal")
		net.WriteEntity(self)
		net.WriteVector(Vector(color.r, color.g, color.b))
	net.Broadcast()
end

-- Add Healing
function meta:repair(healAmount, color)
    if not IsValid(self) or not self:Alive() then return end
	color = color or Color(55,55,255)
    local newHealth = math.min(self:Armor() + healAmount, 1000)
    self:SetArmor(newHealth)
	net.Start("lts.heal")
		net.WriteEntity(self)
		net.WriteVector(Vector(color.r, color.g, color.b))
	net.Broadcast()
end

-- Apply Heal Over Time (HoT)
function meta:healOverTime(totalHeal, duration, interval, color)
    if not IsValid(self) or not self:Alive() then return end
	color = color or Color(0,255,0)

    local healPerTick = totalHeal / (duration / interval)
    local ticks = 0

    timer.Create("HoT_" .. self:EntIndex(), interval, duration / interval, function()
        if not IsValid(self) or not self:Alive() then
            timer.Remove("HoT_" .. self:EntIndex())
            return
        end

        local newHealth = math.min(self:Health() + healPerTick, self:GetMaxHealth())
        self:SetHealth(newHealth)
		net.Start("lts.heal")
			net.WriteEntity(self)
		net.WriteVector(Vector(color.r, color.g, color.b))
		net.Broadcast()

        ticks = ticks + 1
        if ticks >= duration / interval then
            timer.Remove("HoT_" .. self:EntIndex())
        end
    end)
end

-- Purge Heal Over Time
function meta:purgeHoT()
    timer.Remove("HoT_" .. self:EntIndex())
end
