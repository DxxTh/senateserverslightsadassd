hook.Add("HUDShouldDraw", "HideDefaultHUD", function(name)
    local hudElements = {
        "CHudHealth",
        "CHudBattery",
        "CHudCrosshair",
        "CHudAmmo",
        "CHudSecondaryAmmo",
        "CHudWeaponSelection",
        "CHudDamageIndicator",
        "CHudSuitPower"
    }

    if table.HasValue(hudElements, name) then
        return false
    end
end)

local selectedWeaponIndex = 1
local weaponList = {}
local selecting = 0

local function UpdateWeaponList()
	weaponList = LocalPlayer():GetWeapons()
	if selectedWeaponIndex > #weaponList then
		selectedWeaponIndex = #weaponList
	elseif selectedWeaponIndex < 1 then
		selectedWeaponIndex = 1
	end
end

hook.Add("PlayerBindPress", "CustomWeaponSelector", function(ply, bind, pressed)
	if bind == "invnext" and pressed then
		selecting = CurTime() + 1
		selectedWeaponIndex = selectedWeaponIndex + 1
		if selectedWeaponIndex > #weaponList then
			selectedWeaponIndex = 1
		end
		return true
	elseif bind == "invprev" and pressed then
		selecting = CurTime() + 1
		selectedWeaponIndex = selectedWeaponIndex - 1
		if selectedWeaponIndex < 1 then
			selectedWeaponIndex = #weaponList
		end
		return true
	elseif bind == "+attack" and pressed and weaponList[selectedWeaponIndex] and selecting >= CurTime() then
		input.SelectWeapon(weaponList[selectedWeaponIndex])
		selecting = 0
		return true
	end
end)

hook.Add("HUDPaint", "CustomWeaponSelectorHUD", function()
	if selecting >= CurTime() then
		UpdateWeaponList()
		local x, y = ScrW() / 2, ScrH() - 100
		for i, weapon in ipairs(weaponList) do
			draw.SimpleText(
				weapon:GetPrintName(),
				"Default",
				x,
				y - (i * 20),
				i == selectedWeaponIndex and Color(255, 255, 0) or Color(255, 255, 255),
				TEXT_ALIGN_CENTER
			)
		end
	end
end)