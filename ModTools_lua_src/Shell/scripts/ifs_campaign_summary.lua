--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_campaign_summary = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,
	
	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd)
		
		-- set the camera zoom
		ifs_campaign_main:SetZoom(0)
		
		IFText_fnSetString(this.title.text, "ifs.freeform.summary.name")
		
		ifs_freeform_SetButtonVis(this, "accept", nil)

		ifs_campaign_main:UpdatePlayerText(this.player)
		
		IFObj_fnSetVis(this.info, nil)
	end,

	Exit = function(this, bFwd)
	end,

	Input_Accept = function(this, joystick)
		if(gPlatformStr == "PC") then
			--print( "this.CurButton = ", this.CurButton )
			if( this.CurButton == "_accept" ) then
				return
			elseif( this.CurButton == "_back" ) then
				return
			elseif( this.CurButton == "_next" ) then
				-- start the next turn
				ifs_campaign_main:NextTurn()			
			else
				return
			end
		end
	end,

	Input_Misc = function(this, joystick)
		if(gPlatformStr ~= "PC") then
			-- start the next turn
	 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
			ifs_campaign_main:NextTurn()
		end
	end,
	
	Input_Back = function(this, joystick)
		-- go to the previous page
 		ifelm_shellscreen_fnPlaySound(this.cancelSound)
		ScriptCB_PopScreen()
	end,
	
	Input_Start = function(this, joystick)
		-- open pause menu
		ScriptCB_PushScreen("ifs_campaign_menu")
	end,

	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- call base class

		-- update zoom values
		ifs_campaign_main:UpdateZoom()
	end
}
	
ifs_freeform_AddCommonElements(ifs_campaign_summary)
AddIFScreen(ifs_campaign_summary,"ifs_campaign_summary")
