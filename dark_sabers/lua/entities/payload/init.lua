AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
    self:SetModel(self.ModelPath or "models/Combine_Helicopter/helicopter_bomb01.mdl") -- default model
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE) -- prevent movement
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false) -- freeze the entity
    end
    self.NextUseTime = 0
end

function ENT:Think()
	if self.anim then
		self.a = self.a or 0
		if self.a <= CurTime() then
			self:SetSequence(self.anim)
			self.a = CurTime() + 5
		end
	end
end

function ENT:Use(ply)
    if CurTime() < (self.NextUseTime or 0) then return end
    self.NextUseTime = CurTime() + 1 -- 1 second delay

    self.payload(ply)
end