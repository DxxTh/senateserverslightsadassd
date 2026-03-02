local dc = {}
dc.menu = function()
    local f = vgui.Create( "DFrame" )

    local w,h = ScrW() * 0.75, ScrH() * 0.75

    f:SetSize(w,h) 
    f:SetTitle("Digital Chemistry | Animation Viewer")
    f:SetVisible(true)
    f:SetDraggable(false)
    f:ShowCloseButton(true)
    f:MakePopup()
    f:Center()

    function f.Paint(s, ww, hh)
        surface.SetDrawColor(45, 45, 45, 155)
        surface.DrawRect(0, 0, ww, hh)
    end

    local icon = vgui.Create("DModelPanel", f)
    icon:SetPos(0,25)
    icon:SetSize(w/2,h-25)
    icon:SetModel(LocalPlayer():GetModel())

    function icon:runAnimation(s)
        icon.Entity.reset = false
        function icon:LayoutEntity(ent)
            if not ent.reset then
                ent:SetCycle(0)
                ent.reset = true
            end
            ent:SetSequence(ent:LookupSequence(s))
            icon:RunAnimation()
        end
    end

    function icon:LayoutEntity(ent)
        self:runAnimation("menu_gman")
    end

    local pos = icon.Entity:GetPos()
    pos:Add(Vector(0, 0, 40))
    icon:SetLookAt(pos)
    icon:SetCamPos(pos-Vector(-64, 0, 0))
    icon.Entity:SetEyeTarget(pos-Vector(-64, 0, 0))

    local scroll = vgui.Create("DScrollPanel", f)
    scroll:SetPos(w/2,25)
    scroll:SetSize(w/2 - 25,h-50)

    function scroll:Paint() end


    for i=0,icon.Entity:GetSequenceCount() do

        local p = vgui.Create("DPanel", scroll)
        p:SetSize(24,24)
        p:Dock(TOP)
        function p:Paint() end

        local butt = vgui.Create("DButton", p)
        butt:SetText(icon.Entity:GetSequenceName(i))
        butt:SetSize((w/2)/3,24)
        butt:Dock(LEFT)
        butt:SetTextColor(Color(255,255,255))
        butt.DoClick = function()
            icon:runAnimation(icon.Entity:GetSequenceName(i))
        end
        
        butt:DockMargin(0,1,0,0)
        function butt.Paint(s,ww,hh)
            surface.SetDrawColor(160, 26, 88, 200)
            surface.DrawRect(0, 0, ww, hh)
        end

        local butt = vgui.Create("DButton", p)
        butt:SetText("ANIMATE PLAYER")
        butt:SetSize((w/2)/3,24)
        butt:Dock(LEFT)
        butt:SetTextColor(Color(255,255,255))
        butt.DoClick = function()
            net.Start("digital.chemistry.request")
                net.WriteString(icon.Entity:GetSequenceName(i)) -- its protected you asshole.
            net.SendToServer()
            f:Remove()
        end
        
        butt:DockMargin(0,1,0,0)
        function butt.Paint(s,ww,hh)
            surface.SetDrawColor(114, 60, 112, 200)
            surface.DrawRect(0, 0, ww, hh)
        end

        local butt = vgui.Create("DButton", p)
        butt:SetText("COPY BIND")
        butt:SetSize((w/2)/3,24)
        butt:Dock(LEFT)
        butt:SetTextColor(Color(255,255,255))
        butt.DoClick = function()
            SetClipboardText("bind m \"dc_play " .. icon.Entity:GetSequenceName(i) .. "\"")
            chat.AddText(Color(155,0,0), "[DIGITAL CHEMISTRY] ", Color(255,255,255), "'" .. icon.Entity:GetSequenceName(i) .. "' has been copied to your clipboard.")
        end
        
        butt:DockMargin(0,1,0,0)
        function butt.Paint(s,ww,hh)
            surface.SetDrawColor(0, 145, 173, 200)
            surface.DrawRect(0, 0, ww, hh)
        end
    end
end

list.Add( "DesktopWindows", {
    icon = "digital_chemistry/logo.png",
    title = "DC Viewer",
    init = function() dc.menu() end,
})

concommand.Add("dc_play", function(ply, cmd, args)
    if args[1] then
        net.Start("digital.chemistry.request")
            net.WriteString(args[1]) -- its protected you asshole.
        net.SendToServer()
    end
end)