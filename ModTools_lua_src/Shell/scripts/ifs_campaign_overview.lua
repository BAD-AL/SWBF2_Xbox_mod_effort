--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_campaign_overview = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		IFText_fnSetString(this.title.text, "ifs.freeform.fleetmove")
		
		-- set the camera zoom
		ifs_campaign_main:SetZoom(0)

		ifs_freeform_SetButtonVis( this, "misc", nil )
		ifs_freeform_SetButtonVis( this, "back", nil )
		ifs_freeform_SetButtonName( this, "accept", "ifs.freeform.fleet.move" )
		
		-- update tabs
		if this.tableft then
			IFText_fnSetString(this.tableft.text, "ifs.freeform.navigation.bonus")
			IFObj_fnSetVis(this.tableft, ifs_freeform_purchase_tech:CanEnter())
		end
		if this.tabright then
			IFText_fnSetString(this.tabright.text, "ifs.freeform.navigation.units")
			IFObj_fnSetVis(this.tabright, ifs_freeform_purchase_unit:CanEnter())
		end
		
		-- remove unused items
		IFObj_fnSetVis(this.info.subcaption, nil)		

		ifs_campaign_main:UpdatePlayerText(this.player)
		IFText_fnSetString(this.info.caption, "ifs.campaignname." .. ifs_campaign_main.turnNumber)
		IFText_fnSetString(this.info.text, "ifs.campaigndesc." .. ifs_campaign_main.turnNumber)
	
		-- prompt for save if necessary
		ifs_campaign_main:PromptSave()
	end,

	Exit = function(this, bFwd)
	end,

	Input_Accept = function(this, joystick)
		if(gPlatformStr == "PC") then
			--print( "this.CurButton = ", this.CurButton )
			if( this.CurButton == "_accept" ) then
			elseif( this.CurButton == "_back" ) then
				return
			elseif( this.CurButton == "_next" ) then
				-- go to the next screen
				ScriptCB_PushScreen("ifs_freeform_purchase_unit")			
			else
				return
			end				
		end
		-- go to the next screen
 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		ScriptCB_PushScreen("ifs_campaign_battle")
	end,
	
	Input_Back = function(this, joystick)
		if ifs_campaign_main.joystick and joystick ~= ifs_campaign_main.joystick then
			return
		end
	end,

	Input_Misc = function(this, joystick)
		if ifs_campaign_main.joystick and joystick ~= ifs_campaign_main.joystick then
			return
		end
	end,
	
	Input_LTrigger = function(this, joystick)
		if ifs_campaign_main.joystick and joystick ~= ifs_campaign_main.joystick then
			return
		end
		if ifs_freeform_purchase_tech:CanEnter() then
			-- go to the Bonus Purchase Screen
	 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
			ScriptCB_PushScreen("ifs_freeform_purchase_tech")		
		end
	end,
	
	Input_RTrigger = function(this, joystick)
		if ifs_campaign_main.joystick and joystick ~= ifs_campaign_main.joystick then
			return
		end
		if ifs_freeform_purchase_unit:CanEnter() then
			-- go to the Unit purchase Screen
	 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
			ScriptCB_PushScreen("ifs_freeform_purchase_unit")
		end
	end,

	Input_Start = function(this, joystick)
		if ifs_campaign_main.joystick and joystick ~= ifs_campaign_main.joystick then
			return
		end
		-- open pause menu
		ScriptCB_PushScreen("ifs_campaign_menu")
	end,

	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- call base class

		-- update zoom values
		ifs_campaign_main:UpdateZoom()
		
		-- draw planet icons
		ifs_campaign_main:DrawPlanetIcons()

		-- draw fleet movement
		ifs_campaign_main:DrawFleetMove(ifs_campaign_main.planetPrev, ifs_campaign_main.planetSelected, 1)
	end
}

ifs_freeform_AddCommonElements(ifs_campaign_overview)
ifs_freeform_AddTabElements(ifs_campaign_overview)
AddIFScreen(ifs_campaign_overview,"ifs_campaign_overview")
