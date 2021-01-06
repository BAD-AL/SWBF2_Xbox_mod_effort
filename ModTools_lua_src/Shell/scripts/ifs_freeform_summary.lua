--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_freeform_summary = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,
	
	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd)
		
		-- auto-skip for AI
		if not ifs_freeform_main.joystick then
			ifs_freeform_main:NextTurn()
			return
		end
		
		-- set the camera zoom
		ifs_freeform_main:SetZoom(0)
		
		IFText_fnSetString(this.title.text, "ifs.freeform.summary.name")

		ifs_freeform_SetButtonName(this, "accept", "ifs.freeform.newturn")
		ifs_freeform_SetButtonVis(this, "misc", nil)
		
		-- hide back button if coming from AI screen
		ifs_freeform_SetButtonVis(this, "back", ifs_freeform_main.joystick)

		ifs_freeform_main:UpdatePlayerText(this.player)
		
		--Set "galaxy overview" to team color
		local r, g, b = ifs_freeform_main:GetTeamColor(ifs_freeform_main.playerTeam)
		IFObj_fnSetColor(this.info.caption, r, g, b)
		IFText_fnSetString(this.info.caption, "ifs.freeform.overview.name")
		
		-- calculate planet ownership
		local planets = 0
		local owned = 0
		for planet, team in pairs(ifs_freeform_main.planetTeam) do
			if team > 0 then
				planets = planets + 1
				if team == ifs_freeform_main.playerTeam then
					owned = owned + 1
				end
			end
		end
		
		-- calculate fleet ownership
		local fleets = 0
		for planet, fleet in pairs(ifs_freeform_main.fleetPtr[ifs_freeform_main.playerTeam]) do
			fleets = fleets + 1
		end
			
		IFText_fnSetUString(this.info.text,
			ScriptCB_UnicodeStrCat(
				ScriptCB_usprintf("ifs.freeform.overview.planetsowned", 
					ScriptCB_tounicode(owned), ScriptCB_tounicode(planets)),
				ScriptCB_tounicode("\n"),
				ScriptCB_usprintf("ifs.freeform.overview.fleetsowned",
					ScriptCB_tounicode(fleets), ScriptCB_tounicode(4))
				)
			)
	end,

	Exit = function(this, bFwd)
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
		elseif iKey == -59 then
			-- F1 -> help
			this.CurButton = "_help"
			this:Input_Accept(-1)
		end
	end,
	
	Input_Misc = function(this, joystick)
--		if(gPlatformStr ~= "PC") then
--			-- start the next turn
--	 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
--			ifs_freeform_main:NextTurn()
--		end
	end,
	
		
	Input_Misc2 = function(this, joystick)
		-- show the tutorial pop-up
		Popup_Tutorial.textList = {
			"ifs.freeform.tutorial.14",
			"ifs.freeform.tutorial.15",
			"ifs.freeform.tutorial.16",
			"ifs.freeform.tutorial.17"
			}
		Popup_Tutorial:fnActivate(1)
	end,
	
	Input_Back = function(this, joystick)
		-- if not coming from AI screen...	
		if ifs_freeform_main.joystick then
			-- go to the previous page
	 		ifelm_shellscreen_fnPlaySound(this.cancelSound)
			ScriptCB_PopScreen()
		end
	end,
	
	Input_Start = function(this, joystick)
		-- open pause menu
		ScriptCB_PushScreen("ifs_freeform_menu")
	end,

	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- call base class
		
		-- update zoom values
		ifs_freeform_main:UpdateZoom()
		
		-- draw planet icons
		ifs_freeform_main:DrawPlanetIcons()

--		-- draw port icons
--		ifs_freeform_main:DrawPortIcons()

		-- draw fleet icons
		ifs_freeform_main:DrawFleetIcons()
		
	end,
	
	Input_Accept = function(this, joystick)
		if(gPlatformStr == "PC") then
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
--			elseif( this.CurButton == "_next" ) then
--				-- start the next turn
--				ifs_freeform_main:NextTurn()
			else
				return
			end
		end
		
		-- start the next turn
 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		ifs_freeform_main:NextTurn()
	end	
}
	
ifs_freeform_AddCommonElements(ifs_freeform_summary)
AddIFScreen(ifs_freeform_summary,"ifs_freeform_summary")
