util.AddNetworkString("lts.ray")

function castRay(startPos, endPos, lifeTime, color)
    local t = {
        s = startPos,
        e = endPos,
        l = lifeTime,
        c = color
    }

    net.Start("lts.ray")
        net.WriteTable(t)
    net.Broadcast()
end