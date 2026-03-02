local defaultRun = 250
local defaultWalk = 100

local PLAYER = FindMetaTable("Player")
local NPC = FindMetaTable("NPC")

function NPC:addSlow() end

function PLAYER:addSlow(speed, duration)
    if not self.Slows then
        self.Slows = {}
    end

    table.insert(self.Slows, {speed = speed, expires = CurTime() + duration})

    self:updateMoveSpeed()
end

function PLAYER:updateMoveSpeed()
	local perc = 1 - (self:Health() / self:GetMaxHealth())
	
	local subRun = (defaultRun/2) * perc /2
	local subWalk = (defaultWalk/2) * perc  /2
	
    if not self.Slows or #self.Slows == 0 then
        self:SetSlowWalkSpeed((defaultWalk - subWalk) * 0.5)
        self:SetWalkSpeed(defaultWalk - subWalk)
        self:SetRunSpeed(defaultRun - subRun)
        return
    end

    local lowestSpeed = math.huge

    for _, slow in ipairs(self.Slows) do
        if slow.speed < lowestSpeed then
            lowestSpeed = slow.speed
        end
    end
	
	lowestSpeed = math.Clamp(lowestSpeed, 1, defaultRun - subRun)
	
	self:SetSlowWalkSpeed(lowestSpeed)
    self:SetWalkSpeed(lowestSpeed)
    self:SetRunSpeed(lowestSpeed)
end

hook.Add("Think", "ManageSlows", function()
    for _, ply in ipairs(player.GetAll()) do
        if ply.Slows and #ply.Slows > 0 then
            local currentTime = CurTime()
            for i = #ply.Slows, 1, -1 do
                if ply.Slows[i].expires <= currentTime then
                    table.remove(ply.Slows, i)
                end
            end
            ply:updateMoveSpeed()
        end
    end
end)
