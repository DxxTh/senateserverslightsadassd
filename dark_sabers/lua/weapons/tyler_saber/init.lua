AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function SWEP:PrimaryAttack()
	
end

function SWEP:SecondaryAttack()
	
end

function SWEP:Initialize()
	self:SetWeaponHoldType( "normal" )
	self:SetHoldType( "normal" )
end

function SWEP:Reload()
	local ply = self.Owner
	self.lastReload = self.lastReload or 0
	if self.lastReload <= CurTime() then
		local ply = self.Owner
		self.ignited = self.ignited or self:GetNW2Bool("enabled")
		local ignites = {
			{
				anim = "wos_bs_shared_taunt_balanced",
				len = 1.75,
				delay = 1.25,
			},
			{
				anim = "wos_bs_shared_taunt_heavy",
				len = 1.75,
				delay = 0.6,
			},
		}
		
		if not self.ignited then
			if ply:KeyDown(IN_SPEED) then
			ply:addSlow(25, 1)
			local ignite = table.Random(ignites)
				ply:anim(ignite.anim, 1, ignite.len)
				timer.Simple(ignite.delay, function()
					self:SetWeaponHoldType( "melee2" )
					self:SetHoldType( "melee2" )
					ply:EmitSound("hfg/weapons/saber/saberon.mp3")
					self:SetNW2Bool("enabled", not self:GetNW2Bool("enabled"))
				end)
			else
				self:SetWeaponHoldType( "melee2" )
				self:SetHoldType( "melee2" )
				ply:EmitSound("hfg/weapons/saber/saberon.mp3")
				self:SetNW2Bool("enabled", not self:GetNW2Bool("enabled"))
			end
			self.ignited = true
		else
			self:SetWeaponHoldType( "normal" )
			self:SetHoldType( "normal" )
			ply:EmitSound("hfg/weapons/saber/saberoffquick.mp3")
			ply:StopSound("hfg/weapons/saber/saberhum1.wav")
		
			self:SetNW2Bool("enabled", not self:GetNW2Bool("enabled"))
			self.ignited = false
		end
		
		
		self.lastReload = CurTime() + 0.5
	end
end

function SWEP:Think()
	local ply = self.Owner
	self.targets = self.targets or {}
	
	local formID = "Form I: Shii-Cho"
	
	self.formID = self.formID or formID
	
	if ply:GetNW2String("form", "Untrained") ~= self.formID then
		ply:SetNW2String("form", self.formID)
	end
	
	if ply:KeyDown(IN_RELOAD) and ply:KeyDown(IN_ATTACK2) then
		--local a,f = table.Random(lts.forms)
		--ply:ChatPrint(f)
		--self.formID = f
		--ply:SetNW2String("form", self.formID)
	end
	
	local form = lts.forms[self.formID]
	
	self.hummer = self.hummer or 0
	self.comboTimer = self.comboTimer or 0
	self.comboID = self.comboID or 1
	self.rollTimer = self.rollTimer or 0
	ply.startAttackTime = ply.startAttackTime or 0
	ply.startChargeTime = ply.startChargeTime or 0
	
	if self:GetNW2Bool("enabled") then
		if self.hummer <= CurTime() then
			ply:EmitSound("hfg/weapons/saber/saberhum1.wav")
			self.hummer = CurTime() + 1.5
		end
	end
	
	if self.comboTimer <= CurTime() then
		if self.comboID > 0 then
			self.comboID = 1
			ply:SetNW2Int("combo", self.comboID)
		end
	end
	
	if ply.needsLand and ply:IsOnGround() then
		ply.needsLand = false
	end
	
	ply.attackTime = ply.attackTime or 0
	--if ply:KeyDown(IN_SPEED) then return end
	
	ply.web = ply.web or 0
	if ply.web <= CurTime() then
		if not ply:OnGround() and ply:KeyDown(IN_SPEED) and not ply:isStunned() and not ply:isKicking() and ply:hasStamina(5) then
			-- Combat roll logic
			if self.rollTimer <= CurTime() and not ply:OnGround() and ply:KeyDown(IN_ATTACK) then
				local tr = util.TraceLine( {
					start = ply:EyePos(),
					endpos = ply:EyePos() + ply:GetAngles():Forward() * 64,
					filter = function() return false end
				})
				
				if tr.Hit then
					rollAnim = "wos_bs_shared_wallrun"
					rollTime = 1
					dir = Vector(0,0,350)
					
					timer.Simple(0.5, function()
						ply:anim("wos_bs_shared_wallflip", 1, rollTime)
						ply:SetVelocity(ply:GetForward() * -250 + Vector(0,0,350))
					end)
					ply:takeStamina(5)
					ply:anim(rollAnim, 1, rollTime)
					ply:SetVelocity(dir)
					ply.needsLand = false
					self.rollTimer = CurTime() + (rollTime * 2)
				end
			end
			
			
			
			
			if not ply.needsLand and self.rollTimer <= CurTime() and not ply:OnGround() and ply:KeyDown(IN_ATTACK) and not ply:isStunned() and not ply:isKicking() and ply:hasStamina(5) then
				local rollAnim
				local dir
				
				local rollTime = 0.5
				
				if ply:KeyDown(IN_FORWARD) then
					rollAnim = "wos_bs_shared_roll_forward"
					dir = ply:GetForward() * 250 + Vector(0,0,100)
				elseif ply:KeyDown(IN_BACK) then
					rollAnim = "wos_bs_shared_roll_back"
					dir = ply:GetForward() * -250 + Vector(0,0,100)
				elseif ply:KeyDown(IN_MOVELEFT) then
					rollAnim = "wos_bs_shared_roll_left"
					dir = ply:GetRight() * -250 + Vector(0,0,100)
				elseif ply:KeyDown(IN_MOVERIGHT) then
					rollAnim = "wos_bs_shared_roll_right"
					dir = ply:GetRight() * 250 + Vector(0,0,100)
				end
				
				local tr = util.TraceLine( {
					start = ply:EyePos(),
					endpos = ply:EyePos() + ply:GetAngles():Forward() * 48,
					filter = function() return false end
				})
				
				if rollAnim then
					ply:anim(rollAnim, 1, rollTime)
					ply:SetVelocity(dir)
					ply.needsLand = true
					self.rollTimer = CurTime() + (rollTime * 1.5)
					ply:takeStamina(5)
				end
			end
		end
	end
	
	if self.rollTimer <= CurTime() then
		if ply.attackTime >= CurTime() and CurTime() - ply.startAttackTime >= 0 and not ply:isStunned() and not ply:isKicking() then
			
			local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
			local pos, ang = self.Owner:GetBonePosition(bone or 0)
			pos = pos + ang:Forward() * 3 + ang:Up() * 2 + ang:Right() * 1.5
			
			local bladeID = 1
			
			local class = self.Owner:GetNW2String("subclass", "")
			
			local sideSplitter = 1

			if not self.bladeCount then
				self.bladeCount = 0
				if self:GetNW2String("legacyModel", "") ~= "" then
					for id, t in ipairs( self:GetAttachments() or {} ) do
						if string.match( t.name, "blade(%d+)" ) then
							self.bladeCount = self.bladeCount + 1
						end
					end
				end
			end
			
			if class == "Assassin" or class == "Shadow" then
				sideSplitter = 1
			else
				if self.bladeCount > 1 then
					sideSplitter = 0.5
				end
			end
			
	
			if self:GetNW2String("legacyModel", "") ~= "models/theo/theo.mdl" then sideSplitter = 1 end
			
			if self:GetNW2String("legacyModel", "") ~= "" then
				for id, t in ipairs( self:GetAttachments() or {} ) do
					bladeID = bladeID + 1
					if ( !string.match( t.name, "blade(%d+)" ) and !string.match( t.name, "quillon(%d+)" ) ) then continue end
					local bladeNum = string.match( t.name, "blade(%d+)" )
					
					if not bladeNum then bladeNum = 0 end
					
					local obj = self:LookupAttachment( "blade" .. bladeNum )
					local att = self:GetAttachment(obj)
					if (bladeNum and obj > 0 ) then
						local bladePos = att.Pos
						local bladeAng = att.Ang
						bladeAng:RotateAroundAxis(bladeAng:Right(), 90)
						
						local tar, hitPos, hitWorld, hitNormal = lts.bladeScan(self.Owner, self, bladePos, bladeAng, 38, self.Owner.freshAttack, bladeID)
						print(hitWorld)
						if IsValid(tar) then
							self.targets[tar] = self.targets[tar] or 0
							if self.targets[tar] <= CurTime() then
								local stance = ply:GetNW2Int("stance", 1)
								local tstance = tar:GetNW2Int("stance", 1)
								
								local shouldBlock = false
								
								self.comboID = self.comboID + 1
								if self.comboID >= 4 then
									self.comboID = 1
								end
								
								self.comboTimer = CurTime() + 5
								ply:SetNW2Int("combo", self.comboID)
								
								local damageScale = 1
								
								if tar:IsPlayer() then
									if tar:GetActiveWeapon():GetClass() == "tyler_saber" then
										damageScale = lts.item.list[tar:GetActiveWeapon():GetNW2String("crystalItem", "")].defense
										if tstance == stance and tar:GetActiveWeapon():GetNW2Bool("enabled") then
											tar:GetActiveWeapon().attackTime = tar:GetActiveWeapon().attackTime or 0
											if tar:GetActiveWeapon().attackTime >= CurTime() then
												shouldBlock = true
											else
												local rng = math.random(1,10)
												if rng >= 5 then
													shouldBlock = true
												end
											end
										end
									end
								end
								
								if shouldBlock then
									local anim = table.Random({"h_block", "b_block", "b_block_left"})
									tar:anim(anim, 1, 0.4)
									ply:anim(anim, 1, 0.4)
									
									tar.attackTime = CurTime() + 0.4
									ply.attackTime = CurTime() + 0.4
									
									ply.blockTime = CurTime() + 0.4
									ply.blocking = true
									
									local ed = EffectData()
									ed:SetOrigin(hitPos)
									util.Effect("ManhackSparks", ed)
									
									local bnc = "hfg/weapons/saber/saberbounce" .. math.random(1,3) .. ".mp3"
									tar:EmitSound(bnc)
									ply:EmitSound(bnc)
									
									tar.blockTime = CurTime() + 0.4
									tar.blocking = true
									ply:addXP("Defense", math.random(10,20))
									tar:addXP("Defense", math.random(10,20))
								else
									local charge = math.Clamp(math.abs(CurTime() - ply.startChargeTime),0,2)/2
									
									local crystal = lts.item.list[self:GetNW2String("crystalItem", "")].damage
									
									local stances = {}
									stances[1] = "a"
									stances[2] = "w"
									stances[3] = "d"
									
									local stance = ply:GetNW2Int("stance", 1)
									local dir = stances[stance]
									
									local tempid = self.comboID - 1
									if tempid == 0 then tempid = 3 end

									crystal = crystal * form.moves[dir][tempid].damage
									
									local chargeDamage = crystal * charge
									
									local total = math.Round(crystal+chargeDamage) + (ply:getLevel("Melee"))
									
									local eff = EffectData()
									eff:SetOrigin(hitPos)
									util.Effect("ManhackSparks", eff)
									ply:EmitSound("hfg/weapons/saber/saberhit" .. math.random(1,3) .. ".mp3")
									--print(crystal, chargeDamage, charge)
									ply:anim("run_knife2", 1, 0)
									self.targets[tar] = CurTime() + 0.75
									ply.attackTime = 0
									ply.startAttackTime = 0
									ply:addStamina(2)
									--tar:TakeDamage(total, ply, self)
									if tar:IsPlayer() or tar:IsNPC() then
										tar:saberDamage((total * damageScale) * sideSplitter, 0, ply)
									end
								end
							end
						else
							if hitWorld then
								local eff = EffectData()
								eff:SetOrigin(hitPos)
								util.Effect("ManhackSparks", eff)
								ply:EmitSound("hfg/weapons/saber/saberhit" .. math.random(1,3) .. ".mp3")
								ply:anim("run_knife2", 1, 0)
								ply.attackTime = 0
								ply.startAttackTime = 0
							end
						end
					end
				end
				self.Owner.freshAttack = false
			else
			/*
				local tar, hitPos = lts.bladeScan(self.Owner, self, pos, ang, 38, self.Owner.freshAttack)
				self.Owner.freshAttack = false
				
				if IsValid(tar) then
					self.targets[tar] = self.targets[tar] or 0
					if self.targets[tar] <= CurTime() then
						local stance = ply:GetNW2Int("stance", 1)
						local tstance = tar:GetNW2Int("stance", 1)
						
						local shouldBlock = false
						
						self.comboID = self.comboID + 1
						if self.comboID >= 4 then
							self.comboID = 1
						end
						
						self.comboTimer = CurTime() + 5
						ply:SetNW2Int("combo", self.comboID)
						
						if tar:IsPlayer() then
							if tstance == stance and tar:GetActiveWeapon():GetNW2Bool("enabled") then
								if tar:GetActiveWeapon():GetClass() == "tyler_saber" then
									tar:GetActiveWeapon().attackTime = tar:GetActiveWeapon().attackTime or 0
									if tar:GetActiveWeapon().attackTime >= CurTime() then
										shouldBlock = true
									else
										local rng = math.random(1,10)
										if rng >= 5 then
											shouldBlock = true
										end
									end
								end
							end
						end
						
						if shouldBlock then
							local anim = table.Random({"h_block", "b_block", "b_block_left"})
							tar:anim(anim, 1, 0.4)
							ply:anim(anim, 1, 0.4)
							
							tar.attackTime = CurTime() + 0.4
							ply.attackTime = CurTime() + 0.4
							
							ply.blockTime = CurTime() + 0.4
							ply.blocking = true
							
							local ed = EffectData()
							ed:SetOrigin(hitPos)
							util.Effect("ManhackSparks", ed)
							
							local bnc = "hfg/weapons/saber/saberbounce" .. math.random(1,3) .. ".mp3"
							tar:EmitSound(bnc)
							ply:EmitSound(bnc)
							
							tar.blockTime = CurTime() + 0.4
							tar.blocking = true
							ply:addXP("Defense", math.random(10,20))
							tar:addXP("Defense", math.random(10,20))
						else
							local charge = math.Clamp(math.abs(CurTime() - ply.startChargeTime),0,2)/2
							
							local crystal = lts.item.list[self:GetNW2String("crystalItem", "")].damage
							
							local stances = {}
							stances[1] = "a"
							stances[2] = "w"
							stances[3] = "d"
							
							local stance = ply:GetNW2Int("stance", 1)
							local dir = stances[stance]
							
							local tempid = self.comboID - 1
							if tempid == 0 then tempid = 3 end

							crystal = crystal * form.moves[dir][tempid].damage
							
							local chargeDamage = crystal * charge
							
							local total = math.Round(crystal+chargeDamage) + (ply:getLevel("Melee"))
							
							local eff = EffectData()
							eff:SetOrigin(hitPos)
							util.Effect("ManhackSparks", eff)
							ply:EmitSound("hfg/weapons/saber/saberhit" .. math.random(1,3) .. ".mp3")

							ply:anim("run_knife2", 1, 0)
							self.targets[tar] = CurTime() + 0.75
							ply.attackTime = 0
							ply.startAttackTime = 0
							ply:addStamina(2)
							--tar:TakeDamage(total, ply, self)
							tar:saberDamage(total, 0, ply)
						end
					end
				end
				*/
			end
		end
		
		if ply.charging and not ply:isStunned() and not ply:isKicking() then
			if not ply:KeyDown(IN_ATTACK) then
				local stances = {}
				stances[1] = "a"
				stances[2] = "w"
				stances[3] = "d"
				
				local stance = ply:GetNW2Int("stance", 1)
				local dir = stances[stance]
				local anm = form.moves[dir][self.comboID].anim.seq
				
				if not ply:IsOnGround() then
					anm = form.moves[dir][self.comboID].air.seq
				end
				
				local times = {}
				times[1] = 0
				times[2] = 0
				times[3] = 1
				
				local tt = 1 + times[self.comboID]
				--print("Combo:", self.comboID)
				ply:anim(anm, 0.8, tt)
				
				timer.Simple(0.24, function()
					ply:EmitSound("hfg/weapons/saber/saberhup" .. math.random(1,9) .. ".mp3")
				end)
				ply.fleetfoot = ply.fleetfoot or 0
				
				if ply.fleetfoot <= CurTime() then
					ply:addSlow(form.moves[dir][self.comboID].speed, 1)
				end
				
				ply.attackTime = CurTime() + tt
				ply.startAttackTime = CurTime()
				ply:takeStamina(2)
				ply.freshAttack = true
				ply.charging = false
			end
		end

		if ply:KeyDown(IN_ATTACK) and self:GetNW2Bool("enabled") and not ply.blocking and not ply:isStunned() and not ply:isKicking() then
			if ply.attackTime <= CurTime() then
				if not ply.charging then
					self.comboID = self.comboID or 1
					local stances = {}
					stances[1] = "a"
					stances[2] = "w"
					stances[3] = "d"
					
					local stance = ply:GetNW2Int("stance", 1)
					local dir = stances[stance]
					
					local anm = form.moves[dir][self.comboID].anim.charge
					
					if not ply:IsOnGround() then
						anm = form.moves[dir][self.comboID].air.charge
					end
					
					ply:anim(anm, 1, 99)
					
					ply.startChargeTime = CurTime()
					ply.charging = true
				end
			end
		end
		
		if ply.charging and ply.attackTime - CurTime() < -0.5 and ply:hasStamina(2) then
			ply:addSlow(1, 0.1)
			
			local attackTime = CurTime() - ply.startChargeTime
			self.comboTimer = CurTime() + 2
			
			ply.chargeDrain = ply.chargeDrain or 0
			if ply.chargeDrain <= CurTime() then
				 ply:hasStamina(2)
				ply.chargeDrain = CurTime() + 1
			end
			
			if attackTime >= 1 then
				if self.comboID == 1 then
					self.comboID = 2
					ply:SetNW2Int("combo", self.comboID)
				end
			end
			
			if attackTime >= 2 then
				if self.comboID <= 2 then
					self.comboID = 3
					ply:SetNW2Int("combo", self.comboID)
				end
			end
			
		end

		if ply:KeyDown(IN_ATTACK2) and self:GetNW2Bool("enabled") and ply.attackTime <= CurTime() and not ply:isStunned() and not ply:isKicking() and ply:hasStamina(2) then
			ply.blockTime = CurTime() + 0.25
			
			ply.charging = false
			ply.attackTime = 0
			
			ply.lastBlockWalk = ply.lastBlockWalk or 0
			
			ply.blockDrain = ply.blockDrain or 0
			if ply.blockDrain <= CurTime() then
				 ply:takeStamina(2)
				ply.blockDrain = CurTime() + 1
			end
			
			if ply.lastBlockWalk <= CurTime() then
				ply:anim("run_knife2", 1, 1)
				broadcastAlert("Lightsaber Blocking", {
					"Hold right-click to enter a defensive stance,",
					"reducing your movement speed to 75 as you",
					"focus on defense. While blocking, your stamina",
					"will gradually drain, but in return, you'll be",
					"protected from incoming lightsaber strikes",
					"and blaster fire."
				})
				ply.lastBlockWalk = CurTime() + 1
				ply:addSlow(50, 1)
			end
			
			self.Owner.blocking = true
			self:SetWeaponHoldType( "knife" )
			self:SetHoldType( "knife" )
		else
			if self.Owner.blocking then
				if self:GetNW2Bool("enabled") then
					self:SetWeaponHoldType( "melee2" )
					self:SetHoldType( "melee2" )
				else
					self:SetWeaponHoldType( "normal" )
					self:SetHoldType( "normal" )
				end
				self.Owner.blocking = false
			end
		end
	end
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	return true
end
