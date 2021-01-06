--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- XBox Live list of feedback

mpxl_feedback_vbutton_layout = {
	yTop = -110,

	yHeight = 30,
	ySpacing = 0,
	width = 400,
	font = "gamefont_medium",
	RightJustify = 1,
	bRightJustifyButton = 1,
	flashy = 0,
	buttonlist = {
		-- Title is for the left column, string the right-hand option
		{ tag = "attitude",  title = "ifs.xfeedback.feedback", string = "ifs.xfeedback.attitude" },
		{ tag = "session",   title = "", string = "ifs.xfeedback.session", },
		{ tag = "badname",   title = "ifs.xfeedback.Complaints", string = "ifs.xfeedback.badname" },
		{ tag = "cheating",  title = "", string = "ifs.xfeedback.cheating" },
		{ tag = "screaming", title = "", string = "ifs.xfeedback.screaming" },
		{ tag = "threats",   title = "", string = "ifs.xfeedback.threats" },
		{ tag = "cursing",   title = "", string = "ifs.xfeedback.cursing" },
		{ bVoicemailOnly = 1, tag = "offensive",   title = "ifs.xfeedback.Complaints", string = "ifs.xfeedback.offensive" },
	},
	bNoDefaultSizing = 1,
}

-- Shows or hides buttons. If bShowListbox is true, it'll show the
-- listbox, else the buttons will be visible. If bImmediate is true,
-- it'll set them visible now, else it'll do a fancy fade.
function ifs_mpxl_feedback_fnShowItems(this,bShowButtons,bImmediate)

	if(bImmediate) then
		IFObj_fnSetVis(this.buttonlabels, bShowButtons)
		IFObj_fnSetVis(this.buttons, bShowButtons)
	else
		-- Do fades only if changed
		if(this.bShowButtons ~= bShowButtons) then
			local fAnimTime = 0.2
			local A1,A2
			if(bShowButtons) then
				A1 = 0.0
				A2 = 1.0
			else
				A1 = 1.0
				A2 = 0.0
			end
			AnimationMgr_AddAnimation(this.buttonlabels,
																{ fTotalTime = fAnimTime, fStartAlpha = A1, fEndAlpha = A2,})
			AnimationMgr_AddAnimation(this.buttons,
																{ fTotalTime = fAnimTime, fStartAlpha = A1, fEndAlpha = A2,})

			-- Always ensure things are visible after fades triggered
			IFObj_fnSetVis(this.buttonlabels, 1)
			IFObj_fnSetVis(this.buttons, 1)
		end
	end

	-- Always store current state
	this.bShowButtons = bShowButtons
end

-- Callbacks from the "Send negative feedback 'X'?" popup. If bResult is
-- true, user selected 'yes'
function ifs_mpxl_feedback_fnAskedNegative(bResult)
	local this = ifs_mpxl_feedback
	ifs_mpxl_feedback_fnShowItems(this,1)
	if(bResult) then
		-- Send the feedback, get out of this screen
		ScriptCB_SendFeedback(this.TargetName,this.CurButton)
		ScriptCB_PopScreen()
	end

	Popup_YesNo.fnDone = nil
end

ifs_mpxl_feedback = NewIFShellScreen {
	nologo = 1,
	bAcceptIsSelect = 1,
	bDimBackdrop = 1,
	bg_texture = "iface_bgmeta_space",
    movieIntro      = nil, -- played before the screen is displayed
    movieBackground = nil, -- played while the screen is displayed

	title = NewIFText {
		string = "ifs.xfeedback.title",
		font = "gamefont_large",
		y = 0,
		textw = 460,
		texth = 60,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0, -- top
		inert = 1,
		nocreatebackground = 1,
	},

	PlayerName = NewIFText {
--		string = "ifs.xfeedback.title",
		font = "gamefont_medium",
		y = 55,
		textw = 460,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0, -- top
		nocreatebackground = 1,
	},

	buttonlabels = NewIFContainer {
		ScreenRelativeX = 0.1,
		ScreenRelativeY = 0.5,
--		y = 30, -- go down a little to make space for playername up top
	},

	buttons = NewIFContainer {
		ScreenRelativeX = 1,
		ScreenRelativeY = 0.5,
		y = -30, -- go down a little to make space for playername up top
	},

	TargetName = "",
--	bVoicemailOnly = 1,
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

		local k,v
		for k,v in mpxl_feedback_vbutton_layout.buttonlist do
			local Tag = v.tag
			this.buttons[Tag].hidden = (v.bVoicemailOnly ~= this.bVoicemailOnly)
			this.buttonlabels[Tag].hidden = (v.bVoicemailOnly ~= this.bVoicemailOnly)
		end

		ShowHideVerticalText(this.buttonlabels,mpxl_feedback_vbutton_layout)
		this.CurButton = ShowHideVerticalButtons(this.buttons,mpxl_feedback_vbutton_layout)
		SetCurButton(this.CurButton)

		ifs_mpxl_feedback_fnShowItems(this,1)
		IFText_fnSetString(this.PlayerName,this.TargetName)
	end,

	Exit = function(this, bFwd)
		this.bVoicemailOnly = nil
	end,

	Update = function(this, fDt)
		-- Call default base class's update function (make button bounce)
		gIFShellScreenTemplate_fnUpdate(this,fDt)

		-- Lobby might be active (if we entered thru it). Update it.
		ScriptCB_UpdateLobby(nil)
	end,

	Input_Accept = function(this)
		if((this.CurButton == "session") or (this.CurButton == "attitude")) then
			-- Positive feedback requires no confirmation
			ScriptCB_SendFeedback(this.TargetName,this.CurButton)
			ScriptCB_PopScreen()
		else
			-- Need to open prompt dialog before negative feedback
			Popup_YesNo.CurButton = "no" -- default
			Popup_YesNo.fnDone = ifs_mpxl_feedback_fnAskedNegative

			-- Initialize this with something, anything.
			local FeedbackUStr = ScriptCB_tounicode(this.TargetName)

			local i
			for i=1,table.getn(mpxl_feedback_vbutton_layout.buttonlist) do
				if(this.CurButton == mpxl_feedback_vbutton_layout.buttonlist[i].tag) then
					FeedbackUStr = ScriptCB_getlocalizestr(mpxl_feedback_vbutton_layout.buttonlist[i].string)
				end
			end

			local TitleUStr = ScriptCB_usprintf("ifs.xfeedback.sendprompt",FeedbackUStr)
			Popup_YesNo:fnActivate(1)
			gPopup_fnSetTitleUStr(Popup_YesNo, TitleUStr)
			ifs_mpxl_feedback_fnShowItems(this,nil)
		end
	end,

	-- No L/R functionality possible on this screen (gotta have stubs
	-- here, or the base class will override)
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,
}

function ifs_mpxl_feedback_fnBuildScreen(this)
	AddVerticalText(this.buttonlabels,mpxl_feedback_vbutton_layout)
	this.CurButton = AddVerticalButtons(this.buttons,mpxl_feedback_vbutton_layout)
end

ifs_mpxl_feedback_fnBuildScreen(ifs_mpxl_feedback)
ifs_mpxl_feedback_fnBuildScreen = nil

AddIFScreen(ifs_mpxl_feedback,"ifs_mpxl_feedback")
ifs_mpxl_feedback = DoPostDelete(ifs_mpxl_feedback)
