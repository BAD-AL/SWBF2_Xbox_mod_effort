--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Window w/ vertical buttons template, associated code.

-- fnSetSize for a ButtonWindow's Skin. Pulled out so its
-- implementation could be properly shared (refcounted) among all
-- instances. Bugs: 32x32 is the smallest size possible
function gButtonWindowSkin_fnSetSize(this,w,h)
	local borderw = w < 32 and w*0.5 or 16
	local borderh = h < 32 and h*0.5 or 16
	IFBorder_fnSetTexturePos(this, w*-0.5, h*-0.5, w*0.5, h*0.5, borderw, borderh)
end

-- fnSetTexture for a ButtonWindow's Skin. Pulled out so its
-- implementation could be properly shared (refcounted) among all
-- instances
function gButtonWindowSkin_fnSetTexture(this,NewTexture,NewAlpha)
	IFBorder_fnSetTexture(this, NewTexture, NewAlpha)
end

-- fnActivate for a ButtonWindow's Skin. Pulled out so its
-- implementation could be properly shared (refcounted) among all
-- instances
function gButtonWindowSkin_fnActivate(this)
--	print("Write me! (gButtonWindowSkin_fnActivate)")
end

-- Override for setsize -- does so for self, calls it on kids (if present)
function gButtonWindow_fnSetSize(this,w,h)
	this.width = w
	this.height = h
	
	if(this.skin) then
		gButtonWindowSkin_fnSetSize(this.skin,w,h)
	end
end -- function gButtonWindow_fnSetSize

-- Override for setsize -- does so for self, calls it on kids (if present)
function gButtonWindow_fnActivate(this,on)
	local NewTexture

	if(on) then
		NewTexture = this.onTexture
	else
		NewTexture = this.offTexture
	end

	-- Tell kids to do the heavy lifting
	if(this.skin) then
--		this.skin:fnActivate(NewTexture,NewSkinAlpha)

		-- Always resize to last expected size (in case we made it bigger while selected)
		if(not on) then
			gButtonWindowSkin_fnSetSize(this.skin,this.width,this.height)
		end

	end
end -- function gButtonWindow_fnSetSize

-- Override for setsize -- does so for self, calls it on kids (if present)
function gButtonWindow_fnSetTexture(this,NewTexture,NewAlpha)
	if(this.skin) then
		gButtonWindowSkin_fnSetTexture(this.skin,NewTexture,NewAlpha)
	end
end

-- set the text for button window
function gButtonWindow_fnSetText(this,NewText)
	if(this.titleBarElement) then
		IFText_fnSetString( this.titleBarElement, NewText )
	end
end

-- Like NewIFButton, but puts a nice fancy skin on it.

function NewButtonWindow(Template)

	local temp = Template

	temp.skin = NewIFBorder {
		ZPos = 135, -- Text will be at 128 by default, be a bit behind it

		uvs_l = 0.0,
		uvs_t = 0.0,
		uvs_r = 1.0,
		uvs_b = 1.0,
		uvs_w = 0.25,
		uvs_h = 0.25,
		inert_all = 1,

-- 		fnSetSize = gButtonWindowSkin_fnSetSize,
-- 		fnActivate = gButtonWindowSkin_fnActivate,
-- 		fnSetTexture = gButtonWindowSkin_fnSetTexture,
	} -- end of skin

	temp.width = temp.width or 200
	temp.height = temp.height or 200

	--some optional tweaking params:
	local buttonHeightPad = temp.buttonHeightPad or gButtonHeightPad
	local buttonGutter = temp.buttonGutter or gButtonGutter
	local titleOffsetX = temp.titleOffsetX or 0
	local Font = temp.font or gMenuButtonFont
	
	local height = ScriptCB_GetFontHeight(Font) + buttonHeightPad
	
	if(Template.titleText) then
		
		
		temp.titleBarElement = NewIFText { 
			x = temp.width * -0.5 - 10 + titleOffsetX,
			y = (temp.height * -0.5) - height - buttonGutter, 
			font = Font, 
			textw = temp.width, texth = height, 
			halign = "hcenter",
			valign = "vcenter",
			string = Template.titleText,
			flashy = 1,
			startdelay = 0.0,
			bg_width = temp.width - 26,
			bgleft = "bf2_buttons_topleft",
			bgmid = "bf2_buttons_title_center",
			bgright = "bf2_buttons_topright",
-- 			bgleft = "headerbuttonleft",
-- 			bgmid = "headerbuttonmid",
-- 			bgright = "headerbuttonright",
			bgoffsetx = 0, -- -11,
			bgoffsety = 0,
			bgexpandx = 0,
			bgexpandy = buttonHeightPad * 0.5, -- exe doubles this, grr
			ColorR = 255,
			ColorG = 255,
			ColorB = 255,
			textcolorr = gTitleTextColor[1],
			textcolorg = gTitleTextColor[2],
			textcolorb = gTitleTextColor[3],
			bInertPos = 1,
			ZPos = 135,
		}

		temp.titleBarElement.x = temp.titleBarElement.x + 8
	end	


	temp.onTexture = temp.onTexture or "btn_on_pieces"
	temp.offTexture = temp.offTexture or "btn_off_pieces"

	-- Fill in an resizer function
-- 	temp.fnSetSize = gButtonWindow_fnSetSize
-- 	temp.fnSetTexture = gButtonWindow_fnSetTexture
-- 	temp.fnActivate = Template.fnActivate or gButtonWindow_fnActivate

	gButtonWindow_fnSetSize(temp,temp.width,temp.height)
	-- Set default texture
	local texture = temp.bg_texture or "border_3_pieces"
	gButtonWindow_fnSetTexture(temp,texture)
	temp.type = temp.type or "buttonwindow"

	-- Make a container from this expanded template
	return NewIFContainer(temp)
end
