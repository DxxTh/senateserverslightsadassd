local meta = FindMetaTable("Player")
local killed = false
local fallingTranslation = {}

fallingTranslation["pistol"] = "swimming_pistol"
fallingTranslation["smg"] = "swimming_smg1"
fallingTranslation["grenade"] = "swimming_grenade"
fallingTranslation["ar2"] = "swimming_ar2"
fallingTranslation["shotgun"] = "swimming_shotgun"
fallingTranslation["rpg"] = "swimming_rpg"
fallingTranslation["physgun"] = "swimming_gravgun"
fallingTranslation["crossbow"] = "swimming_crossbow"
fallingTranslation["melee"] = "swimming_melee"
fallingTranslation["slam"] = "swimming_slam"
fallingTranslation["normal"] = "swimming_all"
fallingTranslation["fist"] = "swimming_fist"
fallingTranslation["melee2"] = "swimming_melee2"
fallingTranslation["passive"] = "swimming_all"
fallingTranslation["knife"] = "swimming_knife"
fallingTranslation["duel"] = "swimming_duel"
fallingTranslation["camera"] = "swimming_camera"
fallingTranslation["magic"] = "swimming_magic"
fallingTranslation["revolver"] = "swimming_revolver"

local ACT_TRANS = {}

function meta:id()
	return self:SteamID64()
end

function meta:killTime(id)
	timer.Destroy(id .. self:id())
end

function meta:endAnim()
	self:SetCycle(0) 
	self.customAnim = -1
	self.sequence = -1
	self.animTime = 0
	self.sequenceRate = 1
	self.override = false
	self.lastAnim = 0
	self:killTime("endTime")
	--self:anim(1,1,0)
end

function meta:makeTime(id,t)
	timer.Create(id .. self:id(), t, 1, function() self:endAnim(id) end)
end

function meta:isAnimating()
	self.lastAnim = self.lastAnim or 0
	return self.lastAnim >= CurTime()
end

function meta:smoothJumping()
	self.lastAnimJump = self.lastAnimJump or 0
	return self.lastAnimJump >= CurTime()
end

function meta:getAnimTime(s)
	return self:SequenceDuration(self:LookupSequence(s))
end

function overrideAnimation()
	function GAMEMODE:UpdateAnimation(ply, vel, speed)
		
		if killed then return end
		local l = vel:Length()
		local mv = 1
		
		if l > 0.2 then mv = l / speed end
		
		local r = math.min(mv, 1)
		
		local w = ply:WaterLevel()
		local g = ply:IsOnGround()
		
		if w >= 2 then
			r = math.min(r,0.6)
		elseif!g and l > 1000 then
			r = 0.15
		end
		
		ply:SetPlaybackRate(ply.sequenceRate or r)
		
		if CLIENT then
			GAMEMODE:GrabEarAnimation(ply)
			GAMEMODE:MouthMoveAnimation(ply) -- These are pretty boring
		end
		
		if (ply:InVehicle()) then
			local v = ply:GetVehicle()
			if CLIENT then
				local vv = v:GetVelocity()
				local f = v:GetUp()
				local d = f:Dot(Vector(0,0,1))
				ply:SetPoseParameter( "vertical_velocity", ( d < 0 and d or 0 ) + f:Dot(vv) * 0.004 )
			end
		end
	end
	
	local meta = FindMetaTable("Player")
	function meta:anim( s, r, t ) -- seq, rate, time
		--print(s)
		self:SetCycle(0)
		self.override = true
		if !s then
			if SERVER then
				self:endAnim()
			end
			return
		end
		
		
		self.animTime = CurTime() + t
		
		if !t then
			t = self:getAnimTime(s) - 0.15 -- Tinker with this.
		end
		
		if SERVER then
			self:killTime("endTime")
			self:networkAnim(s,r,t)
			if t > 0 then
				self:makeTime("endTime",t)
			end
		end
		
		
		self.lastAnim = CurTime() + t
		self.lastAnimJump = CurTime() + t + 0.1
		return t -- allows us to see how long we're going to play for.
	end

	function GAMEMODE:CalcMainActivity(ply, v)
		--if not IsValid(ply:GetActiveWeapon()) then return end
		
		local wep = ply:GetActiveWeapon()
		local len = v:Length2D()
		ply.animTime = ply.animTime or 0
		
		local plyTable = ply:GetTable()
		plyTable.CalcIdeal = ACT_MP_STAND_IDLE
		plyTable.CalcSeqOverride = -1

		self:HandlePlayerLanding( ply, v, plyTable.m_bWasOnGround )

		if !( self:HandlePlayerNoClipping( ply, v, plyTable ) ||
			self:HandlePlayerDriving( ply, plyTable ) ||
			self:HandlePlayerVaulting( ply, v, plyTable ) ||
			self:HandlePlayerJumping( ply, v, plyTable ) ||
			self:HandlePlayerSwimming( ply, v, plyTable ) ||
			self:HandlePlayerDucking( ply, v, plyTable ) ) then

			local len2d = v:Length2DSqr()
			if ( len2d > 22500 ) then plyTable.CalcIdeal = ACT_MP_RUN elseif ( len2d > 0.25 ) then plyTable.CalcIdeal = ACT_MP_WALK end

		end

		plyTable.m_bWasOnGround = ply:IsOnGround()
		plyTable.m_bWasNoclipping = ( ply:GetMoveType() == MOVETYPE_NOCLIP && !ply:InVehicle() )

		--return plyTable.CalcIdeal, plyTable.CalcSeqOverride

		
		ply.mode = ACT_MP_STAND_IDLE
		ply.sequence = -1
		
		local len = v:Length2D()
		if len > 155 then ply.mode = ACT_MP_RUN elseif len > 1 then ply.mode = ACT_MP_WALK end -- are we moving?
		
		local isGrounded = ply:IsOnGround()
	
		local ht = "knife"
	
	
		if IsValid(wep) then 
			ht = wep:GetHoldType() or "knife"
		end

		
		if ht == "normal" then ht = "knife" end
		if ht == "smg" then ht = "smg1" end
		
		if !isGrounded then
			
			if !(ply.hasSetJumpTime) then
				ply.jumpTime = CurTime() + 0.8
				ply.hasSetJumpTime = true
				ply.swimFall = false
			end
			
			if ply.jumpTime >= CurTime() then
				ply.sequence = ply:LookupSequence("jump_"..ht)
			else
				ply.swimFall = true
				ply.tickFrame = false
				
				if IsValid(wep) then
					local holdType = fallingTranslation[wep:GetHoldType()] or "swimming_all"
					ply.sequence = ply:LookupSequence(holdType)
				else
					ply.sequence = ply:LookupSequence("balanced_jump")
				end
				
			end
			--ply.sequence = ply:LookupSequence("balanced_jump")
			--ply.mode = 1001
		end
		
		if isGrounded then
			if ply.hasSetJumpTime then
				if ply.swimFall then
					ply.landTimer = CurTime() + 0.5
				else
					ply.landTimer = CurTime() + 0.2
				end
				
				ply.hasSetJumpTime = false
			end
			ply.landTimer = ply.landTimer or 0
			if ply.landTimer >= CurTime() then
				if ply.swimFall then
					if !(ply.tickFrame) then
						ply:SetCycle(0)
						if SERVER then ply.isRolling = CurTime() + 0.5 end
						ply.tickFrame = true
					end
				else
					ply.sequence = ply:LookupSequence("cwalk_"..ht)
				end
			end
		end
		
		if ply:Crouching() and isGrounded then
			ply.sequence = ply:LookupSequence("cwalk_"..ht)
			ply.mode = ACT_MP_CROUCHWALK
		end
		
		if !ply:InVehicle() and ply:GetMoveType() == MOVETYPE_NOCLIP then
			if ply:Crouching() then
				ply.sequence = ply:LookupSequence("sit_zen")
			else
				local wep = ply:GetActiveWeapon()
				if IsValid(wep) then
					local holdType = fallingTranslation[wep:GetHoldType()] or "swimming_all"
					ply.sequence = ply:LookupSequence(holdType)
				else
					ply.sequence = ply:LookupSequence("swimming_all")
				end
			end
		end
		
		if ply:InVehicle() then
			return ply.mode, ply:LookupSequence("sit")
		end
		
		
		local final = plyTable.CalcIdeal
		
		if ply.customAnim and ply.customAnim > -1 then ply.sequence = ply.customAnim end
		
		if ply.animTime <= CurTime() then
			ply.sequence = -1
		end
		
		
		--if ply:GetCycle() == 1 then ply.sequence = -1 end
		--return ply.mode, ply.sequence
		LAST_PRINT = LAST_PRINT or 0
		if plyTable.CalcIdeal ~= LAST_PRINT then
			LAST_PRINT = plyTable.CalcIdeal
			--``print(plyTable.CalcIdeal)
		end
		
		local set = {}
		
		set.judge = {
			idles = {
				up = "wos_judge_b_idle",
				left = "wos_judge_r_idle",
				right = "wos_judge_h_idle"
			},
			runs = {
				up = "wos_judge_b_run",
				left = "wos_judge_r_run",
				right = "run_melee2"
			}
		}
		
		set.phalanx = {
			idles = {
				up = "wos_phalanx_b_idle",
				left = "wos_phalanx_r_idle",
				right = "wos_phalanx_h_idle"
			},
			runs = {
				up = "wos_phalanx_b_run",
				left = "wos_phalanx_r_run",
				right = "wos_phalanx_h_run"
			}
		}
		
		
		set.ryoku = {
			idles = {
				up = "wos_ryoku_b_idle",
				left = "wos_ryoku_r_idle",
				right = "wos_ryoku_h_idle"
			},
			runs = {
				up = "wos_ryoku_b_run",
				left = "wos_ryoku_r_run",
				right = "wos_ryoku_h_run"
			}
		}
		
		local animSet = "judge"
		
		local formID = ply:GetNW2String("form", "Untrained")
		local form = lts.forms[formID]
		
		if ply.animTime < CurTime() then
			for p,j in pairs(ACT_TRANS) do
				if plyTable.CalcIdeal == p then
					if p == 996 or p == 997 then
						if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetNW2Bool("enabled") and len > 0 then
							if ply:GetNW2Int("stance", 1) == 2 then
								ply.sequence = ply:LookupSequence(form.runs.up)
							else
								if ply:GetNW2Int("stance", 1) == 3 then
									ply.sequence = ply:LookupSequence(form.runs.right)
								else
									ply.sequence = ply:LookupSequence(form.runs.left)
								end
							end
						else
							if len > 240 then
								ply.sequence = ply:LookupSequence("run_all_02")
							elseif len < 120 then
								ply.sequence = ply:LookupSequence("walk_"..ht)
							else
								ply.sequence = ply:LookupSequence("walk_"..ht)
							end
						end
					elseif p == 990 then
						if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetNW2Bool("enabled") then
							if ply:GetNW2Int("stance", 1) == 2 then
								ply.sequence = ply:LookupSequence(form.idles.up)
							else
								if ply:GetNW2Int("stance", 1) == 3 then
									ply.sequence = ply:LookupSequence(form.idles.right)
								else
									ply.sequence = ply:LookupSequence(form.idles.left)
								end
							end
						end
					else
						ply.sequence = ply:LookupSequence(j)
					end
					
				end
			end
		end
		
		
		return final, ply.sequence
	end
end

ACT_TRANS[1001] = "h_jump"
ACT_TRANS[997] = "sprint_human_01"
ACT_TRANS[996] = "wos_mma_sprint_all"
ACT_TRANS[990] = "wos_judge_h_idle"

net.Receive( "digital.chemistry.anim", function(len, ply)
	local ply = net.ReadEntity()
	local s = net.ReadString()
	local r = net.ReadFloat()
	local t = net.ReadFloat()
	ply:SetCycle(0) 
	ply.customAnim = ply:LookupSequence(s)
	ply.sequence = ply:LookupSequence(s)
	ply.animTime = CurTime() + t or 1
	ply.sequenceRate = r
	ply.override = true
end)




hook.Add("Think", "DetectLookingDirection", function()
    local threshold = 0.5
    
    for _, ply in ipairs(player.GetAll()) do
        if ply:IsValid() and ply:Alive() then
			if ply:KeyDown(IN_WALK) then
				-- Initialize the previous yaw if it doesn't exist
				if not ply.prevYaw then
					ply.prevYaw = ply:EyeAngles().yaw
				end

				-- Get the current yaw angle
				local currentYaw = ply:EyeAngles().yaw
				local yawDifference = currentYaw - ply.prevYaw

				-- Determine if the player is looking right or left with threshold
				if yawDifference > threshold then
					ply.lookingRight = true
				elseif yawDifference < -threshold then
					ply.lookingRight = false
				end
				
				ply.lookingUp = ply:EyeAngles().pitch <= 0
				
				if SERVER then
					if ply.lookingUp then
						ply:SetNW2Int("stance", 2)
					else
						if ply.lookingRight then
							ply:SetNW2Int("stance", 3)
						else
							ply:SetNW2Int("stance", 1)
						end
					end
				end
				
				-- Update the previous yaw for the next check
				ply.prevYaw = currentYaw
			end
        end
    end
end)

 -- NUTSCRIPT OVERRIDES, makes sure this shit loads even after updating server, takes ~60s.
hook.Add( "PostGamemodeLoaded", "fdgher6u465u46u", function() overrideAnimation() end) 										 -- NUTSCRIPT OVERRIDES.
local loadTime = 0																											 -- NUTSCRIPT OVERRIDES.
hook.Add("Think", "4290jk", function() if loadTime <= CurTime() then overrideAnimation() loadTime = CurTime() + 5 end end)  -- NUTSCRIPT OVERRIDES.

