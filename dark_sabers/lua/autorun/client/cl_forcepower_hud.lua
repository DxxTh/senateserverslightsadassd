lts = lts or {}

lts.forcePool = {cur = 0, max = 0}
lts.staminaPool = {cur = 0, max = 0}
lts.pressingPower = {}
lts.powerCooldowns = {}
powerList = powerList or {}

local lastFP = 0

function tryToForce(a)
	if lastFP <= CurTime() then
		net.Start("lts.force")
			net.WriteInt(a,9)
		net.SendToServer()
		lastFP = CurTime() + 0.05
	end
end

net.Receive("lts.cooldown", function()
	local power = net.ReadString()
	local cd = net.ReadInt(32)
	lts.powerCooldowns[power] = CurTime() + cd
end)

net.Receive("lts.force", function()
	local slot = net.ReadInt(9)
	local power = net.ReadString()
	powerList[slot] = power
end)

net.Receive("lts.pool", function()
	local slot = net.ReadInt(32)
	lts.forcePool.cur = slot
end)

net.Receive("lts.pool.max", function()
	local slot = net.ReadInt(32)
	lts.forcePool.max = slot
end)

net.Receive("lts.stamina", function()
	local slot = net.ReadInt(32)
	lts.staminaPool.cur = slot
end)

net.Receive("lts.stamina.max", function()
	local slot = net.ReadInt(32)
	lts.staminaPool.max = slot
end)

local fearTimer = 0
net.Receive("lts.fear", function()
	fearTimer = CurTime() + 2
	surface.PlaySound("npc/fast_zombie/fz_scream1.wav")
end)

local blindTime = 0
net.Receive("lts.blind", function()
	blindTime = CurTime() + 3
end)

lts.forceKeys = {}
lts.forceKeys[1] = KEY_1
lts.forceKeys[2] = KEY_2
lts.forceKeys[3] = KEY_3
lts.forceKeys[4] = KEY_4
lts.forceKeys[5] = KEY_5
lts.forceKeys[6] = KEY_6
lts.forceKeys[7] = KEY_7
lts.forceKeys[8] = KEY_8
lts.forceKeys[9] = KEY_9
lts.forceKeys[0] = KEY_0

lts.forceLoaded = true

local isSwitchingPowers = false
hook.Add("Think", "force_select", function()
	local ply = LocalPlayer()
	
	local canKick = true
	
	if vgui.CursorVisible() then canKick = false end
	if ply:IsTyping() then canKick = false end
	
	if canKick then
		for k,v in pairs(lts.forceKeys) do
			lts.pressingPower[k] = input.IsKeyDown(v)
		end
	end
end)


local removeBinds = {}
removeBinds["slot1"] = true
removeBinds["slot2"] = true
removeBinds["slot3"] = true
removeBinds["slot4"] = true
removeBinds["slot5"] = true
removeBinds["slot6"] = true
removeBinds["slot7"] = true
removeBinds["slot8"] = true
removeBinds["slot9"] = true
removeBinds["slot0"] = true


hook.Add("PlayerBindPress", "244242525", function(ply, bind, pressed)
	for k,v in pairs(removeBinds) do
		if string.find(bind, k) then
			return true
		end
	end
end)

lts = lts or {}

local fontSize = 8

surface.CreateFont("forcePowerFont", {
	font = "Arial",
	size = ScreenScale(fontSize),
	weight = 500,
	antialias = true,
})

surface.CreateFont("descriptionPowerFont", {
	font = "Arial",
	size = ScreenScale(fontSize*0.75),
	weight = 500,
	antialias = true,
})


local lagging = 0
function drawBlurry(x,y,w,h)
	local fps = update_frame_time()
	
	if fps >= 66 then
		drawBlurAt(x, y, w, h)
	end
	
	surface.SetDrawColor(0,0,0,150)
	surface.DrawRect(x,y,w,h)
end

local healthPerc = 1
local healthPercStrike = 1
local forcePerc = 1
local forcePercStrike = 1
local staminaPerc = 1
local staminaPercStrike = 1

local lastAlert = 0

hook.Add("HUDPaint", "force_hud", function() end)
hook.Add("HUDPaint2", "force_hud", function()
	
	if lts.forceLoaded then
		/*
		local sw = ScrW()
		local sh = ScrH()

		local edgePadding = 50
		
		local iconSize = 80
		local iconPad = 8
		local fw = (iconSize*LTS_MAX_FORCE_POWER)+(iconPad*(LTS_MAX_FORCE_POWER+1))
		local fh = (iconPad*2)+iconSize
		
		local x = sw/2 - (fw/2)
		local y = sh - edgePadding - fh
		
		drawBlurry(x,y,fw,fh)
		
		for i=1,LTS_MAX_FORCE_POWER do
			
			local pad = i*iconPad
			local icon = i*iconSize
			local ringThickness = 2
			
			local power = lts.forcePowers[powerList[i]]
			local cost = power and power.cost or 0
			
			if lts.forcePool.cur >= cost then
				surface.SetDrawColor(255,255,255,255)
			else
				surface.SetDrawColor(100,155,155,255)
			end
			
			if lts.pressingPower[i] then
				if powerList[i] then
					lts.powerCooldowns[power.name] = lts.powerCooldowns[power.name] or 0
					--if lts.powerCooldowns[power.name] <= CurTime() then
						--if lts.forcePool.cur >= cost then
							lts.powerCooldowns[power.name] = CurTime() + power.cooldown
							tryToForce(i)
							
							
							
						--end
					--end
				end
				ringThickness = 6
			end
			
			if powerList[i] then
				local cd = lts.powerCooldowns[power.name] or 0
				if (cd >= CurTime()) then
					local t = math.Round(cd-CurTime())
					surface.SetDrawColor(155,100,100,255)
					draw.DrawText(t, "forcePowerFont", x+pad+icon-iconSize + iconSize/2, y+iconPad-ringThickness- ScreenScale(fontSize)/2, Color(200,0,0), TEXT_ALIGN_CENTER )
					surface.DrawRect(x+pad+icon-iconSize,y+iconPad,iconSize / 4,ringThickness)
					surface.DrawRect(x+pad+icon-iconSize + (iconSize/4*3),y+iconPad,iconSize / 4,ringThickness)
				else
					surface.DrawRect(x+pad+icon-iconSize,y+iconPad,iconSize,ringThickness)
				end
			else
				surface.DrawRect(x+pad+icon-iconSize,y+iconPad,iconSize,ringThickness)
			end
			
			draw.DrawText(i, "forcePowerFont", x+pad+icon-iconSize + iconSize/2, y+iconPad+iconSize-ringThickness- ScreenScale(fontSize)/2, color_white, TEXT_ALIGN_CENTER )
			surface.DrawRect(x+pad+icon-iconSize,y+iconPad+iconSize-ringThickness,iconSize/3,ringThickness)
			surface.DrawRect(x+pad+icon-iconSize + (iconSize/3)*2,y+iconPad+iconSize-ringThickness,iconSize/3,ringThickness)
			
			surface.DrawRect(x+pad+icon-iconSize,y+iconPad,ringThickness,iconSize)
			surface.DrawRect(x+pad+icon-iconSize+iconSize-ringThickness,y+iconPad,ringThickness,iconSize)
			
			
			if powerList[i] then
				surface.SetMaterial(mat(power.icon))
				surface.DrawTexturedRect(x+pad+icon-iconSize + ((iconSize*0.25)/2),y+iconPad + ((iconSize*0.25)/2),iconSize*0.75,iconSize*0.75)
			end
		end
		
		local barPad = 8
		local barH = 24
		local ringThickness = 2
		local sliderH = fw - (ringThickness*4)
		
		drawBlurry(x,y-barH-barPad,fw,barH)
		drawBlurry(x,y-barH-barPad-barH-barPad,fw,barH)
		
		surface.SetDrawColor(255,255,255,255)
		
		surface.DrawRect(x,y-barH-barPad,fw,ringThickness)
		surface.DrawRect(x,y-barH-barPad+barH-ringThickness,fw,ringThickness)
		surface.DrawRect(x,y-barH-barPad,ringThickness,barH)
		surface.DrawRect(x+fw-2,y-barH-barPad,ringThickness,barH)
		
		surface.DrawRect(x,y-barH-barPad-barH-barPad,fw,ringThickness)
		surface.DrawRect(x,y-barH-barPad-barH-barPad+barH-ringThickness,fw,ringThickness)
		surface.DrawRect(x,y-barH-barPad-barH-barPad,ringThickness,barH)
		surface.DrawRect(x+fw-2,y-barH-barPad-barH-barPad,ringThickness,barH)
		
		local ply = LocalPlayer()
		
		local hp = ply:Health() / ply:GetMaxHealth()
		
		healthPerc = Lerp(FrameTime()*6, healthPerc, hp)
		healthPercStrike = Lerp(FrameTime()*2, healthPercStrike, hp)
		
		surface.SetDrawColor(155,155,25,555)
		surface.DrawRect(x+ringThickness*2,y-barH-barPad+ringThickness*2,(fw - ringThickness*4) * healthPercStrike,barH - ringThickness*4)
		
		surface.SetDrawColor(155,25,25,555)
		surface.DrawRect(x+ringThickness*2,y-barH-barPad+ringThickness*2,(fw - ringThickness*4) * healthPerc,barH - ringThickness*4)
		
		
		local force = math.Clamp(lts.forcePool.cur / lts.forcePool.max, 0, 1)
		
		forcePerc = Lerp(FrameTime()*6, forcePerc, force)
		forcePercStrike = Lerp(FrameTime()*2, forcePercStrike, force)
		
		surface.SetDrawColor(5,155,155,555)
		surface.DrawRect(x+ringThickness*2,y-barH-barPad+ringThickness*2-barH-barPad,(fw - ringThickness*4) * forcePercStrike,barH - ringThickness*4)
		
		surface.SetDrawColor(115,25,125,555)
		surface.DrawRect(x+ringThickness*2,y-barH-barPad+ringThickness*2-barH-barPad,(fw - ringThickness*4) * forcePerc,barH - ringThickness*4)
		
		
		local stamina = math.Clamp(lts.staminaPool.cur / lts.staminaPool.max, 0, 1)
		
		staminaPerc = Lerp(FrameTime()*6, staminaPerc, stamina)
		staminaPercStrike = Lerp(FrameTime()*2, staminaPercStrike, stamina)
		
		surface.SetDrawColor(255,155,5,555)
		surface.DrawRect(x+ringThickness*2,y-barH-barPad+ringThickness*2-barH-barPad-barH-barPad,(fw - ringThickness*4) * staminaPercStrike,barH - ringThickness*4)
		
		surface.SetDrawColor(225,225,5,555)
		surface.DrawRect(x+ringThickness*2,y-barH-barPad+ringThickness*2-barH-barPad-barH-barPad,(fw - ringThickness*4) * staminaPerc,barH - ringThickness*4)
		*/
		
		local is = 52
		local sp = 13
		local bw = 616
		local bh = 96
		local sw = ScrW()
		local sh = ScrH()
		
		surface.SetDrawColor(225,225,255,555)
		surface.SetMaterial(lts.mat("materials/big_button.png"))
		surface.DrawTexturedRect(sw/2-bw/2,sh-bh,bw,bh)
		
		for i=1,9 do
			local bs = 8
			surface.SetDrawColor(225,225,255,555)
			surface.SetMaterial(lts.mat("materials/hfgjvs/torcom/item_grade_26.png"))
			surface.DrawTexturedRect(sw/2-bw/2 + 22 + ((i-1)*(is+sp)) -bs/2 - 1,sh-bh + 22 -bs/2 -1, is+bs, is+bs)
			
			
			local power = lts.forcePowers[powerList[i]]
			local cost = power and power.cost or 0
			
			if lts.forcePool.cur >= cost then
				surface.SetDrawColor(255,255,255,255)
			else
				surface.SetDrawColor(100,155,155,255)
			end
			
			local shrink = false
			if lts.pressingPower[i] then
				if powerList[i] then
					lts.powerCooldowns[power.name] = lts.powerCooldowns[power.name] or 0
					if lts.powerCooldowns[power.name] <= CurTime() then
						if lts.forcePool.cur >= cost then
							lts.powerCooldowns[power.name] = CurTime() + power.cooldown
							tryToForce(i)
							print("aaaaaa")
							lastAlert = CurTime() + 1
						else
							if lastAlert <= CurTime() then
								addAlert("Not Enough Force!")
								lastAlert = CurTime() + 0.5
							end
						end
					end
				end
				shrink = true
			end
			
			if powerList[i] then
				local cd = lts.powerCooldowns[power.name] or 0
				
				local t = math.Round(cd-CurTime())
				if (cd >= CurTime()) then
					
					if shrink then
						surface.SetDrawColor(225,225,255,255)
						surface.SetMaterial(lts.mat(power.icon))
						surface.DrawTexturedRect(sw/2-bw/2 + 22 + ((i-1)*(is+sp)) + 2,sh-bh + 22 + 2, is-4, is-4)
					else
						surface.SetDrawColor(225,225,255,255)
						surface.SetMaterial(lts.mat(power.icon))
						surface.DrawTexturedRect(sw/2-bw/2 + 22 + ((i-1)*(is+sp)),sh-bh + 22, is, is)
					end
					draw.DrawText(t, "montserrat_32_blur", sw/2-bw/2 + 22 + ((i-1)*(is+sp)) + is/2,sh-bh + 22 + is/2 - 14, Color(255,0,0), TEXT_ALIGN_CENTER)
					draw.DrawText(t, "montserrat_32", sw/2-bw/2 + 22 + ((i-1)*(is+sp)) + is/2,sh-bh + 22 + is/2 - 14, Color(255,0,0), TEXT_ALIGN_CENTER)
				else
					if shrink then
						surface.SetDrawColor(225,225,255,255)
						surface.SetMaterial(lts.mat(power.icon))
						surface.DrawTexturedRect(sw/2-bw/2 + 22 + ((i-1)*(is+sp)) + 2,sh-bh + 22 + 2, is-4, is-4)
					else
						surface.SetDrawColor(225,225,255,255)
						surface.SetMaterial(lts.mat(power.icon))
						surface.DrawTexturedRect(sw/2-bw/2 + 22 + ((i-1)*(is+sp)),sh-bh + 22, is, is)
					end
				end
				
				
				
				draw.DrawText(0, "montserrat_32_blur", sw/2-bw/2 + 22 + ((i-1)*(is+sp)) + is/2,sh-bh + 22 + is/2 - 14, Color(255,0,0), TEXT_ALIGN_CENTER)
				draw.DrawText(0, "montserrat_32", sw/2-bw/2 + 22 + ((i-1)*(is+sp)) + is/2,sh-bh + 22 + is/2 - 14, Color(255,0,0), TEXT_ALIGN_CENTER)
				
				
			end
			
			
			
			draw.DrawText(i, "montserrat_28_blur", sw/2-bw/2 + 22 + ((i-1)*(is+sp)) + is/2,sh-bh + 22 + is - 14, Color(0,0,0), TEXT_ALIGN_CENTER)
			draw.DrawText(i, "montserrat_28", sw/2-bw/2 + 22 + ((i-1)*(is+sp)) + is/2,sh-bh + 22 + is - 14, Color(255,255,255), TEXT_ALIGN_CENTER)
		end
		
		
		
		
		
		
		
		
		
	end
end)

function lts.addSpacer(p,a,b)
	local z = vgui.Create("DPanel", p)
	z:SetSize(a,a)
	z:Dock(b)
	function z:Paint() end
end

net.Receive("lts.power.swap", function()
	local t = net.ReadTable()
	lts.powerBar(t)
end)

function lts.slotMenu(whitelist)
	local iconSize = 80
	local padding = 8
	local fh = ScrH()* 0.6
	local mw = (LTS_MAX_FORCE_POWER*(iconSize))+(LTS_MAX_FORCE_POWER*(padding+1))
	
	local f = vgui.Create("DFrame")
	f:SetSize(mw,fh)
	f:Center()
	f:SetTitle("Force Bar Menu")
	f:SetDraggable(false)
	f:MakePopup()
	
	local slots = vgui.Create("DScrollPanel", f)
	slots:SetSize(padding+padding+iconSize,padding+padding+iconSize)
	slots:Dock(BOTTOM)
	
	local pwrs = vgui.Create("DScrollPanel", f)
	pwrs:SetSize(padding+padding+iconSize,padding+padding+iconSize)
	pwrs:Dock(FILL)
	
	for name,power in pairs(lts.getPowers()) do
		local a = vgui.Create("DPanel", pwrs)
		a:SetSize(padding+padding+iconSize,padding+padding+iconSize)
		a:Dock(TOP)
		
		local icon = vgui.Create("DPanel", a)
		icon:SetPos(8,8)
		icon:SetSize(iconSize,iconSize)
		if whitelist[name] then
			icon:Droppable('ltsPower')
		end
		icon.name = name
		function icon:Paint(w,h)
			if whitelist[name] then
				surface.SetDrawColor(255,255,255,255)
			else
				surface.SetDrawColor(255,255,255,10)
			end
			surface.SetMaterial(mat(power.icon))
			surface.DrawTexturedRect(0,0,w,h)
		end
		
		local b = vgui.Create("DLabel", a)
		b:SetPos(iconSize + 32,16)
		b:SetText(name)
		b:SetFont("forcePowerFont")
		b:SizeToContents()
		
		local b = vgui.Create("DLabel", a)
		b:SetPos(iconSize + 32,16+ScreenScale(fontSize))
		b:SetText("Cooldown: " .. power.cooldown)
		b:SetFont("descriptionPowerFont")
		b:SizeToContents()
		
		local b = vgui.Create("DLabel", a)
		b:SetPos(iconSize + 32,16+ScreenScale(fontSize)+ScreenScale(fontSize*0.75))
		b:SetText("Force Cost: " .. power.cost)
		b:SetFont("descriptionPowerFont")
		b:SizeToContents()
		
		lts.addSpacer(pwrs,4,TOP)
	end
	
	for i=1,LTS_MAX_FORCE_POWER do
		local a = vgui.Create("DButton", slots)
		a:SetSize(iconSize,iconSize)
		a:SetText("")
		a:Dock(LEFT)
		
		function a:DoClick()
			net.Start("lts.power.swap")
				net.WriteInt(i,8)
				net.WriteString("")
			net.SendToServer()
			powerList[i]=nil
		end
		
		a:Receiver('ltsPower',function(receiver, tableOfDroppedPanels, isDropped, menuIndex, mouseX, mouseY )
			if isDropped then
				local name = tableOfDroppedPanels[1].name
				if whitelist[name] then
					net.Start("lts.power.swap")
						net.WriteInt(i,8)
						net.WriteString(name)
					net.SendToServer()
					powerList[i]=name
				end
			end
		end,{})
		
		lts.addSpacer(slots,8,LEFT)
		function a:Paint(w,h)
			surface.SetDrawColor(255,255,255,255)
			local ringThickness = 2
			surface.DrawRect(0,0,w,ringThickness)
			surface.DrawRect(0,0,ringThickness,h)
			surface.DrawRect(w-ringThickness,0,ringThickness,h)
			surface.DrawRect(0,h-ringThickness,w,ringThickness)
			
			local power = lts.forcePowers[powerList[i]]
			if powerList[i] then
				surface.SetMaterial(mat(power.icon))
				surface.DrawTexturedRect(w*0.125,w*0.125,w*0.75,h*0.75)
			end
			
			
			
			draw.DrawText(i, "forcePowerFont", w/2, h - ScreenScale(fontSize), color_white, TEXT_ALIGN_CENTER)
		
		end
	end
	
end
















local meta = FindMetaTable("Player")

local healSigns = {}
local healSize = 128

hook.Add( "Think", "healEffect", function()
	for k,v in pairs(healSigns) do
		if v.lifeTime <= CurTime() then
			table.remove(healSigns, k)
		else
			local lifeTime = v.lifeTime - CurTime()
			local pos = v.pos - Vector(0,0,lifeTime*100)
			local gg = DynamicLight(1000000 + k)
			if (gg) then
				gg.pos = pos
				gg.r = v.color.r
				gg.g = v.color.g
				gg.b = v.color.b
				gg.brightness = 2
				gg.decay = 1000
				gg.size = 64
				gg.dietime = CurTime() + 1
			end
		end
	end
end )

hook.Add("PostDrawTransparentRenderables", "healEffec3", function()
	for k,v in pairs(healSigns) do
		if v.lifeTime <= CurTime() then
			table.remove(healSigns, k)
		else
			local lifeTime = v.lifeTime - CurTime()
			cam.Start3D2D(v.pos - Vector(0,0,lifeTime*32), Angle(0, LocalPlayer():EyeAngles().y + 0, 90), 0.1)
				--surface.SetMaterial(lts.mat("swtor/heal"))
				surface.SetMaterial(lts.mat("lordtyler/UI_Ability_HealthInc3.png"))
				surface.SetDrawColor(v.color.r, v.color.g, v.color.b, 255 * lifeTime)
				surface.DrawTexturedRect(-healSize/2, -healSize/2, healSize, healSize)
			cam.End3D2D()
		end
	end
end)
	
-- Heal Effect Function
function meta:healEffect(color)
	for i=1,16 do
		timer.Simple(0.05*i, function()
			local heal = {}
			heal.lifeTime = CurTime() + 1
			heal.pos = self:GetPos() + Vector(math.Rand(-16, 16), math.Rand(-16, 16), math.Rand(0, 72))
			heal.color = color
			table.insert(healSigns, heal)
		end)
	end
end

net.Receive("lts.heal", function()
    local ply = net.ReadEntity()
    local color = net.ReadVector()

    if IsValid(ply) and LocalPlayer():GetPos():DistToSqr(ply:GetPos()) <= (2048 * 2048) then
        ply:healEffect(Color(color.x, color.y, color.z))
    end
end)





hook.Add("HUDPaint", "DrawFearMaterial", function()
	if fearTimer >= CurTime() then
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, ScrW(), ScrH())
		if math.random(1,5) == 3 then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(lts.mat("materials/lordtyler/scare.jpg"))
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		end
	end
end)



hook.Add("HUDPaint", "BLIND", function()
	if blindTime >= CurTime() then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end
end)


net.Receive("lts.ring", function()
	local ply = LocalPlayer()
	ply:SetDSP(35, false)
	
	timer.Simple(2,function()
		ply:SetDSP(16, false)
	end)
	
	timer.Simple(10,function()
		ply:SetDSP(1, false)
	end)
	
end)


net.Receive("lts.light", function()
	local v = net.ReadVector()-- pos
	local r = net.ReadVector()-- col
	local a = net.ReadInt(32) -- len
	local t = net.ReadInt(32) -- size
	
	local dlight = DynamicLight( LocalPlayer():EntIndex() )
	if ( dlight ) then
		dlight.pos = v
		dlight.r = r.r
		dlight.g = r.g
		dlight.b = r.b
		dlight.brightness = 5
		dlight.decay = 1000
		dlight.size = t
		dlight.dietime = CurTime() + a
	end
	
end)

net.Receive("lts.esp", function()
	local sightDuration = net.ReadInt(32)
	local radius = net.ReadInt(32)
	local col = net.ReadVector()
	
	local ply = LocalPlayer()
	
	hook.Add("PreDrawHalos", "esplol", function()
		local targets = {}
		for _, ent in pairs(ents.FindInSphere(ply:GetPos(), radius)) do
			if ent:IsPlayer() or ent:IsNPC() then
				table.insert(targets, ent)
			end
		end
		halo.Add(targets, Color(col.x, col.y, col.z), 2, 2, 1, true, true)
	end)

	timer.Simple(sightDuration, function()
		hook.Remove("PreDrawHalos", "esplol")
	end)
end)
