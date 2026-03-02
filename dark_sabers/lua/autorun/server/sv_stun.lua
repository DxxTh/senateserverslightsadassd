local PLAYER = FindMetaTable("Player")

function PLAYER:addStun(duration)
    if not self.Stuns then
        self.Stuns = {}
    end
	net.Start("DisableJump")
	net.Send(self)
    table.insert(self.Stuns, CurTime() + duration)
end

function PLAYER:purgeStuns()
    self.Stuns = {}
end

function PLAYER:isStunned()
	local isStunned = false
	self.Stuns = self.Stuns or {}
	for k,v in pairs(self.Stuns) do
		if v <= CurTime() then
			table.remove(self.Stuns, k)
		else
			isStunned = true
		end
	end
	return isStunned
end
