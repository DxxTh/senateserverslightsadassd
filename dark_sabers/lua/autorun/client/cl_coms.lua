net.Receive("ProximityTextChat", function()
        local messageTable = net.ReadTable()
        chat.AddText(unpack(messageTable))
    end)