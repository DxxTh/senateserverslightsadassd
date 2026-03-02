-- API to VESSEL SQL Runner, DEBLOATED, 6/16/25

local PLAYER = FindMetaTable("Player")

serialize = util.TableToJSON
deserialize = util.JSONToTable


function PLAYER:getVar(id, def)
    return self:getData(id, def)
end

function PLAYER:setVar(id, val)
    self:setData(id, val, true)
end

function getVar(id, def)
	return getData(id, def)
end

function setVar(id, val)
	setData(id, val)
end

function addLog() end
function PLAYER:addLog() end

function PLAYER:getInv()
    return self:getData("inv", nil) or {}
end

function PLAYER:setInv(inv)
    self:setData("inv", inv, true)
end

function PLAYER:getLevel(skill)
    return math.floor(self:getXP(skill,0)/10000)
end

function PLAYER:getXP(skill)
    return self:getData(skill, 0)
end

function PLAYER:setXP(skill, amt)
    self:setData(skill, amt)
end

function PLAYER:addXP(skill, amt)
    self:setXP(skill, self:getXP() + amt)
end


hook.Add("PlayerSpawn", "lts.loadCh234234ars", function(ply, t)
    timer.Simple(4, function()
		ply:netInv()
		ply:SetRunSpeed(300)
		ply:SetWalkSpeed(100)
		ply:SetNW2String("team", "Sith")
		ply:setMaxForce(250)
		ply:setMaxStamina(100)
	end)
end)


util.AddNetworkString("lts.cheat.item")


net.Receive("lts.cheat.item", function(len, ply)
	if ply:IsAdmin() then
		local id = net.ReadString()
		ply:addItem(id)
	end
end)