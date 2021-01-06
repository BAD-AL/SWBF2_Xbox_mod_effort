--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


local LoadSaveButtons_layout = {
	yTop = -85,
	ySpacing  = 5,
	width = 280,
	font = "gamefont_small",
	buttonlist = { 
		{ tag = "A", string = "common.yes", },
		{ tag = "B", string = "common.no", },
		{ tag = "C", string = "common.no", },
	},
	nocreatebackground = 1,
}

function gPopup_LoadSave_fnSetMode(this, NewMode)
	-- Do nothing if already set.
	if(this.mode == NewMode) then
		return
	end

	this.mode = NewMode

	-- Set visibility of buttons as needed
	if(this.mode == "OK") then
		-- 1 button
		IFObj_fnSetVis(this.buttons.A,nil)
		IFObj_fnSetVis(this.buttons.B,nil)
		IFObj_fnSetVis(this.buttons.C,1)
	elseif (this.mode == "FORMAT_NOSAVE") then
		-- 3 buttons 
		IFObj_fnSetVis(this.buttons.A,1)
		IFObj_fnSetVis(this.buttons.B,1)
		IFObj_fnSetVis(this.buttons.C,1)
	else
		-- 2 buttons 
		IFObj_fnSetVis(this.buttons.A,nil)
		IFObj_fnSetVis(this.buttons.B,1)
		IFObj_fnSetVis(this.buttons.C,1)
	end

	-- Adjust visibility of buttons
	if(this.mode == "NOTIFY") then
		IFObj_fnSetVis(this.buttons,nil)
	else
		IFObj_fnSetVis(this.buttons,1)
	end

	-- Set text of buttons as needed
	if(this.mode == "OK") then
		RoundIFButtonLabel_fnSetString(this.buttons.C,"common.ok")
	elseif (this.mode == "YESNO") then
		RoundIFButtonLabel_fnSetString(this.buttons.B,"common.no")
		RoundIFButtonLabel_fnSetString(this.buttons.C,"common.yes")
	elseif (this.mode == "RETRY") then
		RoundIFButtonLabel_fnSetString(this.buttons.B,"common.retry")
		RoundIFButtonLabel_fnSetString(this.buttons.C,"ifs.subMemcard.continueNoSave")
	elseif (this.mode == "FORMAT_NOSAVE") then
		RoundIFButtonLabel_fnSetString(this.buttons.A,"ifs.subMemcard.opFormat")
		RoundIFButtonLabel_fnSetString(this.buttons.B,"common.retry")
		RoundIFButtonLabel_fnSetString(this.buttons.C,"ifs.subMemcard.continueNoSave")
	elseif (this.mode == "MANAGE_NOSAVE") then
		RoundIFButtonLabel_fnSetString(this.buttons.B,"ifs.subHarddrive.manage")
		RoundIFButtonLabel_fnSetString(this.buttons.C,"ifs.subMemcard.continueNoSave")
	elseif (this.mode == "MANAGEFILES_NOSAVE") then
		RoundIFButtonLabel_fnSetString(this.buttons.B,"ifs.subHarddrive.managefiles")
		RoundIFButtonLabel_fnSetString(this.buttons.C,"ifs.subMemcard.continueNoSave")
	end

end

-- Does any work to activate this
function gPopup_LoadSave_fnActivate(this,vis)
	this:fnDefaultActivate(vis)
	if(vis) then
		-- Default: no is selected.
		this.CurButton = "C"
		IFButton_fnSelect(this.buttons.A,nil)
		IFButton_fnSelect(this.buttons.B,nil)
		IFButton_fnSelect(this.buttons.C,1)
		gCurHiliteButton = this.buttons.C
	end
end


-- Handle the user hitting accept. Pass on to game.
function gPopup_LoadSave_fnInput_Accept(this)
	if(this.mode ~= "NOTIFY") then
        ifelm_shellscreen_fnPlaySound("shell_menu_accept")
		if(this.CurButton == "A") then
			ScriptCB_LoadSavePopupResult(3)
		elseif (this.CurButton == "B") then
			ScriptCB_LoadSavePopupResult(2)
		elseif (this.CurButton == "C") then
			ScriptCB_LoadSavePopupResult(1)
		else
			print("Unusual button for popup_loadsave,",this.CurButton)
		end
	else
        ifelm_shellscreen_fnPlaySound("shell_menu_cancel")
		-- No buttons visible. Must ignore press
	end
end

-- Handle the user hitting back button. Do nothing if in a mode that
-- one can't cancel from.
function gPopup_LoadSave_fnInput_Back(this)
	if(this.mode ~= "NOTIFY") then
		-- Go to default button, act like the user hit it.
		this.CurButton = "A"
		gPopup_LoadSave_fnInput_Accept(this)
	else
		-- No buttons visible. Must ignore press
	end
end

Popup_LoadSave = NewPopup {
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.6,
	height = 220,
	width = 400,
	ZPos = 50,

	title = NewIFText {
		font = "gamefont_medium",
		textw = 370,
		texth = 180,
		y = -100,
		inert = 1,
		nocreatebackground = 1,
	},

	buttons = NewIFContainer {
		y = 60,
	},

	fnSetMode = gPopup_LoadSave_fnSetMode,
	fnActivate = gPopup_LoadSave_fnActivate,
	Input_Accept = gPopup_LoadSave_fnInput_Accept,
	Input_Back = gPopup_LoadSave_fnInput_Back,
}

AddVerticalButtons(Popup_LoadSave.buttons,LoadSaveButtons_layout)

CreatePopupInC(Popup_LoadSave,"Popup_LoadSave")
