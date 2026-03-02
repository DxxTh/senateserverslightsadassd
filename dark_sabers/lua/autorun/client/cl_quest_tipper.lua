local activeAlert = nil
local fadeInTime = 0.5
local displayTime = 8
local alpha = 0

net.Receive("BroadcastAlert", function()
    local title = net.ReadString()
    local text = net.ReadTable()
    --if not activeAlert then
		activeAlert = {
			title = title,
			text = text,
			startTime = SysTime(),
			material = lts.mat("materials/fenster/lila.png")
		}

		-- Reset alpha for fade-in effect
		alpha = 0
	--end
end)

hook.Add("HUDPaint", "DrawAlert", function()
    if not activeAlert then return end

    local elapsedTime = SysTime() - activeAlert.startTime
	
	local offsetX = ScrW()/2 - 515
	local offsetY = ScrH()/2
	
    -- Calculate alpha for fade-in and fade-out
    if elapsedTime <= fadeInTime then
        alpha = math.min(255, (elapsedTime / fadeInTime) * 255)
    elseif elapsedTime >= (fadeInTime + displayTime) then
        alpha = math.max(0, 255 - ((elapsedTime - fadeInTime - displayTime) / fadeInTime) * 255)
        if alpha == 0 then
            activeAlert = nil
            return
        end
    else
        alpha = 255
    end

    -- Draw the material
    local mat = activeAlert.material
    local w, h = ScrW(), ScrH()
    surface.SetDrawColor(255, 255, 255, alpha)
    surface.SetMaterial(mat)
    surface.DrawTexturedRect(offsetX, offsetY, 515, 485)

    -- Draw the title
    draw.SimpleText(activeAlert.title, "conthrax_22_blur", offsetX + 50, offsetY + 50 + 25, Color(255, 0, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

    draw.SimpleText(activeAlert.title, "conthrax_22", offsetX + 50, offsetY + 50 + 25, Color(255, 200, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

    -- Draw the text
    for k,v in pairs(activeAlert.text) do
		draw.SimpleText(v, "conthrax_14_blur", offsetX + 50 + 16, offsetY + 50 + 16 + 30 + (k*24), Color(0,0,0, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		draw.SimpleText(v, "conthrax_14", offsetX + 50 + 16, offsetY + 50 + 16 + 30 + (k*24), Color(255, 233, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	end
end)