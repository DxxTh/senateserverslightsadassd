util.AddNetworkString("wotc_data")
util.AddNetworkString("wotc_alert")

local meta = FindMetaTable("Player")

function meta:networkVar(id, def)
	self._pdata[id] = self._pdata[id] or def
	local value = self._pdata[id]
	net.Start("wotc_data")
		net.WriteEntity(self)
		net.WriteString(id)
		net.WriteType(value)
	net.Broadcast()
end

function meta:alert(m)
	net.Start("wotc_alert")
		net.WriteString(m)
	net.Send(self)
end

function meta:setData(key, value, networked)
	self._pdata = self._pdata or {}
	self._pdata[key] = value
	local json = util.TableToJSON(self._pdata)

	sql.Query(string.format(
		"REPLACE INTO player_data (steamid, data) VALUES ('%s','%s')",
		self:SteamID(), sql.SQLStr(json, true)
	))
	
	if networked then
		net.Start("wotc_data")
			net.WriteEntity(self)
			net.WriteString(key)
			net.WriteType(value)
		net.Broadcast()
	end
end

function meta:setMoney(a)
	self:setData("money", a, true)
end

function meta:addMoney(a)
	self:setMoney(self:getMoney() + a)
	self:alert("+" .. string.Comma(a) .."gp")
end

function meta:takeMoney(a)
	self:setMoney(self:getMoney() - a)
	self:alert("-" .. string.Comma(a) .."gp")
end

local networkedVars = {["inventory"] = {}, ["money"] = 0, ["equipment"] = {}}

function meta:loadData()
	local result = sql.Query(string.format(
		"SELECT data FROM player_data WHERE steamid='%s' LIMIT 1", self:SteamID()
	))
	
	PrintTable(result)
	
	if type(result) == "table" then
		self._pdata = util.JSONToTable(result[1].data) or {}
		print("Restored data")
		PrintTable(self._pdata)
	else
		self._pdata = {}
		print("No data found.")
	end
	
	for k,v in pairs(networkedVars) do
		self:networkVar(k, v) -- This way we auto-have our saved data on the client
	end
	
end

hook.Add("Initialize", "CreatePlayerDataTable", function()
	sql.Query([[
		CREATE TABLE IF NOT EXISTS player_data (
			steamid TEXT PRIMARY KEY,
			data TEXT
		);
	]])

	hook.Add("PlayerLoadout", "LoadPlayerData", function(ply)
		if not ply.hasSpawned then
			timer.Simple(1, function()
				ply:loadData()
			end)
			ply.hasSpawned = true
		end
	end)
end)

hook.Add("PlayerSpawn", "SetRPWalkRun", function(ply)
	if not IsValid(ply) then return end
	timer.Simple(0, function()
		if not IsValid(ply) then return end
		ply:SetWalkSpeed(120)
		ply:SetRunSpeed(220)
		ply:SetJumpPower(140)
	end)
end)

hook.Add("Move", "AntiBhopSlowdown", function(ply, mv)
	if not ply:IsOnGround() and mv:GetVelocity():Length2D() > ply:GetWalkSpeed() + 10 then
		local vel = mv:GetVelocity()
		vel.x = vel.x * 0.99
		vel.y = vel.y * 0.99
		mv:SetVelocity(vel)
	end
end)

hook.Add("PlayerLoadout", "CustomLoadout", function(ply)
	ply:StripWeapons()
	ply:Give("wotc_fisticuffs")
	local hands = ply:Give("wotc_hands")
	ply:SetActiveWeapon(hands)
	return true
end)

hook.Add("PlayerSpawn", "RemoveDefaultAmmo", function(ply)
	ply:RemoveAllAmmo()
end)

local server_data = {}

function setData(key, value)
	server_data[key] = value
	local json = util.TableToJSON(server_data)

	sql.Query(string.format(
		"REPLACE INTO player_data (steamid, data) VALUES ('SERVER','%s')",
		sql.SQLStr(json, true)
	))
end

function getData(key, default)
	server_data = server_data or {}

	if not next(server_data) then
		local result = sql.Query("SELECT data FROM player_data WHERE steamid='SERVER' LIMIT 1")
		if istable(result) and result[1] and result[1].data then
			server_data = util.JSONToTable(result[1].data) or {}
		else
			server_data = {}
		end
	end

	return server_data[key] ~= nil and server_data[key] or default
end
