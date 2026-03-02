local lastKick = 0

hook.Add("Think", "dsfgdfG", function()
	local ply = LocalPlayer()
	
	local canKick = true
	
	if lastKick >= CurTime() then canKick = false end
	if vgui.CursorVisible() then canKick = false end
	if ply:IsTyping() then canKick = false end
	
	if canKick then
		if input.IsKeyDown(KEY_F) then
			net.Start("lts.kick")
			net.SendToServer()
			lastKick = CurTime() + 2
		end
	end
end)