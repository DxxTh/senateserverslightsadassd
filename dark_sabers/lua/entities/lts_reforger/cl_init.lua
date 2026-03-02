include('shared.lua')

function ENT:Draw()
	self.spawntime = self.spawntime or CurTime() + 10
	if self.spawntime <= CurTime() then
		-- we dont draw it.
	else
		self.Entity:DrawModel()  
	end
end

function ENT:Think()
   
end