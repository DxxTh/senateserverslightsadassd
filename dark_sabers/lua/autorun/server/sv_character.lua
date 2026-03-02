lts = lts or {}

local meta = FindMetaTable("Player")

playerData = playerData or {}
lts.chars = lts.chars or {}

function meta:setID(a)
    self.charID = a
end

function meta:uniqueID()
    return self.charID
end

local defaultRanks = {}
defaultRanks.Sith = "Slave"
defaultRanks.Jedi = "Prospect"
defaultRanks.Trooper = "Recruit"
defaultRanks.JTrooper = "Recruit"

local defaultModels = {
    Assassin = {
        Sith = {
            male = "models/fyu/body/clothe_16.mdl",
            female = "models/fyu/body/female_clothe_60.mdl"
        },
        Jedi = {
            male = "models/fyu/body/clothe_124.mdl",
            female = "models/fyu/body/female_clothe_62.mdl"
        }
    },
    Sorcerer = {
        Sith = {
            male = "models/fyu/body/boutique_clothe_2.mdl",
            female = "models/fyu/body/female_clothe_44.mdl"
        },
        Jedi = {
            male = "models/fyu/body/boutique_clothe_24.mdl",
            female = "models/fyu/body/boutique_clothe_26.mdl"
        }
    },
    Juggernaut = {
        Sith = {
            male = "models/fyu/body/boutique_clothe_10.mdl",
            female = "models/fyu/body/boutique_clothe_11.mdl"
        },
        Jedi = {
            male = "models/fyu/body/boutique_clothe_13.mdl",
            female = "models/fyu/body/boutique_clothe_12.mdl"
        }
    },
    Marauder = {
        Sith = {
            male = "models/fyu/body/clothe_147.mdl",
            female = "models/fyu/body/female_clothe_33.mdl"
        },
        Jedi = {
            male = "models/fyu/body/clothe_148.mdl",
            female = "models/fyu/body/female_clothe_74.mdl"
        }
    },
	
	
	Shadow = {
        Sith = {
            male = "models/fyu/body/clothe_16.mdl",
            female = "models/fyu/body/female_clothe_60.mdl"
        },
        Jedi = {
            male = "models/fyu/body/clothe_124.mdl",
            female = "models/fyu/body/female_clothe_62.mdl"
        }
    },
    Sage = {
        Sith = {
            male = "models/fyu/body/boutique_clothe_2.mdl",
            female = "models/fyu/body/female_clothe_44.mdl"
        },
        Jedi = {
            male = "models/fyu/body/boutique_clothe_24.mdl",
            female = "models/fyu/body/boutique_clothe_26.mdl"
        }
    },
    Sentinel = {
        Sith = {
            male = "models/fyu/body/boutique_clothe_10.mdl",
            female = "models/fyu/body/boutique_clothe_11.mdl"
        },
        Jedi = {
            male = "models/fyu/body/boutique_clothe_13.mdl",
            female = "models/fyu/body/boutique_clothe_12.mdl"
        }
    },
	
    Guardian = {
        Sith = {
            male = "models/fyu/body/clothe_147.mdl",
            female = "models/fyu/body/female_clothe_33.mdl"
        },
        Jedi = {
            male = "models/fyu/body/clothe_148.mdl",
            female = "models/fyu/body/female_clothe_74.mdl"
        }
    },
	
	
    Agent = {
        Sith = {
            male = "models/fyu/body/army_emp_14.mdl",
            female = "models/fyu/body/female_army_emp_7.mdl"
        },
        Jedi = {
            male = "models/fyu/body/army_repu_14.mdl",
            female = "models/fyu/body/female_army_repu_7.mdl"
        }
    },
    Trooper = {
        Sith = {
            male = "models/fyu/body/army_emp_6.mdl",
            female = "models/fyu/body/female_army_emp_1.mdl"
        },
        Jedi = {
            male = "models/fyu/body/army_repu_3.mdl",
            female = "models/fyu/body/female_army_repu_1.mdl"
        }
    }
}

/*
["class"]       =       Assassin

["faction"]     =       Sith

*/

function meta:addChar(slot,data)
    local rank = defaultRanks[data.faction] or "Citizen"
    local body = defaultModels[data.class].Sith[data.gender]

    local head = lts.heads()[data.race][data.gender][data.face]

    local def = {}

    def.class = data.class
    def.rank = rank
    def.body = body
    def.race = data.race
    def.gender = data.gender
    def.face = data.face

    lts.chars.create(
        self:SteamID64(),                   -- steamid
        data.name,                          -- name
        "Freshly arrived to this sector.",  -- desc
        head,                               -- model
        data.faction,                       -- team
        self:IPAddress(),                   -- ip
        serialize({x=0,y=0,z=0}),           -- pos
        serialize({}),                      -- inv
        serialize(def),                     -- data
        0,                  -- currency_1
        0,                  -- currency_2
        0,                  -- currency_3
        0,                  -- currency_4
        0,                  -- currency_5
        0,                  -- currency_6
        0,                  -- currency_7
        0,                  -- currency_8
        0                   -- currency_9
    )
end

function meta:getChars()
    local steamID = self:SteamID64()
	playerData[steamID] = playerData[steamID] or {}
    return playerData[steamID]
end







local forcedData = {
	emitter = {
		mdl = "models/lordtyler/lightsaberweaponsgrpgeometricalemitter.mdl",
		tex = "lordtylersservers/lordtyler_MI_LightsaberWeaponsGrpGeometricalEmitter_",
		mat = "steel_rusted_",
		dye = "gold",
		offset = 4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},
	switch = {
		mdl = "models/lordtyler/lightsaberweaponsgrphennixrswitch.mdl",
		tex = "lordtylersservers/lordtyler_MI_LightsaberWeaponsGrpHennixSwitch_",
		mat = "steel_brushed_",
		dye = "sinisterblack",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},
	blade = {
		mdl = "models/lordtyler/lightsaberweaponsgrphennixrgrip.mdl",
		tex = "lordtylersservers/lordtyler_MI_LightsaberWeaponsGrpHennixGrip_",
		mat = "leather_red_",
		dye = "gunmetal",
		offset = 0,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},
	pommel = {
		mdl = "models/lordtyler/lightsaberweaponsgrphennixpommel.mdl",
		tex = "lordtylersservers/lordtyler_MI_LightsaberWeaponsGrpHennixPommel_",
		mat = "steel_rusted_",
		dye = "gold",
		offset = -3.4,
		angs = {
			up = 0,
			right = 0,
			forward = 0,
		},
	},
}

local classes = {
	Sith = {
		Sorcerer = {
			health = {
				base = 1250,
				modifier = 9,
			},
			armor = {
				base = 250,
				modifier = 0.5,
			},
			force = {
				base = 1000,
				modifier = 2.5,
			},
			stamina = {
				base = 100,
				modifier = 0.2,
			},
		},
		Assassin = {
			health = {
				base = 1000,
				modifier = 9,
			},
			armor = {
				base = 300,
				modifier = 0.65,
			},
			force = {
				base = 700,
				modifier = 1.3,
			},
			stamina = {
				base = 120,
				modifier = 0.25,
			},
		},
		Juggernaut = {
			health = {
				base = 2000,
				modifier = 15,
			},
			armor = {
				base = 500,
				modifier = 1,
			},
			force = {
				base = 500,
				modifier = 1,
			},
			stamina = {
				base = 100,
				modifier = 0.25,
			},
		},
		Marauder = {
			health = {
				base = 2000,
				modifier = 12,
			},
			armor = {
				base = 400,
				modifier = 0.75,
			},
			force = {
				base = 500,
				modifier = 1,
			},
			stamina = {
				base = 100,
				modifier = 0.5,
			},
		},
	},
	Jedi = {
		Sage = {
			health = {
				base = 1250,
				modifier = 9,
			},
			armor = {
				base = 250,
				modifier = 0.5,
			},
			force = {
				base = 1000,
				modifier = 2.5,
			},
			stamina = {
				base = 100,
				modifier = 0.2,
			},
		},
		Shadow = {
			health = {
				base = 1000,
				modifier = 9,
			},
			armor = {
				base = 300,
				modifier = 0.65,
			},
			force = {
				base = 700,
				modifier = 1.3,
			},
			stamina = {
				base = 120,
				modifier = 0.25,
			},
		},
		Guardian = {
			health = {
				base = 2000,
				modifier = 15,
			},
			armor = {
				base = 500,
				modifier = 1,
			},
			force = {
				base = 500,
				modifier = 1,
			},
			stamina = {
				base = 100,
				modifier = 0.25,
			},
		},
		Sentinel = {
			health = {
				base = 2000,
				modifier = 12,
			},
			armor = {
				base = 400,
				modifier = 0.75,
			},
			force = {
				base = 500,
				modifier = 1,
			},
			stamina = {
				base = 100,
				modifier = 0.5,
			},
		},
	},
}

function meta:spawnAs(slot)
    local char = self:getChar(slot)
	if char then
		self:setID(slot)
		local head = lts.heads()[char.memory.race][char.memory.gender][char.memory.face]
		self:SetNW2String("head", head)
		self:SetModel(char.memory.body)
		local spawnPositions = {
			["Sith"] = Vector(-9763,-6310, -9634),
			["Jedi"] = Vector(13323,7147, -11787),

		}
		local spawnPos = spawnPositions[char.team] or Vector(0, 0, 0)
		self:SetPos(spawnPos + Vector(math.random(-128,128),math.random(-128,128),0))
		
		local class = classes[char.team][char.memory.class]
		
		local totalHP = (class.health.base + (self:getLevel("Melee")*class.health.modifier))
		local totalAM = class.armor.base + (self:getLevel("Defense")*class.armor.modifier)
		local totalFR = class.force.base + (self:getLevel("Force") * class.force.modifier)
		local totalSM = class.stamina.base + (self:getLevel("Melee") * class.stamina.modifier) + (self:getLevel("Defense") * class.stamina.modifier)
		
		if char.team == "Jedi" or char.team == "Sith" then
			totalHP = totalHP * (1+ lts.holocronBuffs[string.lower(char.team)].health )
			totalAM = totalAM * (1+ lts.holocronBuffs[string.lower(char.team)].armor )
			totalFR = totalFR * (1+ lts.holocronBuffs[string.lower(char.team)].force )
			totalSM = totalSM * (1+ lts.holocronBuffs[string.lower(char.team)].stamina )
		end
		
		self:StripWeapons()
		self:damageTypeSetup()
		self:SetRunSpeed(250)
		self:SetWalkSpeed(100)
		self:networkSkillPoints()
		self:SetNW2Int("charID", slot)
		
		self:setMaxForce(totalFR)
		self:setMaxStamina(totalSM)
		
		self:addStamina(999999)
		self:addForce(999999)
		
		self:addXP("Force", 0)
		self:addXP("Melee", 0)
		self:addXP("Defense", 0)
		
		self:netInv()
		
		self:AddEFlags(EFL_NO_DAMAGE_FORCES)
		
		
		self:SetMaxHealth(totalHP * (1+self:vipBoost()))
		self:SetHealth(self:GetMaxHealth())
		self:SetArmor(totalAM)
		
		self:SetNW2String("subclass", char.memory.class)
		self:SetNW2String("team", char.team)
		self:SetNW2String("name", char.name)
		self:SetNW2String("desc", char.desc)
		self:SetNW2String("role", char.memory.role)
		
		local vipLevel = getVar("vip_" .. self:SteamID64(), 0) or 0
		self:SetNW2Int("vip", vipLevel)
		
		if vipLevel > 0 then
			self:addBooster("Force", lts.vipNames(vipLevel), self:vipBoost(), 999999)
			self:addBooster("Melee", lts.vipNames(vipLevel), self:vipBoost(), 999999)
			self:addBooster("Defense", lts.vipNames(vipLevel), self:vipBoost(), 999999)
		end
		
		self:Give("lts_keys")
	else
		self:ChatPrint("Character " .. slot .. " not found!")
	end
end

function meta:isAlly(tar)
	return self:GetNW2String("team", "") == tar:GetNW2String("team", "")
end

local broadcaster = 0
hook.Add("Think", "saberDataBroadcast", function()
	if broadcaster <= CurTime() then
		--for _, ply in ipairs(player.GetAll()) do
		--	net.Start("tyler.saber")
		--		net.WriteEntity(ply)
		--		net.WriteTable(forcedData)
		--	net.Broadcast()
		--end
		broadcaster = CurTime() + 10
    end
end)

hook.Add("PlayerSpawn", "4920", function(ply)
	timer.Simple(0, function()
		if ply:uniqueID() then ply:spawnAs(ply:uniqueID()) else
            --net.Start("lts.chars")
           --     net.WriteTable(ply:getChars())
           -- net.Send(ply)
			--ply:KillSilent()
        end
	end)
end)

local charData = {
    name = "Joe",
    desc = "Joe momma",
    faction = "Sith",
    class = "Melee",
    race = "Zabrak",
    head = 1,
    male = true,
}

util.AddNetworkString("lts.chars")
net.Receive("lts.chars", function(len, ply)
    net.Start("lts.chars")
        net.WriteTable(ply:getChars())
    net.Send(ply)
end)

util.AddNetworkString("lts.charSelect")
net.Receive("lts.charSelect", function(len, ply)
    local slot = net.ReadInt(32)
    ply:spawnAs(slot)
	ply:Spawn() 
end)

util.AddNetworkString("lts.deleteChar")
net.Receive("lts.deleteChar", function(len, ply)
    local slot = net.ReadInt(32)
    ply:delChar(slot)
end)

util.AddNetworkString("lts.charCreate")
net.Receive("lts.charCreate", function(len, ply)
    local payload = net.ReadTable()
    local chars = ply:getChars()

    local vipSlots = {}
    vipSlots[0] = 2
    vipSlots[1] = 3
    vipSlots[2] = 3
    vipSlots[3] = 4
    vipSlots[4] = 5

    local slots = vipSlots[ply:vipLevel()]

    local canmake = false
    local slot = nil

    for i=1,slots do
        if not chars[i] then
            canmake = true
            slot = i
            break
        end
    end

    if canmake then
        if lts.isClass(payload.faction, payload.class) then
            ply:addChar(slot,payload)
            timer.Simple(3, function()
                --ply:SendLua("lts.charSelect()")
            end)
        else
            lts.networkExploit(ply, "Mismatching faction/class combo during character creation.")
        end
    else
        ply:alert("We couldn't make your character..", "No slots available, consider upgrading to VIP for more lives!")
    end

end)

/*
["class"]       =       Assassin
["face"]        =       1
["faction"]     =       Sith
["gender"]      =       male
["name"]        =        Lord Tyler 2
["race"]        =       Zabrak
*/