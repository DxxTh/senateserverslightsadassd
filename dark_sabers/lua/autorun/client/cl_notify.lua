local alerts = {}
local alertLife = 10

net.Receive("lts.alert.add", function()
	addAlert(net.ReadString())
end)

function addAlert(m)
	local alert = {msg=m,life=CurTime()+alertLife}
	print(m)
	table.insert(alerts, alert)
	surface.PlaySound("hfg/interface/esc.mp3")
end

function lifePerc(a)
	return math.Clamp(a-CurTime(),0,1)
end

hook.Add("HUDPaint", "89j", function()
	local index = -1
	for k,v in SortedPairs(alerts, true) do
		index=index+1
		
		local ap = lifePerc(v.life)
		draw.SimpleText(v.msg, "conthrax_18", ScrW() - 5, 5 + (index*28), Color(0,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText(v.msg, "conthrax_18", ScrW() - 5, 5 + (index*28), Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		if v.life <= CurTime() then
			table.remove(alerts,k)
		end
	end
end)


local announceMessage = ""
local announceTime = 0

net.Receive("lts.event", function()
	announceMessage = net.ReadString()
	announceTime = CurTime() + 10
	surface.PlaySound( "ui/message_holo.wav" )
end)

local mat = Material("lordtyler/aramech/Main Screen Elements/Announce/announcement_texture.png")

hook.Add("HUDPaint", "8429j", function()
	if announceTime >= CurTime() then
	
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(ScrW()/2 - 478/2, ScrH()*0.2, 478, 85)
		
		draw.SimpleText(announceMessage, "conthrax_24_blur", ScrW()/2, ScrH()*0.2 + 40, Color(0,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(announceMessage, "conthrax_24", ScrW()/2, ScrH()*0.2 + 40, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end)




local debuffs = {}

net.Receive("lts.debuff.add", function()
	addDebuff(net.ReadString(), net.ReadInt(32))
end)

function addDebuff(m,t)
	local alert = {msg=m,life=CurTime()+t}
	table.insert(debuffs, alert)
	surface.PlaySound("hfg/weapons/force/distract.wav")
end

hook.Add("HUDPaint", "89j2", function()
	local index = -1
	for k,v in SortedPairs(debuffs, true) do
		index=index+1
		
		local ap = lifePerc(v.life)
		
		draw.SimpleText(v.msg, "conthrax_12", ScrW() - 5, 5 + (index*26), Color(0,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText(v.msg, "conthrax_12", ScrW() - 5, 5 + (index*26), Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		if v.life <= CurTime() then
			table.remove(debuffs,k)
		end
	end
end)



-- ESP for Holocron Hunter Entities

hook.Add("HUDPaint", "HolocronHunterESP", function()

end)
