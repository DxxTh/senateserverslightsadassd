function GM:OnPlayerHitGround( ply, bInWater, bOnFloater, flFallSpeed )

end

hook.Add("OnPlayerHitGround", "409kj10k4", function(ply)
	local vel = ply:GetVelocity()
	local a = -0.75
	
    if ply.LastJump and CurTime() - ply.LastJump < 2 then
		--print("anus")
        ply:SetVelocity(vel * Vector(a,a,1))
    else
        ply.LastJump = CurTime()
    end
end)

util.AddNetworkString("DisableJump")

hook.Add("KeyPress", "PreventBhop", function(ply, key)
	if key == IN_JUMP then
		if ply:GetJumpCooldown() > CurTime() and not ply:isStunned() then
			net.Start("DisableJump")
			net.Send(ply)
		else
			ply:SetJumpCooldown(CurTime() + 2)
		end
	end
end)

local PLAYER = FindMetaTable("Player")

function PLAYER:SetJumpCooldown(time)
	self.JumpCooldown = time
end

function PLAYER:GetJumpCooldown()
	return self.JumpCooldown or 0
end