local meta = FindMetaTable("Player")

function meta:getData(key, default)
	if not self._pdata then return default end
	return self._pdata[key] ~= nil and self._pdata[key] or default
end

function meta:getMoney(a)
	return self:getData("money", 0)
end

function meta:hasMoney(a)
	return self:getMoney() >= a
end