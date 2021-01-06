--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_battle_fleet_sound = "mtg_%s_fleet_attacking_%s"
ifs_battle_planet_sound = "mtg_%s_planet_attacking_%s_%s"

ifs_freeform_battle = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
	
		ifs_freeform_main:SetZoom(2)
		MoveCameraToEntity(ifs_freeform_main.planetSelected .. "_camera")
		
		IFObj_fnSetVis(this.title, nil)
				
		-- remove player group
		IFObj_fnSetVis(this.player, nil)
		
		-- allow back only if coming from player fleet movement
		this.allowBack = ifs_freeform_main.joystick and ScriptCB_IsScreenInStack("ifs_freeform_fleet")
		
		-- update button status
		ifs_freeform_SetButtonVis( this, "back", this.allowBack )
		if ifs_freeform_main.joystick then
			ifs_freeform_SetButtonName( this, "accept", "ifs.freeform.attack" )
			ifs_freeform_SetButtonName( this, "back", "ifs.freeform.noattack" )
		else
			ifs_freeform_SetButtonName( this, "accept", "common.next" )
		end
		ifs_freeform_SetButtonVis( this, "misc", nil )
		ifs_freeform_SetButtonVis(this, "help", nil)
		
		-- play appropriate VO messages and display caption and info text
		--if it's a deep space battle
		if not ifs_freeform_main.planetTeam[ifs_freeform_main.planetSelected] then
			if ifs_freeform_main.joystick then
				ifs_freeform_main:PlayVoice(string.format(ifs_battle_fleet_sound, ifs_freeform_main.playerSide, "us"))
			else
				ifs_freeform_main:PlayVoice(string.format(ifs_battle_fleet_sound, ifs_freeform_main.otherSide, "them"))
			end
			IFObj_fnSetVis(this.info, true)
			IFText_fnSetString(this.info.caption, "ifs.freeform.spacebattle")
			IFObj_fnSetVis(this.info.text, false)
		--if it's a space battle over a planet
		elseif ifs_freeform_main.planetFleet[ifs_freeform_main.planetSelected] == 0 then
			if ifs_freeform_main.joystick then
				ifs_freeform_main:PlayVoice(string.format(ifs_battle_fleet_sound, ifs_freeform_main.playerSide, "us"))
			else
				ifs_freeform_main:PlayVoice(string.format(ifs_battle_fleet_sound, ifs_freeform_main.otherSide, "them"))
			end
			IFObj_fnSetVis(this.info, true)
			IFText_fnSetString(this.info.text, "ifs.freeform.planetdesc." .. ifs_freeform_main.planetSelected)
			IFObj_fnSetVis(this.info.text, true)
			IFText_fnSetUString(this.info.caption,
				ScriptCB_usprintf("ifs.freeform.fleetbattle",
					ScriptCB_getlocalizestr("planetname." .. ifs_freeform_main.planetSelected)
				)
			)
		--if it's a planet battle
		else
			if ifs_freeform_main.joystick then
				ifs_freeform_main:PlayVoice(string.format(ifs_battle_planet_sound, ifs_freeform_main.playerSide, ifs_freeform_main.planetSelected, "us"))
			else
				ifs_freeform_main:PlayVoice(string.format(ifs_battle_planet_sound, ifs_freeform_main.otherSide, ifs_freeform_main.planetSelected, "them"))
			end
			IFObj_fnSetVis(this.info, 1)
			IFText_fnSetString(this.info.text, "ifs.freeform.planetdesc." .. ifs_freeform_main.planetSelected)
			IFObj_fnSetVis(this.info.text, true)
			IFText_fnSetUString(this.info.caption,
				ScriptCB_usprintf("ifs.freeform.planetbattle",
					ScriptCB_getlocalizestr("planetname." .. ifs_freeform_main.planetSelected)
				)
			)
		end
		
		-- if in soak mode...
		if ifs_freeform_main.soakMode then
			-- start a display timer
			this.displayTimer = 5
		end
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

		-- auto-accept after the display timer elapses
		if this.displayTimer then
			this.displayTimer = this.displayTimer - fDt
			if this.displayTimer < 0 then
				this.displayTimer = nil
				if(gPlatformStr == "PC") then
					this.CurButton = "_accept"
				end
				this:Input_Accept(nil)
			end
		end
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
--		elseif iKey == 32 then
--			-- space -> next
--			this.CurButton = "_next"
--			this:Input_Accept(-1)
		end
	end,
	
	Input_Accept = function(this, joystick)
		if(gPlatformStr == "PC") then
			--print( "this.CurButton = ", this.CurButton )
			if( this.CurButton == "_accept" ) then
				-- purchase the item
			elseif( this.CurButton == "_back" ) then
				-- handle in Input_Back
				this:Input_Back(joystick)
				return
--			elseif( this.CurButton == "_next" ) then
--				return
			else
				return
			end
		end
		
 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
 		
		-- go to the battle mode screen
		ScriptCB_PushScreen("ifs_freeform_battle_mode")
	end, -- Input_Accept

	Input_Misc = function(this, joystick)
	end,
		
	Input_Back = function(this, joystick)
		-- if coming from the fleet screen...
		if this.allowBack then
			-- go back a screen
	 		ifelm_shellscreen_fnPlaySound(this.cancelSound)
			ScriptCB_PopScreen()
		end
	end,
	
	Input_Start = function(this, joystick)
		-- open pause menu
		ScriptCB_PushScreen("ifs_freeform_menu")
	end,
}

ifs_freeform_AddCommonElements(ifs_freeform_battle)
AddIFScreen(ifs_freeform_battle,"ifs_freeform_battle")
