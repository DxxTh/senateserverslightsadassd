local function createSegment(s, e, x, random_offset)
    local segments = {}
    for i = 0, x do
        local t = i / x
        local segment = LerpVector(t, s, e)

        if i > 0 and i < x then
            segment = segment + Vector(math.Rand(-random_offset, random_offset), math.Rand(-random_offset, random_offset), math.Rand(-random_offset, random_offset))
        end

        table.insert(segments, segment)
    end
    return segments
end

local function calcLightning(s, e, x)
    local segments = createSegment(s, e, x, 10)
    local sub_segments = {}

    for i = 1, #segments - 1 do
        local sub_end = segments[i]
        local sub_start = segments[i - 1] or s
        local n = x - 1

        if n > 0 then
            local sub_segment = createSegment(sub_start, sub_end, n, 3)
            table.remove(sub_segment, #sub_segment) -- Remove the guaranteed ending position
            table.insert(sub_segments, sub_segment)
        end
    end

    return segments, sub_segments
end

local lightnings = {}

function lts.addLightning(s,e,x,m,l,c)
    local i = #lightnings+1
    local segments, sub_segments = calcLightning(s, e, x)
    lightnings[i] = lightnings[i] or {}
    lightnings[i].segments = segments
    lightnings[i].sub_segments = sub_segments
    lightnings[i].mat = Material(m)
    lightnings[i].time = CurTime() + l
    lightnings[i].color = c
	
	local effectdata = EffectData()
	effectdata:SetOrigin(e)
	effectdata:SetMagnitude(1)
	util.Effect("ElectricSpark", effectdata)

end

net.Receive("lts.lightning", function()
    local t = net.ReadTable()
    lts.addLightning(t.s, t.e, t.x, t.m, t.l, t.c)
end)

net.Receive("lts.lightning.advanced", function()
    local t = net.ReadTable()
    for k,v in pairs(t.v) do
		lts.addLightning(v.s, v.e, t.x, t.m, t.l, t.c)
	end
end)

hook.Add("PostDrawTranslucentRenderables", "2ty", function()
    for kk,vv in pairs(lightnings) do
        local p
        for k, v in pairs(vv.segments) do
            if p then
                render.SetMaterial(vv.mat)
                render.DrawBeam(p, v, 6, 0, 1, Color(255, 255, 255))
                local dlight = DynamicLight(99999+k)
                if ( dlight ) then
                    local s = math.random(0.9,1.25)
                    dlight.pos = p
                    dlight.r = vv.color.r*s
                    dlight.g = vv.color.g*s
                    dlight.b = vv.color.b*s
                    dlight.brightness = 0.2
                    dlight.decay = 100
                    dlight.size = 512
                    dlight.dietime = CurTime() + 0.2
                end
            end
            p = v
        end
        for _, branch in pairs(vv.sub_segments) do
            local bp
            for jj, bv in pairs(branch) do
                if bp then
                    render.SetMaterial(vv.mat)
                    render.DrawBeam(bp, bv, 3, 0, 1, Color(255, 255, 255))
                end
                bp = bv
            end
        end
        if vv.time <= CurTime() then
            lightnings[kk]=nil
        end
    end
end)