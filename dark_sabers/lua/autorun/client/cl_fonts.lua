registeredFonts = registeredFonts or {}

function lts.registerFont(name,font,size)
	if not FONTS_REGISTERED then
	   for i=6,64 do
			surface.CreateFont(name .. "_" .. i, {
				font = font,
				size = ScrH() / 1080 * i
			})
			surface.CreateFont(name .. "_" .. i .. "_blur", {
				font = font,
				size = ScrH() / 1080 * i,
				blursize = 4
			})
	   end
	   table.insert(registeredFonts, name)
	end
end

function lts.drawText(text,font,x,y,color,blurcolor,mode)
    draw.DrawText(text,font,x,y,color,mode)
    draw.DrawText(text,font.."_blur",x,y,blurcolor,mode)
end

lts.registerFont( "enigma", "Enigmatic" )
lts.registerFont( "montserrat", "Montserrat" )
lts.registerFont( "latolight", "Lato Light" )
lts.registerFont( "inriasans", "Inria Sans" )
lts.registerFont( "montserrat", "Montserrat")
lts.registerFont( "jetset", "Jet Set")
lts.registerFont( "proxima", "PromixaNova-Regular")
lts.registerFont( "capt", "The Capt")
lts.registerFont( "sw", "Star Jedi")
lts.registerFont( "protobesh", "Protobesh AF")
--lts.registerFont( "luke", "Sky Luke")
lts.registerFont( "aurebesh", "Aurebesh")
lts.registerFont( "basic", "Galactic Basic")
lts.registerFont( "sithbasic", "Kingthings Italique")
--lts.registerFont( "sith", "Sith AF")
--lts.registerFont( "sithpro", "Sith Prophecy")
lts.registerFont( "orb_med", "Orbitron Medium")
lts.registerFont( "orb_black", "Orbitron Black")
lts.registerFont( "laconic", "Laconic-Regular")
lts.registerFont( "conthrax", "ConthraxSb-Regular")

FONTS_REGISTERED = true
concommand.Add("lts.fonts", function()
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Registered Fonts")
    frame:SetSize(600, ScrH() * 0.75)
    frame:Center()
    frame:MakePopup()

    local scrollPanel = vgui.Create("DScrollPanel", frame)
    scrollPanel:Dock(FILL)

    for _, font in ipairs(registeredFonts) do
		print(font)
        local fontName = font .. "_64"
        local label = vgui.Create("DLabel", scrollPanel)
        label:SetText(font)
        label:SetFont(fontName)
        label:SetTextColor(Color(255, 255, 255))
        label:Dock(TOP)
        label:DockMargin(0, 0, 0, 10)
        label:SizeToContents()
    end
end)