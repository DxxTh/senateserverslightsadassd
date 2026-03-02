function vinette()
	surface.SetDrawColor(0, 0, 0, 255)
	surface.SetMaterial(lts.mat("overlays/vignette"))
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
end

local barW = 300
local barH = 20
local barO = 5

function healthBar()
	local ply = LocalPlayer()
	local a = ply:Health()
	local b = ply:GetMaxHealth()
	
	local x = ScrW()/2 - barW - 5
	local y = ScrH() - 120
	
	local pos = 1
	local barSp = 10
	
	local perc = a/b
	
	local text = "(" .. a  .. "/" .. b .. ")"
	
	surface.SetDrawColor(100, 100, 100, 255)
	surface.SetMaterial(lts.mat("materials/lordtyler/hp_bar_under.png"))
	surface.DrawTexturedRect(x, y, barW, barH)
	
	surface.SetDrawColor(231, 76, 60, 255)
	surface.SetMaterial(lts.mat("materials/lordtyler/hp_bar.png"))
	surface.DrawTexturedRect(x, y, barW * perc, barH)
	
	draw.SimpleText( text, "proxima_12", x + barW/2, y + 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function armorBar()
	local ply = LocalPlayer()
	local a = ply:Armor()
	local b = 1000
	
	local pos = 2
	local barSp = 0
	
	local x = ScrW()/2 + 5
	local y = ScrH() - 120
	
	local perc = a/b
	
	local text = "(" .. a  .. "/" .. b .. ")"
	
	surface.SetDrawColor(100, 100, 100, 255)
	surface.SetMaterial(lts.mat("materials/lordtyler/hp_bar_under.png"))
	surface.DrawTexturedRect(x, y, barW, barH)
	
	surface.SetDrawColor(52, 152, 219, 255)
	surface.SetMaterial(lts.mat("materials/lordtyler/hp_bar.png"))
	surface.DrawTexturedRect(x, y, barW * perc, barH)
	
	draw.SimpleText( text, "proxima_12", x + barW/2, y + 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function staminaBar()
	local ply = LocalPlayer()
	local a = lts.staminaPool.cur
	local b = lts.staminaPool.max
	
	local pos = 3
	local barSp = 0
	
	local x = ScrW()/2 + 5
	local y = ScrH() - 120 - 22
	
	local perc = a/b
	
	local text = "(" .. a  .. "/" .. b .. ")"
	
	surface.SetDrawColor(100, 100, 100, 255)
	surface.SetMaterial(lts.mat("materials/lordtyler/hp_bar_under.png"))
	surface.DrawTexturedRect(x, y, barW, barH)
	
	surface.SetDrawColor(2043, 204, 46, 255)
	surface.SetMaterial(lts.mat("materials/lordtyler/hp_bar.png"))
	surface.DrawTexturedRect(x, y, barW * perc, barH)
	
	draw.SimpleText( text, "proxima_12", x + barW/2, y + 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function forceBar()
	local ply = LocalPlayer()
	local a = lts.forcePool.cur
	local b = lts.forcePool.max
	
	local pos = 4
	local barSp = 0
	
	local x = ScrW()/2 - barW - 5
	local y = ScrH() - 120 - 22
	
	local perc = a/b
	
	local text = "(" .. a  .. "/" .. b .. ")"
	
	surface.SetDrawColor(100, 100, 100, 255)
	surface.SetMaterial(lts.mat("materials/lordtyler/hp_bar_under.png"))
	surface.DrawTexturedRect(x, y, barW, barH)
	
	surface.SetDrawColor(155, 89, 182, 255)
	surface.SetMaterial(lts.mat("materials/lordtyler/hp_bar.png"))
	surface.DrawTexturedRect(x, y, barW * perc, barH)
	
	draw.SimpleText( text, "proxima_12", x + barW/2, y + 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function crosshair()
	local player = LocalPlayer()
    if not IsValid(player) or not player:Alive() then return end
	
    local trace = {}
    trace.start = player:GetShootPos()
    trace.endpos = trace.start + (player:GetAimVector() * 10000) -- Large distance for the trace
    trace.filter = player
    local tr = util.TraceLine(trace)
    local screenPos = tr.HitPos:ToScreen()
	
	local dis = tr.HitPos:Distance(player:GetPos())
	
	local size = 64
	local scale = math.Clamp(1.1-(dis/1024), 0.4, 1)
	
	size = size * scale
	
    --surface.DrawRect(screenPos.x - (lineThickness / 2), screenPos.y - lineLength, lineThickness, lineLength * 2)
    --surface.DrawRect(screenPos.x - lineLength, screenPos.y - (lineThickness / 2), lineLength * 2, lineThickness)
	texture(screenPos.x-(size/2), screenPos.y-(size/2), size, size, "crosshair")
end


local dir = "materials/lordtyler/hud/"

function mt(a)
	return lts.mat(dir..a..".png")
end

local localAvatar = nil

function avatar(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    local steamID64 = ply:SteamID64()
    if not steamID64 then return end

    http.Fetch("https://steamcommunity.com/profiles/" .. steamID64 .. "?xml=1", 
        function(body)
            local avatarURL = string.match(body, "<avatarFull><!%[CDATA%[(.-)%]%]></avatarFull>")
            if avatarURL then
                localAvatar  = avatarURL
            end
        end,
        function(error)
        end
    )
end
avatar(LocalPlayer())

function texture(x, y, w, h, m, percent)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(mt(m))

    if percent then
		percent = math.Clamp(percent,0,1)
        -- Adjust width according to the percentage
        local adjustedWidth = w * math.Clamp(percent, 0, 1)
        surface.DrawTexturedRectUV(x, y, adjustedWidth, h, 0, 0, percent, 1)
    else
        surface.DrawTexturedRect(x, y, w, h)
    end
end

function powericon(x, y, w, h, m, percent)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(lts.mat(m))

    if percent then
		percent = math.Clamp(percent,0,1)
        -- Adjust width according to the percentage
        local adjustedWidth = w * math.Clamp(percent, 0, 1)
        surface.DrawTexturedRectUV(x, y, adjustedWidth, h, 0, 0, percent, 1)
    else
        surface.DrawTexturedRect(x, y, w, h)
    end
end

local avatar, downloaded = ( Material("vgui/avatar_default") )

local bleed = 0
local bleeding = false

function rgb(frequency)
    local r = math.floor(math.sin(frequency * CurTime() + 0) * 127 + 128)
    local g = math.floor(math.sin(frequency * CurTime() + 2) * 127 + 128)
    local b = math.floor(math.sin(frequency * CurTime() + 4) * 127 + 128)
    return Color(r, g, b)
end

function testHUD()
    texture(0, ScrH() - 11, ScrW(), 11, "underbar")
	texture(25, 25, 301, 101, "userbar")
    texture(ScrW() / 2 - 987 / 2, ScrH() - 116, 987, 116, "powers")
	
	if not downloaded then
		downloaded = true
		-- NEVER call this every frame unless you are planning on DDoSing Steam.
		getAvatarMaterial(LocalPlayer():SteamID64(), function(mat)
			avatar = mat
		end)
	end
	
	if localAvatar then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(avatar)
		surface.DrawTexturedRect(39, 47, 56, 56)
    end
	
	local logoScale = 0.25
	
	if bleed >= 199 or bleed <= 1 then
		bleeding = !bleeding
	end
	
	if bleeding then
		bleed = Lerp(FrameTime()*2, bleed, 0)
	else
		bleed = Lerp(FrameTime()*2, bleed, 200)
	end
	
	local col = rgb(0.1)
	
	--surface.SetDrawColor(col.r, col.g, col.b, bleed)
   -- surface.SetMaterial(lts.mat("lordtyler/hud/hfg_dagger_blur.png"))
	--surface.DrawTexturedRect(ScrW() - (649*logoScale) - 20, 20, 649*logoScale, 379*logoScale)
	
	--surface.SetDrawColor(255,255,255,255)
 --   surface.SetMaterial(lts.mat("lordtyler/hud/hfg_dagger.png"))
	--surface.DrawTexturedRect(ScrW() - (649*logoScale) - 20, 20, 649*logoScale, 379*logoScale)
	local ply = LocalPlayer()
	local stance = ply:GetNWInt("stance", 1)
	if stance == 3 then
		texture(ScrW() / 2 - 987 / 2 + 175+2, ScrH() - 160+2, 40, 40, "dir_left")
	end
	if stance == 2 then
		texture(ScrW() / 2 - 987 / 2 + 175+2, ScrH() - 160+2, 40, 40, "dir_up")
	end
	if stance == 1 then
		texture(ScrW() / 2 - 987 / 2 + 175+2, ScrH() - 160+2, 40, 40, "dir_right")
	end
	texture(ScrW() / 2 - 987 / 2 + 175, ScrH() - 160, 44, 44, "buff_over")
	
	
	local combo = ply:GetNWBool("combo", 1)
	if combo >= 4 then combo = 1 end
	
	if combo >= 1 then
		texture(ScrW() / 2 - 987 / 2 + 175+2 + 48, ScrH() - 160+2, 40, 40, "t1")
	end
	if combo >= 2 then
		texture(ScrW() / 2 - 987 / 2 + 175+2 + 48, ScrH() - 160+2, 40, 40, "t2")
	end
	if combo >= 3 then
		texture(ScrW() / 2 - 987 / 2 + 175+2 + 48, ScrH() - 160+2, 40, 40, "t3")
	end
	
	
	texture(ScrW() / 2 - 987 / 2 + 175 + 48, ScrH() - 160, 44, 44, "buff_over")
	
	
    local healthPercent = LocalPlayer():Health() / LocalPlayer():GetMaxHealth()
    texture(114, 44, 190, 17, "bar_health", healthPercent)
	draw.SimpleText(LocalPlayer():Health() .. "/" .. LocalPlayer():GetMaxHealth(), "conthrax_8", 114 + 190/2, 44 + 17/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
    local armorPercent = LocalPlayer():Armor() / 1000
    texture(114, 44 + 17, 190, 17, "bar_armor", armorPercent)
	draw.SimpleText(LocalPlayer():Armor() .. "/" .. 1000, "conthrax_8", 114 + 190/2, 44 + 17/2 + 17, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
    local forcePercent = lts.forcePool.cur / lts.forcePool.max
    texture(114, 44 + 17 + 17, 190, 17, "bar_force", forcePercent)
	draw.SimpleText(lts.forcePool.cur .. "/" .. lts.forcePool.max, "conthrax_8", 114 + 190/2, 44 + 17/2 + 17 + 17, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
    local staminaPercent = lts.staminaPool.cur / lts.staminaPool.max
    texture(114, 44 + 17 + 17 + 17, 190, 17, "bar_stamina", staminaPercent)
	draw.SimpleText(lts.staminaPool.cur .. "/" .. lts.staminaPool.max, "conthrax_8", 114 + 190/2, 44 + 17/2 + 17 + 17 + 17, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	local obj = {}
	
	local ply = LocalPlayer()
	local ending = "lightyears away.."
	if harmonyPlanet == ply:GetNW2String("currentPlanet", "Unknown") then
		local p = ply:GetPos()
		local dis = math.Round(tometers(xydis(p.x, p.y, harmonyX, harmonyY)))
		ending = dis.."m away."
		if dis <= 30 then
			obj.title = "HARMONIZED " .. GetGlobal2Int("harmonyPercent", 0) .. "%"
			obj.color = Color(255,255,0)
		else
			obj.title = "Harmony " .. GetGlobal2Int("harmonyPercent", 0) .. "%"
			obj.color = Color(255,255,255)
		end
	else
		obj.title = "Harmony " .. GetGlobal2Int("harmonyPercent", 0) .. "%"
		obj.color = Color(255,255,255)
	end
	
	
	draw.SimpleText(obj.title, "conthrax_8", 114 + 190/2, 44 + 17/2 + 17 + 17 + 17 + 30, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(harmonyPlanet .. ", ".. ending, "conthrax_8", 114 + 190/2, 44 + 17/2 + 17 + 17 + 17 + 30 + 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	
	draw.SimpleText("Darksabers is currently in beta", "conthrax_12_blur", ScrW()/2, 25, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("Darksabers is currently in beta", "conthrax_12", ScrW()/2, 25, Color(200,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	local is = 48
	
	for k,v in pairs(powerList) do
		local power = lts.forcePowers[v]
		
		local highlight = false
		
		if lts.pressingPower[k] then
			highlight = true
			if powerList[k] then
				lts.powerCooldowns[power.name] = lts.powerCooldowns[power.name] or 0
				--if lts.powerCooldowns[power.name] <= CurTime() then
					--if lts.forcePool.cur >= cost then
						--lts.powerCooldowns[power.name] = CurTime() + power.cooldown
						lastSend = lastSend or 0
						if lastSend <= CurTime() then
							net.Start("lts.force")
								net.WriteInt(k,9)
							net.SendToServer()
							lastSend = CurTime() + 0.05
						end
					--end
				--end
			end
			ringThickness = 6
		end
		
		local cd = math.Round((lts.powerCooldowns[power.name] or 0) - CurTime())
		powericon(ScrW() / 2 - 987 / 2 + ((k-1)*(is+14)) + 177, ScrH() - 116 + 28, is, is, power.icon)
		
		if cd >= 0 then
			draw.SimpleText(cd, "conthrax_22_blur", ScrW() / 2 - 987 / 2 + ((k-1)*(is+14)) + 177 + is/2, ScrH() - 116 + 28 + is/2, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(cd, "conthrax_22_blur", ScrW() / 2 - 987 / 2 + ((k-1)*(is+14)) + 177 + is/2, ScrH() - 116 + 28 + is/2, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(cd, "conthrax_22_blur", ScrW() / 2 - 987 / 2 + ((k-1)*(is+14)) + 177 + is/2, ScrH() - 116 + 28 + is/2, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(cd, "conthrax_22", ScrW() / 2 - 987 / 2 + ((k-1)*(is+14)) + 177 + is/2, ScrH() - 116 + 28 + is/2, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		draw.SimpleText(power.cost, "conthrax_12_blur", ScrW() / 2 - 987 / 2 + ((k-1)*(is+14)) + 177 + is - 4, ScrH() - 116 + 28 + 8, Color(0,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(power.cost, "conthrax_12_blur", ScrW() / 2 - 987 / 2 + ((k-1)*(is+14)) + 177 + is - 4, ScrH() - 116 + 28 + 8, Color(0,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(power.cost, "conthrax_12_blur", ScrW() / 2 - 987 / 2 + ((k-1)*(is+14)) + 177 + is - 4, ScrH() - 116 + 28 + 8, Color(0,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(power.cost, "conthrax_12", ScrW() / 2 - 987 / 2 + ((k-1)*(is+14)) + 177 + is - 4, ScrH() - 116 + 28 + 8, Color(150,0,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		
		
		draw.SimpleText(k, "conthrax_12_blur", ScrW() / 2 - 987 / 2 + ((k-1)*(is+14)) + 177 + is - 4, ScrH() - 116 + 28 + is - 8, Color(0, 0, 0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(k, "conthrax_12_blur", ScrW() / 2 - 987 / 2 + ((k-1)*(is+14)) + 177 + is - 4, ScrH() - 116 + 28 + is - 8, Color(0, 0, 0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(k, "conthrax_12_blur", ScrW() / 2 - 987 / 2 + ((k-1)*(is+14)) + 177 + is - 4, ScrH() - 116 + 28 + is - 8, Color(0, 0, 0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(k, "conthrax_12", ScrW() / 2 - 987 / 2 + ((k-1)*(is+14)) + 177 + is - 4, ScrH() - 116 + 28 + is - 8, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
	
end


hook.Add("HUDPaint", "main_hud", function()
	vinette()
	--healthBar()
	--armorBar()
	--staminaBar()
	--forceBar()
	testHUD()
	crosshair()
end)


concommand.Add("lts.emojis", function()
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Emojipedia")
    frame:SetSize(ScrW() * 0.9, ScrH() * 0.9) -- 90% of screen space
    frame:Center()
    frame:MakePopup()

    local htmlPanel = vgui.Create("DHTML", frame)
    htmlPanel:Dock(FILL)
    htmlPanel:OpenURL("https://emojipedia.org/")
end)



hook.Add("PostPlayerDraw", "DrawPlayerHUD", function(ply)
    if ply == LocalPlayer() then return end
    if not ply:Alive() then return end

    local pos = ply:GetPos() + Vector(0, 0, 74)
    local ang = LocalPlayer():EyeAngles()
    ang:RotateAroundAxis(ang:Forward(), 90)
    ang:RotateAroundAxis(ang:Right(), 90)

    local teamColor = ply:GetNW2String("team", "") == "Jedi" and Color(0, 102, 204) or Color(204, 0, 0)
    local name = ply:Nick()
    local rank = ply:GetNW2String("rankedRank", "[8] Skirmisher")
	
	local m = string.Explode(" ", rank)
	rank = m[2]
	
	local role = ply:GetNW2String("role", "")
	if role ~= "" then role = role .." " end
	
    -- Get subclass and create icon material
    local subclass = ply:GetNW2String("subclass", "")
    local iconUrl = "lordtyler/ixui/icon-style-" .. subclass:lower() .. ".png"
    local iconMat = lts.mat(iconUrl)

    -- Get health values
    local hp = ply:Health()
    local maxHp = ply:GetMaxHealth()
    local hpLerp = Lerp(0.1, ply.lastHpLerp or maxHp, hp)
    local hpYellowLerp = Lerp(0.02, ply.lastHpYellowLerp or maxHp, hp)

    -- Update stored lerp values
    ply.lastHpLerp = hpLerp
    ply.lastHpYellowLerp = hpYellowLerp

    -- Calculate health bar sizes
    local barWidth = 300
    local hpWidth = math.Clamp((hp / maxHp) * barWidth, 0, barWidth)
    local hpYellowWidth = math.Clamp((hpYellowLerp / maxHp) * barWidth, 0, barWidth)

    -- Size options for the icon
    local iconSize = 128 -- Default icon size
    local iconOffset = -iconSize / 2 -- Center the icon above the player name

    cam.Start3D2D(pos, ang, 0.05)
        -- Draw subclass icon above the player name
        if iconMat then
            surface.SetMaterial(iconMat)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(iconOffset, -iconSize - 55, iconSize, iconSize)
        end
		
		local pad = 38

        -- Draw name and rank
        draw.SimpleText(role .. name, "conthrax_38_blur", 0, -38, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(role .. name, "conthrax_38", 0, -38, teamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(rank, "conthrax_32", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText( ply:GetNW2String("team", "") .. " " .. subclass, "conthrax_32", 0, pad, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		
		
        -- Draw health bar background
        surface.SetDrawColor(255, 0, 0, 255)
        surface.DrawRect(-barWidth / 2, pad*2, barWidth, 6)

        -- Draw yellow lerp layer
        surface.SetDrawColor(255, 255, 0, 200)
        surface.DrawRect(-barWidth / 2, pad*2, hpYellowWidth, 6)

        -- Draw red current HP layer
        surface.SetDrawColor(0, 255, 0, 255)
        surface.DrawRect(-barWidth / 2, pad*2, hpWidth, 6)
    cam.End3D2D()
end)
