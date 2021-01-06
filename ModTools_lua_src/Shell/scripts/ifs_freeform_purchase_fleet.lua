--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
ifs_freeform_port_cost = { [0] = 40, [1] = 60, [2] = 80, [3] = 100 }

--ifs_purchase_fleet_entry_sound = "mtg_%s_fleet_select_build"
--ifs_purchase_fleet_bought_port_sound = "mtg_%s_port_bought_us"
--ifs_purchase_fleet_bought_fleet_sound = "mtg_%s_fleet_bought_us"
--ifs_purchase_fleet_blocked_port_sound = "mtg_%s_port_cannot_build_us"
--ifs_purchase_fleet_blocked_fleet_sound = "mtg_%s_fleet_cannot_build_us"
--ifs_purchase_fleet_broke_port_sound = "mtg_%s_port_broke_us"
--ifs_purchase_fleet_broke_fleet_sound = "mtg_%s_fleet_broke_us"

ifs_freeform_purchase_fleet = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,

	lastDoubleClickTime = nil,
	bDoubleClicked = nil,

	-- calculate port cost
	UpdatePortCost = function(this)
		-- count ports
		local ports = 0
		for planet, port in pairs(ifs_freeform_main.planetPort) do
			if port == ifs_freeform_main.playerTeam then
				ports = ports + 1
			end
		end
		this.portCost = ifs_freeform_port_cost[ports]
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

	-- build a port
	BuildPort = function(this, team, planet)
		if ifs_freeform_main:SpendResources(team, this.portCost) then
			ifs_freeform_main:CreatePort(team, planet)
			this:UpdatePortCost()
			return true
		end
	end,

	-- build a fleet
	BuildFleet = function(this, team, planet)
		if ifs_freeform_main:SpendResources(team, this.fleetCost) then
			ifs_freeform_main:CreateFleet(team, planet)
			this:UpdateFleetCost()
			return true
		end
	end,

	UpdateAction = function(this)
		local team = ifs_freeform_main.playerTeam
		local selected = ifs_freeform_main.planetSelected
		
		this.buildPort = nil
		this.buildFleet = nil

		-- if the planet is not friendly...
		if ifs_freeform_main.planetTeam[selected] ~= team then
			-- no action
			ifs_freeform_SetButtonName(this, "accept", "ifs.freeform.purchase.navy.build")
			IFObj_fnSetAlpha(this.action.accept, 0.5)
			IFText_fnSetString(this.info.caption, "ifs.freeform.purchase.navy.nobuild")
			IFObj_fnSetColor(this.info.caption, 255, 255, 255)
			IFObj_fnSetVis(this.info.subcaption, nil)
		-- else if the planet has no port...
		elseif ifs_freeform_main.planetPort[selected] ~= team then
			-- build a port
			IFText_fnSetString(this.info.caption, "ifs.freeform.purchase.navy.portname")
			IFObj_fnSetVis(this.info.subcaption, 1)
			
			IFText_fnSetUString(this.info.subcaption,
				ScriptCB_usprintf("ifs.freeform.credits", ScriptCB_tounicode(this.portCost))
			)	
			
			ifs_freeform_SetButtonName(this, "accept", "ifs.freeform.purchase.navy.port")
			
			if ifs_freeform_main:EnoughResources(team, this.portCost) then
				IFObj_fnSetAlpha(this.action.accept, 1.0)
				IFObj_fnSetColor(this.info.caption, 255, 255, 32)
				IFObj_fnSetColor(this.info.subcaption, 255, 255, 32)
				this.buildPort = true
			else
				IFObj_fnSetAlpha(this.action.accept, 0.5)
				IFObj_fnSetColor(this.info.caption, 255, 32, 32)
				IFObj_fnSetColor(this.info.subcaption, 255, 32, 32)
			end
		-- else if the planet has no fleet...
		elseif ifs_freeform_main.planetFleet[selected] ~= team then
			-- build a fleet
			IFText_fnSetString(this.info.caption, "ifs.freeform.purchase.navy.fleetname")
			IFObj_fnSetVis(this.info.subcaption, 1)
			
			IFText_fnSetUString(this.info.subcaption,
				ScriptCB_usprintf("ifs.freeform.credits", ScriptCB_tounicode(this.fleetCost))
			)
			
			ifs_freeform_SetButtonName(this, "accept", "ifs.freeform.purchase.navy.fleet")
			
			if ifs_freeform_main:EnoughResources(team, this.fleetCost) then
				IFObj_fnSetAlpha(this.action.accept, 1.0)
				IFObj_fnSetColor(this.info.caption, 255, 255, 32)
				IFObj_fnSetColor(this.info.subcaption, 255, 255, 32)
				this.buildFleet = true
			else
				IFObj_fnSetAlpha(this.action.accept, 0.5)
				IFObj_fnSetColor(this.info.caption, 255, 32, 32)
				IFObj_fnSetColor(this.info.subcaption, 255, 32, 32)
			end
		else
			-- no action
			ifs_freeform_SetButtonName(this, "accept", "ifs.freeform.purchase.navy.build")
			
			IFObj_fnSetAlpha(this.action.accept, 0.5)
			IFText_fnSetString(this.info.caption, "ifs.freeform.purchase.navy.nobuild")
			IFObj_fnSetColor(this.info.caption, 255, 255, 255)
			
		end

		ifs_freeform_SetButtonName(this, "back", "common.back")
		ifs_freeform_SetButtonName(this, "misc", "ifs.freeform.endturn")
	end,

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		ifs_freeform_main:PlayVoice(string.format(ifs_purchase_fleet_entry_sound, ifs_freeform_main.playerSide))
		
		IFText_fnSetString(this.title.text, "ifs.freeform.purchase.navy.name")
		
--		IFObj_fnSetColor(this.navigation.pad.build, 160, 240, 250)

		ifs_freeform_main:UpdatePlayerText(this.player)
		ifs_freeform_main:UpdatePlanetInfo(this.info)
		
		this:UpdatePortCost()
		this:UpdateFleetCost()
		this:UpdateAction()

		-- default to high-zoom
		this.zoomLevel = 0

		-- set the camera zoom
		ifs_freeform_main:SetZoom(this.zoomLevel)
	end,

	Exit = function(this, bFwd)
--		gIFShellScreenTemplate_fnExit(this)
	end,

	Input_LTrigger = function(this, joystick)
		if this.zoomLevel > 0 then
			-- zoom out
			this.zoomLevel = this.zoomLevel - 1
			ifs_freeform_main:SetZoom(this.zoomLevel)
		end
	end,

	Input_RTrigger = function(this, joystick)
		if this.zoomLevel < 1 then
			-- zoom in
			this.zoomLevel = this.zoomLevel + 1
			ifs_freeform_main:SetZoom(this.zoomLevel)
		end
	end,

	Input_Accept = function(this, joystick)
		if(gPlatformStr == "PC") then
			--print( "this.CurButton = ", this.CurButton )
			if( this.CurButton == "_accept" ) then
				-- purchase the item
			elseif( this.CurButton == "_back" ) then
				-- handle in Input_Back
			elseif( this.CurButton == "_next" ) then
				-- go to end
				ScriptCB_PushScreen("ifs_freeform_summary")
			else
				-- check double click
				if( this.lastDoubleClickTime and ScriptCB_GetMissionTime()<this.lastDoubleClickTime+0.4 ) then
					this.bDoubleClicked = 1
				else
					this.lastDoubleClickTime = ScriptCB_GetMissionTime()
				end
				if( this.bDoubleClicked == 1 ) then
					this.bDoubleClicked = 0
				else
					return
				end			
			end
		end
		
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		-- get the active team
		local team = ifs_freeform_main.playerTeam

		-- get the active planet
		local selected = ifs_freeform_main.planetSelected

		-- if the planet is friendly...
		if ifs_freeform_main.planetTeam[selected] == team then
			-- if the planet has no port...
			if ifs_freeform_main.planetPort[selected] ~= team then
				-- build a port (checks for resources)
				if this:BuildPort(team, selected) then
					ifs_freeform_main:PlayVoice(string.format(ifs_purchase_fleet_bought_port_sound, ifs_freeform_main.playerSide))
				else
					ifs_freeform_main:PlayVoice(string.format(ifs_purchase_fleet_broke_port_sound, ifs_freeform_main.playerSide))
				end
			-- else if the planet has no fleet...
			elseif ifs_freeform_main.planetFleet[selected] ~= team then
				-- build a fleet (checks for resources)
				if this:BuildFleet(team, selected) then
					ifs_freeform_main:PlayVoice(string.format(ifs_purchase_fleet_bought_fleet_sound, ifs_freeform_main.playerSide))
				else
					ifs_freeform_main:PlayVoice(string.format(ifs_purchase_fleet_broke_fleet_sound, ifs_freeform_main.playerSide))
				end
			else
				ifs_freeform_main:PlayVoice(string.format(ifs_purchase_fleet_blocked_fleet_sound, ifs_freeform_main.playerSide))
			end

			ifs_freeform_main:UpdatePlayerText(this.player)
			ifs_freeform_main:UpdatePlanetInfo(this.info)
			this:UpdateAction()
		else
			ifs_freeform_main:PlayVoice(string.format(ifs_purchase_fleet_blocked_port_sound, ifs_freeform_main.playerSide))
		end

	end,

	Input_Back = function(this, joystick)
		-- go 'back' to Movement screen
		ScriptCB_PopScreen();
		ScriptCB_PushScreen("ifs_freeform_fleet")
	end,

	Input_Misc = function(this, joystick)
		if(gPlatformStr ~= "PC") then
			-- go to end
			ScriptCB_PushScreen("ifs_freeform_summary")
		end
	end,
	
	Input_DPadRight = function(this, joystick)
		-- go to the Unit Purchase Screen
		ScriptCB_PopScreen();
		ScriptCB_PushScreen("ifs_freeform_purchase_unit")		
	end,
	
	Input_DPadDown = function(this, joystick)
		-- go to the Movement Screen
		ScriptCB_PopScreen();
--		ScriptCB_PushScreen("ifs_freeform_fleet")		
	end,
	
	Input_DPadLeft = function(this, joystick)
		-- go to the Bonus Purchase Screen
		ScriptCB_PopScreen();
		ScriptCB_PushScreen("ifs_freeform_purchase_tech")		
	end,
	
	Input_DPadUp = function(this, joystick)
	end,

	Input_Start = function(this, joystick)
		-- open pause menu
		ScriptCB_PushScreen("ifs_freeform_menu")
	end,

	HandleMouse = function(this, x, y)
		gIFShellScreenTemplate_fnHandleMouse(this, x, y)
		
		for planet, _ in pairs(ifs_freeform_main.planetDestination) do
			local x1, y1 = GetScreenPosition(planet)
			local dx = x1 - x
			local dy = y1 - y
			if dx*dx+dy*dy<400 then
				ifs_freeform_main.planetNext = planet
			end
		end
	end,
	
	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- call base class

		-- save the current location
		local planetOld = ifs_freeform_main.planetSelected

		-- update zoom values
		ifs_freeform_main:UpdateZoom()
		
		-- update the next planet
		ifs_freeform_main:UpdateNextPlanet()

		-- select the new planet
		ifs_freeform_main:SelectPlanet(this.info, ifs_freeform_main.planetNext)

		-- draw lanes
		ifs_freeform_main:DrawLanes()
		
		-- draw planet icons
		ifs_freeform_main:DrawPlanetIcons()

		-- draw port icons
		ifs_freeform_main:DrawPortIcons()

		-- draw fleet icons
		ifs_freeform_main:DrawFleetIcons()

		-- draw available build
		if this.buildPort then
			ifs_freeform_main:DrawPortIcon(ifs_freeform_main.planetSelected, ifs_freeform_main.playerTeam, true, true)
		end
		if this.buildFleet then
			ifs_freeform_main:DrawFleetIcon(ifs_freeform_main.planetSelected, ifs_freeform_main.playerTeam, true, true)
		end

		-- if the planet changed...
		if ifs_freeform_main.planetNext ~= planetOld then
			this:UpdateAction()
		end
	end
}

ifs_freeform_AddCommonElements(ifs_freeform_purchase_fleet)
AddIFScreen(ifs_freeform_purchase_fleet,"ifs_freeform_purchase_fleet")
