local meta = FindMetaTable("Player")

util.AddNetworkString("lts.debuff.add")

-- Table to store resistances, debuffs, and their timers for each player
meta.resistances = meta.resistances or {}
meta.debuffs = meta.debuffs or {}

-- Helper function to initialize resistance and debuff tables
function meta:damageTypeSetup()
    self.resistances = {
        [DMG_GENERIC] = 0,
        [DMG_BURN] = 0,
        [DMG_BLAST] = 0,
        [DMG_SHOCK] = 0,
        [DMG_SONIC] = 0,
        [DMG_ENERGYBEAM] = 0,
        [DMG_DROWN] = 0,
        [DMG_NERVEGAS] = 0,
        [DMG_POISON] = 0,
        [DMG_RADIATION] = 0,
        [DMG_ACID] = 0,
        [DMG_SLOWBURN] = 0,
        [DMG_PLASMA] = 0,
        [DMG_DISSOLVE] = 0,
        [DMG_SLASH] = 0
    }

    self.debuffs = {
        [DMG_GENERIC] = 0,
        [DMG_BURN] = 0,
        [DMG_BLAST] = 0,
        [DMG_SHOCK] = 0,
        [DMG_SONIC] = 0,
        [DMG_ENERGYBEAM] = 0, -- the force one.
        [DMG_DROWN] = 0,
        [DMG_NERVEGAS] = 0,
        [DMG_POISON] = 0,
        [DMG_RADIATION] = 0,
        [DMG_ACID] = 0,
        [DMG_SLOWBURN] = 0,
        [DMG_PLASMA] = 0,
        [DMG_DISSOLVE] = 0,
        [DMG_SLASH] = 0
    }
end

-- Add resistance with duration
function meta:addResistance(dmgType, amount, duration)
    self.resistances[dmgType] = (self.resistances[dmgType] or 0) + amount

    if duration > 0 then
        timer.Create("resistance_timer_" .. self:EntIndex() .. "_" .. dmgType, duration, 1, function()
            if IsValid(self) then
                self:purgeResistance(dmgType)
            end
        end)
    end
end

local debuffMessage = {
	[DMG_GENERIC] = "% Generic Damage Received",
	[DMG_BURN] =  "% Burn Damage Received",
	[DMG_BLAST] =  "% Blast Damage Received",
	[DMG_SHOCK] =  "% Shock Damage Received",
	[DMG_SONIC] = "% Sonic Damage Received",
	[DMG_ENERGYBEAM] = "% Force Damage Received", -- the force one.
	[DMG_DROWN] = "% Drown Damage Received",
	[DMG_NERVEGAS] = "% Nerve Damage Received",
	[DMG_POISON] = "% Poison Damage Received",
	[DMG_RADIATION] = "% Radiation Damage Received",
	[DMG_ACID] = "% Acid Damage Received",
	[DMG_SLOWBURN] = "% Exposure Damage Received",
	[DMG_PLASMA] = "% Plasma Damage Received",
	[DMG_DISSOLVE] = "% Dissolve Damage Received",
	[DMG_SLASH] = "% Lightsaber Damage Received",
}


-- Add debuff with duration
function meta:addDebuff(dmgType, amount, duration)
    self.debuffs[dmgType] = (self.debuffs[dmgType] or 0) + amount
	
	net.Start("lts.debuff.add")
		net.WriteString("+"..amount.." ".. debuffMessage[dmgType] .. "("..durations.."s)")
		net.WriteInt(duration,32)
	net.Send(self)
	
    if duration > 0 then
        timer.Create("debuff_timer_" .. self:EntIndex() .. "_" .. dmgType, duration, 1, function()
            if IsValid(self) then
                self:purgeDebuff(dmgType)
            end
        end)
    end
end

-- Purge specific damage type resistances
function meta:purgeResistance(dmgType)
    self.resistances[dmgType] = 0
    timer.Remove("resistance_timer_" .. self:EntIndex() .. "_" .. dmgType)
end

-- Purge specific damage type debuffs
function meta:purgeDebuff(dmgType)
    self.debuffs[dmgType] = 0
    timer.Remove("debuff_timer_" .. self:EntIndex() .. "_" .. dmgType)
end

-- Purge all resistances
function meta:purgeAllResistances()
    for dmgType, _ in pairs(self.resistances) do
        self:purgeResistance(dmgType)
    end
end

-- Purge all debuffs
function meta:purgeAllDebuffs()
    for dmgType, _ in pairs(self.debuffs) do
        self:purgeDebuff(dmgType)
    end
end

-- Apply single damage (with resistance and debuff adjustments)
function meta:applySingleDamage(attacker, dmgAmount, dmgType)
    if not IsValid(self) or not self:Alive() then return end

    local resistance = self.resistances[dmgType] or 0
    local debuff = self.debuffs[dmgType] or 0

    local adjustedDamage = dmgAmount * (1 - resistance / 100) * (1 + debuff / 100)

    local dmginfo = DamageInfo()
    dmginfo:SetDamage(adjustedDamage)
    dmginfo:SetAttacker(attacker or game.GetWorld())
    dmginfo:SetInflictor(attacker or game.GetWorld())
    dmginfo:SetDamageType(dmgType)

    self:TakeDamageInfo(dmginfo)
end

-- Apply DOT (Damage Over Time) (with resistance and debuff adjustments)
function meta:applyDoT(attacker, totalDamage, duration, interval, dmgType)
    if not IsValid(self) or not self:Alive() then return end

    local damagePerTick = totalDamage / (duration / interval)
    local ticks = 0
	local seed = math.random(111111111,999999999)
    timer.Create("DoT_" .. self:EntIndex() .. "_" .. dmgType .. seed, interval, duration / interval, function()
        if not IsValid(self) or not self:Alive() then
            timer.Remove("DoT_" .. self:EntIndex() .. "_" .. dmgType .. seed)
            return
        end

        local resistance = self.resistances[dmgType] or 0
        local debuff = self.debuffs[dmgType] or 0

        local adjustedDamage = damagePerTick * (1 - resistance / 100) * (1 + debuff / 100)

        local dmginfo = DamageInfo()
        dmginfo:SetDamage(adjustedDamage)
        dmginfo:SetAttacker(attacker or game.GetWorld())
        dmginfo:SetInflictor(attacker or game.GetWorld())
        dmginfo:SetDamageType(dmgType)

        self:TakeDamageInfo(dmginfo)
        ticks = ticks + 1

        if ticks >= duration / interval then
            timer.Remove("DoT_" .. self:EntIndex() .. "_" .. dmgType)
        end
    end)
end

-- Purge specific damage type DOT
function meta:purgeDoT(dmgType)
    timer.Remove("DoT_" .. self:EntIndex() .. "_" .. dmgType)
end

-- Purge all DOTs
function meta:purgeAllDoTs()
    for dmgType, _ in pairs(self.resistances) do
        timer.Remove("DoT_" .. self:EntIndex() .. "_" .. dmgType)
    end
end

-- Generic Damage
function meta:genericDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_GENERIC)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_GENERIC)
    end
end

-- Burn Damage
function meta:burnDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_BURN)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_BURN)
    end
end

-- Blast Damage
function meta:blastDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_BLAST)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_BLAST)
    end
end

-- Shock Damage
function meta:shockDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_SHOCK)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_SHOCK)
    end
end

-- Sonic Damage
function meta:sonicDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_SONIC)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_SONIC)
    end
end

-- Energy Beam Damage
function meta:energyBeamDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_ENERGYBEAM)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_ENERGYBEAM)
    end
end

-- Drown Damage
function meta:drownDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_DROWN)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_DROWN)
    end
end

-- Nerve Gas Damage
function meta:nerveGasDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_NERVEGAS)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_NERVEGAS)
    end
end

-- Poison Damage
function meta:poisonDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_POISON)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_POISON)
    end
end

-- Radiation Damage
function meta:radiationDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_RADIATION)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_RADIATION)
    end
end

-- Acid Damage
function meta:acidDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_ACID)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_ACID)
    end
end

-- Slow Burn Damage
function meta:slowBurnDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_SLOWBURN)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_SLOWBURN)
    end
end

-- Plasma Damage
function meta:plasmaDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_PLASMA)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_PLASMA)
    end
end

-- Dissolve Damage
function meta:dissolveDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_DISSOLVE)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_DISSOLVE)
    end
end

-- Saber Damage
function meta:saberDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_SLASH)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_SLASH)
    end
end

-- Usage Example:
-- ply:burnDamage(100, 0, attacker) -- 100 burn damage as single instance
-- ply:addResistance(DMG_BURN, 50, 4) -- Add 50% burn resistance for 4 seconds
-- ply:addDebuff(DMG_BURN, 25, 4) -- Add 25% burn debuff for 4 seconds






























local meta = FindMetaTable("NPC")

meta.resistances = meta.resistances or {}
meta.debuffs = meta.debuffs or {}

function meta:damageTypeSetup()
    self.resistances = {
        [DMG_GENERIC] = 0,
        [DMG_BURN] = 0,
        [DMG_BLAST] = 0,
        [DMG_SHOCK] = 0,
        [DMG_SONIC] = 0,
        [DMG_ENERGYBEAM] = 0,
        [DMG_DROWN] = 0,
        [DMG_NERVEGAS] = 0,
        [DMG_POISON] = 0,
        [DMG_RADIATION] = 0,
        [DMG_ACID] = 0,
        [DMG_SLOWBURN] = 0,
        [DMG_PLASMA] = 0,
        [DMG_DISSOLVE] = 0,
        [DMG_SLASH] = 0
    }

    self.debuffs = {
        [DMG_GENERIC] = 0,
        [DMG_BURN] = 0,
        [DMG_BLAST] = 0,
        [DMG_SHOCK] = 0,
        [DMG_SONIC] = 0,
        [DMG_ENERGYBEAM] = 0, -- the force one.
        [DMG_DROWN] = 0,
        [DMG_NERVEGAS] = 0,
        [DMG_POISON] = 0,
        [DMG_RADIATION] = 0,
        [DMG_ACID] = 0,
        [DMG_SLOWBURN] = 0,
        [DMG_PLASMA] = 0,
        [DMG_DISSOLVE] = 0,
        [DMG_SLASH] = 0
    }
end

-- Add resistance with duration
function meta:addResistance(dmgType, amount, duration)
    self.resistances[dmgType] = (self.resistances[dmgType] or 0) + amount

    if duration > 0 then
        timer.Create("resistance_timer_" .. self:EntIndex() .. "_" .. dmgType, duration, 1, function()
            if IsValid(self) then
                self:purgeResistance(dmgType)
            end
        end)
    end
end

local debuffMessage = {
	[DMG_GENERIC] = "% Generic Damage Received",
	[DMG_BURN] =  "% Burn Damage Received",
	[DMG_BLAST] =  "% Blast Damage Received",
	[DMG_SHOCK] =  "% Shock Damage Received",
	[DMG_SONIC] = "% Sonic Damage Received",
	[DMG_ENERGYBEAM] = "% Force Damage Received", -- the force one.
	[DMG_DROWN] = "% Drown Damage Received",
	[DMG_NERVEGAS] = "% Nerve Damage Received",
	[DMG_POISON] = "% Poison Damage Received",
	[DMG_RADIATION] = "% Radiation Damage Received",
	[DMG_ACID] = "% Acid Damage Received",
	[DMG_SLOWBURN] = "% Exposure Damage Received",
	[DMG_PLASMA] = "% Plasma Damage Received",
	[DMG_DISSOLVE] = "% Dissolve Damage Received",
	[DMG_SLASH] = "% Lightsaber Damage Received",
}


-- Add debuff with duration
function meta:addDebuff(dmgType, amount, duration)
    self.debuffs[dmgType] = (self.debuffs[dmgType] or 0) + amount
	
	net.Start("lts.debuff.add")
		net.WriteString("+"..amount.." ".. debuffMessage[dmgType] .. "("..durations.."s)")
		net.WriteInt(duration,32)
	net.Send(self)
	
    if duration > 0 then
        timer.Create("debuff_timer_" .. self:EntIndex() .. "_" .. dmgType, duration, 1, function()
            if IsValid(self) then
                self:purgeDebuff(dmgType)
            end
        end)
    end
end

-- Purge specific damage type resistances
function meta:purgeResistance(dmgType)
    self.resistances[dmgType] = 0
    timer.Remove("resistance_timer_" .. self:EntIndex() .. "_" .. dmgType)
end

-- Purge specific damage type debuffs
function meta:purgeDebuff(dmgType)
    self.debuffs[dmgType] = 0
    timer.Remove("debuff_timer_" .. self:EntIndex() .. "_" .. dmgType)
end

-- Purge all resistances
function meta:purgeAllResistances()
    for dmgType, _ in pairs(self.resistances) do
        self:purgeResistance(dmgType)
    end
end

-- Purge all debuffs
function meta:purgeAllDebuffs()
    for dmgType, _ in pairs(self.debuffs) do
        self:purgeDebuff(dmgType)
    end
end


-- Apply single damage (with resistance and debuff adjustments)
function meta:applySingleDamage(attacker, dmgAmount, dmgType)
    if not IsValid(self) then return end

    local resistance = self.resistances[dmgType] or 0
    local debuff = self.debuffs[dmgType] or 0

    local adjustedDamage = dmgAmount * (1 - resistance / 100) * (1 + debuff / 100)

    local dmginfo = DamageInfo()
    dmginfo:SetDamage(adjustedDamage)
    dmginfo:SetAttacker(attacker or game.GetWorld())
    dmginfo:SetInflictor(attacker or game.GetWorld())
    dmginfo:SetDamageType(dmgType)

    self:TakeDamageInfo(dmginfo)
end

-- Apply DOT (Damage Over Time) (with resistance and debuff adjustments)
function meta:applyDoT(attacker, totalDamage, duration, interval, dmgType)
    if not IsValid(self) then return end

    local damagePerTick = totalDamage / (duration / interval)
    local ticks = 0
	
	local seed = math.random(111111111,999999999)
    timer.Create("DoT_" .. self:EntIndex() .. "_" .. dmgType .. seed, interval, duration / interval, function()
        if not IsValid(self) then
            timer.Remove("DoT_" .. self:EntIndex() .. "_" .. dmgType .. seed)
            return
        end

        local resistance = self.resistances[dmgType] or 0
        local debuff = self.debuffs[dmgType] or 0

        local adjustedDamage = damagePerTick * (1 - resistance / 100) * (1 + debuff / 100)

        local dmginfo = DamageInfo()
        dmginfo:SetDamage(adjustedDamage)
        dmginfo:SetAttacker(attacker or game.GetWorld())
        dmginfo:SetInflictor(attacker or game.GetWorld())
        dmginfo:SetDamageType(dmgType)

        self:TakeDamageInfo(dmginfo)
        ticks = ticks + 1

        if ticks >= duration / interval then
            timer.Remove("DoT_" .. self:EntIndex() .. "_" .. dmgType)
        end
    end)
end

-- Purge specific damage type DOT
function meta:purgeDoT(dmgType)
    timer.Remove("DoT_" .. self:EntIndex() .. "_" .. dmgType)
end

-- Purge all DOTs
function meta:purgeAllDoTs()
    for dmgType, _ in pairs(self.resistances) do
        timer.Remove("DoT_" .. self:EntIndex() .. "_" .. dmgType)
    end
end

-- Generic Damage
function meta:genericDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_GENERIC)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_GENERIC)
    end
end

-- Burn Damage
function meta:burnDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_BURN)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_BURN)
    end
end

-- Blast Damage
function meta:blastDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_BLAST)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_BLAST)
    end
end

-- Shock Damage
function meta:shockDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_SHOCK)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_SHOCK)
    end
end

-- Sonic Damage
function meta:sonicDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_SONIC)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_SONIC)
    end
end

-- Energy Beam Damage
function meta:energyBeamDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_ENERGYBEAM)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_ENERGYBEAM)
    end
end

-- Drown Damage
function meta:drownDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_DROWN)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_DROWN)
    end
end

-- Nerve Gas Damage
function meta:nerveGasDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_NERVEGAS)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_NERVEGAS)
    end
end

-- Poison Damage
function meta:poisonDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_POISON)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_POISON)
    end
end

-- Radiation Damage
function meta:radiationDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_RADIATION)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_RADIATION)
    end
end

-- Acid Damage
function meta:acidDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_ACID)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_ACID)
    end
end

-- Slow Burn Damage
function meta:slowBurnDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_SLOWBURN)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_SLOWBURN)
    end
end

-- Plasma Damage
function meta:plasmaDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_PLASMA)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_PLASMA)
    end
end

-- Dissolve Damage
function meta:dissolveDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_DISSOLVE)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_DISSOLVE)
    end
end

-- Saber Damage
function meta:saberDamage(amount, time, attacker)
    if time == 0 then
        self:applySingleDamage(attacker, amount, DMG_SLASH)
    else
        self:applyDoT(attacker, amount, time, 1, DMG_SLASH)
    end
end

-- Usage Example:
-- ply:burnDamage(100, 0, attacker) -- 100 burn damage as single instance
-- ply:addResistance(DMG_BURN, 50, 4) -- Add 50% burn resistance for 4 seconds
-- ply:addDebuff(DMG_BURN, 25, 4) -- Add 25% burn debuff for 4 seconds
