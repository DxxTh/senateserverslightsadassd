AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/Police.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(false)
	
	local phys = self:GetPhysicsObject()
 
	if phys and phys:IsValid() then
		phys:EnableMotion(false)
	end
	timer.Simple(0.1, function()
		if !(self.QID) then self:Remove() end
	end)
--	self:SetSequence("walk_idle")
end

function ENT:Think()
	if (self.anim) then
		if !(self.running) then
			self:SetSequence(self.anim)
			self.running = true
		end
	end
end

function ENT:Start()
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(  SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE || CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
	self:SetMaxYawSpeed( 90 )
end

function ENT:AcceptInput( n, a, ply )	
	if n == "Use" and ply:IsPlayer() then
		if !(self.use) then self.use = CurTime() end
		if self.use <= CurTime() then
			ply:LoadQuest(self.QID)
			ply:SendLua("StartQuestDialog()")
			self.use = CurTime() + 1
		end
	end
end

