--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- General handler for a Yes/No 


Popup_YesNo_Large = NewPopup {
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.5,
	height = 220,
	width = 440,
	ButtonHeightHint = 70,
	ZPos = 50,

	title = NewIFText {
		font = gPopupTextFont,
		textw = 410,
		texth = 160,
		y2 = -100,
		flashy = 0,
	},

	buttons = NewIFContainer {
		y = 40,
	},

	fnSetMode = gPopup_YesNo_fnSetMode,
	fnActivate = gPopup_YesNo_fnActivate,
	Input_Accept = gPopup_YesNo_fnInput_Accept,
	-- Be more XBox-compliant
	Input_Back = function(this)
		this.CurButton = "no"
        ifelm_shellscreen_fnPlaySound("shell_menu_cancel")
		gPopup_YesNo_fnInput_Accept(this)
	end,
}

AddVerticalButtons(Popup_YesNo_Large.buttons, Vertical_YesNoButtons_layout)
Popup_YesNo_Large.buttons.x2 = Popup_YesNo_Large.buttons.x

CreatePopupInC(Popup_YesNo_Large,"Popup_YesNo_Large")

Popup_YesNo_Large = DoPostDelete(Popup_YesNo_Large)

