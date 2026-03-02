ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.AutomaticFrameAdvance = true
function ENT:SetAutomaticFrameAdvance( bUsingAnim ) -- This is called by the game to tell the entity if it should animate itself.
	self.AutomaticFrameAdvance = bUsingAnim
end
ENT.PrintName		= "QNPC"
ENT.Author			= "Tyler"
ENT.Information		= ""
ENT.Category		= "Kraken"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true
