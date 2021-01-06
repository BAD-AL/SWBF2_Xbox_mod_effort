--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- General handler for a "Error" dialog. 

-- Does any work to activate this. Vis is nil if off, or a float in
-- the following list (out of FLGuiManager.h)

-- 	enum eErrorSeverity {
-- 		ERROR_NONE = 0,				// no error
-- 		OLD_ERROR_PAD_MISSING = 1, // Pauses SP, dialog in MP
-- 		ERROR_WARNING = 2,			// no ui steps required
-- 		ERROR_DELAY = 3,			// no ui steps required, but add a delay to return
-- 		ERROR_SUBSCREEN = 4,		// error in subscreen, bail one screen
-- 		ERROR_IGNORE_OR_REBOOT = 5,	// optional reboot to dashboard
-- 		ERROR_LEAVE_SESSION = 6,	// must leave the current session
--		ERROR_LOGOFF_SECONDARY,			// 7 - must disconnect secondary player only (XLive)
--		ERROR_LOGOFF,			// 8 - must disconnect all players
--		ERROR_LOGOFF_CABLE,		// 9 - cable out, must disconnect
--		ERROR_LOGOFF_OR_REBOOT,	// 10 - must logoff, optional reboot to dashboard
--		ERROR_REBOOT,			// 11 - must reboot to dashboard
--		ERROR_MISSING_DC,		// 12 - client missing a downloadable content map in MP
--		ERROR_PAD_MISSING, // 13 - Pauses SP, dialog in MP [new one, bumped priority above net - NM 7/1/04]
-- 	};

-- The OK button is shown for anything ERROR_SUBSCREEN or higher

function gPopup_Error_fnActivate(this,vis)
	print("Error_fnActivate. vis = ", vis)
	if(vis) then

		-- Hack for bug 7600 - ifs_mp_lobby_quick's fnPostError gets no error
		-- reported, as it's been cleared by then. So, store a copy of the
		-- last error, as long as it's not a controller-pulled error.
		if(vis < 13) then
			this.iLastNetError = vis
		end

		-- Hide busy popup if present by making it transparent.
		-- [Artists want everything transparent, which makes showing both
		-- at once very visually confusing]
		if(Popup_Busy) then
			IFObj_fnSetAlpha(Popup_Busy,0.0)
		end

		-- HACK for 3774, 6326 - hide DNAS stuff if present (only in PS2 shell)
		-- Thou shalt have no bitmaps before the DNAS logo.
		if(ifs_mpps2_dnas and ifs_mpps2_dnas.dnasImg) then
			IFObj_fnSetVis(ifs_mpps2_dnas.dnasImg, nil)
			IFObj_fnSetVis(ifs_mpps2_dnas.dnasTM, nil)
			IFObj_fnSetVis(ifs_mpps2_dnas.buttons, nil)
			IFObj_fnSetVis(ifs_mpps2_dnas.errorText, nil)
		end

		-- Fix for 10993, 11067 - hide any popups, because the artists cannot be
		-- severed from their love of transparency. Two popups in the same
		-- space is unreadable. - NM 8/19/05
		if(Popup_Ok) then
			IFObj_fnSetVis(Popup_Ok, nil)
		end
		if(Popup_YesNo) then
			IFObj_fnSetVis(Popup_YesNo, nil)
		end
		if(Popup_YesNo_Large) then
			IFObj_fnSetVis(Popup_YesNo_Large, nil)
		end
		if(Popup_LoadSave2) then
			IFObj_fnSetVis(Popup_LoadSave2, nil)
		end
		if(Popup_Tutorial) then
			IFObj_fnSetVis(Popup_Tutorial, nil)
		end
		if(Popup_YesNo_Gamespy) then
			IFObj_fnSetVis(Popup_YesNo_Gamespy, nil)
		end
		if(Popup_Ask_Historical) then
			IFObj_fnSetVis(Popup_Ask_Historical, nil)
		end
		if(Popup_Ok_Large) then
			IFObj_fnSetVis(Popup_Ok_Large, nil)
		end

		if(Popup_LobbyOpts and (Popup_LobbyOpts.bIsActivated)) then
			Popup_LobbyOpts:fnActivate(nil)
		end

		this.bShowButtons = (vis > 3)
		if(this.bShowButtons) then
			this.bShowOk = (vis == 4) or ((vis >=6) and (vis <= 9)) or (vis == 11) or (vis == 13)

			if(this.bShowOk) then
				IFButton_fnSelect(this.buttons.no,nil)
				this.CurButton = "yes"
				IFButton_fnSelect(this.buttons.yes,1)
				this.buttons.no.hidden = 1
				RoundIFButtonLabel_fnSetString(this.buttons.yes,"common.ok")
			else
				IFButton_fnSelect(this.buttons.yes,nil)
				this.CurButton = "no"
				IFButton_fnSelect(this.buttons.no,1)
				this.buttons.no.hidden = nil
				RoundIFButtonLabel_fnSetString(this.buttons.yes,"common.yes")
			end

			ShowHideVerticalButtons(this.buttons, Vertical_YesNoButtons_layout)
			gCurHiliteButton = this.buttons[this.CurButton]
			IFObj_fnSetVis(this.buttons,(vis ~= 11))
		else
			this.CurButton = "no"
--			IFButton_fnSelect(this.buttons[this.CurButton],nil)
--			gCurHiliteButton = nil
			IFObj_fnSetVis(this.buttons,nil)
		end
	end

	-- Hack workaround for bug 6841 - turn off second "no controllers" message
	-- if present
	if((ifs_boot) and (ifs_boot.title)) then
		IFObj_fnSetVis(ifs_boot.title, not vis)
	end

end


-- Handle the user hitting accept (back uses defaults). Close this popup,
-- let things know who won
function gPopup_Error_fnInput_Accept(this)
	if(this.bShowButtons) then
		local ErrorLevel,ErrorMessage = ScriptCB_GetError()
		print("In gPopup_Error_fnInput_Accept")
		-- Default: hide this.

		local bUserHitYes = (this.CurButton == "yes") -- or 'Ok', same thing
		ScriptCB_CloseErrorBox(bUserHitYes)

		-- Call callback if applicable, w/ result (nil = no, other = yes)
		ScriptCB_SndPlaySound("shell_menu_ok")
		if(this.fnDone) then
			this.fnDone()
		end

		ifelem_shellscreen_fnPostControllerError()

		if(gCurScreenTable and (gCurScreenTable.fnPostError)) then
			gCurScreenTable.fnPostError(gCurScreenTable,bUserHitYes,ErrorLevel,ErrorMessage)
--		else
--			print("Uhoh, current screen has no post-error handler!")
		end

	end
end

Popup_Error = NewPopup {
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.5,
	height = 270,
	width = 440,
	ButtonHeightHint = 70,
	ZPos = 0,

	title = NewIFText {
		font = gPopupTextFont,
		textw = 415,
		texth = 170,
		y2 = -115,
		valign = "top", 
		nocreatebackground = 1,
	},

	buttons = NewIFContainer {
		y = 95,
	},

	fnSetMode = gPopup_Error_fnSetMode,
	fnActivate = function(this,vis)
		gPopup_Error_fnActivate(this,vis)
	end,
	fnSetTitle = function(this, MsgUStr)
		gPopup_fnSetTitleUStr(this, MsgUStr)
	end,

	Input_Accept = function(this)
		gPopup_Error_fnInput_Accept(this)
	end,
	Input_Back = function(this)
		this.CurButton = "no"
		gPopup_Error_fnInput_Accept(this)
	end,

	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt)
		ScriptCB_UpdateLobby(nil)
	end,

	fnPostMissingController = function(this)
		if(gCurScreenTable and gCurScreenTable.fnPostMissingController) then
			gCurScreenTable.fnPostMissingController(gCurScreenTable)
		end
	end,
}

Popup_Error.CurButton = AddVerticalButtons(Popup_Error.buttons, Vertical_YesNoButtons_layout)
Popup_Error.buttons.x2 = Popup_Error.buttons.x
gButtonWindow_fnSetTexture(Popup_Error,"opaque_rect")

CreatePopupInC(Popup_Error,"Popup_Error")
Popup_Error = DoPostDelete(Popup_Error)
