lts.forcePowers = lts.forcePowers or {}
lts.protectedCode = lts.protectedCode or {}

local meta = FindMetaTable("Player")

local spammableRange = 128

function meta:injure(ply,amt)
	self:TakeDamage(amt,ply,ply:GetActiveWeapon())
end

function meta:createDust(radius, duration)
	local ply = self
    local dustEffect = EffectData()
    dustEffect:SetOrigin(ply:GetPos())
    dustEffect:SetRadius(radius)
    dustEffect:SetMagnitude(1)
    dustEffect:SetScale(1)

    -- Emit the dust effect repeatedly around the player for the given duration
    timer.Create("thumperDust_" .. ply:EntIndex(), 0.1, duration * 10, function()
        if IsValid(ply) then
            dustEffect:SetOrigin(ply:GetPos())
            util.Effect("ThumperDust", dustEffect)
        else
            timer.Remove("thumperDust_" .. ply:EntIndex())
        end
    end)
end

function meta:projectile(model, pos, lifeTime, riseTime, riseDist, speed, damage)
	local p = ents.Create("lts_projectile")
	
	p.model = model
	p.riseTime = CurTime() + riseTime
	p.riseDist = riseDist
	p.killTime = CurTime() + lifeTime
	p.speed = speed
	p.player = self
	p.damage = damage
	
	p:SetPos(pos)
	p:SetAngles(self:GetAngles())
	p:Spawn()
end
hook.Add("EntityTakeDamage", "RemoveProjectileCollisionDamage", function(target, dmginfo)
    local attacker = dmginfo:GetAttacker()
    if IsValid(attacker) and attacker:GetClass() == "lts_projectile" and dmginfo:IsDamageType(DMG_CRUSH) then
        dmginfo:SetDamage(0)
    end
end)

hook.Add("PhysicsCollide", "RemoveProjectilePhysicsCollisionDamage", function(data, collider)
    local hitEntity = data.HitEntity
    if IsValid(collider) and collider:GetClass() == "lts_projectile" then
        return
    end
end)