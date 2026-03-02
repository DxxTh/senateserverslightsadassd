local canJump = true

net.Receive("DisableJump", function()
	canJump = false
	timer.Simple(2, function() canJump = true end)
end)

hook.Add("CreateMove", "DisableJumpKey", function(cmd)
	if not canJump then
		cmd:RemoveKey(IN_JUMP)
	end
end)