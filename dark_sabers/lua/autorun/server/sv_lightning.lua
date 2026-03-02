util.AddNetworkString("lts.lightning")
util.AddNetworkString("lts.lightning.advanced")

local meta = FindMetaTable("Player")
local meta2 = FindMetaTable("NPC")

-- make this a function
/*
t.s = ply:GetPos()
t.e = e:GetPos() + Vector(0,0,9)
t.x = 10
t.m = "cable/redlaser"
t.l = 0.1
t.c = Color(166, 12, 12)

net.Start("lts.lightning")
    net.WriteTable(t)
net.Broadcast()
*/

-- castLightning(pos, tr.HitPos, 10, "cable/blue_elec", 0.1, Color(222,255,254))

function castLightning(startPos, endPos, thickness, material, lifeTime, color)
    local t = {
        s = startPos,
        e = endPos,
        x = thickness,
        m = material,
        l = lifeTime,
        c = color
    }

    net.Start("lts.lightning")
		net.WriteTable(t)
    net.Broadcast()
end



function advancedLightning(vecs, thickness, material, lifeTime, color)
    local t = {
        v = vecs,
        x = thickness,
        m = material,
        l = lifeTime,
        c = color
    }

    net.Start("lts.lightning.advanced")
		net.WriteTable(t)
    net.Broadcast()
end

function meta:chainLightning(caster, dist, hops, delay, dmg, png, color)
	if hops > 0 then
		timer.Simple(delay, function()
			for _,v in pairs(ents.FindInSphere(self:GetPos(), dist)) do
				if v:IsPlayer() or v:IsNPC() then
					if v ~= caster then
						v.lastChainHop = v.lastChainHop or 0
						if v.lastChainHop <= CurTime() then
							v:addStun(0.5)
							v:addSlow(1,0.5)
							v:anim("zombie_walk_03", 1, 0.5)
							castLightning(self:GetPos() + Vector(0,0,32), v:GetPos() + Vector(0,0,32), 6, png, 0.25, color)
							v:energyBeamDamage(dmg, 0, caster)
							v:chainLightning(caster, dist, hops-1, delay, dmg, png, color)
							v.lastChainHop = CurTime() + delay + 0.1
							break
						end
					end
				end
			end
		end)
	end
end

function meta2:chainLightning(caster, dist, hops, delay, dmg, png, color)
	if hops > 0 then
		timer.Simple(delay, function()
			for _,v in pairs(ents.FindInSphere(self:GetPos(), dist)) do
				if v:IsPlayer() or v:IsNPC() then
					if v ~= caster then
						v.lastChainHop = v.lastChainHop or 0
						if v.lastChainHop <= CurTime() then
							v:addStun(0.5)
							v:addSlow(1,0.5)
							v:anim("zombie_walk_03", 1, 0.5)
							castLightning(self:GetPos() + Vector(0,0,32), v:GetPos() + Vector(0,0,32), 6, png, 0.25, color)
							v:energyBeamDamage(dmg, 0, caster)
							v:chainLightning(caster, dist, hops-1, delay, dmg, png, color)
							v.lastChainHop = CurTime() + delay + 0.1
							break
						end
					end
				end
			end
		end)
	end
end


function targetRandomPos(target)
    local boneId = target:LookupBone("ValveBiped.Bip01_Spine")
    
    if not boneId then 
        -- If the bone isn't found, return an approximate position for a standard NPC/player hull size
        local approxPos = target:GetPos() + Vector(0, 0, 36) -- 36 is approximate height offset
        return approxPos + Vector(math.Rand(-16, 16), math.Rand(-16, 16), math.Rand(0, 72)) -- Approximate hull size
    end

    local hitboxSet = 0 -- Use the default hitbox set, adjust if needed
    local min, max = target:GetHitBoxBounds(hitboxSet, boneId)

    if not min or not max then
        -- If hitbox bounds aren't valid, return an approximate hull-based position
        local approxPos = target:GetPos()
        return approxPos + Vector(math.Rand(-16, 16), math.Rand(-16, 16), math.Rand(0, 72))
    end

    local randomPos = Vector(
        math.Rand(min.x, max.x),
        math.Rand(min.y, max.y),
        math.Rand(min.z, max.z)
    )

    local boneMatrix = target:GetBoneMatrix(boneId)
    if boneMatrix then
        randomPos = boneMatrix:GetTranslation() + randomPos
    end

    return randomPos
end

