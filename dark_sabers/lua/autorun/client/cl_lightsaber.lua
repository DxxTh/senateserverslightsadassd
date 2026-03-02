player_sabers = player_sabers or {}
local meta = FindMetaTable("Player")


net.Receive("tyler.saber", function()
	local ply = net.ReadEntity()
	local data = net.ReadTable()
	ply:applybullshit(data)
	addAlert("Updated lightsaber for " .. ply:Nick())
end)

function meta:applybullshit(d)
    player_sabers[self:SteamID()] = d
    for k, v in pairs(d) do
        local m = v.tex .. v.mat .. v.dye .. ".png"
		print(m)
        registerMaterial(m)
    end

end

function dumpTable(tbl)
    local json = util.TableToJSON(tbl, true) -- Convert the table to JSON (pretty --printed)
    SetClipboardText(json) -- Copy the JSON to the clipboard
    --print("Table copied to clipboard as JSON.")
end


concommand.Add("lts.saberdata", function(ply, cmd, args)
	dumpTable(player_sabers)
end)

local grip2 = "models/lordtyler/lightsaberweaponsgrpgeometricallgrip.mdl"
local emitter = "models/lordtyler/lightsaberweaponsgrpgeometricalemitter.mdl"
local switch = "models/lordtyler/lightsaberweaponsgrpgeometricalrswitch.mdl"
local pommel = "models/lordtyler/lightsaberweaponsgrpgeometricalpommel.mdl"
local ring = "models/lordtyler/lightsaberweaponsgrpgeometricalheavyring.mdl"
local base = "models/lordtyler/lightsaberweaponsgrpgeometricalrgrip.mdl"


local kyber = "models/redgun/crystalgun.mdl"
local tuning = "models/tuning/tuning.mdl"
local heatsink = "models/heat/heat.mdl"
local mod = "models/modgun/modgun.mdl"
local battery = "models/batt/batt.mdl"

local test = Material("models/lordtyler/test.png")

local pos

local c = 0

local currentFakeMat = "lordtyler_MI_LightsaberWeaponsGrpCalSwitch_steel_rusted_brass.png"

local saberEditing = false
local pressingF3
local isMouseClicking

local saberButtons = {}
local lerps = {}
local lerpsa = {}

hook.Add("Think", "309242", function()
	if saberEditing then
		if input.IsMouseDown(MOUSE_LEFT) then
			if not isMouseClicking then
				for k,v in pairs(saberButtons) do
					if mouseIsOnButton(v.x,v.y,v.w,v.h) then
						v.func()
					end
				end
				isMouseClicking = true
			end
		else
			isMouseClicking = false
		end
	end

	if not pressingF3 then
		if input.IsKeyDown(KEY_F4) then
			pressingF3 = true
			saberEditing = true
			lerps = {}
			lerpsa = {}
			gui.EnableScreenClicker(true)
		end
	else
		if not input.IsKeyDown(KEY_F4) then
			if saberEditing then
				gui.EnableScreenClicker(false)
				pressingF3 = false
				saberEditing = false
			end
		end
	end
end)

function mouseIsOnButton(x,y,w,h)
	local mx = gui.MouseX()
	local my = gui.MouseY()
	return mx>=x and mx<=(x+w) and my>=y and my<=(y+h)
end

local mats = {
	"steel_brushed_",
	"steel_scratched_",
	"steel_rusted_",
	"steel_hammered_",
	"wood_walnut_",
	"wood_pine_",
	"flat_polymer_",
	"glossy_polymer_",
	"leather_red_",
	"leather_black_",
	"wrap_demascus_",
	"wrap_leaf_",
	"wrap_tech_",
	"wrap_wood_",
}

local dyes = {
	"bloodred",
	"bluesteel",
	"brass",
	"bronze",
	"cobalt",
	"gold",
	"gunmetal",
	"inquisitive",
	"nodye",
	"rosepink",
	"sage",
	"sinisterblack",
	"titanium",
}

local bladeMaterialIndex = 1
local bladeDyeIndex = 1

local emitterMaterialIndex = 1
local emitterDyeIndex = 1

local pommelMaterialIndex = 1
local pommelDyeIndex = 1

local switchMaterialIndex = 1
local switchDyeIndex = 1


playerSaberModels = playerSaberModels or {}

hook.Add("PostDrawTranslucentRenderables", "DrawLocalPlayerSaber", function()
	for _,ply in pairs(player.GetAll()) do
		local steamID = ply:SteamID()
		local saberData = player_sabers[steamID]
		if saberData and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "tyler_saber" then
			playerSaberModels[steamID] = playerSaberModels[steamID] or {}

			-- Get or create the models
			saberData.blade = saberData.blade or "models/balloons/balloon_dog.mdl"
			local base = playerSaberModels[steamID].base or ClientsideModel(saberData.blade.mdl)
			local emitter = playerSaberModels[steamID].emitter or ClientsideModel(saberData.emitter.mdl)
			local switch = playerSaberModels[steamID].switch or ClientsideModel(saberData.switch.mdl)
			local pommel = playerSaberModels[steamID].pommel or ClientsideModel(saberData.pommel.mdl)

			-- Save them in the table
			playerSaberModels[steamID].base = base
			playerSaberModels[steamID].emitter = emitter
			playerSaberModels[steamID].switch = switch
			playerSaberModels[steamID].pommel = pommel
			
			
			local bone = ply:LookupBone("ValveBiped.Bip01_R_Hand") or 0
			local pos, ang = ply:GetBonePosition(bone)
			
			--local pos2 = pos + ang:Forward() * 3 + ang:Up() * 2 + ang:Right() * 1.5
			--lts.bladeLines(ply, ply:GetActiveWeapon(), pos2, ang, 35)
			
			pos = pos + ang:Forward() * 3 + ang:Up() * 2 + ang:Right() * 1.5
			ang:RotateAroundAxis(ang:Right(), 180)
			--ang:RotateAroundAxis(ang:Right(), FrameTime() * 10)
			
			
			

			
			
			
			--ply.kyber:SetModel(crystal.model)
			--ply.kyber:SetColor(crystal.color)
			
			-- Position and angle
			local viewPos = pos
			local viewAng = ang
			local forward = viewAng:Forward()
			local right = viewAng:Right()
			local up = viewAng:Up()

			-- Extract positioning data from the saber data table
			local baseData = saberData.blade
			local emitterData = saberData.emitter
			local switchData = saberData.switch
			local pommelData = saberData.pommel
			
			if string.len(ply:GetActiveWeapon():GetNW2String("legacyModel", "")) <= 0  and type(baseData) == "table" then
				
				baseData = baseData or {}
				base:SetPos(viewPos + forward * baseData.angs.forward + right * baseData.angs.right + up * baseData.offset)
				base:SetModel(baseData.mdl)
				base:SetModelScale(1)
				base:SetAngles(viewAng)
				base:SetNoDraw(false)
				base:SetMaterial("")
				local texture = baseData.tex .. baseData.mat .. baseData.dye
				base:SetMaterial("!" .. texture)
				base:SetParent(nil)
				base:RemoveEffects(EF_BONEMERGE)

				emitter:SetPos(viewPos + forward * emitterData.angs.forward + right * emitterData.angs.right + up * emitterData.offset)
				emitter:SetModel(emitterData.mdl)
				emitter:SetAngles(viewAng)
				emitter:SetNoDraw(false)
				emitter:SetMaterial("")
				local texture = emitterData.tex .. emitterData.mat .. emitterData.dye
				emitter:SetMaterial("!" .. texture)

				switch:SetPos(viewPos + forward * switchData.angs.forward + right * switchData.angs.right + up * switchData.offset)
				switch:SetModel(switchData.mdl)
				switch:SetAngles(viewAng)
				switch:SetNoDraw(false)
				switch:SetMaterial("")
				local texture = switchData.tex .. switchData.mat .. switchData.dye
				switch:SetMaterial("!" .. texture)

				pommel:SetPos(viewPos + forward * pommelData.angs.forward + right * pommelData.angs.right + up * pommelData.offset)
				pommel:SetModel(pommelData.mdl)
				pommel:SetAngles(viewAng)
				pommel:SetNoDraw(false)
				pommel:SetMaterial("")
				local texture = pommelData.tex .. pommelData.mat .. pommelData.dye
				pommel:SetMaterial("!" .. texture)
			else
				base:SetModelScale(2)
				base:SetPos(pos)
				base:SetModel(ply:GetActiveWeapon():GetNW2String("legacyModel", ""))
				base:SetAngles(viewAng)
				base:SetNoDraw(false)
				base:SetMaterial("")
				base:SetParent(ply)
				base:AddEffects(EF_BONEMERGE)
				emitter:SetNoDraw(true)
				pommel:SetNoDraw(true)
				switch:SetNoDraw(true)
			end
			
			local tunerID = ply:GetActiveWeapon():GetNW2String("powerTunerItem", "")
			local crystalID = ply:GetActiveWeapon():GetNW2String("crystalItem", "")
			
			local crystal = lts.item.list[crystalID]
			local tuner = lts.item.list[tunerID]
			
			--if ply == LocalPlayer() then
				--print(tostring(crystalID), tostring(tunerID), tostring(crystal), tostring(tuner))
			--end
			
			if tuner and crystal then
				local len = -tuner.bladeLength
				local thickness = 0.5
				
				if not ply:GetActiveWeapon():GetNW2Bool("enabled") then
					len = 0
				end

				ply:GetActiveWeapon().targetLen = len
				ply:GetActiveWeapon().curLen = ply:GetActiveWeapon().curLen or len
				ply:GetActiveWeapon().curLen = Lerp(FrameTime() * 12, ply:GetActiveWeapon().curLen, len)

				local ang = emitter:GetAngles()
				local pos = emitter:GetPos() + emitter:GetUp() * 1
				
				if ply:GetActiveWeapon():GetNW2String("legacyModel", "") ~= "" then
					ang = base:GetAngles()
					pos = base:GetPos() + base:GetUp() * 4
				end
				
				if crystal and ply:GetActiveWeapon().curLen <= -0.1 then
					saberData.trail = saberData.trail or {}
					saberData.trail2 = saberData.trail2 or {}

					saberData.trail.pos = saberData.trail.pos or pos + ang:Up() * 1.5
					saberData.trail.tip = saberData.trail.tip or pos + ang:Up() * -ply:GetActiveWeapon().curLen

					saberData.trail2.pos = saberData.trail2.pos or pos + ang:Up() * 1.5
					saberData.trail2.tip = saberData.trail2.tip or pos + ang:Up() * -ply:GetActiveWeapon().curLen

					local spd = 32
					saberData.trail.pos = LerpVector(FrameTime()*spd, saberData.trail.pos, pos + ang:Up() * 1.5)
					saberData.trail.tip = LerpVector(FrameTime()*spd, saberData.trail.tip, pos + ang:Up() * -(ply:GetActiveWeapon().curLen + 1.5))

					saberData.trail2.pos = pos + ang:Up() * 1.5
					saberData.trail2.tip = pos + ang:Up() * -(ply:GetActiveWeapon().curLen + 1.5)
					
					
					
					
					
					if ply:GetActiveWeapon():GetNW2String("legacyModel", "") ~= "" then
						for id, t in ipairs( base:GetAttachments() or {} ) do
							if ( !string.match( t.name, "blade(%d+)" ) and !string.match( t.name, "quillon(%d+)" ) ) then continue end

							local bladeNum = string.match( t.name, "blade(%d+)" )
							local quillonNum = string.match( t.name, "quillon(%d+)" )
							local obj = base:LookupAttachment( "blade" .. bladeNum )
							local att = base:GetAttachment(obj)
							if (bladeNum and obj > 0 ) then
								local bladePos = att.Pos
								local bladeAng = att.Ang
								
								bladeAng:RotateAroundAxis(bladeAng:Right(), -90)
								
								render.SetMaterial(mat("hydrasabers/glows/normal.png"))
								render.DrawBeam( bladePos, bladePos + bladeAng:Up() * -ply:GetActiveWeapon().curLen, thickness+4, 1, 0, Color(crystal.color.r, crystal.color.g, crystal.color.b))
								render.SetMaterial(mat("hydrasabers/blades/normal.png"))
								render.DrawBeam( bladePos + bladeAng:Up() * -1.5, bladePos + bladeAng:Up() * -(ply:GetActiveWeapon().curLen+1.5), thickness*3, 1, 0, Color(crystal.innerColor.r, crystal.innerColor.g, crystal.innerColor.b) )
							end
						end
					end
					
					
					
					--render.SetMaterial(mat("hydrasabers/glows/normal.png"))
					--render.DrawBeam( pos, pos + ang:Up() * -ply:GetActiveWeapon().curLen, thickness+4, 1, 0, Color(crystal.color.r, crystal.color.g, crystal.color.b))
					
					local dlight = DynamicLight( ply:EntIndex() )
					if ( dlight ) then
						dlight.pos = pos + ang:Up() * -ply:GetActiveWeapon().curLen / 2
						dlight.r = crystal.color.r
						dlight.g = crystal.color.g
						dlight.b = crystal.color.b
						dlight.brightness = 1
						dlight.decay = 1000
						dlight.size = 256
						dlight.dietime = CurTime() + 1
					end
					
					local tip1 = saberData.trail.tip
					local tip2 = saberData.trail2.tip

					local pos1 = saberData.trail.pos
					local pos2 = saberData.trail2.pos
					
					local white = lts.mat("materials/slot_overlay.png")
					
					--render.SetMaterial(white)
					--render.DrawQuad(pos2, pos1, tip1, tip2, Color(crystal.innerColor.r, crystal.innerColor.g, crystal.innerColor.b))
					
					--render.SetMaterial(white)
					--render.DrawQuad(tip2, tip1, pos1, pos2, Color(crystal.innerColor.r, crystal.innerColor.g, crystal.innerColor.b))

					--render.SetMaterial(mat("hydrasabers/blades/normal.png"))
					--render.DrawBeam( pos + ang:Up() * -1.5, pos + ang:Up() * -(ply:GetActiveWeapon().curLen+1.5), thickness*3, 1, 0, Color(crystal.innerColor.r, crystal.innerColor.g, crystal.innerColor.b) )
					
					--render.SetMaterial(mat("cedi/lightsabers/blade/ener_eclair"))
					--render.DrawBeam( pos + ang:Up() * -1.5, pos + ang:Up() * -(ply:GetActiveWeapon().curLen+1.5), thickness*6, 1, 0, Color(crystal.innerColor.r, crystal.innerColor.g, crystal.innerColor.b))
				end
			end
		else
			playerSaberModels[steamID] = playerSaberModels[steamID] or {}
			if saberData then
				-- Get or create the models
				local base = playerSaberModels[steamID].base or ClientsideModel(saberData.blade.mdl)
				local emitter = playerSaberModels[steamID].emitter or ClientsideModel(saberData.emitter.mdl)
				local switch = playerSaberModels[steamID].switch or ClientsideModel(saberData.switch.mdl)
				local pommel = playerSaberModels[steamID].pommel or ClientsideModel(saberData.pommel.mdl)
				if IsValid(base) then
					base:SetNoDraw(true)
					emitter:SetNoDraw(true)
					pommel:SetNoDraw(true)
					switch:SetNoDraw(true)
				end
			end
		end
	end
end)
