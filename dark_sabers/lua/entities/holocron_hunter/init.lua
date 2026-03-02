AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/swtor/arsenic/tyler/orangegrayholocron.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.Entity:GetPhysicsObject():EnableMotion(true)
	self.Entity:GetPhysicsObject():Wake()
	self:DrawShadow(false)
end

function ENT:Use(ply)
	if not self.held then
		self.owner = ply
		self:SetPos(self.owner:GetPos() + Vector(0,0,32))
		self:SetParent(ply)
		self.held = true
		self:SetNW2Entity("owner", ply)
	end
end

function ENT:Think()
	if self.held then
		if self.owner:KeyDown(IN_DUCK) then
			self:SetParent(nil)
			self:SetPos(self.owner:GetPos() + Vector(0,0,32))
			self.owner = false
			self.held = false
			self:SetNW2Entity("owner", self)
			self.Entity:GetPhysicsObject():EnableMotion(true)
			self.Entity:GetPhysicsObject():Wake()
		end
	else
		self:SetParent(nil)
	end
end
