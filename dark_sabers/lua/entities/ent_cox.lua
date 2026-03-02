AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Kinetite"
ENT.Author = "Your Name"
ENT.Information = "A sphere of kinetic energy that travels forward, dealing damage."
ENT.Category = "Force Powers"

ENT.Spawnable = false
ENT.AdminSpawnable = false


function ENT:Initialize()
    -- Set the model
    self:SetModel("models/hunter/misc/sphere025x025.mdl")
    self:SetModelScale(1, 0)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
	self.speed = self.speed or 1000
    -- Wake the physics object
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
        phys:EnableGravity(false) -- Disable gravity so it moves straight
    end
	
	self.damage = self.damage or 100
	self.effect = self.effect or "effects/blueflare1"
	
	self.Sound = CreateSound(self, "ambient/energy/electric_loop.wav")
    self.Sound:Play()
	
    -- Add lightning effect
	if CLIENT then
		self.LightningEffect = ParticleEmitter(self:GetPos())
	end
end

if CLIENT then
	function ENT:Draw() end
end

function ENT:Think()
    -- Ensure the entity keeps moving forward
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:SetVelocity(self:GetForward() * self.speed) -- Adjust speed as necessary
    end
	if CLIENT then
    -- Update the position for the lightning effec
		if self.LightningEffect then
			local particle = self.LightningEffect:Add(self.effect, self:GetPos())
			if particle then
				particle:SetVelocity(Vector(0,0,0))
				particle:SetDieTime(0.1)
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)
				particle:SetStartSize(32)
				particle:SetEndSize(0)
				particle:SetColor(255, 255, 100)
			end
		end
		
		local dlight = DynamicLight(self:EntIndex())
		if dlight then
			dlight.pos = self:GetPos()
			dlight.r = 255
			dlight.g = 255
			dlight.b = 100
			dlight.brightness = 2
			dlight.Decay = 1000
			dlight.Size = 200
			dlight.DieTime = CurTime() + 0.1
		end
    end
	if SERVER then
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 16)) do
			if v:IsNPC() or v:IsPlayer() then
				if v.owner ~= v then
					if not self.came then
						local damageInfo = DamageInfo()
						damageInfo:SetDamage(self.damage) -- Adjust damage amount
						damageInfo:SetAttacker(self.owner or self)
						damageInfo:SetInflictor(self)
						damageInfo:SetDamageType(DMG_ENERGYBEAM)
						v:TakeDamageInfo(damageInfo)
						--v:anim("b_reaction_upper",1,0.5)
						
						local eff = EffectData()
						eff:SetOrigin(v:GetPos())
						util.Effect("Explosion", eff)
						
						self.came = true
						self:Remove()
					end
				end
			end
		end
	end
	
    self:NextThink(CurTime())
    return true
end

function ENT:PhysicsCollide(data, phys)
	if SERVER then
		local hitEnt = data.HitEntity
		if not self.came then
			if IsValid(hitEnt) then
				-- Deal damage
				local damageInfo = DamageInfo()
				damageInfo:SetDamage(self.damage) -- Adjust damage amount
				damageInfo:SetAttacker(self.Owner or self)
				damageInfo:SetInflictor(self)
				damageInfo:SetDamageType(DMG_ENERGYBEAM)
				hitEnt:TakeDamageInfo(damageInfo)
				self.came = true

				-- Optional: Apply force to the hit entity
				if hitEnt:IsPlayer() or hitEnt:IsNPC() then
					local direction = (hitEnt:GetPos() - self:GetPos()):GetNormalized()
					hitEnt:SetVelocity(direction * 500)
					--hitEnt:anim("b_reaction_upper",1,0.5)
				end
			end
		end

		-- Create an impact effect
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos())
		effectData:SetMagnitude(1)
		effectData:SetScale(1)
		effectData:SetRadius(1)
		util.Effect("ElectricSpark", effectData)

		self:Remove()
	end
end

function ENT:Launch(direction, owner)
    self:SetOwner(owner)
    self.Owner = owner
    self:SetAngles(direction:Angle())
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:SetVelocity(direction * self.speed) -- Adjust speed as necessary
    end
end

function ENT:OnRemove()
    if self.LightningEffect then
        self.LightningEffect:Finish()
    end
	if self.Sound then
        self.Sound:Stop()
    end
end