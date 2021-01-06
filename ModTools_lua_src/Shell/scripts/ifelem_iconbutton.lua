--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Support code for an "icon button" - a text button with an icon
-- behind it.


-- Creates an IconButton based on the specified layout. Valid params in
-- the layout are:
--
-- layout.ScreenReleativeX, .ScreenRelativeY, .x, .y  : copied for IFObject base
-- layout.texture : texture to use for icon
-- layout.string  : string to use for button text
-- layout.size    : size of icon (placed centered in it)
-- layout.font    : font texture
-- layout.textw   : width of text (which can be wider than icon)
function NewIconButton(layout)
	layout.size = layout.size or 64
	local HalfSize = layout.size * 0.5

	local ret = NewIFContainer { 
		ScreenRelativeX = layout.ScreenRelativeX,
		ScreenRelativeY = layout.ScreenRelativeY,
		x = layout.x,
		y = layout.y,

		icon = NewIFImage {
			ZPos = 240, 
			localpos_l = -HalfSize,
			localpos_r =  HalfSize,
			localpos_t = -HalfSize,
			localpos_b =  HalfSize,
			texture = layout.texture,
		},

		helptext = NewIFText { 
			halign = "hcenter", valign = "vcenter",
			texth = layout.size,
			textw = layout.textw,
			font = layout.font,
			string = layout.string,
			startdelay=0, nocreatebackground=1, 
		},
	}

	return ret
end

-- Sets a texture
function gIconButton_fnSetTexture(this, tex)
	IFImage_fnSetTexture(this.icon, tex)
end

-- Sets the string
function gIconButton_fnSetString(this, str)
	IFText_fnSetString(this.helptext, str)
end

-- Sets the string
function gIconButton_fnSetUString(this, ustr)
	IFText_fnSetUString(this.helptext, ustr)
end

-- Selects a button, given a brite flag
function gIconButton_fnSelect(this, bBrite)
	local TextAlpha = 0.75
	local IconAlpha = 0.5

	if(bBrite) then
		TextAlpha = 1
		IconAlpha = 0.75
	end

	IFObj_fnSetAlpha(this.icon, IconAlpha)
	IFObj_fnSetAlpha(this.helptext, TextAlpha)
end

-- Updates a button, which should be selected. 
function gIconButton_fnHilight(this, fDt)
	gButton_CurSizeAdd = gButton_CurSizeAdd + fDt * gButton_CurDir
	if(gButton_CurSizeAdd > 1) then
		gButton_CurSizeAdd = 1
		gButton_CurDir = -math.abs(gButton_CurDir)
	elseif (gButton_CurSizeAdd < 0.5) then
		gButton_CurSizeAdd = 0.5
		gButton_CurDir = math.abs(gButton_CurDir)
	end
	
	IFObj_fnSetAlpha(this.helptext,gButton_CurSizeAdd)
	IFObj_fnSetAlpha(this.icon,gButton_CurSizeAdd * 0.75)
end