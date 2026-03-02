if SAM_LOADED then return end
local sam, command = sam, sam.command

command.set_category("Starforge > Players")

command.new("bar")
	:Help("Open your force bar.")
	:OnExecute(function(ply, title, ...)
		net.Start("lts.power.swap")
			net.WriteTable(ply:getPowers())
		net.Send(ply)
	end)
:End()

command.new("skills")
	:Help("Open the skill tree")
	:OnExecute(function(ply, title, ...)
		net.Start("lts.skilltree")
			net.WriteTable(ply:getPowers())
		net.Send(ply)
	end)
:End()


command.set_category("Starforge > Apprenticeship")

local maxApprenticesPerTeam = {}

-- RequestMaster Command
command.new("requestmaster")
    :Help("Request a player to be your master.")
    :AddArg("player", {single_target = true})
    :OnExecute(function(ply, target)
        target = target[1]

        if ply:getVar("masterID") then
            ply:NotifyLocalized("You already have a master.")
            return
        end

        if not IsValid(target) then
            ply:NotifyLocalized("Invalid target.")
            return
        end

        if target == ply then
            ply:NotifyLocalized("You cannot request yourself.")
            return
        end

        -- Check if the target can have more apprentices
        local targetTeam = target:GetNWString("role", "")
        local maxApprentices = lts.apprentices[targetTeam] or 0

        local apprentices = target:getVar("apprentices", {})
        if #apprentices >= maxApprentices then
            ply:NotifyLocalized("Target cannot have more apprentices.")
            return
        end

        -- Store the request temporarily
        ply.requestedMaster = target
        target:NotifyLocalized(ply:Nick().." has requested you to be their master. Type /acceptapprentice "..ply:Nick().." to accept.")
        ply:NotifyLocalized("You have requested "..target:Nick().." to be your master.")
    end)
:End()

-- AcceptApprentice Command
command.new("acceptapprentice")
    :Help("Accepts the player as your apprentice.")
    :AddArg("player", {single_target = true})
    :OnExecute(function(ply, target)
        target = target[1]

        if not IsValid(target) then
            ply:NotifyLocalized("Invalid target.")
            return
        end

        if target == ply then
            ply:NotifyLocalized("You cannot accept yourself.")
            return
        end

        -- Check if the target has requested to be your apprentice
        if not target.requestedMaster or target.requestedMaster ~= ply then
            ply:NotifyLocalized(target:Nick().." has not requested you to be their master.")
            return
        end

        -- Check if you can have more apprentices
        local targetTeam = ply:GetNWString("role", "")
        local maxApprentices = lts.apprentices[targetTeam] or 0
        local apprentices = ply:getVar("apprentices", {})

        if #apprentices >= maxApprentices then
            ply:NotifyLocalized("You cannot have more apprentices.")
            return
        end

        -- Check if target already has a master
        if target:getVar("masterID") then
            ply:NotifyLocalized(target:Nick().." already has a master.")
            return
        end

        -- Set up the apprenticeship
        table.insert(apprentices, target:uniqueID())
        ply:setVar("apprentices", apprentices)

        target:setVar("masterID", ply:uniqueID())

        -- Remove the request
        target.requestedMaster = nil

        ply:NotifyLocalized("You have accepted "..target:Nick().." as your apprentice.")
        target:NotifyLocalized(ply:Nick().." has accepted you as their apprentice.")
    end)
:End()

-- RequestApprentice Command
command.new("requestapprentice")
    :Help("Request a player to be your apprentice.")
    :AddArg("player", {single_target = true})
    :OnExecute(function(ply, target)
        target = target[1]

        if not IsValid(target) then
            ply:NotifyLocalized("Invalid target.")
            return
        end

        if target == ply then
            ply:NotifyLocalized("You cannot request yourself.")
            return
        end

        -- Check if target already has a master
        if target:getVar("masterID") then
            ply:NotifyLocalized(target:Nick().." already has a master.")
            return
        end

        -- Check if you can have more apprentices
        local targetTeam = ply:GetNWString("role", "")
        local maxApprentices = lts.apprentices[targetTeam] or 0

        if #apprentices >= maxApprentices then
            ply:NotifyLocalized("You cannot have more apprentices.")
            return
        end

        -- Store the request temporarily
        target.requestedApprentice = ply
        target:NotifyLocalized(ply:Nick().." has requested you to be their apprentice. Type /acceptmaster "..ply:Nick().." to accept.")
        ply:NotifyLocalized("You have requested "..target:Nick().." to be your apprentice.")
    end)
:End()

-- AcceptMaster Command
command.new("acceptmaster")
    :Help("Accepts the player as your master.")
    :AddArg("player", {single_target = true})
    :OnExecute(function(ply, target)
        target = target[1]

        if not IsValid(target) then
            ply:NotifyLocalized("Invalid target.")
            return
        end

        if target == ply then
            ply:NotifyLocalized("You cannot accept yourself.")
            return
        end
		
        -- Check if the target has requested you to be their apprentice
        if not ply.requestedApprentice or ply.requestedApprentice ~= target then
            ply:NotifyLocalized(target:Nick().." has not requested you to be their apprentice.")
            return
        end

        -- Check if you already have a master
        if ply:getVar("masterID") then
            ply:NotifyLocalized("You already have a master.")
            return
        end

        -- Check if target can have more apprentices
        local targetTeam = target:GetNWString("role", "")
        local maxApprentices = lts.apprentices[targetTeam] or 0

        if #apprentices >= maxApprentices then
            ply:NotifyLocalized(target:Nick().." cannot have more apprentices.")
            return
        end

        -- Set up the apprenticeship
        table.insert(apprentices, ply:uniqueID())
        target:setVar("apprentices", apprentices)

        ply:setVar("masterID", target:uniqueID())

        -- Remove the request
        ply.requestedApprentice = nil

        ply:NotifyLocalized("You have accepted "..target:Nick().." as your master.")
        target:NotifyLocalized(ply:Nick().." has accepted you as their apprentice.")
    end)
:End()

-- Disavow Command
command.new("disavow")
    :Help("Leave apprenticeship or disown an apprentice.")
    :AddArg("player", {single_target = true, optional = true})
    :OnExecute(function(ply, target)
        target = target and target[1] or nil

        if target then
            -- Disown an apprentice
            if not IsValid(target) then
                ply:NotifyLocalized("Invalid target.")
                return
            end

            local apprentices = ply:getVar("apprentices", {})
            if not table.HasValue(apprentices, target:uniqueID()) then
                ply:NotifyLocalized(target:Nick().." is not your apprentice.")
                return
            end

            table.RemoveByValue(apprentices, target:uniqueID())
            ply:setVar("apprentices", apprentices)

            target:setVar("masterID", nil)

            ply:NotifyLocalized("You have disowned "..target:Nick().." as your apprentice.")
            target:NotifyLocalized(ply:Nick().." has disowned you as their apprentice.")
        else
            -- Leave apprenticeship
            local masterID = ply:getVar("masterID")
            if not masterID then
                ply:NotifyLocalized("You do not have a master.")
                return
            end

            local master = nil
            for _, v in ipairs(player.GetAll()) do
                if v:uniqueID() == masterID then
                    master = v
                    break
                end
            end

            if master then
                local apprentices = master:getVar("apprentices", {})
                table.RemoveByValue(apprentices, ply:uniqueID())
                master:setVar("apprentices", apprentices)
                master:NotifyLocalized(ply:Nick().." has left your apprenticeship.")
            end

            ply:setVar("masterID", nil)
            ply:NotifyLocalized("You have left your apprenticeship.")
        end
    end)
:End()



command.set_category("Starforge > Admins")
command.new("setvip")
	:SetPermission( "admin")
	:Help("Give a player a vip level (0-3)")
	:AddArg("player", {single_target = true})
	:AddArg("number", {hint = "vip rank", optional = false})
	:OnExecute(function(ply, tar, rank)
		tar = tar[1]
		setVar("vip_" .. tar:SteamID64(), rank)
		tar:SetNW2Int("vip", rank)
		for k,v in pairs(player.GetAll()) do
			v:NotifyLocalized(ply:Name() .. " has GRANTED " .. tar:Nick() .. " " .. lts.vipNames(rank))
		end
		
		ply:addLog("ADMIN_ABUSE", "%s ran command %s %s (%s) on %s", {ply:Nick(), "setvip", tostring(rank), lts.vipNames(rank), tar:Nick()})
		
	end)
:End()

command.new("givepower")
	:SetPermission("charadmin", "admin")
	:Help("Give a player a force power")
	:AddArg("player", {single_target = true})
	:AddArg("text", {hint = "powerID", optional = false})
	:OnExecute(function(ply, tar, pwr)
		tar = tar[1]
		local power = lts.getPower(pwr)
		if power then
			tar:grantPower(pwr)
			ply:addLog("ADMIN_ABUSE", "%s ran command %s %s on %s", {ply:Nick(), "givepower", pwr, tar:Nick()})
			for k,v in pairs(player.GetAll()) do
				v:NotifyLocalized(ply:Name() .. " has GRANTED " .. tar:Nick() .. " " .. pwr)
			end
		else
			ply:NotifyLocalized("Invalid power '" .. pwr .. "'")
		end
	end)
:End()

command.new("takepower")
	:SetPermission("charadmin", "admin")
	:Help("Take a players force power")
	:AddArg("player", {single_target = true})
	:AddArg("text", {hint = "powerID", optional = false})
	:OnExecute(function(ply, tar, pwr)
		tar = tar[1]
		local power = lts.getPower(pwr)
		if power then
			tar:takePower(pwr)
			ply:addLog("ADMIN_ABUSE", "%s ran command %s %s on %s", {ply:Nick(), "takepower", pwr, tar:Nick()})
			for k,v in pairs(player.GetAll()) do
				v:NotifyLocalized(ply:Name() .. " has REVOKED " .. tar:Nick() .. "'s " .. pwr)
			end
		else
			ply:NotifyLocalized("Invalid power '" .. pwr .. "'")
		end
	end)
:End()

command.new("revokeallpowers")
	:SetPermission("charadmin", "admin")
	:Help("Take a players force power")
	:AddArg("player", {single_target = true})
	:AddArg("text", {hint = "powerID", optional = false})
	:OnExecute(function(ply, tar, pwr)
		tar = tar[1]
		tar:resetPowers()
		for k,v in pairs(player.GetAll()) do
			v:NotifyLocalized(ply:Name() .. " has REVOKED ALL OF " .. tar:Nick() .. "'s powers.")
		end
		ply:addLog("ADMIN_ABUSE", "%s ran command %s %s on %s", {ply:Nick(), "revokeallpowers", pwr, tar:Nick()})
	end)
:End()



-- Add Item Command
command.new("additem")
    :SetPermission("additem")
    :Help("Adds an item to the target player.")
    :AddArg("player", {single_target = true})
    :AddArg("text", {hint = "Item ID"})
    :OnExecute(function(ply, targets, itemID)
        local target = targets[1]

        if not IsValid(target) then
            ply:Notify("Invalid target.")
            return
        end

        if not itemID or itemID == "" then
            ply:Notify("Invalid item ID.")
            return
        end

        target:addItem(itemID)
		ply:addLog("ADMIN_ABUSE_MAJOR", "%s ran command %s %s on %s", {ply:Nick(), "additem", itemID, target:Nick()})

        for k, v in pairs(player.GetAll()) do
            v:NotifyLocalized(ply:Name() .. " has added item " .. itemID .. " to " .. target:Nick() .. ".")
        end
    end)
:End()

-- Set Variable Command
command.new("setvar")
    :SetPermission("setvar")
    :AddArg("player", {single_target = true})
    :AddArg("text", {hint = "Variable Name"})
    :AddArg("text", {hint = "Value"})
    :Help("Sets a variable on the target player.")
    :OnExecute(function(ply, targets, varName, value)
        local target = targets[1]

        if not IsValid(target) then
            ply:Notify("Invalid target.")
            return
        end

        if not varName or varName == "" then
            ply:Notify("Invalid variable name.")
            return
        end

        target:setVar(varName, value)
		ply:addLog("ADMIN_ABUSE", "%s ran command %s %s on %s", {ply:Nick(), "setvar", varName .." " .. value, target:Nick()})

        for k, v in pairs(player.GetAll()) do
            v:NotifyLocalized(ply:Name() .. " has set variable " .. varName .. " to " .. value .. " on " .. target:Nick() .. ".")
        end
    end)
:End()

-- Set Money Command
command.new("setmoney")
    :SetPermission("setmoney")
    :AddArg("player", {single_target = true})
    :AddArg("number", {hint = "Amount"})
    :Help("Sets the target player's money.")
    :OnExecute(function(ply, targets, amount)
        local target = targets[1]

        if not IsValid(target) then
            ply:Notify("Invalid target.")
            return
        end

        amount = tonumber(amount)
        if not amount then
            ply:Notify("Invalid amount.")
            return
        end

        target:setMoney(amount)
		ply:addLog("ADMIN_ABUSE_MAJOR", "%s ran command %s %s on %s", {ply:Nick(), "setmoney", tostring(amount), target:Nick()})

        for k, v in pairs(player.GetAll()) do
            v:NotifyLocalized(ply:Name() .. " has set " .. target:Nick() .. "'s money to " .. amount .. ".")
        end
    end)
:End()

-- Set Team Command
command.new("setteam")
    :SetPermission("setteam")
    :AddArg("player", {single_target = true})
    :AddArg("text", {hint = "Team Name"})
    :Help("Sets the target player's team.")
    :OnExecute(function(ply, targets, teamName)
        local target = targets[1]

        if not IsValid(target) then
            ply:Notify("Invalid target.")
            return
        end

        if not teamName or teamName == "" then
            ply:Notify("Invalid team name.")
            return
        end

        target:setTeam(teamName)

        for k, v in pairs(player.GetAll()) do
            v:NotifyLocalized(ply:Name() .. " has set " .. target:Nick() .. "'s team to " .. teamName .. ".")
        end
    end)
:End()

command.new("setrole")
    :SetPermission("setrole")
    :AddArg("player", {single_target = true})
    :AddArg("text", {hint = "Role Name"})
    :Help("Sets the target player's role.")
    :OnExecute(function(ply, targets, teamName)
        local target = targets[1]

        if not IsValid(target) then
            ply:Notify("Invalid target.")
            return
        end

        if not teamName or teamName == "" then
            ply:Notify("Invalid role name.")
            return
        end

        target:setVar("role", teamName)
		target:SetNWString("role", teamName)
        for k, v in pairs(player.GetAll()) do
            v:NotifyLocalized(ply:Name() .. " has set " .. target:Nick() .. "'s role to " .. teamName .. ".")
        end
    end)
:End()


command.new("setclass")
    :SetPermission("setclass")
    :AddArg("player", {single_target = true})
    :AddArg("text", {hint = "Class Name"})
    :Help("Sets the target player's class.")
    :OnExecute(function(ply, targets, teamName)
        local target = targets[1]

        if not IsValid(target) then
            ply:Notify("Invalid target.")
            return
        end

        if not teamName or teamName == "" then
            ply:Notify("Invalid class name.")
            return
        end

        target:setVar("class", teamName)

        for k, v in pairs(player.GetAll()) do
            v:NotifyLocalized(ply:Name() .. " has set " .. target:Nick() .. "'s class to " .. teamName .. "!")
        end
    end)
:End()

-- Set Body Model Command
command.new("setbody")
    :SetPermission("setbody")
    :AddArg("player", {single_target = true})
    :AddArg("text", {hint = "Model"})
    :Help("Sets the target player's body model.")
    :OnExecute(function(ply, targets, model)
        local target = targets[1]

        if not IsValid(target) then
            ply:Notify("Invalid target.")
            return
        end

        if not model or model == "" then
            ply:Notify("Invalid model.")
            return
        end

        target:setVar("body", model)

        for k, v in pairs(player.GetAll()) do
            v:NotifyLocalized(ply:Name() .. " has set " .. target:Nick() .. "'s body model to " .. model .. ".")
        end
    end)
:End()
command.new("petflag")
    :SetPermission("petflag")
    :AddArg("player", {single_target = true})
    :Help("Sets the target player's body model.")
    :OnExecute(function(ply, targets)
        local target = targets[1]

        if not IsValid(target) then
            ply:Notify("Invalid target.")
            return
        end

        local flag = target:getVar("petflags", "")

		if flag == "" then
			target:setVar("petflags", "sure")
			for k, v in pairs(player.GetAll()) do
				v:NotifyLocalized(ply:Name() .. " has given pet flags to " .. target:Nick())
			end
		else
			target:setVar("petflags", "")
			for k, v in pairs(player.GetAll()) do
				v:NotifyLocalized(ply:Name() .. " has taken pet flags from " .. target:Nick())
			end
		end
    end)
:End()

-- Set Face Command
command.new("setface")
    :SetPermission("setface")
    :AddArg("player", {single_target = true})
    :AddArg("number", {hint = "Face ID"})
    :Help("Sets the target player's face.")
    :OnExecute(function(ply, targets, faceID)
        local target = targets[1]

        if not IsValid(target) then
            ply:Notify("Invalid target.")
            return
        end

        faceID = tonumber(faceID)
        if not faceID then
            ply:Notify("Invalid face ID.")
            return
        end

        target:setVar("face", faceID)

        for k, v in pairs(player.GetAll()) do
            v:NotifyLocalized(ply:Name() .. " has set " .. target:Nick() .. "'s face ID to " .. faceID .. ".")
        end
    end)
:End()

-- Set Gender Command
command.new("setgender")
    :SetPermission("setgender")
    :AddArg("player", {single_target = true})
    :AddArg("text", {hint = "Gender"})
    :Help("Sets the target player's gender.")
    :OnExecute(function(ply, targets, gender)
        local target = targets[1]

        if not IsValid(target) then
            ply:Notify("Invalid target.")
            return
        end

        if not gender or gender == "" then
            ply:Notify("Invalid gender.")
            return
        end

        target:setVar("gender", gender)

        for k, v in pairs(player.GetAll()) do
            v:NotifyLocalized(ply:Name() .. " has set " .. target:Nick() .. "'s gender to " .. gender .. ".")
        end
    end)
:End()

-- Set Race Command
command.new("setrace")
    :SetPermission("setrace")
    :AddArg("player", {single_target = true})
    :AddArg("text", {hint = "Race"})
    :Help("Sets the target player's race.")
    :OnExecute(function(ply, targets, race)
        local target = targets[1]

        if not IsValid(target) then
            ply:Notify("Invalid target.")
            return
        end

        if not race or race == "" then
            ply:Notify("Invalid race.")
            return
        end

        target:setVar("race", race)

        for k, v in pairs(player.GetAll()) do
            v:NotifyLocalized(ply:Name() .. " has set " .. target:Nick() .. "'s race to " .. race .. ".")
        end
    end)
:End()

-- Set Description Command
command.new("setdesc")
    :SetPermission("setdesc")
    :AddArg("player", {single_target = true})
    :AddArg("text", {hint = "Description"})
    :Help("Sets the target player's description.")
    :OnExecute(function(ply, targets, desc)
        local target = targets[1]

        if not IsValid(target) then
            ply:Notify("Invalid target.")
            return
        end

        if not desc or desc == "" then
            ply:Notify("Invalid description.")
            return
        end

        target:setDesc(desc)

        for k, v in pairs(player.GetAll()) do
            v:NotifyLocalized(ply:Name() .. " has set " .. target:Nick() .. "'s description to " .. desc .. ".")
        end
    end)
:End()

-- Set Name Command
command.new("setname")
    :SetPermission("setname")
    :AddArg("player", {single_target = true})
    :AddArg("text", {hint = "Name"})
    :Help("Sets the target player's name.")
    :OnExecute(function(ply, targets, name)
        local target = targets[1]

        if not IsValid(target) then
            ply:Notify("Invalid target.")
            return
        end

        if not name or name == "" then
            ply:Notify("Invalid name.")
            return
        end

        target:setName(name)

        for k, v in pairs(player.GetAll()) do
            v:NotifyLocalized(ply:Name() .. " has set " .. target:Nick() .. "'s name to " .. name .. ".")
        end
    end)
:End()

-- Add XP Command
command.new("addxp")
    :SetPermission("addxp")
    :AddArg("player", {single_target = true})
    :AddArg("text", {hint = "Skill"})
    :AddArg("number", {hint = "Amount"})
    :Help("Adds XP to the target player's skill.")
    :OnExecute(function(ply, targets, skill, amount)
        local target = targets[1]
        local validSkills = {Force = true, Melee = true, Defense = true}

        if not IsValid(target) then
            ply:Notify("Invalid target.")
            return
        end

        if not validSkills[skill] then
            ply:Notify("Invalid skill. Valid skills are Force, Melee, Defense.")
            return
        end

        amount = tonumber(amount)
        if not amount then
            ply:Notify("Invalid amount.")
            return
        end

        target:addXP(skill, amount)
		ply:addLog("ADMIN_ABUSE_MAJOR", "%s ran command %s %s on %s", {ply:Nick(), "addxp", skill .. " " .. tostring(amount), target:Nick()})

        for k, v in pairs(player.GetAll()) do
            v:NotifyLocalized(ply:Name() .. " has added " .. amount .. " XP to " .. target:Nick() .. "'s " .. skill .. " skill.")
        end
    end)
:End()

-- Add Stamina Command
command.new("addstamina")
    :SetPermission("addstamina")
    :AddArg("player", {single_target = true})
    :AddArg("number", {hint = "Amount"})
    :Help("Adds stamina to the target player.")
    :OnExecute(function(ply, targets, amount)
        local target = targets[1]

        if not IsValid(target) then
            ply:Notify("Invalid target.")
            return
        end

        amount = tonumber(amount)
        if not amount then
            ply:Notify("Invalid amount.")
            return
        end

        target:addStamina(amount)

        for k, v in pairs(player.GetAll()) do
            v:NotifyLocalized(ply:Name() .. " has added " .. amount .. " stamina to " .. target:Nick() .. ".")
        end
    end)
:End()

-- Add Force Command
command.new("addforce")
    :SetPermission("addforce")
    :AddArg("player", {single_target = true})
    :AddArg("number", {hint = "Amount"})
    :Help("Adds force to the target player.")
    :OnExecute(function(ply, targets, amount)
        local target = targets[1]

        if not IsValid(target) then
            ply:Notify("Invalid target.")
            return
        end

        amount = tonumber(amount)
        if not amount then
            ply:Notify("Invalid amount.")
            return
        end

        target:addForce(amount)

        for k, v in pairs(player.GetAll()) do
            v:NotifyLocalized(ply:Name() .. " has added " .. amount .. " force to " .. target:Nick() .. ".")
        end
    end)
:End()
















