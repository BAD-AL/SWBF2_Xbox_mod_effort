--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_freeform_fleet_cost = { [0] = 0, [1] = 100, [2] = 200, [3] = 300, [4] = 400, [5] = 500, [6] = 600, [7] = 700, [8] = 800, [9] = 900, [10] = 1000, [11] = 1100, [12] = 1200, [13] = 1300 }

ifs_fleet_entry_sound = "mtg_%s_fleet_select"
ifs_fleet_move_sound = "mtg_%s_fleet_move"
ifs_fleet_cancel_sound = "mtg_%s_fleet_cancel_move"
ifs_fleet_blocked_sound = "mtg_%s_fleet_cannot_move_us"
ifs_purchase_fleet_bought_fleet_sound = "mtg_%s_fleet_bought_us"
ifs_purchase_fleet_blocked_fleet_sound = "mtg_%s_fleet_cannot_build_us"
ifs_purchase_fleet_broke_fleet_sound = "mtg_%s_fleet_broke_us"

ifs_freeform_fleet = NewIFShellScreen {
    nologo = 1,
    movieIntro      = nil,
    movieBackground = nil,
    bNohelptext_accept = 1,
    bNohelptext_back = 1,
    bNohelptext_backPC = 1,

    GetSuggestedMove = function(this, team, planet)
        -- use the AI to calculate weights
        ifs_freeform_ai:CalculateWeights(team)
        
        -- get weighted move values
        local moveWeight = {}
        local totalWeight = 0
        local reference = ifs_freeform_ai.planetValue[planet]
        for _, destination in ipairs(ifs_freeform_main.planetDestination[planet]) do
            if ifs_freeform_main.planetFleet[destination] ~= team then
                local weight = math.pow(2, ifs_freeform_ai.planetValue[destination] - reference)
                moveWeight[destination] = weight
                totalWeight = totalWeight + weight
            end
        end
        
        -- get a random move
        local randomWeight = math.random() * totalWeight
        
        -- for each possible move...
        for move, weight in pairs(moveWeight) do
            -- deduct the move's weight
            randomWeight = randomWeight - weight
            
            -- if this move is the selected one...
            if randomWeight <= 0 then
                -- return the destination
                return move
            end
        end
        
        -- no move (wah!)
        return planet
    end,
    
    -- is this a valid build?
    IsValidBuild = function(this, team, planet)
        return ifs_freeform_main.planetTeam[planet] == team
    end,
    
    -- build a fleet
    BuildFleet = function(this, team, planet)
        if this:IsValidBuild(team, planet) and ifs_freeform_main:SpendResources(team, this.fleetCost) then
            ifs_freeform_main:CreateFleet(team, planet)
            this:UpdateFleetCost()
            return true
        end
    end,
    
    -- calculate fleet cost
    UpdateFleetCost = function(this)
        -- count fleets
        local fleets = 0
        for planet, fleet in pairs(ifs_freeform_main.planetFleet) do
            if fleet == ifs_freeform_main.playerTeam then
                fleets = fleets + 1
            end
        end
        this.fleetCost = ifs_freeform_fleet_cost[fleets]
    end,
    
    SelectFleet = function(this, team, planet)
        -- if the planet has a friendly fleet...
        if ifs_freeform_main.planetFleet[planet] == team then
            -- select the fleet
            this.fleetSelected = planet
            ifs_freeform_main.lastFleet[team] = planet
            -- pick a default destination using AI code
            ifs_freeform_main:SelectPlanet(this.info, planet)
            ifs_freeform_main.planetNext = this:GetSuggestedMove(team, planet)
            return true
        end
        return false
    end,
    
    DeselectFleet = function(this)
        this.fleetSelected = nil
    end,
    
    IsValidMove = function(this, team, start, next)
        -- check if the next location is valid...
        local valid = false
        for _, destination in ipairs(ifs_freeform_main.planetDestination[start]) do
            if next == destination then
                valid = true
                break
            end
        end
        if not valid then
            return false
        end
        
        -- check if the next location is blocked
        if ifs_freeform_main.planetFleet[next] == team then
            return false
        end
        
        -- the move is valid
        return true
    end,
    
    AttemptMove = function(this, team, start, next)
        -- fail invalid move
        if not this:IsValidMove(team, start, next) then
            return false
        end
        
        -- move the fleet
        ifs_freeform_main:MoveFleet(team, start, next)

        -- select the planet
        ifs_freeform_main:SelectPlanet(this.info, next)

        -- save the fleet's move
        this.turnNumber = ifs_freeform_main.turnNumber
        this.planetStart = start
        this.planetNext = next

        -- if the destination planet is an enemy, or there is a fleet battle...
        if ifs_freeform_main.planetTeam[next] == 3 - team or
            ifs_freeform_main.planetFleet[next] == 0 then

            -- jump to the battle screen
            this.nextScreen = "ifs_freeform_battle"
        else
            -- go to the summary page
            this.nextScreen = "ifs_freeform_summary"
        end

        -- start the display timer timer
        this.displayTimer = 1.0

        -- deselect the fleet
        this:DeselectFleet()
        
        return true
    end,
    
    AttemptUndo = function(this, team)
        if not this.turnNumber or this.turnNumber ~= ifs_freeform_main.turnNumber then
            return false
        end
        
        -- reverse the fleet's move
        ifs_freeform_main:MoveFleet(team, this.planetNext, this.planetStart)
        ifs_freeform_main:SelectPlanet(this.info, this.planetStart)

        -- clean up undo
        this.turnNumber = nil
        this.planetStart = nil
        this.planetNext = nil
        
        return true
    end,
    
    UpdateAction = function(this)
        local team = ifs_freeform_main.playerTeam
        local selected = ifs_freeform_main.planetSelected
        local next = ifs_freeform_main.planetNext

        this.buildFleet = nil       

		-- get planet info
        ifs_freeform_main:UpdatePlanetInfo(this.info)
        
        -- if there is a selected fleet...
        if this.fleetSelected then
            -- if the fleet is moving...
            if ifs_freeform_main.planetNext ~= ifs_freeform_main.planetSelected then
                ifs_freeform_SetButtonVis(this, "accept", 1)
                ifs_freeform_SetButtonName(this, "accept", "ifs.freeform.fleet.move")
            else
                ifs_freeform_SetButtonVis(this, "accept", nil)
            end
            
            ifs_freeform_SetButtonVis(this, "back", 1)
            ifs_freeform_SetButtonName(this, "back", "ifs.freeform.fleet.deselect" )
            
            if ifs_freeform_main.planetTeam[next] then
                IFObj_fnSetVis(this.info, true)
                IFObj_fnSetVis(this.info.caption, true)
                IFText_fnSetString(this.info.caption, "planetname." .. next)
                IFObj_fnSetColor(this.info.caption, ifs_freeform_main:GetTeamColor(ifs_freeform_main.planetTeam[next]))
                IFObj_fnSetAlpha(this.info.caption, gTitleTextAlpha)         
            else
                IFObj_fnSetVis(this.info, false)
                IFObj_fnSetVis(this.info.caption, false)
            end
            
            IFObj_fnSetVis(this.info.subcaption, nil)
        else
            -- if the planet has a friendly fleet...
            if ifs_freeform_main.planetFleet[selected] == team then
                ifs_freeform_SetButtonVis(this, "accept", 1)
                if ifs_freeform_main.planetTeam[selected] then
                    IFObj_fnSetVis(this.info, true)
                    IFObj_fnSetVis(this.info.caption, true)
                    IFObj_fnSetVis(this.info.subcaption, false)
                    IFObj_fnSetColor(this.info.caption, ifs_freeform_main:GetTeamColor(ifs_freeform_main.planetTeam[selected]))
                    IFObj_fnSetAlpha(this.info.caption, gTitleTextAlpha)
                    IFText_fnSetString(this.info.caption, "planetname." .. selected)
                else
                    IFObj_fnSetVis(this.info, false)
                    IFObj_fnSetVis(this.info.caption, false)
                    IFObj_fnSetVis(this.info.subcaption, false)
                end
                ifs_freeform_SetButtonName(this, "accept", "ifs.freeform.fleet.select")
            -- if this is a valid build location...
            elseif this:IsValidBuild(team, selected) then
                -- build a fleet                
                IFObj_fnSetVis(this.info, true)
                IFObj_fnSetVis(this.info.caption, true)
                IFObj_fnSetVis(this.info.subcaption, true)
                ifs_freeform_SetButtonVis(this, "accept", 1)                    
                
                IFText_fnSetUString(this.info.caption,
                    ScriptCB_usprintf("ifs.freeform.fleet.build",
                        ScriptCB_getlocalizestr("planetname." .. selected)
                    )               
                )
                IFText_fnSetUString(this.info.subcaption,
                    ScriptCB_usprintf("ifs.freeform.credits", ScriptCB_tounicode(this.fleetCost))
                )
                
                IFText_fnSetString(this.info.text, "ifs.freeform.fleet.desc")
        
                ifs_freeform_SetButtonName(this, "accept", "ifs.freeform.purchase.navy.fleet")

				local enough = ifs_freeform_main:EnoughResources(team, this.fleetCost)
				local r, g, b = ifs_freeform_main:GetCreditsColor(enough)
				local a = gTitleTextAlpha
				local accept_a = enough and 1.0 or 0.3
                IFObj_fnSetColor(this.info.caption, r, g, b)
                IFObj_fnSetAlpha(this.info.caption, a)
                IFObj_fnSetColor(this.info.subcaption, r, g, b)
                IFObj_fnSetAlpha(this.info.subcaption, a)
                IFObj_fnSetAlpha(this.action.accept, accept_a)
				this.buildFleet = enough
            else
                -- cannot build here
                ifs_freeform_SetButtonVis(this, "accept", nil)
                if ifs_freeform_main.planetTeam[selected] then
                    IFObj_fnSetVis(this.info, true)
                    IFObj_fnSetVis(this.info.caption, true)
                    IFObj_fnSetColor(this.info.caption, ifs_freeform_main:GetTeamColor(ifs_freeform_main.planetTeam[selected]))
                    IFObj_fnSetAlpha(this.info.caption, gTitleTextAlpha)
                    IFText_fnSetString(this.info.caption, "planetname." .. selected)
                else
                    IFObj_fnSetVis(this.info, false)
                    IFObj_fnSetVis(this.info.caption, false)
                end
                IFObj_fnSetVis(this.info.subcaption, false)
            end
            
            ifs_freeform_SetButtonVis(this, "back", nil)
        end

        ifs_freeform_SetButtonName(this, "misc", "ifs.freeform.skip")
    end,

    Enter = function(this, bFwd)
        gIFShellScreenTemplate_fnEnter(this, bFwd)

        ifs_freeform_main:PlayVoice(string.format(ifs_fleet_entry_sound, ifs_freeform_main.playerSide))
        
        -- get the active team
        local team = ifs_freeform_main.playerTeam
            
        -- if backing into this page after a fleet move...
        local didUndo = false
        if not bFwd then
            -- reverse the fleet's move
            didUndo = this:AttemptUndo(team)
        elseif not this.turnNumber or this.turnNumber ~= ifs_freeform_main.turnNumber then
            this.fleetSelected = nil
            this.turnNumber = nil
            this.planetStart = nil
            this.planetNext = nil
        end
        
        IFText_fnSetString(this.title.text, "ifs.freeform.navigation.move")

        if bFwd or didUndo then
            -- pick a fleet if none set
            if not ifs_freeform_main.lastFleet[team] then
                -- if the selected planet has a fleet...
                local selected = ifs_freeform_main.planetSelected
                if selected and ifs_freeform_main.planetFleet[selected] == team then
                    -- use the fleet on the selected planet
                    ifs_freeform_main.lastFleet[team] = selected
                else
                    -- pick another fleet
                    for planet, fleet in pairs(ifs_freeform_main.fleetPtr[team]) do
                        ifs_freeform_main.lastFleet[team] = planet
                        break
                    end
                end
            end
            
            -- select the last-used fleet
            this:SelectFleet(team, ifs_freeform_main.lastFleet[team])
        elseif not this.fleetSelected then
            -- re-center on selected planet
            ifs_freeform_main.planetNext = ifs_freeform_main.planetSelected
        end
        
        IFObj_fnSetVis(this.info.caption, 1)
        IFText_fnSetString(this.info.caption, "ifs.freeform.purchase.navy.fleetname")
                
        -- update tabs
        if (gPlatformStr == "PC") then
            ifelem_tabmanager_SelectTabGroup(this, true)
            ifelem_tabmanager_SetSelected(this, ifs_freeform_tab_layout, "_tab_fleet")
            ifelem_tabmanager_SetDimmed(this, ifs_freeform_tab_layout, "_tab_bonus", not ifs_freeform_purchase_tech:CanEnter())
            ifelem_tabmanager_SetDimmed(this, ifs_freeform_tab_layout, "_tab_units", not ifs_freeform_purchase_unit:CanEnter())
        else
            IFText_fnSetString(this.tableft.text, "ifs.freeform.navigation.bonus")
            IFObj_fnSetVis(this.tableft, ifs_freeform_purchase_tech:CanEnter() and 1 or nil)        
            IFText_fnSetString(this.tabright.text, "ifs.freeform.navigation.units")
            IFObj_fnSetVis(this.tabright, ifs_freeform_purchase_unit:CanEnter() and 1 or nil)
        end
        
        ifs_freeform_main:UpdatePlayerText(this.player)

        this:UpdateFleetCost()
        this:UpdateAction()

        -- default to mid-zoom
        this.zoomLevel = 1

		if (gPlatformStr == "PC") then
			-- no scroll yet
			this.scrollX = 0
			this.scrollZ = 0
			
			-- establish boundary
			this.scrollMinX = 0
			this.scrollMinZ = 0
			this.scrollMaxX = 0
			this.scrollMaxZ = 0
			for planet, _ in pairs(ifs_freeform_main.planetDestination) do
				local x, y, z = GetWorldPosition(planet)
				if this.scrollMinX > x then this.scrollMinX = x end
				if this.scrollMaxX < x then this.scrollMaxX = x end
				if this.scrollMinZ > z then this.scrollMinZ = z end
				if this.scrollMaxZ < z then this.scrollMaxZ = z end
			end
		end
		
		-- set the camera zoom
		ifs_freeform_main:SetZoom(this.zoomLevel)
            
		-- prompt for save if necessary
		ifs_freeform_main:PromptSave()
        
        -- clear mouse state
		this.lastDoubleClickTime = nil
		this.bDoubleClicked = nil
    end,

    Exit = function(this, bFwd)
--      gIFShellScreenTemplate_fnExit(this)
    end,

	Input_KeyDown = function(this, iKey)
		if iKey == 8 then
			-- backspace -> back
			this.CurButton = "_back"
			this:Input_Accept(-1)
		elseif iKey == 10 or iKey == 13 then
			-- enter -> accept
			this.CurButton = "_accept"
			this:Input_Accept(-1)
		elseif iKey == 32 then
			-- space -> next
			this.CurButton = "_next"
			this:Input_Accept(-1)
		elseif iKey == -59 then
			-- F1 -> help
			this.CurButton = "_help"
			this:Input_Accept(-1)
		elseif iKey == 9 then
			-- tab -> next tab
			ScriptCB_SetIFScreen("ifs_freeform_purchase_tech")
		elseif iKey == 45 or iKey == 95 then
			-- '-' or '_' -> zoom out
			this:Input_LTrigger2()
		elseif iKey == 43 or iKey == 61 then
			-- '+' or '=' -> zoom in
			this:Input_RTrigger2()
		end
	end,
	
	Input_DPadUp = function(this, joystick)
		this:Input_RTrigger2(joystick)
	end,
	
	Input_DPadDown = function(this, joystick)
		this:Input_LTrigger2(joystick)
	end,
	
    Input_LTrigger2 = function(this, joystick)
        if this.zoomLevel > 0 then
            -- zoom out
            this.zoomLevel = this.zoomLevel - 1
            ifs_freeform_main:SetZoom(this.zoomLevel)
            ---ScriptCB_SndPlaySound("meta_zoom_out");
        end
    end,

    Input_RTrigger2 = function(this, joystick)
        if this.zoomLevel < 1 then
            -- zoom in
            this.zoomLevel = this.zoomLevel + 1
            ifs_freeform_main:SetZoom(this.zoomLevel)
            ScriptCB_SndPlaySound("meta_zoom_in");
        else
            -- focus on the selected planet
            ScriptCB_PushScreen("ifs_freeform_focus")
            ScriptCB_SndPlaySound("meta_zoom_in");
        end
    end,

    Input_Accept = function(this, joystick)
        if(gPlatformStr == "PC") then
            if ifelem_tabmanager_HandleInputAccept(this, ifs_freeform_tab_layout) then
                return
            end
            --print( "this.CurButton = ", this.CurButton )
            if( this.CurButton == "_accept" ) then
                -- fall through
            elseif( this.CurButton == "_back" ) then
                -- handle in Input_Back
                this:Input_Back(joystick)
                return
            elseif( this.CurButton == "_help" ) then
				-- handle in Input_Misc2
				this:Input_Misc2(joystick)
				return
            elseif( this.CurButton == "_next" ) then
				if not this.displayTimer then
                    -- go to next screen
	                ScriptCB_PushScreen("ifs_freeform_summary")
	            end
                return
            else
                print ("Click", this.planetRollover)
                
                -- don't do anything if not clicking on a planet
                if not this.planetRollover then
                    return
                end
                
                -- if a fleet is selected...
                if this.fleetSelected then
                    -- if not a valid move...
                    if not this:IsValidMove(ifs_freeform_main.playerTeam, ifs_freeform_main.planetSelected, this.planetRollover) then
                        -- don't select
                        ifelm_shellscreen_fnPlaySound(this.errorSound)
                        return
                    end
                end
                
				if ifs_freeform_main.planetNext ~= this.planetRollover then
					-- use the clicked planet
					ifs_freeform_main.planetNext = this.planetRollover
					
					-- clear double-click
					this.bDoubleClicked = nil
					this.lastDoubleClickTime = nil
				end
                
				-- play the next name sound
				ifs_freeform_main:PlayVoice(string.format(ifs_planet_name_sound, ifs_freeform_main.playerSide, ifs_freeform_main.planetNext))

				-- don't perform click action if moving to a new planet                
				if not this.fleetSelected and ifs_freeform_main.planetSelected ~= ifs_freeform_main.planetNext then
					this:UpdateAction()
					return
				end
				
				-- check double click
				if( this.lastDoubleClickTime and ScriptCB_GetMissionTime()<this.lastDoubleClickTime+0.4 ) then
					this.bDoubleClicked = 1
				else
					this.lastDoubleClickTime = ScriptCB_GetMissionTime()
				end
				if( this.bDoubleClicked == 1 ) then
					this.bDoubleClicked = nil
					-- fake accept button
					this.CurButton = "_accept"
				end
            end
        end

        -- If base class handled this work, then we're done
        if(gShellScreen_fnDefaultInputAccept(this)) then
            return
        end     

        if this.displayTimer then
            this.displayTimer = 0.0
            return
        end
        
        ifelm_shellscreen_fnPlaySound(this.acceptSound)
        
        -- get the active team
        local team = ifs_freeform_main.playerTeam

        -- get the starting planet
        local start = ifs_freeform_main.planetSelected
        
        -- if there is a selected fleet...
        if this.fleetSelected then
            if gPlatformStr ~= "PC" or this.CurButton == "_accept" then
                -- get the next planet
                local next = ifs_freeform_main.planetNext
            
                -- attempt a move
                if not this:AttemptMove(team, start, next) then
                    -- complain about failure
                    ifs_freeform_main:PlayVoice(string.format(ifs_fleet_blocked_sound, ifs_freeform_main.playerSide))
                end
            end            
        -- else try to select a fleet
        elseif this:SelectFleet(team, start) then
            ifs_freeform_main:PlayVoice(string.format(ifs_fleet_move_sound, ifs_freeform_main.playerSide))
        
        -- try to build a fleet (checks for resources)
        -- first check if this is your planet...
        elseif this:IsValidBuild(team, start) then         
            if gPlatformStr ~= "PC" or this.CurButton == "_accept" then
                if this:BuildFleet(team, start) then
                    ifs_freeform_main:PlayVoice(string.format(ifs_purchase_fleet_bought_fleet_sound, ifs_freeform_main.playerSide))
                else
                    ifs_freeform_main:PlayVoice(string.format(ifs_purchase_fleet_broke_fleet_sound, ifs_freeform_main.playerSide))
                end
            end
        else
            ifelm_shellscreen_fnPlaySound(this.cancelSound)
        end             
            
        ifs_freeform_main:UpdatePlayerText(this.player)
        this:UpdateAction()
    end, --input_accept 

    Input_Back = function(this, joystick)
        if this.fleetSelected then
            this.fleetSelected = nil
            ifelm_shellscreen_fnPlaySound(this.cancelSound)
            ifs_freeform_main.lastFleet[ifs_freeform_main.playerTeam] = nil
            ifs_freeform_main.planetNext = ifs_freeform_main.planetSelected
            ifs_freeform_main:PlayVoice(string.format(ifs_fleet_cancel_sound, ifs_freeform_main.playerSide))
	        this:UpdateAction()
        elseif this.displayTimer then
            this.displayTimer = nil
            this:AttemptUndo(ifs_freeform_main.playerTeam)
        end
        this:UpdateAction()
    end,

    Input_Misc = function(this, joystick)
        if(gPlatformStr ~= "PC") then
            -- go to the next screen
			if this.displayTimer then
				return
			end
            ifelm_shellscreen_fnPlaySound(this.acceptSound)
            ScriptCB_PushScreen("ifs_freeform_summary")
        else
            -- if right click on PC then deselect
            this:Input_Back(joystick)
        end
    end,
    
    Input_Misc2 = function(this, joystick)
        if this.displayTimer then
            return
        end
        -- show the tutorial pop-up
        Popup_Tutorial.textList = {
            "ifs.freeform.tutorial.1",
            "ifs.freeform.tutorial.2",
            "ifs.freeform.tutorial.3",
            "ifs.freeform.tutorial.4",
            "ifs.freeform.tutorial.5",
            "ifs.freeform.tutorial.6",
            "ifs.freeform.tutorial.7"
            }
        Popup_Tutorial:fnActivate(1)
    end,
    
    Input_LTrigger = function(this, joystick)
        if this.displayTimer then
            return
        end
		if(gPlatformStr == "PC") then
			return
		end
        if ifs_freeform_purchase_tech:CanEnter() then
            -- go to the Bonus Purchase Screen
            ifelm_shellscreen_fnPlaySound(this.acceptSound)
            ScriptCB_PushScreen("ifs_freeform_purchase_tech")
        end
    end,
    
    Input_RTrigger = function(this, joystick)
        if this.displayTimer then
            return
        end
		if(gPlatformStr == "PC") then
			return
		end
        if ifs_freeform_purchase_unit:CanEnter() then
            -- go to the Unit purchase Screen
            ifelm_shellscreen_fnPlaySound(this.acceptSound)
            ScriptCB_PushScreen("ifs_freeform_purchase_unit")
        end
    end,
    
    Input_Start = function(this, joystick)
        if this.displayTimer then
            return
        end
        -- open pause menu
        ScriptCB_PushScreen("ifs_freeform_menu")
    end,

    HandleMouse = function(this, x, y)
        gIFShellScreenTemplate_fnHandleMouse(this, x, y)
        
        if this.displayTimer then
            return
        end
        
        -- check for planet rollover
        this.planetRollover = nil
        for planet, _ in pairs(ifs_freeform_main.planetDestination) do
            local x1, y1 = GetScreenPosition(planet)
            local dx = x1 - x
            local dy = y1 - y
            if dx*dx+dy*dy<400 then
                this.planetRollover = planet
            end
        end
        
        -- check for edge push
        local screen_w, screen_h, v, widescreen = ScriptCB_GetScreenInfo()
        if x <= 0 then
			this.scrollX = -1
		elseif x >= screen_w * widescreen - 1 then
			this.scrollX = 1
		else
			this.scrollX = 0
		end
        if y <= 0 then
			this.scrollZ = -1
		elseif y >= screen_h - 1 then
			this.scrollZ = 1
		else
			this.scrollZ = 0
		end
    end,
    
    Update = function(this, fDt)
        gIFShellScreenTemplate_fnUpdate(this, fDt) -- call base class
        
        -- update zoom values
        ifs_freeform_main:UpdateZoom()

        -- if displaying the move...
        if this.displayTimer then
            -- count down the timer
            this.displayTimer = this.displayTimer - fDt

            -- if the timer elapses...
            if this.displayTimer <= 0 then
                -- go to the next screen
                ScriptCB_PushScreen(this.nextScreen)
                this.displayTimer = nil
                this.nextScreen = nil
            end
        else
            -- save the current location
            local planetOld = ifs_freeform_main.planetNext

            --don't move around the galaxy if the tutorial popup is up!
            if(not ScriptCB_IsPopupOpen()) then
                if (gPlatformStr ~= "PC") then
					-- allow continuous push with a fleet selectd
					if this.fleetSelected then
						ifs_freeform_main.movePressed = nil
					end

                    -- update the next planet
                    ifs_freeform_main:UpdateNextPlanet()
                    
                elseif this.scrollX ~= 0 or this.scrollZ ~= 0 then
					local x, y, z = GetMapCameraPosition()
					x = x + this.scrollX * 100 * fDt
					z = z + this.scrollZ * 100 * fDt
					if x < this.scrollMinX then x = this.scrollMinX end
					if x > this.scrollMaxX then x = this.scrollMaxX end
					if z < this.scrollMinZ then z = this.scrollMinZ end
					if z > this.scrollMaxZ then z = this.scrollMaxZ end
					SetMapCameraPosition(x, y, z)
                    SnapMapCamera()
                end
            end

            -- get the next planet
            local next = ifs_freeform_main.planetNext
            
            -- if moving to an "important" next...
            if next ~= planetOld and ifs_freeform_main.planetTeam[next] and ifs_freeform_main.planetTeam[next] > 0 then
                -- play the next name sound
                ifs_freeform_main:PlayVoice(string.format(ifs_planet_name_sound, ifs_freeform_main.playerSide, next))
            end
            
            -- if no fleet is selected...
            if not this.fleetSelected then
                -- select the new planet
                ifs_freeform_main:SelectPlanet(this.info, next)
                this:UpdateAction()
            end
            
            local playerTeam = ifs_freeform_main.playerTeam
            local start = ifs_freeform_main.planetSelected
        
            -- if a fleet is selected...
            if this.fleetSelected then
                -- if moving...
                if next ~= start then
                    -- draw a move-fleet icon
                    ifs_freeform_main:DrawFleetIcon(next, playerTeam, true, true)
                end
                
--                -- if not a valid move...
--                if not this:IsValidMove(playerTeam, start, next) then
--                  -- can't move here
--                  ifs_freeform_main:DrawNonIcon(next, playerTeam, true)
--                end
            else
                -- draw available build
                if this.buildFleet then
                    ifs_freeform_main:DrawFleetIcon(start, playerTeam, true, true)
                end
                
--                -- if the planet is not owned...
--                if ifs_freeform_main.planetFleet[start] ~= playerTeam and ifs_freeform_main.planetTeam[start] ~= playerTeam then
--                  -- can't build here
--                  ifs_freeform_main:DrawNonIcon(next, playerTeam, true)
--                end
            end
            
            -- if the planet changed...
            if ifs_freeform_main.planetNext ~= planetOld then
                ifelm_shellscreen_fnPlaySound(this.selectSound)
                this:UpdateAction()
            end
        end

        -- get the player team
        local playerTeam = ifs_freeform_main.playerTeam

        -- draw rollover icon if any        
        if this.planetRollover then
            ifs_freeform_main:DrawRolloverIcon(this.planetRollover)
        end

        -- draw lanes
        ifs_freeform_main:DrawLanes()

        -- draw planet icons
        ifs_freeform_main:DrawPlanetIcons()

--      -- draw port icons
--      ifs_freeform_main:DrawPortIcons(playerTeam)

        -- draw fleet icons
        ifs_freeform_main:DrawFleetIcons(this.fleetSelected, playerTeam)
    end
}

ifs_freeform_AddCommonElements(ifs_freeform_fleet)
ifs_freeform_AddTabElements(ifs_freeform_fleet)
AddIFScreen(ifs_freeform_fleet,"ifs_freeform_fleet")
