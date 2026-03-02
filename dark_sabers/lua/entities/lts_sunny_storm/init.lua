AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.Entity:GetPhysicsObject():EnableMotion(false)
	self.Entity:GetPhysicsObject():Sleep()
	self:DrawShadow(false)
	self:EmitSound("custom_powers/here_comes_the_sun.wav")
end

function ENT:OnRemove()
	self:StopSound("custom_powers/here_comes_the_sun.wav")
end

function ENT:damage()
	self.ply = self.ply or self
	self.dmg = self.dmg or 10
	for k,v in pairs(ents.FindInSphere(self:GetPos(), 256)) do
		if v:IsPlayer() or v:IsNPC() then
			if v ~= self.ply then
				local pos = v:GetPos()
				pos = pos + Vector(0, 0, 64 * 7)
				local g = 128
				--pos = pos + Vector(math.random(-g,g), math.random(-g,g), 0)
				
				local kinetite = ents.Create("ent_cox") -- Replace with the name of your entity
				if IsValid(kinetite) then
					kinetite:SetPos(pos) -- Spawn the entity in front of the player
					kinetite:Spawn()
					kinetite.effect = "lordtyler/cox_orb.png"
					kinetite:Activate()
					kinetite.damage = self.dmg
					kinetite.speed = math.random(500,750)
					kinetite:SetAngles(Vector(0,0,-kinetite.speed):Angle())
					--kinetite:Launch(Vector(0,0,-100), ply)
				end
				
			end
		end
	end
end

function ENT:Think()
	self.zap = self.zap or 0
	if self.zap <= CurTime() then
		self:damage()
		self.zap = CurTime() + math.Rand(1,2)
	end
end