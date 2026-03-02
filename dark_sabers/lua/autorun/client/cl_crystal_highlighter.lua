hook.Add("PreDrawHalos", "fdghgfhg", function()
	local ply = LocalPlayer()
	if IsValid(ply:GetActiveWeapon()) then
		if saberEditing then
			local crystal = ix.item.list[ply:GetActiveWeapon():GetNW2String("crystalItem", "")]
			if crystal then
				halo.Add({ply.kyber}, Color(crystal.color.r,crystal.color.g,crystal.color.b), 5, 5, 2 )
			end
		end
	end
end)