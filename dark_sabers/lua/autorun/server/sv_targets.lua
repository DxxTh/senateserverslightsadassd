local meta = FindMetaTable("Player")

-- Shared Whitelist Table
local whitelist = {
	["player"] = true,
	["npc"] = true
}

function meta:addToWhitelist(classname)
	whitelist[classname] = true
end

function meta:removeFromWhitelist(classname)
	whitelist[classname] = nil
end

local function isWhitelisted(ent)
	return ent:IsPlayer() or ent:IsNPC()
end

-- Single Target (trace line)
function meta:singleTarget(range)
	local trace = {}
	trace.start = self:GetShootPos()
	trace.endpos = self:GetShootPos() + (self:GetAimVector() * range)
	trace.filter = self
	local tr = util.TraceLine(trace)
	if tr.Hit and isWhitelisted(tr.Entity) then
		return tr.Entity
	else
		return nil
	end
end

function meta:laneCastSingle(range, width)
    local trace = {}
    trace.start = self:GetShootPos()
    trace.endpos = self:GetShootPos() + (self:GetAimVector() * range)
    trace.filter = self
    trace.mins = Vector(-width / 2, -width / 2, 0) -- Adjust for player height, no below-floor casting
    trace.maxs = Vector(width / 2, width / 2, 72) -- Player height is 72 units by default
    local tr = util.TraceHull(trace)

    if tr.Hit and isWhitelisted(tr.Entity) then
        return tr.Entity
    else
        return nil
    end
end

-- Lane Cast Multi-Target with re-tracing and ignoring found entities
function meta:laneCastMulti(range, width)
    local foundEntities = {}
    local ignoreList = {self}
    local continueTracing = true

    while continueTracing do
        local trace = {}
        trace.start = self:GetShootPos()
        trace.endpos = self:GetShootPos() + (self:GetAimVector() * range)
        trace.filter = ignoreList
        trace.mins = Vector(-width / 2, -width / 2, 0) -- Adjust for player height, no below-floor casting
        trace.maxs = Vector(width / 2, width / 2, 72) -- Player height is 72 units by default
        local tr = util.TraceHull(trace)

        if tr.Hit and isWhitelisted(tr.Entity) and not table.HasValue(foundEntities, tr.Entity) then
            table.insert(foundEntities, tr.Entity)
            table.insert(ignoreList, tr.Entity) -- Ignore found entity for the next trace
        else
            continueTracing = false
        end
    end

    return foundEntities
end

-- AOE Cast
function meta:aoeCast(radius)
	local entities = ents.FindInSphere(self:GetPos(), radius)
	local filteredEntities = {}

	for _, ent in ipairs(entities) do
		if isWhitelisted(ent) and ent ~= self then
			table.insert(filteredEntities, ent)
		end
	end

	return filteredEntities
end

function meta:getAlliesInRange(radius)
	local entities = ents.FindInSphere(self:GetPos(), radius)
	local filteredEntities = {}

	for _, ent in ipairs(entities) do
		if isWhitelisted(ent) and ent ~= self then
			if ent:GetNWString("team","") == self:GetNWString("team", "") then
				table.insert(filteredEntities, ent)
			end
		end
	end

	return filteredEntities
end
