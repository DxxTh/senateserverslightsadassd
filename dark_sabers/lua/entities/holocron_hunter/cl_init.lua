include('shared.lua')

function ENT:Draw()
	
	if IsValid(self:GetNW2Entity("owner")) then
		local ply = self:GetNW2Entity("owner")
		if ply:IsPlayer() then
			self:SetPos(ply:GetPos() + Vector(0,0,32) )
		end
	else
		self:SetPos(self:GetPos())
	end
	self.Entity:DrawModel()
end

function ENT:Think()
   
end