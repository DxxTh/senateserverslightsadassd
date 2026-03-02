lts=lts or {}
-- Server-side code
util.AddNetworkString("OpenTeleportMenu")
util.AddNetworkString("StartTeleport")
util.AddNetworkString("StartTeleportCountdown")
util.AddNetworkString("TeleportCancelled")
util.AddNetworkString("TeleportCompleted")

lts.teleportPositions = {}

lts.teleportPositions["Tython"] = {
	Other = Vector(7241,-4533, -7502),
	Jedi = Vector(-5941,4356, 2679),
}

lts.teleportPositions["Tatooine"] = {
	Other = Vector(-12540,-9973, -403),
}


lts.teleportPositions["Mustafar"] = {
	Sith = Vector(6365,-1391, -1282),
	Other = Vector(676,-1180, -1961),
}


lts.teleportPositions["Ilum"] = {
	Sith = Vector(12785,-6983, 110),
	Jedi = Vector(-6285,-13901, -1146),
	Other = Vector(2352,-10205, -974),
}

lts.teleportPositions["Ossus"] = {
	Other = Vector(10330,-6254, 4840),
	Jedi = Vector(10093,-4832, 4770),
}

lts.teleportPositions["Korriban"] = {
	Sith = Vector(2167,-2068, -14270),
	Other = Vector(4556,-6671, -13022),
}

lts.teleportPositions["Mandalore"] = {
	Other = Vector(-14500,8802, 7786),
}

lts.teleportPositions["Dromund Kaas"] = {
	Other = Vector(-6328,6791, 4854),
	Sith = Vector(-7757,10691, 4933),
}


lts.teleportPositions["Dathomir"] = {
	Other = Vector(9873,-13974, 7421),
}

lts.teleportPositions["Makeb"] = {
	Sith = Vector(-3548,7002, 14389),
	Other = Vector(5216,13025, 11914),
	Jedi = Vector(13065,14942, 13223),
}


net.Receive("OpenTeleportMenu", function(len, ply)
	net.Start("OpenTeleportMenu")
		net.WriteTable(lts.teleportPositions)
	net.Send(ply)
end)

net.Receive("StartTeleport", function(len, ply)
    local selectedPlanet = net.ReadString()
    local playerTeam = ply:GetNW2String("team", "Loading")
    local planetPositions = lts.teleportPositions

    local destination = lts.teleportPositions[selectedPlanet][playerTeam] or lts.teleportPositions[selectedPlanet].Other

    local initialPos = ply:GetPos()
    local initialHealth = ply:Health()

    net.Start("StartTeleportCountdown")
		net.WriteInt(5, 32) -- 10 seconds
    net.Send(ply)
	
	ply:addSlow(50, 10)
	
    timer.Simple(5, function()
        if not IsValid(ply) then return end
		ply:SetPos(destination + Vector(math.random(-128,128), math.random(-128,128), 0))
		ply:addLog("TELEPORTER", "%s has teleported to %s", {ply:Nick(), selectedPlanet})
		ply:ChatPrint("Teleported to " .. selectedPlanet .. ".")
		net.Start("TeleportCompleted")
		net.Send(ply)
		timer.Remove(teleportID)
    end)
end)