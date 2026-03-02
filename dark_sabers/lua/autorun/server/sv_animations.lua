util.AddNetworkString("digital.chemistry.anim")
util.AddNetworkString("digital.chemistry.request")
local meta = FindMetaTable("Player")

function meta:networkAnim(s,r,t)
	self.customAnim = self:LookupSequence(s)
	self.sequence = self:LookupSequence(s)
	self.animTime = CurTime() + t or 1
	self.sequenceRate = r
	self.override = true
	self:SetCycle(0)
	
	net.Start("digital.chemistry.anim")
		net.WriteEntity(self)
		net.WriteString(s)
		net.WriteFloat(r or 1)
		net.WriteFloat(t or 1)
	net.Broadcast()
end

net.Receive("digital.chemistry.request", function(len, ply)
	ply.stopSpams = ply.stopSpams or 0
	if ply.stopSpams <= CurTime() then
		local s = net.ReadString()
		local id = ply:LookupSequence(s)

		local len = 0

		if id > -1 then
			len = ply:SequenceDuration(id)
			ply:anim(s, 1, len)
		end

		len = math.Clamp(len, 0.5, 120)

		ply.stopSpams = CurTime() + len
	end
end)