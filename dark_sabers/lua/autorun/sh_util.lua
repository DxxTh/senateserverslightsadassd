function tometers(u)
    return u * 0.01905
end

function xydis(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end


EF = EF or {}

function EF.AddNextbot(ENT)
    local class = string.Replace(ENT.Folder, "entities/", "")
    if !ENT.PrintName then return false end
	print(class)
    if CLIENT then
        language.Add(class, ENT.TrueName or ENT.PrintName)
        ENT.Killicon = ENT.Killicon or {
            icon = "HUD/killicons/default",
            color = Color(255, 80, 0, 255)
        }
        killicon.Add(class, ENT.Killicon.icon, ENT.Killicon.color)
    end

    local nextbot = {
        Name = ENT.PrintName,
        Class = class,
        Category = ENT.Category or "Other"
    }

    --if ENT.Spawnable then
        list.Set("NPC", class, nextbot)
    --end
end