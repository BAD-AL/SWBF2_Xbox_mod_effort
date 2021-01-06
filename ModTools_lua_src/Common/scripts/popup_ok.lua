--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- General handler for a "Ok" dialog

-- Does any work to activate this
function gPopup_Ok_fnActivate(this,vis)
	this:fnDefaultActivate(vis)
	if(vis) then
		local TagOfFirst, BtnWidth
		TagOfFirst, BtnWidth = ShowHideVerticalButtons(this.buttons,OkButton_layout)
		this.fMinWidth = BtnWidth + 20

		-- 1 button, it's selected, hilighted, etc
		this.CurButton = "ok"
		IFButton_fnSelect(this.buttons[this.CurButton],1)
		gCurHiliteButton = this.buttons[this.CurButton]
	end
end

-- Handle the user hitting accept (back uses defaults). Close this popup,
-- let things know who won
function gPopup_Ok_fnInput_Accept(this, iJoystick)

	print("Ok, input_accept. iJoystick = ", iJoystick, "iOnlyJoystick = ", this.iOnlyJoystick)
	if(this.iOnlyJoystick) then
		if(this.iOnlyJoystick ~= (iJoystick + 1)) then
			print("Wrong joystick! Ignoring!")
			return
		end
	end


	-- Default: hide this.
	gPopup_Ok_fnActivate(this,nil)

	-- Call callback if applicable, w/ result (nil = no, other = yes)
    ifelm_shellscreen_fnPlaySound("shell_menu_accept")
	if(this.fnDone) then
		this.fnDone()
	end
end

Popup_Ok = NewPopup {
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.5,
	height = 180,
	width = 260,
	ZPos = 50,
	ButtonHeightHint = 45,

	title = NewIFText {
		font = gPopupTextFont,
		textw = 220,
		texth = 120,
		y2 = -80,
		flashy=0,
	},

	buttons = NewIFContainer {
		y = 40,
	},

	fnSetMode = gPopup_Ok_fnSetMode,
	fnActivate = gPopup_Ok_fnActivate,
	Input_Accept = gPopup_Ok_fnInput_Accept,

	Input_Back = gPopup_Ok_fnInput_Accept,
}

AddVerticalButtons(Popup_Ok.buttons,OkButton_layout)
Popup_Ok.buttons.x2 = Popup_Ok.buttons.x

CreatePopupInC(Popup_Ok,"Popup_Ok")
Popup_Ok = DoPostDelete(Popup_Ok)
