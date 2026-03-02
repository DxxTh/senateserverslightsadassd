lts = lts or {}

local bg = Material("skill/menu.png")
local tree = Material("lordtyler/forcetree_tree.png")
local blip = Material("lordtyler/forcetree_icon.png")

local fontSize = 120

surface.CreateFont("abilityPoints", {
	font = "Arial",
	size = ScreenScale(fontSize),
	weight = 500,
	antialias = true,
})
surface.CreateFont("abilityPoints2", {
	font = "Arial",
	size = ScreenScale(fontSize),
	weight = 500,
	blursize = 16,
	antialias = true,
})


surface.CreateFont("abilityPointsText", {
	font = "Arial",
	size = ScreenScale(fontSize/8),
	weight = 500,
	antialias = true,
})
surface.CreateFont("abilityPointsText2", {
	font = "Arial",
	size = ScreenScale(fontSize/8),
	weight = 500,
	blursize = 16,
	antialias = true,
})


surface.CreateFont("abilityName", {
	font = "Arial",
	size = ScreenScale(fontSize/6),
	weight = 500,
	antialias = true,
})
surface.CreateFont("abilityName2", {
	font = "Arial",
	blursize = 16,
	size = ScreenScale(fontSize/6),
	weight = 500,
	antialias = true,
})



surface.CreateFont("abilityDesc", {
	font = "Arial",
	size = ScreenScale(fontSize/12),
	weight = 500,
	antialias = true,
})
surface.CreateFont("abilityDesc2", {
	font = "Arial",
	blursize = 16,
	size = ScreenScale(fontSize/12),
	weight = 500,
	antialias = true,
})





function lts.forceMenu(powers)
	if LTS_SKILL_TREE then LTS_SKILL_TREE:Remove() end
	local s = 1
	local fw, fh = ScrW()*0.9, ScrH()*0.8
	local f = vgui.Create("DFrame")
	f:SetSize(fw,fh)
	f:Center()
	f:SetTitle("")
	f:SetDraggable(false)
	f:MakePopup()
	LTS_SKILL_TREE = f
	function f:Paint(ww,hh)
		self.ww = ww
		self.hh = hh
		surface.SetDrawColor(255,255,255)
		
		surface.SetMaterial(bg)
		surface.DrawTexturedRect(0,0,ww,hh)
		
		--surface.SetDrawColor(255,255,255,50	)
		--surface.SetMaterial(tree)
		--surface.DrawTexturedRect(0,0,ww,hh)
		
		
		
		/*
		local xx, yy = 0.5, 0.825 -- Base "zeros" of your grid
		local spacing = 0.035      -- Grid spacing
		
		surface.SetDrawColor(255, 255, 255, 25) -- Set the draw color to white

		-- Set the font for the numbers
		surface.SetFont("enigma_12")
		local textColor = Color(255, 255, 255, 25)

		-- Draw vertical grid lines from x = -10 to x = 10
		for x = -20, 20, 0.5 do
			local xpos = (xx + x * spacing) * ww
			
			local isInteger = x % 1 == 0

			if isInteger then
				surface.SetDrawColor(255, 255, 255, 10) -- Main grid line
			else
				surface.SetDrawColor(255, 255, 255, 3) -- Subgrid line
			end
			
			surface.DrawLine(xpos, 0, xpos, hh)

			-- Draw the x-axis numbers below the grid
			local text = tostring(x)
			local textWidth, textHeight = surface.GetTextSize(text)
			surface.SetTextColor(textColor)
			surface.SetTextPos(xpos - textWidth / 2, (yy * hh) + 5) -- Slight offset downward
			surface.DrawText(text)
		end

		-- Draw horizontal grid lines from y = -10 to y = 10
		for y = -20, 20 do
			local ypos = (yy - y * spacing) * hh
			surface.DrawLine(0, ypos, ww, ypos)

			-- Draw the y-axis numbers to the left of the grid
			local text = tostring(y)
			local textWidth, textHeight = surface.GetTextSize(text)
			surface.SetTextColor(textColor)
			surface.SetTextPos((xx * ww) - textWidth - 5, ypos - textHeight / 2) -- Slight offset to the left
			surface.DrawText(text)
		end
			*/
		
		if input.IsKeyDown(KEY_F4) then
			local mx, my = gui.MousePos()
			local lx, ly = self:ScreenToLocal(mx, my)
			
			surface.SetDrawColor(255,25,25,255)
			
			surface.DrawRect(0,ly,ww,1)
			surface.DrawRect(lx,0,1,hh)
			
			local hperc = math.Round(ly / fh, 3)
			local wperc = math.Round(lx / fw, 3)
			
			surface.SetFont( "Default" )
			surface.SetTextColor( 0, 0, 0 )
			surface.SetTextPos( mx + 25 -1, my + 25 + 1 ) 
			surface.DrawText( "X: " .. wperc )
			
			surface.SetTextColor( 255, 25, 25 )
			surface.SetTextPos( mx + 25, my + 25 ) 
			surface.DrawText( "X: " .. wperc )
			
			surface.SetTextColor( 0, 0, 0 )
			surface.SetTextPos( mx + 50  -1, my + 50 + 1 ) 
			surface.DrawText( "Y: " .. hperc )
			
			surface.SetTextColor( 255, 25, 25 )
			surface.SetTextPos( mx + 50, my + 50 ) 
			surface.DrawText( "Y: " .. hperc )
		end
		
		local ply = LocalPlayer()
		local pt = ply:GetNW2String("team", "")
		local bs = 32
		local pdd = 0.875
		local points = LocalPlayer():getSkillPoints()
		draw.DrawText(points, "enigma_48", fw/2, fh*pdd + 32, Color(255,255,255), TEXT_ALIGN_CENTER)

		draw.DrawText("Ability Points", "enigma_32_blur", fw/2, fh*pdd, Color(0,255,255), TEXT_ALIGN_CENTER)
		draw.DrawText("Ability Points", "enigma_32", fw/2, fh*pdd, Color(255,255,255), TEXT_ALIGN_CENTER)

		local name = ""
		local desc = ""
		
		local powerPos = {}
		
		for k,t in pairs(lts.getPowers()) do
			local x = (ww*t.x)+2-(bs/2)
			local y = (hh*t.y)+2-(bs/2)
			local s = bs-4
			powerPos[k] = {x=x,y=y}
		end
		
		for k,t in pairs(lts.getPowers()) do
			--if t.allowed[pt] then
				surface.SetDrawColor(100,100,35,255)
				for _,d in pairs(t.requires) do
					if powerPos[d] then
						surface.DrawLine(powerPos[k].x + bs/2 - 2, powerPos[k].y + bs/2 - 2, powerPos[d].x + bs/2 - 2, powerPos[d].y + bs/2 - 2)
					end
				end
			--end
		end
		
		for k,t in pairs(lts.getPowers()) do
			--if t.allowed["Sith"] and t.allowed["Jedi"] then
			--if t.allowed[pt] then
				local hasLearned = false
				
				
				surface.SetDrawColor(175,0,0,255)
				
				if powers[k] then
					hasLearned = true
					surface.SetDrawColor(0,200,0,255)
				end
				
				local canLearn = true
				if not hasLearned then
					for a,b in pairs(t.requires) do
						if not powers[b] then
							canLearn = false
							break
						end
					end
					if canLearn then
						surface.SetDrawColor(200,200,100,255)
					end
				end
				
				local mx, my = gui.MousePos()
				local lx, ly = self:ScreenToLocal(mx, my)
				
				local minW = (ww*t.x)-(bs/2)
				local maxW = minW + bs
				
				local minH = (hh*t.y)-(bs/2)
				local maxH = minH + bs
				
				
				
				if lx >= minW and lx <= maxW and ly >= minH and ly <= maxH then
					name = t.name
					desc = t.desc
					if t.passive then
						name = name .. " (passive)"
					end
				end
			
				
				--surface.SetTextColor( 255, 255, 255 )
				--surface.SetFont("Default")
				--surface.SetTextPos((ww*t.x)-(bs/2),(hh*t.y)-(bs/2) - 25)
				
				--draw.DrawText(t.name, "enigma_16_blur", (ww*t.x), (hh*t.y)+16, Color(0,255,255), TEXT_ALIGN_CENTER)
				
				if hasLearned then
					draw.DrawText(t.name, "conthrax_8", (ww*t.x), (hh*t.y)+16, Color(255,255,255), TEXT_ALIGN_CENTER)
				else
					if canLearn then
						draw.DrawText(t.name, "conthrax_8", (ww*t.x), (hh*t.y)+16, Color(200,200,100), TEXT_ALIGN_CENTER)
					else
						draw.DrawText(t.name, "conthrax_8", (ww*t.x), (hh*t.y)+16, Color(177,0,0), TEXT_ALIGN_CENTER)
					end
				end
				
				
				
				--surface.DrawText(t.name)
				local alpha = 255
				if not canLearn then alpha = 200 end
				
				surface.DrawRect((ww*t.x)-(bs/2),(hh*t.y)-(bs/2),bs,bs)
				
				
				surface.SetDrawColor(alpha,alpha,alpha,alpha)
				surface.SetMaterial(mat(t.icon))
				surface.DrawTexturedRect((ww*t.x)+2-(bs/2),(hh*t.y)+2-(bs/2),bs-4,bs-4)
				
				if t.passive then
					--draw.DrawText("P", "capt_28_blur", (ww*t.x),(hh*t.y)-14, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					--draw.DrawText("P", "capt_20", (ww*t.x),(hh*t.y)-14, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			
				
			
				
				
				draw.DrawText(name, "enigma_20_blur", 50, 25, Color(0,0,0), TEXT_ALIGN_LEFT)
				draw.DrawText(name, "enigma_20", 50, 25, Color(5,255,255), TEXT_ALIGN_LEFT)

				draw.DrawText(desc, "enigma_16_blur", 50, 60, Color(0,0,0), TEXT_ALIGN_LEFT)
				draw.DrawText(desc, "enigma_16", 50, 60, Color(255,255,255), TEXT_ALIGN_LEFT)

			--end
		end
	end
	
	function f:Think()
		self.ww = self.ww or 0
		self.hh = self.hh or 0
		local ply = LocalPlayer()
		local pt = ply:GetNW2String("team", "")
		if not self.clicking then
			if input.IsMouseDown(MOUSE_LEFT) then
				local mx, my = gui.MousePos()
				local lx, ly = self:ScreenToLocal(mx, my)
				for k,t in pairs(lts.getPowers()) do
					--if t.allowed["Sith"] and t.allowed["Jedi"] then
					--if t.allowed[pt] then
						local bs = 78*0.75
						
						local minW = (self.ww*t.x)-(bs/2)
						local maxW = minW + bs
						
						local minH = (self.hh*t.y)-(bs/2)
						local maxH = minH + bs
						
						
						
						if lx >= minW and lx <= maxW and ly >= minH and ly <= maxH then
							net.Start("lts.skilltree")
								net.WriteString(k)
							net.SendToServer()
						end
					--end
				end
				self.clicking = true
			end
		else
			if not input.IsMouseDown(MOUSE_LEFT) then
				self.clicking = false
			end
		end
		if input.IsKeyDown(KEY_F4) then
			local mx, my = gui.MousePos()
			local lx, ly = self:ScreenToLocal(mx, my)
			local hperc = math.Round(ly / fh, 3)
			local wperc = math.Round(lx / fw, 3)
			
			local obj = {}
			obj.x = wperc
			obj.y = hperc

			if input.IsMouseDown(MOUSE_LEFT) then
				--SetClipboardText("x=" .. wperc .. ",y=" .. hperc .. ",")
				SetClipboardText("powerSetPos(\"\", " .. wperc .. ", " .. hperc .. ")")
			end
		end
	end
end

function lts.powerBar(powers)
	if LTS_SKILL_TREE then LTS_SKILL_TREE:Remove() end
	local s = 1
	local fw, fh = ScrW()*0.9, ScrH()*0.8
	
	local f2 = vgui.Create("DFrame")
	f2:SetSize(ScrW(),ScrH())
	f2:SetPos(0,0)
	f2:CenterHorizontal()
	f2:SetTitle("")
	f2:SetDraggable(false)
	f2:ShowCloseButton(false)
	f2:MakePopup()
	
	local bw = 616
	local bh = 96
	
	function f2:Paint(ww,hh)
		--surface.SetDrawColor(225,225,255,555)
		--surface.SetMaterial(lts.mat("materials/big_button.png"))
		--surface.DrawTexturedRect(0,0,bw,bh)
	end
	
	local f = vgui.Create("DPanel", f2)
	f:SetSize(fw,fh)
	f:Center()
	
	local x = vgui.Create("DButton", f)
	x:SetText("X")
	x:SetPos(fw-64,0)
	x:SetSize(64,24)
	function x:Paint(ww,hh)
		surface.SetDrawColor(0,255,255)
		surface.DrawRect(0,0,ww,hh)
	end
	
	function x:DoClick()
		f2:Remove()
	end
	
	f.selectedPower = 1
	LTS_SKILL_TREE = f
	
	function f:OnRemove()
		f2:Remove()
	end

	for i=1,9 do
		local is = 48
		local b = vgui.Create("DButton", f2)
		b:SetPos(ScrW() / 2 - 987 / 2 + ((i-1)*(is+14)) + 177, ScrH() - 116 + 28)
		b:SetSize(48,48)
		b:SetText("")
		
		function b:Paint(ww,hh)
			if powerList[i] then
				local power = lts.forcePowers[powerList[i]]
				if power then
					surface.SetDrawColor(225,225,255,255)
					surface.SetMaterial(lts.mat(power.icon))
					surface.DrawTexturedRect(0,0,ww,hh)
				end
			else
				surface.SetDrawColor(225,225,255,100)
				surface.SetMaterial(lts.mat("materials/hfgjvs/torcom/item_grade_26.png"))
				surface.DrawTexturedRect(0,0,ww,hh)
			end
			
			if f.selectedPower == i then
				surface.SetDrawColor(0,225,255,255)
				surface.SetMaterial(lts.mat("hfgjvs/torcom/grunge.png"))
				surface.DrawTexturedRect(0,0,ww,hh)
				surface.SetDrawColor(225,225,255,255)
				surface.SetMaterial(lts.mat("hfgjvs/torcom/item_grade_17.png"))
				surface.DrawTexturedRect(0,0,ww,hh)
			end
		end
		
		function b:DoClick()
			f.selectedPower = i
		end
		
		function b:DoRightClick()
			powerList[i]=nil
		end
		
	end
	
	
	function f:Paint(ww,hh)
		self.ww = ww
		self.hh = hh
		surface.SetDrawColor(255,255,255)
		
		surface.SetMaterial(bg)
		surface.DrawTexturedRect(0,0,ww,hh)
		
		--surface.SetDrawColor(255,255,255,50	)
		--surface.SetMaterial(tree)
		--surface.DrawTexturedRect(0,0,ww,hh)
		
		
		
		
		local xx, yy = 0.5, 0.825 -- Base "zeros" of your grid
		local spacing = 0.035      -- Grid spacing
		
		surface.SetDrawColor(255, 255, 255, 25) -- Set the draw color to white

		-- Set the font for the numbers
		surface.SetFont("conthrax_8")
		local textColor = Color(255, 255, 255, 25)
		/*
		-- Draw vertical grid lines from x = -10 to x = 10
		for x = -20, 20, 0.5 do
			local xpos = (xx + x * spacing) * ww
			
			local isInteger = x % 1 == 0

			if isInteger then
				surface.SetDrawColor(255, 255, 255, 10) -- Main grid line
			else
				surface.SetDrawColor(255, 255, 255, 3) -- Subgrid line
			end
			
			surface.DrawLine(xpos, 0, xpos, hh)

			-- Draw the x-axis numbers below the grid
			local text = tostring(x)
			local textWidth, textHeight = surface.GetTextSize(text)
			surface.SetTextColor(textColor)
			surface.SetTextPos(xpos - textWidth / 2, (yy * hh) + 5) -- Slight offset downward
			surface.DrawText(text)
		end

		-- Draw horizontal grid lines from y = -10 to y = 10
		for y = -20, 20 do
			local ypos = (yy - y * spacing) * hh
			surface.DrawLine(0, ypos, ww, ypos)

			-- Draw the y-axis numbers to the left of the grid
			local text = tostring(y)
			local textWidth, textHeight = surface.GetTextSize(text)
			surface.SetTextColor(textColor)
			surface.SetTextPos((xx * ww) - textWidth - 5, ypos - textHeight / 2) -- Slight offset to the left
			surface.DrawText(text)
		end
			*/
		
		
		local ply = LocalPlayer()
		local pt = ply:GetNW2String("team", "")
		local bs = 32
		local pdd = 0.875
		
		local name = ""
		local desc = ""
		
		local powerPos = {}
		
		for k,t in pairs(lts.getPowers()) do
			local x = (ww*t.x)+2-(bs/2)
			local y = (hh*t.y)+2-(bs/2)
			local s = bs-4
			powerPos[k] = {x=x,y=y}
		end
		
		for k,t in pairs(lts.getPowers()) do
			--if t.allowed["Sith"] and t.allowed["Jedi"] then
			--if t.allowed[pt] then
				surface.SetDrawColor(100,100,35,255)
				for _,d in pairs(t.requires) do
					if powerPos[d] then
						surface.DrawLine(powerPos[k].x + bs/2 - 2, powerPos[k].y + bs/2 - 2, powerPos[d].x + bs/2 - 2, powerPos[d].y + bs/2 - 2)
					end
				end
			--end
		end
		
		for k,t in pairs(lts.getPowers()) do
			--if t.allowed["Sith"] and t.allowed["Jedi"] then
			--if t.allowed[pt] then
				local hasLearned = false
				
				
				surface.SetDrawColor(175,0,0,255)
				
				if powers[k] then
					hasLearned = true
					surface.SetDrawColor(0,200,0,255)
				end
				
				local canLearn = true
				if not hasLearned then
					for a,b in pairs(t.requires) do
						if not powers[b] then
							canLearn = false
							break
						end
					end
					if canLearn then
						surface.SetDrawColor(200,200,100,255)
					end
				end
				
				local mx, my = gui.MousePos()
				local lx, ly = self:ScreenToLocal(mx, my)
				
				local minW = (ww*t.x)-(bs/2)
				local maxW = minW + bs
				
				local minH = (hh*t.y)-(bs/2)
				local maxH = minH + bs
				
				
				
				if lx >= minW and lx <= maxW and ly >= minH and ly <= maxH then
					name = t.name
					desc = t.desc
					if t.passive then
						name = name .. " (passive)"
					end
				end
			
				
				if hasLearned then
					draw.DrawText(t.name, "conthrax_8", (ww*t.x), (hh*t.y)+16, Color(255,255,255), TEXT_ALIGN_CENTER)
				else
					if canLearn then
						draw.DrawText(t.name, "conthrax_8", (ww*t.x), (hh*t.y)+16, Color(200,200,100), TEXT_ALIGN_CENTER)
					else
						draw.DrawText(t.name, "conthrax_8", (ww*t.x), (hh*t.y)+16, Color(177,0,0), TEXT_ALIGN_CENTER)
					end
				end
				
				local alpha = 255
				if not canLearn then alpha = 200 end
				
				surface.DrawRect((ww*t.x)-(bs/2),(hh*t.y)-(bs/2),bs,bs)
				
				
				surface.SetDrawColor(alpha,alpha,alpha,alpha)
				surface.SetMaterial(mat(t.icon))
				surface.DrawTexturedRect((ww*t.x)+2-(bs/2),(hh*t.y)+2-(bs/2),bs-4,bs-4)
				
				draw.DrawText(name, "enigma_20_blur", 50, 25, Color(0,0,0), TEXT_ALIGN_LEFT)
				draw.DrawText(name, "enigma_20", 50, 25, Color(5,255,255), TEXT_ALIGN_LEFT)

				draw.DrawText(desc, "enigma_16_blur", 50, 60, Color(0,0,0), TEXT_ALIGN_LEFT)
				draw.DrawText(desc, "enigma_16", 50, 60, Color(255,255,255), TEXT_ALIGN_LEFT)

			--end
		end
	end
	
	function f:Think()
		self.ww = self.ww or 0
		self.hh = self.hh or 0
		local ply = LocalPlayer()
		local pt = ply:GetNW2String("team", "")
		if not self.clicking then
			if input.IsMouseDown(MOUSE_LEFT) then
				local mx, my = gui.MousePos()
				local lx, ly = self:ScreenToLocal(mx, my)
				for k,t in pairs(lts.getPowers()) do
					--if t.allowed["Sith"] and t.allowed["Jedi"] then
					--if t.allowed[pt] then
						local bs = 78*0.75
						
						local minW = (self.ww*t.x)-(bs/2)
						local maxW = minW + bs
						
						local minH = (self.hh*t.y)-(bs/2)
						local maxH = minH + bs
						
						if lx >= minW and lx <= maxW and ly >= minH and ly <= maxH then
							net.Start("lts.power.swap")
								net.WriteInt(f.selectedPower,8)
								net.WriteString(k)
							net.SendToServer()
							powerList[f.selectedPower]=k
						end
					--end
				end
				self.clicking = true
			end
		else
			if not input.IsMouseDown(MOUSE_LEFT) then
				self.clicking = false
			end
		end
		if input.IsKeyDown(KEY_F4) then
			local mx, my = gui.MousePos()
			local lx, ly = self:ScreenToLocal(mx, my)
			local hperc = math.Round(ly / fh, 3)
			local wperc = math.Round(lx / fw, 3)
			
			local obj = {}
			obj.x = wperc
			obj.y = hperc

			if input.IsMouseDown(MOUSE_LEFT) then
				--SetClipboardText("x=" .. wperc .. ",y=" .. hperc .. ",")
				SetClipboardText("powerSetPos(\"\", " .. wperc .. ", " .. hperc .. ")")
			end
		end
	end
end


local meta = FindMetaTable("Player")
function meta:getSkillPoints()
	return self:GetNWInt("skillpoints", 0)
end

net.Receive("lts.skilltree", function()
	local t = net.ReadTable()
	lts.forceMenu(t)
end)

net.Receive("lts.powerbar", function()
	local t = net.ReadTable()
	lts.powerBar(t)
end)