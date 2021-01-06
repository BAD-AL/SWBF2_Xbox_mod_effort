--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Editbox for Lua. Handles the overall setup of them, with functions
-- for managing them.

function IFEditbox_fnSetString(this,NewStr)
	if(this.bPasswordMode) then
		local ShowStr = string.rep("*", string.len(NewStr))	
		IFText_fnSetString(this.showtext,ShowStr)
	else
		IFText_fnSetString(this.showtext,NewStr)
	end
	this.CurStr = NewStr

	IFEditbox_fnMoveCursor(this)
end

function IFEditbox_fnSetUString(this,NewUStr)
	if(this.bPasswordMode) then
		local ShowStr = string.rep("*", string.len(NewUStr) * 0.5)	
		IFText_fnSetString(this.showtext,ShowStr)
	else
		IFText_fnSetUString(this.showtext,NewUStr)
	end
	this.CurStr = ScriptCB_ununicode(NewUStr)
	IFEditbox_fnMoveCursor(this)
end

function IFEditbox_fnGetString(this)
	return this.CurStr
end

function IFEditbox_fnSetFont(this,NewFont)
	IFText_fnSetFont(this.showtext,NewFont)
end

function IFEditbox_fnSetScale(this,HScale,VScale)
	IFText_fnSetScale(this.showtext,HScale,VScale)
end

-- Moves the cursor to the appropriate location
function IFEditbox_fnMoveCursor(this)
	local CurPixelLen = IFText_fnGetExtent(this.showtext)
	IFObj_fnSetPos(this.cursor, this.cursor.xLeft + CurPixelLen - 2)
end

-- Adds one character to an editbox. Handles special chars like
-- delete, etc.
function IFEditbox_fnAddChar(this,iChar)
	local Len = string.len(this.CurStr)

	if(iChar == 8) then
		-- Handle backspace
		if(Len > 0) then
			this.CurStr = string.sub(this.CurStr, 1, Len - 1)
			IFEditbox_fnSetString(this,this.CurStr)
		end
		return
	end

	-- Ignore all other illegal, immoral, or fattening characters.
	if((iChar < 32) or (iChar > 254)) then
		return
	end

	local CurPixelLen = IFText_fnGetExtent(this.showtext)
	if(((this.MaxLen) and (CurPixelLen >= this.MaxLen)) or
		 ((this.MaxChars) and (Len >= this.MaxChars))) then
		ifelm_shellscreen_fnPlaySound("shell_menu_error")
		return
	end

	this.CurStr = this.CurStr .. string.char(iChar)
	IFEditbox_fnSetString(this,this.CurStr)
end

-- Sets the hilight on things
function IFEditbox_fnHilight(this, bBright)
	local NewTexture
	if(bBright) then
		NewTexture = "border_3a_pieces"
	else
		NewTexture = "border_3_pieces"
	end

	if(this.bClearOnHilightChange) then
		IFEditbox_fnSetString(this,"")
	end	
	-- hey, it's a hack!
	if(this.bIsTheCheatBox and (ifs_missionselect)) then
		if(ifs_missionselect.cheatOutput) then
			IFObj_fnSetVis( ifs_missionselect.cheatOutput, nil )
		end
	end

	gButtonWindow_fnSetTexture(this, NewTexture)
	IFObj_fnSetVis(this.cursor,bBright)

	IFEditbox_fnMoveCursor(this) -- just in case
end

-- Bounces the cursor
gEditbox_CurAlpha = 0.5
gEditbox_CurDir = 2
function IFEditbox_fnBounceCursor(this, fDt)
	if(this.bSilentAndInvisible) then
		return
	end
	
	gEditbox_CurAlpha = gEditbox_CurAlpha + fDt * gEditbox_CurDir
	if(gEditbox_CurAlpha > 1) then
		gEditbox_CurAlpha = 1
		gEditbox_CurDir = -math.abs(gEditbox_CurDir)
	elseif (gEditbox_CurAlpha < 0.3) then
		gEditbox_CurAlpha = 0.3
		gEditbox_CurDir = math.abs(gEditbox_CurDir)
	end

	IFObj_fnSetAlpha(this.cursor,gEditbox_CurAlpha)
end

-- Creates a new Editbox. This item is centered around the center of
-- what's passed in. Values in Template to be filled out:
--
-- width : overall width in pixels (of the background)
-- height : overall height in pixels
-- MaxChars : # of characters possible, nil for unlimited
-- MaxLen : math.max length (in pixels at current font), nil for unlimited
function NewEditbox(Template)
	-- Fill in defaults in case parent didn't.
	Template.width = Template.width or 100
	Template.w = Template.width
	Template.height = Template.height or 16
	Template.h = Template.height
	
	local temp 
	if(Template.bSilentAndInvisible) then
		temp = NewIFContainer(Template)
	else
		temp = NewButtonWindow(Template)
	end
--  {
-- 		x = Template.x,
-- 		y = Template.y,
-- 		ZPos = Template.ZPos,
-- 		w = Template.width,
-- 		width = Template.width,
-- 		h = Template.height,
-- 		height = Template.height,
-- 	}

	temp.bHotspot = 1
	temp.fHotspotX = Template.w * - 0.5
	temp.fHotspotW = Template.w
	temp.fHotspotY = Template.h * -0.5
	temp.fHotspotH = Template.h

	temp.text_offset_x = 16
	temp.text_offset_width = -32

	if(gPlatformStr == "PC") then
		temp.text_offset_x = 16 - 6
		temp.text_offset_width = -32 + 6
	end
	
	temp.showtext = NewIFText {
		x = Template.x + Template.width * -0.5 + temp.text_offset_x,
		y = Template.h * -0.5,
		halign = "left",
		valign = "vcenter",
		textw = Template.width + temp.text_offset_width,
		texth = Template.h,
		font = Template.font,
		string = Template.string,
		ustring = Template.ustring,
		nocreatebackground = 1,
	}

	temp.cursor = NewIFText {
		x = Template.x + Template.width * -0.5 + temp.text_offset_x,
		y = Template.h * -0.5,
		halign = "left",
		valign = "vcenter",
		textw = Template.width + temp.text_offset_width,
		texth = Template.h,
		font = Template.font,
		string = "_",
		nocreatebackground = 1,
		alpha = 0, -- invisible by default
		ColorR = 255,
		ColorG = 255,
		ColorB = 0,
	}
	temp.cursor.xLeft = temp.cursor.x -- store this for later

	temp.type = "editbox" -- change type for mouse code
	temp.MaxChars = Template.MaxChars
	temp.MaxLen = Template.MaxLen
	temp.bPasswordMode = Template.bPasswordMode

	if(Template.string) then
		temp.CurStr = Template.string
	elseif (Template.ustring) then
		temp.CurStr = ScriptCB_ununicode(Template.ustring)
	else
		temp.CurStr = ""
	end

	return temp
end




