AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Sith Dummy"
ENT.Author = "The Big LT"
ENT.Spawnable = true

-- Config
ENT.Model = "models/player/kleiner.mdl"
ENT.SequenceName = "wos_judge_h_s1_t1"
ENT.PlaybackPercent = 0.25

function ENT:Initialize()
	if SERVER then
		self:SetModel(self.Model)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Sleep()
			phys:EnableMotion(false)
		end

		local seq = self:LookupSequence(self.SequenceName)
		if seq and seq >= 0 then
			self:ResetSequence(seq)
			self:SetCycle(self.PlaybackPercent)
			self:SetPlaybackRate(0)
		end
	end
end

function ENT:Think()
	if SERVER then
	
		local seq = self:LookupSequence(self.SequenceName)
		if seq and seq >= 0 then
			self:ResetSequence(seq)
			self:SetCycle(self.PlaybackPercent)
			self:SetPlaybackRate(0)
		end
		
		self:NextThink(CurTime())
		return true
	end
end











if SERVER then
	util.AddNetworkString("OpenPlaybackMenu")
	util.AddNetworkString("UpdatePlaybackSettings")

	function ENT:Use(activator)
		if not IsValid(activator) or not activator:IsPlayer() then return end

		if activator:KeyDown(IN_RELOAD) then
			if self._nextToggle and self._nextToggle > CurTime() then return end
			self._nextToggle = CurTime() + 1
			self:SetNWBool("evil", not self:GetNWBool("evil", false))
		else
			net.Start("OpenPlaybackMenu")
			net.WriteEntity(self)
			net.WriteString(self:GetModel())
			net.WriteString("")
			net.WriteFloat(self:GetCycle())
			net.Send(activator)
		end
	end

	net.Receive("UpdatePlaybackSettings", function(len, ply)
		local ent = net.ReadEntity()
		if not IsValid(ent) or ent:GetClass() ~= "dummy_1" then return end

		local model = net.ReadString()
		local sequence = net.ReadString()
		local playback = net.ReadFloat()

		if model ~= "" and model ~= ent:GetModel() then
			ent:SetModel(model)
		end
		if sequence ~= "" then
			ent.SequenceName = sequence
		end
		ent.PlaybackPercent = playback
	end)
end

if CLIENT then
	net.Receive("OpenPlaybackMenu", function()
		local ent = net.ReadEntity()
		local curModel = net.ReadString()
		local curSeq = net.ReadString()
		local curCycle = net.ReadFloat()

		local frame = vgui.Create("DFrame")
		frame:SetTitle("Playback Controller")
		frame:SetSize(300, 200)
		frame:Center()
		frame:MakePopup()

		local modelEntry = vgui.Create("DTextEntry", frame)
		modelEntry:SetPos(10, 30)
		modelEntry:SetSize(280, 20)
		modelEntry:SetText(curModel)

		local seqEntry = vgui.Create("DTextEntry", frame)
		seqEntry:SetPos(10, 60)
		seqEntry:SetSize(280, 20)
		seqEntry:SetText(curSeq)

		local slider = vgui.Create("DNumSlider", frame)
		slider:SetPos(10, 90)
		slider:SetSize(280, 40)
		slider:SetText("Playback %")
		slider:SetMin(0)
		slider:SetMax(1)
		slider:SetDecimals(2)
		slider:SetValue(curCycle)
		
		slider.OnValueChanged = function( self, value )
			net.Start("UpdatePlaybackSettings")
			net.WriteEntity(ent)
				net.WriteString("")
				net.WriteString("")
				net.WriteFloat(slider:GetValue())
			net.SendToServer()
		end
				

		local apply = vgui.Create("DButton", frame)
		apply:SetText("Apply")
		apply:SetPos(10, 140)
		apply:SetSize(280, 30)
		apply.DoClick = function()
			net.Start("UpdatePlaybackSettings")
			net.WriteEntity(ent)
			net.WriteString(modelEntry:GetValue())
			net.WriteString(seqEntry:GetValue())
			net.WriteFloat(slider:GetValue())
			net.SendToServer()
			frame:Close()
		end
	end)
	
	
	function ENT:Draw()
		self:DrawModel()
		
		local crystal = {}
		crystal.color = Color(50,50,255)
		
		if self:GetNWBool("evil") then
			crystal.color = Color(255,0,0)
		end
		
		crystal.innerColor = Color(255,255,255)
		
		if not IsValid(self.heldModel) then
			self.heldModel = ClientsideModel("models/swtor/arsenic/lightsabers/revanite'smk-2lightsaber.mdl", RENDERGROUP_OPAQUE)
			self.heldModel:SetNoDraw(true)
		end
		
		
		
		local bone = self:LookupBone("ValveBiped.Bip01_R_Hand") or 0
		local pos, ang = self:GetBonePosition(bone)
		
		pos = pos + ang:Forward() * 2.5 + ang:Up() * -6 + ang:Right() * 0.5
		ang:RotateAroundAxis(ang:Right(), 90)
		
		
	
		self.heldModel:SetPos(pos)
		self.heldModel:SetAngles(ang)
		self.heldModel:DrawModel()
		
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			dlight.pos = pos + ang:Up() * -48 / 2
			dlight.r = crystal.color.r
			dlight.g = crystal.color.g
			dlight.b = crystal.color.b
			dlight.brightness = 1
			dlight.decay = 1000
			dlight.size = 256
			dlight.dietime = CurTime() + 1
		end
		
		local thickness = 0.5
		
		local base = self.heldModel
		
		for id, t in ipairs( self.heldModel:GetAttachments()) do
			if ( !string.match( t.name, "blade(%d+)" ) and !string.match( t.name, "quillon(%d+)" ) ) then continue end

			local bladeNum = string.match( t.name, "blade(%d+)" )
			local quillonNum = string.match( t.name, "quillon(%d+)" )
			local obj = base:LookupAttachment( "blade" .. bladeNum )
			local att = base:GetAttachment(obj)
			if (bladeNum and obj > 0 ) then
				local bladePos = att.Pos
				local bladeAng = att.Ang
				
				bladeAng:RotateAroundAxis(bladeAng:Right(), 90)
				
				render.SetMaterial(mat("hydrasabers/glows/normal.png"))
				render.DrawBeam( bladePos, bladePos + bladeAng:Up() * -39.5, thickness+4, 1, 0, Color(crystal.color.r, crystal.color.g, crystal.color.b))
				render.SetMaterial(mat("hydrasabers/blades/normal.png"))
				render.DrawBeam( bladePos + bladeAng:Up() * -1.5, bladePos + bladeAng:Up() * -(38), thickness*3, 1, 0, Color(crystal.innerColor.r, crystal.innerColor.g, crystal.innerColor.b) )
			end
		end
	end

	function ENT:OnRemove()
		if IsValid(self.heldModel) then
			self.heldModel:Remove()
		end
	end

end

