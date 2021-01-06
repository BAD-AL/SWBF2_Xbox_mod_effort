--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

OkButton_layout = {
	yTop = 0,
	width = 300,
	font = gPopupButtonFont,
	buttonlist = { 
		{ tag = "ok", string = "common.ok", },
	},
--	nocreatebackground = 1,
}

ActiveButton_layout = {
	yTop = 0,
	width = 300,
	font = gPopupButtonFont,
	buttonlist = { 
		{ tag = "ok", string = "common.meta.active", },
	},
--	nocreatebackground = 1,
}

-- BF2 is all vertical - NM 7/19/05

-- Hor iz_YesNoButtons_layout = {
-- 	yTop = 0,
-- 	width = 300,
-- 	font = gPopupButtonFont,
-- 	buttonlist = { 
-- 		{ tag = "yes", string = "common.yes", },
-- 		{ tag = "no", string = "common.no", },
-- 	},
-- --	nocreatebackground = 1,
-- }

-- Hor iz_YesNoButtons_layout_Wide = {
-- 	yTop = 0,
-- 	width = 300,
-- 	font = gPopupButtonFont,
-- 	buttonlist = { 
-- 		{ tag = "A", string = "common.yes", },
-- 		{ tag = "B", string = "common.no", },
-- 	},
-- --	nocreatebackground = 1,
-- }

Vertical_YesNoButtons_layout = {
	yTop = 1,
	width = 300,
	font = gPopupButtonFont,
	buttonlist = { 
		{ tag = "yes", string = "common.yes", },
		{ tag = "no", string = "common.no", },
	},
	nocreatebackground = 1,
}

-- Support code 

function gPopup_fnSetTitle_Internal(this, MsgStr, MsgUStr)
	local EntryW, EntryH = this.width, this.height
--	print("popup, setting title Internal", this.width, this.height)

	-- Pass 1: try narrowing popup's width a little

	local TotalW = (this.width * 0.75) - 32

	if(this.fMinWidth) then
		TotalW = math.max(TotalW, this.fMinWidth)
	end

	IFText_fnSetTextBox(this.title, TotalW, this.height)
	IFObj_fnSetPos(this.title, TotalW * -0.5, this.title.y2)
	if(MsgUStr) then
		IFText_fnSetUString(this.title, MsgUStr)
	else
		IFText_fnSetString(this.title, MsgStr)
	end

	local l, t, r, b = IFText_fnGetDisplayRect(this.title)
	local TextW = r - l
	local TextH = b - t
--	print("Pass 1, got W, H = ", TextW, TextH)

	-- Determine if this is "too much" text, and fall back to full size if needed.
	if((this.bNoThinPopup) or (TextH > (this.height * 0.45)) or 
		 (TotalW < (gButtonWidthPad * 1.5))) then
		-- Too tall. Gotta go back to full width
		TotalW = (this.width) - 32

		if(this.fMinWidth) then
			TotalW = math.max(TotalW, this.fMinWidth)
		end

		IFText_fnSetTextBox(this.title, (this.width) - 32, this.height)
		IFObj_fnSetPos(this.title, TotalW * -0.5, this.title.y2)
		if(MsgUStr) then
			IFText_fnSetUString(this.title, MsgUStr)
		else
			IFText_fnSetString(this.title, MsgStr)
		end
		l, t, r, b = IFText_fnGetDisplayRect(this.title)
		TextW = r - l
		TextH = b - t

--		print("Pass 2, got W, H = ", TextW, TextH)
	end

	if(this.fMinWidth) then
		TextW = math.max(TextW, this.fMinWidth)
	end

	-- Now, set window size
	local BoxH = TextH + gPopupWidthPad + (this.ButtonHeightHint or 50)
	local BoxW = TextW + gPopupHeightPad
	gButtonWindow_fnSetSize(this, BoxW, BoxH)
	IFObj_fnSetPos(this.skin, 0, this.title.y2 + BoxH * 0.5 - 16)
	IFObj_fnSetPos(this.buttons, this.buttons.x2, this.title.y2 + TextH + (this.TitleHeightHint or 14))

	this.LastTextW = TextW - 16 -- store this in case we want to read it later

	-- Ensure total box size gets properly restored for later
	this.width, this.height = EntryW, EntryH
end

function gPopup_fnSetTitleUStr(this, MsgUStr)
	gPopup_fnSetTitle_Internal(this, nil, MsgUStr)
end

function gPopup_fnSetTitleStr(this, MsgStr)
	gPopup_fnSetTitle_Internal(this, MsgStr, nil)
end
