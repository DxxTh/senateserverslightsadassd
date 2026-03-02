AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
    self:SetModel("models/props_phx/cannonball.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE) -- prevent movement
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false) -- freeze the entity
    end
end

function ENT:Think()
	self.think = self.think or 0
	self.think2 = self.think2 or 0
	if self.think <= CurTime() then
		if self.think2 <= CurTime() then
			local near = false
			for k,v in pairs(ents.FindInSphere(self:GetPos(), 700)) do
				if v:IsPlayer() then
					near = true
					break
				end
			end
			if near then
				lts.spawnFauna(self, self.limit, self.fauna)
				self.think2 = CurTime() + self.delay
			else
				self.faunaTable = self.faunaTable or {}
				for k,v in pairs(self.faunaTable) do
					if IsValid(v) then
						v:Remove()
					end
				end
			end
		end
		self.think = CurTime() + self.tick
	end
end