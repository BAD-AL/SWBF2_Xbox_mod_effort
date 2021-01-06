--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_sp_vbutton_layout = {
--	yTop = -70,
	xWidth = 650, -- Made 650 to fix bug 8742 - NM 8/18/04
	width = 650,
	xSpacing = 10,
	ySpacing = 5,
	font = "gamefont_large",
	buttonlist = { 
--		{ tag = "campaignCW", string = "ifs.sp.campaign.cw", },
--		{ tag = "campaignGCW", string = "ifs.sp.campaign.gcw", },
--		{ tag = "meta", string = "ifs.sp.meta", },
		{ tag = "ia", string = "ifs.sp.ia", },
	},
	title = "ifs.main.sp",
	rotY = 35,
}

ifs_sp = NewIFShellScreen {
	movieIntro      = nil, -- WAS "ifs_sp_intro",
	movieBackground = "temp_shell", -- WAS "ifs_sp",
	music           = "shell_soundtrack",

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- top
		y = 20, -- go slightly down from center
	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
        gMovieDisabled = nil

		if(bFwd and ScriptCB_IsMetagameStateSaved()) then
            ifs_movietrans_PushScreen(ifs_meta_new_load)
		end
		if(bFwd and ScriptCB_IsSPStateSaved()) then
			if(gPlatformStr == "PC") then
				ifs_movietrans_PushScreen(ifs_sp_briefing)
			else 
				ifs_movietrans_PushScreen(ifs_sp_era)
			end
		end
		--if( ifs_sp.bForSplitScreen ) then
		--	this.buttons.meta.hidden = 1
		--	IFObj_fnSetVis( this.buttons.meta, nil )
		--else
		--	this.buttons.meta.hidden = nil
		--	IFObj_fnSetVis( this.buttons.meta, 1 )
		--end		

		-- if its splitscreen, change the orange title to say "splitscreen"
		if(ScriptCB_IsSplitscreen()) then
			IFText_fnSetString(this.buttons._titlebar_,"ifs.main.split")
		else
			IFText_fnSetString(this.buttons._titlebar_,"ifs.main.sp")
		end
		

		ShowHideVerticalButtons(this.buttons,ifs_sp_vbutton_layout)
		gMovieAlwaysPlay = 1
	end,
	
	Exit = function(this, bFwd)
		if (not bFwd) then
			gMovieAlwaysPlay = nil

			ScriptCB_SetMetagameRulesOn(nil) -- for ingame
			ScriptCB_SetHistoricalRulesOn(nil)
			ScriptCB_SetCanSwitchSides(1)
		end
		gIFShellScreenTemplate_fnLeave(this, bFwd)
	end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		if(this.CurButton == "ia") then
			ScriptCB_SetMetagameRulesOn(nil) -- for ingame
			ScriptCB_SetHistoricalRulesOn(nil)
			ScriptCB_SetCanSwitchSides(1)
			if(this.bForSplitScreen) then
				ifs_movietrans_PushScreen(ifs_split_map)
			else
				ifs_movietrans_PushScreen(ifs_instant_top)
			end	
		elseif (this.CurButton == "campaignCW") then
			ScriptCB_SetMetagameRulesOn(nil) -- for ingame
			ScriptCB_SetHistoricalRulesOn(1)
			ScriptCB_SetCanSwitchSides(nil)
			if(gPlatformStr == "PC") then
				ifs_sp_briefing.era = "new"
				ifs_movietrans_PushScreen(ifs_sp_briefing)
			else 
				ifs_movietrans_PushScreen(ifs_sp_era)
			end
		elseif (this.CurButton == "campaignGCW") then
			ScriptCB_SetMetagameRulesOn(nil) -- for ingame
			ScriptCB_SetHistoricalRulesOn(1)
			ScriptCB_SetCanSwitchSides(nil)
			if(gPlatformStr == "PC") then
				ifs_sp_briefing.era = "classic"
				ifs_movietrans_PushScreen(ifs_sp_briefing)
			else 
				ifs_movietrans_PushScreen(ifs_sp_era)
			end
			
		elseif (this.CurButton == "meta") then
			-- always clear the quit player here
			ScriptCB_SetQuitPlayer(1)
			-- stop previous movie	
			ScriptCB_SetMetagameRulesOn(1) -- for ingame
			ScriptCB_SetHistoricalRulesOn(nil)
			ScriptCB_SetCanSwitchSides(nil)
			
			if(gPlatformStr == "PC") then
				ifs_movietrans_PushScreen(ifs_meta_opts) --skip the load/new screen on PC
			else
				ifs_movietrans_PushScreen(ifs_meta_new_load)
			end
		end
	end,
}


ifs_sp.CurButton = AddVerticalButtons(ifs_sp.buttons,ifs_sp_vbutton_layout)
AddIFScreen(ifs_sp,"ifs_sp")
