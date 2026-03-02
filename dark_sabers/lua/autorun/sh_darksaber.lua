lts = lts or {}
lts.forcePowers = lts.forcePowers or {}

LTS_MAX_FORCE_POWER = 9

function powerSetPos(pwr, x, y)
	local xx,yy = 0.5, 0.825
	lts.forcePowers[pwr].x = xx + (x/2*0.075)
	lts.forcePowers[pwr].y = yy - (y/2*0.075)	
end

function lts.addPower(k,v)
	v.name = k
	
	for a,b in pairs(v.allowed) do
		v.allowed[b]=true
	end
	
	v.x = math.Rand(0.1,0.9)
	v.y = math.Rand(0,0.25)
	
	lts.forcePowers[k]=v
	powerSetPos(k, v.xx, v.yy)
	
	if v.isClassPower then
		local g = table.Copy(v)
		
		g.name = v.jediName
		g.desc = v.jediDesc
		g.icon = v.jediIcon
		g.daddy = k
		g.allowed["Jedi"] = true
		
		g.x = math.Rand(0.1,0.9)
		g.y = math.Rand(0,0.25)
		
		lts.forcePowers[g.name] = g
		powerSetPos(g.name, -g.xx, g.yy)
	end
	
end

function lts.getPower(k)
	return lts.forcePowers[k]
end

function lts.getPowers()
	return lts.forcePowers
end


lts.addPower("Force Restore", {
    desc = "Light restoration for the force sensitive.",
    icon = "hfgjvs/kraken/jedi guard focus/3363915145_2661221914.png",
    cooldown = 1, cost = 0,
    xx = 0, yy = 0,
    requires = {},
    allowed = {"Jedi", "Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        ply:addSlow(1,2)
		ply:anim("sit_zen", 1, 2)
		ply:addForce(5 + math.Round(forceLevel/100))
        ply:heal(50, Color(0, 255, 255))
        ply:addStamina(3)
		ply:addXP("Force", math.random(5,25))
    end
})

lts.addPower("Force Slow", {
    desc = "Slows your target for 2 seconds",
    icon = "hfgjvs/kraken/jedi scoun ruffian/3563016249_1093904117.png",
    cooldown = 15, cost = 50,
    xx = -1, yy = 0,
    requires = {"Force Restore"},
    allowed = {"Jedi", "Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local tar = ply:laneCastSingle(512, 128)
        if IsValid(tar) then
			ply:anim("wos_cast_choke", 1, 0.7)
            tar:addSlow(75, 2)
            ply:sound("hfg/weapons/force/grip.mp3")
        end
    end
})

lts.addPower("Force Dash", {
    desc = "Lunge forward a short distance",
    icon = "hfgjvs/kraken/jedi shad kinetic combat/1211343474_706890510.png",
    cooldown = 15, cost = 50,
    xx = 1, yy = 0,
    requires = {"Force Restore"},
    allowed = {"Jedi", "Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		ply:SetPos(ply:GetPos() + Vector(0,0,3))
		ply:SetVelocity(ply:GetForward() * 500 + Vector(0,0,100))
    end
})

lts.addPower("Force Heal", {
    desc = "Use the force to restore your health.",
    icon = "hfgjvs/kraken/jedi sage seer/2530596337_929219035.png",
    cooldown = 20, cost = 75,
    xx = -1.5, yy = 2,
    requires = {"Force Slow"},
    allowed = {"Jedi", "Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        ply:heal(500, Color(0, 255, 255))
    end
})

lts.addPower("Force Resist", {
    desc = "Defend yourself from 10% of incoming force damage for 6 seconds.",
    icon = "hfgjvs/kraken/jedi sage seer/684994180_2615896761.png",
    cooldown = 30, cost = 100,
    xx = -0.5, yy = 2,
    requires = {"Force Slow"},
    allowed = {"Jedi", "Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		local resistanceAmount = 10
		local hibernationDuration = 6
        ply:addResistance(DMG_ENERGYBEAM, resistanceAmount, hibernationDuration)
        ply:addResistance(DMG_SHOCK, resistanceAmount, hibernationDuration)
        ply:addResistance(DMG_BURN, resistanceAmount, hibernationDuration)
        ply:addResistance(DMG_RADIATION, resistanceAmount, hibernationDuration)
        ply:addResistance(DMG_DROWN, resistanceAmount, hibernationDuration)
        ply:addResistance(DMG_POISON, resistanceAmount, hibernationDuration)
    end
})

lts.addPower("Force Push", {
    desc = "Push enemies away.",
    icon = "hfgjvs/kraken/jedi sage seer/915256278_3961334268.png",
    cooldown = 20, cost = 50,
    xx = 0.5, yy = 2,
    requires = {"Force Dash"},
    allowed = {"Jedi", "Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		local pushForce = 1000 -- Force applied to push targets
        local radius = 512 -- Radius to affect targets

        ply:anim("walk_magic", 1, 1)
		
        local targets = ents.FindInSphere(ply:GetPos(), radius)
        for _, target in pairs(targets) do
            if IsValid(target) and target:IsPlayer() and target ~= ply then
                target:SetPos(target:GetPos() + Vector(0,0,3))
                target:SetVelocity(ply:GetForward() * pushForce)
            end
        end

        ply:sound("ambient/levels/labs/electric_explosion1.wav")
    end
})

lts.addPower("Force Pull", {
    desc = "Pull enemies towards you.",
    icon = "hfgjvs/kraken/jedi sage seer/2193028204_1579101984.png",
    cooldown = 20, cost = 75,
    xx = 1.5, yy = 2,
    requires = {"Force Dash"},
    allowed = {"Jedi", "Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		local pushForce = -1000 -- Force applied to push targets
        local radius = 512 -- Radius to affect targets

        ply:anim("walk_magic", 1, 1)
		
        local targets = ents.FindInSphere(ply:GetPos(), radius)
        for _, target in pairs(targets) do
            if IsValid(target) and target:IsPlayer() and target ~= ply then
                target:SetPos(target:GetPos() + Vector(0,0,3))
                target:SetVelocity(ply:GetForward() * pushForce)
            end
        end

        ply:sound("ambient/levels/labs/electric_explosion1.wav")
    end
})

lts.addPower("Force Leap", {
    desc = "Leap into the air with the power of the force",
    icon = "hfgjvs/kraken/jedi sage balance/4075403952_1062608372.png",
    cooldown = 20, cost = 75,
    xx = 1, yy = 4,
    requires = {"Force Pull", "Force Push"},
    allowed = {"Jedi", "Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		local pushForce = 1000 -- Force applied to push targets
        local radius = 512 -- Radius to affect targets

        ply:anim("zombie_leap_start", 1, 0.75)
		
        ply:SetPos(ply:GetPos() + Vector(0,0,3))
        ply:SetVelocity(ply:GetForward() * pushForce + Vector(0,0,500))

        ply:sound("ambient/levels/labs/electric_explosion1.wav")
    end
})

lts.addPower("Purge Stuns", {
    desc = "Purges stuns, but not slows.",
    icon = "hfgjvs/kraken/jedi guard focus/2917228475_700852931.png",
    cooldown = 15, cost = 70,
    xx = -1, yy = 4,
    requires = {"Force Heal", "Force Resist"},
    allowed = {"Jedi", "Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		ply:purgeStuns()
    end
})

lts.addPower("Force Stun", {
    desc = "Stun your target for 2 seconds.",
    icon = "hfgjvs/kraken/jedi sage balance/4128348939_4125669981.png",
    cooldown = 15, cost = 70,
    xx = 0, yy = 4,
    requires = {"Purge Stuns", "Force Leap"},
    allowed = {"Jedi", "Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		local tar = ply:laneCastSingle(512, 128)
        if IsValid(tar) then
			ply:anim("wos_cast_choke", 1, 0.7)
            tar:addSlow(1, 1)
            tar:addStun(1)
        end
    end
})

lts.addPower("Force Levitate", {
    desc = "Begin to fly in the air for a few moments.",
    icon = "hfgjvs/kraken/jedi guard focus/1759637358_2009735347.png",
    cooldown = 45, cost = 150,
    xx = 0, yy = 6,
    requires = {"Force Stun"},
    allowed = {"Jedi", "Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		local levitateDuration = 5
        ply:anim("swim_passive", 1, 5)
        ply:SetMoveType(MOVETYPE_FLY)
        ply:sound("ambient/levels/labs/electric_explosion1.wav")
        timer.Simple(levitateDuration, function()
            if IsValid(ply) then
                ply:SetMoveType(MOVETYPE_WALK)
            end
        end)
    end
})

lts.addPower("Force Seethe", {
    desc = "The darkness surrounds you..",
    icon = "hfgjvs/kraken/jedi guns dirty fighting/209722804_1103904115.png",
	isClassPower = true,
	jediName = "Battle Meditation",
	jediDesc = "Meditate on your upcoming battle...",
	jediIcon = "hfgjvs/kraken/jedi guard defense/899498588_112923587.png",
    cooldown = 2, cost = 0,
    xx = 6, yy = 7,
    requires = {"Force Levitate"},
    allowed = {"Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        ply:addSlow(1,2)
		ply:anim("sit_zen", 1, 2)
		ply:addForce(5 + math.Round(forceLevel/100) * 4)
        ply:heal(150, Color(0, 255, 255))
        ply:addStamina(6)
		ply:addXP("Force", math.random(50,250))
    end
})

lts.addPower("Dark Heal", {
    desc = "Use the Darkness to restore your health.",
    icon = "hfgjvs/kraken/sith Sorc corruption/3503150683_860414893.png",
	isClassPower = true,
	jediName = "Light Heal",
	jediDesc = "Use the force to restore your health",
	jediIcon = "hfgjvs/kraken/jedi sage telekinetics/909775362_2172479202.png",
    cooldown = 30, cost = 75,
    xx = 9, yy = 8,
    requires = {"Force Seethe"},
    allowed = {"Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        ply:heal(2000 + (forceLevel*4), Color(255, 0, 0))
    end
})

lts.addPower("Force Kinetite", {
    desc = "Launch a sphere of kinetic energy that travels forward and deals damage on impact.",
    icon = "hfgjvs/kraken/sith sorc lightning/643548762_3310141638.png",
	isClassPower = true,
	jediName = "Force Orb",
	jediDesc = "Launch a sphere of kinetic energy that travels forward and deals damage on impact.",
	jediIcon = "hfgjvs/kraken/jedi sage telekinetics/3544923193_2513861905.png",
    cooldown = 10, cost = 50,
    xx = 3, yy = 8,
    requires = {"Force Seethe"},
    allowed = {"Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local direction = ply:GetAimVector()

        -- Create the Kinetite entity
        local kinetite = ents.Create("ent_kinetite")
        if IsValid(kinetite) then
            kinetite:SetPos(ply:EyePos() + direction * 50)
            kinetite:Spawn()
            kinetite:Activate()
            kinetite.damage = 500
            kinetite:Launch(direction * 1000, ply)
        end

        -- Animation and sound for the player
        ply:anim("wos_cast_lightning_armed", 1, 0.25)
        ply:EmitSound("ambient/energy/electric_loop.wav")
        timer.Simple(1, function()
            ply:StopSound("ambient/energy/electric_loop.wav")
        end)
    end
})

lts.addPower("Empowered Strike", {
    desc = "Overcharge your Light Saber increasing melee damage.",
    icon = "hfgjvs/kraken/sith mara carnage/1076525610_2911944164.png",
	isClassPower = true,
	jediName = "Focused Strike",
	jediDesc = "Overcharge your Light Saber increasing melee damage",
	jediIcon = "hfgjvs/kraken/jedi sent combat/991937761_1200321510.png",
    cooldown = 30, cost = 50,
    xx = 1.5, yy = 9,
    requires = {"Force Kinetite"},
    allowed = {"Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        ply:addBuff("saberDamage", 1, 5)
    end
})

lts.addPower("Armor Repair", {
    desc = "Repair your armor increasing your total defense.",
    icon = "hfgjvs/kraken/sith jugg immortal/2959061971_1731476469.png",
	isClassPower = true,
	jediName = "Force Mend",
	jediDesc = "Repair your armor increasing your total defense.",
	jediIcon = "hfgjvs/kraken/jedi scoun sawbones/807863898_2391465486.png",
    cooldown = 30, cost = 50,
    xx = 4.5, yy = 9,
    requires = {"Force Kinetite"},
    allowed = {"Sith"},
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        ply:repair(500)
    end
})

lts.addPower("Force Sever", {
    desc = "Severs your target's connection to the force preventing abilities.",
    icon = "hfgjvs/kraken/sith ass deception/2454489445_3983434785.png",
	isClassPower = true,
	jediName = "Force Nullify",
	jediDesc = "Severs your target's connection to the force preventing abilities.",
	jediIcon = "hfgjvs/kraken/jedi sage telekinetics/2939369316_491388031.png",
    cooldown = 30, cost = 50,
    xx = 7.5, yy = 9,
    requires = {"Dark Heal"},
    allowed = {"Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local tar = ply:laneCastSingle(512, 128)
        if IsValid(tar) then
            ply:anim("wos_cast_choke", 1, 0.7)
            tar:addSlow(75, 2)
            ply:sound("hfg/weapons/force/grip.mp3")
			
			for _, powerName in pairs(tar.powers) do
				local remainingCooldown = tar:getCooldownRemaining(powerName)
				if remainingCooldown <= 10 then
					tar:setCooldown(powerName, 10)
				end
			end
			
        end
    end
})

lts.addPower("Dark Surge", {
    desc = "Use the Force to restore your stamina.",
    icon = "hfgjvs/kraken/sith mara carnage/3382689195_278360974.png",
	isClassPower = true,
	jediName = "Controlled Breath",
	jediDesc = "Use the Force to restore your stamina.",
	jediIcon = "hfgjvs/kraken/jedi sent combat/654096368_1485517089.png",
    cooldown = 30, cost = 50,
    xx = 1.5, yy = 11,
    requires = {"Empowered Strike", "Force Stalk"},
    allowed = {"Sith"},
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        ply:addStamina(100)
    end
})

lts.addPower("Black Lightning", {
    desc = "A more potent and deadly form of Force Lightning.",
    icon = "hfgjvs/kraken/sith sorc madness/3338200499_3413796869.png",
    cost = 8,
    cooldown = 0,
    xx = 10.5, yy = 16,
    requires = {"Force Scream", "Force Inferno", "Force Storm"},
    allowed = {"Sith"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		ply:stopSound("hfg/weapons/force/lightning2.wav")
		ply:anim("wos_cast_lightning", 1, 0)
	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local tar = ply:laneCastSingle(512, 64)
		
		local lightningTexture = "lordtyler/lightning/black.png"
		--local lightningTexture = "cable/blue_elec"
		local lightningThickness = 5
		local lightningColor = Color(25, 25, 25)
		local lightningLifespan = 0.15
		
		local fings = {
			{up = 3, right = 2, forward = 2}, -- thumb
			{up = 3, right = 1, forward = 3},
			{up = 2, right = 1, forward = 3},
			{up = 1, right = 1, forward = 3},
			{up = 0, right = 1, forward = 3},
		}
		
        if IsValid(tar) then
            local baseDamage = forceLevel * 5
            local duration = 1
            local interval = 0.5
			
			if ply:hasKeys() then
				ply:anim("wos_cast_lightning", 1, 1)
			else
				ply:anim("wos_cast_lightning_armed", 1, 1)
			end
		
			ply:addSlow(100, 0.5)
            tar:addSlow(25, 0.5)
			
            ply:sound("hfg/weapons/force/lightning2.wav")
            tar:sound("hfg/weapons/force/lightninghit1.mp3")
			
            local vecs = {}
			
			local working = false
			if tar:IsPlayer() then
				if tar:getForce() >= baseDamage/4 then
					if tar:hasSaber() then
						if tar.blockTime >= CurTime() then
							for _,v in pairs(fings) do
								local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
								local fing, fang = ply:GetBonePosition(bone)
								
								fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
								
								local bone = tar:LookupBone("ValveBiped.Bip01_R_Hand") or 0
								local pos, ang = tar:GetBonePosition(bone)
								
								pos = pos + ang:Forward() * 3 + ang:Up() * 2 + ang:Right() * 1.5
								ang:RotateAroundAxis(ang:Right(), 180)
								
								table.insert(vecs, {s = fing, e = pos + ang:Up() * math.random(35,0)})
							end
							
							advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
							tar.lastLigtning = tar.lastLigtning or 0
							
							if tar.lastLigtning <= CurTime() then
								tar:takeForce(baseDamage/4)
								tar.lastLigtning = CurTime() + duration/2
							end
							
							working = true
						end
					end
				end
			end
		
			if not working then
				for _,v in pairs(fings) do
					local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
					local fing, fang = ply:GetBonePosition(bone)
					
					fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
					
					table.insert(vecs, {s = fing, e = targetRandomPos(tar)})
				end
				advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
				tar.lastLigtning = tar.lastLigtning or 0
				if tar.lastLigtning <= CurTime() then
					tar:applyDoT(ply, baseDamage, duration, interval, DMG_ENERGYBEAM)
					tar.lastLigtning = CurTime() + duration/2
				end
			end
			
        else
            local tr = util.TraceLine( {
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:EyeAngles():Forward() * 512,
				filter = function(ent) return ent == self end
			})
			
			if ply:hasKeys() then
				ply:anim("wos_cast_lightning", 1, 0.5)
			else
				ply:anim("wos_cast_lightning_armed", 1, 0.5)
			end
		
			ply:addSlow(100, 0.5)
            
			local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
			local hand = ply:GetBonePosition(bone)
			
			ply:sound("hfg/weapons/force/lightning2.wav")
            --castLightning(hand, tr.HitPos, 2, "cable/blue_elec", 0.1, Color(222,255,254))
			
			local vecs = {}

			-- targetRandomPos(target)
			for _,v in pairs(fings) do
				local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
				local fing, fang = ply:GetBonePosition(bone)
				
				fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
				
				table.insert(vecs, {s = fing, e = tr.HitPos})
			end
			
			advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
        end
    end
})

lts.addPower("White Lightning", {
    desc = "A more potent and deadly form of Force Lightning.",
    icon = "hfgjvs/kraken/jedi shad kinetic combat/3258379006_3835601682.png",
    cost = 8,
    cooldown = 0,
    xx = -10.5, yy = 16,
    requires = {"Force Command", "Force Immolate", "Force of Nature"},
    allowed = {"Jedi"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		ply:stopSound("hfg/weapons/force/lightning2.wav")
		ply:anim("wos_cast_lightning", 1, 0)
	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local tar = ply:laneCastSingle(512, 64)
		
		local lightningTexture = "lordtyler/lightning/white.png"
		--local lightningTexture = "cable/blue_elec"
		local lightningThickness = 5
		local lightningColor = Color(255, 255, 255)
		local lightningLifespan = 0.15
		
		local fings = {
			{up = 3, right = 2, forward = 2}, -- thumb
			{up = 3, right = 1, forward = 3},
			{up = 2, right = 1, forward = 3},
			{up = 1, right = 1, forward = 3},
			{up = 0, right = 1, forward = 3},
		}
		
        if IsValid(tar) then
            local baseDamage = forceLevel * 2
            local duration = 1
            local interval = 0.5
			
			if ply:hasKeys() then
				ply:anim("wos_cast_lightning", 1, 1)
			else
				ply:anim("wos_cast_lightning_armed", 1, 1)
			end
		
			ply:addSlow(100, 0.5)
            tar:addSlow(25, 0.5)
			
            ply:sound("hfg/weapons/force/lightning2.wav")
            tar:sound("hfg/weapons/force/lightninghit1.mp3")
			
            local vecs = {}
			
			local working = false
			if tar:IsPlayer() then
				if tar:getForce() >= baseDamage/4 then
					if tar:hasSaber() then
						if tar.blockTime >= CurTime() then
							for _,v in pairs(fings) do
								local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
								local fing, fang = ply:GetBonePosition(bone)
								
								fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
								
								local bone = tar:LookupBone("ValveBiped.Bip01_R_Hand") or 0
								local pos, ang = tar:GetBonePosition(bone)
								
								pos = pos + ang:Forward() * 3 + ang:Up() * 2 + ang:Right() * 1.5
								ang:RotateAroundAxis(ang:Right(), 180)
								
								table.insert(vecs, {s = fing, e = pos + ang:Up() * math.random(35,0)})
							end
							
							advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
							tar.lastLigtning = tar.lastLigtning or 0
							
							if tar.lastLigtning <= CurTime() then
								tar:takeForce(baseDamage/4)
								tar.lastLigtning = CurTime() + duration/2
							end
							
							working = true
						end
					end
				end
			end
		
			if not working then
				for _,v in pairs(fings) do
					local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
					local fing, fang = ply:GetBonePosition(bone)
					
					fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
					
					table.insert(vecs, {s = fing, e = targetRandomPos(tar)})
				end
				advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
				tar.lastLigtning = tar.lastLigtning or 0
				if tar.lastLigtning <= CurTime() then
					tar:applyDoT(ply, baseDamage, duration, interval, DMG_ENERGYBEAM)
					tar.lastLigtning = CurTime() + duration/2
				end
			end
			
        else
            local tr = util.TraceLine( {
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:EyeAngles():Forward() * 512,
				filter = function(ent) return ent == self end
			})
			
			if ply:hasKeys() then
				ply:anim("wos_cast_lightning", 1, 0.5)
			else
				ply:anim("wos_cast_lightning_armed", 1, 0.5)
			end
		
			ply:addSlow(100, 0.5)
            
			local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
			local hand = ply:GetBonePosition(bone)
			
			ply:sound("hfg/weapons/force/lightning2.wav")
            --castLightning(hand, tr.HitPos, 2, "cable/blue_elec", 0.1, Color(222,255,254))
			
			local vecs = {}

			-- targetRandomPos(target)
			for _,v in pairs(fings) do
				local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
				local fing, fang = ply:GetBonePosition(bone)
				
				fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
				
				table.insert(vecs, {s = fing, e = tr.HitPos})
			end
			
			advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
        end
    end
})

lts.addPower("Force Lightning", {
    desc = "Ranged Damage Attack",
    icon = "hfgjvs/kraken/sith sorc lightning/2135032387_850460727.png",
    cost = 4,
    cooldown = 0,
    xx = 10.5, yy = 9,
    requires = {"Dark Heal"},
    allowed = {"Sith"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		ply:stopSound("hfg/weapons/force/lightning2.wav")
		ply:anim("wos_cast_lightning", 1, 0)
	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local tar = ply:laneCastSingle(512, 64)
		
		local lightningTexture = "lordtyler/lightning/blue.png"
		--local lightningTexture = "cable/blue_elec"
		local lightningThickness = 5
		local lightningColor = Color(56, 75, 255)
		local lightningLifespan = 0.15
		
		local fings = {
			{up = 3, right = 2, forward = 2}, -- thumb
			{up = 3, right = 1, forward = 3},
			{up = 2, right = 1, forward = 3},
			{up = 1, right = 1, forward = 3},
			{up = 0, right = 1, forward = 3},
		}
		
		
        if IsValid(tar) then
            local baseDamage = forceLevel
            local duration = 1
            local interval = 0.5
			
			if ply:hasKeys() then
				ply:anim("wos_cast_lightning", 1, 1)
			else
				ply:anim("wos_cast_lightning_armed", 1, 1)
			end
		
			ply:addSlow(100, 0.5)
            tar:addSlow(25, 0.5)
			
            ply:sound("hfg/weapons/force/lightning2.wav")
            tar:sound("hfg/weapons/force/lightninghit1.mp3")
			
            local vecs = {}
			
			local working = false
			if tar:IsPlayer() then
				if tar:getForce() >= baseDamage/4 then
					if tar:hasSaber() then
						if tar.blockTime >= CurTime() then
							for _,v in pairs(fings) do
								local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
								local fing, fang = ply:GetBonePosition(bone)
								
								fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
								
								local bone = tar:LookupBone("ValveBiped.Bip01_R_Hand") or 0
								local pos, ang = tar:GetBonePosition(bone)
								
								pos = pos + ang:Forward() * 3 + ang:Up() * 2 + ang:Right() * 1.5
								ang:RotateAroundAxis(ang:Right(), 180)
								
								table.insert(vecs, {s = fing, e = pos + ang:Up() * math.random(35,0)})
							end
							
							advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
							tar.lastLigtning = tar.lastLigtning or 0
							
							if tar.lastLigtning <= CurTime() then
								tar:takeForce(baseDamage/4)
								tar.lastLigtning = CurTime() + duration/2
							end
							
							working = true
						end
					end
				end
			end
		
			if not working then
				for _,v in pairs(fings) do
					local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
					local fing, fang = ply:GetBonePosition(bone)
					
					fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
					
					table.insert(vecs, {s = fing, e = targetRandomPos(tar)})
				end
				advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
				tar.lastLigtning = tar.lastLigtning or 0
				if tar.lastLigtning <= CurTime() then
					tar:applyDoT(ply, baseDamage, duration, interval, DMG_ENERGYBEAM)
					tar.lastLigtning = CurTime() + duration/2
				end
			end
			
        else
            local tr = util.TraceLine( {
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:EyeAngles():Forward() * 512,
				filter = function(ent) return ent == self end
			})
			
			if ply:hasKeys() then
				ply:anim("wos_cast_lightning", 1, 0.5)
			else
				ply:anim("wos_cast_lightning_armed", 1, 0.5)
			end
		
			ply:addSlow(100, 0.5)
            
			local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
			local hand = ply:GetBonePosition(bone)
			
			ply:sound("hfg/weapons/force/lightning2.wav")
            --castLightning(hand, tr.HitPos, 2, "cable/blue_elec", 0.1, Color(222,255,254))
			
			local vecs = {}

			-- targetRandomPos(target)
			for _,v in pairs(fings) do
				local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
				local fing, fang = ply:GetBonePosition(bone)
				
				fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
				
				table.insert(vecs, {s = fing, e = tr.HitPos})
			end
			
			advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
        end
    end
})

lts.addPower("Electric Judgement", {
    desc = "Ranged Damage Attack",
    icon = "hfgjvs/kraken/jedi shad serenity/2275020623_507157037.png",
    cost = 4,
    cooldown = 0,
    xx = -10.5, yy = 9,
    requires = {"Light Heal"},
    allowed = {"Jedi"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		ply:stopSound("hfg/weapons/force/lightning2.wav")
		ply:anim("wos_cast_lightning", 1, 0)
	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local tar = ply:laneCastSingle(512, 64)
		
		local lightningTexture = "lordtyler/lightning/yellow.png"
		--local lightningTexture = "cable/blue_elec"
		local lightningThickness = 5
		local lightningColor = Color(56, 75, 255)
		local lightningLifespan = 0.15
		
		local fings = {
			{up = 3, right = 2, forward = 2}, -- thumb
			{up = 3, right = 1, forward = 3},
			{up = 2, right = 1, forward = 3},
			{up = 1, right = 1, forward = 3},
			{up = 0, right = 1, forward = 3},
		}
		
		
        if IsValid(tar) then
            local baseDamage = forceLevel
            local duration = 1
            local interval = 0.5
			
			if ply:hasKeys() then
				ply:anim("wos_cast_lightning", 1, 1)
			else
				ply:anim("wos_cast_lightning_armed", 1, 1)
			end
		
			ply:addSlow(100, 0.5)
            tar:addSlow(25, 0.5)
			
            ply:sound("hfg/weapons/force/lightning2.wav")
            tar:sound("hfg/weapons/force/lightninghit1.mp3")
			
            local vecs = {}
			
			local working = false
			if tar:IsPlayer() then
				if tar:getForce() >= baseDamage/4 then
					if tar:hasSaber() then
						if tar.blockTime >= CurTime() then
							for _,v in pairs(fings) do
								local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
								local fing, fang = ply:GetBonePosition(bone)
								
								fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
								
								local bone = tar:LookupBone("ValveBiped.Bip01_R_Hand") or 0
								local pos, ang = tar:GetBonePosition(bone)
								
								pos = pos + ang:Forward() * 3 + ang:Up() * 2 + ang:Right() * 1.5
								ang:RotateAroundAxis(ang:Right(), 180)
								
								table.insert(vecs, {s = fing, e = pos + ang:Up() * math.random(35,0)})
							end
							
							advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
							tar.lastLigtning = tar.lastLigtning or 0
							
							if tar.lastLigtning <= CurTime() then
								tar:takeForce(baseDamage/4)
								tar.lastLigtning = CurTime() + duration/2
							end
							
							working = true
						end
					end
				end
			end
		
			if not working then
				for _,v in pairs(fings) do
					local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
					local fing, fang = ply:GetBonePosition(bone)
					
					fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
					
					table.insert(vecs, {s = fing, e = targetRandomPos(tar)})
				end
				advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
				tar.lastLigtning = tar.lastLigtning or 0
				if tar.lastLigtning <= CurTime() then
					tar:applyDoT(ply, baseDamage, duration, interval, DMG_ENERGYBEAM)
					tar.lastLigtning = CurTime() + duration/2
				end
			end
			
        else
            local tr = util.TraceLine( {
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:EyeAngles():Forward() * 512,
				filter = function(ent) return ent == self end
			})
			
			if ply:hasKeys() then
				ply:anim("wos_cast_lightning", 1, 0.5)
			else
				ply:anim("wos_cast_lightning_armed", 1, 0.5)
			end
		
			ply:addSlow(100, 0.5)
            
			local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
			local hand = ply:GetBonePosition(bone)
			
			ply:sound("hfg/weapons/force/lightning2.wav")
            --castLightning(hand, tr.HitPos, 2, "cable/blue_elec", 0.1, Color(222,255,254))
			
			local vecs = {}

			-- targetRandomPos(target)
			for _,v in pairs(fings) do
				local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
				local fing, fang = ply:GetBonePosition(bone)
				
				fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
				
				table.insert(vecs, {s = fing, e = tr.HitPos})
			end
			
			advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
        end
    end
})

lts.addPower("Force Leech", {
    desc = "Leech the life from your opponent.",
    icon = "hfgjvs/kraken/sith sorc corruption/3531100291_3620306390.png",
	isClassPower = true,
	jediName = "Force Siphon",
	jediDesc = "Leech the life from your opponent.",
	jediIcon = "hfgjvs/kraken/jedi scoun sawbones/600559870_244925032.png",
    cost = 60,
    cooldown = 20,
    xx = 10.5, yy = 11,
    requires = {"Force Lightning", "Dark Transfer"},
    allowed = {"Sith"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		local tar = ply:laneCastSingle(512, 128)
		if IsValid(tar) then
			local amt = (forceLevel * 4)
			ply:heal(amt, Color(200, 0, 255))
			tar:energyBeamDamage(amt, 5, ply)
		end
	end
})

lts.addPower("Dark Transfer", {
    desc = "Transfer your life force into your target.",
    icon = "hfgjvs/kraken/sith sorc corruption/3099926829_2656096473.png",
	isClassPower = true,
	jediName = "Force Rejuvinate",
	jediDesc = "Transfer your life force into your target.",
	jediIcon = "hfgjvs/kraken/jedi scoun sawbones/589382234_753632583.png",
    cost = 4,
    cooldown = 0,
    xx = 11.5, yy = 11,
    requires = {"CLASS_BENEFITS"},
    allowed = {"Sith"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		local tar = ply:laneCastSingle(512, 128)
		if IsValid(tar) then
			local amt = forceLevel
			if ply:Health() > forceLevel then
				ply:energyBeamDamage(amt, 0, ply)
				tar:heal(amt, Color(200, 0, 255))
			end
		end
	end
})

lts.addPower("Force Scream", {
    desc = "Unleashing a devastating scream amplified by the Force.",
    icon = "hfgjvs/kraken/sith jugg immortal/487342805_2705891482.png",
	isClassPower = true,
	jediName = "Force Command",
	jediDesc = "Unleashing a devastating scream amplified by the Force",
	jediIcon = "hfgjvs/kraken/jedi shad serenity/3942262603_3557239221.png",
    cost = 50,
    cooldown = 10,
    xx = 11.5, yy = 13,
    requires = {"Force Leech"},
    allowed = {"Sith"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local tar = ply:laneCastSingle(512, 128)
        if IsValid(tar) then
            local baseDamage = forceLevel * 4
            local duration = 2
            local interval = 0.25
			
			ply:anim("menu_zombie_01", 1, 1)
			tar:anim("idle_all_cower", 1, 1)

			ply:addSlow(100, 1)
            tar:addSlow(100, 1)
			
            ply:sound("custom_powers/tyler_growl.wav")
			
			net.Start("lts.ring")
			net.Send(tar)
		
			tar:applyDoT(ply, baseDamage, duration, interval, DMG_ENERGYBEAM)
        end
    end
})

lts.addPower("Force Inferno", {
    desc = "Generate intense flames fueled by dark energy, burning enemies in a fiery storm.",
    icon = "hfgjvs/kraken/sith power pyrotech/940193728_3393441994.png",
	isClassPower = true,
	jediName = "Force Immolate",
	jediDesc = "Generate intense flames fueled by dark energy, burning enemies in a fiery storm.",
	jediIcon = "hfgjvs/kraken/jedi guns saboteur/4172681189_479970006.png",
    cost = 100,
    cooldown = 90,
    xx = 10.5, yy = 13,
    requires = {"Force Leech"},
    allowed = {"Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local radius = 512 -- Large area of effect
        local baseDamage = forceLevel/4 -- Damage per tick
        local burnDuration = 12 -- Duration of burn damage
        local burnInterval = 1 -- How often damage ticks
        local burnIntensity = 200 -- Extra push force

        -- Animation for casting Force Inferno
        ply:anim("wos_cast_lightning_armed", 1, 1)
		
        -- Function to apply flames and burn effect
        local function igniteEnemies()
            local targets = ply:aoeCast(radius)
            for _, target in pairs(targets) do
                if IsValid(target) and target ~= ply then
                    -- Apply burn damage over time
                    target:applyDoT(ply, baseDamage, burnDuration, burnInterval, DMG_BURN)

                    -- Push targets to simulate the impact of the inferno
                    local forceDirection = (target:GetPos() - ply:GetPos()):GetNormalized() + Vector(0, 0, 1)
                    target:SetVelocity(forceDirection * burnIntensity)
					CreateVFireEntFires(target, 5)
                    -- Create a flame effect
                    local effectData = EffectData()
                    effectData:SetOrigin(target:GetPos() + Vector(0, 0, 50))
                    util.Effect("HelicopterMegaBomb", effectData)
                end
            end
        end

        -- Ignite enemies for the burn duration
        local infernoDuration = 0
        timer.Create("ForceInferno_" .. ply:EntIndex(), burnInterval, burnDuration / burnInterval, function()
            if IsValid(ply) then
                infernoDuration = infernoDuration + burnInterval
                igniteEnemies()

                -- Stop after the duration ends
                if infernoDuration >= burnDuration then
                    timer.Remove("ForceInferno_" .. ply:EntIndex())
                end
            else
                -- Ensure timer is cleaned up if caster disappears
                timer.Remove("ForceInferno_" .. ply:EntIndex())
            end
        end)
    end
})

lts.addPower("Force Storm", {
    desc = "Call upon the forces of nature to summon lightning.",
    icon = "hfgjvs/kraken/sith sorc lightning/3382305215_2367234041.png",
	isClassPower = true,
	jediName = "Force of Nature",
	jediDesc = "Call upon the forces of nature to summon lightning.",
	jediIcon = "hfgjvs/kraken/sith sorc lightning/3382305215_2367234041.png",
    cost = 4,
    cooldown = 20,
    xx = 9.5, yy = 13,
    requires = {"Force Leech"},
    allowed = {"Sith"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		
	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		ply:anim("menu_zombie_01", 1, 0.75)
		ply:addSlow(25, 0.75)
		
		local storm = ents.Create("lts_storm")
		storm:SetPos(ply:GetPos())
		storm:Spawn()
		storm.dmg = 10
		storm.ply = ply
		timer.Simple(10,function()
			storm:Remove()
		end)
		
    end
})




 
lts.addPower("Force Cloak", {
    desc = "Render yourself invisible for a short time.",
    icon = "hfgjvs/kraken/jedi sage telekinetics/4094111264_1236287357.png",
	isClassPower = true,
	jediName = "Force Stealth",
	jediDesc = "Render yourself invisible for a short time.",
	jediIcon = "hfgjvs/kraken/jedi sage telekinetics/4094111264_1236287357.png",
    cost = 80,
    cooldown = 90,
    xx = 7.5, yy = 11,
    requires = {"Force Sever", "Force Horror"},
    allowed = {"Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        ply:anim("wos_cast_lightning", 1, 1)
        ply:SetNoDraw(true)
        ply:sound("ambient/levels/labs/electric_explosion1.wav")
        timer.Simple(30, function()
            ply:SetNoDraw(false)
        end)
    end
})

lts.addPower("Force Horror", {
    desc = "Blind your foe with fear.",
    icon = "hfgjvs/kraken/sith sorc madness/1437037426_2598738403.png",
	isClassPower = true,
	jediName = "Force Fear",
	jediDesc = "Blind your foe with their own fears.",
	jediIcon = "hfgjvs/kraken/jedi shad kinetic combat/1790303756_2830408285.png",
    cost = 50,
    cooldown = 20,
    xx = 8.5, yy = 11,
    requires = {"CUSTOM_POWERS"},
    allowed = {"Sith"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local tar = ply:laneCastSingle(512, 128)
        if IsValid(tar) then
            local baseDamage = 100
            local duration = 1
            local interval = 0.25
			
			ply:anim("wos_cast_choke", 1, 1)
			tar:anim("r_reaction_upper", 1, 1)
			
			local pp = ply:GetPos()
			local tp = tar:GetPos()
			local dir = (pp - tp):Angle()

			ply:addSlow(100, 1)
            tar:addSlow(100, 1)
			
            ply:sound("hfg/weapons/force/grip.mp3")
			
			for i=1,4 do 
				timer.Simple(i*0.5, function()
					tar:SetEyeAngles(Angle(math.random(-180,180), math.random(-90,90), 0))
				end)
			end
			
			net.Start("lts.fear")
			net.Send(tar)
			
			tar:applyDoT(ply, baseDamage, duration, interval, DMG_ENERGYBEAM)
			ply:healOverTime(baseDamage, duration, interval, Color(200,0,255))
        end
    end
})

lts.addPower("Force Web", {
    desc = "Ensnare enemies in a web of dark energy.",
    icon = "hfgjvs/kraken/sith sorc lightning/3387050273_3599725236.png",
	isClassPower = true,
	jediName = "Force Entangle",
	jediDesc = "Ensnare enemies in a web of light energy.",
	jediIcon = "hfgjvs/kraken/jedi guns saboteur/3525981575_3058689588.png",
    cost = 80,
    cooldown = 15,
    xx = 8.5, yy = 13,
    requires = {"Force Cloak"},
    allowed = {"Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)
    
    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local target = ply:laneCastSingle(512, 128)
        if IsValid(target) then
            local duration = 5
            local interval = 0.1
            local lightningTexture = "lordtyler/lightning/purple.png"

            -- Webbed target animation
            target:anim("seq_cower", 1, duration)
            target:addSlow(1, duration) -- Target slowed during the ensnare
			target.web = CurTime() + 5
            -- Function to generate lightning web from head to ground
            local function generateWeb()
                for i = 1, 6 do
                    local startPos = target:GetPos() + Vector(0, 0, 60) -- From head
                    local endPos = target:GetPos() + Vector(math.cos(i * math.pi / 3) * 50, math.sin(i * math.pi / 3) * 50, 0) -- Around the target
                    castLightning(startPos, endPos, 2, lightningTexture, 0.1, Color(200, 0, 255)) -- Draw lightning for 0.1 seconds
                end
            end
			
			for _, powerName in pairs(target.powers) do
				local remainingCooldown = target:getCooldownRemaining(powerName)
				if remainingCooldown <= 3 then
					target:setCooldown(powerName, 3)
				end
			end
			
            -- Continuously update the lightning web every 0.1 seconds for the duration
            local webDuration = 0
            timer.Create("ForceNet_" .. target:EntIndex(), interval, duration / interval, function()
                if IsValid(target) then
                    webDuration = webDuration + interval
                    generateWeb()

                    -- Stop after duration ends
                    if webDuration >= duration then
                        timer.Remove("ForceNet_" .. target:EntIndex())
                    end
                else
                    -- Ensure timer is cleaned up if target disappears
                    timer.Remove("ForceNet_" .. target:EntIndex())
                end
            end)
        end
    end
})

lts.addPower("Red Lightning", {
    desc = "Ranged Damage Attack",
    icon = "hfgjvs/kraken/sith sorc madness/2532758649_2240258236.png",
    cost = 4,
    cooldown = 0,
    xx = 6.5, yy = 13,
    requires = {"Force Cloak"},
    allowed = {"Sith"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		ply:stopSound("hfg/weapons/force/lightning2.wav")
		ply:anim("wos_cast_lightning", 1, 0)
	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local tar = ply:laneCastSingle(512, 64)
		
		local lightningTexture = "lordtyler/lightning/red.png"
		--local lightningTexture = "cable/blue_elec"
		local lightningThickness = 5
		local lightningColor = Color(56, 75, 255)
		local lightningLifespan = 0.15
		
		local fings = {
			{up = 3, right = 2, forward = 2}, -- thumb
			{up = 3, right = 1, forward = 3},
			{up = 2, right = 1, forward = 3},
			{up = 1, right = 1, forward = 3},
			{up = 0, right = 1, forward = 3},
		}
		
		
        if IsValid(tar) then
            local baseDamage = forceLevel
            local duration = 1
            local interval = 0.5
			
			if ply:hasKeys() then
				ply:anim("wos_cast_lightning", 1, 1)
			else
				ply:anim("wos_cast_lightning_armed", 1, 1)
			end
		
			ply:addSlow(100, 0.5)
            tar:addSlow(25, 0.5)
			
            ply:sound("hfg/weapons/force/lightning2.wav")
            tar:sound("hfg/weapons/force/lightninghit1.mp3")
			
            local vecs = {}
			
			local working = false
			if tar:IsPlayer() then
				if tar:getForce() >= baseDamage/4 then
					if tar:hasSaber() then
						if tar.blockTime >= CurTime() then
							for _,v in pairs(fings) do
								local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
								local fing, fang = ply:GetBonePosition(bone)
								
								fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
								
								local bone = tar:LookupBone("ValveBiped.Bip01_R_Hand") or 0
								local pos, ang = tar:GetBonePosition(bone)
								
								pos = pos + ang:Forward() * 3 + ang:Up() * 2 + ang:Right() * 1.5
								ang:RotateAroundAxis(ang:Right(), 180)
								
								table.insert(vecs, {s = fing, e = pos + ang:Up() * math.random(35,0)})
							end
							
							advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
							tar.lastLigtning = tar.lastLigtning or 0
							
							if tar.lastLigtning <= CurTime() then
								tar:takeForce(baseDamage/4)
								tar.lastLigtning = CurTime() + duration/2
							end
							
							working = true
						end
					end
				end
			end
		
			if not working then
				for _,v in pairs(fings) do
					local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
					local fing, fang = ply:GetBonePosition(bone)
					
					fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
					
					table.insert(vecs, {s = fing, e = targetRandomPos(tar)})
				end
				advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
				tar.lastLigtning = tar.lastLigtning or 0
				if tar.lastLigtning <= CurTime() then
					tar:applyDoT(ply, baseDamage, duration, interval, DMG_ENERGYBEAM)
					ply:heal(baseDamage, Color(0, 255, 0))
					tar.lastLigtning = CurTime() + duration/2
				end
			end
			
        else
            local tr = util.TraceLine( {
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:EyeAngles():Forward() * 512,
				filter = function(ent) return ent == self end
			})
			
			if ply:hasKeys() then
				ply:anim("wos_cast_lightning", 1, 0.5)
			else
				ply:anim("wos_cast_lightning_armed", 1, 0.5)
			end
		
			ply:addSlow(100, 0.5)
            
			local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
			local hand = ply:GetBonePosition(bone)
			
			ply:sound("hfg/weapons/force/lightning2.wav")
            --castLightning(hand, tr.HitPos, 2, "cable/blue_elec", 0.1, Color(222,255,254))
			
			local vecs = {}

			-- targetRandomPos(target)
			for _,v in pairs(fings) do
				local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
				local fing, fang = ply:GetBonePosition(bone)
				
				fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
				
				table.insert(vecs, {s = fing, e = tr.HitPos})
			end
			
			advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
        end
    end
})

lts.addPower("Emerald Lightning", {
    desc = "Ranged Damage Attack",
    icon = "hfgjvs/kraken/jedi sage seer/2530596337_929219035.png",
    cost = 4,
    cooldown = 0,
    xx = -6.5, yy = 13,
    requires = {"Force Stealth"},
    allowed = {"Jedi"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		ply:stopSound("hfg/weapons/force/lightning2.wav")
		ply:anim("wos_cast_lightning", 1, 0)
	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local tar = ply:laneCastSingle(512, 64)
		
		local lightningTexture = "lordtyler/lightning/green.png"
		--local lightningTexture = "cable/blue_elec"
		local lightningThickness = 5
		local lightningColor = Color(56, 75, 255)
		local lightningLifespan = 0.15
		
		local fings = {
			{up = 3, right = 2, forward = 2}, -- thumb
			{up = 3, right = 1, forward = 3},
			{up = 2, right = 1, forward = 3},
			{up = 1, right = 1, forward = 3},
			{up = 0, right = 1, forward = 3},
		}
		
		
        if IsValid(tar) then
            local baseDamage = forceLevel
            local duration = 1
            local interval = 0.5
			
			if ply:hasKeys() then
				ply:anim("wos_cast_lightning", 1, 1)
			else
				ply:anim("wos_cast_lightning_armed", 1, 1)
			end
		
			ply:addSlow(100, 0.5)
            tar:addSlow(25, 0.5)
			
            ply:sound("hfg/weapons/force/lightning2.wav")
            tar:sound("hfg/weapons/force/lightninghit1.mp3")
			
            local vecs = {}
			
			local working = false
			if tar:IsPlayer() then
				if tar:getForce() >= baseDamage/4 then
					if tar:hasSaber() then
						if tar.blockTime >= CurTime() then
							for _,v in pairs(fings) do
								local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
								local fing, fang = ply:GetBonePosition(bone)
								
								fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
								
								local bone = tar:LookupBone("ValveBiped.Bip01_R_Hand") or 0
								local pos, ang = tar:GetBonePosition(bone)
								
								pos = pos + ang:Forward() * 3 + ang:Up() * 2 + ang:Right() * 1.5
								ang:RotateAroundAxis(ang:Right(), 180)
								
								table.insert(vecs, {s = fing, e = pos + ang:Up() * math.random(35,0)})
							end
							
							advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
							tar.lastLigtning = tar.lastLigtning or 0
							
							if tar.lastLigtning <= CurTime() then
								tar:takeForce(baseDamage/4)
								tar.lastLigtning = CurTime() + duration/2
							end
							
							working = true
						end
					end
				end
			end
		
			if not working then
				for _,v in pairs(fings) do
					local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
					local fing, fang = ply:GetBonePosition(bone)
					
					fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
					
					table.insert(vecs, {s = fing, e = targetRandomPos(tar)})
				end
				advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
				tar.lastLigtning = tar.lastLigtning or 0
				if tar.lastLigtning <= CurTime() then
					tar:applyDoT(ply, baseDamage, duration, interval, DMG_ENERGYBEAM)
					ply:heal(baseDamage, Color(0, 255, 0))
					tar.lastLigtning = CurTime() + duration/2
				end
			end
			
        else
            local tr = util.TraceLine( {
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:EyeAngles():Forward() * 512,
				filter = function(ent) return ent == self end
			})
			
			if ply:hasKeys() then
				ply:anim("wos_cast_lightning", 1, 0.5)
			else
				ply:anim("wos_cast_lightning_armed", 1, 0.5)
			end
		
			ply:addSlow(100, 0.5)
            
			local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
			local hand = ply:GetBonePosition(bone)
			
			ply:sound("hfg/weapons/force/lightning2.wav")
            --castLightning(hand, tr.HitPos, 2, "cable/blue_elec", 0.1, Color(222,255,254))
			
			local vecs = {}

			-- targetRandomPos(target)
			for _,v in pairs(fings) do
				local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
				local fing, fang = ply:GetBonePosition(bone)
				
				fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
				
				table.insert(vecs, {s = fing, e = tr.HitPos})
			end
			
			advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
        end
    end
})

lts.addPower("Cheap Trick", {
    desc = "Force your enemies saber to turn off.",
    icon = "hfgjvs/kraken/sith oper lethality/1172017248_1435774430.png",
	isClassPower = true,
	jediName = "Force Disarm",
	jediDesc = "Force your enemies saber to turn off.",
	jediIcon = "hfgjvs/kraken/jedi scoun ruffian/1962483690_516502081.png",
    cost = 75,
    cooldown = 60,
    xx = 7.5, yy = 13,
    requires = {"Force Cloak"},
    allowed = {"Sith"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		ply:stopSound("hfg/weapons/force/lightning2.wav")
		ply:anim("wos_cast_lightning", 1, 0)
	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local tar = ply:laneCastSingle(512, 64)

        if IsValid(tar) then
            if tar:GetActiveWeapon():GetClass() == "tyler_saber" then
				local wep = tar:GetActiveWeapon()
				tar:EmitSound("hfg/weapons/saber/saberoffquick.mp3")
				tar:StopSound("hfg/weapons/saber/saberhum1.wav")
				tar.ignited = false
				tar:GetActiveWeapon():SetWeaponHoldType( "normal" )
				tar:GetActiveWeapon():SetHoldType( "normal" )
				wep:SetNWBool("enabled", false)
			end
        end
    end
})




lts.addPower("Force Blink", {
    desc = "Blink forward up to 2048 units.",
    icon = "hfgjvs/kraken/sith ass deception/2203546642_115423332.png",
	isClassPower = true,
	jediName = "Force Teleport",
	jediDesc = "Blink forward up to 1024 units.",
	jediIcon = "hfgjvs/kraken/jedi sage seer/859101596_1062532045.png",
    cost = 75,
    cooldown = 30,
    xx = 7.5, yy = 16,
    requires = {"Red Lightning", "Cheap Trick", "Force Web"},
    allowed = {"Sith"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		local maxTeleportDistance = 2048
		local maxSlopeAngle = 45
		local eyePos = ply:EyePos()
		local eyeAngles = ply:EyeAngles()
		local forward = eyeAngles:Forward()

		local trace = util.TraceLine({
			start = eyePos,
			endpos = eyePos + forward * maxTeleportDistance,
			filter = ply
		})

		if trace.Hit then
			local hitPos = trace.HitPos
			local hitNormal = trace.HitNormal

			local slopeAngle = math.deg(math.acos(hitNormal:Dot(Vector(0, 0, 1))))

			if slopeAngle <= maxSlopeAngle then
				local teleportPos = hitPos

				if trace.Fraction < 1 then
					ply:SetPos(teleportPos)
				else
					ply:SetPos(eyePos + forward * maxTeleportDistance + Vector(0,0,16))
				end
			end
		else
			ply:SetPos(ply:GetPos() + ply:GetForward() * maxTeleportDistance + Vector(0,0,16))
		end
    end
})

lts.addPower("Force Absorb", {
	desc = "Become invulnerable for 8 seconds.",
	icon = "hfgjvs/kraken/sith jugg rage/4014681151_1768678916.png",
	isClassPower = true,
	jediName = "Tutaminis",
	jediDesc = "Become invulnerable for 8 seconds.",
	jediIcon = "hfgjvs/kraken/jedi sage balance/2348207445_3124779292.png",
	cooldown = 45, cost = 50,
	xx = 4.5, yy = 11,
	requires = {"Armor Repair", "Dark Shield"},
	allowed = {"Sith"},
	func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		ply.invulnerable = CurTime() + 8
		ply:sound("hfg/weapons/force/absorb.mp3")
	end
})

lts.addPower("Dark Shield", {
    desc = "Enter a defensive stance and negate then reduce incoming damage.",
    icon = "hfgjvs/kraken/sith mara carnage/1181912592_4091553054.png",
	isClassPower = true,
	jediName = "Force Guard",
	jediDesc = "Repair your armor increasing your total defense.",
	jediIcon = "hfgjvs/kraken/jedi guard defense/3468098433_3300445041.png",
    cooldown = 45, cost = 50,
    xx = 5.5, yy = 11,
    requires = {"CUSTOM_POWERS"},
    allowed = {"Sith"},
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        ply.invulnerable = CurTime() + 2
		ply:addResistance(DMG_GENERIC, 10, 5)
		ply:addResistance(DMG_SLASH, 10, 5)
		ply:repair(250)
		ply:sound("hfg/weapons/force/absorb.mp3")
    end
})

lts.addPower("Force Shock", {
	desc = "Use the force to shock and stun your opponent",
	icon = "hfgjvs/kraken/sith merc innovative ordnance/3725624151_1478255135.png",
	isClassPower = true,
	jediName = "Force Electrocute",
	jediDesc = "Use the force to shock and stun your opponent",
	jediIcon = "hfgjvs/kraken/jedi sent combat/2798143181_1501722744.png",
	cooldown = 45, cost = 50,
	xx = 4.5, yy = 13,
	requires = {"Force Absorb"},
	allowed = {"Sith"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		ply:stopSound("hfg/weapons/force/lightning2.wav")
		ply:anim("wos_cast_lightning", 1, 0)
	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local tar = ply:laneCastSingle(512, 64)
		
		local lightningTexture = "lordtyler/lightning/orange.png"
		--local lightningTexture = "cable/blue_elec"
		local lightningThickness = 5
		local lightningColor = Color(56, 75, 255)
		local lightningLifespan = 0.15
		
		local fings = {
			{up = 3, right = 2, forward = 2}, -- thumb
			{up = 3, right = 1, forward = 3},
			{up = 2, right = 1, forward = 3},
			{up = 1, right = 1, forward = 3},
			{up = 0, right = 1, forward = 3},
		}
		
		
        if IsValid(tar) then
            local baseDamage = forceLevel
            local duration = 1
            local interval = 0.5
			
			if ply:hasKeys() then
				ply:anim("wos_cast_lightning", 1, 1)
			else
				ply:anim("wos_cast_lightning_armed", 1, 1)
			end
		
			ply:addSlow(100, 0.5)
            tar:addSlow(25, 0.5)
			
            ply:sound("hfg/weapons/force/lightning2.wav")
            tar:sound("hfg/weapons/force/lightninghit1.mp3")
			
            local vecs = {}
			
			local working = false
			if tar:IsPlayer() then
				if tar:getForce() >= baseDamage/4 then
					if tar:hasSaber() then
						if tar.blockTime >= CurTime() then
							for _,v in pairs(fings) do
								local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
								local fing, fang = ply:GetBonePosition(bone)
								
								fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
								
								local bone = tar:LookupBone("ValveBiped.Bip01_R_Hand") or 0
								local pos, ang = tar:GetBonePosition(bone)
								
								pos = pos + ang:Forward() * 3 + ang:Up() * 2 + ang:Right() * 1.5
								ang:RotateAroundAxis(ang:Right(), 180)
								
								table.insert(vecs, {s = fing, e = pos + ang:Up() * math.random(35,0)})
							end
							
							advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
							tar.lastLigtning = tar.lastLigtning or 0
							
							if tar.lastLigtning <= CurTime() then
								tar:takeForce(baseDamage/4)
								tar.lastLigtning = CurTime() + duration/2
							end
							
							working = true
						end
					end
				end
			end
		
			if not working then
				for _,v in pairs(fings) do
					local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
					local fing, fang = ply:GetBonePosition(bone)
					
					fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
					
					table.insert(vecs, {s = fing, e = targetRandomPos(tar)})
				end
				advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
				tar.lastLigtning = tar.lastLigtning or 0
				if tar.lastLigtning <= CurTime() then
					tar:applyDoT(ply, baseDamage, duration, interval, DMG_ENERGYBEAM)
					tar:addStun(2)
					tar:addSlow(1,2)
					tar:anim("wos_bs_shared_kneeling", 1, 2)
					tar.lastLigtning = CurTime() + duration/2
				end
			end
			
        else
            local tr = util.TraceLine( {
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:EyeAngles():Forward() * 512,
				filter = function(ent) return ent == self end
			})
			
			if ply:hasKeys() then
				ply:anim("wos_cast_lightning", 1, 0.5)
			else
				ply:anim("wos_cast_lightning_armed", 1, 0.5)
			end
		
			ply:addSlow(100, 0.5)
            
			local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
			local hand = ply:GetBonePosition(bone)
			
			ply:sound("hfg/weapons/force/lightning2.wav")
            --castLightning(hand, tr.HitPos, 2, "cable/blue_elec", 0.1, Color(222,255,254))
			
			local vecs = {}

			-- targetRandomPos(target)
			for _,v in pairs(fings) do
				local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
				local fing, fang = ply:GetBonePosition(bone)
				
				fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward
				
				table.insert(vecs, {s = fing, e = tr.HitPos})
			end
			
			advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
        end
    end
})

lts.addPower("Force Crush", {
	desc = "Use the force to crush and stun your opponent",
	icon = "hfgjvs/kraken/sith mara annihilation/548855568_1259323027.png",
	isClassPower = true,
	jediName = "Force Wound",
	jediDesc = "Use the force to wound and stun your opponent",
	jediIcon = "hfgjvs/kraken/jedi shad infiltration/1243919091_2936482099.png",
	cooldown = 45, cost = 50,
	xx = 5.5, yy = 13,
	requires = {"Force Absorb"},
	allowed = {"Sith"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		
	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local tar = ply:laneCastSingle(512, 64)
        if IsValid(tar) then
			ply:anim("wos_cast_choke_armed", 1, 2)
			tar:anim("wos_force_crush", 1, 2)
			
			ply:addSlow(1, 1)
			tar:addSlow(1, 1)
			
			ply:addStun(1)
			tar:addStun(1)
			
			tar:energyBeamDamage(2000, 0, ply)
        end
    end
})

lts.addPower("Force Choke", {
	desc = "Use the force to choke and stun your opponent, low cost high cooldown - based on Force level.",
	icon = "hfgjvs/kraken/sith snip marksmanship/981030376_3198293177.png",
	isClassPower = true,
	jediName = "Force Grab",
	jediDesc = "Use the force to choke and stun your opponent, low cost high cooldown - based on Force level.",
	jediIcon = "hfgjvs/kraken/jedi shad infiltration/4143699087_2482769172.png",
	cooldown = 60, cost = 10,
	xx = 3.5, yy = 13,
	requires = {"Force Absorb"},
	allowed = {"Sith"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		
	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local tar = ply:laneCastSingle(512, 64)
        if IsValid(tar) then
			ply:anim("wos_cast_choke_armed", 1, 2)
			tar:anim("wos_force_choke", 1, 2)
			
			ply:sound("hfg/weapons/force/grip.mp3")
			
			ply:addSlow(1, 1)
			tar:addSlow(1, 1)	
			
			ply:addStun(1)
			tar:addStun(1)
			
			tar:energyBeamDamage(2000 + forceLevel, 0, ply)
        end
    end
})


lts.addPower("Rage", {
	desc = "Become unstopable for 15 seconds.",
	icon = "hfgjvs/kraken/sith mara annihilation/1346045608_3577177739.png",
	isClassPower = true,
	jediName = "Berserk",
	jediDesc = "Become unstopable for 15 seconds.",
	jediIcon = "hfgjvs/kraken/jedi shad kinetic combat/1213474378_1661745960.png",
	cooldown = 120+15, cost = 200,
	xx = 4.5, yy = 16,
	requires = {"Force Shock", "Force Crush", "Force Choke"},
	allowed = {"Sith"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		
	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        ply:anim("menu_zombie", 1, 1)
		ply:addSlow(1,1)
		ply:Ignite(15)
		
		ply:addResistance(DMG_GENERIC, 90, 15)
		ply:addResistance(DMG_BURN, 90, 15)
		ply:addResistance(DMG_BLAST, 90, 15)
		ply:addResistance(DMG_SHOCK, 90, 15)
		ply:addResistance(DMG_SONIC, 90, 15)
		ply:addResistance(DMG_ENERGYBEAM, 90, 15)
		ply:addResistance(DMG_DROWN, 90, 15)
		ply:addResistance(DMG_NERVEGAS, 90, 15)
		ply:addResistance(DMG_POISON, 90, 15)
		ply:addResistance(DMG_RADIATION, 90, 15)
		ply:addResistance(DMG_ACID, 90, 15)
		ply:addResistance(DMG_SLOWBURN, 90, 15)
		ply:addResistance(DMG_PLASMA, 90, 15)
		ply:addResistance(DMG_DISSOLVE, 90, 15)
		ply:addResistance(DMG_SLASH, 90, 15)
    end
})



lts.addPower("Fleetfoot", {
	desc = "Move faster while attacking for 8 seconds.",
	icon = "hfgjvs/kraken/jedi vang plasmatech/3747161145_2453909426.png",
	isClassPower = true,
	jediName = "Dance of the Blade",
	jediDesc = "Move faster while attacking for 8 seconds.",
	jediIcon = "hfgjvs/kraken/jedi guard defense/1967656806_1002793691.png",
	cooldown = 60+8, cost = 200,
	xx = 1.5, yy = 16,
	requires = {"Force Kill", "Power Strike", "Whirlwind"},
	allowed = {"Sith"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		
	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        ply:anim("menu_zombie", 1, 1)
		ply.fleetfoot = CurTime() + 8
    end
})



lts.addPower("Force Stalk", {
    desc = "Detect nearby danger or other beings within a short range.",
    icon = "hfgjvs/kraken/sith snip marksmanship/3533406657_3327671360.png",
	isClassPower = true,
	jediName = "Force Sense",
	jediDesc = "Detect nearby danger or other beings within a short range.",
	jediIcon = "hfgjvs/kraken/jedi sage telekinetics/2939369316_491388031.png",
    cost = 40,
    cooldown = 30,
    xx = 2.5, yy = 11,
    requires = {"CUSTOM_POWERS"},
    allowed = {"Jedi", "Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local senseRadius = 512 -- Short range radius for detecting danger or beings
        local senseDuration = 10 -- Duration of the ESP effect

        -- Animation for casting Force Sense
        ply:anim("wos_cast_lightning", 1, 1)

        -- Hook to outline nearby entities (similar to ESP)
        hook.Add("PreDrawHalos", "ForceSenseHalo_" .. ply:EntIndex(), function()
            local targets = {}
            for _, ent in pairs(ents.FindInSphere(ply:GetPos(), senseRadius)) do
                if ent:IsPlayer() or ent:IsNPC() then
                    table.insert(targets, ent)
                end
            end

            -- Apply halo effect to show detected entities
            halo.Add(targets, Color(255, 150, 0), 2, 2, 1, true, true)
        end)

        -- Remove Force Sense after the duration ends
        timer.Simple(senseDuration, function()
            if IsValid(ply) then
                hook.Remove("PreDrawHalos", "ForceSenseHalo_" .. ply:EntIndex())
            end
        end)

        -- Optional: Sound effect to signify Force Sense activation
        ply:sound("ambient/levels/labs/electric_explosion1.wav")
    end
})

lts.addPower("Force Kill", {
    desc = "Stop the target's vital bodily functions.",
	isClassPower = true,
	jediName = "Force Neutralize",
	jediDesc = "Ends the vitals of the threat before you.",
	jediIcon = "hfgjvs/kraken/jedi sage balance/4265406457_2577452578.png",
    icon = "hfgjvs/kraken/sith sorc lightning/2619532686_1456484940.png",
    cost = 120,
    cooldown = 45,
    xx = 0.5, yy = 13,
    requires = {"Dark Surge"},
    allowed = {"Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local tar = ply:laneCastSingle(512, 128)
        if IsValid(tar) then
            local damage = 250
            local healthThreshold = tar:GetMaxHealth() * 0.05 -- 5% of target's max health

            ply:anim("wos_cast_choke", 1, 1)

            -- Check if target is below 5% health for execution
            if tar:Health() <= healthThreshold then
                tar:applySingleDamage(ply, tar:Health(), DMG_GENERIC) -- Instantly kills target
            else
                tar:applySingleDamage(ply, damage, DMG_GENERIC) -- Applies 250 damage
            end

            -- Force Kill visual effect
            timer.Simple(0.5, function()
                local startPos = ply:EyePos()
                local endPos = tar:GetPos() + Vector(0, 0, 64)

                castRay(startPos, endPos, 1, Color(255, 0, 0), 1)
            end)
        end
    end
})

lts.addPower("Power Strike", {
    desc = "Instantly gain a T3 attack!",
    icon = "hfgjvs/kraken/sith jugg immortal/2137988118_3532955493.png",
	isClassPower = true,
	jediName = "True Strike",
	jediDesc = "Instantly gain a T3 attack!",
	jediIcon = "hfgjvs/kraken/jedi guard defense/1174161262_3840476148.png",
    cost = 50,
    cooldown = 10,
    xx = 1.5, yy = 13,
    requires = {"Dark Surge"},
    allowed = {"Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        local wep = ply:GetActiveWeapon()
		if wep:GetClass() == "tyler_saber" then
			wep.comboID = 3
			ply:SetNWInt("combo", 3)
		end
    end
})

lts.addPower("Whirlwind", {
    desc = "Beyblade beyblade, let 'er rip",
    icon = "hfgjvs/kraken/sith mara annihilation/1879443733_376321230.png",
	isClassPower = true,
	jediName = "Cyclone",
	jediDesc = "Beyblade beyblade, let 'er rip",
	jediIcon = "hfgjvs/kraken/jedi sent combat/223848346_3608669147.png",
    cost = 50,
    cooldown = 10,
    xx = 2.5, yy = 13,
    requires = {"Dark Surge"},
    allowed = {"Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
        ply:anim("vanguard_h_right_t3", 1, 2)
		
		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 512)) do
			if v:IsPlayer() or v:IsNPC() then
				if v ~= ply then
					v:saberDamage(saberLevel*4, 0, ply)
					if v:IsPlayer() then
						v:SetPos(v:GetPos() + 1)
						v:addStun(2)
						v:addSlow(1,2)
						v:AddVelocity(Vector(0,0,500))
					end
				end
			end
		end
		
    end
})





lts.addPower("Force Kick Balls", {
    desc = "Custom Power (Tyler)",
    icon = "hfgjvs/kraken/jedi scoun ruffian/2860058812_1289146270.png",
    cooldown = 2, cost = 5,
    xx = -5, yy = -2,
    requires = {"CUSTOM_POWERS"},
    allowed = {"Jedi", "Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		ply:anim("wos_bs_shared_kick", 1, 1)
		
		
		ply.kicking2 = CurTime() + 1
		timer.Simple(0.5, function()
			local bone = ply:LookupBone("ValveBiped.Bip01_L_Foot")
			local pos, ang = ply:GetBonePosition(bone)
			
			for k,v in pairs(ents.FindInSphere(pos, 32)) do
				if v ~= ply then
					if v:IsPlayer() then
						v:GetPhysicsObject():AddVelocity(ply:GetForward() * 250 + Vector(0,0,100))
						if v:IsPlayer() then
							local wep = v:GetActiveWeapon()
							if wep:GetClass() == "tyler_saber" then
								if v.blocking then
									ply:anim("wos_bs_shared_kick", 1, 0)
									--ply:addSlow(1,0.1)
									
									v:addStun(1.5)
									ply.kicking2 = 0
									ply:addLog("POWERKICK", "%s has power kicked %s breaking their block.", {ply:Nick(), v:Nick()})
									v:addLog("POWERKICK_RECIEVED", "%s was power kicked %s and their block was broken.", {v:Nick(), ply:Nick()})
								else
									v:addLog("POWERKICK_RECIEVED", "%s was kicked by %s.", {v:Nick(), ply:Nick()})
									ply:addLog("POWERKICK", "%s has power kicked %s.", {ply:Nick(), v:Nick()})
									ply:addSlow(1,0.5)
								end
							
								v.blocking = false
								v.attackTime = 0
								v.blockTime = 0
								v:addStun(1)
								v:addSlow(1, 1)
							end
							local anim = table.Random({"h_reaction_lower"})
							v:anim(anim, 1, 1)
							v:EmitSound("hfg/player/gurp2.wav")
						end
					end
				end
			end
		end)
		ply:addXP("Melee", math.random(1,5))
    end
})

lts.addPower("Chain Darkness", {
    desc = "Custom Power (Jade)",
    icon = "hfgjvs/kraken/sith sorc lightning/2674624317_1425116172.png",
    cooldown = 30, cost = 100,
    xx = -6, yy = -2,
    requires = {"CUSTOM_POWERS"},
    allowed = {"Jedi", "Sith"},
    done = function(ply, faction, forceLevel, saberLevel, defenseLevel)

    end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		local tar = ply:laneCastSingle(512, 64)
		if IsValid(tar) then
			local lightningTexture = "lordtyler/lightning/c_blurple.png"
			local lightningThickness = 6
			local lightningColor = Color(85, 57, 204)
			local lightningLifespan = 0.15

			local fings = {
				{up = 3, right = 2, forward = 2},
				{up = 3, right = 1, forward = 3},
				{up = 2, right = 1, forward = 3},
				{up = 1, right = 1, forward = 3},
				{up = 0, right = 1, forward = 3},
			}

			local baseDamage = 300
			local duration = 3
			local interval = 0.5

			if ply:hasKeys() then
				ply:anim("wos_cast_lightning", 1, 1)
			else
				ply:anim("wos_cast_lightning_armed", 1, 1)
			end

			ply:addSlow(100, 0.5)
			tar:addSlow(50, 0.5)

			ply:sound("hfg/weapons/force/lightning2.wav")
			tar:sound("hfg/weapons/force/lightninghit1.mp3")

			local vecs = {}

			for _, v in pairs(fings) do
				local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
				local fing, fang = ply:GetBonePosition(bone)

				fing = fing + fang:Up() * v.up + fang:Right() * v.right + fang:Forward() * v.forward

				table.insert(vecs, {s = fing, e = targetRandomPos(tar)})
			end

			advancedLightning(vecs, lightningThickness, lightningTexture, lightningLifespan, lightningColor)
			tar:chainLightning(ply, 512, 5, 0.66, 1000, lightningTexture, lightningColor)
		end
    end
})

lts.addPower("Golden Dawn", {
    desc = "Custom Force Power",
    icon = "hfgjvs/kraken/jedi vang shield specialist/129334767_2124567916.png",
    cost = 50,
    cooldown = 60,
    xx = -8, yy = -2,
    requires = {"CUSTOM_POWERS"},
    allowed = {"Sith", "Jedi"},
	done = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		
	end,
    func = function(ply, faction, forceLevel, saberLevel, defenseLevel)
		ply:anim("menu_zombie_01", 1, 0.75)
		ply:addSlow(25, 0.75)
		
		local storm = ents.Create("lts_sunny_storm")
		storm:SetPos(ply:GetPos())
		storm.dmg = 100 + math.floor(forceLevel/2)
		storm:Spawn()
		storm.ply = ply
		timer.Simple(28.5,function()
			storm:Remove()
		end)
		
    end
})

function lts.gerenateJediPowers()
	for k,v in pairs(lts.forcePowers) do
		if v.daddy then
			local sithPower = lts.forcePowers[v.daddy]
			v.allowed = {"Jedi"}
			for m,sithReq in pairs(sithPower.requires) do
				local sithReqPower = lts.forcePowers[sithReq]
				if not sithReqPower then
					v.requires[m] = "CUSTOM_POWERS"
				else
					v.requires[m] = sithReqPower.jediName or "UNSET"
				end
			end
			
		end
	end
end
lts.gerenateJediPowers()

-- Work around for generated requiring non-gen'd
lts.forcePowers["Force Teleport"].requires = {"Emerald Lightning", "Force Disarm", "Force Entangle"}
lts.forcePowers["Battle Meditation"].requires = {"Force Levitate"}
lts.forcePowers["Force Siphon"].requires = {"Electric Judgement", "Force Rejuvinate"}
--lts.forcePowers["Electric Judgement"].requires = {"Light Heal"}