local meta = FindMetaTable("Player")

function meta:getAttackerDirection(a)
	return (self:GetPos() - a:GetPos()):Angle()
end

function meta:forceModifier()
	return 1
end

hook.Add("EntityTakeDamage", "2424", function(ply, d)
	ply.invulnerable = ply.invulnerable or 0
		
	if ply.invulnerable >= CurTime() then
		ply:sound("hfg/weapons/force/absorbhit.mp3")
		d:SetDamage(0)
	else
		if d:GetDamageType() == DMG_ENERGYBEAM then
			if IsValid(d:GetAttacker()) then
				if d:GetAttacker():IsPlayer() then
					local atk = d:GetAttacker()
					d:ScaleDamage(atk:forceModifier())
				end
			end
		end
		
		if d:GetDamageType() == DMG_BURN then
			d:ScaleDamage(5)
		end

		if ply:IsPlayer() then
			if ply.voidNextFallDamage then
				if d:IsDamageType(DMG_FALL) then
					d:SetDamage(0)
					ply.voidNextFallDamage = false
				end
			end
			ply.blockTime = ply.blockTime or 0
			if ply.blockTime >= CurTime() then
				if d:IsDamageType(DMG_SLASH) or d:IsDamageType(DMG_BULLET) then 
					local attackerDir = ply:getAttackerDirection(d:GetAttacker()).y -180
					local plyDir = ply:GetAngles().y
					
					local offset = plyDir - attackerDir
					local set = table.Random({"h", "r", "b"})
					local anim = "_block"
					
					if offset >= -20 and offset <= 20 then
						anim = set..anim
					else
						if offset < -20 then
							anim = set..anim .. "_left"
						else
							anim = set..anim .. "_right"
						end
					end
					
					ply:anim(anim, 1, 0.25)
					ply:damageNumber(0, false, false)
					d:SetDamage(0)
					ply:addXP("Defense", math.random(10,20))
					if d:GetAttacker():IsPlayer() then
						d:GetAttacker():addXP("Melee", math.random(10,20))
					end
				else
					local xpt = "Melee"
					
					if d:GetDamageType() == DMG_ENERGYBEAM then
						xpt = "Force"
					end
					
					ply:damageNumber(d:GetDamage(), false, false)
					d:GetAttacker():addXP(xpt, math.random(25,50))
				end
			end
		end
	end
end)