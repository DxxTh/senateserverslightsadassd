lts = lts or {}

local scanLines = 8

util.AddNetworkString("saber.scan")

function lts.bladeScan(ply, obj, start, ang, len, reset, bladeID)
	bladeID = bladeID or 1
    local seg = len / scanLines
    local cur = {}
    -- Generate current blade position vectors
    for i = 1, scanLines do
        cur[i] = start + ang:Up() * -(seg * i) + ang:Up() * -4
    end

    if reset then
		obj.prev = obj.prev or {}
		obj.prevAng = ang
		obj.prev[bladeID] = {}
		for i = 1, scanLines do
			obj.prev[bladeID][i] = cur[i] -- initialize with current points
		end
	else
		obj.prev = obj.prev or {}
		obj.prevAng = obj.prevAng or ang
		obj.prev[bladeID] = obj.prev[bladeID] or {}
	end


    local hit
    local tar
    local pos
	local hitWorld
	local hitNormal

    for i = 1, scanLines do
        local realpos = util.TraceLine({
			start = cur[i],
			endpos = obj.prev[bladeID][i],
			filter = {obj, ply},
		})

		if realpos.Hit and not realpos.HitWorld then
			hit = true
			tar = realpos.Entity
			pos = realpos.HitPos
			hitNormal = realpos.HitNormal
			break
		else
			if realpos.HitWorld then
				hit = true
				pos = realpos.HitPos
				hitNormal = realpos.HitNormal
				hitWorld = true
				break
			end
		end
    end

    --Network original points and phantom points
	
	local scanTBL = obj.prev[bladeID]
	if type(scanTBL) == "table" and BLADE_NET then
		net.Start("saber.scan")
			net.WriteTable(scanTBL)
			net.WriteTable(cur)
			net.WriteInt(bladeID, 32)
		net.Broadcast()
	end
	
    obj.prev[bladeID] = cur
	
    if hit then
        return tar, pos, hitWorld, hitNormal
    else
        return nil, nil, nil, nil
    end
end
