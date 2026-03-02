lts = lts or {}
local meta = FindMetaTable("Player")

lts.abilityPointLevels = {}
lts.abilityPointLevels.Force = {}
lts.abilityPointLevels.Force[1] = true
lts.abilityPointLevels.Force[3] = true
lts.abilityPointLevels.Force[5] = true
lts.abilityPointLevels.Force[9] = true
lts.abilityPointLevels.Force[15] = true

for i=1,500 do
	lts.abilityPointLevels.Force[i*50] = true
end

lts.abilityPointLevels.Melee = {}
lts.abilityPointLevels.Melee[1] = true
lts.abilityPointLevels.Melee[3] = true
lts.abilityPointLevels.Melee[5] = true
lts.abilityPointLevels.Melee[9] = true
lts.abilityPointLevels.Melee[15] = true

for i=1,500 do
	lts.abilityPointLevels.Melee[i*50] = true
end