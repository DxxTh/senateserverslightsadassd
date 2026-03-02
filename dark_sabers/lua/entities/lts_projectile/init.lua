AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel(self.model)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:GetPhysicsObject():EnableGravity(false)
end

function ENT:Think()
	self.riseTime = self.riseTime or CurTime() + 1
	self.riseDist = self.riseDist or 2
	self.killTime = self.killTime or CurTime() + 2
	self.speed = self.speed or 1000
	
	if self.killTime <= CurTime() then
		self:Remove()
	else
		if self.riseTime <= CurTime() then
			if not self.jetted then
				self:GetPhysicsObject():EnableMotion(true)
				
				local dir
				if IsValid(self.player) then
					dir = self.player:EyeAngles():Forward() * self.speed
				else
					dir = self:GetForward() * self.speed
				end
				
				self:GetPhysicsObject():SetVelocity(dir)
				self.jetted = true
			end
		else
			self:GetPhysicsObject():EnableMotion(false)
			self:SetPos(self:GetPos() + Vector(0,0,self.riseDist))
		end
	end
	
	self:NextThink(CurTime()+0.05)
    return true
end

function ENT:PhysicsCollide( data, phys )
	if data.HitEntity:IsPlayer() then
		if data.HitEntity ~= self.player then
			if not self.smacked then
				data.HitEntity:energyBeamDamage(self.damage, 0, self.player)
				self.smacked = true
				self:Remove()
			end
		end
	end
	self:GetPhysicsObject():EnableGravity(true)
end