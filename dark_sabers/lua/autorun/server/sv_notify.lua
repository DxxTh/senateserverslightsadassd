local meta = FindMetaTable("Player")

util.AddNetworkString("lts.xp")
util.AddNetworkString("lts.alert.add")

function meta:NotifyLocalized(m)
	net.Start("lts.alert.add")
		net.WriteString(m)
	net.Send(self)
end

function meta:alert(m)
	net.Start("lts.xp")
		net.WriteString(m)
	net.Send(self)
end

function fuck(m)
	net.Start("lts.xp")
		net.WriteString(m)
	net.Send(player.GetAll())
end