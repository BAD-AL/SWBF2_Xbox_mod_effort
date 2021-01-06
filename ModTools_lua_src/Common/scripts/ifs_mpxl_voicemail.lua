--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


xlvoicemail_vbutton_layout = {
--	yTop = 10,
	ySpacing = 5,
	width = 510,
	font = gMenuButtonFont,
	buttonlist = {
		{ tag = "record", string = "ifs.xvoicemail.record" },
		{ tag = "play", string = "ifs.xvoicemail.play" },
		{ tag = "stop", string = "ifs.xvoicemail.stop" },
		{ tag = "feedback", string = "ifs.mp.friends.feedback" },
		{ tag = "delete", string = "ifs.Profile.delete" },
		{ tag = "block", string = "ifs.xvoicemail.block" },
		{ tag = "invite", string = "ifs.xvoicemail.sendinvite", font = "gamefont_small", yAdd = 8, },
		{ tag = "friendrequest", string = "ifs.xvoicemail.sendfriendrequest", font = "gamefont_small", yAdd = 8, },
	},
	title = "ifs.xvoicemail.title",
}

-- Callbacks from the "never accept friends requests" popup. If
-- bResult is true, user selected 'yes'
function ifs_mpxl_voicemail_fnAskedBlock(bResult)
	local this = ifs_mpxl_voicemail

	-- Always turn screen back on
	local fAnimTime = 0.2
	AnimationMgr_AddAnimation(this.buttons,
														{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})

	if(bResult) then
		ScriptCB_XL_DeleteVoicemail(1, xlfriends_listbox_layout.SelectedIdx) -- 1 == permanently
		ScriptCB_PopScreen()
	end
end


function ifs_mpxl_voicemail_fnSetBusy(this, bNewBusy)
	this.bBusy = bNewBusy
	this.buttons.record.bDimmed = this.bBusy
	this.buttons.play.bDimmed = this.bBusy
	this.buttons.feedback.bDimmed = this.bBusy
	this.buttons.delete.bDimmed = this.bBusy
	this.buttons.block.bDimmed = this.bBusy
	this.buttons.invite.bDimmed = this.bBusy
	this.buttons.friendrequest.bDimmed = this.bBusy
	this.buttons.stop.bDimmed = not this.bBusy

	-- Determine new "first" button, jump to it always
	local NewButton = ShowHideVerticalButtons(this.buttons,xlvoicemail_vbutton_layout)
	this.CurButton = NewButton
	SetCurButton(this.CurButton)

end


ifs_mpxl_voicemail = NewIFShellScreen {
	nologo = 1,
	bAcceptIsSelect = 1,
	bDimBackdrop = 1,
	bg_texture = "iface_bgmeta_space",
	movieIntro      = nil, -- played before the screen is displayed
	movieBackground = nil, -- played while the screen is displayed

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = gDefaultButtonScreenRelativeY, -- top
	},

	Enter = function(this, bFwd)
		-- Always call base class
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if(ErrorLevel >= 6) then -- session or login error, must keep going further
				ScriptCB_PopScreen()
			end
		end

		ifs_mpxl_voicemail_fnSetBusy(this, nil)
		if(bFwd) then
			ScriptCB_XL_EnableVoicemail(1)

			this.buttons.record.hidden = not this.bRecordOnly
			this.buttons.invite.hidden = (not this.bRecordOnly) or (this.bFriendMode)
			this.buttons.friendrequest.hidden = (not this.bRecordOnly) or (this.bInviteMode)
			this.buttons.feedback.hidden = this.bRecordOnly
			this.buttons.delete.hidden = this.bRecordOnly
			this.buttons.block.hidden = this.bRecordOnly
		end

		this.CurButton = ShowHideVerticalButtons(this.buttons,xlvoicemail_vbutton_layout)
		SetCurButton(this.CurButton)

	end,

	Exit = function(this, bFwd)
		if(not bFwd) then
			ScriptCB_XL_EnableVoicemail(nil)
		end
	end,

	Update = function(this, fDt)
		-- Call default base class's update function (make button bounce)
		gIFShellScreenTemplate_fnUpdate(this,fDt)

		ScriptCB_XL_UpdateVoicemail()
	end,


	Input_Accept = function(this)
		if(this.CurButton == "record") then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			ScriptCB_XL_RecordVoicemail()
			ifs_mpxl_voicemail_fnSetBusy(this, 1)
		elseif (this.CurButton == "play") then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			ScriptCB_XL_PlayVoicemail()
			ifs_mpxl_voicemail_fnSetBusy(this, 1)
		elseif (this.CurButton == "stop") then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			ScriptCB_XL_StopVoicemail()
			ifs_mpxl_voicemail_fnSetBusy(this, nil)
		elseif (this.CurButton == "feedback") then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			ifs_mpxl_feedback.bVoicemailOnly = 1
			ifs_movietrans_PushScreen(ifs_mpxl_feedback)
		elseif (this.CurButton == "delete") then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			ScriptCB_XL_DeleteVoicemail(nil, xlfriends_listbox_layout.SelectedIdx) -- nil == just this one, not permanent
			ScriptCB_PopScreen()
		elseif (this.CurButton == "invite") then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			ScriptCB_DoFriendAction("INVITEVOICE",this.bRecentMode)
			ScriptCB_PopScreen() -- back to Friends screen
		elseif (this.CurButton == "friendrequest") then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			this.iTargetIdx = this.iTargetIdx or 1
			ScriptCB_LobbyAction(this.iTargetIdx, this.TargetStr, "friendvoice")
			ScriptCB_PopScreen() -- back to Friends screen
		elseif (this.CurButton == "block") then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			Popup_YesNo_Large.CurButton = "no" -- default
			Popup_YesNo_Large.fnDone = ifs_mpxl_voicemail_fnAskedBlock
			Popup_YesNo_Large:fnActivate(1)
			gPopup_fnSetTitleStr(Popup_YesNo_Large, "ifs.xvoicemail.block_prompt")

			local fAnimTime = 0.2
			AnimationMgr_AddAnimation(this.buttons,
																{ fTotalTime = fAnimTime, fStartAlpha = 1, fEndAlpha = 0,})
		end
	end,

	-- No L/R functionality possible on this screen (gotta have stubs
	-- here, or the base class will override)
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,

	bBusy = nil,
	Update = function(this, fDt)
		-- Call default base class's update function (make button bounce)
		gIFShellScreenTemplate_fnUpdate(this,fDt)

		local bComplete = ScriptCB_XL_UpdateVoicemail()
		if(this.bBusy and bComplete) then
			ifs_mpxl_voicemail_fnSetBusy(this, nil)
		end

		-- If we're in record mode, and the headset goes MIA, then bail
		if(this.bRecordOnly) then
			local bHaveHeadset = ScriptCB_XL_IsHeadsetPresent()
			if(not bHaveHeadset) then
				ScriptCB_PopScreen() -- back to Friends screen
			end
		end
	end,
}


-- Do programatic work to set up this screen
function ifs_mpxl_voicemail_fnBuildScreen(this)
	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen

	this.CurButton = AddVerticalButtons(this.buttons,xlvoicemail_vbutton_layout)
end

ifs_mpxl_voicemail_fnBuildScreen(ifs_mpxl_voicemail)
ifs_mpxl_voicemail_fnBuildScreen = nil

AddIFScreen(ifs_mpxl_voicemail,"ifs_mpxl_voicemail")
ifs_mpxl_voicemail = DoPostDelete(ifs_mpxl_voicemail)
