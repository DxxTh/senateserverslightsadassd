util.AddNetworkString("lts.kick")

local meta = FindMetaTable("Player")

local kickables = {}

kickables["player"] = true
kickables["prop_physics"] = true

function meta:isKicking()
	self.kicking2 = self.kicking2 or 0
	return self.kicking2 >= CurTime()
end


net.Receive("lts.kick", function(len, ply)
	ply.lastKick = ply.lastKick or 0
	if ply.lastKick <= CurTime() and not ply:isStunned() and ply:hasStamina(5) then
		ply:anim("wos_bs_shared_kick", 1, 1)
		ply:takeStamina(5)
		ply:addSlow(1,0.6)
		ply.kicking2 = CurTime() + 1
		timer.Simple(0.5, function()
			local bone = ply:LookupBone("ValveBiped.Bip01_L_Foot")
			local pos, ang = ply:GetBonePosition(bone)
			
			for k,v in pairs(ents.FindInSphere(pos, 32)) do
				if v ~= ply then
					if kickables[v:GetClass()] then
						v:GetPhysicsObject():AddVelocity(ply:GetForward() * 250 + Vector(0,0,100))
						if v:IsPlayer() then
							local wep = v:GetActiveWeapon()
							if wep:GetClass() == "tyler_saber" then
								if v.blocking then
									ply:anim("wos_bs_shared_kick", 1, 0)
									--ply:addSlow(1,0.1)
									
									v:addStun(1.5)
									ply.kicking2 = 0
									ply:addLog("POWERKICK", "%s has power kicked %s breaking their block.", {ply:Nick(), v:Nick()})
									v:addLog("POWERKICK_RECIEVED", "%s was power kicked %s and their block was broken.", {v:Nick(), ply:Nick()})
								else
									v:addLog("POWERKICK_RECIEVED", "%s was kicked by %s.", {v:Nick(), ply:Nick()})
									ply:addLog("POWERKICK", "%s has power kicked %s.", {ply:Nick(), v:Nick()})
									ply:addSlow(1,0.5)
								end
							
								v.blocking = false
								v.attackTime = 0
								v.blockTime = 0
								v:addStun(1)
								v:addSlow(1, 1)
							end
							local anim = table.Random({"b_reaction_upper", "b_reaction_upper_left", "b_reaction_right"})
							v:anim(anim, 1, 1)
						end
					end
				end
			end
		end)
		ply:addXP("Melee", math.random(1,5))
		ply.lastKick = CurTime() + 2
	end
end)