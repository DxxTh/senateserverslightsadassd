local meta = FindMetaTable("Player")
meta.steamName = meta.steamName or meta.Name -- cache it so we can remake it.

function meta:customName()
	return self:GetNW2String("name", self:steamName())
end

meta.Name = meta.customName
meta.Nick = meta.customName
meta.GetName = meta.customName

function meta:vipLevel()
	return 3
end