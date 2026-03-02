concommand.Add("lts.materials", function()
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Material Browser")
    frame:SetSize(ScrW() * 0.9, ScrH() * 0.9)
    frame:Center()
    frame:MakePopup()

    local scrollPanel = vgui.Create("DScrollPanel", frame)
    scrollPanel:Dock(FILL)

    local materialPath = "addons/starforge_jvs_ix/materials/"

    local function FindMaterialsInFolder(folder)
        local files, folders = file.Find(folder .. "*", "GAME")

        for _, mat in ipairs(files) do
            if string.EndsWith(mat, ".vmt") or string.EndsWith(mat, ".png2") then
                local matPath = folder .. mat
                local displayPath = string.gsub(matPath, "^addons/starforge_jvs_ix/", "")
				
				if string.EndsWith(mat, ".vmt") then
					displayPath = string.Replace(displayPath, "addons/starforge_jvs_ix/materials/", "")
					displayPath = string.Replace(displayPath, "materials/", "")
					displayPath = string.Replace(displayPath, ".vmt", "")
				end

                local matPanel = vgui.Create("DPanel", scrollPanel)
                matPanel:SetTall(150)
                matPanel:Dock(TOP)
                matPanel:DockMargin(0, 0, 0, 10)

                local matPreview = vgui.Create("DImage", matPanel)
				print(displayPath)
                matPreview:SetMaterial(Material(displayPath))
                matPreview:SetSize(150, 150)
                matPreview:Dock(LEFT)

                local matButton = vgui.Create("DButton", matPanel)
                matButton:SetText(displayPath)
                matButton:SetTextColor(Color(255, 255, 255))
                matButton:Dock(FILL)
                matButton:DockMargin(10, 0, 0, 0)
                matButton:SetContentAlignment(5)

                matButton.DoClick = function()
                    SetClipboardText(displayPath)
                end
            end
        end

        for _, subFolder in ipairs(folders) do
            FindMaterialsInFolder(folder .. subFolder .. "/")
        end
    end

    FindMaterialsInFolder(materialPath)
end)
