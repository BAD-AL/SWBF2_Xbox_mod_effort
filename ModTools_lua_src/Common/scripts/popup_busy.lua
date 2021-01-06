--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- General handler for a "Busy..." dialog for the front end

CancelButton_layout = {
	yTop = 0,
	width = 300,
	font = gPopupButtonFont,
	buttonlist = { 
		{ tag = "cancel", string = "common.cancel", },
	},
	nocreatebackground = 1,
}


-- Does any work to activate this
function gPopup_Busy_fnActivate(this,vis)
	this:fnDefaultActivate(vis)
	if(vis) then
		ShowHideVerticalButtons(this.buttons,CancelButton_layout)

		-- sanity check that required callbacks are set up
		assert(this.fnCheckDone)
		assert(this.fnOnSuccess)
		assert(this.fnOnFail)
		assert(this.fnOnCancel)

		-- Error popup might have set our alpha to 0. Reset it.
		IFObj_fnSetAlpha(Popup_Busy,1.0)

		this.fBusyTime = 0 -- Clear timer
		this.fBusyTimeFloor = -1 -- Clear timer for display

		-- 1 button, it's selected, hilighted, etc
		this.CurButton = "cancel"
		IFButton_fnSelect(this.buttons[this.CurButton],1)
		gCurHiliteButton = this.buttons[this.CurButton]

		IFObj_fnSetVis(this.buttons, not this.bNoCancel)

		-- Reset string to default ASAP
		if(not this.bCallerSetsString) then
			local TimeUStr = ScriptCB_usprintf("ifs.busytime",
																				 ScriptCB_tounicode(string.format("%d",this.fBusyTimeFloor)))
		end
	else -- disabling this screen
		this.bCallerSetsString = nil -- clean up after this.
		this.iOnlyJoystick = nil -- ditto
	end
end

-- Handle the user hitting accept (back uses defaults). Close this popup,
-- let things know who won
function gPopup_Busy_fnInput_Accept(this, iJoystick)
	print("Busy, input_accept. iJoystick = ", iJoystick, "iOnlyJoystick = ", this.iOnlyJoystick)
	if(this.iOnlyJoystick) then
		if(this.iOnlyJoystick ~= (iJoystick + 1)) then
			print("Wrong joystick! Ignoring!")
			return
		end
	end

	if(this.CurButton == "cancel") then
		if(not this.bNoCancel) then
			-- Default: hide this.
			gPopup_Busy_fnActivate(this,nil)
	
			-- Do callback
			if(this.fnOnCancel) then
				this.fnOnCancel()
			end
		end
	end
end

Popup_Busy = NewPopup {
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.5,
	height = 200,
	width = 400,
	ZPos = 50,

	title = NewIFText {
		font = gPopupTextFont,
		textw = 380,
		texth = 120,
		y = -80,
		nocreatebackground = 1,
	},

	BusyTimeStr = NewIFText {
		font = gPopupTextFont,
		textw = 380,
		texth = 120,
		y = 0,
		nocreatebackground = 1,
	},

	buttons = NewIFContainer {
		y = 50,
	},

	fnSetMode = gPopup_Busy_fnSetMode,
	fnActivate = gPopup_Busy_fnActivate,
	Input_Accept = gPopup_Busy_fnInput_Accept,
	Input_Back = gPopup_Busy_fnInput_Accept,

	fBusyTime = 0, -- Clear timer
	fBusyTimeFloor = -1, -- Clear timer for display (math.floor of fBusyTime)

	Update = function(this, fDt)
		local IsDone = this.fnCheckDone()

		this.fBusyTime = this.fBusyTime + fDt
		-- force a press of the cancel button if it goes too long
		if((this.fTimeout) and (this.fBusyTime > this.fTimeout)) then
			IsDone = -1
			this.fTimeout = nil -- don't hammer on fnOnFail
		end

		local bWaitingOnMin
		if((this.fMinTimeout) and (this.fBusyTime < this.fMinTimeout)) then
			bWaitingOnMin = 1
		end

		if((IsDone > 0.5) and not bWaitingOnMin) then
			this.fMinTimeout = nil
			this.fnOnSuccess()
		elseif ((IsDone < -0.5)  and not bWaitingOnMin) then
			this.fMinTimeout = nil
			this.fnOnFail()
		else
			if(not this.bCallerSetsString) then
				local fTimeFloor = math.floor(this.fBusyTime)
				if(this.fBusyTimeFloor ~= fTimeFloor) then
					this.fBusyTimeFloor = fTimeFloor
					local TimeUStr = ScriptCB_usprintf("ifs.busytime",
																						 ScriptCB_tounicode(string.format("%d",this.fBusyTimeFloor)))
					IFText_fnSetUString(this.BusyTimeStr,TimeUStr)
				end -- string needs a change
			end -- we manage string
		end

	end,

	-- Must be specified by caller
	-- fnCheckDone() -- returns -1 (failure), 0 (pending), or 1 (success)
	-- fnOnSuccess() -- what to do when succeeds
	-- fnOnFail()
	-- fnOnCancel()
}

AddVerticalButtons(Popup_Busy.buttons,CancelButton_layout)

CreatePopupInC(Popup_Busy,"Popup_Busy")
Popup_Busy = DoPostDelete(Popup_Busy)