-- ifs_sp.lua (Zerted1.3 patch )
-- Decompiled by cbadal; 
-- verified 

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
		--{ tag = "training", string = "ifs.sp.training", },
		--{ tag = "spacetraining", string = "ifs.sp.spacetraining", },
		--{ tag = "riseempire", string = "ifs.sp.riseempire", },
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

--[[ 
function ifs_sp_fnUpdateButtonVis(this)
	local bIsSplit = ScriptCB_IsSplitscreen()

	this.buttons.training.hidden = bIsSplit
--	this.buttons.custom.hidden = not bIsSplit

	local bCompletedTraining = 1 -- = ScriptCB_GetSPProgress(1) > 0
	local bCompletedRise = 1 -- ScriptCB_GetSPProgress(2) > 0
	
	this.buttons.riseempire.bDimmed = not bCompletedTraining
-- 	this.buttons["1"].bDimmed = (not bCompletedRise) and (not bIsSplit)
-- 	this.buttons["2"].bDimmed = (not bCompletedRise) and (not bIsSplit)
-- 	this.buttons["3"].bDimmed = (not bCompletedRise) and (not bIsSplit)
-- 	this.buttons["4"].bDimmed = (not bCompletedRise) and (not bIsSplit)
-- 	this.buttons.load.bDimmed = (not bCompletedTraining) and (not bIsSplit)
	return ShowHideVerticalButtons(this.buttons,ifs_sp_vbutton_layout)
end


-- Callback when the "play training" dialog is done. If bResult is
-- true, the user selected 'yes'
function ifs_sp_fnPostAskTraining(bResult)
	local this = ifs_sp

	if(ifs_sp_campaign.bCancelAsk) then
		ifs_sp_campaign.bCancelAsk = nil -- clear flag
		ifs_sp_fnUpdateButtonVis(this)
		IFObj_fnSetVis(this.buttons, 1)
	elseif (bResult) then
		ScriptCB_SetGameRules("campaign")
		ScriptCB_ClearMissionSetup()
		ScriptCB_SetInTrainingMission(1)
		ScriptCB_SetMissionNames("geo1c_c", nil)
		ScriptCB_EnterMission()
	else
		-- Skipping training. Stay on this screen, and enable Rise of the Empire
		ScriptCB_SetSPProgress(1,2)
		ifs_sp_fnUpdateButtonVis(this)
		IFObj_fnSetVis(this.buttons, 1)

		-- If this was on the way to some choice, execute it now
		if(this.BackupCurButton) then
			this.CurButton = this.BackupCurButton
			this:Input_Accept()
		end
	end

	this.BackupCurButton = nil
end

-- Intercepts the call to various options (ROTE, *conquest). Reads
-- this.CurButton, and internal states. Returns true if the call is to
-- proceed, nil if it to not proceed (or it's still asking). Will
-- re-call Input_Accept() if the user hits 'yes' in the dialog
function ifs_sp_fnAskTraining(this)
	bCompletedTraining = (ScriptCB_GetSPProgress(1) > 0) or (ScriptCB_IsSplitscreen())
	if(bCompletedTraining) then
		return 1
	end

	-- Hasn't completed training. Store choice, in case they want to
	-- skip out.
	this.BackupCurButton = this.CurButton
	IFObj_fnSetVis(this.buttons, nil)
	Popup_Ask_Historical.CurButton = "yes" -- default
	Popup_Ask_Historical.fnDone = ifs_sp_fnPostAskTraining
	Popup_Ask_Historical:fnActivate(1)
	gPopup_fnSetTitleStr(Popup_Ask_Historical, "ifs.sp.asktraining")
end--]]

ifs_sp = NewIFShellScreen {
	movieIntro      = nil, -- WAS "ifs_sp_intro",
	movieBackground = "shell_sub_left", -- WAS "ifs_sp",
	music           = "shell_soundtrack",
	--bAcceptIsSelect = 1,

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = gDefaultButtonScreenRelativeY, -- center
	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		gMovieDisabled = nil

		--this.CurButton = ifs_sp_fnUpdateButtonVis(this)
		--SetCurButton(this.CurButton)

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
			--ScriptCB_SetLastBattleVictoryValid(nil) -- don't care about victory
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
--[[		elseif (this.CurButton == "riseempire") then
			-- Ken, do something in ifs_freeform_rise_newload's "new" code.
			if(ifs_sp_fnAskTraining(this)) then
				ScreenToPush = ifs_freeform_rise_newload
			end
		elseif (this.CurButton == "training") then
			-- If training has been completed, assme they want to replay it.
			ifs_sp_fnPostAskTraining(1)
		elseif (this.CurButton == "spacetraining" ) then
			ScreenToPush = ifs_spacetraining--]]
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
		-------------------------------------------------------------

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
