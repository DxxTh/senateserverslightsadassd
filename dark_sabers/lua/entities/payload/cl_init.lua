include('shared.lua')

function ENT:Draw()
    self:DrawModel()
end

hook.Add("PostDrawTranslucentRenderables", "DrawTitleOnNPC", function()
    for _, ent in ipairs(ents.FindInSphere(LocalPlayer():GetPos(), 512)) do
        if ent:IsValid() then
            local title = ent:GetNW2String("Title", "")
            if title and title ~= "" then
                -- Set up the position above the entity
                local pos = ent:GetPos() + Vector(0, 0, 80) -- Adjust the height as needed
                local ang = LocalPlayer():EyeAngles()
                ang:RotateAroundAxis(ang:Forward(), 90)
                ang:RotateAroundAxis(ang:Right(), 90)

                cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.07)
                    cam.IgnoreZ(true) -- Ensures the text is drawn over all objects
                    draw.SimpleTextOutlined(
                        title,
                        "conthrax_64",
                        0, 0,
                        Color(255, 221, 28),
                        TEXT_ALIGN_CENTER,
                        TEXT_ALIGN_CENTER,
                        1,
                        Color(0, 0, 0, 255)
                    )
                    cam.IgnoreZ(false)
                cam.End3D2D()
            end
        end
    end
end)