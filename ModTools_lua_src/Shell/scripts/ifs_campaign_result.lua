--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_campaign_result = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function

--		ifs_campaign_main:SetZoom(2)
--		MoveCameraToEntity(ifs_campaign_main.planetSelected .. "_camera")
--		SnapMapCamera()
--		
--		IFObj_fnSetVis(this.title, nil)
--			
--		IFText_fnSetString(this.info.caption, "ifs.campaignname." .. ifs_campaign_main.turnNumber)
--
--		IFObj_fnSetVis(this.player, nil)
--
--		local mission = ifs_campaign_mission[ifs_campaign_main.turnNumber]
--		if this.lost then
--			IFText_fnSetUString(this.info.text,
--				ScriptCB_usprintf("ifs.freeform.wasdestroyed",
--					ScriptCB_getlocalizestr("ifs.freeform.fleet." .. mission.side)
--				)
--			)
--			ifs_freeform_SetButtonName( this, "accept", "common.retry")
--		elseif mission.space then
--			IFText_fnSetUString(this.info.text,
--				ScriptCB_usprintf("ifs.freeform.destroyed",
--					ScriptCB_getlocalizestr("ifs.freeform.fleet." .. mission.side),
--					ScriptCB_getlocalizestr("ifs.freeform.fleet." .. mission.enemy)
--				)
--			)
--			ifs_freeform_SetButtonName( this, "accept", "common.next")
--		else
--			IFText_fnSetUString(this.info.text,
--				ScriptCB_usprintf("ifs.freeform.captured",
--					ScriptCB_getlocalizestr("ifs.freeform.fleet." .. mission.side),
--					ScriptCB_getlocalizestr("planetname." .. mission.planet)
--				)
--			)
--			ifs_freeform_SetButtonName( this, "misc", "common.next")
--		end
--
--		ifs_freeform_SetButtonVis(this, "misc", nil)
--		ifs_freeform_SetButtonVis(this, "back", nil)
		
		if bFwd then
			if this.lost then
				-- go back to the battle screen
				ScriptCB_PushScreen("ifs_campaign_battle")
			else
				ifs_campaign_main:NextTurn()
			end
		end
	end,

	Exit = function(this, bFwd)
	end,

	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- call base class

--		-- update zoom values
--		ifs_campaign_main:UpdateZoom()
	end,
	
	Input_Accept = function(this, joystick)
--		if(gPlatformStr == "PC") then
--			--print( "this.CurButton = ", this.CurButton )
--			if( this.CurButton == "_accept" ) then
--			elseif( this.CurButton == "_back" ) then
--				return
--			elseif( this.CurButton == "_next" ) then
--				-- handle in Input_Misc
--				return
--			else
--				return
--			end
--		end
--		if ifs_campaign_main.joystick and joystick ~= ifs_campaign_main.joystick then
--			return
--		end
--		
--		-- if the player lost...
--		if this.lost then
--			-- go back to the battle screen
--	 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
--			ScriptCB_PushScreen("ifs_campaign_battle")
--		else
----			-- if not moving to another planet...
----			local turn = ifs_campaign_main.turnNumber
----			if ifs_campaign_mission[turn].planet == ifs_campaign_mission[turn+1].planet then
--				-- skip the summary screen
--		 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
--				ifs_campaign_main:NextTurn()
----			else
----				-- go to the summary screen
----				ScriptCB_PushScreen("ifs_campaign_summary")
----			end
--		end		
	end, -- Input_Accept
	
	Input_Misc = function(this, joystick)
--		if ifs_campaign_main.joystick and joystick ~= ifs_campaign_main.joystick then
--			return
--		end
--		-- If base class handled this work, then we're done
--		if(gShellScreen_fnDefaultInputAccept(this)) then
--			return
--		end		
	end,

	Input_Back = function(this, joystick)
--		-- no going back from here...
--		if ifs_campaign_main.joystick and joystick ~= ifs_campaign_main.joystick then
--			return
--		end
	end,

--	Input_Start = function(this, joystick)
--		if ifs_campaign_main.joystick and joystick ~= ifs_campaign_main.joystick then
--			return
--		end
--		-- open pause menu
--		ScriptCB_PushScreen("ifs_campaign_menu")
--	end,
}

ifs_freeform_AddCommonElements(ifs_campaign_result)
AddIFScreen(ifs_campaign_result,"ifs_campaign_result")