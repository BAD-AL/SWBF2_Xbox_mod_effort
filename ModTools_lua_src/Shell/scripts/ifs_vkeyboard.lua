--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Virtual Keyboard for consoles
--

-- This code opens up a shell screen that has a keyboard, and
-- stores what the user set. 

-- Params for the keyboard
vkeyboard_specs = {
	NumRows = 4,
	NumColumns = 13,
	MaxLen = 15, -- Max len of string (in chars) that can be entered
	MaxWidth = 150,
	fnDone = nil, -- Callback function to do something when the user is done
}


-- Helper function - sees if the current string could be added to
-- iAscii will be nil when using the dpad, or valid if going thru
function IFS_VKeyboard_fnCouldAddChar(this, iAscii)

	local StringLen = string.len(this.WorkString)

--	print("fnCouldAdd, string.len=", StringLen, "iKeyOffset = ",iKeyOffset)

	local CurPixelLen = IFText_fnGetExtent(this.buttons.DisplayString)
	-- Always clamp against length
	if ((StringLen >= vkeyboard_specs.MaxLen) or
			(CurPixelLen >= vkeyboard_specs.MaxWidth)) then
		return nil
	end
	
	if(iAscii) then
		-- If this is the first character, don't allow space to be set.
		if((StringLen < 1) and (iAscii == 32)) then
			return nil
		end

		if((vkeyboard_specs.bGamespyMode) and (string.len(this.WorkString) < 1)) then
			local FirstChar = string.char(iAscii)
			if((FirstChar == "@") or (FirstChar == "+") or (FirstChar == ":") or (FirstChar == "#")) then
				Popup_Ok.fnDone = ifs_vkeyboard_fnGamespy1stCharOk
				Popup_Ok:fnActivate(1)
				gPopup_fnSetTitleStr(Popup_Ok, "ifs.gsprofile.badchars2")
				ifs_vkeyboard_fnSetPieceVis(this,nil)
				return nil
			end
		end

		return 1 -- ok to add


	else
		local iKeyOffset = this.fCharOffset + this.CursorY*(vkeyboard_specs.NumColumns) + this.CursorX

		if((vkeyboard_specs.bGamespyMode) and (string.len(this.WorkString) < 1)) then
			if((string.len(this.WorkString) < 1) and 
				 ((iKeyOffset == (13*5+1)) or (iKeyOffset == (13*5+10)) or (iKeyOffset == (13*6+8)) or (iKeyOffset == (13*4+10)))) then

				Popup_Ok.fnDone = ifs_vkeyboard_fnGamespy1stCharOk
				Popup_Ok:fnActivate(1)
				gPopup_fnSetTitleStr(Popup_Ok, "ifs.gsprofile.badchars2")
				ifs_vkeyboard_fnSetPieceVis(this,nil)
				return nil
			end
		end

		-- If this is the first character, don't allow space to be set.
		if((StringLen < 1) and (iKeyOffset == (13*5+0))) then
			return nil
		end
		
		return 1
	end
end

-- Helper function: turns pieces on/off as requested
function ifs_vkeyboard_fnSetPieceVis(this,bNormalVis)
	IFObj_fnSetVis(this.deletegroup,bNormalVis)
	IFObj_fnSetVis(this.modegroup,bNormalVis)
	--		IFObj_fnSetVis(this.startgroup,bNormalVis)
	
	IFObj_fnSetVis(this.buttons,bNormalVis)
end

function ifs_vkeyboard_fnErrOk()
	local this = ifs_vkeyboard
	ifs_vkeyboard_fnSetPieceVis(this,1)
end

function ifs_vkeyboard_fnGamespy1stCharOk()
	local this = ifs_vkeyboard
	ifs_vkeyboard_fnSetPieceVis(this,1)
end

-- Converts the cursor's position from the hilighted button
function IFS_VKeyboard_ButtonXFromCursor(this)
	if(this.CurButton == "cancel") then
		this.CursorX = math.floor(vkeyboard_specs.NumColumns * 0.15)
	elseif (this.CurButton == "back") then
		this.CursorX = math.floor(vkeyboard_specs.NumColumns * 0.5)
	else
		this.CursorX = math.floor(vkeyboard_specs.NumColumns * 0.85)
	end
end

-- Converts the bottom button's position
function IFS_VKeyboard_CursorFromButtonX(this)
	if(this.CursorX < (vkeyboard_specs.NumColumns * 0.30)) then
		this.CurButton = "cancel"
	elseif (this.CursorX < (vkeyboard_specs.NumColumns * 0.67)) then
		this.CurButton = "back"
	else
		this.CurButton = "ok"
	end
	IFButton_fnSelect(this.buttons[this.CurButton],1)
	gCurHiliteButton = this.buttons[this.CurButton]
end

-- Regets the keys depending on the current mode
function IFS_VKeyboard_fnRegetKeys(this)
	local i,j
	for i=1,vkeyboard_specs.NumRows do
		for j=1,vkeyboard_specs.NumColumns do
			local Offset =  (i-1)*(vkeyboard_specs.NumColumns) + (j-1) -- C counts from 0
			local KeyOffset = this.fCharOffset + Offset
			IFText_fnSetString(this.buttons[Offset],ScriptCB_GetVKeyboardCharacter(KeyOffset))

			
			local ShowAlpha = 1
			IFObj_fnSetAlpha(this.buttons[Offset],ShowAlpha)
		end
	end
end

-- Helper function: moves the cursor
function IFS_VKeyboard_MoveCursor(this)

	-- 
	local i,j
	for i=1,vkeyboard_specs.NumRows do
		for j=1,vkeyboard_specs.NumColumns do
			local Offset =  (i-1)*(vkeyboard_specs.NumColumns) + (j-1) -- C counts from 0
			IFObj_fnSetColor(this.buttons[Offset], gUnselectedTextColor[1], gUnselectedTextColor[2], gUnselectedTextColor[3])
		end
	end

	if(this.CursorY < vkeyboard_specs.NumRows) then
		IFObj_fnSetVis(this.buttons.Cursor, 1)
		IFObj_fnSetPos(this.buttons.Cursor,
									 vkeyboard_specs.StartX + (this.CursorX + 0.5) * vkeyboard_specs.XDiff + 1,
									 vkeyboard_specs.StartY + (this.CursorY + 0.3) * vkeyboard_specs.YDiff + 0)
		IFObj_fnSetColor(this.buttons.Cursor, gSelectedTextColor[1], gSelectedTextColor[2], gSelectedTextColor[3])
		local Offset = (this.CursorY)*(vkeyboard_specs.NumColumns) + (this.CursorX) -- C counts from 0
		IFObj_fnSetColor(this.buttons[Offset], gSelectedTextColor[1], gSelectedTextColor[2], gSelectedTextColor[3])
		IFButton_fnSelect(this.buttons.cancel,nil)
		IFButton_fnSelect(this.buttons.back,nil)
		IFButton_fnSelect(this.buttons.ok,nil)
		ifelm_shellscreen_fnPlaySound(this.selectSound)
	else
		ifelm_shellscreen_fnPlaySound(this.selectSound)
		IFObj_fnSetVis(this.buttons.Cursor, nil)
	end
end

-- Helper function: bounces the cursor when over a letter
function IFS_VKeyboard_BounceCursor(this,fDt)
	this.ButtonAddScale = this.ButtonAddScale + fDt * this.ButtonDir
	if(this.ButtonAddScale > 3) then
		this.ButtonAddScale = 3
		this.ButtonDir = -10
	elseif (this.ButtonAddScale < 0) then
		this.ButtonAddScale = 0
		this.ButtonDir = 10
	end

	gButtonWindow_fnSetSize(this.buttons.Cursor,
													vkeyboard_specs.CursorWidth + this.ButtonAddScale,
													vkeyboard_specs.CursorHeight + this.ButtonAddScale)

end

-- Helper function: shows the current string
function IFS_VKeyboard_ShowCurString(this)

	local Len = string.len(this.WorkString)
--	print("VK, len = ", Len)
	local ShowStr = ""

	if(vkeyboard_specs.bPasswordMode) then
		ShowStr = string.rep("*", string.len(this.WorkString))	
	else
		ShowStr = this.WorkString
	end

	IFObj_fnSetColor(this.buttons.DisplayString, gSelectedTextColor[1], gSelectedTextColor[2], gSelectedTextColor[3])


	-- Try and make this fit
	local bFits = nil
	local Font = "gamefont_medium"
	local HScale = 1
	local Stage = 1
	repeat
		IFText_fnSetScale(this.buttons.DisplayString,HScale)
		IFText_fnSetFont(this.buttons.DisplayString,Font)
		IFText_fnSetString(this.buttons.DisplayString,ShowStr)

		local CurPixelLen = IFText_fnGetExtent(this.buttons.DisplayString)
		if(CurPixelLen < (gSafeW - 32)) then
			bFits = 1
		else
			if(Stage == 1) then
				Font = "gamefont_small"
			elseif (Stage == 2) then
				Font = "gamefont_tiny"
			elseif (Stage == 3) then
				HScale = 0.8
			elseif (Stage == 4) then
				bFits = 1 -- couldn't make it fit any other way
			end
			Stage = Stage + 1
		end
	until bFits

	-- Keep unicode version for later.
	this.CurString = ScriptCB_tounicode(this.WorkString)
	
	local bCouldAccept = vkeyboard_specs.fnIsOk()
	IFObj_fnSetVis(this.deletegroup,string.len(this.WorkString) > 0)
	--		IFObj_fnSetVis(this.startgroup,bCouldAccept)
	IFObj_fnSetVis(this.Helptext_Accept,IFS_VKeyboard_fnCouldAddChar(this))
end

-- Helper function: deletes the last character, if applicable
function IFS_VKeyboard_Backspace(this)
	local Len = string.len(this.WorkString)
	this.WorkString = string.sub(this.WorkString, 1, Len - 1)
	IFS_VKeyboard_ShowCurString(this)
	if(vkeyboard_specs.bGamespyMode) then
		IFS_VKeyboard_fnRegetKeys(this)
	end
end


-- Helper function: deletes the last character, if applicable
function IFS_VKeyboard_ClearEntry(this)
	this.WorkString = ""
	IFS_VKeyboard_ShowCurString(this)
	if(vkeyboard_specs.bGamespyMode) then
		IFS_VKeyboard_fnRegetKeys(this)
	end
end


ifs_vkeyboard = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,

	-- For bouncing the cursor:
	ButtonAddScale = 1,
	ButtonDir = 4,

	title = NewIFText {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.0, -- top
		font = "gamefont_large",
		textw = 460,
		texth = 75,
		y = 0,
		halign = "hcenter",
		nocreatebackground = 1,
	},

	deletegroup = NewHelptext {
		ScreenRelativeX = 0.0, -- left
		ScreenRelativeY = 1.0, -- bot
		y = -40,
		buttonicon = "btnmisc",
		string = "ifs.vkeyboard.backspace_large",
	},

	modegroup = NewHelptext {
		ScreenRelativeX = 1.0, -- right
		ScreenRelativeY = 1.0, -- bot
		y = -40,
		x = 0,
		bRightJustify = 1,
		buttonicon = "btnmisc2",
		string = "ifs.vkeyboard.mode",
	},

	Input_Accept = function(this)
		if(this.CursorY == vkeyboard_specs.NumRows) then
			if(this.CurButton == "cancel") then
				ScriptCB_PopScreen()
				ifelm_shellscreen_fnPlaySound(this.cancelSound)
			elseif (this.CurButton == "back") then
				-- First deletion zaps all text
				if(this.bFirstAction) then
					IFS_VKeyboard_ClearEntry(this)
					this.bFirstAction = nil
				else
					IFS_VKeyboard_Backspace(this)
				end
				ifelm_shellscreen_fnPlaySound("shell_keyboard_backspace")
			else
--				print("VKeyboard, Input_Accept, cur = 'ok'")
				ifelm_shellscreen_fnPlaySound(this.acceptSound)

				local bCanAccept,ErrStr = vkeyboard_specs.fnIsOk()
				if(bCanAccept) then
					vkeyboard_specs.fnDone()
				else
					ifs_vkeyboard_fnSetPieceVis(this,nil)
					Popup_Ok.fnDone = ifs_vkeyboard_fnErrOk
					Popup_Ok:fnActivate(1)
					gPopup_fnSetTitleStr(Popup_Ok, ErrStr)
				end
			end
		else
			-- First character typed zaps contents
			if(this.bFirstAction) then
				IFS_VKeyboard_ClearEntry(this)
				this.bFirstAction = nil
			end

			if(IFS_VKeyboard_fnCouldAddChar(this)) then
				ifelm_shellscreen_fnPlaySound("shell_keyboard_key")
				local Offset = this.CursorY*(vkeyboard_specs.NumColumns) + this.CursorX + this.fCharOffset
				this.WorkString = this.WorkString .. ScriptCB_GetVKeyboardCharacter(Offset)
				IFS_VKeyboard_ShowCurString(this)
				if(vkeyboard_specs.bGamespyMode) then
					IFS_VKeyboard_fnRegetKeys(this)
				end
			else
				ifelm_shellscreen_fnPlaySound(this.errorSound)
			end
		end
	end,

	Input_Start = function(this)
		if(vkeyboard_specs.fnDone) then
			vkeyboard_specs.fnDone()
		end
		ifelm_shellscreen_fnPlaySound(this.acceptSound)
	end,

	Input_Misc = function(this)
		-- First action on screen clears old value
		if(this.bFirstAction) then
			IFS_VKeyboard_ClearEntry(this)
			this.bFirstAction = nil
		else
			IFS_VKeyboard_Backspace(this)
		end
		ifelm_shellscreen_fnPlaySound("shell_keyboard_backspace")
	end,

	Input_Misc2 = function(this)
		if(this.fCharOffset > 1) then
			this.fCharOffset = 0
			IFText_fnSetString(this.modegroup.helpstr, "ifs.vkeyboard.mode_symbols")
		else
			this.fCharOffset = vkeyboard_specs.NumColumns * vkeyboard_specs.NumRows
			IFText_fnSetString(this.modegroup.helpstr, "ifs.vkeyboard.mode_letters")
		end
		gHelptext_fnMoveIcon(this.modegroup)


		IFS_VKeyboard_fnRegetKeys(this)

		-- Skip deadzone on VK
		if(this.fCharOffset > 0) then
			if((this.CursorY == 3) and (this.CursorX > 2)) then
				this.CursorX = 2
				IFS_VKeyboard_MoveCursor(this)
			end
		end

		ifelm_shellscreen_fnPlaySound("shell_keyboard_key")
	end,

	Input_GeneralUp = function(this)
		this.CursorY = this.CursorY - 1
		if(this.CursorY < 0) then
			this.CursorY = vkeyboard_specs.NumRows
			IFS_VKeyboard_CursorFromButtonX(this)
		elseif (this.CursorY < vkeyboard_specs.NumRows) then
			gCurHiliteButton = nil
		end

		-- Skip deadzone on VK
		if(this.fCharOffset > 0) then
			if((this.CursorY == 3) and (this.CursorX > 2)) then
				this.CursorY = this.CursorY - 1 
			end
		end

		IFS_VKeyboard_MoveCursor(this)
	end,

	Input_GeneralDown = function(this)
		this.CursorY = this.CursorY + 1

		-- Skip deadzone on VK
		if(this.fCharOffset > 0) then
			if((this.CursorY == 3) and (this.CursorX > 2)) then
				this.CursorY = this.CursorY + 1 
			end
		end

		if(this.CursorY == vkeyboard_specs.NumRows) then
			IFS_VKeyboard_CursorFromButtonX(this)
		elseif (this.CursorY > vkeyboard_specs.NumRows) then
			this.CursorY = 0
			gCurHiliteButton = nil
		end

		IFS_VKeyboard_MoveCursor(this)
	end,

	Input_GeneralLeft = function(this)
		if(this.CursorY == vkeyboard_specs.NumRows) then
			gDefault_Input_GeneralLeft(this)
			IFS_VKeyboard_ButtonXFromCursor(this)
		else
			this.CursorX = this.CursorX - 1
			if(this.CursorX < 0) then
				this.CursorX = vkeyboard_specs.NumColumns - 1
			end

			-- Skip deadzone on VK
			if(this.fCharOffset > 0) then
				if((this.CursorY == 3) and (this.CursorX > 2)) then
					this.CursorX = 2
				end
			end
		end
		IFS_VKeyboard_MoveCursor(this)
	end,

	Input_LTrigger = function(this)
		if((this.CursorY < vkeyboard_specs.NumRows) and (this.CursorX > 0)) then
			this.CursorX = math.max(0,this.CursorX - vkeyboard_specs.HalfWidth)

			-- Skip deadzone on VK
			if(this.fCharOffset > 0) then
				if((this.CursorY == 3) and (this.CursorX > 2)) then
					this.CursorX = 0
				end
			end

			ifelm_shellscreen_fnPlaySound(this.selectSound)
			IFS_VKeyboard_MoveCursor(this)
		end -- could move
	end,

	Input_GeneralRight = function(this)
		if(this.CursorY == vkeyboard_specs.NumRows) then
			gDefault_Input_GeneralRight(this)
			IFS_VKeyboard_ButtonXFromCursor(this)
		else
			this.CursorX = this.CursorX + 1
			if(this.CursorX > (vkeyboard_specs.NumColumns - 1)) then
				this.CursorX = 0
			end

			-- Skip deadzone on VK
			if(this.fCharOffset > 0) then
				if((this.CursorY == 3) and (this.CursorX > 2)) then
					this.CursorX = 0
				end
			end
		end
		IFS_VKeyboard_MoveCursor(this)
	end,

	Input_RTrigger = function(this)
		if((this.CursorY < vkeyboard_specs.NumRows) and (this.CursorX < (vkeyboard_specs.NumColumns - 1))) then
			this.CursorX = math.min(this.CursorX + vkeyboard_specs.HalfWidth,vkeyboard_specs.NumColumns - 1)
			ifelm_shellscreen_fnPlaySound(this.selectSound)

			-- Skip deadzone on VK
			if(this.fCharOffset > 0) then
				if((this.CursorY == 3) and (this.CursorX > 2)) then
					this.CursorX = 2
				end
			end

			IFS_VKeyboard_MoveCursor(this)
		end -- could move
	end,

	Enter = function(this, bFwd)
		-- Always call base class
		gIFShellScreenTemplate_fnEnter(this, bFwd)
		
		gHelptext_fnMoveIcon(this.modegroup)

		this.WorkString = ScriptCB_ununicode(this.CurString)

		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if(ErrorLevel >= 6) then -- session or login error, must keep going further
				ScriptCB_PopScreen()
			end
		end

		-- Set flag for first action
		this.bFirstAction = 1

		if(this.bCursorOnLetters) then
			this.bCursorOnLetters = nil -- clear before next time we enter
			this.CursorX = 0
			this.CursorY = 0
			IFButton_fnSelect(this.buttons.cancel,nil)
			IFButton_fnSelect(this.buttons.back,nil)
			IFButton_fnSelect(this.buttons.ok,nil)
			gCurHiliteButton = nil
		else
			this.CurButton = "ok"
			gCurHiliteButton = this.buttons[this.CurButton]
			IFButton_fnSelect(this.buttons.cancel,nil)
			IFButton_fnSelect(this.buttons.back,nil)
			IFButton_fnSelect(this.buttons[this.CurButton],1)
			this.CursorY = vkeyboard_specs.NumRows
			this.CursorX = math.floor(vkeyboard_specs.NumColumns * 0.85)
		end

		-- Always reset this on entry
		IFText_fnSetScale(this.buttons.DisplayString,1,1)
		IFText_fnSetFont(this.buttons.DisplayString,"gamefont_medium")

		local ScreenW,ScreenH = ScriptCB_GetSafeScreenInfo() -- of the usable screen
		gButtonWindow_fnSetSize(this.buttons.DisplayStringBG,ScreenW - 20, this.DisplayBoxHeight)

		this.fCharOffset = 0 -- Always go back to letters. 
		IFText_fnSetString(this.modegroup.helpstr, "ifs.vkeyboard.mode_symbols")
		gHelptext_fnMoveIcon(this.modegroup)
		IFS_VKeyboard_fnRegetKeys(this)

		IFS_VKeyboard_MoveCursor(this)
		IFS_VKeyboard_ShowCurString(this)

		AnimationMgr_AddAnimation(this.deletegroup, {fStartAlpha = 0, fEndAlpha = 1,})
		AnimationMgr_AddAnimation(this.modegroup, {fStartAlpha = 0, fEndAlpha = 1,})
--		AnimationMgr_AddAnimation(this.startgroup, {fStartAlpha = 0, fEndAlpha = 1,})
		AnimationMgr_AddAnimation(this.buttons, {fStartAlpha = 0, fEndAlpha = 1,})
	end,

	Exit = function(this)
		vkeyboard_specs.bPasswordMode = nil
		vkeyboard_specs.bGamespyMode = nil
	end,

	UpdateButtons = function(this)
		if(this.CurButton == "cancel") then
			this.CursorX = math.floor(vkeyboard_specs.NumColumns * 0.15)
		elseif (this.CurButton == "back") then
			this.CursorX = math.floor(vkeyboard_specs.NumColumns * 0.5)
		else
			this.CursorX = math.floor(vkeyboard_specs.NumColumns * 0.85)
		end
		this.CursorY = vkeyboard_specs.NumRows
	end,

	Update = function(this, fDt)
		IFS_VKeyboard_BounceCursor(this,fDt)
		gIFShellScreenTemplate_fnUpdate(this,fDt)
	end,

	AcceptString = function(this, ustr)
		this.CurButton = "ok"
		this.WorkString = ScriptCB_ununicode(ustr)
		this.CursorY = vkeyboard_specs.NumRows
		this.CursorX = math.floor(vkeyboard_specs.NumColumns * 0.85)
		IFS_VKeyboard_MoveCursor(this)
		IFS_VKeyboard_ShowCurString(this)
	end,

	Input_KeyDown = function(this, iKey)
--		print("ifs_vkeyboard, KeyDown. Ascii = ",iKey)
		if (iKey == 10) then
			-- Special-case enter
			this.CursorY = vkeyboard_specs.NumRows
			this.CurButton = "ok"
			this:Input_Accept()
		elseif (iKey == 8) then
			-- Special-case backspace
			this:Input_Misc()
		elseif ((iKey >= 32) and (iKey < 127)) then
			if(IFS_VKeyboard_fnCouldAddChar(this, iKey)) then
				ifelm_shellscreen_fnPlaySound("shell_keyboard_key")
				this.WorkString = this.WorkString .. string.char(iKey)
				IFS_VKeyboard_ShowCurString(this)
				if(vkeyboard_specs.bGamespyMode) then
					IFS_VKeyboard_fnRegetKeys(this)
				end
			else
				ifelm_shellscreen_fnPlaySound(this.errorSound)
			end
		end
		this.bFirstAction = nil -- clear this
	end,

}

-- Helper function: adds a set of buttons to the screen, based on 
function IFS_VKeyboard_AddButtons(this)
	local ScreenW,ScreenH = ScriptCB_GetSafeScreenInfo() -- of the usable screen

	-- Take up ~ half the screen
	ScreenH = ScreenH * 0.60

	if(this.Helptext_Accept) then
		IFText_fnSetString(this.Helptext_Accept.helpstr,"ifs.vkeyboard.select")
	end
	
	this.buttons = NewButtonWindow {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.46, -- just above center
		width = ScreenW,
		height = ScreenH,
		y = ScreenH * -0.05,
		ZPos = 220,
	}
	this.buttons.skin.ZPos = 220

	local XDiff = (ScreenW - 32) / vkeyboard_specs.NumColumns
	local YDiff = (ScreenH * 0.58) / vkeyboard_specs.NumRows
	if(YDiff > (XDiff * 1.2)) then
		YDiff = (XDiff * 1.2)
	end
	local StartX = (ScreenW - 32) * -0.5
	local StartY = -1.5 * YDiff -- ScreenH * -0.5

	-- Store where everything's at for later
	vkeyboard_specs.StartX = StartX
	vkeyboard_specs.StartY = StartY
	vkeyboard_specs.XDiff = XDiff
	vkeyboard_specs.YDiff = YDiff

	local i,j,XPos,YPos
	YPos = StartY
	for i=1,vkeyboard_specs.NumRows do
		XPos = StartX
		for j=1,vkeyboard_specs.NumColumns do
			local Offset = (i-1)*(vkeyboard_specs.NumColumns) + (j-1) -- C counts from 0
			this.buttons[Offset] = NewIFText {
				font = "gamefont_medium",
				textw = XDiff * 1.1,
				x = XPos, y = YPos,
				inert = 1, -- delete from lua after creating in C
				nocreatebackground = 1,		
				startdelay = math.random() * 0.5,		
			}

--			IFText_fnSetUString(this.buttons[Offset],ScriptCB_GetVKeyboardCharacter(Offset))
			XPos = XPos + XDiff
		end -- j loop
		YPos = YPos + YDiff
	end -- i loop

	this.DisplayBoxHeight = YDiff * 1.4
	this.buttons.DisplayStringBG = NewButtonWindow {
		y = ScreenH * -0.4 + YDiff * 0.3,
		x = 0,
		width = ScreenW * 0.65 + 10,
		height = this.DisplayBoxHeight,
		ZPos = 150,
	}

	this.buttons.DisplayString = NewIFText {
		y = this.buttons.DisplayStringBG.y + this.DisplayBoxHeight * -0.5 - 4,
		textw = ScreenW  - 32,
		texth = this.DisplayBoxHeight,
		font = "gamefont_medium",
		valign = "vcenter",
		nocreatebackground = 1,
	}

	vkeyboard_specs.CursorWidth = XDiff * 0.9
	vkeyboard_specs.CursorHeight = YDiff * 0.9

	this.buttons.Cursor = NewButtonWindow {
		width = vkeyboard_specs.CursorWidth,
		height = vkeyboard_specs.CursorHeight,
		ZPos = 130,
	}

	local BottomButtons_layout = {
		xLeft = -40,
		yTop = 0,
		xWidth = 80,
		xSpacing = 0,
		height = 45,
		font = "gamefont_medium",
		buttonlist = { 
			{ tag = "cancel", string = "common.cancel", },
			{ tag = "back", string = "ifs.vkeyboard.backspace", },
			{ tag = "ok", string = "common.accept", },
		},
		nocreatebackground = 1,
	}

	-- Calculate the size/spacing for the buttons based on screen size
	BottomButtons_layout.xWidth = ScreenW * 0.32 -- a bit less than 1/3
	BottomButtons_layout.xLeft = -BottomButtons_layout.xWidth - BottomButtons_layout.xSpacing
	BottomButtons_layout.yTop = ScreenH * 0.4 -- near the bottom

	AddHorizontalButtons(this.buttons,BottomButtons_layout)
	this.buttons.cancel.ZPos = 50
	this.buttons.back.ZPos = 50
	this.buttons.ok.ZPos = 50

	-- Calculate midpoint of this
	vkeyboard_specs.HalfWidth = math.floor(vkeyboard_specs.NumColumns * 0.5) 

	this.CurString = ""
	this.WorkString = ""
end

IFS_VKeyboard_AddButtons(ifs_vkeyboard)
IFS_VKeyboard_AddButtons = nil -- clear out of memory to save space

AddIFScreen(ifs_vkeyboard,"ifs_vkeyboard")

