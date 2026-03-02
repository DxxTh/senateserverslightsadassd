lts=lts or {}

local inv = {}
local invOpen = false
local hh,ww = 820,738

local function adjust(panel)
    local entity = panel:GetEntity()
    if not IsValid(entity) then return end

    local mn, mx = entity:GetRenderBounds()
    local size = math.max(math.abs(mn.x) + math.abs(mx.x), math.abs(mn.y) + math.abs(mx.y), math.abs(mn.z) + math.abs(mx.z))

    panel:SetFOV(45)
    panel:SetCamPos(Vector(size, size, size*1.25))
    panel:SetLookAt((mn + mx) * 0.5)
end

net.Receive("lts.inv", function(len, ply)
    local data = net.ReadTable()
    local open = net.ReadBool()
    inv = data
    if open then
        safeOpenInv()
    end
end)

function getInv()
    return inv
end

if IsValid(MENU_INVENTORY) then
	MENU_INVENTORY:Remove()
end

function safeOpenInv()
    if IsValid(MENU_INVENTORY) then
        MENU_INVENTORY:Remove()
    end

    local drop = vgui.Create("DFrame")
    drop:SetTitle("")
    drop:SetSize(ScrW(),ScrH())
    drop:Center()
    drop:ShowCloseButton(false)
    drop:MakePopup()
	drop:Receiver("inv", function(rec, obj, isDropped, menuIndex, mouseX, mouseY )
		if isDropped then
			net.Start("lts.item.use")
				net.WriteInt(obj[1].parent.slot,7)
				net.WriteString("Drop")
			net.SendToServer()
		end
	end,{})
	drop.Paint = nil
	
    local frame = vgui.Create("DPanel", drop)
    --frame:SetTitle("")
    frame:SetSize(ww,hh)
    frame:Center()
    --frame:ShowCloseButton(false)
    --frame:MakePopup()
    --frame:SetBackgroundBlur(true)
	frame.slots = {}
	frame:SetMouseInputEnabled(true)
	
	MENU_INVENTORY = frame
	
    frame.Think = function(self, w, h)
        self.dead = self.dead or CurTime() + 0.5
        if self.dead <= CurTime() then
            --frame:Remove()
            --safeOpenInv()
        end
    end

    frame.Paint = function(self, w, h)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(lts.mat("crafting/main.png"))
        surface.DrawTexturedRect(0,0,w,h)

        draw.DrawText("Inventory", "enigma_25", w/2, 24, Color(200,200,0), TEXT_ALIGN_CENTER )

    end
    local ss = 24
    local close = vgui.Create("DButton", frame)
    close:SetPos(ww-ss-24,8)
    close:SetSize(ss,ss)
    close:SetText("")

    function close:DoClick()
        invOpen = false
        frame:Remove()
    end

    function close:Paint(w,h)
        if self:IsHovered() then
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(lts.mat("icons/cross.png"))
            surface.DrawTexturedRect(0,0,w,h)
        else
            surface.SetDrawColor(2, 255, 255, 255)
            surface.SetMaterial(lts.mat("icons/cross.png"))
            surface.DrawTexturedRect(0,0,w,h)
        end
    end

    local cols = 10
    local pad = 8

    local vipLevel = LocalPlayer():vipLevel()

    for i=0,99 do
        local row = math.floor(i/10)
        xx = i - (row*cols)

        local b = vgui.Create("DPanel", frame)
        b:SetSize(64,64)
        b:SetPos(64 + 48 + ((xx-1) * 64), 70 + (64*row))
		b.slot = i+1
		b.occupied = false
		b:SetZPos(5)
		b:Receiver("inv", function(rec, obj, isDropped, menuIndex, mouseX, mouseY )
			if isDropped then
				if not rec.occupied then
					if rec.slot <= 50 then
						net.Start("lts.item.move")
							net.WriteInt(obj[1].parent.slot, 7) -- prev
							net.WriteInt(rec.slot, 7) -- new
						net.SendToServer()
						obj[1].parent.occupied = false
						obj[1].parent = rec
						rec.occupied = true
						obj[1]:SetPos(rec:GetPos())
					else
						if rec.slot <= 60 and LocalPlayer():vipLevel() >= 1 then
							obj[1].parent.occupied = false
							obj[1].parent = rec
							rec.occupied = true
							obj[1]:SetPos(rec:GetPos())
						elseif rec.slot <= 80 and LocalPlayer():vipLevel() >= 2 then
							obj[1].parent.occupied = false
							obj[1].parent = rec
							rec.occupied = true
							obj[1]:SetPos(rec:GetPos())
						elseif rec.slot <= 100 and LocalPlayer():vipLevel() >= 3 then
							obj[1].parent.occupied = false
							obj[1].parent = rec
							rec.occupied = true
							obj[1]:SetPos(rec:GetPos())
						else
							chat.AddText(Color(255,0,0), "[IX] ", Color(255,255,255), "Additional inventory slots are unlocked by purchasing VIP!")
						end
					end
				end
			end
		end,{})
		frame.slots[i+1] = b
		
        function b:Paint(w,h)
			local a = 255
            if i >= 80 then
                if vipLevel >=3 then
                    surface.SetDrawColor(255, 255, 255, a)
                    surface.SetMaterial(lts.mat("hfgjvs/torcom/item_grade_26.png"))
                    surface.DrawTexturedRect(0,0,w,h)
                else
                    surface.SetDrawColor(100, 100, 100, a)
                    surface.SetMaterial(lts.mat("hfgjvs/torcom/item_grade_26.png"))
                    surface.DrawTexturedRect(0,0,w,h)
                end
            elseif i >= 60 then
                if vipLevel >=2 then
                    surface.SetDrawColor(255, 255, 255, a)
                    surface.SetMaterial(lts.mat("hfgjvs/torcom/item_grade_26.png"))
                    surface.DrawTexturedRect(0,0,w,h)
                else
                    surface.SetDrawColor(100, 100, 100, a)
                    surface.SetMaterial(lts.mat("hfgjvs/torcom/item_grade_26.png"))
                    surface.DrawTexturedRect(0,0,w,h)
                end
            elseif i >= 50 then
                if vipLevel >=1 then
                    surface.SetDrawColor(255, 255, 255, a)
                    surface.SetMaterial(lts.mat("hfgjvs/torcom/item_grade_26.png"))
                    surface.DrawTexturedRect(0,0,w,h)
                else
                    surface.SetDrawColor(100, 100, 100, a)
                    surface.SetMaterial(lts.mat("hfgjvs/torcom/item_grade_26.png"))
                    surface.DrawTexturedRect(0,0,w,h)
                end
            else
                surface.SetDrawColor(255, 255, 255, a)
                surface.SetMaterial(lts.mat("hfgjvs/torcom/item_grade_26.png"))
                surface.DrawTexturedRect(0,0,w,h)
            end
            
        end

    end


	for slot,data in pairs(inv) do
		local parent = frame.slots[slot]
		
		local item = lts.item.list[data.id]
		if item then
			local b = vgui.Create("DModelPanel", frame)
			b:SetSize(64,64)
			b:SetPos(parent:GetPos())
			parent.occupied = true
			b.parent = parent
			b:SetModel(item.model)
			b.item = item
			adjust(b)
			b:SetZPos(999)
			b:Droppable("inv")
			b:Receiver("inv", function(rec, obj, isDropped, menuIndex, mouseX, mouseY )
				if isDropped then
					print("DROPPED", rec.parent.slot, obj[1].parent.slot)
					if rec.parent.slot ~= obj[1].parent.slot then
						net.Start("lts.item.combine")
							net.WriteInt(obj[1].parent.slot, 7) -- prev
							net.WriteInt(rec.parent.slot, 7) -- new
						net.SendToServer()
					end
				end
			end,{})
			if item.isCrystal then
				b:SetColor(item.color)
			end
			b.old = b.OnMousePressed
			function b:OnMousePressed(mouseCode)
				if mouseCode == MOUSE_RIGHT and self.item then
					local menu = DermaMenu()
					for funcName, func in SortedPairs(self.item.funcs or {}) do
						menu:AddOption(funcName, function()
							net.Start("lts.item.use")
								net.WriteInt(self.parent.slot,7)
								net.WriteString(funcName)
							net.SendToServer()
						end)
					end
					menu:Open()
				else
					self.old(self, mouseCode)
				end
			end
			
			b.paint = b.Paint
			function b:Paint(w,h)
				if self.item.grade then
					local grades = {
						["Primordial"] 	= "hfgjvs/torcom/item_grade_23.png",
						["Mythic"] 		= "hfgjvs/torcom/itemorange.png",
						["Legendary"] 	= "hfgjvs/torcom/item_grade_2.png",
						["Celestial"] 	= "hfgjvs/torcom/item_grade_22.png",
						["Artifact"] 	= "hfgjvs/torcom/item_grade_17.png",
						["Unique"] 		= "hfgjvs/torcom/item_grade_19.png",
						["Heroic"] 		= "hfgjvs/torcom/item_grade_10.png",
						["Arcane"] 		= "hfgjvs/torcom/item_grade_3.png",
						["Rare"] 		= "hfgjvs/torcom/item_grade_11.png",
						["Grand"] 		= "hfgjvs/torcom/item_grade_12.png",
						["Basic"] 		= "hfgjvs/torcom/item_grade_16.png",
					}
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(lts.mat(grades[self.item.grade]))
					surface.DrawTexturedRect(0,0,w,h)
				else
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(lts.mat("hfgjvs/torcom/item_grade_16.png"))
					surface.DrawTexturedRect(0,0,w,h)
				end
				self.paint(self,w,h)
			end
			
			function b:Think()
				if self:IsHovered() then
					frame.tooltip.enabled = CurTime() + 0.01
					frame.tooltip.title = item.name
					frame.tooltip.desc = item.description
					frame.tooltip:MakePopup()
				end
			end
		end
	end
	
	local tooltip = vgui.Create("DFrame")
	tooltip:MakePopup()
	tooltip:SetSize(459,201)
	tooltip:SetPos(0,0)
	tooltip:SetTitle("")
	
	function tooltip.Paint(self, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(lts.mat("descript.png"))
		surface.DrawTexturedRect(0, 0, w, h)

		-- Draw title
		draw.SimpleText(self.title, "enigma_22", w/2, 10 + 20, Color(0, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		-- Draw description with multi-line support
		local descText = self.desc or ""
		local x, y = w/2, 40 + 30
		local maxWidth = w - 40
		local lines = wrapText(descText, "enigma_16", maxWidth)
		for _, line in ipairs(lines) do
			draw.SimpleText(line, "enigma_16", x, y, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			y = y + 20
		end
	end

	-- Helper function to wrap text for multi-line support
	function wrapText(text, font, maxWidth)
		surface.SetFont(font)
		local words = string.Explode(" ", text)
		local lines = {}
		local currentLine = ""

		for _, word in ipairs(words) do
			local testLine = currentLine == "" and word or (currentLine .. " " .. word)
			local textWidth = surface.GetTextSize(testLine)

			if textWidth > maxWidth then
				table.insert(lines, currentLine)
				currentLine = word
			else
				currentLine = testLine
			end
		end

		if currentLine ~= "" then
			table.insert(lines, currentLine)
		end

		return lines
	end

	tooltip:ShowCloseButton(false)
	tooltip:SetZPos(30000)
	tooltip.enabled = 0
	frame.tooltip = tooltip
    
	tooltip.Think = function(self, w, h)
		if self.enabled >= CurTime() then
			self:SetPos(gui.MouseX() - 459/2, gui.MouseY() - 201 - 16)
		else
			self:SetPos(-9999,-9999)
		end
    end
	function frame:OnRemove()
		tooltip:Remove()
		drop:Remove()
	end
	
end

function lts.openInv()
    if not inv then
        net.Start("lts.inv")
            net.WriteBool(true)
        net.SendToServer()
    else
        safeOpenInv()
    end
end

hook.Add("Think", "OpenInventoryOnKeyPress", function()
    if not LocalPlayer():IsTyping() and not vgui.GetKeyboardFocus() and not gui.IsGameUIVisible()then
        if input.IsKeyDown(KEY_I) then
            if not invOpen then
                safeOpenInv()
                invOpen = true
            end
        end
    end
end)

concommand.Add("lts.openInv", function(ply, cmd, args)
    lts.openInv()
end)
















concommand.Add("lts.cycles", function()
    local frame = vgui.Create("DFrame")
    frame:SetSize(800, 600)
    frame:Center()
    frame:SetTitle("Player Animation Viewer")
    frame:MakePopup()

    local mdlPanel = vgui.Create("DModelPanel", frame)
    mdlPanel:SetSize(400, 400)
    mdlPanel:SetPos(200, 50)
    mdlPanel:SetFOV(75)
    mdlPanel:SetCamPos(Vector(50, 0, 50))
    mdlPanel:SetLookAt(Vector(0, 0, 50))

    local plyModel = LocalPlayer():GetModel()
    mdlPanel:SetModel(plyModel)

    local sequenceDropdown = vgui.Create("DComboBox", frame)
    sequenceDropdown:SetPos(200, 460)
    sequenceDropdown:SetSize(400, 30)
    sequenceDropdown:SetValue("Select Animation Sequence")

    local t = {
        "wo",
        "b_",
        "h_",
        "r_",
    }

    for i = 0, mdlPanel.Entity:GetSequenceCount() - 1 do
        local a = false
        local m = mdlPanel.Entity:GetSequenceName(i)
        for _,s in pairs(t) do
            local l = string.len(s)
            local b = string.sub(m,1,2)
            if b == s then a = true break end
        end
        if a then
            sequenceDropdown:AddChoice(m)
        end
    end

    sequenceDropdown.OnSelect = function(panel, index, value)
        local seqID = mdlPanel.Entity:LookupSequence(value)
        mdlPanel.Entity:ResetSequence(seqID)
        mdlPanel.Entity:SetCycle(0)
    end

    local cycleSlider = vgui.Create("DNumSlider", frame)
    cycleSlider:SetPos(50, 500)
    cycleSlider:SetSize(700, 50)
    cycleSlider:SetText("Animation Cycle")
    cycleSlider:SetMin(0)
    cycleSlider:SetMax(1)
    cycleSlider:SetDecimals(2)
    cycleSlider:SetValue(0)

    cycleSlider.OnValueChanged = function(panel, value)
        mdlPanel.Entity:SetCycle(value)
        mdlPanel.Entity:SetPlaybackRate(0) -- Freezes the animation at the selected cycle
    end
end)















local crystalColors = {}

crystalColors["Advanced Orange"] = {color = Color(255, 165, 0), innerColor = Color(255, 228, 181)}
crystalColors["Advanced Yellow"] = {color = Color(255, 255, 0), innerColor = Color(255, 255, 224)}
crystalColors["Advanced Green"] = {color = Color(0, 255, 0), innerColor = Color(144, 238, 144)}
crystalColors["Advanced Blue"] = {color = Color(0, 0, 255), innerColor = Color(173, 216, 230)}
crystalColors["Advanced Purple"] = {color = Color(128, 0, 128), innerColor = Color(221, 160, 221)}
crystalColors["Advanced Red"] = {color = Color(255, 0, 0), innerColor = Color(255, 99, 71)}
crystalColors["Gray"] = {color = Color(99, 99, 99), innerColor = Color(255, 255, 255)}
crystalColors["Advanced Black"] = {color = Color(0, 0, 0), innerColor = Color(105, 105, 105)}

crystalColors["Orange"] = {color = Color(255, 165, 0), innerColor = Color(255, 255, 255)}
crystalColors["Yellow"] = {color = Color(255, 255, 0), innerColor = Color(255, 255, 255)}
crystalColors["Green"] = {color = Color(0, 255, 0), innerColor = Color(255, 255, 255)}
crystalColors["Blue"] = {color = Color(0, 0, 255), innerColor = Color(255, 255, 255)}
crystalColors["Purple"] = {color = Color(128, 0, 128), innerColor = Color(255, 255, 255)}
crystalColors["Red"] = {color = Color(255, 0, 0), innerColor = Color(255, 255, 255)}
crystalColors["White"] = {color = Color(255, 255, 255), innerColor = Color(255, 255, 255)}
crystalColors["Black"] = {color = Color(0, 0, 0), innerColor = Color(255, 255, 255)}
crystalColors["Pink"] = {color = Color(255, 105, 180), innerColor = Color(255, 255, 255)}

crystalColors["Blood Red"] = {color = Color(177, 0, 0), innerColor = Color(255, 255, 255)}

crystalColors["Cyan"] = {color = Color(0, 255, 255), innerColor = Color(224, 255, 255)}
crystalColors["Magenta"] = {color = Color(255, 0, 255), innerColor = Color(255, 182, 193)}
crystalColors["Lime"] = {color = Color(50, 205, 50), innerColor = Color(144, 238, 144)}
crystalColors["Advanced Pink"] = {color = Color(255, 192, 203), innerColor = Color(255, 182, 193)}
crystalColors["Bronze"] = {color = Color(205, 127, 50), innerColor = Color(218, 165, 32)}

crystalColors["Viridian"] = {color = Color(64, 130, 109), innerColor = Color(143, 188, 143)}
crystalColors["Silver"] = {color = Color(192, 192, 192), innerColor = Color(220, 220, 220)}
crystalColors["Gold"] = {color = Color(255, 215, 0), innerColor = Color(255, 223, 0)}
crystalColors["Copper"] = {color = Color(184, 115, 51), innerColor = Color(210, 105, 30)}
crystalColors["Indigo"] = {color = Color(75, 0, 130), innerColor = Color(75, 0, 130)}

crystalColors["Orange Yellow"] = {color = Color(255, 204, 0), innerColor = Color(255, 255, 102)}
crystalColors["Teal"] = {color = Color(0, 128, 128), innerColor = Color(0, 206, 209)}
crystalColors["Azure"] = {color = Color(0, 127, 255), innerColor = Color(240, 248, 255)}
crystalColors["Amethyst"] = {color = Color(153, 102, 204), innerColor = Color(216, 191, 216)}
crystalColors["Rose"] = {color = Color(255, 102, 204), innerColor = Color(255, 182, 193)}

crystalColors["Chartreuse"] = {color = Color(127, 255, 0), innerColor = Color(240, 255, 240)}
crystalColors["Scarlet"] = {color = Color(255, 36, 0), innerColor = Color(250, 128, 114)}
crystalColors["Lavender"] = {color = Color(230, 230, 250), innerColor = Color(255, 240, 245)}
crystalColors["Crimson"] = {color = Color(220, 20, 60), innerColor = Color(255, 99, 71)}
crystalColors["Turquoise"] = {color = Color(64, 224, 208), innerColor = Color(175, 238, 238)}





local crystalModels = {
    "models/zhrom/Adegan_Crystal.mdl",
    "models/zhrom/Dragite_Crystal.mdl",
    "models/zhrom/Focus_Crystal.mdl",
    "models/zhrom/Kaiburr_Crystal.mdl",
    "models/zhrom/Katak_Crystal.mdl",
    "models/zhrom/Rubat_Crystal.mdl",
    "models/zhrom/Solari_Crystal.mdl",
    "models/zhrom/Vexxtal_Crystal.mdl"
}

crystalEntities = crystalEntities or {}
for _, ent in ipairs(crystalEntities) do
    if IsValid(ent) then ent:Remove() end
end

local crystalData = {
    radius = 35,
    speed = 1,
    height = 1,
    colors = {
        Color(255, 0, 0),
        Color(255, 127, 0),
        Color(255, 255, 0),
        Color(0, 255, 0),
        Color(0, 0, 255),
        Color(75, 0, 130),
        Color(148, 0, 211),
        Color(0, 0, 0),
        Color(139, 69, 19),
        Color(255, 255, 255),
        Color(128, 128, 128)
    }
}

local texts = {}

local nnn = 0
hook.Add("Think", "RotateCrystals", function()/*
    for _, ent in ipairs(crystalEntities) do
        if IsValid(ent) then ent:Remove() end
    end

    crystalEntities = {}

    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local eyePos = ply:EyePos() - ply:EyeAngles():Forward() * -64 + Vector(0, 0, 0)
    local aaa = ply:EyeAngles()
    local i = 0
    for k,v in pairs (crystalColors) do
        i=i+1
        local heightOffset = (i - 1) * crystalData.height
        --for j = 1, #crystalModels do
            

            local max = aaa:Right() * (58)
            local pos = eyePos + aaa:Right() * i*3 - max
            texts[k] = {}
            texts[k].name = k
            texts[k].color = v.color
            texts[k].innerColor = v.innerColor
            texts[k].pos = pos

            local ent = ClientsideModel("models/zhrom/Dragite_Crystal.mdl", RENDERGROUP_OPAQUE)
            texts[k].ent = ent
            if IsValid(ent) then
                ent:SetPos(pos)
                ent:SetAngles(Angle(0, angle, 0))
                ent:SetModelScale(1.5)
                ent:SetColor(v.color)
                table.insert(crystalEntities, ent)
            end
        --end
    end*/
end)

local blade2 = Material("hydrasabers/blades/normal.png", "noclamp smooth")
local blade1 = Material("hydrasabers/blades/normal.png", "noclamp smooth")
local glow = Material("hydrasabers/glows/normal.png", "noclamp smooth")
hook.Add( "PostDrawTranslucentRenderables", "422g", function()
   /* local ply = LocalPlayer()
    for k,v in pairs(texts) do
        local sizeW = 0.75
        local sizeH = 16
        local pad = 8
        local fuzz = 2

        local ang = ply:EyeAngles()
        local z = 0
        local offset = ang:Up() * 2 + ang:Up() * -0.75 + ang:Right() * -z

        local pp = v.pos + offset

        render.SetMaterial(glow)
        render.DrawBeam( pp, pp + Vector(0,0,sizeH*(fuzz/2) +0.2), sizeW*fuzz, 1, 0, v.color)

        render.SetMaterial(blade1)
        render.DrawBeam( pp, pp + Vector(0,0,sizeH), sizeW, 1, 0, v.innerColor)
        
        render.SetMaterial(glow)
        render.DrawBeam( pp, pp - Vector(0,0,sizeH*(fuzz/2) +0.2), sizeW*fuzz, 1, 0, v.color)

        render.SetMaterial(blade2)
        render.DrawBeam( pp, pp - Vector(0,0,sizeH), sizeW, 1, 0, Color(0,0,0))
        
        --render.DrawBeam( v.pos + Vector(0,0,fuzz), v.pos + Vector(0,0,sizeH + fuzz), sizeW*1.1, 1, 0, v.innerColor )
    end*/
end)


surface.CreateFont( "sss", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 12,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


hook.Add("HUDPaint", "824", function()
    /*local mode = true
    for k,v in pairs(texts) do
        mode = not mode
        local pos = v.pos:ToScreen()

        if mode then pos.y = pos.y + 16 end

        draw.DrawText(v.name, "sss", pos.x, pos.y+16, color_white, TEXT_ALIGN_CENTER)

        local sizeW = 16
        local sizeH = 64
        local pad = 8
        local fuzz = 1.5
        
        --draw.RoundedBox(sizeW/2, pos.x, pos.y - sizeH - pad, sizeW, sizeH, v.color)
        --draw.RoundedBox((sizeW-(fuzz/2))/2, pos.x + (fuzz/2), pos.y - sizeH - pad + (fuzz/2), sizeW-fuzz, sizeH-fuzz, v.innerColor)

        --render.SetMaterial(zmat("hydrasabers/glows/normal.png"))
       -- render.DrawBeam( v.pos, v.pos + Vector(0,0,sizeH), sizeW+4, 1, 0, v.color)
        
        --render.SetMaterial(blade)
        --render.DrawBeam( v.pos + Vector(0,0,fuzz), v.pos + Vector(0,0,sizeH + fuzz), sizeW*3, 1, 0, v.innerColor )

    end*/
end)
