util.AddNetworkString("tyler.fakemat")
util.AddNetworkString("tyler.saber")

local saberData = {
	emitter = {
		mdl = "models/lordtyler/lightsaberweaponsgrphennixemitter.mdl",
		tex = "lordtylersservers/lordtyler_MI_LightsaberWeaponsGrpHennixEmitter_",
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

local lastThink = 0

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
