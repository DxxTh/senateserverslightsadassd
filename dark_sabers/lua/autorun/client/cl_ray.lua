local rays = {}

function lts.addRay(s, e, l, c)
    local i = #rays + 1
    rays[i] = rays[i] or {}
    rays[i].start = s
    rays[i].endpos = e
    rays[i].time = CurTime() + l
    rays[i].color = c
	
	local effectdata = EffectData()
	effectdata:SetOrigin(e)
	effectdata:SetMagnitude(1)
	util.Effect("ElectricSpark", effectdata)
end

net.Receive("lts.ray", function()
    local t = net.ReadTable()
    lts.addRay(t.s, t.e, t.l, t.c)
end)

hook.Add("PostDrawTranslucentRenderables", "lts.drawRays", function()
    for kk, vv in pairs(rays) do
        if vv.start and vv.endpos then
            render.SetMaterial(lts.mat("lordtyler/misc/ray.png"))
            render.DrawBeam(vv.start, vv.endpos, 6, 0, 1, vv.color)

            local dlight = DynamicLight(99999 + kk)
            if dlight then
                local s = math.random(0.9, 1.25)
                dlight.pos = vv.start
                dlight.r = vv.color.r * s
                dlight.g = vv.color.g * s
                dlight.b = vv.color.b * s
                dlight.brightness = 0.2
                dlight.decay = 100
                dlight.size = 512
                dlight.dietime = CurTime() + 0.2
            end
        end

        if vv.time <= CurTime() then
            rays[kk] = nil
        end
    end
end)
