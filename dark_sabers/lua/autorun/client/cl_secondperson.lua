local removeBones = {
	"ValveBiped.Bip01_Head1",
	"ValveBiped.Bip01_Neck1"
}

local modAngX = 0
local modAngY = 0

local holdtypes = {
	melee2 = { origin = { up = 1, forward = 8, right = 3 } },
	ar2 = { origin = { up = 3, forward = 8, right = 2 } },
	revolver = { origin = { up = 3, forward = 8, right = 2 } },
	pistol = { origin = { up = 3, forward = 8, right = 4 } },
	smg = { origin = { up = 3, forward = 8, right = 2 } },
	shotgun = { origin = { up = 3, forward = 8, right = -4 } },
	grenade = { origin = { up = 3, forward = 11, right = 2 } },
	rpg = { origin = { up = 3, forward = 8, right = 0 } },
	physgun = { origin = { up = 3, forward = 8, right = -4 } },
	crossbow = { origin = { up = 3, forward = 8, right = -4 } },
	melee = { origin = { up = 3, forward = 11, right = 2 } },
	slam = { origin = { up = 3, forward = 8, right = 2 } },
	normal = { origin = { up = 3, forward = 8, right = 2 } },
	idle = { origin = { up = 3, forward = 8, right = 2 } },
	fist = { origin = { up = 3, forward = 8, right = 2 } },
	knife = { origin = { up = 3, forward = 8, right = 2 } },
	duel = { origin = { up = 3, forward = 8, right = 2 } },
	camera = { origin = { up = 3, forward = 8, right = 2 } }
}

local thirdPersonEnabled = true
local head

local function toggleThirdPerson()
	thirdPersonEnabled = not thirdPersonEnabled
	if thirdPersonEnabled then head = nil end
end

concommand.Add("lts.3p", toggleThirdPerson)

hook.Add("CalcView", "SecondPersonView", function(player, pos, ang, fov)
	if thirdPersonEnabled then
		local tar = player:GetAttachment(player:LookupAttachment("eyes")).Pos
		if not head then
			head = tar
		end

		head = LerpVector(FrameTime()*12, head, tar)
		
		ang:RotateAroundAxis(player:GetUp(), modAngX)
		
		local wish = head - (ang:Forward() * 75  + ang:Right() * -15)
		
		local tr = util.TraceLine( {
			start = head,
			endpos = wish,
			filter = function() return false end
		})
		
		if tr.HitWorld then
			wish = tr.HitPos + ang:Forward() * 5
		end
		
		--ang:RotateAroundAxis(ang:Up(), 45)
		
		local view = {
			origin = wish,
			angles = ang,
			fov = fov,
			drawviewer = true
		}
	
		return view
	else
		local weapon = player:GetActiveWeapon()
		if IsValid(weapon) and holdtypes[weapon:GetHoldType()] and (weapon:GetClass() == "tyler_saber" or weapon:GetClass() == "nico_holocom") then
			local eyeAttachment = player:GetAttachment(player:LookupAttachment("eyes"))
			local originOffset = holdtypes[weapon:GetHoldType()].origin
			local adjustedAng = Angle(eyeAttachment.Ang.p, player:GetAngles().y, 0)

			local view = {
				origin = eyeAttachment.Pos + (player:GetUp() * (originOffset.up + 2)) - (player:GetForward() * (originOffset.forward - 1)) + (player:GetRight() * originOffset.right),
				angles = ang,
				fov = fov,
				drawviewer = true
			}
			return view
		end
	end
end)

hook.Add("Think", "SecondPersonBoneManipulation", function()
	local player = LocalPlayer()
	local weapon = player:GetActiveWeapon()
	if IsValid(weapon) and holdtypes[weapon:GetHoldType()] and (weapon:GetClass() == "tyler_saber" or weapon:GetClass() == "nico_holocom") and not thirdPersonEnabled then
		for _, bone in pairs(removeBones) do
			if player:LookupBone(bone) then
				player:ManipulateBoneScale(player:LookupBone(bone), Vector() * 0)
			end
		end
	else
		for _, bone in pairs(removeBones) do
			if player:LookupBone(bone) then
				player:ManipulateBoneScale(player:LookupBone(bone), Vector(1, 1, 1))
			end
		end
	end
end)


local camKeys = {}

camKeys[IN_JUMP] = true
camKeys[IN_WALK] = true
camKeys[IN_SPEED] = true
camKeys[IN_RUN] = true
camKeys[IN_MOVELEFT] = true
camKeys[IN_MOVERIGHT] = true
camKeys[IN_BACK] = true
camKeys[IN_FORWARD] = true
camKeys[IN_ATTACK] = true
camKeys[IN_ATTACK2] = true
camKeys[IN_RELOAD] = true
camKeys[IN_ZOOM] = true

local dontScuff = 0

hook.Add( "InputMouseApply", "FreezeTurning", function(cmd,x,y,ang)
	local ply = LocalPlayer()
	local isMoving = false
	
	for k,v in pairs(camKeys) do
		if ply:KeyDown(k) then
			isMoving = true
			modAngX = 0
			modAngY = 0
			dontScuff = CurTime() + 120
			break
		end
	end
	if not isMoving and dontScuff <= CurTime() then
		cmd:SetMouseX( 0 )
		cmd:SetMouseY( 0 )
		modAngX = modAngX + x/50
		modAngY = modAngY + y/50
		return true
	end
end )
