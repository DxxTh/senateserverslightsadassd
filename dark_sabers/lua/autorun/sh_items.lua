lts = lts or {}

lts.item = {}
items = {}
lts.item.list = {}
lts.util = lts.util or {}

function lts.item.add(id, name, desc, mdl, cat, data, funcs)
    local ITEM = {}
    ITEM.name = name
    ITEM.description = desc
    ITEM.category = cat
    ITEM.model = mdl
	ITEM.funcs = funcs or {}
	ITEM.funcs["Drop"] = function(ply, slot, item)
		local data = ply:getItem(slot)
		
		local ent = ents.Create("lts_item")
		ent:SetPos(ply:GetPos() + ply:GetForward()*32)
		ent.hash = data.hash
		ent.id = data.id
		ent.model = item.model
		ent:Spawn()
		if lts.item.list[id].color then
			ent:SetColor(lts.item.list[id].color)
		end
		ply:removeItem(slot)
		ply:netInv(true)
	end
	
    if data then
        for k,v in pairs(data) do
            ITEM[k] = v
        end
    end

    lts.item.list[id] = ITEM

    return lts.item.list[id]
end

function lts.util.item(id, base, name, desc, mdl, cat, data)
	local ITEM = lts.item.add(id, name, desc, mdl, cat, data)
    return ITEM
end

function lts.util.addLightsaber(id, base, name, desc, mdl, cat, data)
	local ITEM = lts.item.add(id, name, desc, mdl, cat, data)
	ITEM.combine = function(ply,inv,drop,me)
		local dropItem = lts.item.list[inv[drop].id]
		if dropItem.isCrystal then
			if getVar("crystal_".. inv[me].hash, "") == "" then
				ply:sound("hfg/effects/cloth".. math.random(1,3) ..".mp3")
				setVar("crystal_".. inv[me].hash, inv[drop])
				return true
			end
		end
		if not data.legacyHilt then
			if dropItem.isPommel then
				if getVar("pommel_".. inv[me].hash, "") == "" then
					ply:sound("hfg/effects/cloth".. math.random(1,3) ..".mp3")
					setVar("pommel_".. inv[me].hash, inv[drop])
					return true
				end
			end
			if dropItem.isGrip then
				if getVar("grip_".. inv[me].hash, "") == "" then
					ply:sound("hfg/effects/cloth".. math.random(1,3) ..".mp3")
					setVar("grip_".. inv[me].hash, inv[drop])
					return true
				end
			end
			if dropItem.isEmitter then
				if getVar("emitter_".. inv[me].hash, "") == "" then
					ply:sound("hfg/effects/cloth".. math.random(1,3) ..".mp3")
					setVar("emitter_".. inv[me].hash, inv[drop])
					return true
				end
			end
			if dropItem.isTrigger then
				if getVar("trigger_".. inv[me].hash, "") == "" then
					ply:sound("hfg/effects/cloth".. math.random(1,3) ..".mp3")
					setVar("trigger_".. inv[me].hash, inv[drop])
					return true
				end
			end
		end
	end
	
	ITEM.funcs["Drop"] = function(ply, slot, item)
		local data = ply:getItem(slot)
		
		local ent = ents.Create("lts_item")
		ent:SetPos(ply:GetPos() + ply:GetForward()*32)
		ent.hash = data.hash
		ent.id = data.id
		ent.model = item.model
		ent:Spawn()
		if lts.item.list[id].color then
			ent:SetColor(lts.item.list[id].color)
		end
		ply:removeItem(slot)
		ply:netInv(true)
		ply:StripWeapon("tyler_saber")
	end
		
		
	ITEM.funcs["Remove Crystal"] = function(ply, slot, item)
		local inv = ply:getInv()
		if getVar("crystal_".. inv[slot].hash, "") ~= "" then
			local crystal = getVar("crystal_".. inv[slot].hash, "")
			ply:addItem(crystal.id, nil, crystal.hash)
			ply:sound("hfg/effects/cloth".. math.random(1,3) ..".mp3")
			ply:netInv(true)
			setVar("crystal_".. inv[slot].hash, "")
			ply:StripWeapon("tyler_saber")
		end
	end
		
	if not data.legacyHilt then
		ITEM.funcs["Remove Emitter"] = function(ply, slot, item)
			local inv = ply:getInv()
			if getVar("emitter_".. inv[slot].hash, "") ~= "" then
				local crystal = getVar("emitter_".. inv[slot].hash, "")
				ply:addItem(crystal.id, nil, crystal.hash)
				ply:sound("hfg/effects/cloth".. math.random(1,3) ..".mp3")
				ply:netInv(true)
				setVar("emitter_".. inv[slot].hash, "")
				ply:StripWeapon("tyler_saber")
			end
		end
		ITEM.funcs["Remove Grip"] = function(ply, slot, item)
			local inv = ply:getInv()
			if getVar("grip_".. inv[slot].hash, "") ~= "" then
				local crystal = getVar("grip_".. inv[slot].hash, "")
				ply:addItem(crystal.id, nil, crystal.hash)
				ply:sound("hfg/effects/cloth".. math.random(1,3) ..".mp3")
				ply:netInv(true)
				setVar("grip_".. inv[slot].hash, "")
				ply:StripWeapon("tyler_saber")
			end
		end
		ITEM.funcs["Remove Trigger"] = function(ply, slot, item)
			local inv = ply:getInv()
			if getVar("trigger_".. inv[slot].hash, "") ~= "" then
				local crystal = getVar("trigger_".. inv[slot].hash, "")
				ply:addItem(crystal.id, nil, crystal.hash)
				ply:sound("hfg/effects/cloth".. math.random(1,3) ..".mp3")
				ply:netInv(true)
				setVar("trigger_".. inv[slot].hash, "")
				ply:StripWeapon("tyler_saber")
			end
		end
		ITEM.funcs["Remove Pommel"] = function(ply, slot, item)
		local inv = ply:getInv()
		if getVar("pommel_".. inv[slot].hash, "") ~= "" then
			local crystal = getVar("pommel_".. inv[slot].hash, "")
			ply:addItem(crystal.id, nil, crystal.hash)
			ply:sound("hfg/effects/cloth".. math.random(1,3) ..".mp3")
			ply:netInv(true)
			setVar("pommel_".. inv[slot].hash, "")
			ply:StripWeapon("tyler_saber")
		end
	end
	end
	ITEM.funcs["UnEquip"] = function(ply, slot, item)
		ply:StripWeapon("tyler_saber")
	end
	ITEM.funcs["Equip"] = function(ply, slot, item)
		local inv = ply:getInv()
		local canEquip = true
		local missingParts = {}
		print("IS LEGACY?", data.legacyHilt)
		if not data.legacyHilt == true then
			if getVar("pommel_".. inv[slot].hash, "") == "" then canEquip = false table.insert(missingParts, "Pommel") end
			if getVar("emitter_".. inv[slot].hash, "") == "" then canEquip = false table.insert(missingParts, "Emitter") end
			if getVar("trigger_".. inv[slot].hash, "") == "" then canEquip = false table.insert(missingParts, "Trigger") end
			if getVar("grip_".. inv[slot].hash, "") == "" then canEquip = false table.insert(missingParts, "Grip") end
		end
		
		if getVar("crystal_".. inv[slot].hash, "") == "" then canEquip = false table.insert(missingParts, "Crystal") end
		
		if not canEquip then
			ply:ChatPrint("Your lightsaber is missing: " .. table.concat(missingParts, ", "))
		else
			local pommel = 	getVar("pommel_".. 	inv[slot].hash, "")
			local emitter = getVar("emitter_".. inv[slot].hash, "")
			local grip = 	getVar("grip_".. 	inv[slot].hash, "")
			local trigger = getVar("trigger_".. inv[slot].hash, "")
			local crystal = getVar("crystal_".. inv[slot].hash, "")
			
			
			ply:StripWeapon("tyler_saber")
			local sab = ply:Give("tyler_saber")
			ply:SetActiveWeapon(sab)
			ply:GetActiveWeapon().WorldModel = item.model
			ply:GetActiveWeapon():SetModel(item.model)
			ply:GetActiveWeapon():SetNW2String("crystalItem", crystal.id)
			ply:GetActiveWeapon():SetNW2String("powerTunerItem", "powertuner_test")
			
			if not data.legacyHilt == true then
				local saberData = {
					emitter = {
						mdl = 		lts.item.list[emitter.id].model,
						tex = 		lts.item.list[emitter.id].tex,
						mat = 		lts.item.list[emitter.id].mat,
						dye = 		lts.item.list[emitter.id].dye,
						offset = 	lts.item.list[emitter.id].offset,
						angs = 		lts.item.list[emitter.id].angs
					},
					switch = {
						mdl = 		lts.item.list[trigger.id].model,
						tex = 		lts.item.list[trigger.id].tex,
						mat = 		lts.item.list[trigger.id].mat,
						dye = 		lts.item.list[trigger.id].dye,
						offset = 	lts.item.list[trigger.id].offset,
						angs = 		lts.item.list[trigger.id].angs
					},
					blade = {
						mdl = 		lts.item.list[grip.id].model,
						tex = 		lts.item.list[grip.id].tex,
						mat = 		lts.item.list[grip.id].mat,
						dye = 		lts.item.list[grip.id].dye,
						offset = 	lts.item.list[grip.id].offset,
						angs = 		lts.item.list[grip.id].angs
					},
					pommel = {
						mdl = 		lts.item.list[pommel.id].model,
						tex = 		lts.item.list[pommel.id].tex,
						mat = 		lts.item.list[pommel.id].mat,
						dye = 		lts.item.list[pommel.id].dye,
						offset = 	lts.item.list[pommel.id].offset,
						angs = 		lts.item.list[pommel.id].angs
					},
				}
				
				timer.Simple(0.5, function()
					net.Start("tyler.saber")
						net.WriteEntity(ply)
						net.WriteTable(saberData)
					net.Broadcast()
				end)
			else
				ply:GetActiveWeapon():SetNW2String("legacyModel", item.model)
				local saberData = {
					emitter = {
						mdl = 		"models/props_junk/PopCan01a.mdl",
						tex = 		"",
						mat = 		"",
						dye = 		"",
						offset = 	0,
						angs = 		{up=0,right=0,forward=0}
					},
					switch = {
						mdl = 		"models/props_junk/PopCan01a.mdl",
						tex = 		"",
						mat = 		"",
						dye = 		"",
						offset = 	0,
						angs = 		{up=0,right=0,forward=0}
					},
					blade = {
						mdl = 		"models/props_junk/PopCan01a.mdl",
						tex = 		"",
						mat = 		"",
						dye = 		"",
						offset = 	0,
						angs = 		{up=0,right=0,forward=0}
					},
					pommel = {
						mdl = 		"models/props_junk/PopCan01a.mdl",
						tex = 		"",
						mat = 		"",
						dye = 		"",
						offset = 	0,
						angs = 		{up=0,right=0,forward=0}
					},
				}
				timer.Simple(0.5, function()
					net.Start("tyler.saber")
						net.WriteEntity(ply)
						net.WriteTable(saberData)
					net.Broadcast()
				end)
			end
		end
		
	end
    return ITEM
end

function lts.util.addHolocronItem(id, base, name, desc, mdl, cat, cats, min, max)
	local crons = {1, 5, 10, 25, 50, 100, 250}
	for _,multi in pairs(crons) do
		local ITEM = lts.item.add(id .. "_" ..multi, name .. " x" .. multi, desc, mdl, cat, {})
		ITEM.funcs["Open"] = function(ply, slot, item)
			for i=1,multi do
				timer.Simple(i*0.1, function()
					ply:addXP(table.Random(cats), math.random(min,max))
				end)
			end
			ply:removeItem(slot)
			ply:netInv(true)
		end
	end
    return ITEM
end

lts.util.addHolocronItem("holocron_birthday", nil, "Birthday Holocron", "For those who supported tyler during his birthday!", "models/christmas_gift2/christmas_gift2.mdl", "Holocrons", {"Melee", "Force", "Defense"}, 1000, 10000)

lts.util.addHolocronItem("holocron_xp", nil, "Holocron", "Contains experience.", "models/lordtrilobite/starwars/props/holocron_sith01.mdl", "Holocrons", {"Melee", "Force", "Defense"}, 100, 1000)
lts.util.addHolocronItem("holocron_ancient", nil, "Ancient Holocron", "Contains experience.", "models/lordtrilobite/starwars/props/holocron_sith01.mdl", "Holocrons", {"Melee", "Force", "Defense"}, 1000, 5000)

lts.util.addHolocronItem("holocron_force", nil, "Force Holocron", "Contains experience.", "models/kingpommes/starwars/misc/jedi/jedi_holocron_2.mdl", "Holocrons", {"Force"}, 100, 1000)
lts.util.addHolocronItem("holocron_force_ancient", nil, "Ancient Force Holocron", "Contains experience.", "models/kingpommes/starwars/misc/jedi/jedi_holocron_2.mdl", "Holocrons", {"Force"}, 1000, 5000)

lts.util.addHolocronItem("holocron_defense", nil, "Defense Holocron", "Contains experience.", "models/kingpommes/starwars/misc/jedi/jedi_holocron_2.mdl", "Holocrons", {"Defense"}, 100, 1000)
lts.util.addHolocronItem("holocron_defense_ancient", nil, "Ancient Defense Holocron", "Contains experience.", "models/kingpommes/starwars/misc/jedi/jedi_holocron_2.mdl", "Holocrons", {"Defense"}, 1000, 5000)

lts.util.addHolocronItem("holocron_melee", nil, "Melee Holocron", "Contains experience.", "models/kingpommes/starwars/misc/jedi/jedi_holocron_2.mdl", "Holocrons", {"Melee"}, 100, 1000)
lts.util.addHolocronItem("holocron_melee_ancient", nil, "Ancient Melee Holocron", "Contains experience.", "models/kingpommes/starwars/misc/jedi/jedi_holocron_2.mdl", "Holocrons", {"Melee"}, 1000, 5000)




lts.util.addLightsaber("lightsaber", nil, "Lightsaber Case", "Holds your lightsaber parts", "models/starwars/syphadias/props/sw_tor/bioware_ea/items/harvesting/slicing/slicing_footlocker_screen.mdl", "Weapons", {
	isLightsaber = true
})


lts.util.addLightsaber("training_saber", nil, "Training Lightsaber", "Holds your lightsaber parts", "models/training/training.mdl", "Weapons", {
	isLightsaber = true,
	legacyHilt = true
})

concommand.Add("lts.item.list", function()
    PrintTable(lts.item.list.lightsaber)
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

local stats = {}

stats["Adegan"] = {
    stats = {
        ["Primordial"] = {atk = 1450, def = 0.25, frc = 1},
        ["Mythic"] = {atk = 1325, def = 0.35, frc = 1},
        ["Legendary"] = {atk = 1200, def = 0.5, frc = 1},
        ["Celestial"] = {atk = 1075, def = 0.55, frc = 1},
        ["Artifact"] = {atk = 950, def = 0.6, frc = 1},
        ["Unique"] = {atk = 825, def = 0.65, frc = 1},
        ["Heroic"] = {atk = 700, def = 0.7, frc = 1},
        ["Arcane"] = {atk = 575, def = 0.75, frc = 1},
        ["Rare"] = {atk = 450, def = 0.8, frc = 1},
        ["Grand"] = {atk = 325, def = 0.85, frc = 1},
        ["Basic"] = {atk = 200, def = 0.9, frc = 1},
    },
    mdl = "models/zhrom/Adegan_Crystal.mdl",
    special = function(ply,wep)
        -- do nothing
    end
}

stats["Rubat"] = {
    stats = {
        ["Primordial"] = {atk = 4000, def = 1, frc = 1},
        ["Mythic"] = {atk = 3000, def = 1, frc = 1},
        ["Legendary"] = {atk = 2380, def = 1, frc = 1},
        ["Celestial"] = {atk = 2120, def = 1, frc = 1},
        ["Artifact"] = {atk = 1860, def = 1, frc = 1},
        ["Unique"] = {atk = 1600, def = 1, frc = 1},
        ["Heroic"] = {atk = 1340, def = 1, frc = 1},
        ["Arcane"] = {atk = 1080, def = 1, frc = 1},
        ["Rare"] = {atk = 820, def = 1, frc = 1},
        ["Grand"] = {atk = 560, def = 1, frc = 1},
        ["Basic"] = {atk = 300, def = 1, frc = 1},
    },
    mdl = "models/zhrom/Rubat_Crystal.mdl",
    special = function(ply,wep)
        -- do nothing
    end
}

stats["Focus"] = {
    stats = {
        ["Primordial"] = {atk = 1200, def = 1, frc = 0.45},
        ["Mythic"] = {atk = 1100, def = 1, frc = 0.5},
        ["Legendary"] = {atk = 1000, def = 1, frc = 0.55},
        ["Celestial"] = {atk = 900, def = 1, frc = 0.6},
        ["Artifact"] = {atk = 800, def = 1, frc = 0.65},
        ["Unique"] = {atk = 700, def = 1, frc = 0.7},
        ["Heroic"] = {atk = 600, def = 1, frc = 0.75},
        ["Arcane"] = {atk = 500, def = 1, frc = 0.8},
        ["Rare"] = {atk = 400, def = 1, frc = 0.85},
        ["Grand"] = {atk = 300, def = 1, frc = 0.9},
        ["Basic"] = {atk = 200, def = 1, frc = 0.95},
    },
    mdl = "models/zhrom/Focus_Crystal.mdl",
    special = function(ply,wep)
        -- do nothing
    end
}

stats["Kaiburr"] = {
    stats = {
        ["Primordial"] = {atk = 3000, def = 0.89, frc = 0.89},
        ["Mythic"] = {atk = 2740, def = 0.9, frc = 0.9},
        ["Legendary"] = {atk = 2480, def = 0.91, frc = 0.91},
        ["Celestial"] = {atk = 2220, def = 0.92, frc = 0.92},
        ["Artifact"] = {atk = 1960, def = 0.93, frc = 0.93},
        ["Unique"] = {atk = 1700, def = 0.94, frc = 0.94},
        ["Heroic"] = {atk = 1440, def = 0.95, frc = 0.95},
        ["Arcane"] = {atk = 1180, def = 0.96, frc = 0.96},
        ["Rare"] = {atk = 920, def = 0.97, frc = 0.97},
        ["Grand"] = {atk = 660, def = 0.98, frc = 0.98},
        ["Basic"] = {atk = 400, def = 0.99, frc = 0.99},
    },
    mdl = "models/zhrom/Kaiburr_Crystal.mdl",
    special = function(ply,wep)
        -- do nothing
    end
}

stats["Katak"] = {
    stats = {
        ["Primordial"] = {atk = 3000, def = 0.89, frc = 0.89},
        ["Mythic"] = {atk = 2740, def = 0.9, frc = 0.9},
        ["Legendary"] = {atk = 2480, def = 0.91, frc = 0.91},
        ["Celestial"] = {atk = 2220, def = 0.92, frc = 0.92},
        ["Artifact"] = {atk = 1960, def = 0.93, frc = 0.93},
        ["Unique"] = {atk = 1700, def = 0.94, frc = 0.94},
        ["Heroic"] = {atk = 1440, def = 0.95, frc = 0.95},
        ["Arcane"] = {atk = 1180, def = 0.96, frc = 0.96},
        ["Rare"] = {atk = 920, def = 0.97, frc = 0.97},
        ["Grand"] = {atk = 660, def = 0.98, frc = 0.98},
        ["Basic"] = {atk = 400, def = 0.99, frc = 0.99},
    },
    mdl = "models/zhrom/Katak_Crystal.mdl",
    special = function(ply,wep)
        -- do nothing
    end
}

stats["Solari"] = {
    stats = {
        ["Primordial"] = {atk = 2800, def = 0.78, frc = 0.89},
        ["Mythic"] = {atk = 2560, def = 0.8, frc = 0.9},
        ["Legendary"] = {atk = 2320, def = 0.82, frc = 0.91},
        ["Celestial"] = {atk = 2080, def = 0.84, frc = 0.92},
        ["Artifact"] = {atk = 1840, def = 0.86, frc = 0.93},
        ["Unique"] = {atk = 1600, def = 0.88, frc = 0.94},
        ["Heroic"] = {atk = 1360, def = 0.9, frc = 0.95},
        ["Arcane"] = {atk = 1120, def = 0.92, frc = 0.96},
        ["Rare"] = {atk = 880, def = 0.94, frc = 0.97},
        ["Grand"] = {atk = 640, def = 0.96, frc = 0.98},
        ["Basic"] = {atk = 400, def = 0.99, frc = 0.99},
    },
    mdl = "models/zhrom/Solari_Crystal.mdl",
    special = function(ply,wep)
        -- do nothing
    end
}

stats["Dragite"] = {
    stats = {
        ["Primordial"] = {atk = 2600, def = 0.56, frc = 0.89},
        ["Mythic"] = {atk = 2380, def = 0.6, frc = 0.9},
        ["Legendary"] = {atk = 2160, def = 0.64, frc = 0.91},
        ["Celestial"] = {atk = 1940, def = 0.68, frc = 0.92},
        ["Artifact"] = {atk = 1720, def = 0.72, frc = 0.93},
        ["Unique"] = {atk = 1500, def = 0.76, frc = 0.94},
        ["Heroic"] = {atk = 1280, def = 0.8, frc = 0.95},
        ["Arcane"] = {atk = 1060, def = 0.84, frc = 0.96},
        ["Rare"] = {atk = 840, def = 0.88, frc = 0.97},
        ["Grand"] = {atk = 620, def = 0.92, frc = 0.98},
        ["Basic"] = {atk = 400, def = 0.96, frc = 0.99},
    },
    mdl = "models/zhrom/Dragite_Crystal.mdl",
    special = function(ply,wep)
        -- do nothing
    end
}

stats["Vexxtal"] = {
    stats = {
        ["Primordial"] = {atk = 2800, def = 0.89, frc = 0.56},
        ["Mythic"] = {atk = 2560, def = 0.9, frc = 0.59},
        ["Legendary"] = {atk = 2320, def = 0.91, frc = 0.64},
        ["Celestial"] = {atk = 2080, def = 0.92, frc = 0.68},
        ["Artifact"] = {atk = 1840, def = 0.93, frc = 0.72},
        ["Unique"] = {atk = 1600, def = 0.94, frc = 0.74},
        ["Heroic"] = {atk = 1360, def = 0.95, frc = 0.76},
        ["Arcane"] = {atk = 1120, def = 0.96, frc = 0.84},
        ["Rare"] = {atk = 880, def = 0.97, frc = 0.89},
        ["Grand"] = {atk = 640, def = 0.98, frc = 0.92},
        ["Basic"] = {atk = 400, def = 0.99, frc = 0.96},
    },
    mdl = "models/zhrom/Vexxtal_Crystal.mdl",
    special = function(ply,wep)
        -- do nothing
    end
}


lts.crystals = {}

for crystal, data in pairs(stats) do
    for grade, stats in pairs(data.stats) do
        for color, colors in pairs(crystalColors) do
            local id = string.lower("crystal_" .. crystal .. "_" .. grade .. "_" .. color)
            id = id:gsub("%s+", "")
            table.insert(lts.crystals, id)
            lts.item.add(id, grade .. " " .. color .. " " .. crystal .. " Crystal", "A lightsaber crystal, shimmering in the ambient light.", data.mdl, "Crystals", {
                color = colors.color,
                innerColor = colors.innerColor,
                patinaColor = Color(0,0,0),
                damage = stats.atk,
                defense = stats.def,
				grade = grade,
                force = stats.frc,
                isCrystal = true,
				autoGenerated = true,
            })
            local id = string.lower("corrupted_crystal_" .. crystal .. "_" .. grade .. "_" .. color)
            id = id:gsub("%s+", "")
            table.insert(lts.crystals, id)
            lts.item.add(id, grade .. " " .. color .. " " .. crystal .. " Crystal", "A corrupted lightsaber crystal, shimmering in the ambient light.", data.mdl, "Crystals", {
                color = colors.color,
                innerColor = Color(0,0,0),
                patinaColor = Color(0,0,0),
                damage = stats.atk,
                defense = stats.def,
				grade = grade,
                force = stats.frc,
                isCrystal = true,
				autoGenerated = true,
            })
        end
    end
end

print("[LTS] There are " .. table.Count(lts.item.list) .. " procedurally generated lightsaber crystals.")





































local ITEM = lts.util.item("crystal_test", nil, "Red Kyber Crystal", "Elegantly beautiful.", "models/white7/white7.mdl", "Crystals", {
    color = Color(255,0,0),
    innerColor = Color(255,255,255),
    patinaColor = Color(0,0,0),
    damage = 500,

    isCrystal = true,
    isArcUnit = false,
    isInnerReactor = false,
    isEffModule = false,
    isPowerTuner = false,

    isEmitter = false,
    isTrigger = false,
    isGrip = false,
    isPommel = false,
})

if CLIENT then
    function ITEM.PaintOver(item, w, h)
        surface.SetDrawColor(item.color.r, item.color.g, item.color.b, 255)
        local m = item.model
        m = string.Replace(m, ".mdl", ".png")
        surface.SetMaterial(mat("materials/spawnicons/" .. m))
        surface.DrawTexturedRect(0,0,w,h)
    end
end


local ITEM = lts.util.item("crystal_test2", nil, "Blue Kyber Crystal", "Elegantly beautiful.", "models/white6/white6.mdl", "Crystals", {
    color = Color(22,12,245),
    innerColor = Color(255,255,255),
    patinaColor = Color(0,0,0),
    damage = 500,

    isCrystal = true,
    isArcUnit = false,
    isInnerReactor = false,
    isEffModule = false,
    isPowerTuner = false,

    isEmitter = false,
    isTrigger = false,
    isGrip = false,
    isPommel = false,
})

if CLIENT then
    function ITEM.PaintOver(item, w, h)
        surface.SetDrawColor(item.color.r, item.color.g, item.color.b, 255)
        local m = item.model
        m = string.Replace(m, ".mdl", ".png")
        surface.SetMaterial(mat("materials/spawnicons/" .. m))
        surface.DrawTexturedRect(0,0,w,h)
    end
end



local ITEM = lts.util.item("crystal_test3", nil, "Orange Kyber Crystal", "Elegantly beautiful.", "models/white6/white6.mdl", "Crystals", {
    color = Color(255,150,0),
    innerColor = Color(255,255,255),
    patinaColor = Color(0,0,0),
    damage = 500,

    isCrystal = true,
    isArcUnit = false,
    isInnerReactor = false,
    isEffModule = false,
    isPowerTuner = false,

    isEmitter = false,
    isTrigger = false,
    isGrip = false,
    isPommel = false,
})

if CLIENT then
    function ITEM.PaintOver(item, w, h)
        surface.SetDrawColor(item.color.r, item.color.g, item.color.b, 255)
        local m = item.model
        m = string.Replace(m, ".mdl", ".png")
        surface.SetMaterial(mat("materials/spawnicons/" .. m))
        surface.DrawTexturedRect(0,0,w,h)
    end
end





lts.util.item("arcunit_test", nil, "Standard Arc Unit", "Elegantly beautiful.", "models/heat/heat.mdl", "Innards", {
    isCrystal = false,
    isArcUnit = true,
    isInnerReactor = false,
    isEffModule = false,
    isPowerTuner = false,

    isEmitter = false,
    isTrigger = false,
    isGrip = false,
    isPommel = false,

    shape = "Standard",
})

lts.util.item("innerreactor_test", nil, "Standard Reactor", "Pretty shitty to be honest.", "models/batt/batt.mdl", "Innards", {
    isCrystal = false,
    isArcUnit = false,
    isInnerReactor = true,
    isEffModule = false,
    isPowerTuner = false,

    isEmitter = false,
    isTrigger = false,
    isGrip = false,
    isPommel = false,

    defenseBonus = 0.1,
})

lts.util.item("effmod_test", nil, "Cracked Efficiency Module", "Pretty shitty to be honest.", "models/modgun/modgun.mdl", "Innards", {
    isCrystal = false,
    isArcUnit = false,
    isInnerReactor = false,
    isEffModule = true,
    isPowerTuner = false,

    isEmitter = false,
    isTrigger = false,
    isGrip = false,
    isPommel = false,

    bonusDamage = 0.1,
})

lts.util.item("powertuner_test", nil, "Standardized Power Tuner", "Basic bitch", "models/tuning/tuning.mdl", "Innards", {
    isCrystal = false,
    isArcUnit = false,
    isInnerReactor = false,
    isEffModule = false,
    isPowerTuner = true,

    isEmitter = false,
    isTrigger = false,
    isGrip = false,
    isPommel = false,

    bladeLength = 38,
})

lts.util.item("emitter_enochian", nil, "Enochian Emitter", "Beatuiful and round emitter, used by master of the force.", "models/lordtyler/LightsaberWeaponsGrpEnoEmitter.mdl", "Saber Bits", {
    isCrystal = false,
    isArcUnit = false,
    isInnerReactor = false,
    isEffModule = false,
    isPowerTuner = false,

    isEmitter = true,
    isTrigger = false,
    isGrip = false,
    isPommel = false,
    tex = "lordtylersservers/lordtyler_MI_LightsaberWeaponsGrpEnoEmitter_",
    material = "steel_brushed_",
    dye = "nodye",
})

lts.util.item("switch_enochian", nil, "Enochian Switch", "Beatuiful and round switch, used by master of the force.", "models/lordtyler/LightsaberWeaponsGrpDeconstructedRSwitch.mdl", "Saber Bits", {
    isCrystal = false,
    isArcUnit = false,
    isInnerReactor = false,
    isEffModule = false,
    isPowerTuner = false,

    isEmitter = false,
    isTrigger = true,
    isGrip = false,
    isPommel = false,
    tex = "lordtylersservers/lordtyler_MI_LightsaberWeaponsGrpDeconstructedSwitch_",
    material = "steel_brushed_",
    dye = "nodye",
})

lts.util.item("pommel_enochian", nil, "Enochian Pommel", "Beatuiful and round pommel, used by master of the force.", "models/lordtyler/LightsaberWeaponsGrpDeconstructedLSwitch.mdl", "Saber Bits", {
    isCrystal = false,
    isArcUnit = false,
    isInnerReactor = false,
    isEffModule = false,
    isPowerTuner = false,

    isEmitter = false,
    isTrigger = false,
    isGrip = false,
    isPommel = true,
    tex = "lordtylersservers/lordtyler_MI_LightsaberWeaponsGrpDeconstructedSwitch_",
    material = "steel_brushed_",
    dye = "nodye",
})


local ITEM = lts.util.item("grip_enochian", nil, "Enochian Grip", "Beatuiful and round grip, used by master of the force.", "models/lordtyler/LightsaberWeaponsGrpEnoRGrip.mdl", "Saber Bits", {
    isCrystal = false,
    isArcUnit = false,
    isInnerReactor = false,
    isEffModule = false,
    isPowerTuner = false,

    isEmitter = false,
    isTrigger = false,
    isGrip = true,
    isPommel = false,
    tex = "lordtylersservers/lordtyler_MI_LightsaberWeaponsGrpEnoGrip_",
    material = "steel_brushed_",
    dye = "nodye",
})



local emittersMeta = {
	{
		name = "Cal",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Deconstructed",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Eno",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Geometrical",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Greeble",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Hennix",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Inspired",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Kenobi",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "LSMB",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Luke",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Medieval",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Nomad",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Rancor",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Ripple",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Santari",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Glow",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Sentinel",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},
}


local switchMeta = {
	{
		name = "Cal",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Deconstructed",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Eno",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Geometrical",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Greeble",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Hennix",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Inspired",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Kenobi",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "LSMB",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Luke",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Medieval",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Nomad",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Rancor",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Ripple",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Santari",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Glow",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Sentinel",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},
}


local gripMeta = {
	{
		name = "Cal",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Deconstructed",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Eno",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Geometrical",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Greeble",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Hennix",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Inspired",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Kenobi",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "LSMB",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Luke",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Medieval",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Nomad",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Rancor",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Ripple",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Santari",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Glow",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Sentinel",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},
}


local pommelMeta = {
	{
		name = "Cal",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Deconstructed",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Eno",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Geometrical",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Greeble",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Hennix",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Inspired",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Kenobi",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "LSMB",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Luke",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Medieval",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Nomad",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Rancor",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Ripple",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Santari",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Glow",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},{
		name = "Sentinel",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},
}


local bases = {
	emitter = {
		mdl = "models/lordtyler/lightsaberweaponsgrp%semitter.mdl",
		txr = "lordtyler_MI_LightsaberWeaponsGrp%sEmitter_",
	},
	switch = {
		mdl = "models/lordtyler/lightsaberweaponsgrp%srswitch.mdl",
		txr = "lordtyler_MI_LightsaberWeaponsGrp%sSwitch_",
	},
	grip = {
		mdl = "models/lordtyler/lightsaberweaponsgrp%srgrip.mdl",
		txr = "lordtyler_MI_LightsaberWeaponsGrp%sGrip_",
	},
	pommel = {
		mdl = "models/lordtyler/lightsaberweaponsgrp%spommel.mdl",
		txr = "lordtyler_MI_LightsaberWeaponsGrp%sPommel_",
	},
}



local mats = {
	["Brushed"] = "steel_brushed_",
	["Scratched"] = "steel_scratched_",
	["Rusted"] = "steel_rusted_",
	["Hammered"] = "steel_hammered_",
	["Walnut"] = "wood_walnut_",
	["Pine"] = "wood_pine_",
	["Flat Polymer"] = "flat_polymer_",
	["Glossy Polymer"] = "glossy_polymer_",
	["Tanned Leather"] = "leather_red_",
	["Aged Leather"] = "leather_black_",
	["Demascus Wrap"] = "wrap_demascus_",
	["Leaf Wrap"] = "wrap_leaf_",
	["Tech Wrap"] = "wrap_tech_",
	["Faux Wood Wrap"] = "wrap_wood_",
}

local dyes = {
	["Blood Red"] = "bloodred",
	["Blue Steel"] = "bluesteel",
	["Brass"] = "brass",
	["Bronze"] = "bronze",
	["Cobalt"] = "cobalt",
	["Gold"] = "gold",
	["Gun Metal"] = "gunmetal",
	["Inquisitive"] = "inquisitive",
	["Plain"] = "nodye",
	["Rose Pink"] = "rosepink",
	["Sage"] = "sage",
	["Sinister Black"] = "sinisterblack",
	["Titanium"] = "titanium",
}

local count = 0
for _,emit in pairs(emittersMeta) do
	local base = bases.emitter
	local mdl = string.format(base.mdl, string.lower(emit.name))
	local txr = string.format(base.txr, emit.name)
	for z,a in pairs(mats) do
		for x,b in pairs(dyes) do
			count = count + 1
			lts.util.item("emitter_".. emit.name .. "_" .. a .. "_" .. b, nil, x .. " " .. z .. " " .. emit.name .. " Emitter", "Part of a lightsaber.", mdl, "Emitters", {
				isEmitter = true,
				tex = txr,
				mat = a,
				dye = b,
				offset = emit.offset,
				angs = emit.angs
			})
		end
	end
end
print("[LTS] There are " .. count .. " procedurally generated lightsaber emitters.")
print("[LTS] Total Items: " .. table.Count(lts.item.list))

local count = 0
for _,emit in pairs(switchMeta) do
	local base = bases.switch
	local mdl = string.format(base.mdl, string.lower(emit.name))
	local txr = string.format(base.txr, emit.name)
	for z,a in pairs(mats) do
		for x,b in pairs(dyes) do
			count = count + 1
			lts.util.item("switch_".. emit.name .. "_" .. a .. "_" .. b, nil, x .. " " .. z .. " " .. emit.name .. " Switch", "Part of a lightsaber.", mdl, "Switches", {
				isTrigger = true,
				tex = txr,
				mat = a,
				dye = b,
				offset = emit.offset,
				angs = emit.angs
			})
		end
	end
end
print("[LTS] There are " .. count .. " procedurally generated lightsaber switches.")
print("[LTS] Total Items: " .. table.Count(lts.item.list))

local count = 0
for _,emit in pairs(gripMeta) do
	local base = bases.grip
	local mdl = string.format(base.mdl, string.lower(emit.name))
	local txr = string.format(base.txr, emit.name)
	for z,a in pairs(mats) do
		for x,b in pairs(dyes) do
			count = count + 1
			lts.util.item("grip_".. emit.name .. "_" .. a .. "_" .. b, nil, x .. " " .. z .. " " .. emit.name .. " Grip", "Part of a lightsaber.", mdl, "Grips", {
				isGrip = true,
				tex = txr,
				mat = a,
				dye = b,
				offset = emit.offset,
				angs = emit.angs
			})
		end
	end
end
print("[LTS] There are " .. count .. " procedurally generated lightsaber grips.")
print("[LTS] Total Items: " .. table.Count(lts.item.list))

local count = 0
for _,emit in pairs(pommelMeta) do
	local base = bases.pommel
	local mdl = string.format(base.mdl, string.lower(emit.name))
	local txr = string.format(base.txr, emit.name)
	for z,a in pairs(mats) do
		for x,b in pairs(dyes) do
			count = count + 1
			lts.util.item("pommel_".. emit.name .. "_" .. a .. "_" .. b, nil, x .. " " .. z .. " " .. emit.name .. " Pommel", "Part of a lightsaber.", mdl, "Pommels", {
				isPommel = true,
				tex = txr,
				mat = a,
				dye = b,
				offset = emit.offset,
				angs = emit.angs
			})
		end
	end
end
print("[LTS] There are " .. count .. " procedurally generated lightsaber pommels.")
print("[LTS] Total Items: " .. table.Count(lts.item.list))


if CLIENT then
	concommand.Add("lts.item.menu", function()
		-- Create the main frame
		local frame = vgui.Create("DFrame")
		frame:SetSize(ScrW() * 0.75, ScrH() * 0.75)
		frame:Center()
		frame:SetTitle("Item Catalog")
		frame:MakePopup()
		frame:SetDraggable(true)
		frame:ShowCloseButton(true)
		frame:SetBackgroundBlur(true)
		frame:SetSizable(true)
		frame.Paint = function(self, w, h)
			draw.RoundedBox(8, 0, 0, w, h, Color(10, 10, 20, 230)) -- Dark background
			draw.RoundedBox(8, 0, 0, w, 25, Color(0, 122, 204, 255)) -- Blue header
		end

		-- Organize items by category
		local categories = {}

		for k, item in pairs(lts.item.list) do
			local category = item.category or "Uncategorized"
			categories[category] = categories[category] or {}
			categories[category][k] = item
		end

		-- Create a panel for categories
		local categoryPanel = vgui.Create("DScrollPanel", frame)
		categoryPanel:SetSize(200, frame:GetTall() - 50)
		categoryPanel:SetPos(10, 40)

		-- Customize the scrollbar (optional)
		local sbar = categoryPanel:GetVBar()
		function sbar:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 30, 255))
		end
		function sbar.btnUp:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 122, 204, 255))
		end
		function sbar.btnDown:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 122, 204, 255))
		end
		function sbar.btnGrip:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 122, 204, 255))
		end

		-- Add category buttons
		for categoryName, _ in pairs(categories) do
			local btn = categoryPanel:Add("DButton")
			btn:SetText(categoryName)
			btn:SetTall(40)
			btn:Dock(TOP)
			btn:DockMargin(0, 0, 0, 5)
			btn:SetTextColor(Color(255, 255, 255))
			btn:SetFont("DermaLarge")
			btn.Paint = function(self, w, h)
				if self:IsHovered() then
					draw.RoundedBox(4, 0, 0, w, h, Color(0, 122, 204, 255))
				else
					draw.RoundedBox(4, 0, 0, w, h, Color(30, 30, 40, 255))
				end
			end

			-- On button click, display items in the selected category
			btn.DoClick = function()
				DisplayItems(categories[categoryName])
			end
		end

		-- Create the item display panel
		local itemPanel = vgui.Create("DScrollPanel", frame)
		itemPanel:SetSize(frame:GetWide() - 230, frame:GetTall() - 50)
		itemPanel:SetPos(220, 40)

		-- Customize the scrollbar (optional)
		local sbar = itemPanel:GetVBar()
		function sbar:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 30, 255))
		end
		function sbar.btnUp:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 122, 204, 255))
		end
		function sbar.btnDown:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 122, 204, 255))
		end
		function sbar.btnGrip:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 122, 204, 255))
		end

		-- Function to display items
		function DisplayItems(items)
			itemPanel:Remove()
			itemPanel = vgui.Create("DScrollPanel", frame)
			itemPanel:SetSize(frame:GetWide() - 230, frame:GetTall() - 50)
			itemPanel:SetPos(220, 40)

			-- Customize the scrollbar (optional)
			sbar = itemPanel:GetVBar()
			function sbar:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 30, 255))
			end
			function sbar.btnUp:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 122, 204, 255))
			end
			function sbar.btnDown:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 122, 204, 255))
			end
			function sbar.btnGrip:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 122, 204, 255))
			end
			-- Use an icon layout to organize item panels
			local iconLayout = vgui.Create("DIconLayout", itemPanel)
			iconLayout:Dock(FILL)
			iconLayout:SetSpaceY(10)
			iconLayout:SetSpaceX(10)

			-- Variables for performance optimization
			local viewportHeight = itemPanel:GetTall()
			local itemHeight = 200 -- Approximate height of each item panel

			for k, item in pairs(items) do
				if item.autoGenerated then return end
				local itemPanel = iconLayout:Add("DPanel")
				itemPanel:SetSize(150, itemHeight)
				itemPanel:SetBackgroundColor(Color(40, 40, 50, 255))

				-- Create a label for the item name
				local nameLabel = vgui.Create("DLabel", itemPanel)
				nameLabel:SetPos(5, 5)
				nameLabel:SetSize(140, 20)
				nameLabel:SetText(item.name)
				nameLabel:SetFont("DermaDefaultBold")
				nameLabel:SetTextColor(Color(255, 255, 255))

				-- Create a model panel to display the item model
				local modelPanel = vgui.Create("DModelPanel", itemPanel)
				modelPanel:SetSize(140, 140)
				modelPanel:SetPos(5, 30)
				modelPanel:SetModel(item.model)
				modelPanel.DoClick = function()
					chat.AddText(Color(255,0,0),"[IX] ", Color(255,255,255), "Cheating in '", Color(255,0,0), k, Color(255,255,255), "' to your inventory, and copied the ID to your clipboard.")
					SetClipboardText(k)
					
					net.Start("lts.cheat.item")
						net.WriteString(k)
					net.SendToServer()
					
				end
				
				if item.color then
					modelPanel:SetColor(item.color)
				end
				--modelPanel:SetVisible(false)

				-- Optimize model rendering
				modelPanel.LayoutEntity = function() end -- Stop the model from rotating

				-- Adjust the camera position
				if IsValid(modelPanel.Entity) then
					local mn, mx = modelPanel.Entity:GetRenderBounds()
					local size = 0
					size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
					size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
					size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

					modelPanel:SetFOV(45)
					modelPanel:SetCamPos(Vector(size, size, size)* 1.1)
					modelPanel:SetLookAt((mn + mx) * 0.5)

					-- Create a tooltip with the item description
				end
					itemPanel:SetTooltip(item.description)
			end
		end

		-- Display items from the first category by default
		local firstCategoryName = next(categories)
		if firstCategoryName then
			DisplayItems(categories[firstCategoryName])
		end

	end)
end


local slaveMadeThese = {
	{name = "[$] Adascorp Pole Saber",
mdl = "models/swtor/arsenic/lightsabers/adascorppolesaber.mdl",},

{name = "Antique Socorro Saber Besh",
mdl = "models/swtor/arsenic/lightsabers/antiquesocorrolightsaberbesh.mdl",},

{name = "Antique Socorro Saber Cresh",
mdl = "models/swtor/arsenic/lightsabers/antiquesocorrolightsabercresh.mdl",},

{name = "Antique Socorro Saber Dorn",
mdl = "models/swtor/arsenic/lightsabers/antiquesocorrolightsaberdorn.mdl",},

{name = "[$] Antique Socorro Saber Staff Aurek",
mdl = "models/swtor/arsenic/lightsabers/antiquesocorrosaberstaffaurek.mdl",},

{name = "[$] Antique Socorro Saber Staff Dorn",
mdl = "models/swtor/arsenic/lightsabers/antiquesocorrosaberstaffdorn.mdl",},

{name = "Arakyd Saber",
mdl = "models/swtor/arsenic/lightsabers/arakydsaber.mdl",},

{name = "[$] Ardent Defender's Dual Saber",
mdl = "models/swtor/arsenic/lightsabers/ardentdefender'sdualsaber.mdl",},

{name = "Ardent Defender's Saber",
mdl = "models/swtor/arsenic/lightsabers/ardentdefender'slightsaber.mdl",},

{name = "Artusian Saber",
mdl = "models/swtor/arsenic/lightsabers/artusianlightsaber.mdl",},

{name = "[$] Artusian Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/artusiansaberstaff.mdl",},

{name = "Ashara's Saber",
mdl = "models/swtor/arsenic/lightsabers/ashara'slightsaber.mdl",},

{name = "[$] Attuned Force Lord's Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/attunedforcelord'ssaberstaff.mdl",},

{name = "Blade Master's Attenuated Saber",
mdl = "models/swtor/arsenic/lightsabers/blademaster'sattenuatedlightsaber.mdl",},

{name = "[$] Blade Master's Attenuated Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/blademaster'sattenuatedsaberstaff.mdl",},

{name = "Blade Master's Attenuated Shoto",
mdl = "models/swtor/arsenic/lightsabers/blademaster'sattenuatedshoto.mdl",},

{name = "Blade Master's Saber",
mdl = "models/swtor/arsenic/lightsabers/blademaster'slightsaber.mdl",},

{name = "[$] Blade Master's Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/blademaster'ssaberstaff.mdl",},

{name = "Blade Master's Shoto",
mdl = "models/swtor/arsenic/lightsabers/blademaster'sshoto.mdl",},

{name = "Challenger's Saber",
mdl = "models/swtor/arsenic/lightsabers/challenger'slightsaber.mdl",},

{name = "Chrysopazz Saber",
mdl = "models/swtor/arsenic/lightsabers/chrysopazlightsaber.mdl",},

{name = "[$] Chrysopazz Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/chrysopazsaberstaff.mdl",},

{name = "Conqueror's Saber",
mdl = "models/swtor/arsenic/lightsabers/conqueror'slightsaber.mdl",},

{name = "[$] Conqueror's Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/conqueror'ssaberstaff.mdl",},

{name = "Coruscant Saber",
mdl = "models/swtor/arsenic/lightsabers/coruscalightsaber.mdl",},

{name = "[$] Coruscant Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/coruscasaberstaff.mdl",},

{name = "[$] Strangely Assembled Double Saber",
mdl = "models/swtor/arsenic/lightsabers/custom-builtdoublebladedsaber.mdl",},

{name = "[$] Dark Revier Double Bladed",
mdl = "models/swtor/arsenic/lightsabers/darkreveriedoublebladedsaber.mdl",},

{name = "[$] Darkseeker's Double Bladed",
mdl = "models/swtor/arsenic/lightsabers/darkseeker'sdoublebladedsaber.mdl",},

{name = "Dauntless Avenger's Saber",
mdl = "models/swtor/arsenic/lightsabers/dauntlessavenger'slightsaber.mdl",},

{name = "Defender's Saber",
mdl = "models/swtor/arsenic/lightsabers/defender'slightsaber.mdl",},

{name = "[$] Defiant Technographer's Dual Saber",
mdl = "models/swtor/arsenic/lightsabers/defianttechnographer'sdualsaber.mdl",},

{name = "Defiant Technographer's Saber",
mdl = "models/swtor/arsenic/lightsabers/defianttechnographer'slightsaber.mdl",},

{name = "Derelict Saber",
mdl = "models/swtor/arsenic/lightsabers/derelictlightsaber.mdl",},

{name = "[$] Derelict Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/derelictsaberstaff.mdl",},

{name = "[$] Descendant's Heirloom Dual Saber",
mdl = "models/swtor/arsenic/lightsabers/descendant'sheirloomdualsaber.mdl",},

{name = "[$] Desolator's Star Forged Dual Saber",
mdl = "models/swtor/arsenic/lightsabers/desolator'sstarforgeddualsaber.mdl",},

{name = "[$] Despot's Dual Saber",
mdl = "models/swtor/arsenic/lightsabers/despot'sdualsaber.mdl",},

{name = "[$] Devastor's Double Bladed Saber",
mdl = "models/swtor/arsenic/lightsabers/devastator'sdoublebladedlightsaber.mdl",},

{name = "Diabolist Saber",
mdl = "models/swtor/arsenic/lightsabers/diabolistlightsaber.mdl",},

{name = "Dragon Pearl Saber",
mdl = "models/swtor/arsenic/lightsabers/dragonpearllightsaber.mdl",},

{name = "[$] Dragon Pearl Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/dragonpearlsaberstaff.mdl",},

{name = "[$] Elegant Modified Double Bladed Saber",
mdl = "models/swtor/arsenic/lightsabers/elegantmodifieddoublebladedsaber.mdl",},

{name = "[$] Etched Dual Saber",
mdl = "models/swtor/arsenic/lightsabers/etchedduelerdualsaber.mdl",},

{name = "[$] Eternal Commander Mk4 Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/eternalcommandermk-14saberstaff.mdl",},

{name = "Eternal Commander Mk4 Saber",
mdl = "models/swtor/arsenic/lightsabers/eternalcommandermk-4lightsaber.mdl",},

{name = "Exarch's Mk1 Saber",
mdl = "models/swtor/arsenic/lightsabers/exarch'smk-1lightsaber.mdl",},

{name = "[$] Herald's Pole Saber",
mdl = "models/swtor/arsenic/lightsabers/herald'spolesaber.mdl",},

{name = "Grantek F11 Saber",
mdl = "models/swtor/arsenic/lightsabers/grantekf11-dlightsaber.mdl",},

{name = "[$] Grantek F11 Dual Saber",
mdl = "models/swtor/arsenic/lightsabers/grantekf11-ddualsaber.mdl",},

{name = "Gemini Mk4 Saber",
mdl = "models/swtor/arsenic/lightsabers/geminimk-4lightsaber.mdl",},

{name = "Frontier Hunter's Saber",
mdl = "models/swtor/arsenic/lightsabers/frontierhunter'slightsaber.mdl",},

{name = "[$] Frontier Hunter's Dual Saber",
mdl = "models/swtor/arsenic/lightsabers/frontierhunter'sdualsaber.mdl",},

{name = "Fire Node Saber",
mdl = "models/swtor/arsenic/lightsabers/firenodelightsaber.mdl",},

{name = "[$] Fearless Retaliator's Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/fearlessretaliator'ssaberstaff.mdl",},

{name = "Fearless Retaliator's Saber",
mdl = "models/swtor/arsenic/lightsabers/fearlessretaliator'slightsaber.mdl",},

{name = "[$] Exquisite Champion Dual Saber",
mdl = "models/swtor/arsenic/lightsabers/exquisitechampiondualsaber.mdl",},

{name = "Executioner's Saber",
mdl = "models/swtor/arsenic/lightsabers/executioner'slightsaber.mdl",},

{name = "Exarch's Mk2 Saber",
mdl = "models/swtor/arsenic/lightsabers/exarch'smk-2lightsaber.mdl",},

{name = "[$] Hermit's Pole Saber",
mdl = "models/swtor/arsenic/lightsabers/hermit'spolesaber.mdl",},

{name = "Hiridu Saber",
mdl = "models/swtor/arsenic/lightsabers/hiridulightsaber.mdl",},

{name = "[$] Hiridu Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/hiridusaberstaff.mdl",},

{name = "Ice-Jewel Saber",
mdl = "models/swtor/arsenic/lightsabers/ice-jewellightsaber.mdl",},

{name = "[$] Indomitable Vanquisher's Staff",
mdl = "models/swtor/arsenic/lightsabers/indomitablevanquisher'ssaberstaff.mdl",},

{name = "[$] Inscrutable Dual Saber",
mdl = "models/swtor/arsenic/lightsabers/inscrutabledualsaber.mdl",},

{name = "Inscrutable Saber",
mdl = "models/swtor/arsenic/lightsabers/inscrutablelightsaber.mdl",},

{name = "Instigator's Saber",
mdl = "models/swtor/arsenic/lightsabers/instigator'slightsaber.mdl",},

{name = "[$] Ioka Mk4 Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/iokathmk-4saberstaff.mdl",},

{name = "Mytag Saber",
mdl = "models/swtor/arsenic/lightsabers/mytaglightsaber.mdl",},

{name = "Nova Saber",
mdl = "models/swtor/arsenic/lightsabers/novalightsaber.mdl",},

{name = "[$] Occultists' Pole Saber Mk1",
mdl = "models/swtor/arsenic/lightsabers/occultists'polesabermk1.mdl",},

{name = "Outlander Saber",
mdl = "models/swtor/arsenic/lightsabers/outlanderlightsaber.mdl",},

{name = "Outlander Saber 2",
mdl = "models/swtor/arsenic/lightsabers/outlanderlightsaber2.mdl",},

{name = "[$] Outlander Pole Saber",
mdl = "models/swtor/arsenic/lightsabers/outlanderpolesaber.mdl",},

{name = "[$] Outlander Pole Saber 2",
mdl = "models/swtor/arsenic/lightsabers/outlanderpolesaber2.mdl",},

{name = "Overseer's Saber",
mdl = "models/swtor/arsenic/lightsabers/overseer'slightsaber.mdl",},

{name = "Pitless Raider Saber",
mdl = "models/swtor/arsenic/lightsabers/pitilessraiderlightsaber.mdl",},

{name = "Praetorian Saber",
mdl = "models/swtor/arsenic/lightsabers/praetorian'slightsaber.mdl",},

{name = "Prismatic Saber",
mdl = "models/swtor/arsenic/lightsabers/prismaticlightsaber.mdl",},

{name = "[$] Prophet's Star Forged Dual Saber",
mdl = "models/swtor/arsenic/lightsabers/prophet'sstarforgeddualsaber.mdl",},

{name = "Reckoning's Exposed Lightsaber",
mdl = "models/swtor/arsenic/lightsabers/reckoning'sexposedlightsaber.mdl",},

{name = "Satele Shan's Sparring Lightsaber",
mdl = "models/swtor/arsenic/lightsabers/sateleshan'ssparringlightsaber.mdl",},

{name = "Senya Tirall's Lightsaber 2",
mdl = "models/swtor/arsenic/lightsabers/senyatirall'slightsaber-cartel.mdl",},

{name = "[$] Reckoning's Exposed Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/reckoning'sexposedsaberstaff.mdl",},

{name = "[$] Redeemer's Star Forged Dual Saber",
mdl = "models/swtor/arsenic/lightsabers/redeemer'sstarforgeddualsaber.mdl",},

{name = "[$] Satele Shan's Dual Saber",
mdl = "models/swtor/arsenic/lightsabers/sateleshan'sdualsaber.mdl",},

{name = "[$] Rishi's Pole Saber",
mdl = "models/swtor/arsenic/lightsabers/rishi'smk-1polesaber.mdl",},

{name = "Rishi's Lightsaber",
mdl = "models/swtor/arsenic/lightsabers/rishi'slightsabermk-1.mdl",},

{name = "Righteous Prime Saber",
mdl = "models/swtor/arsenic/lightsabers/righteousprimevallightsaber.mdl",},

{name = "[$] Revanite Mk2 Pole Saber",
mdl = "models/swtor/arsenic/lightsabers/revanite'smk-2polesaber.mdl",},

{name = "Revanite Mk2 Saber",
mdl = "models/swtor/arsenic/lightsabers/revanite'smk-2lightsaber.mdl",},

{name = "[$] Revanite Mk1 Pole Saber",
mdl = "models/swtor/arsenic/lightsabers/revanite'smk-1polesaber.mdl",},

{name = "Revanite Mk1 Saber",
mdl = "models/swtor/arsenic/lightsabers/revanite'smk-1lightsaber.mdl",},

{name = "[$] Retribution's Exposed Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/retribution'sexposedsaberstaff.mdl",},

{name = "Retribution's Exposed Saber",
mdl = "models/swtor/arsenic/lightsabers/retribution'sexposedlightsaber.mdl",},

{name = "Senya Tirall's Saber",
mdl = "models/swtor/arsenic/lightsabers/senyatirall'slightsaber-companion.mdl",},

{name = "[$] Serenity's Unsealed Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/serenity'sunsealedsaberstaff.mdl",},

{name = "Stronghold Defender's Saber",
mdl = "models/swtor/arsenic/lightsabers/strongholddefender'slightsaber.mdl",},

{name = "[$] Stronghold Defender's Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/strongholddefender'ssaberstaff.mdl",},

{name = "[$] Tempted Apprentice's Dual Blade",
mdl = "models/swtor/arsenic/lightsabers/temptedapprentice'sdualsaber.mdl",},

{name = "Tempted Apprentice's Saber",
mdl = "models/swtor/arsenic/lightsabers/temptedapprentice'slightsaber.mdl",},

{name = "Thermal Light Saber Mk3",
mdl = "models/swtor/arsenic/lightsabers/thermallightsabermk-3.mdl",},

{name = "Thexan's Saber",
mdl = "models/swtor/arsenic/lightsabers/thexan'slightsaber.mdl",},

{name = "Tythonian Saber",
mdl = "models/swtor/arsenic/lightsabers/tythianlightsaber.mdl",},

{name = "Tythonian Force Master's Saber",
mdl = "models/swtor/arsenic/lightsabers/tythonianforce-master'slightsaber.mdl",},

{name = "[$] Unrelenting Aggressor Dual Saber",
mdl = "models/swtor/arsenic/lightsabers/unrelentingaggressordualsaber.mdl",},

{name = "[$] Unstable Arbiter's Dual Saber",
mdl = "models/swtor/arsenic/lightsabers/unstablearbiter'sdualsaber.mdl",},

{name = "Unstable Arbiter's Saber",
mdl = "models/swtor/arsenic/lightsabers/unstablearbiter'slightsaber.mdl",},

{name = "[$] Unstable Peace Maker's Dual Saber",
mdl = "models/swtor/arsenic/lightsabers/unstablepeacemaker'sdualsaber.mdl",},

{name = "Unstable Peace Maker's Saber",
mdl = "models/swtor/arsenic/lightsabers/unstablepeacemaker'slightsaber.mdl",},

{name = "Vengeance's Unsealed Saber",
mdl = "models/swtor/arsenic/lightsabers/vengeance'sunsealedlightsaber.mdl",},

{name = "[$] Vengeance's Unsealed Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/vengeance'sunsealedsaberstaff.mdl",},

{name = "[$] Vigorous Battle Blade",
mdl = "models/swtor/arsenic/lightsabers/vigorousbattlerdualsaber.mdl",},

{name = "Vindicator's Saber",
mdl = "models/swtor/arsenic/lightsabers/vindicator'slightsaber.mdl",},

{name = "Vindicator's Saber Staff",
mdl = "models/swtor/arsenic/lightsabers/vindicator'ssaberstaff.mdl",},

{name = "Saber of the Warden",
mdl = "models/swtor/arsenic/lightsabers/warden'slightsaber.mdl",},

{name = "[$] Warmaster's Double Bladed Saber",
mdl = "models/swtor/arsenic/lightsabers/warmaster'sdoublebladedlightsaber.mdl",},

{name = "[$] Zakuulan Pole Saber",
mdl = "models/swtor/arsenic/lightsabers/zakuulan'smk-1polesaber.mdl",},

{name = "[$] Zakuulan Pole Staff",
mdl = "models/swtor/arsenic/lightsabers/zakuulan'smk-2polesaber.mdl",},

{name = "Zoist Guardian Hilt",
mdl = "models/swtor/arsenic/lightsabers/ziostguardian'slightsaber.mdl",},

{name = "Anakin's Blade 2",
mdl = "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl",},

{name = "Anakin's Blade 3",
mdl = "models/sgg/starwars/weapons/w_anakin_ep3_saber_hilt.mdl",},

{name = "Jedi Blade",
mdl = "models/sgg/starwars/weapons/w_common_jedi_saber_hilt.mdl",},

{name = "Luke's Hilt",
mdl = "models/sgg/starwars/weapons/w_luke_ep6_saber_hilt.mdl",},

{name = "Windu's Hilt",
mdl = "models/sgg/starwars/weapons/w_mace_windu_saber_hilt.mdl",},

{name = "Maul's Half Blade",
mdl = "models/sgg/starwars/weapons/w_maul_saber_half_hilt.mdl",},

{name = "Obi Wan's Hilt 1",
mdl = "models/sgg/starwars/weapons/w_obiwan_ep1_saber_hilt.mdl",},

{name = "Obi Wan's Hilt 3",
mdl = "models/sgg/starwars/weapons/w_obiwan_ep3_saber_hilt.mdl",},

{name = "Quigon's Hilt",
mdl = "models/sgg/starwars/weapons/w_quigon_gin_saber_hilt.mdl",},

{name = "Sidious' Hilt",
mdl = "models/sgg/starwars/weapons/w_sidious_saber_hilt.mdl",},

{name = "Vader's Hilt",
mdl = "models/sgg/starwars/weapons/w_vader_saber_hilt.mdl",},

{name = "Yoda's Hilt",
mdl = "models/sgg/starwars/weapons/w_yoda_saber_hilt.mdl",},

{name = "Dooku's Hilt",
mdl = "models/weapons/starwars/w_dooku_saber_hilt.mdl",},

{name = "Blade of the Stranger",
mdl = "models/weapons/starwars/w_kr_hilt.mdl",},

{name = "[$] Maul's Hilt",
mdl = "models/weapons/starwars/w_maul_saber_staff_hilt.mdl",},

{name = "Aayla's Hilt",
mdl = "models/starwars/cwa/lightsabers/aaylasecura.mdl",},

{name = "Adigalia Blade",
mdl = "models/starwars/cwa/lightsabers/adigalia.mdl",},

{name = "Ahsoka's Hilt",
mdl = "models/starwars/cwa/lightsabers/ahsoka.mdl",},

{name = "Byph Blade",
mdl = "models/starwars/cwa/lightsabers/byph.mdl",},

{name = "Compressed Crystal Blade",
mdl = "models/starwars/cwa/lightsabers/compressedcrystal.mdl",},

{name = "Dark Force Phase 1",
mdl = "models/starwars/cwa/lightsabers/darkforcephase1.mdl",},

{name = "Dark Force Phase 2",
mdl = "models/starwars/cwa/lightsabers/darkforcephase2.mdl",},

{name = "Dark Knight Blade 1",
mdl = "models/starwars/cwa/lightsabers/darkknight1.mdl",},

{name = "Dark Knight Blade 2",
mdl = "models/starwars/cwa/lightsabers/darkknight2.mdl",},

{name = "Dark Saber",
mdl = "models/starwars/cwa/lightsabers/darksaber.mdl",},

{name = "Ancient Dark Saber",
mdl = "models/starwars/cwa/lightsabers/darksaberancient.mdl",},

{name = "Darth Maul's Blade",
mdl = "models/starwars/cwa/lightsabers/darthmaul.mdl",},

{name = "Blade of the Exile",
mdl = "models/starwars/cwa/lightsabers/exile.mdl",},

{name = "Felucia Blade 1",
mdl = "models/starwars/cwa/lightsabers/felucia1.mdl",},

{name = "Felucia Blade 2",
mdl = "models/starwars/cwa/lightsabers/felucia2.mdl",},

{name = "Forked Hilt",
mdl = "models/starwars/cwa/lightsabers/forked.mdl",},

{name = "Ganodi Hilt",
mdl = "models/starwars/cwa/lightsabers/ganodi.mdl",},

{name = "Gungan Hilt",
mdl = "models/starwars/cwa/lightsabers/gungan.mdl",},

{name = "Gungi's Blade",
mdl = "models/starwars/cwa/lightsabers/gungi.mdl",},

{name = "Jocastanu's Blade",
mdl = "models/starwars/cwa/lightsabers/jocastanu.mdl",},

{name = "Kashyyyk Hilt",
mdl = "models/starwars/cwa/lightsabers/kashyyyk.mdl",},

{name = "Katooni Hilt",
mdl = "models/starwars/cwa/lightsabers/katooni.mdl",},

{name = "Kit Fisto's Blade",
mdl = "models/starwars/cwa/lightsabers/kitfisto.mdl",},

{name = "Lightside Affiliation Blade",
mdl = "models/starwars/cwa/lightsabers/lightsideaffiliation.mdl",},

{name = "Luminara's Blade",
mdl = "models/starwars/cwa/lightsabers/luminara.mdl",},

{name = "Petro's Hilt",
mdl = "models/starwars/cwa/lightsabers/petro.mdl",},

{name = "Pulsating Hilt",
mdl = "models/starwars/cwa/lightsabers/pulsating.mdl",},

{name = "Pulsating Blue Hilt",
mdl = "models/starwars/cwa/lightsabers/pulsatingblue.mdl",},

{name = "Ahsoka's Blade 2",
mdl = "models/starwars/cwa/lightsabers/reverseahsoka.mdl",},

{name = "Saeseetiin's Blade",
mdl = "models/starwars/cwa/lightsabers/saeseetiin.mdl",},

{name = "Samurai Blade",
mdl = "models/starwars/cwa/lightsabers/samurai.mdl",},

{name = "Shaak Ti's Blade",
mdl = "models/starwars/cwa/lightsabers/shaakti.mdl",},

{name = "The Sparkling Crystal",
mdl = "models/starwars/cwa/lightsabers/sparklingcrystal.mdl",},

{name = "Spiralling Blade",
mdl = "models/starwars/cwa/lightsabers/spiralling.mdl",},

{name = "Talz's Blade",
mdl = "models/starwars/cwa/lightsabers/talz.mdl",},

{name = "Unstable Blade",
mdl = "models/starwars/cwa/lightsabers/unstable.mdl",},

{name = "Ventress' Blade",
mdl = "models/starwars/cwa/lightsabers/ventress.mdl",},

{name = "Zatt Blade",
mdl = "models/starwars/cwa/lightsabers/zatt.mdl",},

{name = "Zebra Blade",
mdl = "models/starwars/cwa/lightsabers/zebra.mdl",},

{name = "[$] Twin Blade of the Fallen",
mdl = "models/borth-twin/borth-twin.mdl",},

{name = "Dani's Blade",
mdl = "models/dani/dani.mdl",},

{name = "[$] Pike 2",
mdl = "models/donation2/donation2.mdl",},

{name = "Day's Blade",
mdl = "models/days/days.mdl",},

{name = "[$] Pike 1",
mdl = "models/donation1/donation1.mdl",},

{name = "[$] X Factor",
mdl = "models/donation3/donation3.mdl",},

{name = "Blade of the Forgotten",
mdl = "models/dylanxd/dylanxd.mdl",},

{name = "Strange Blade",
mdl = "models/lightsaber2/lightsaber2.mdl",},

{name = "The Cutlass",
mdl = "models/lightsaber3/lightsaber3.mdl",},

{name = "Blade of the Hive",
mdl = "models/lightsaber4/lightsaber4.mdl",},

{name = "Kyle's Hilt",
mdl = "models/sgg/starwars/weapons/w_kyle_saber_hilt.mdl",},

{name = "Mysterious Hilt",
mdl = "models/sgg/starwars/weapons/w_reborn_saber_hilt.mdl",},

{name = "Saber 1",
mdl = "models/sgg/starwars/weapons/w_saber_1_hilt.mdl",},

{name = "Saber 2",
mdl = "mmodels/sgg/starwars/weapons/w_saber_2_hilt.mdl",},

{name = "Saber 3",
mdl = "models/sgg/starwars/weapons/w_saber_3_hilt.mdl",},

{name = "Saber 4",
mdl = "models/sgg/starwars/weapons/w_saber_4_hilt.mdl",},

{name = "Saber 5",
mdl = "models/sgg/starwars/weapons/w_saber_5_hilt.mdl",},

{name = "Saber 6",
mdl = "models/sgg/starwars/weapons/w_saber_6_hilt.mdl",},

{name = "Saber 7",
mdl = "models/sgg/starwars/weapons/w_saber_7_hilt.mdl",},

{name = "Saber 8",
mdl = "models/sgg/starwars/weapons/w_saber_8_hilt.mdl",},

{name = "Saber 9",
mdl = "models/sgg/starwars/weapons/w_saber_9_hilt.mdl",},

{name = "[$] Double Bladed 1",
mdl = "models/sgg/starwars/weapons/w_saber_dual_1_hilt.mdl",},

{name = "[$] Double Bladed 2",
mdl = "models/sgg/starwars/weapons/w_saber_dual_2_hilt.mdl",},

{name = "[$] Double Bladed 3",
mdl = "models/sgg/starwars/weapons/w_saber_dual_3_hilt.mdl",},

{name = "[$] Double Bladed 4",
mdl = "models/sgg/starwars/weapons/w_saber_dual_4_hilt.mdl",},

{name = "[$] Double Bladed 5",
mdl = "models/sgg/starwars/weapons/w_saber_dual_5_hilt.mdl",},

{name = "[$] Snake Pike",
mdl = "models/snake2/snake2.mdl",},

{name = "[$] The Grand Saber",
mdl = "models/the grand saber/the grand saber.mdl",},

{name = "The Knowledge Seeker",
mdl = "models/the knowledge seeker/the knowledge seeker.mdl",},

{name = "[$] Theo's Blade",
mdl = "models/theo/theo.mdl",},

{name = "Training Blade",
mdl = "models/training/training.mdl",},

{name = "[$] Twin Saber",
mdl = "models/twinsaber/twinsaber.mdl",},

{name = "Unknown's Saber",
mdl = "models/unknown/unknown.mdl",},

{name = "Temple Guard Pike",
mdl = "models/pike/pike.mdl",},

{name = "[$$$] Jesus Pike",
	mdl = "models/donation4/donation4.mdl",},

{name = "Suko's Blade",
mdl = "models/pike/pike.mdl",},
}

for k,v in pairs(slaveMadeThese) do
	local item_id = "legacy_saber_" .. string.gsub(string.lower(v.name), "%W", "")
	lts.util.addLightsaber(item_id, nil, v.name, "A brilliant lightsaber.", v.mdl, "Legacy Hilts", {
		isLightsaber = true,
		legacyHilt = true
	})
end



if CLIENT then
local frame
local typeOptions = {
	"Adegan", "Rubat", "Focus", "Kaiburr", "Katak", "Solari", "Dragite", "Vexxtal"
}

local rarityOptions = {
	"Primordial", "Mythic", "Legendary", "Celestial", "Artifact",
	"Unique", "Heroic", "Arcane", "Rare", "Grand", "Basic"
}

local colorOptions = {
	"Advanced Orange", "Advanced Yellow", "Advanced Green", "Advanced Blue", "Advanced Purple", "Advanced Red", "Gray", "Advanced Black",
	"Orange", "Yellow", "Green", "Blue", "Purple", "Red", "White", "Black", "Pink", "Blood Red", "Cyan", "Magenta", "Lime",
	"Advanced Pink", "Bronze", "Viridian", "Silver", "Gold", "Copper", "Indigo", "Orange Yellow", "Teal", "Azure",
	"Amethyst", "Rose", "Chartreuse", "Scarlet", "Lavender", "Crimson", "Turquoise"
}

local function openCrystalMenu()
	if IsValid(frame) then frame:Remove() end

	frame = vgui.Create("DFrame")
	frame:SetSize(520, 460)
	frame:Center()
	frame:SetTitle("")
	frame:MakePopup()
	frame:DockPadding(20, 20, 20, 20)
	frame.Paint = function(s, w, h)
		draw.RoundedBox(12, 0, 0, w, h, Color(20, 20, 25))
		draw.SimpleText("Crystal Creator", "DermaLarge", 20, 10, color_white, 0, 0)
	end

	local corruptedCheckbox = vgui.Create("DCheckBoxLabel", frame)
	corruptedCheckbox:SetText("Corrupted")
	corruptedCheckbox:SetFont("DermaLarge")
	corruptedCheckbox:SetTextColor(color_white)
	corruptedCheckbox:Dock(TOP)
	corruptedCheckbox:DockMargin(0, 40, 0, 20)

	local typeDrop = vgui.Create("DComboBox", frame)
	typeDrop:SetValue("Select Type")
	for _, v in ipairs(typeOptions) do typeDrop:AddChoice(v) end
	typeDrop:Dock(TOP)
	typeDrop:SetTall(35)
	typeDrop:DockMargin(0, 0, 0, 10)

	local rarityDrop = vgui.Create("DComboBox", frame)
	rarityDrop:SetValue("Select Rarity")
	for _, v in ipairs(rarityOptions) do rarityDrop:AddChoice(v) end
	rarityDrop:Dock(TOP)
	rarityDrop:SetTall(35)
	rarityDrop:DockMargin(0, 0, 0, 10)

	local colorDrop = vgui.Create("DComboBox", frame)
	colorDrop:SetValue("Select Color")
	for _, v in ipairs(colorOptions) do colorDrop:AddChoice(v) end
	colorDrop:Dock(TOP)
	colorDrop:SetTall(35)
	colorDrop:DockMargin(0, 0, 0, 10)

	local colorPreview = vgui.Create("DPanel", frame)
	colorPreview:SetTall(60)
	colorPreview:Dock(TOP)
	colorPreview:DockMargin(0, 0, 0, 10)
	colorPreview.Paint = function(s, w, h)
		local name = colorDrop:GetValue()
		local c = crystalColors[name]
		if not c then return end

		local bladeColor = c.color or color_white
		local coreColor = corruptedCheckbox:GetChecked() and Color(0, 0, 0) or (c.innerColor)

		surface.SetMaterial(Material("vgui/gradient-r"))
		surface.SetDrawColor(bladeColor.r, bladeColor.g, bladeColor.b, 255)
		surface.DrawRect(0, 0, w, h)
		
		surface.SetMaterial(Material("vgui/gradient-r"))
		surface.SetDrawColor(coreColor)
		surface.DrawRect(0, 8, w, h-16)
	end

	local function refreshPreview()
		colorPreview:InvalidateLayout()
		colorPreview:PaintManual()
	end

	colorDrop.OnSelect = refreshPreview
	corruptedCheckbox.OnChange = refreshPreview

	local confirm = vgui.Create("DButton", frame)
	confirm:SetText("Summon Crystal")
	confirm:Dock(BOTTOM)
	confirm:SetTall(45)
	confirm:SetFont("DermaLarge")
	confirm.Paint = function(s, w, h)
		draw.RoundedBox(8, 0, 0, w, h, Color(80, 170, 255))
	end
	confirm.DoClick = function()
		local corrupted = corruptedCheckbox:GetChecked()
		local ctype = typeDrop:GetValue()
		local rarity = rarityDrop:GetValue()
		local color = colorDrop:GetValue()

		if ctype == "Select Type" or rarity == "Select Rarity" or color == "Select Color" then
			surface.PlaySound("buttons/button10.wav")
			return
		end

		local id = (corrupted and "corrupted_crystal_" or "crystal_") .. string.lower(ctype .. "_" .. rarity .. "_" .. color)
		chat.AddText(Color(255,0,0), "Spawned: " .. id)

		net.Start("lts.cheat.item")
			net.WriteString(id)
		net.SendToServer()
	end
end

concommand.Add("open_crystal_menu", openCrystalMenu)




end