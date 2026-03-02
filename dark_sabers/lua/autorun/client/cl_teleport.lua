-- Client-side code
net.Receive("OpenTeleportMenu", function()
    local availablePlanets = net.ReadTable()

    -- Create the teleport menu
    local frame = vgui.Create("DFrame")
    frame:SetTitle("")
    frame:SetSize(744, 714)
    frame:Center()
    frame:MakePopup()
	
	function frame:Paint(w,h)
		surface.SetDrawColor(225,225,255,255)
		surface.SetMaterial(lts.mat("fenster/dawdat.png"))
		surface.DrawTexturedRect(0,0,w,h)
	end
	

    local planetList = vgui.Create("DListView", frame)
    planetList:SetSize(390,350)
    planetList:SetPos(215,180)
    planetList:AddColumn("Planets")

    for planetName, _ in pairs(availablePlanets) do
        planetList:AddLine(planetName)
    end

    planetList.OnRowSelected = function(lst, index, pnl)
        local selectedPlanet = pnl:GetColumnText(1)
        net.Start("StartTeleport")
        net.WriteString(selectedPlanet)
        net.SendToServer()
        frame:Close()
    end
end)

local teleportEndTime = 0

net.Receive("StartTeleportCountdown", function()
    local duration = net.ReadInt(32)
    teleportEndTime = CurTime() + duration

    hook.Add("HUDPaint", "TeleportCountdown", function()
        local timeLeft = math.max(0, teleportEndTime - CurTime())
        draw.SimpleText("Teleporting in " .. math.ceil(timeLeft) .. " seconds...", "DermaLarge", ScrW() / 2, ScrH() / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end)
end)

local function removeTeleportHUD()
    hook.Remove("HUDPaint", "TeleportCountdown")
    teleportEndTime = 0
end

net.Receive("TeleportCancelled", function()
    removeTeleportHUD()
end)

net.Receive("TeleportCompleted", function()
    removeTeleportHUD()
end)
