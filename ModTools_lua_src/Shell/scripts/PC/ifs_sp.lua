--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_sp_vbutton_layout = {
--	yTop = -70,
	xWidth = 300,
	width = 300,
	xSpacing = 10,
	ySpacing = 5,
	font = gMenuButtonFont,
	bLeftJustifyButtons = 1,
	buttonlist = { 
		{ tag = "meta", string = "ifs.sp.meta", },
		{ tag = "ia", string = "ifs.sp.ia", },
	},
	title = "ifs.main.sp",
--	rotY = 35,
}

function ifs_sp_StartSaveProfile()
--	print("ifs_sp_StartSaveProfile")
	
	ifs_saveop.doOp = "SaveProfile"
	ifs_saveop.OnSuccess = ifs_sp_SaveProfileSuccess
	ifs_saveop.OnCancel = ifs_sp_SaveProfileCancel
	local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
	ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
	ifs_saveop.saveProfileNum = iProfileIdx
	ifs_movietrans_PushScreen(ifs_saveop)
end

function ifs_sp_SaveProfileSuccess()
--	print("ifs_sp_SaveProfileSuccess")
	local this = ifs_sp
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()

	if(this.NextScreenAfterSave) then
--		print("  staying here, will push from Enter")
	else
		-- exit this screen
		ScriptCB_PopScreen()
	end
end

function ifs_sp_SaveProfileCancel()
--	print("ifs_sp_SaveProfileCancel")
	local this = ifs_sp
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()

	if(this.NextScreenAfterSave) then
--		print("  staying here, will push from Enter")
	else
		-- exit this screen
		ScriptCB_PopScreen()
	end
end


ifs_sp = NewIFShellScreen {
	movieIntro      = nil, -- WAS "ifs_sp_intro",
	movieBackground = "shell_sub_left", -- WAS "ifs_sp",
	music           = "shell_soundtrack",

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = gDefaultButtonScreenRelativeY, -- center
	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		gMovieDisabled = nil


		if(bFwd and ScriptCB_IsCampaignStateSaved()) then
			if(ScriptCB_IsCurProfileDirty()) then
				this.NextScreenAfterSave = ifs_campaign_main
				ifs_sp_StartSaveProfile()
			else
				ifs_movietrans_PushScreen(ifs_campaign_main)
			end
		end

		if(bFwd and ScriptCB_GetInTrainingMission()) then
			ScriptCB_SetSPProgress(1,1) -- note this is complete
			ScriptCB_SetInTrainingMission(nil) -- clear flag so this doen't happen again
		end

		-- if its splitscreen, change the orange title to say "splitscreen"
		if(ScriptCB_IsSplitscreen()) then
			IFText_fnSetString(this.buttons._titlebar_,"ifs.main.split")
		else
			IFText_fnSetString(this.buttons._titlebar_,"ifs.main.sp")
		end

		if(bFwd) then
			ShowHideVerticalButtons(this.buttons,ifs_sp_vbutton_layout)
		end
		SetCurButton(this.CurButton)

		if((not bFwd) and (this.NextScreenAfterSave)) then
			ifs_movietrans_PushScreen(this.NextScreenAfterSave)
			this.NextScreenAfterSave = nil
		end

		gMovieAlwaysPlay = 1
	end,
	
	Exit = function(this, bFwd)
		if (not bFwd) then
			gMovieAlwaysPlay = nil
			ScriptCB_SetGameRules("instantaction")
		end

		gIFShellScreenTemplate_fnLeave(this, bFwd)
	end,

	Input_Accept = function(this)

		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		-- Next screen to go to at end of Input_Accept, if this is not-nil
		-- at the bottom
		local ScreenToPush = nil

 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		if(this.CurButton == "ia") then
			ScriptCB_SetGameRules("instantaction")
			if(this.bForSplitScreen) then
				ScreenToPush = ifs_split_map
			else
				ScreenToPush = ifs_instant_top
			end
		elseif (this.CurButton == "meta") then
			ScreenToPush = ifs_sp_campaign
		elseif (this.CurButton == "campaign") then
			ScriptCB_SetGameRules("campaign")
			ifs_sp_briefing.era = "c1"
			ScreenToPush = ifs_sp_briefing
		end

		if(ScreenToPush) then
			-- We can't invalidate profile on this screen - NM 7/18/05
			if(nil) then -- ScriptCB_IsCurProfileDirty()) then
				this.NextScreenAfterSave = ScreenToPush
				ifs_sp_StartSaveProfile()
			else
				ifs_movietrans_PushScreen(ScreenToPush)
			end
		end -- have a ScreenToPush

	end,

	Input_Back = function(this)
		if(ScriptCB_IsCurProfileDirty()) then
			this.NextScreenAfterSave = nil
			ifs_sp_StartSaveProfile()
		else
			--otherwise just exit
			ScriptCB_PopScreen()
		end		
	end,
}

ifs_sp.CurButton = AddVerticalButtons(ifs_sp.buttons,ifs_sp_vbutton_layout)
AddIFScreen(ifs_sp,"ifs_sp")
