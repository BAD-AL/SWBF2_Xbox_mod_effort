--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Single player Tabs layout
gPCSinglePlayerTabsLayout = {
	{ tag = "_tab_campaign",	string = "ifs.sp.campaign",			screen = "ifs_sp_campaign",		xPos = 350, width = 350, },
	{ tag = "_tab_instant",		string = "ifs.sp.ia",				screen = "ifs_missionselect",	xPos = 700, width = 350, },
}

ifs_sp_campaign_vbutton_layout = {
--	yTop = -70,
	xWidth = 460,
	width = 460,
	xSpacing = 10,
	ySpacing = 5,
	font = gMenuButtonFont,
	bLeftJustifyButtons = 1, 
	buttonlist = { 
		{ tag = "1", string = "ifs.meta.Configs.1", },
		{ tag = "2", string = "ifs.meta.Configs.2", },
		{ tag = "3", string = "ifs.meta.Configs.3", },
		{ tag = "4", string = "ifs.meta.Configs.4", },
		{ tag = "custom", string = "ifs.meta.Configs.custom", },
		{ tag = "campaign", string = "ifs.sp.campaign1.title", },
		{ tag = "load", string = "ifs.meta.load.btnload", },
	},
	title = "ifs.sp.meta",
--	rotY = 35,
}

AskHistorical_Button_Layout = {
	yTop = 0,
	width = 300,
	font = gPopupButtonFont,
	buttonlist = { 
		{ tag = "yes", string = "ifs.sp.play", },
		{ tag = "no", string = "ifs.sp.skip", },
	},
--	nocreatebackground = 1,
}

-- General handler for a "Ok" dialog

Popup_Ask_Historical = NewPopup {
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.5,
	height = 240,
	width = 400,
	ZPos = 50,
	ButtonHeightHint = 70,

	title = NewIFText {
		font = gPopupTextFont,
		textw = 370,
		texth = 160,
		y2 = -110,
		flashy=0,
	},

	buttons = NewIFContainer {
		y = 50,
	},

	fnSetMode = gPopup_YesNo_fnSetMode,
	fnActivate = gPopup_YesNo_fnActivate,
	Input_Accept = gPopup_YesNo_fnInput_Accept,
	Input_GeneralRight = gPopup_YesNo_fnInput_GeneralRight,
	Input_GeneralLeft = gPopup_YesNo_fnInput_GeneralLeft,
	
	Input_Back = function(this)
		ifs_sp_campaign.bCancelAsk = 1
		this.CurButton = "no"
		gPopup_YesNo_fnInput_Accept(this)
	end,
}


function ifs_sp_campaign_StartSaveProfile()
--	print("ifs_sp_campaign_StartSaveProfile")
	
	ifs_saveop.doOp = "SaveProfile"
	ifs_saveop.OnSuccess = ifs_sp_campaign_SaveProfileSuccess
	ifs_saveop.OnCancel = ifs_sp_campaign_SaveProfileCancel
	local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
	ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
	ifs_saveop.saveProfileNum = iProfileIdx
	ifs_movietrans_PushScreen(ifs_saveop)
end

function ifs_sp_campaign_SaveProfileSuccess()
--	print("ifs_sp_campaign_SaveProfileSuccess")
	local this = ifs_sp_campaign
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()

	if(this.NextScreenAfterSave) then
--		print("  staying here, will push from Enter")
	else
		-- exit this screen
		ScriptCB_PopScreen()
	end
end

function ifs_sp_campaign_SaveProfileCancel()
--	print("ifs_sp_campaign_SaveProfileCancel")
	local this = ifs_sp_campaign
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()

	if(this.NextScreenAfterSave) then
--		print("  staying here, will push from Enter")
	else
		-- exit this screen
		ScriptCB_PopScreen()
	end
end


-- 
function ifs_sp_campaign_fnUpdateButtonVis(this)
	local bIsSplit = ScriptCB_IsSplitscreen()

--	this.buttons.training.hidden = bIsSplit
	this.buttons.custom.hidden = not bIsSplit
	this.buttons.campaign.hidden = gFinalBuild

	local bCompletedTraining = 1 -- = ScriptCB_GetSPProgress(1) > 0
	local bCompletedRise = 1 -- ScriptCB_GetSPProgress(2) > 0
	
--	this.buttons.riseempire.bDimmed = not bCompletedTraining
	this.buttons["1"].bDimmed = (not bCompletedRise) and (not bIsSplit)
	this.buttons["2"].bDimmed = (not bCompletedRise) and (not bIsSplit)
	this.buttons["3"].bDimmed = (not bCompletedRise) and (not bIsSplit)
	this.buttons["4"].bDimmed = (not bCompletedRise) and (not bIsSplit)
	this.buttons.load.bDimmed = (not bCompletedTraining) and (not bIsSplit)
	return ShowHideVerticalButtons(this.buttons,ifs_sp_campaign_vbutton_layout)
end


-- Callback when the "play training" dialog is done. If bResult is
-- true, the user selected 'yes'
function ifs_sp_campaign_fnPostAskTraining(bResult)
	local this = ifs_sp_campaign

	if(ifs_sp_campaign.bCancelAsk) then
		ifs_sp_campaign.bCancelAsk = nil -- clear flag
		ifs_sp_campaign_fnUpdateButtonVis(this)
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
		ifs_sp_campaign_fnUpdateButtonVis(this)
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
function ifs_sp_campaign_fnAskTraining(this)
	bCompletedTraining = (ScriptCB_GetSPProgress(1) > 0) or (ScriptCB_IsSplitscreen())
	if(bCompletedTraining) then
		return 1
	end

	-- Hasn't completed training. Store choice, in case they want to
	-- skip out.
	this.BackupCurButton = this.CurButton
	IFObj_fnSetVis(this.buttons, nil)
	Popup_Ask_Historical.CurButton = "yes" -- default
	Popup_Ask_Historical.fnDone = ifs_sp_campaign_fnPostAskTraining
	Popup_Ask_Historical:fnActivate(1)
	gPopup_fnSetTitleStr(Popup_Ask_Historical, "ifs.sp.asktraining")
end

ifs_sp_campaign = NewIFShellScreen {
	bAcceptIsSelect = 1,
	movieIntro      = nil, -- WAS "ifs_sp_campaign_intro",
	movieBackground = "shell_sub_left", -- WAS "ifs_sp_campaign",
	music           = "shell_soundtrack",

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	Enter = function(this, bFwd)
		-- tabs	
		if(gPlatformStr == "PC") then
			ifelem_tabmanager_SetSelected(this, gPCSinglePlayerTabsLayout, "_tab_campaign")
		end
	
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		gMovieDisabled = nil

		if(bFwd and ScriptCB_IsCampaignStateSaved()) then
			if(ScriptCB_IsCurProfileDirty()) then
				this.NextScreenAfterSave = ifs_campaign_main
				ifs_sp_campaign_StartSaveProfile()
			else
				ifs_movietrans_PushScreen(ifs_campaign_main)
			end
		end

		if(bFwd and ScriptCB_GetInTrainingMission()) then
			ScriptCB_SetSPProgress(1,1) -- note this is complete
			ScriptCB_SetInTrainingMission(nil) -- clear flag so this doen't happen again
			ScriptCB_SetLastBattleVictoryValid(nil) -- don't care about victory
		end

		-- if its splitscreen, change the orange title to say "splitscreen"
		-- REMOVED NM 8/9/05 - BF2 bug 9399 - testers didn't like
-- 		if(ScriptCB_IsSplitscreen()) then
-- 			IFText_fnSetString(this.buttons._titlebar_,"ifs.main.split")
-- 		else
-- 			IFText_fnSetString(this.buttons._titlebar_,"ifs.meta.title")
--		end

		if(bFwd) then
			this.CurButton = ifs_sp_campaign_fnUpdateButtonVis(this)
		end
		SetCurButton(this.CurButton)

		if((not bFwd) and (this.NextScreenAfterSave)) then
			ifs_movietrans_PushScreen(this.NextScreenAfterSave)
			this.NextScreenAfterSave = nil
		end

		gMovieAlwaysPlay = 1
		this.iCheatState = 0
	end,
	
	Exit = function(this, bFwd)
		if (not bFwd) then
			gMovieAlwaysPlay = nil
			ScriptCB_SetGameRules("instantaction")
		end

		gIFShellScreenTemplate_fnLeave(this, bFwd)
	end,

	Input_Accept = function(this)
		this.iCheatState = 0
		if(gPlatformStr == "PC") then
			-- If the tab manager handled this event, then we're done
			if(ifelem_tabmanager_HandleInputAccept(this, gPCSinglePlayerTabsLayout)) then
				return
			end
		end

		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		-- Next screen to go to at end of Input_Accept, if this is not-nil
		-- at the bottom
		local ScreenToPush = nil

 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		if (this.CurButton == "riseempire") then
			-- Ken, do something in ifs_freeform_rise_newload's "new" code.
			if(ifs_sp_campaign_fnAskTraining(this)) then
				ScreenToPush = ifs_freeform_rise_newload
			end
		elseif (this.CurButton == "meta") then
			if(ifs_sp_campaign_fnAskTraining(this)) then
				ScreenToPush = ifs_freeform_pickscenario
			end
		elseif (this.CurButton == "custom") then
			if(ifs_sp_campaign_fnAskTraining(this)) then
				ScreenToPush = ifs_freeform_customsetup
			end
		elseif (this.CurButton == "campaign") then
			ScriptCB_SetGameRules("campaign")
			ifs_sp_briefing.era = "c1"
			ScreenToPush = ifs_sp_briefing
		elseif (this.CurButton == "training") then
			-- If training has been completed, assme they want to replay it.
			ifs_sp_campaign_fnPostAskTraining(1)
		elseif (this.CurButton == "campaign") then
			ScriptCB_SetGameRules("campaign")
			ifs_sp_campaign_briefing.era = "c1"
			ScreenToPush = ifs_sp_campaign_briefing
		elseif (this.CurButton == "load") then
			ifs_freeform_load.Mode = "Load"
			ifs_freeform_load.SkipPromptSave = 1
			ScreenToPush = ifs_freeform_load
		else
			-- always clear the quit player here
			ScriptCB_SetQuitPlayer(1)
			if(ifs_sp_campaign_fnAskTraining(this)) then 
				ScreenToPush = ifs_freeform_main
				if (this.CurButton == "1") then
					-- rebel scenario
					ifs_freeform_start_all(ifs_freeform_main)
				elseif (this.CurButton == "2") then
					-- cis scenario
					ifs_freeform_start_cis(ifs_freeform_main)
				elseif (this.CurButton == "3") then
					-- republic scenario
					ifs_freeform_start_rep(ifs_freeform_main)
				elseif (this.CurButton == "4") then
					-- empire scenario
					ifs_freeform_start_imp(ifs_freeform_main)
				else
					ScreenToPush = nil
				end
			end
		end

		if(ScreenToPush) then
			-- Fix for 4903 - don't prompt to save right before a load.
			if((ScriptCB_IsCurProfileDirty()) and (this.CurButton ~= "load")) then
				this.NextScreenAfterSave = ScreenToPush
				ifs_sp_campaign_StartSaveProfile()
			else
				ifs_movietrans_PushScreen(ScreenToPush)
			end
		end -- have a ScreenToPush
		
	end,

	Input_Back = function(this)
		this.iCheatState = 0
		if(ScriptCB_IsCurProfileDirty()) then
			this.NextScreenAfterSave = nil
			ifs_sp_campaign_StartSaveProfile()
		else
			--otherwise just exit
			ScriptCB_PopScreen()
		end		
	end,

	Input_Misc = function(this)
		if((this.iCheatState == 0) or (this.iCheatState == 2) or (this.iCheatState == 4)) then
			this.iCheatState = this.iCheatState + 1
		end
	end,

	Input_Misc2 = function(this)
		if((this.iCheatState == 1) or (this.iCheatState == 3) or (this.iCheatState == 5)) then
			this.iCheatState = this.iCheatState + 1
		end

		if(this.iCheatState == 6) then
			ScriptCB_SetSPProgress(2,2)
			ifs_sp_campaign_fnUpdateButtonVis(this)
		end
	end,

}

function ifs_sp_campaign_fnBuildScreen( this ) 
	if(gPlatformStr == "PC") then
		-- Add tabs to screen
		ifelem_tabmanager_Create(this, gPCSinglePlayerTabsLayout)
	end
end

ifs_sp_campaign_fnBuildScreen( ifs_sp_campaign )
ifs_sp_campaign_fnBuildScreen = nil

AddVerticalButtons(Popup_Ask_Historical.buttons,AskHistorical_Button_Layout)
CreatePopupInC(Popup_Ask_Historical,"Popup_Ask_Historical")
Popup_Ask_Historical.buttons.x2 = Popup_Ask_Historical.buttons.x

ifs_sp_campaign.CurButton = AddVerticalButtons(ifs_sp_campaign.buttons,ifs_sp_campaign_vbutton_layout)
AddIFScreen(ifs_sp_campaign,"ifs_sp_campaign")
