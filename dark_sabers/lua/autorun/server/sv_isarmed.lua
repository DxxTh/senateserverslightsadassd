local meta = FindMetaTable("Player")

function meta:hasSaber()
	return self:GetActiveWeapon():GetClass() == "tyler_saber"
end

function meta:hasKeys()
	return self:GetActiveWeapon():GetClass() == "weapon_keys"
end