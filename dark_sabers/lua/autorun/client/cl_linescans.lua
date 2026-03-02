lts=lts or {}

local scans = {}
local clscans = {}
local bezierScans = {} -- Store Bezier scans separately
local scanLines = 8

function lts.bladeLines(ply, obj, start, ang, len)
    local seg = len / scanLines

    local cur = {}

    for i=1,scanLines do
        cur[i] = start + ang:Up() * -(seg*i) + ang:Up() * -4
    end

    obj.prev = obj.prev or cur

    local hit
    local tar
	local pos
	
	local data = {prev = obj.prev, cur = cur, time = CurTime() + 0.5}
	table.insert(clscans, data)
    obj.prev = cur
end

net.Receive("saber.scan", function()
    local prev = net.ReadTable()
    local cur = net.ReadTable()
	local bladeID = net.ReadInt(32)
	local data = {prev = prev, cur = cur, time = CurTime() + 3, bladeID = bladeID}
	table.insert(scans, data)
end)

local rainbow_colors = {
    Color(255, 0, 0),     -- 1 = Red
    Color(255, 127, 0),   -- 2 = Orange
    Color(255, 255, 0),   -- 3 = Yellow
    Color(0, 255, 0),     -- 4 = Green
    Color(0, 0, 255),     -- 5 = Blue
    Color(75, 0, 130),    -- 6 = Indigo
    Color(143, 0, 255)    -- 7 = Violet
}

hook.Add("PostDrawTranslucentRenderables", "gfhfhahfa", function()
    for k,v in pairs(scans) do
		if v.time <= CurTime() then
			scans[k] = nil
		else
			-- Render original scans (red)
			for m,d in pairs(v.prev) do
				render.DrawLine(d, v.cur[m], rainbow_colors[v.bladeID])
				--print(v.bladeID)
			end
		end
	end
    for k,v in pairs(clscans) do
		if v.time <= CurTime() then
			clscans[k] = nil
		else
			-- Render client-side scans (green)
			for m,d in pairs(v.prev) do
				render.DrawLine(d, v.cur[m], rainbow_colors[v.bladeID])
			end
		end
	end
end)
