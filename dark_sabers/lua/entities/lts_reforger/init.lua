AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/props_c17/oildrum001.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.Entity:GetPhysicsObject():EnableMotion(false)
	self.Entity:GetPhysicsObject():Sleep()
	self:DrawShadow(false)
end

function ENT:Use(ply)
	self.last = self.last or 0
	if self.last <= CurTime() then
		ply:StripWeapons()
		timer.Simple(0.5,function()
			self:Give("tyler_saber")
			net.Start("tyler.saber")
				net.WriteEntity(self)
				net.WriteTable(saberData)
			net.Broadcast()
		end)
		self.last = CurTime()+1
	end
end