AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Item"

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
		timer.Simple(60, function()
			if IsValid(self) then
				self:Remove()
			end
		end)
	end

	function ENT:Use(ply)
		if not self.used then
			local added, reason = ply:addItem(self.id, nil, self.hash)
			if added then
				self:Remove()
			end
			self.used = true
		end
	end
end