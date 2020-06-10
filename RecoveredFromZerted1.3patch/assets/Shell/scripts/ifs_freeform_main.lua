--ifs_freeform_main.lua - zerted patch 1.3
-- verified by cbadal

--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_planet_name_sound = "mtg_%s_planet_name_%s"

ifs_freeform_tab_layout = 
{
	{ tag = "_tab_fleet", string = "ifs.freeform.navigation.move",  screen = "ifs_freeform_fleet",         },
	{ tag = "_tab_bonus", string = "ifs.freeform.navigation.bonus", screen = "ifs_freeform_purchase_tech", },
	{ tag = "_tab_units", string = "ifs.freeform.navigation.units", screen = "ifs_freeform_purchase_unit", },
}


ifs_freeform_main = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,
	
	-- get current team resources
    GetResources = function(this, team)
        print("ifs_freeform_main: GetResources()")

		team = team or this.playerTeam
		return this.teamResources[team]
	end,

	-- add current team resources
    AddResources = function(this, team, amount)
        print("ifs_freeform_main: AddResources()")

		team = team or this.playerTeam
		this.teamResources[team] = this.teamResources[team] + amount
		return this.teamResources[team]
	end,
	
	-- enough resources?
	EnoughResources = function(this, team, amount)
		team = team or this.playerTeam
		return amount and this.teamResources[team] >= amount
	end,
	
	-- try to spend amount
    SpendResources = function(this, team, amount)
        print( "ifs_freeform_main: SpendResources()")

		team = team or this.playerTeam
		if amount and this.teamResources[team] >= amount then
			this.teamResources[team] = this.teamResources[team] - amount
			return this.teamResources[team]
		end
		return nil
	end,
	
	-- create a starport with the specified team on the specified planet
    CreatePort = function(this, team, planet)
        print("ifs_freeform_main: CreatePort()")
--		if not this.planetPort[planet] then
--			this.planetPort[planet] = team
--		end
--		if not this.portPtr[planet] then
--			this.portPtr[planet] = CreateEntity(this.portClass[team], this.modelMatrix[planet][3])
--		end
	end,
	
	-- destroy a starport with the specified team on the specified planet
    DestroyPort = function(this, team, planet)
        print( "ifs_freeform_main: DestroyPort()")
--		if this.planetPort[planet] == team then
--			this.planetPort[planet] = nil
--		end
--		if this.portPtr[planet] then
--			DeleteEntity(this.portPtr[planet])
--			this.portPtr[planet] = nil
--		end
	end,
	
	-- create a fleet with the specified team on the specified planet
    CreateFleet = function(this, team, planet)
        print("ifs_freeform_main: CreateFleet()")
		-- add the fleet to the planet
		if not this.planetFleet[planet] then
			this.planetFleet[planet] = team
		elseif this.planetFleet[planet] == 3 - team then
			this.planetFleet[planet] = 0
		end
		
		-- create a fleet entity
		if not this.fleetPtr[team][planet] then
			this.fleetPtr[team][planet] = CreateEntity(this.fleetClass[team], this.modelMatrix[planet][team])
		end
		
		-- update the last fleet
		this.lastFleet[team] = planet
	end,
	
	-- destroy a fleet with the specified team on the specified planet
    DestroyFleet = function(this, team, planet)
        print( "ifs_freeform_main: DestoryFleet()")
		-- remove the fleet from the planet
		if this.planetFleet[planet] == 0 then
			this.planetFleet[planet] = 3 - team
		elseif this.planetFleet[planet] == team then
			this.planetFleet[planet] = nil
		end
		if this.fleetPtr[team][planet] then
			DeleteEntity(this.fleetPtr[team][planet])
			this.fleetPtr[team][planet] = nil
		end
	end,

	-- move a fleet with the specified planet from the start planet to the next planet
    MoveFleet = function(this, team, start, next)
        print( "ifs_freeform_main: MoveFleet()")

		-- save the fleet object
		local fleetPtr = this.fleetPtr[team][start]
		
		-- remove the fleet from the start planet
		this.fleetPtr[team][start] = nil
		if this.planetFleet[start] == 0 then
			this.planetFleet[start] = 3 - team
		elseif this.planetFleet[start] == team then
			this.planetFleet[start] = nil
		end
		
		-- update the fleet's position
		SetEntityMatrix(fleetPtr, this.modelMatrix[next][team])
		
		-- add the fleet to the next planet
		this.fleetPtr[team][next] = fleetPtr
		if not this.planetFleet[next] then
			this.planetFleet[next] = team
		elseif this.planetFleet[next] == 3 - team then
			this.planetFleet[next] = 0
		end
		
		-- update the last fleet
		this.lastFleet[team] = next
	end,
	
	-- select the specified planet
	SelectPlanet = function(this, info, planet)
        if this.planetSelected ~= planet then
            print( "ifs_freeform_main: SelectPlanet()")

			-- update the selection
			this.planetSelected = planet
			this.planetNext = planet
			
			-- move the camera to the selected planet
			MoveCameraToEntity(planet)
			
			-- apply planet camera offset
			local offset = this.cameraOffset[planet]
			if offset then
				SetMapCameraOffset(2, offset[1], offset[2], offset[3])
			end
			
			if info then
				this:UpdatePlanetInfo(info)
			end
		end
	end,
	
	-- update the information window with planet data
	UpdatePlanetInfo = function(this, info, planet)
		-- update the information window
		planet = planet or this.planetNext
		team = this.planetTeam[planet]
		if not team or team == 0 then
			IFText_fnSetUString(info.text, ScriptCB_tounicode(""))
		else
			value = this.planetValue[planet] or this
			base = planet == this.planetBase[team]
			local text = ScriptCB_UnicodeStrCat(
				value.victory and ScriptCB_usprintf("ifs.freeform.victorycredits", ScriptCB_tounicode(value.victory)) or ScriptCB_tounicode(""),
				ScriptCB_tounicode("\n"),
				value.turn and ScriptCB_usprintf("ifs.freeform.turncredits", ScriptCB_tounicode(value.turn)) or ScriptCB_tounicode(""),
				ScriptCB_tounicode("\n"),
				base and ScriptCB_getlocalizestr(this.baseName[team]) or ScriptCB_tounicode(""),
				ScriptCB_tounicode("\n")
				)
			IFText_fnSetUString(info.text, text)
		end
	end,

	-- set launch mission
    SetLaunchMission = function(this, mission)
        print( "ifs_freeform_main: SetLaunhMission()")

		-- set the mission to launch
		if type(mission) == "table" then
			this.launchMission = mission[math.random(table.getn(mission))]
		else
            this.launchMission = mission
        end
        print( "ifs_freeform_main: SetLaunhMission(): Using mission: ", this.launchMission or "[Nil]")
		ScriptCB_SetMissionNames(this.launchMission, nil)
	end,
	
	-- save mission setup
    SaveMissionSetup = function(this)
        print( "ifs_freeform_main: SaveMissionSetup()")

		-- create mission setup table
		local missionSetup = {}
		
		-- add team units
		local teamUnits = {}
		for team, code in ifs_freeform_main.teamCode do
			teamUnits[code] = ifs_purchase_unit_owned[team]
		end
		missionSetup.units = teamUnits
		
		-- add current world
		local selected = ifs_freeform_main.planetSelected
		missionSetup.world = ifs_freeform_main.planetTeam[selected] and selected or "spa"
		
		-- store mission setup table
		ScriptCB_SaveMissionSetup(missionSetup)
		
		-- set forced teams
		for controller, team in pairs(ifs_freeform_main.controllerTeam) do
			ScriptCB_MetagameSetSide(ifs_freeform_main.controllerPlayer[controller], ifs_freeform_main.teamCode[team])
		end
		
		-- Reset difficulty to what's in profile
		ScriptCB_SetDifficulty(ScriptCB_GetDifficulty())
	end,
		
	-- apply battle results for the specified planet
    ApplyBattleResult = function(this, planet, winner)
        print("ifs_freeform_main: ApplyBattleResult()")
		-- save which team won
		this.winnerTeam = winner
		
		-- save whether the battle was a fleet battle
		this.fleetBattle = this.planetFleet[planet] == 0
		
		-- get the losing team
		local loser = 3 - winner

		-- create if necessary		
		this.planetResources = this.planetResources or {}
		this.battleResources = this.battleResources or {}
		
		-- no planet resources yet
		this.planetResources[winner] = 0
		this.planetResources[loser] = 0
			
		-- if the battle was a fleet battle...
		if this.fleetBattle then
			-- give winner and loser some resources
			this.battleResources[winner] = this.spaceValue.victory
			this.battleResources[loser] = this.spaceValue.defeat
		else
			-- if the planet is the loser's base, remove it from play
			-- otherwise, assign it to the winner
			this.planetTeam[planet] = planet == this.planetBase[loser] and 0 or winner
						
			-- give winner and loser planet resources
			this.battleResources[winner] = this.planetValue[planet].victory
			this.battleResources[loser] = this.planetValue[planet].defeat
			
			-- add per-turn resource units per planet
			for planet, team in pairs(this.planetTeam) do
				if team ~= 0 then
					this.planetResources[team] = this.planetResources[team] + this.planetValue[planet].turn
				end
			end
		end
		
		-- give each team its added resources
		this:AddResources(winner, this.battleResources[winner] + this.planetResources[winner])
		this:AddResources(loser, this.battleResources[loser] + this.planetResources[loser])
		
		-- remove the loser's fleet, if any
		if this.fleetBattle or this.planetFleet[planet] == loser then
			AttachEffectToMatrix(CreateEffect(this.fleetExplosion[loser]), this.modelMatrix[planet][loser])
		end
		this:DestroyFleet(loser, planet)
		
		-- add the planet to the battle list (for AI)
		this.recentPlanets = this.recentPlanets or {}
		if this.planetTeam[planet] and this.planetTeam[planet] > 0 then
			this.recentPlanets[3] = nil
			table.insert(this.recentPlanets, 1, planet)
		end
	end,
	
	-- set the active team
    SetActiveTeam = function(this, team)
        print( "ifs_freeform_main: SetActiveTeam()")

		this.playerTeam = team
		this.playerSide = this.teamCode[team]
		this.otherSide = this.teamCode[3 - team]
		this.joystick = this.teamController[team]
		this.joystick_other = this.teamController[3 - team]
		ScriptCB_SetHotController((this.joystick or this.joystick_other or 0)+1)
			
		-- update dependent values
		ifs_freeform_purchase_unit:SetActiveSide()
	end,
	
	-- go to the next turn
    NextTurn = function(this)
        print( "ifs_freeform_main: NextTurn()")

		-- clear the screen stack
		ScriptCB_PopScreen("ifs_freeform_main")
		
		-- update metagame victory result
		if this.CheckVictory then
			this.teamVictory = this:CheckVictory()
		end
		
		-- on victory...
		if this.teamVictory then
			-- go to the end screen
			ScriptCB_PushScreen("ifs_freeform_end")
		else
			-- advance to the next turn
			this.turnNumber = this.turnNumber + 1
			
			-- switch teams
			this.lastSelected[this.playerTeam] = this.planetNext
			this:SetActiveTeam(3 - this.playerTeam)
			this:SelectPlanet(nil, this.lastSelected[this.playerTeam])
			
			-- clear state
			this.launchMission = nil
			this.activeBonus = {}
			
			-- if the team has a human player...
			if this.joystick then
				-- go to the fleet screen
				ScriptCB_PushScreen("ifs_freeform_fleet")
			else
				-- go to ai move
				ScriptCB_PushScreen("ifs_freeform_ai")
			end
		end
	end,
	
	-- set up team colors
	InitTeamColor = function(this)
		-- precomputed colors
		local colorWhite = { r=255, g=255, b=255 }
		local colorBlue = { r=32, g=96, b=255 }
		local colorRed = { r=255, g=32, b=32 }
		
		-- if AI versus team 2...
		this.teamColor = {}
		if not this.teamController[1] and this.teamController[2] then
			-- swapped colors: 1=red, 2=blue
			this.teamColor[1] = { [0] = colorWhite, [1] = colorRed, [2] = colorBlue }
			this.teamColor[2] = { [0] = colorWhite, [1] = colorRed, [2] = colorBlue }
		else
			-- absolute colors: 1=blue, 2=red
			this.teamColor[1] = { [0] = colorWhite, [1] = colorBlue, [2] = colorRed }
			this.teamColor[2] = { [0] = colorWhite, [1] = colorBlue, [2] = colorRed }
		end
	end,
	
	-- get the color value for the specified team
	GetTeamColor = function(this, team)
		local color = this.teamColor[this.playerTeam][team]
		return color.r, color.g, color.b
	end,

	-- get the color value for the specified affordability
	GetCreditsColor = function(this, afford)
		if afford then
			return 255, 255, 32		-- can afford: yellow
		else
			return 255, 32, 32		-- can't afford: red
		end
	end,
	
	-- is a zoom currently active?
	IsZoomActive = function(this)
		-- get the current zoom and alpha values
		local zoom, dir, ratio = GetMapCameraZoom()
		
		-- zooming if direction hasn't cleared
		return dir ~= 0
	end,
	
	-- update zoom state
	UpdateZoom = function(this)
		-- get the current zoom and alpha values
		local zoom, dir, ratio = GetMapCameraZoom()

		-- generate transparency value
		local alpha
		if zoom == 2 or zoom - dir == 2 then
			if dir > 0 then
				-- zooming in: fade from 1 to 0
				alpha = 0.5 + 0.5 * math.cos(math.pi * ratio)
			elseif dir < 0 then
				-- zooming out: fade from 0 to 1
				alpha = 0.5 - 0.5 * math.cos(math.pi * ratio)
			elseif zoom == 2 then
				-- zoomed in: transparent
				alpha = 0
			else
				-- zoomed out: opaque
				alpha = 1
			end
		else
			-- zoomed out: opaque
			alpha = 1
		end
		
		-- save alpha for rendering
		this.renderAlpha = alpha
				
		-- update visibility
		local visible = alpha > 0
		SetProperty("gal_prp_galaxy", "IsVisible", visible)
--		SetProperty("gal_prp_galaxy_2", "IsVisible", visible)
--		SetProperty("gal_prp_galaxy_3", "IsVisible", visible)
--		SetProperty("gal_prp_grid", "IsVisible", visible)
		
		-- fade out the galaxy
		local color = "255 255 255 " .. 255 * alpha
		SetProperty("gal_prp_galaxy", "GeometryColor", color)
--		SetProperty("gal_prp_galaxy_2", "GeometryColor", color)
--		SetProperty("gal_prp_galaxy_3", "GeometryColor", color)
--		SetProperty("gal_prp_grid", "GeometryColor", color)
		
		-- set planet and system visibility
		for planet, _ in pairs(this.planetTeam) do
			local focus = (zoom == 2 or zoom - dir == 2) and (planet == this.planetSelected)
			SetProperty(planet, "IsVisible", focus)
			SetProperty(planet, "GeometryColor", focus and "255 255 255 255" or color)
			if planet ~= "pol" and planet ~= "dea" then	-- hack!
				local system = planet .. "_system"
				SetProperty(system, "IsVisible", visible)
				SetProperty(system, "GeometryColor", color)
			end
		end
		
		-- set fleet visibility
		for team, list in pairs(this.fleetPtr) do
			for planet, fleet in pairs(list) do
				local focus = (zoom == 2 or zoom - dir == 2) and (planet == this.planetSelected)
				SetProperty(fleet, "IsVisible", focus)
			end
		end
		
		-- set port visibility
		for team, list in pairs(this.portPtr) do
			for planet, port in pairs(list) do
				local focus = (zoom == 2 or zoom - dir == 2) and (planet == this.planetSelected)
				SetProperty(port, "IsVisible", focus)
			end
		end
	end,
	
	-- set zoom level
	-- (0=wide, 1=normal, 2=focus)
	SetZoom = function(this, zoom)
		-- set the map camera zoom
		SetMapCameraZoom(zoom)
		this:UpdateZoom()
	end,

	-- play a voiceover
	PlayVoice = function(this, name)
		-- stop any existing voiceover
		StopAudioStream(this.streamVoice, 0)
		
		-- play the new voiceover
		PlayAudioStreamUsingProperties("sound\\gal.lvl", name, 1)
		
		--print(debug.traceback())
		--print("PlayVoice", name)
	end,
	
	-- prompt for save
    PromptSave = function(this, force)
        print( "ifs_freeform_main: PromptSave()")

		-- if forcing a save...
		if force then
			-- allow force save
			this.requestSave = force
		-- if in soak mode...
		elseif ifs_freeform_main.soakMode then
			-- don't prompt
			return
		end
		-- update dependent zoom
		this:UpdateZoom()
		-- if a save is requested...
		if this.requestSave then
			print("Progress Save")
			-- prompt for save
			ifs_freeform_load.NoPromptSave = nil
			ifs_freeform_load.Mode = "Save"
			ScriptCB_PushScreen("ifs_freeform_load")
			-- clear request
			this.requestSave = nil
			-- prompted
			return true
		else
			-- for each active player...
			for controller, team in pairs(this.controllerTeam) do
				-- if the profile is dirty...
				local iProfileIdx = 1 + controller
				if ScriptCB_IsProfileDirty(iProfileIdx) then
					print("Profile Save", iProfileIdx)
					-- prompt for profile save
					ifs_saveop.doOp = "SaveProfile"
					ifs_saveop.OnSuccess = function() ScriptCB_PopScreen() end
					ifs_saveop.OnCancel = function() ScriptCB_PopScreen() end
					ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
					ifs_saveop.saveProfileNum = iProfileIdx
					ScriptCB_PushScreen("ifs_saveop")
					-- prompted
					return true
				end
			end
		end
		-- no prompt
		return false
	end,
	
	-- draw lanes between planets
	DrawLanes = function(this, start, next, alpha)
		-- default if nothing specified
		start = start or this.planetSelected
		next = next or this.planetNext
		alpha = alpha or this.renderAlpha
		
		-- for each starting planet...
		for planet1, destinations in pairs(this.planetDestination) do
			-- for each potential destination...
			for _, planet2 in ipairs(destinations) do
				if planet1 < planet2 then
					local a = 32
					local shift = 0
					local repetitions = 1
					if planet1 == start or planet2 == start then
						a = 200
						if start ~= next and (planet1 == next or planet2 == next) then
							a = 255
							if planet1 == next then
								shift = 2 * ScriptCB_GetMissionTime()
							else
								shift = -2 * ScriptCB_GetMissionTime()
							end
							shift = shift - math.floor(shift)
							repetitions = 8
						end
					end
					DrawBeamBetween(
						this.planetMatrix[planet1][0],
						this.planetMatrix[planet2][0],
						"lane_selected", 1.0, 255, 255, 255, a * alpha, shift, repetitions
						)
				end
			end
		end
	end,

	-- draw a rollover icon for a planet
	DrawRolloverIcon = function(this, planet, alpha)
		alpha = alpha or this.renderAlpha
		local team = this.planetTeam[planet] or 0
		local matrix = this.planetMatrix[planet][0]
		local r,g,b = this:GetTeamColor(team)
		DrawParticleAt(matrix, "planetgraphic_cursor", 12, r, g, b, 112, 0.0)
	end,
		
	-- draw icons for all planets
	DrawPlanetIcons = function(this, alpha)
		alpha = alpha or this.renderAlpha
		-- draw planet icons
		for planet, _ in pairs(this.planetDestination) do
			local team = this.planetTeam[planet] or 0
			local matrix = this.planetMatrix[planet][0]
			local r,g,b = this:GetTeamColor(team)
			if team ~= 0 then
				DrawParticleAt(matrix, "planetgraphic_halo", 75, r, g, b, 20 * alpha, 0.0)
			else
				DrawParticleAt(matrix, "planetgraphic_halo", 3, r, g, b, 192 * alpha, 0.0)
			end
			if planet == this.planetSelected then
				local size = ScriptCB_GetMissionTime()
				size = size - math.floor(size)
				local a = 224 * (1 - size * size)
				size = 14 * size + 4
				DrawParticleAt(matrix, "planetgraphic_cursor", size, r, g, b, a * alpha, 0.0)
--			elseif team ~= 0 then
--				DrawParticleAt(matrix, "planetgraphic_cursor", 16, r, g, b, 192, 0.0)
			end
			
			if team ~= 0 then
				local base = planet == this.planetBase[team]
				
				local size = base and 24 or 16
				DrawParticleAt(matrix, "star_flare", size, r, g, b, 128 * alpha, 0.0)
				DrawParticleAt(matrix, "star_flare", size * 0.5, 255, 255, 255, 255 * alpha, 0.0)
				
				if base then
					local matrix = this.planetMatrix[planet][3]
					local side = this.teamCode[team]
					DrawParticleAt(matrix, "seal_" .. side, 12, r, g, b, 192 * alpha, 0.0)
				end
			end
		end
	end,
	
	-- draw icon for a single starport
	DrawPortIcon = function(this, planet, team, blink, outline, alpha)
--		alpha = alpha or this.renderAlpha
--		local r,g,b = this:GetTeamColor(team)
--		if blink then
--			local scale = 0.6 + 0.4 * math.sin(2 * math.pi * ScriptCB_GetMissionTime())
--			r = r * scale
--			g = g * scale
--			b = b * scale
--		end
--		local matrix = this.planetMatrix[planet][3]
--		if outline then
--			DrawParticleAt(matrix, this.portStroke[team], 16, r, g, b, 255 * alpha, 0)
--		else
--			DrawParticleAt(matrix, this.portIcon[team], 16, r, g, b, 255 * alpha, 0)
--		end
	end,
	
	-- draw icons for all starports
	DrawPortIcons = function(this, alpha)
--		alpha = alpha or this.renderAlpha
--		for planet, port in pairs(this.portPtr) do
--			local team = this.planetPort[planet]
--			local r,g,b = this:GetTeamColor(team)
--			local matrix = this.planetMatrix[planet][3]
--			DrawParticleAt(matrix, this.portIcon[team], 12, 255, 255, 255, 255 * alpha, 0)
--			DrawParticleAt(matrix, this.portStroke[team], 12, r, g, b, 255 * alpha, 0)
--		end
	end,
	
	-- draw icon for a single fleet
	DrawFleetIcon = function(this, planet, team, blink, outline, alpha)
		alpha = alpha or this.renderAlpha
		local r,g,b = this:GetTeamColor(team)
		if blink then
			local scale = 0.6 + 0.4 * math.sin(2 * math.pi * ScriptCB_GetMissionTime())
			r = r * scale
			g = g * scale
			b = b * scale
		end
		local matrix = this.planetMatrix[planet][team]
		if outline then
			DrawParticleAt(matrix, this.fleetStroke[team], 16, r, g, b, 255 * alpha, 0)
		else
			DrawParticleAt(matrix, this.fleetIcon[team], 16, r, g, b, 255 * alpha, 0)
		end
	end,
	
	-- draw icons for all fleets
	DrawFleetIcons = function(this, selected, blink, alpha)
		alpha = alpha or this.renderAlpha
		for team, list in pairs(this.fleetPtr) do
			for planet, fleet in pairs(list) do
				local r,g,b = this:GetTeamColor(team)
				if planet == selected or team == blink then
					local scale = 0.6 + 0.4 * math.sin(2 * math.pi * ScriptCB_GetMissionTime())
					r = r * scale
					g = g * scale
					b = b * scale
					if planet == selected then
						local white = 255 * (1 - scale)
						r = r + white
						g = g + white
						b = b + white
					end
				end
				local matrix = this.planetMatrix[planet][team]
				DrawParticleAt(matrix, this.fleetStroke[team], 16, r, g, b, 255 * alpha, 0)
				DrawParticleAt(matrix, this.fleetIcon[team], 16, 255, 255, 255, 255 * alpha, 0)
			end
		end
	end,
	
--	-- draw non icon
--	DrawNonIcon = function(this, planet, team, blink, alpha)
--		team = team or 0
--		blink = blink or false
--		alpha = alpha or this.renderAlpha
--		local r,g,b = 165, 60, 60
--		if blink then
--			local scale = 0.6 + 0.4 * math.sin(2 * math.pi * ScriptCB_GetMissionTime())
--			r = r * scale
--			g = g * scale
--			b = b * scale
--		end
--		local matrix = this.planetMatrix[planet][team]
--		DrawParticleAt(matrix, "non", 8, r, g, b, 255 * alpha, 0)
--	end,
	
	-- update the player side and resource display
	UpdatePlayerText = function(this, player)
		if this.joystick then
			IFText_fnSetUString(player.name, ScriptCB_GetProfileName(this.joystick+1))
		else
			IFText_fnSetString(player.name, this.teamName[this.playerTeam])
		end
		IFText_fnSetUString(player.resources,
			ScriptCB_usprintf("ifs.freeform.credits", ScriptCB_tounicode(this:GetResources()))
		)
		IFImage_fnSetTexture(player.icon, "seal_" .. this.playerSide)
		local r, g, b = this:GetTeamColor(this.joystick and this.playerTeam or 3 - this.playerTeam)
		IFObj_fnSetColor(player.icon, r, g, b)
		IFObj_fnSetColor(player.name, r, g, b)
	end,
	
	-- get the next planet based on player input
	UpdateNextPlanet = function(this)
		if not this.joystick then
			return
		end
		
		-- get the left joystick value
		local x, y = ScriptCB_ReadLeftstick(this.joystick)
		
		-- get the joystick magnitude
		local magnitude = x * x + y * y
		
		-- if controller move was registered
		if this.movePressed then
			-- if released...
			if magnitude < 0.01 then
				-- clear moved
				this.movePressed = nil
			end
		else
			-- if pushed sufficiently...
			if magnitude > 0.4096 then
				-- register moved
				this.movePressed = true
			
				-- normalize the direction
				local scale = math.sqrt(magnitude)
				x = x / scale
				y = -y / scale
				
				-- get the starting planet's screen position
				local x0, y0 = GetScreenPosition(this.planetSelected)
				
				-- for each planet...
				local bestscore = 0
				for index, planet in ipairs(this.planetDestination[this.planetSelected]) do
					-- if no fleet is selected, or the destination does not have a friendly fleet...
					if not this.fleetSelected or this.planetFleet[planet] ~= this.playerTeam then
						-- get the planet's screen position
						local x1, y1 = GetScreenPosition(planet)
						
						-- get the normalized direction
						local dx = x1 - x0
						local dy = y1 - y0
						local scale = math.sqrt(dx * dx + dy * dy)
						dx = dx / scale
						dy = dy / scale
						
						-- get the direction score
						local score = x * dx + y * dy
						
						-- update the best planet
						if bestscore < score then
							bestscore = score
							this.planetNext = planet
						end
					end
				end
			end
		end
	end,
	
	-- set victory condition: planet limit
	-- (default to 100% captured plus no enemy fleets remaining)
    SetVictoryPlanetLimit = function(this, limit)
        print("ifs_freeform_main: SetVictoryPlanetLimit()")

		print("SetVictoryPlanetLimit", limit)
		this.CheckVictory = function(this)
			print("CheckVictoryPlanetLimit", limit)
			local checkfleets = false
			if not limit then
				limit = 0
				for planet, team in pairs(this.planetTeam) do
					if team > 0 then
						limit = limit + 1
					end
				end
				checkfleets = true
			end
			local counts = { [1] = 0, [2] = 0 }
			for planet, team in pairs(this.planetTeam) do
				if team > 0 then
					counts[team] = counts[team] + 1
					if counts[team] >= limit then
						if checkfleets then
							for planet, fleet in pairs(this.fleetPtr[3 - team]) do
								return nil
							end
						end
						return team
					end
				end
			end
			return nil
		end
	end,
	
	-- setvictory condition: base capture
    SetVictoryBaseCapture = function(this)
        print( "ifs_freeform_main: SetVictoryBaseCapture()")

		print("SetVictoryBaseCapture")
		this.CheckVictory = function(this)
			print("CheckVictoryBaseCapture")
			if this.planetTeam[this.planetBase[1]] ~= 1 then
				return 2
			elseif this.planetTeam[this.planetBase[2]] ~= 2 then
				return 1
			else
				return nil
			end
		end
	end,
	
	-- set victory condition: resource limit
	-- (default to 1000 RU)
    SetVictoryResourceLimit = function(this, limit)
        print( "ifs_freeform_main: SetVictoryResourceLimit()")

		-- backup victory condition: capture all planets
		print("SetVictoryResourceLimit", limit)
		this:SetVictoryPlanetLimit(nil)
		local CheckTotalVictory = this.CheckVictory
		
		if not limit then
			limit = 1000
		end
		this.CheckVictory = function(this)
			print("CheckVictoryResourceLimit", limit)
			for team, resources in this.teamResources do
				if resources >= limit then
					return team
				end
			end
			return CheckTotalVictory(this)
		end
	end,
	
	-- set victory condition: turn limit
	-- (default to 10 turns)
	-- player with the moSetst planets wins, with resources as a tiebreaker
	SetVictoryTurnLimit = function(this, limit)
		print("SetVictoryTurnLimit", limit)
		-- backup victory condition: capture all planets
		this:SetVictoryPlanetLimit(nil)
		local CheckTotalVictory = this.CheckVictory
		
		if not limit then
			limit = 10
		end
		this.CheckVictory = function(this)
			print("CheckVictoryTurnLimit", limit)
			if this.turnNumber >= limit * 2 then
				local counts = { [1] = 0, [2] = 0 }
				for planet, team in pairs(this.planetTeam) do
					if team > 0 then
						counts[team] = counts[team] + 1
					end
				end
				if counts[1] > counts[2] then
					return 1
				elseif counts[1] < counts[2] then
					return 2
				elseif this.teamResources[1] > this.teamResources[2] then
					return 1
				elseif this.teamResources[1] < this.teamResources[2] then
					return 2
				end
			end
			return CheckTotalVictory(this)
		end
	end,
	
	-- save metagame state
    SaveState = function(this)
        print( "ifs_freeform_main: SaveState()")

		-- what's the current screen?
		if ScriptCB_IsScreenInStack("ifs_freeform_summary") then
			if ScriptCB_IsScreenInStack("ifs_freeform_result") then
				this.curScreen = "summary_result"
			else
				this.curScreen = "summary_fleet"
			end
		elseif ScriptCB_IsScreenInStack("ifs_freeform_result") then
			this.curScreen = "result"
		elseif ScriptCB_IsScreenInStack("ifs_freeform_battle_card") then
			if ifs_freeform_battle_card.defending then
				this.curScreen = "battle_card_2"
			else
				this.curScreen = "battle_card_1"
			end
		elseif ScriptCB_IsScreenInStack("ifs_freeform_battle_mode") then
			this.curScreen = "battle_mode"
		elseif ScriptCB_IsScreenInStack("ifs_freeform_battle") then
			if ScriptCB_IsScreenInStack("ifs_freeform_fleet") then
				this.curScreen = "battle_back"
			else
				this.curScreen = "battle_noback"
			end
		else
			this.curScreen = nil
		end
		
		-- map name to team as a hint
		local profileTeam = {}
		for joystick, team in pairs(this.controllerTeam) do
			local name = ScriptCB_ununicode(ScriptCB_GetProfileName(joystick+1))
			profileTeam[name] = team
		end
		
		-- save values to saved state
		ScriptCB_SaveMetagameState(
			this.custom,
			this.scenario,
			profileTeam,		--this.controllerTeam,
			this.lastSelected,
			this.lastFleet,
			this.planetTeam,
--			this.planetPort,
			this.planetFleet,
			this.planetNext,
			this.teamResources,
			ifs_purchase_unit_owned,
			ifs_purchase_tech_cards,
			ifs_purchase_tech_using,
			this.playerTeam,
			this.turnNumber,
			this.curScreen,
			ifs_freeform_fleet.turnNumber,
			ifs_freeform_fleet.planetStart,
			ifs_freeform_fleet.planetNext,
			this.launchMission,
			this.activeBonus,
			this.winnerTeam,
			this.fleetBattle,
			this.recentPlanets,
			this.planetResources,
			this.battleResources,
			this.soakMode
			)
	end,
	
	-- load metagame state
    LoadState = function(this)
        print("ifs_freeform_main: LoadState()")

		local profileTeam
		local screen
		
		-- load values from saved state
		this.custom,
		this.scenario,
		profileTeam,		--this.controllerTeam,
		this.lastSelected,
		this.lastFleet,
		this.planetTeam,
--		this.planetPort,
		this.planetFleet,
		this.planetNext,
		this.teamResources,
		ifs_purchase_unit_owned,
		ifs_purchase_tech_cards,
		ifs_purchase_tech_using,
		this.playerTeam,
		this.turnNumber,
		this.curScreen,
		ifs_freeform_fleet.turnNumber,
		ifs_freeform_fleet.planetStart,
		ifs_freeform_fleet.planetNext,
		this.launchMission,
		this.activeBonus,
		this.winnerTeam,
		this.fleetBattle,
		this.recentPlanets,
		this.planetResources,
		this.battleResources,
		this.soakMode
		= ScriptCB_LoadMetagameState()
		
		-- create a blank list if empty
		this.recentPlanets = this.recentPlanets or {}
		
		-- if loading a mission... (HACK)
		if ScriptCB_GetLastBattleVictory() < 0 then
			-- set mission name
			if this.launchMission then
				ScriptCB_SetMissionNames(this.launchMission, nil)
			end
		
			-- activate team bonuses
			for team, bonus in pairs(this.activeBonus) do
				ActivateBonus(team, bonus)
			end
		end
		
		-- start appropriate scenario
		local start = _G["ifs_freeform_start_" .. this.scenario]
		if start then
			start(this, this.custom)
		else
			assert("undefined scenario type \""..this.scenario.."\"")
		end
		
		-- discard the unused start function
		this.Start = nil
		
		-- restore profile teams
		local controllerTeam = {}
		for joystick, team in pairs(this.controllerTeam) do
			local name = ScriptCB_ununicode(ScriptCB_GetProfileName(joystick+1))
			local newteam = profileTeam[name]
			print (joystick, team, newteam, name)
			controllerTeam[joystick] = newteam or team
		end
		ifs_freeform_controllers(this, controllerTeam)
	end,
	
    OneTimeInit = function(this, showLoadDisplay)
        print( "ifs_freeform_main: OneTimeInit()")

		-- restore any saved metagame state
		if ScriptCB_IsMetagameStateSaved() then
			this:LoadState()
		end

	
		if not this.planetDestination then
			
			-- set up memory pools (HACK)
			SetMemoryPoolSize("EntitySoundStream", 2)

			SetMemoryPoolSize("ParticleTransformer::PositionTr", 700)
			SetMemoryPoolSize("ParticleTransformer::SizeTransf", 751)
			SetMemoryPoolSize("ParticleTransformer::ColorTrans", 1176)
			
			SetMemoryPoolSize("ParticleEmitterObject", 16)
			SetMemoryPoolSize("ParticleEmitterInfoData", 128)
			SetMemoryPoolSize("ParticleEmitter", 128)

			-- show the load display
			if showLoadDisplay then
				-- stop any streaming
				ScriptCB_StopMovie()
				ScriptCB_CloseMovie()
				ScriptCB_SetShellMusic()
			
				-- do loading
				SetupTempHeap(2 * 1024 * 1024)
				ScriptCB_ShowLoadDisplay(true)
			end
			
			-- load sides
			ifs_purchase_load_data(this.teamCode[1], this.teamCode[2])

			-- read the galaxy map level
			ReadDataFile("gal\\gal1.lvl")
			
			-- read the galaxy map level
			ReadDataFile("sound\\gal.lvl;gal_vo")
			
			this.streamVoice = OpenAudioStream("sound\\gal.lvl",  "gal_vo_slow")
			this.streamMusic = OpenAudioStream("sound\\gal.lvl",  "gal_music")

			ScriptCB_PostLoadHack()

			-- hide the load display
			if showLoadDisplay then
				ScriptCB_ShowLoadDisplay(false)
				ClearTempHeap()
			end	

			-- perform one-time setup
			this:Setup()
			
			-- create empty port array
			this.portPtr = { }
			
			-- create empty fleet array
			this.fleetPtr = { [1] = {}, [2] = {} }
			
			-- create planet, fleet, and port matrices
			this.planetMatrix = {}
			this.modelMatrix = {}
			for planet, _ in pairs(this.planetDestination) do
				local planetMatrix = GetEntityMatrix(planet)
				this.planetMatrix[planet] = {}
				this.planetMatrix[planet][0] = planetMatrix
				this.planetMatrix[planet][1] = CreateMatrix(-2.25, 0.0, 1.0, 0.0, 10.0, 4.0, -8.0, planetMatrix)
				this.planetMatrix[planet][2] = CreateMatrix(2.25, 0.0, 1.0, 0.0, -10.0, 4.0, -8.0, planetMatrix)
				this.planetMatrix[planet][3] = CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 16.0, 0.0, planetMatrix)
				this.modelMatrix[planet] = {}
				this.modelMatrix[planet][1] = GetEntityMatrix(planet .. "_fleet1") or this.planetMatrix[planet][1]
				this.modelMatrix[planet][2] = GetEntityMatrix(planet .. "_fleet2") or this.planetMatrix[planet][2]
			end
			
			-- show side setup screen?
			this.setupSides = (this.custom ~= nil)
			
			-- initialize team colors
			this:InitTeamColor()
		end
	end,
	
    Enter = function(this, bFwd)
        print("ifs_freeform_main: Enter()")

		gIFShellScreenTemplate_fnEnter(this, bFwd)
		
		if bFwd then
			-- stop any playing movie
			ifelem_shellscreen_fnStopMovie()
			
			-- disable split screen
			this.wasSplit = ScriptCB_GetNumCameras()
			ScriptCB_SetSplitscreen(nil)
			
			-- enable metagame rules
			ScriptCB_SetGameRules("metagame")
			
			-- clear out saved screen
			this.curScreen = nil
			
			-- perform one-time init
			-- (does nothing if already loaded)
			this:OneTimeInit(true)
			
			ScriptCB_SetShellMusic("metagame_menu_music")
			
			-- set build screens to campaign mode	
			ifs_freeform_purchase_unit:SetFreeformMode()
			ifs_freeform_purchase_tech:SetFreeformMode()
			
			-- if metagame state was saved...
			if ScriptCB_IsMetagameStateSaved() then
				-- set the active team
				this:SetActiveTeam(this.playerTeam)
			else
				-- set initial state
				this:Start()
				
				-- get selected planet and fleet for each side
				this.lastSelected = {}
				this.lastFleet = {}
				for planet, team in pairs(this.planetFleet) do
					if team > 0 then
						this.lastSelected[team] = planet
						this.lastFleet[team] = planet
					end
				end
				for team, planet in pairs(this.planetBase) do
					if not this.lastSelected[team] then
						this.lastSelected[team] = planet
					end
				end
				
				-- set the active team to that of the starting controller
				this:SetActiveTeam(this.controllerTeam[this.startController])
				this.planetNext = this.lastSelected[this.playerTeam]
				
				-- clear state
				this.launchMission = nil
				this.activeBonus = {}
				this.recentPlanets = {}
			end
			
			-- if the last battle had a winner...
			local winner = ScriptCB_GetLastBattleVictory()
			if this.soakMode and ScriptCB_IsMetagameStateSaved() then
				winner = math.random(2)
			end
			if winner > 0 then
				-- apply battle results
				this:ApplyBattleResult(this.planetNext, winner)
			
				-- clear battle result
				ScriptCB_SetLastBattleVictoryValid(false)
				
				-- go to the result screen
				ScriptCB_PushScreen("ifs_freeform_result")
				
				-- trigger save request on next turn
				this.requestSave = true
				
			-- if setting up sides...
			elseif this.setupSides then
			
				-- go to the side setup screen
				ScriptCB_PushScreen("ifs_freeform_sides")
				
			-- otherwise...
			else
			
				-- go to the saved screen
				if this.curScreen == "summary_result" then
					ScriptCB_PushScreen("ifs_freeform_result")
					ScriptCB_PushScreen("ifs_freeform_summary")
				elseif this.curScreen == "summary_fleet" then
					ScriptCB_PushScreen("ifs_freeform_fleet")
					ScriptCB_PushScreen("ifs_freeform_summary")
				elseif this.curScreen == "result" then
					ScriptCB_PushScreen("ifs_freeform_result")
				elseif this.curScreen == "battle_card_2" then
					ifs_freeform_battle_card.defending = 1
					ScriptCB_PushScreen("ifs_freeform_battle")
					ScriptCB_PushScreen("ifs_freeform_battle_mode")
					ScriptCB_PushScreen("ifs_freeform_battle_card")
				elseif this.curScreen == "battle_card_1" then
					ifs_freeform_battle_card.defending = nil
					ScriptCB_PushScreen("ifs_freeform_battle")
					ScriptCB_PushScreen("ifs_freeform_battle_mode")
					ScriptCB_PushScreen("ifs_freeform_battle_card")
				elseif this.curScreen == "battle_mode" then
					ScriptCB_PushScreen("ifs_freeform_battle")
					ScriptCB_PushScreen("ifs_freeform_battle_mode")
				elseif this.curScreen == "battle_back" then
					ScriptCB_PushScreen("ifs_freeform_fleet")
					ScriptCB_PushScreen("ifs_freeform_battle")
				elseif this.curScreen == "battle_noback" then
					ScriptCB_PushScreen("ifs_freeform_battle")
				-- if the team has a human player...
				elseif this.joystick then
					-- go to the fleet screen
					ScriptCB_PushScreen("ifs_freeform_fleet")
				else
					-- go to ai move
					ScriptCB_PushScreen("ifs_freeform_ai")
				end
				
			end
			
			-- set up build screen
			ifs_purchase_build_screen()
			
			-- initialize ai state (HACK)
			ifs_freeform_ai:Init()			
			
--			-- create port entities (HACK)
--			for planet, port in pairs(this.portPtr) do
--				DeleteEntity(port)
--			end
--			this.portPtr = { }
--			for planet, team in pairs(this.planetPort) do
--				this.portPtr[planet] = CreateEntity(this.portClass[team], this.modelMatrix[planet][3])
--			end
			
			-- create fleet entities (HACK)
			for team, list in pairs(this.fleetPtr) do
				for planet, fleet in pairs(list) do
					DeleteEntity(fleet)
				end
			end
			this.fleetPtr = { [1] = {}, [2] = {} }
			for planet, team in pairs(this.planetFleet) do
				if team == 0 then
					this.fleetPtr[1][planet] = CreateEntity(this.fleetClass[1], this.modelMatrix[planet][1])
					this.fleetPtr[2][planet] = CreateEntity(this.fleetClass[2], this.modelMatrix[planet][2])
				else
					this.fleetPtr[team][planet] = CreateEntity(this.fleetClass[team], this.modelMatrix[planet][team])
				end
			end

			-- select the initial planet
			this:SelectPlanet(nil, this.planetNext)
			
			-- set camera offset for each zoom level
			SetMapCameraOffset(0, 0, 200, 480)
			SetMapCameraPitch(0, -0.05)
			SetMapCameraOffset(1, 0, 100, 150)
			SetMapCameraPitch(1, -0.025)
			
			-- enable the 3D scene
			ScriptCB_EnableScene(true)
		end
	end,

    Exit = function(this, bFwd)
        print( "ifs_freeform_main: Exit()")

--		gIFShellScreenTemplate_fnExit(this)
		
		if not bFwd then
			-- clear active controller
			ScriptCB_SetHotController(nil)
			
			-- disable metagame rules
			ScriptCB_SetGameRules("instantaction")
			
			-- disable the 3D scene
			ScriptCB_EnableScene(false)
			
			-- restore split screen
			ScriptCB_SetSplitscreen(this.wasSplit)
			this.wasSplit = nil
			
			-- re-open the shell movie stream
			ScriptCB_OpenMovie(gMovieStream, "")		
		end
	end,
}

function ifs_freeform_AddCommonElements(this)
	local w,h = ScriptCB_GetSafeScreenInfo()
	local screen_w, screen_h, v, widescreen = ScriptCB_GetScreenInfo()
	
	local bar_h = screen_h * (gPlatformStr == "PC" and 0.09375 or 0.125)
	
	local title_w = w * 0.2
	local title_h = ScriptCB_GetFontHeight("gamefont_medium")

	this.title = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.0, -- top
		ZPos = 185,
		UseSafezone = gPlatformStr == "PC" and 0,
		
		text = NewIFText {
			y = gPlatformStr == "PC" and (bar_h - title_h - gButtonHeightPad * 0.5) or yTop,
			font = "gamefont_medium", 
			textw = title_w * 1.5, 
			texth = title_h, 
			halign = "hcenter",
			valign = "bottom",
		
			bgleft = "bf2_buttons_topleft",
			bgmid = "bf2_buttons_title_center",
			bgright = "bf2_buttons_topright",
			bg_width = title_w * 1.25, 
			startdelay = 0.0,
			bgoffsetx = 0,
			bgexpandx = 0,
			bgexpandy = gButtonHeightPad * 0.5, -- exe doubles this, grr
			ColorR = 255,
			ColorG = 255,
			ColorB = 255,
			textcolorr = gTitleTextColor[1],
			textcolorg = gTitleTextColor[2],
			textcolorb = gTitleTextColor[3],
			alpha = gTitleTextAlpha,
			bInertPos = 1,
		}
	}
	
	local player_w = w * .5
	local r, g, b = ifs_freeform_main:GetCreditsColor(true)
	
	this.player = NewIFContainer {
		ScreenRelativeX = 0.5, -- left
		ScreenRelativeY = gPlatformStr == "PC" and 0.0 or 0.15, -- top
		width = player_w,
		ZPos = 190,
		UseSafezone = gPlatformStr == "PC" and 0,
		y = gPlatformStr == "PC" and bar_h + gButtonHeightPad * 0.5,
		
		icon = NewIFImage { 
			ColorR = 255, ColorG = 255, ColorB = 255, alpha = 0.7,
			localpos_l = -16,
			localpos_t = 0,
			localpos_r = 16,
			localpos_b = 32,
			inert = 1,
		},
		
		name = NewIFText {
			font = "gamefont_medium",
			ColorR = 255, ColorG = 255, ColorB = 255, alpha = 0.7,
			textw = w*0.5,
			halign = "right",
			valign = "vcenter",
			x = -(w * 0.5) - 18,
			y = 0,
			nocreatebackground = 1
		},
		
		resources = NewIFText {
			font = "gamefont_medium",
			textcolorr = r,
			textcolorg = g,
			textcolorb = b,
			alpha = gTitleTextAlpha,
			textw = w,
			halign = "left",
			valign = "vcenter",		
			x = 20,
			y = 0,
			nocreatebackground = 1
		}
	}	

	this.letterbox_top = NewIFImage {
		ScreenRelativeX = 0.0, --left
		ScreenRelativeY = 0.0, --top
		texture = "blank_icon",
		ZPos = 200,
		UseSafezone = 0,	
			
		texture = "blank_icon",
		ColorR = 0, ColorG = 0, ColorB = 0, 
		localpos_l = 0,
		localpos_t = 0,
		localpos_r = screen_w*widescreen,
		localpos_b = bar_h,
		inert = 1,
	}
	
	this.letterbox_bottom = NewIFImage {
		ScreenRelativeX = 0.0, --left
		ScreenRelativeY = 1.0, --bottom
		texture = "blank_icon",
		ZPos = 200,
		UseSafezone = 0,	
			
		texture = "blank_icon",
		ColorR = 0, ColorG = 0, ColorB = 0, 
		localpos_l = 0,
		localpos_t = -bar_h,
		localpos_r = screen_w*widescreen,
		localpos_b = 0,
		inert = 1,
	}		
		
	
	local info_w = w * widescreen * 0.95
	local info_text_h = gPlatformStr == "PC" and h * 0.1 or h * 0.2
	local info_caption_h = ScriptCB_GetFontHeight("gamefont_small")
	local info_h = info_text_h + info_caption_h + 5
	
	this.info = NewButtonWindow {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.9, -- bottom
		width = info_w + 32,
		height = info_h + 32,
		y = -0.5 * (info_h + 32),
		ZPos = 195,
		UseSafezone = gPlatformStr == "PC" and 0,
		
		caption = NewIFText {
			x = -info_w * 0.5,
			y = -info_h * 0.5,
			font = "gamefont_small",
			textcolorr = gUnselectedTextColor[1],
			textcolorg = gUnselectedTextColor[2],
			textcolorb = gUnselectedTextColor[3],
			alpha = gUnselectedTextAlpha,
			textw = info_w,
			texth = info_caption_h,
			halign = "left",
			valign = "top",
			nocreatebackground = 1
		},
		
		subcaption = NewIFText {
			x = -info_w * 0.5,
			y = -info_h * 0.5,
			font = "gamefont_small",
			textcolorr = gUnselectedTextColor[1],
			textcolorg = gUnselectedTextColor[2],
			textcolorb = gUnselectedTextColor[3],
			textw = info_w,
			texth = info_caption_h,
			halign = "right",
			valign = "top",
			nocreatebackground = 1
		},
		
		text = NewIFText {
			x = -info_w * 0.5,
			y = -info_h * 0.5 + info_caption_h + 5,
			font = "gamefont_tiny",
			textcolorr = gUnselectedTextColor[1],
			textcolorg = gUnselectedTextColor[2],
			textcolorb = gUnselectedTextColor[3],
			alpha = gUnselectedTextAlpha,
			halign = "left",
			valign = "top",
			flashy = 0,
			textw = info_w,
			texth = info_text_h,
		},
	}
	
	local action_w = w
	local action_h = h * 0.05
	
	if(gPlatformStr == "PC") then
		local BackButtonW = 150	-- made wider to fix 9173 - NM 8/25/04
		local BackButtonH = 25
		
		local left = BackButtonW * 0.5
		local right = w - BackButtonW * 0.5
		local spacing = (right - left) / 3
		
		this.action = NewIFContainer{
			ScreenRelativeX = 0.0, -- left
			ScreenRelativeY = 1.0, -- bottom
			width = action_w,
			height = action_h,
			x = 0,
			ZPos = 190,
		
			misc = NewPCIFButton -- NewRoundIFButton				
			{
				x = right - spacing,
				btnw = BackButtonW,
				btnh = BackButtonH,
				font = "gamefont_medium", 
				string = "ifs.freeform.endturn",
				tag = "_next",
			}, -- end of btn
			
			accept = NewPCIFButton -- NewRoundIFButton			
			{
				x = right,
				btnw = BackButtonW,
				btnh = BackButtonH,
				font = "gamefont_medium", 
				string = "common.accept",
				tag = "_accept",
				
			}, -- end of btn

			back = NewPCIFButton -- NewRoundIFButton
			{
				x = left,
				btnw = BackButtonW,
				btnh = BackButtonH,
				font = "gamefont_medium", 
				string = "common.back",
				tag = "_back",
				
			}, -- end of btn
			
			help = NewPCIFButton
			{
				x = left + spacing,
				btnw = BackButtonW,
				btnh = BackButtonH,
				font = "gamefont_medium", 
				string = "ifs.freeform.help",
				tag = "_help",
			},
		}
	else
		this.action = NewIFContainer{
			ScreenRelativeX = 0.0, -- left
			ScreenRelativeY = 1.0, -- bottom
			width = action_w,
			height = action_h * 2,
			ZPos = 190,

			misc = NewHelptext {
				x = w*widescreen,
				buttonicon = "btnmisc",
				string = "ifs.freeform.endturn",
				bRightJustify = 1,
				y = -34, 
			},

			
			accept = NewHelptext {
				x = w*widescreen,
				buttonicon = "btna",
				string = "common.accept",
				bRightJustify = 1,
				y = -15, 
			},
			
			back = NewHelptext {
				x = 0,
				buttonicon = "btnb",
				string = "common.back",
				bLeftJustify = 1,
				y = -15, 
			},
			
			help = NewHelptext {
				x = 0,
				buttonicon = "btnmisc2",
				string = "ifs.freeform.help",
				bLeftJustify = 1,
				y = -34,  
			},
		}
	end	
end

function ifs_freeform_AddTabElements(this)
	local w,h = ScriptCB_GetSafeScreenInfo()
	
	local tab_w = w * 0.3
	local icon_w = w * 0.05
	local bar_h = h * .1
	local title_h = h * 0.1 - 1
	
	if(gPlatformStr == "PC") then
	
		-- Add tabs to screen
		ifelem_tabmanager_Create(this, ifs_freeform_tab_layout)
		
	else

		this.tableft = NewIFContainer {
			ScreenRelativeX = 0.0, -- left
			ScreenRelativeY = 0.0, -- top
			ZPos = 190,
					
			text = NewIFText {
				ZPos = 175,
				font = "gamefont_small",
				textw = tab_w,
				texth = title_h,
				halign = "hcenter",
				valign = "bottom",
				x = icon_w,
				y = yTop,
				
				bgleft = "bf2_buttons_botleft",
				bgmid = "bf2_buttons_items_center",
				bgright = "bf2_buttons_botright",
				bg_flipped = 1,
				bg_width = title_w, 
				startdelay = 0.0,
				bgoffsetx = 0,
				bgexpandx = 0,
				bgexpandy = gButtonHeightPad * 0.5, -- exe doubles this, grr
				ColorR = 255,
				ColorG = 255,
				ColorB = 255,
				textcolorr = gUnselectedTextColor[1],
				textcolorg = gUnselectedTextColor[2],
				textcolorb = gUnselectedTextColor[3],
				alpha = gUnselectedTextAlpha,
				bInertPos = 1
			},
			
			button = NewIFImage {
				ZPos = 175,
				texture = "btnl1", 
				localpos_l = 0,
				localpos_t = bar_h - 32,
				localpos_r = 32,
				localpos_b = bar_h,
				inert = 1,
			}
		}
			
		this.tabright = NewIFContainer {
			ScreenRelativeX = 1.0, -- right
			ScreenRelativeY = 0.0, -- top
			ZPos = 190,
					
			text = NewIFText {
				ZPos = 188,
				font = "gamefont_small",
				ColorR = 189,
	            ColorG = 208,
	            ColorB = 242,
				textw = tab_w,
				texth = title_h,
				halign = "hcenter",
				valign = "bottom",
				x = - tab_w - icon_w,
				y = yTop,
				
				bgleft = "bf2_buttons_botleft",
				bgmid = "bf2_buttons_items_center",
				bgright = "bf2_buttons_botright",
				bg_flipped = 1,
				bg_width = title_w, 
				startdelay = 0.0,
				bgoffsetx = 0,
				bgexpandx = 0,
				bgexpandy = gButtonHeightPad * 0.5, -- exe doubles this, grr
				ColorR = 255,
				ColorG = 255,
				ColorB = 255,
				textcolorr = gUnselectedTextColor[1],
				textcolorg = gUnselectedTextColor[2],
				textcolorb = gUnselectedTextColor[3],
				alpha = gUnselectedTextAlpha,
				bInertPos = 1
				
			},
			
			button = NewIFImage {	
				ZPos = 188,
				texture = "btnr1", 
				localpos_l = -32,
				localpos_t = bar_h -32,
				localpos_r = 0,
				localpos_b = bar_h,
				inert = 1,
			}		
		}
	end	
end

function ifs_freeform_SetButtonVis(this, button_name, visible)
--	if(gPlatformStr == "PC") then
		IFObj_fnSetVis( this.action[button_name], visible )
--	else
--		IFObj_fnSetVis(this.action[button_name].text, visible)
--		IFObj_fnSetVis(this.action[button_name].icon, visible)			
--	end
end

function ifs_freeform_SetButtonName(this, button_name, new_name)
	if(gPlatformStr == "PC") then
		RoundIFButtonLabel_fnSetString( this.action[button_name], new_name )
	else
		IFText_fnSetString(this.action[button_name].helpstr, new_name)
	end
end

AddIFScreen(ifs_freeform_main,"ifs_freeform_main")

