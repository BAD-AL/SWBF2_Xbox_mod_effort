--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- General handler for a Yes/No 

-- Does any work to activate this
function gPopup_YesNo_fnActivate(this,vis)
	this:fnDefaultActivate(vis)
	if(vis) then
--		print("In Popup_YesNo_fnActivate")

		-- Fix for 9727 - hide host screen's "back" helptext, if found. NM
		-- 8/11/05
		if(gCurScreenTable and gCurScreenTable.Helptext_Back) then
			this.EntryScreenTable = gCurScreenTable
			this.bBackVis = IFObj_fnGetVis(gCurScreenTable.Helptext_Back)
			IFObj_fnSetVis(gCurScreenTable.Helptext_Back, nil)
		else
			this.EntryScreenTable = nil
		end

		local TagOfFirst, BtnWidth
		TagOfFirst, BtnWidth = ShowHideVerticalButtons(this.buttons, Vertical_YesNoButtons_layout)
		this.fMinWidth = BtnWidth + 20

		-- Default: "yes" is selected, if not already set
		this.CurButton = this.CurButton or "yes"

		-- A little extra work, but shouldn't be too bad: deselect all
		-- buttons on entry
		IFButton_fnSelect(this.buttons.no,nil)
		IFButton_fnSelect(this.buttons.yes,nil)

		-- Select right button.
		IFButton_fnSelect(this.buttons[this.CurButton],1)
		gCurHiliteButton = this.buttons[this.CurButton]
		
		-- accept input from all controllers
		if (ifs_saveop and ifs_saveop.saveProfileNum) then
			this.iOnlyJoystick = ifs_saveop.saveProfileNum
		end
		if(this.iOnlyJoystick) then
			this.wasRead = ScriptCB_SetHotController(this.iOnlyJoystick)
		end
	else
		-- restore previous input state
		if(this.iOnlyJoystick) then
			ScriptCB_SetHotController(this.wasRead)
			this.wasRead = nil
			this.iOnlyJoystick = nil -- clean up after screen
		end

		if(this.EntryScreenTable) then
			IFObj_fnSetVis(this.EntryScreenTable.Helptext_Back, this.bBackVis)
			this.EntryScreenTable = nil
		end
	end
end

-- Handle the user hitting accept (back uses defaults). Close this popup,
-- let things know who won
function gPopup_YesNo_fnInput_Accept(this,iJoystick)
	-- only accept it if you actually hit a button
	if(this.CurButton) then
		-- Default: hide this.
		gPopup_YesNo_fnActivate(this,nil)

		-- Call callback if applicable, w/ result (nil = no, other = yes)
		ifelm_shellscreen_fnPlaySound("shell_menu_accept")
		if(this.fnDone) then
			this.fnDone(this.CurButton == "yes")
		--else
		--    ifelm_shellscreen_fnPlaySound("shell_menu_cancel")
		end
	end
end

function gPopup_YesNo_fnInput_GeneralUp(this,iJoystick)
	gDefault_Input_GeneralUp(this,iJoystick)
end

function gPopup_YesNo_fnInput_GeneralDown(this,iJoystick)
	gDefault_Input_GeneralDown(this,iJoystick)
end


Popup_YesNo = NewPopup {
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.5,
	height = 180,
	width = 300,
	ButtonHeightHint = 75,
	ZPos = 50,

	title = NewIFText {
--		string = "Busy w/ Memcard",
		font = gPopupTextFont,
		textw = 260,
		texth = 120,
		y2 = -80,
		flashy = 0,
	},

	buttons = NewIFContainer {
-- 		ScreenRelativeX = 0.5, -- centered onscreen
-- 		ScreenRelativeY = 0.5,
		y = 20,
	},

	fnSetMode = gPopup_YesNo_fnSetMode,
	fnActivate = gPopup_YesNo_fnActivate,
	Input_Accept = function(this, iJoystick)
									 gPopup_YesNo_fnInput_Accept(this, iJoystick)
								 end,
	Input_GeneralUp = gPopup_YesNo_fnInput_GeneralUp,
	Input_GeneralDown = gPopup_YesNo_fnInput_GeneralDown,
	
	
	-- allowing this violates all kinds of load save tcrs, both on xbox and ps2.  mostly because
	-- it isn't "positive confirmation" of a destructive action.  if it is needed other places we
	-- should special case it with a flag or something
	-- Be more XBox-compliant
	Input_Back = function(this)
	--	 this.CurButton = "no"
	--	 gPopup_YesNo_fnInput_Accept(this)
	end,
}

AddVerticalButtons(Popup_YesNo.buttons, Vertical_YesNoButtons_layout)
Popup_YesNo.buttons.x2 = Popup_YesNo.buttons.x

CreatePopupInC(Popup_YesNo,"Popup_YesNo")
Popup_YesNo = DoPostDelete(Popup_YesNo)
