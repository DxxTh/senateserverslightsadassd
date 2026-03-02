hook.Add("OnPlayerHitGround", "CustomFallDamageAnim", function(ply, inWater, onFloater, speed)
	--ply:ChatPrint(speed)
    if not inWater and speed > 500 then
			ply:SetRunSpeed(1)
			ply:SetWalkSpeed(1)
        ply:anim("wos_bs_shared_kneeling", 1, 1)
		timer.Simple(0.8, function()
			ply:anim("wos_bs_shared_kneeling_recover", 1, 1)
		end)
		timer.Simple(1.8, function()
			ply:SetRunSpeed(300)
			ply:SetWalkSpeed(100)
		end)
        return true
    end
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
				
				if ply.lookingUp then
					ply:SetNW2Int("stance", 2)
				else
					if ply.lookingRight then
						ply:SetNW2Int("stance", 3)
					else
						ply:SetNW2Int("stance", 1)
					end
				end
				
				-- Update the previous yaw for the next check
				ply.prevYaw = currentYaw
			end
        end
    end
end)