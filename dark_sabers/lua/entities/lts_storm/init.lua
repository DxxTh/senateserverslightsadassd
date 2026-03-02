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
end

function ENT:strike()
    local pos = self:GetPos()
    pos = pos + Vector(0, 0, 64 * 3.25)
    
    -- Set a random angle offset for the trace direction
    local angleOffset = Angle(math.random(-30, 30), math.random(-30, 30), 0) 
    local direction = -angleOffset:Up()

    local g = 128
	
	pos = pos + Vector(math.random(-g,g), math.random(-g,g), 0)
	
	local h = 64
    local traceStart = pos + Vector(math.random(-h, h), math.random(-h, h), 0)
    local traceEnd = traceStart + direction * 999
    
    local traceData = {}
    traceData.start = traceStart
    traceData.endpos = traceEnd
    traceData.filter = self
    
    local tr = util.TraceLine(traceData)
	
	castLightning(pos, tr.HitPos, 10, "lordtyler/lightning/blue.png", 0.25, Color(56, 75, 255))

end

function ENT:damage()
	self.ply = self.ply or self
	self.dmg = self.dmg or 10
	for k,v in pairs(ents.FindInSphere(self:GetPos(), 256)) do
		if v:IsPlayer() or v:IsNPC() then
			if v ~= self.ply then
				v:applySingleDamage(self.ply, self.dmg, DMG_ENERGYBEAM)
				local pos = self:GetPos()
				pos = pos + Vector(0, 0, 64 * 3.25)
				local g = 128
				pos = pos + Vector(math.random(-g,g), math.random(-g,g), 0)
				castLightning(pos, v:GetPos() + Vector(0,0,64), 10, "lordtyler/lightning/blue.png", 0.25, Color(56, 75, 255))
				v:EmitSound("ix/thunder" .. math.random(1,4) .. ".wav")
			end
		end
	end
	
	
	
end

function ENT:Think()
	self.zap = self.zap or 0
	if self.zap <= CurTime() then
		self:StopSound("hfg/weapons/force/lightning2.wav")
		self:strike()
		self:damage()
		self:EmitSound("ix/thunder" .. math.random(1,4) .. ".wav")
		self.zap = CurTime() + math.Rand(0,0.75)
	end
end