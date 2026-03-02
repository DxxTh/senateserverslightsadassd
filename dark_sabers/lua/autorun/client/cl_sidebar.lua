harmonyPlanet = harmonyPlanet or "Nowhere"
harmonyX = harmonyX or 0
harmonyY = harmonyY or 0

net.Receive("lts.harmony", function()
	harmonyPlanet = net.ReadString()
	harmonyX = net.ReadInt(32)
	harmonyY = net.ReadInt(32)
end)

local sb = {}

sb.w = ScrW() * 0.15
sb.pad = 25

sb.display = {
	{
		title = "Location",
		color = Color(0,255,255),
		text = function()
			return LocalPlayer():GetNW2String("currentPlanet", "Unknown")
		end
	},{
		title = "Harmony",
		color = Color(255,255,255),
		text = function()
			local ply = LocalPlayer()
			local ending = "lightyears away.."
			if harmonyPlanet == ply:GetNW2String("currentPlanet", "Unknown") then
				local p = ply:GetPos()
				local dis = math.Round(tometers(xydis(p.x, p.y, harmonyX, harmonyY)))
				ending = dis.."m away."
				if dis <= 30 then
					sb.display[2].title = "HARMONIZED " .. GetGlobal2Int("harmonyPercent", 0) .. "%"
					sb.display[2].color = Color(255,255,0)
				else
					sb.display[2].title = "Harmony " .. GetGlobal2Int("harmonyPercent", 0) .. "%"
					sb.display[2].color = Color(255,255,255)
				end
			else
				sb.display[2].title = "Harmony " .. GetGlobal2Int("harmonyPercent", 0) .. "%"
				sb.display[2].color = Color(255,255,255)
			end
			return harmonyPlanet .. ", ".. ending
		end
	},{
		title = "Dueling Rank",
		color = Color(255,195,0),
		text = function()
			return LocalPlayer():GetNW2String("rankedRank", "Loading...")
		end
	},{
		title = "Combat Level",
		color = Color(255,0,0),
		text = function()
			return "Level " .. math.Round((LocalPlayer():getLevel("Force")/3) + (LocalPlayer():getLevel("Melee")/3) + (LocalPlayer():getLevel("Defense")))
		end
	},{
		title = "Force Level",
		color = Color(255,0,255),
		text = function()
			return "Level " .. LocalPlayer():getLevel("Force") .. " (" .. string.Comma(LocalPlayer():getXP("Force")) .."xp)"
		end
	},{
		title = "Melee Level",
		color = Color(255,255,0),
		text = function()
			return "Level " .. LocalPlayer():getLevel("Melee") .. " (" .. string.Comma(LocalPlayer():getXP("Melee")) .."xp)"
		end
	},{
		title = "Defense Level",
		color = Color(255,255,0),
		text = function()
			return "Level " .. LocalPlayer():getLevel("Defense") .. " (" .. string.Comma(LocalPlayer():getXP("Defense")) .."xp)"
		end
	}
}



hook.Add("HUDPaint", "dn53of9g354", function()
if true then return end
	if LocalPlayer():GetNWInt("charID", -1) > -1 and IsValid(LTS_SB) then
		local offset = table.Count(sb.display) * 50
		--drawBlurry(sb.pad, sb.pad, sb.w, (sb.pad * 2) + offset)
		
		surface.SetDrawColor(225,225,255,200)
		surface.SetMaterial(lts.mat("materials/background.png"))
		surface.DrawTexturedRect(sb.pad, sb.pad, sb.w, (sb.pad * 2) + offset)

		local s = 0
		for k,v in pairs(sb.display) do
			s=s+1
			local text = v.text()
			draw.DrawText(v.title, "orb_black_24_blur", sb.pad*2, (sb.pad*2) * s, v.color, TEXT_ALIGN_LEFT )
			draw.DrawText(v.title, "orb_black_24", sb.pad*2, (sb.pad*2) * s, color_white, TEXT_ALIGN_LEFT )
			draw.DrawText(text, "latolight_18", sb.pad*2 + 12, (sb.pad*2) * s + 25, color_white, TEXT_ALIGN_LEFT )
		end
	end
end)