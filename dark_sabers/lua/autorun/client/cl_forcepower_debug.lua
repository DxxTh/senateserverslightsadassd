local function OpenPowersMenu()
    -- Create the main frame
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Powers")
    frame:SetSize(ScrW(), ScrH())
    frame:Center()
    frame:MakePopup()
    frame:SetDraggable(false)
    frame:ShowCloseButton(true)

    -- Create a scroll panel to hold the grid
    local scrollPanel = vgui.Create("DScrollPanel", frame)
    scrollPanel:Dock(FILL)

    -- Create a grid layout
    local grid = vgui.Create("DIconLayout", scrollPanel)
    grid:Dock(FILL)
    grid:SetSpaceY(10) -- Vertical spacing between panels
    grid:SetSpaceX(10) -- Horizontal spacing between panels

    -- Variable for number of powers per row
    local powersPerRow = 15 -- You can adjust this number

    -- Retrieve the powers
    local powers = lts.getPowers()

    -- Calculate power panel size
    local spacingX = grid:GetSpaceX() or 10
    local spacingY = grid:GetSpaceY() or 10
    local totalSpacingX = spacingX * (powersPerRow + 1)
    local powerPanelWidth = (frame:GetWide() - totalSpacingX) / powersPerRow
    local powerPanelHeight = powerPanelWidth * 1.25 -- Keeping the aspect ratio

    -- Decide font sizes based on panel width
    local nameFontSize = math.Clamp(math.floor(powerPanelWidth / 10), 16, 24)
    local descFontSize = math.Clamp(math.floor(powerPanelWidth / 12), 12, 16)
    local nameFont = "enigma_" .. nameFontSize
    local descFont = "enigma_" .. descFontSize

    -- Loop through the powers and create panels
    for _, power in pairs(powers) do
        -- Create a panel for each power
        local powerPanel = grid:Add("DPanel")
        powerPanel:SetSize(powerPanelWidth, powerPanelHeight)

        -- Background color
        powerPanel.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(60, 60, 60, 255))
        end

        -- Power icon
        local iconSize = powerPanelWidth * 0.3 -- Adjust icon size proportionally
        local icon = vgui.Create("DImage", powerPanel)
        icon:SetSize(iconSize, iconSize)
        icon:SetPos((powerPanel:GetWide() - icon:GetWide()) / 2, 10)
        icon:SetImage(power.icon or "path/to/default/icon.png")

        -- Power name
        local nameLabel = vgui.Create("DLabel", powerPanel)
        nameLabel:SetPos(10, iconSize + 20)
        nameLabel:SetSize(powerPanel:GetWide() - 20, 30)
        nameLabel:SetFont(nameFont)
        nameLabel:SetText(power.name or "Unnamed Power")
        nameLabel:SetColor(Color(255, 255, 255))
        nameLabel:SetContentAlignment(5) -- Center alignment

        -- Power description
        local descLabel = vgui.Create("DLabel", powerPanel)
        descLabel:SetPos(10, iconSize + 50)
        descLabel:SetSize(powerPanel:GetWide() - 20, powerPanel:GetTall() - (iconSize + 60))
        descLabel:SetFont(descFont)
        descLabel:SetText(power.desc or "No description available.")
        descLabel:SetColor(Color(200, 200, 200))
        descLabel:SetWrap(true)
        descLabel:SetAutoStretchVertical(true)

        -- Click functionality
        powerPanel:SetMouseInputEnabled(true)
        powerPanel.OnMousePressed = function()
            -- Copy the power name to the clipboard
			
			local q = string.Replace(power.name, " ", "+")
			local b = "http://www.google.com/search?q=jedipedia+swtor+force+power+\"" .. q .. "\""
            SetClipboardText(b)
            -- Optional: Notify the player
            notification.AddLegacy("Copied '" .. power.name .. "' to clipboard.", NOTIFY_HINT, 2)
            surface.PlaySound("buttons/button15.wav")
        end
    end
end

-- Hook to open the menu with a console command
concommand.Add("lts.debug.powers", OpenPowersMenu)
