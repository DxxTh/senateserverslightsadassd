function headPos(ply)
    local headBone = ply:LookupBone("ValveBiped.Bip01_Head1") -- Look up the head bone
    if not headBone then return nil end  -- Return nil if the head bone isn't found

    local headPos, headAng = ply:GetBonePosition(headBone)  -- Get the position and angle of the head bone
    if not headPos then return nil end  -- Return nil if the head position isn't valid

    return headPos + Vector(0, 0, 16)  -- Add 8 units to the Z-axis (upward) of the head position
end

hook.Add("PostDrawTranslucentRenderables", "DrawDefenseModeIcons", function(ply)end)
hook.Add("PostDrawTranslucentRenderablesz", "DrawDefenseModeIcons", function(ply)
	for _,ply in pairs(player.GetAll()) do
		if not ply:Alive() then return end
		
		local offset = Vector(0, 0, 70)  -- Adjust this vector to change icon position
		local pos = headPos(ply)
		local ang = LocalPlayer():EyeAngles()
		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), 90)

		cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.1)
			local stance = ply:GetNWInt("stance", 1)
			if stance > 0 then
				local L = 55
				local R = 55
				local U = 55
				
				if stance == 3 then
					L = 255
				elseif stance == 2 then
					U = 255
				elseif stance == 1 then
					R = 255
				end
				
				
				surface.SetDrawColor(0, 0, 0, 255)
				surface.SetMaterial(lts.mat("icons/arrow-left-bold.png"))
				surface.DrawTexturedRect(-16 - 16 + 1, -16 + 1, 32, 32)
				
				surface.SetMaterial(lts.mat("icons/arrow_up.png"))
				surface.DrawTexturedRect(-16 + 1, -16 - 16 + 1, 32, 32)
				
				surface.SetMaterial(lts.mat("icons/arrow-right-bold.png"))
				surface.DrawTexturedRect(-16+16 + 1, -16 + 1, 32, 32)
				
				
				
				
				
				surface.SetMaterial(lts.mat("icons/arrow-left-bold.png"))
				surface.SetDrawColor(L, 75, 75, 255)
				surface.DrawTexturedRect(-16 - 16, -16, 32, 32)
				
				surface.SetMaterial(lts.mat("icons/arrow_up.png"))
				surface.SetDrawColor(U, 75, 75, 255)
				surface.DrawTexturedRect(-16, -16 - 16, 32, 32)
				
				surface.SetMaterial(lts.mat("icons/arrow-right-bold.png"))
				surface.SetDrawColor(R, 75, 75, 255)
				surface.DrawTexturedRect(-16+16, -16, 32, 32)
				
				
				
				local t1 = 55
				local t2 = 55
				local t3 = 55
				
				local combo = ply:GetNWBool("combo", 1)
				
				if combo >= 4 then combo = 1 end
				
				if combo >= 1 then
					t1 = 255
				end
				if combo >= 2 then
					t2 = 255
				end
				if combo >= 3 then
					t3 = 255
				end
				
				
				surface.SetMaterial(lts.mat("icons/lightning-bolt.png"))
				surface.SetDrawColor(t1, t1, 75, 255)
				surface.DrawTexturedRect(-16 - 16, -16 + 26, 32, 32)
				
				surface.SetMaterial(lts.mat("icons/lightning-bolt.png"))
				surface.SetDrawColor(t2, t2, 75, 255)
				surface.DrawTexturedRect(-16, -16 + 18, 32, 32)
				
				surface.SetMaterial(lts.mat("icons/lightning-bolt.png"))
				surface.SetDrawColor(t3, t3, 75, 255)
				surface.DrawTexturedRect(-16+16, -16 + 26, 32, 32)
			end
		cam.End3D2D()
	end
end)
