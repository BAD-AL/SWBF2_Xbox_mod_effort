
ifs_campaign_main = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,

	GetResources = ifs_freeform_main.GetResources,
	AddResources = ifs_freeform_main.AddResources,
	EnoughResources = ifs_freeform_main.EnoughResources,
	SpendResources = ifs_freeform_main.SpendResources,
	SelectPlanet = ifs_freeform_main.SelectPlanet,
	SetActiveTeam = ifs_freeform_main.SetActiveTeam,
	InitTeamColor = ifs_freeform_main.InitTeamColor,
	GetTeamColor = ifs_freeform_main.GetTeamColor,
	GetCreditsColor = ifs_freeform_main.GetCreditsColor,
	
	-- draw icons for all planets
	DrawPlanetIcons = function(this)
		local alpha = this.renderAlpha
		
		-- draw planet icons		
		for planet, team in pairs(this.planetTeam) do
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
				local a = 112 * (1 - size * size)
				size = 28 * size + 4
				DrawParticleAt(matrix, "planetgraphic_cursor", size, r, g, b, a, 0.0)
--			elseif team ~= 0 then
--				DrawParticleAt(matrix, "planetgraphic_cursor", 16, r, g, b, 96, 0.0)
			end
			
			if team ~= 0 then
				DrawParticleAt(matrix, "star_flare", 16, r, g, b, 128, 0.0)
				DrawParticleAt(matrix, "star_flare", 8, 255, 255, 255, 255, 0.0)
			end
		end
	end,
	
	-- draw fleet movement
	DrawFleetMove = function(this, planet, next, team)
		local alpha = this.renderAlpha
		local r,g,b = this:GetTeamColor(team)
		local scale = 0.6 + 0.4 * math.sin(2 * math.pi * ScriptCB_GetMissionTime())
		r = r * scale
		g = g * scale
		b = b * scale
		
		-- draw the starting location
		local matrix = this.planetMatrix[planet][team]
		DrawParticleAt(matrix, this.fleetStroke[team], 16, r, g, b, 255 * alpha, 0)
		DrawParticleAt(matrix, this.fleetIcon[team], 16, 255, 255, 255, 255 * alpha, 0)
		
		-- if moving somewhere new...
		if planet ~= next then
			-- draw the destination
			local matrix = this.planetMatrix[next][team]
			DrawParticleAt(matrix, this.fleetStroke[team], 16, r, g, b, 255 * alpha, 0)
			
			-- draw beam to destination
			local shift = -2 * ScriptCB_GetMissionTime()
			shift = shift - math.floor(shift)
			repetitions = 8
			DrawBeamBetween(
				ifs_campaign_main.planetMatrix[planet][0],
				ifs_campaign_main.planetMatrix[next][0],
				"lane_selected", 1.0, 255, 255, 255, 255 * alpha, shift, repetitions
				)
		end
	end,
	
	UpdatePlayerText = ifs_freeform_main.UpdatePlayerText,
	
	-- set zoom level
	-- (0=wide, 1=normal, 2=focus)
	SetZoom = function(this, zoom)
		-- set the map camera zoom
		SetMapCameraZoom(zoom)
		this:UpdateZoom()
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
  		for _, mission in ipairs(ifs_campaign_mission) do
  			local planet = mission.planet
			local focus = (zoom == 2 or zoom - dir == 2) and (planet == this.planetSelected)
			SetProperty(planet, "IsVisible", focus)
			SetProperty(planet, "GeometryColor", focus and "255 255 255 255" or color)
			if planet ~= "pol" and planet ~= "dea" then	-- hack!
				local system = planet .. "_system"
				SetProperty(system, "IsVisible", visible)
				SetProperty(system, "GeometryColor", color)
			end
  		end
  	end,
  	
	PlayVoice = ifs_freeform_main.PlayVoice,

	-- prompt for save
	PromptSave = function(this, force)
		-- allow force save
		this.requestSave = force or this.requestSave
		-- update dependent zoom
		this:UpdateZoom()
		-- if a save is requested...
		if this.requestSave then
			print("Progress Save")
			-- prompt for save
			ifs_campaign_load.NoPromptSave = nil
			ifs_campaign_load.Mode = "Save"
			ScriptCB_PushScreen("ifs_campaign_load")
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

	-- initialize campaign state	
	InitState = function(this)
		this.teamResources = { [1] = 50 }
		this.teamItems = { [1] = { soldier = true, pilot = true } }
		this.turnNumber = 1
		ScriptCB_PushScreen("ifs_campaign_turn_intro")
	end,
	
	-- save campaign state
	SaveState = function(this)
--		-- what's the current screen?
--		if ScriptCB_IsScreenInStack("ifs_campaign_result") then
--			this.curScreen = "result"
--		elseif ScriptCB_IsScreenInStack("ifs_campaign_battle") then
--			this.curScreen = "battle"
--		else
--			this.curScreen = "overview"
--		end
		
		-- save values to saved state
		ScriptCB_SaveCampaignState(
			this.teamResources,
			this.teamItems,
			this.turnNumber,
			ifs_purchase_unit_owned[1],
			ifs_purchase_tech_cards[1],
			ifs_purchase_tech_using[1]
--			this.curScreen,
--			ifs_campaign_result.lost
			)
	end,
	
	-- load campaign state
	LoadState = function(this)
		-- load values from saved state
		this.teamResources,
		this.teamItems,
		this.turnNumber,
		ifs_purchase_unit_owned[1],
		ifs_purchase_tech_cards[1],
		ifs_purchase_tech_using[1]
--		this.curScreen,
--		ifs_campaign_result.lost
		= ScriptCB_LoadCampaignState()
	end,
	
	ApplyBattleResult = function(this, winner)
		if winner == 1 then
			-- apply battle results
			if ifs_campaign_mission[this.turnNumber].space then
				this.teamResources[1] = this.teamResources[1] + 20 + 5 * this.turnNumber
			else
				this.teamResources[1] = this.teamResources[1] + 40 + 5 * this.turnNumber
			end
			
--			ifs_campaign_result.lost = nil
			
			-- go to the next turn
			ifs_campaign_main:NextTurn(true)
		else
--			ifs_campaign_result.lost = true
			
			-- go back to the battle screen
			ScriptCB_PushScreen("ifs_campaign_battle")
		end
			
--		-- go to the result screen
--		ScriptCB_PushScreen("ifs_campaign_result")
			
		-- clear battle result
		ScriptCB_SetLastBattleVictoryValid(false)
		
		-- trigger save request on next turn
		this.requestSave = true
	end,
	
	ApplyTurn = function(this, turn)
		-- update unit, technology, and planet lists so far
		for i=this.turnNumber,turn do
			local mission = ifs_campaign_mission[i]
			if not mission then
				return false
			end
			
--			-- apply any unit changes for this mission
--			if mission.unit then
--				for type, unit in pairs(mission.unit) do
--					ifs_purchase_unit_table[type] = ifs_purchase_unit_table[type] or {}
--					for key, value in pairs(unit) do
--						ifs_purchase_unit_table[type][key] = value
--					end
--				end
--			end
--			-- apply any tech changes for this mission
--			if mission.tech then
--				for _, tech in ipairs(mission.tech) do
--					local duplicate = false
--					for _, desc in ipairs(ifs_purchase_tech_table) do
--						if desc.name == tech then
--							duplicate = true
--							break
--						end
--					end
--					if not duplicate then 
--						for _, desc in ipairs(ifs_purchase_tech_table_freeform) do
--							if desc.name == tech then
--								table.insert(ifs_purchase_tech_table, desc)
--								break
--							end
--						end
--					end
--				end
--			end
			-- set planet teams
			if i == turn then
				-- save team sides
				this.teamCode = {
					[1] = mission.side,
					[2] = mission.enemy
				}
				
				-- associate names with teams
				this.teamName = {
					[1] = "common.sides."..mission.side..".name",
					[2] = "common.sides."..mission.enemy..".name"
				}
				
				-- associate names with team fleets
				this.fleetName = {
					[1] = "ifs.freeform.fleet."..mission.side,
					[2] = "ifs.freeform.fleet."..mission.enemy
				}
				
				-- associate entity class with team fleets
				this.fleetClass = {
					[1] = ifs_campaign_fleet[mission.side],
					[2] = ifs_campaign_fleet[mission.enemy]
				}
				
				-- associate icon textures with team fleets
				this.fleetIcon = {
					[1] = mission.side.."_fleet_normal_icon",
					[2] = mission.enemy.."_fleet_normal_icon"
				}
				this.fleetStroke = {
					[1] = mission.side.."_fleet_normal_stroke",
					[2] = mission.enemy.."_fleet_normal_stroke"
				}
				
				-- set player team
				this.playerTeam = 1
				this.playerSide = this.teamCode[1]
				
				-- set up the planet
				this.planetTeam[mission.planet] = 2
				this:SelectPlanet(nil, mission.planet)
			else
				this.planetTeam[mission.planet] = 1
				this.planetPrev = mission.planet
			end
		end
		
		-- update the turn number
		this.turnNumber = turn
		
		return true
	end,
	
	NextTurn = function(this, init)
		if not init then
			-- clear the screen stack
			ScriptCB_PopScreen("ifs_campaign_main")
		end
		
		-- advance to the next turn
		if this:ApplyTurn(this.turnNumber+1) then

--			-- update dependent values
--			ifs_freeform_purchase_unit:SetActiveSide()
			
			-- go to the turn intro screen
			ScriptCB_PushScreen("ifs_campaign_turn_intro")
		else
		
			-- go to the end screen
			ScriptCB_PushScreen("ifs_campaign_end")
			
		end
	end,
	
	OneTimeInit = function(this, showLoadDisplay)
		-- initialize
		ifs_freeform_init_common(this)
		
		-- force co-op
		ifs_freeform_controllers(this, { [0] = 1, [1] = 1, [2] = 1, [3] = 1 })
		
		-- save the active controller
		this.joystick = this.teamController[1]	
	
		-- if this is the first time...
		if not this.isLoaded then
			this.isLoaded = true
					
			-- set up memory pools (HACK)
			SetMemoryPoolSize("EntitySoundStream", 2)

			SetMemoryPoolSize("ParticleTransformer::PositionTr", 700)
			SetMemoryPoolSize("ParticleTransformer::SizeTransf", 751)
			SetMemoryPoolSize("ParticleTransformer::ColorTrans", 1176)

			if showLoadDisplay then
				-- stop any streaming
				ScriptCB_StopMovie()
				ScriptCB_CloseMovie()
				ScriptCB_SetShellMusic()

				-- do loading
				SetupTempHeap(2 * 1024 * 1024)

				-- show the load display
				ScriptCB_ShowLoadDisplay(true)
			end

--				-- load sides
--				ifs_purchase_load_data("rep", "imp")
			ReadDataFile("inshell.lvl")

			-- read the galaxy map level
			ReadDataFile("gal\\gal1.lvl")
			
			-- read the galaxy map level
			ReadDataFile("sound\\gal.lvl;gal_vo")
							
			this.streamVoice = OpenAudioStream("sound\\gal.lvl",  "gal_vo_slow")
			this.streamMusic = OpenAudioStream("sound\\gal.lvl",  "gal_music")

			ScriptCB_PostLoadHack()

			if showLoadDisplay then
				-- hide the load display
				ScriptCB_ShowLoadDisplay(false)
				
				ClearTempHeap()
			end
			
			-- create planet, fleet, and port matrices
			this.planetMatrix = {}
			this.modelMatrix = {}
			for _, mission in ipairs(ifs_campaign_mission) do
				local planet = mission.planet
				local planetMatrix = GetEntityMatrix(planet)
				this.planetMatrix[planet] = {}
				this.planetMatrix[planet][0] = planetMatrix
				this.planetMatrix[planet][1] = CreateMatrix(-2.25, 0.0, 1.0, 0.0, 10.0, 4.0, -8.0, planetMatrix)
				this.planetMatrix[planet][2] = CreateMatrix(2.25, 0.0, 1.0, 0.0, -10.0, 4.0, -8.0, planetMatrix)
				this.modelMatrix[planet] = {}
				this.modelMatrix[planet][1] = GetEntityMatrix(planet .. "_fleet1") or this.planetMatrix[planet][1]
				this.modelMatrix[planet][2] = GetEntityMatrix(planet .. "_fleet2") or this.planetMatrix[planet][2]
			end
			
			-- init team colors
			this:InitTeamColor()
		end
	end,
	
	Enter = function(this, bFwd)
		if bFwd then
			-- stop any playing movie
			ifelem_shellscreen_fnStopMovie()
			
			-- disable split screen
			this.wasSplit = ScriptCB_GetNumCameras()
			ScriptCB_SetSplitscreen(nil)
			
			-- enable campaign rules
			ScriptCB_SetGameRules("campaign")
			
--			-- clear out saved screen
--			this.curScreen = nil
					
			-- perform one-time init
			-- (does nothing if already loaded)
			this:OneTimeInit(true)
							
			this.shellMusic = "metagame_menu_music"		
			ScriptCB_SetShellMusic(this.shellMusic)
			
--			-- set build screens to campaign mode	
--			ifs_freeform_purchase_unit:SetCampaignMode()
--			ifs_freeform_purchase_tech:SetCampaignMode()
			
			-- load campaign state
			if ScriptCB_IsCampaignStateSaved() then
				this:LoadState()
			else
				this:InitState()
			end

			-- create empty fleet array
			this.fleetPtr = { [1] = {} }
				
			-- update unit, technology, and planet lists so far
			local turn = this.turnNumber
			this.turnNumber = 1
			this.planetTeam = {}
			this:ApplyTurn(turn)

--			-- set up build screen
--			ifs_purchase_build_screen()
			
			-- if the last battle had a winner...
			local winner = ScriptCB_GetLastBattleVictory()
			if winner > 0 then
				-- apply the battle result
				this:ApplyBattleResult(winner)
			elseif ScriptCB_IsCampaignStateSaved() then
				-- restore saved screen
--				if this.curScreen == "result" then
--					ScriptCB_PushScreen("ifs_campaign_result")
--				elseif this.curScreen == "battle" then
--					if this.turnNumber > 1 and ifs_campaign_mission[this.turnNumber - 1].planet ~= ifs_campaign_mission[this.turnNumber].planet then
--						ScriptCB_PushScreen("ifs_campaign_overview")
--					end
					ScriptCB_PushScreen("ifs_campaign_battle")
--				else
--					ScriptCB_PushScreen("ifs_campaign_overview")
--				end
			end
			
			-- set camera offset for each zoom level
			SetMapCameraOffset(0, 0, 325, 575)
			SetMapCameraPitch(0, -0.05)
			SetMapCameraOffset(1, 0, 100, 150)
			SetMapCameraPitch(1, -0.025)
			
			-- enable the 3D scene
			ScriptCB_EnableScene(true)
		end
	end,
	
	Exit = function(this, bFwd)
		if not bFwd then
			-- clear active controller
			ScriptCB_SetHotController(nil)
			
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

AddIFScreen(ifs_campaign_main,"ifs_campaign_main")
