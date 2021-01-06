--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_freeform_focus = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext = 1,
	bNohelptextPC = 1,

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function

		-- get the selected planet
		local selected = ifs_freeform_main.planetSelected

		-- focus on the selected planet
		ifs_freeform_main:SetZoom(2)
		MoveCameraToEntity(selected .. "_camera")

		IFObj_fnSetVis(this.title, nil)
		
		-- if the planet has a team
		if ifs_freeform_main.planetTeam[selected] then
			-- update title
			IFObj_fnSetVis(this.info, true)
			IFText_fnSetString(this.info.caption, "planetname." .. selected)
			IFObj_fnSetColor(this.info.caption, ifs_freeform_main:GetTeamColor(ifs_freeform_main.planetTeam[selected]))
			IFObj_fnSetAlpha(this.info.caption, gUnselectedTextAlpha)
			IFObj_fnSetVis(this.info.caption, true)
		else
			IFObj_fnSetVis(this.info, false)
			IFObj_fnSetVis(this.info.caption, false)
		end
		IFObj_fnSetVis(this.info.subcaption, false)

		-- remove player group
		IFObj_fnSetVis(this.player, nil)
		
		-- update info
		IFText_fnSetString(this.info.text, "ifs.freeform.planetdesc." .. selected)

		-- hide actions
		ifs_freeform_SetButtonVis(this, "accept", nil)
		ifs_freeform_SetButtonVis(this, "back", nil)
		ifs_freeform_SetButtonVis(this, "misc", nil)
		ifs_freeform_SetButtonVis(this, "help", nil)
	end,

	Exit = function(this, bFwd)
	end,

	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- call base class

		-- update zoom values
		ifs_freeform_main:UpdateZoom()
		
		-- draw lanes
		ifs_freeform_main:DrawLanes(nil, nil)

		-- draw planet icons
		ifs_freeform_main:DrawPlanetIcons()

--		-- draw port icons
--		ifs_freeform_main:DrawPortIcons()

		-- draw fleet icons
		ifs_freeform_main:DrawFleetIcons(nil, false)
		if ifs_freeform_main.planetNext ~= ifs_freeform_main.planetSelected then
			if ifs_freeform_main.planetFleet[ifs_freeform_main.planetNext] ~= ifs_freeform_main.playerTeam then
				ifs_freeform_main:DrawFleetIcon(ifs_freeform_main.planetNext, ifs_freeform_main.playerTeam, true, true)
			else
--				ifs_freeform_main:DrawNonIcon(ifs_freeform_main.planetNext, ifs_freeform_main.playerTeam, true)
			end
		end
	end,
	
	Input_Accept = function(this, joystick)
	end,

	Input_Back = function(this, joystick)
	end,

  	Input_Start = function(this, joystick)
		-- open pause menu
		ScriptCB_PushScreen("ifs_freeform_menu")
  	end,

	Input_KeyDown = function(this, iKey)
		if iKey == 45 or iKey == 95 then
			-- '-' or '_' -> zoom out
			this:Input_LTrigger2()
		end
	end,
	
	Input_DPadDown = function(this, joystick)
		this:Input_LTrigger2(joystick)
	end,
	
	Input_LTrigger2 = function(this, joystick)
		ScriptCB_PopScreen()
	end,
}

ifs_freeform_AddCommonElements(ifs_freeform_focus)
AddIFScreen(ifs_freeform_focus,"ifs_freeform_focus")
