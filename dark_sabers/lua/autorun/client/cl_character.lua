lts = lts or {}

chars = chars or {}

local hasIntro = false

net.Receive("lts.update.char", function()
    local data = net.ReadTable()
	if chars[data.id] then
		if data.isData then
			chars[data.id].memory[data.key] = data.val
		else
			chars[data.id][data.key] = data.val
		end
	end
end)

net.Receive("lts.chars", function()
    chars = net.ReadTable()
    if not hasIntro then lts.introMenu() hasIntro = true end
end)

function lts.getChars()
    return chars
end

function lts.resetChars()
	chars = {}
end

concommand.Add("lts.getchars", function()
    net.Start("lts.chars")
    net.SendToServer()
end)

concommand.Add("lts.chars", function()
    PrintTable(chars)
end)

concommand.Add("lts.charselect", function()
    lts.characterSelect()
end)

playerModels = playerModels or {}

hook.Add("Think", "UpdateClientsideModels", function()
    for _, ply in ipairs(ents.GetAll()) do
		if ply:IsPlayer() or ply:IsNPC() then
			local head = ply:GetNW2String("head", "")
			if head ~= "" then
				playerModels[ply] = playerModels[ply] or ClientsideModel(head, RENDERGROUP_OPAQUE)

				if ply:IsPlayer() and IsValid(ply:GetRagdollEntity()) then
					playerModels[ply]:SetModel(head)
					playerModels[ply]:SetParent(ply:GetRagdollEntity())
					playerModels[ply]:AddEffects(EF_BONEMERGE)
				else
					playerModels[ply]:SetModel(head)
					playerModels[ply]:SetParent(ply)
					playerModels[ply]:AddEffects(EF_BONEMERGE)
				end
			end
		end
	end
end)

concommand.Add("lts.headpop", function()
	for k,v in pairs(playerModels) do
		v:Remove()
	end
	playerModels = {}
end)

hook.Add("EntityRemoved", "RemoveClientsideModel", function(ent)
    if playerModels[ent] and IsValid(playerModels[ent]) then
        playerModels[ent]:Remove()
        playerModels[ent] = nil
    end
end)

hook.Add("CreateClientsideRagdoll", "4222sdf", function(ply,doll)
	local head = ply:GetNW2String("head", "")
	if head ~= "" then
		playerModels[ply]:SetModel(head)
		playerModels[ply]:SetParent(doll)
		playerModels[ply]:AddEffects(EF_BONEMERGE)
	end
end)