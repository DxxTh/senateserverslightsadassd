include('shared.lua')

function ENT:Draw()
	
	self.draw = self.draw or 0
	
	if self.draw <= CurTime() then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos() + Vector(0,0,64*4))
		util.Effect("lts_stormcloud", effectdata)
		self.draw = CurTime() + 0.1
	end
	
	--self:DrawModel()
end

function ENT:Initialize()
	
end

function ENT:Think()
   
end