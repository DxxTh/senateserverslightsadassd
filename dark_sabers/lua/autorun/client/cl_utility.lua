local mat = {}
function lts.mat(a)
    mat[a]=mat[a] or Material(a)
    return mat[a]
end

concommand.Add("lts", function(ply, cmd, args)
    lts[args[1]]()
end)


net.Receive("lts.alert", function()
    local title = net.ReadString()
    local alert = net.ReadString()
    lts.alert(title, alert)
end)

function lts.alert(title, msg)
    local frame = vgui.Create("DPanel")
    frame:SetSize(1024, 200)
    frame:SetPos(ScrW()/2 - 512, ScrH() * 0.1)
    frame:SetBackgroundColor(Color(0, 0, 0, 0))
    frame:MakePopup(true)

    function frame:Think()
        if input.IsKeyDown(KEY_SPACE) then
            frame:Remove()
        end
    end

    function frame:Paint(w, h)
        surface.SetMaterial(lts.mat("ggui/star_wars/glow_red.png"))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetMaterial(lts.mat("keyboard/light/space_key_light.png"))
        surface.SetDrawColor(255, 255, 255, 255)

        local s = math.abs(math.sin(CurTime()))
        s= math.Clamp(s,0.5,1)

        surface.DrawTexturedRect(w/2- (100*s)/2, h-(75), 100*s, 100*s)
    end

    local titleLabel = vgui.Create("DLabel", frame)
    titleLabel:SetFont("enigma_32")
    titleLabel:SetText(title)
    titleLabel:SizeToContents()
    titleLabel:SetPos((frame:GetWide() - titleLabel:GetWide()) / 2, 40)

    local msgLabel = vgui.Create("DLabel", frame)
    msgLabel:SetFont("enigma_24")
    msgLabel:SetText(msg)
    msgLabel:SizeToContents()
    msgLabel:SetPos((frame:GetWide() - msgLabel:GetWide()) / 2, 100)

    --timer.Simple(0.01, function() gui.EnableScreenClicker(false) end)
end