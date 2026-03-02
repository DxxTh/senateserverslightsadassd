local meta = FindMetaTable("Player")
local inventories = {}
local items = {}

util.AddNetworkString("lts.inv")
util.AddNetworkString("lts.item.move")
util.AddNetworkString("lts.item.use")
util.AddNetworkString("lts.item.combine")


net.Receive("lts.item.use", function(len, ply)
	local inv = ply:getInv()
	
	local a = net.ReadInt(7)
	local b = net.ReadString()
	
	if not inv[a] then return end
	if not lts.item.list[inv[a].id].funcs[b] then return end
	lts.item.list[inv[a].id].funcs[b](ply,a,lts.item.list[inv[a].id])
end)

net.Receive("lts.item.move", function(len, ply)
	local a = net.ReadInt(7)
	local b = net.ReadInt(7)
	ply:moveItem(a, b)
end)

net.Receive("lts.item.combine", function(len, ply)
	local inv = ply:getInv()
	
	local a = net.ReadInt(7) -- dropping
	local b = net.ReadInt(7) -- into
	
	if inv[a] and inv[b] then
		local id = inv[b].id
		local item = lts.item.list[id]
		if item.combine then
			local delete = item.combine(ply,inv,a,b)
			if delete then
				inv[a] = nil
				ply:setInv(inv)
				ply:netInv(true)
			end
		end
	end
end)

function meta:addItem(item, slot, hash)
    local inv = table.Copy(self:getInv())
    slot = slot or self:findFirstAvailableSlot()
	hash = hash or lts.generateHash()
    if not slot then return false, "No available slot" end
    if (slot >= 51 and slot <= 60 and self:vipLevel() < 1) or
       (slot >= 61 and slot <= 80 and self:vipLevel() < 2) or
       (slot >= 81 and slot <= 100 and self:vipLevel() < 3) then
        return false, "Insufficient VIP level"
    end

    if inv[slot] then return false, "Slot already occupied" end

    inv[slot] = {id = item, hash = hash}
    self:setInv(inv)
	self:netInv()
    return true
end

function meta:moveItem(a, b)
    local inv = self:getInv()
    if not inv[a] then return false, "Slot A is empty" end
    if inv[b] then return false, "Slot B is already occupied" end

    inv[b] = inv[a]
    inv[a] = nil
    self:setInv(inv)
	self:netInv()
    return true
end

function meta:removeItem(slot)
    local inv = self:getInv()
    if not inv[slot] then return false, "Slot is empty" end

    inv[slot] = nil
    self:setInv(inv)
	self:netInv()
    return true
end

function meta:getItem(slot)
    local inv = self:getInv()
    if not inv[slot] then return false, "Slot is empty" end
	
    return inv[slot]
end

function meta:findFirstAvailableSlot()
    local inv = self:getInv()
    for i = 1, 100 do
        if not inv[i] then
            if (i >= 51 and i <= 60 and self:vipLevel() < 1) or
               (i >= 61 and i <= 80 and self:vipLevel() < 2) or
               (i >= 81 and i <= 100 and self:vipLevel() < 3) then
                -- Skip slots that require higher VIP level
            else
                return i
            end
        end
    end
    return nil
end

function meta:netInv(open, tars)
    net.Start("lts.inv")
        net.WriteTable(self:getInv())
        net.WriteBool(open)
    net.Send(self or tars)
end

net.Receive("lts.inv", function(len, ply)
    local open = net.ReadBool()
    if ply.character then
        local inv = ply:getInv()
        ply:netInv(open)
    end
end)

concommand.Add("lts.cheat", function(ply, cmd, args)
	local id = args[1]
	
	if lts.item.list[id] then
		ply:addItem(id)
	else
		ply:ChatPrint("Invalid Item")
	end
	
end)

concommand.Add("lts.testinv", function(ply, cmd, args)
    ply:netInv(true)
end)

concommand.Add("lts.testinv3", function(ply, cmd, args)
	ply:setInv({})
end)