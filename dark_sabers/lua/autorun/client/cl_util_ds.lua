concommand.Add("pos", function(ply,cmd,args)
	local p = ply:GetPos()
	local m = "Vector(" .. math.Round(p.x) .. "," .. math.Round(p.y) .. ", " .. math.Round(p.z) .. "),"
	ply:ChatPrint(m)
	SetClipboardText(m)
end)

local blur = Material("pp/blurscreen")

function drawBlur(panel, amount, passes)
	amount = amount or 5
	surface.SetMaterial(blur)
	surface.SetDrawColor(255, 255, 255)

	local x, y = panel:LocalToScreen(0, 0)

	for i = -(passes or 0.2), 1, 0.2 do
		blur:SetFloat("$blur", i * amount)
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
	end
end

function drawBlurAt(x, y, w, h, amount, passes)
	amount = amount or 5
	surface.SetMaterial(blur)
	surface.SetDrawColor(255, 255, 255)

	local scrW, scrH = ScrW(), ScrH()
	local x2, y2 = x / scrW, y / scrH
	local w2, h2 = (x + w) / scrW, (y + h) / scrH

	for i = -(passes or 0.2), 1, 0.2 do
		blur:SetFloat("$blur", i * amount)
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRectUV(x, y, w, h, x2, y2, w2, h2)
	end
end

cachedMats = cachedMats or {}
cachedMats2 = cachedMats2 or {}

function mat(s)
	s = s or "abc"
	cachedMats[s] = cachedMats[s] or Material(s, "noclamp smooth")
	return cachedMats[s]
end

function zmat(s)
	s = s or "abc"
	cachedMats2[s] = cachedMats2[s] or Material(s, "noclamp smooth")
	return cachedMats2[s]
end

local frame_times = {}
local max_samples = 100

function update_frame_time()
    local frame_time = FrameTime()
    
    if #frame_times >= max_samples then
        table.remove(frame_times, 1)
    end
    table.insert(frame_times, frame_time)
    
    local total = 0
    for _, time in ipairs(frame_times) do
        total = total + time
    end
    local average_frame_time = total / #frame_times
    return average_frame_time > 0 and (1 / average_frame_time) or 0
end


local clear_decals = 0
hook.Add("Think", "42809420924", function()
	if clear_decals <= CurTime() then
		game.RemoveRagdolls()
		RunConsoleCommand("r_cleardecals")
		clear_decals = CurTime() + 60
	end
end)