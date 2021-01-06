--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Utility functions for the StarWars: Frontline interface. These
-- functions are used for the shell and ingame interfaces. Shell-only
-- stuff should go in shell\scripts\shell_util.lua ]

-- Some constants for rapudly changing the look/feel of things. 
-- Note: we are a CONSOLE game. Subtle is a BAD thing. 

if(gPlatformStr == "PS2") then
  gTitleTextColor = { 246, 235, 20 } -- of listbox titles, buttonlist titles yellow
  gTitleTextAlpha = 0.8
  gSelectedTextColor = { 138, 160, 244} -- Photoshop-safe color : lightblue
  gSelectedTextAlpha = 0.6 -- 1.0 == opaque, 0.0 = transparent
  gUnselectedTextColor = { 240, 240, 240} -- Photoshop-safe color : white
  gUnselectedTextAlpha = 0.6
  gHelptextTextColor = { 240, 240, 240} -- Photoshop-safe color : white
  gHelptextTextAlpha = 0.8

  gButtonWidthPad = 100 -- pixels to pad buttons by on left/right side.
  gButtonHeightPad = 6 -- pixels to stretch button height by, added to font height
  gButtonGutter = 4 -- # of pixels to add between buttons
  gDefaultButtonScreenRelativeY = 0.6 -- % of screen buttons are centered around.

  gMenuButtonFont = "gamefont_large" -- font used on all menu screens that are vertical buttons
	gPopupTextFont = "gamefont_small"
	gPopupButtonFont = "gamefont_small"
	gListboxItemFont = "gamefont_large" -- font used in options listboxes.

	gPopupWidthPad = 32 -- space around text in popups
	gPopupHeightPad = 32 -- space around text in popups

  gHelptextIconWidth = 11
  gHelptextIconHeight = 12

	gButton_CurDir = 2 -- Speed at which buttons animate. Higher = more stroby.
	gButton_MinHilightAlpha = 0.3 -- 0 = completely transparent, 1.0 = opaque
	gButton_MaxHilightAlpha = 1.0 -- 0 = completely transparent, 1.0 = opaque

elseif (gPlatformStr == "XBox") then

  gTitleTextColor = { 246, 235, 20} -- of listbox titles, buttonlist titles yellow
  gTitleTextAlpha = 0.8
  gSelectedTextColor = { 138, 160, 244} -- Photoshop-safe color : lightblue
  gSelectedTextAlpha = 0.6 -- 1.0 == opaque, 0.0 = transparent
  gUnselectedTextColor = { 240, 240, 240 } -- Photoshop-safe color : white
  gUnselectedTextAlpha = 0.6
  gHelptextTextColor = { 240, 240, 240} -- Photoshop-safe color : white
  gHelptextTextAlpha = 0.8

  gButtonWidthPad = 136 -- pixels to pad buttons by on left/right side.
  gButtonHeightPad = 6 -- pixels to stretch button height by, added to font height
  gButtonGutter = 4 -- # of pixels to add between buttons
  gDefaultButtonScreenRelativeY = 0.6 -- % of screen buttons are centered around.

  gMenuButtonFont = "gamefont_large" -- font used on all menu screens that are vertical buttons
	gPopupTextFont = "gamefont_small"
	gPopupButtonFont = "gamefont_small"
	gListboxItemFont = "gamefont_large" -- font used in options listboxes.

	gPopupWidthPad = 32
	gPopupHeightPad = 32

  gHelptextIconWidth = 15
  gHelptextIconHeight = 16

	gButton_CurDir = 2 -- Speed at which buttons animate. Higher = more stroby.
	gButton_MinHilightAlpha = 0.3 -- 0 = completely transparent, 1.0 = opaque
	gButton_MaxHilightAlpha = 1.0 -- 0 = completely transparent, 1.0 = opaque

elseif (gPlatformStr == "PC") then

  gTitleTextColor = { 0, 0, 0} -- of listbox titles, buttonlist titles yellow
  gTitleTextAlpha = 1.0 --0.8
  gSelectedTextColor = { 255, 209, 25} -- Photoshop-safe color : yellow
  gSelectedTextAlpha = 1.0 --0.6 -- 1.0 == opaque, 0.0 = transparent
  gUnselectedTextColor = { 240, 240, 240 } -- Photoshop-safe color : white
  gUnselectedTextAlpha = 1.0 --0.6
  gHelptextTextColor = { 240, 240, 240} -- Photoshop-safe color : white
  gHelptextTextAlpha = 1.0 --0.8

  gButtonWidthPad = 100 -- pixels to pad buttons by on left/right side.
  gButtonHeightPad = 6 -- pixels to stretch button height by, added to font height
  gButtonGutter = 4 -- # of pixels to add between buttons
  gDefaultButtonScreenRelativeY = 0.6 -- % of screen buttons are centered around.

  gMenuButtonFont = "gamefont_large" -- font used on all menu screens that are vertical buttons
	gPopupTextFont = "gamefont_small"
	gPopupButtonFont = "gamefont_small"
	gListboxItemFont = "gamefont_large" -- font used in options listboxes.

	gPopupWidthPad = 32
	gPopupHeightPad = 32

  gHelptextIconWidth = 11
  gHelptextIconHeight = 12

	gListboxSliderWidth = 16 -- in pixels.

	gButton_CurDir = 2 -- Speed at which buttons animate. Higher = more stroby.
	gButton_MinHilightAlpha = 0.3 -- 0 = completely transparent, 1.0 = opaque
	gButton_MaxHilightAlpha = 1.0 -- 0 = completely transparent, 1.0 = opaque
end

-- From luabook1.pdf -- from a template of new values (init), and a
-- generic template (old), creates a proper merge of the values, with
-- preference given to new values, if they conflict. Returns the
-- merge.
function createObj (old, init)
	local new = init or {}
	local k,v
	for k,v in old do
		if not new[k] then new[k] = v end
	end
	return new
end

-- -------------------------------------------------------------------
-- Templates for the various classes. These contain default values for
-- all of the values and accessor function(s). Individual
-- implementations of each one can specify any to all of the
-- parameters; values are copied over from the template only if not
-- present in the new implementation.

-- Helper functions

-- Sets the position. Pass nil for either arg to use current value instead
function IFObj_fnSetZPos(this, aVal)
	if(this.cp) then
		ScriptCB_IFObj_SetZOrder(this.cp,aVal)
	end
	this.ZPos = aVal
end

-- Sets the position. Pass nil for either arg to use current value instead
function IFObj_fnSetPos(this,x,y,z)
	this.x = x or this.x or 0.0
	this.y = y or this.y or 0.0
	this.z = z or this.z
	if(this.cp) then
		ScriptCB_IFObj_SetPos(this.cp,this.x,this.y,this.z)
	end
end

function IFObj_fnSetVis(this,v)
--	this.vis = v
	if(this.cp) then
		ScriptCB_IFObj_SetVis(this.cp,v)
	else
		this.bCreateHidden = not vis
	end
end

function IFObj_fnGetVis(this)
	if(this.cp) then
		return ScriptCB_IFObj_GetVis(this.cp)
	end
	return 1 -- always on if not yet created
end

-- Sets the color, pushes thru to C++ as needed. Pass nil for any/all
-- values to use current.
function IFObj_fnSetColor(this,R,G,B)
	if(this.cp) then
		ScriptCB_IFObj_SetColor(this.cp,R,G,B)
	else
		this.ColorR = R or this.ColorR
		this.ColorG = G or this.ColorG
		this.ColorB = B or this.ColorB
	end
end

-- Sets the color, pushes thru to C++ as needed
function IFObj_fnSetAlpha(this,a)
	if(this.cp) then
		ScriptCB_IFObj_SetAlpha(this.cp,a)
		this.alpha = nil
	else
		this.alpha = a
	end
end

function IFObj_fnCreateHotspot(this)
	if(this.cp) then
			ScriptCB_IFObj_CreateHotSpot(this.cp)
	end
end

-- Returns a bool as to whether the hotspot on the current item was
-- hit or not. If the object hasn't been created, this will return
-- nil. Non-PC builds will probably return nil all the time
function IFObj_fnTestHotSpot(this)
	if(this.cp) then
		return ScriptCB_IFObj_TestHotSpot(this.cp)
	else
		return nil
	end
end

-- Like the above, but takes params as to where the mouse is. Also
-- returns 3 values: a bool for hit, and then 2 floats, which are the
-- % into the image hit
function IFObj_fnIsMouseOver(this, x, y)
	if(this.cp) then
		return ScriptCB_IFObj_MouseOver(this.cp, x, y)
	end
end


-- Presented as a commented-out reference only. Use NewIFObj to actually make one.

-- gIFObjTemplate = {
--	x = 0,
--	y = 0,
--	width = 0,
--	height = 0,
--	alpha = 1,

	-- Disabled by default (so as to not propagate down), but presented
	-- here for completion. These values allow items, if their parent
	-- is an IFScreen, to set their screen positioning. [Must set both
	-- X & Y if you want to set either. Default is topleft]

	-- ScreenRelativeX = 0, -- 0 = left, 0.5 = center, 1 = right
	-- ScreenRelativeY = 0, -- 0 = top, 0.5 = center, 1 = bottom
	-- UseSafezone = 1, -- 0 or 1, NOT nil/1. [Otherwise, can't test for presence]

	-- Other items
	-- ZPos = 128, -- 0 = on top of all, 255 = behind all.
	--	vis = 1, -- 1 = enabled, 0 = hidden

	-- If set to 1, this object will be deleted from lua after creating the
	-- C++ version of it. That should save a small amount of memory, but
	-- prevent any further changing of it from the lua side.
	-- inert = nil,

	-- Colors. 
--	ColorR = 255,
--	ColorG = 255,
--	ColorB = 255,
-- }

function IFText_fnSetString(this,str,case)
	if(not this) then
		return
	end

	if(this.cp) then
		ScriptCB_IFText_SetString(this.cp,str,case)
		this.string = nil
		this.ustring = nil
		this.font = nil
		this.case = nil
	else
		this.string = str
		this.case = case
	end
end

function IFText_fnSetUString(this,str)
	if(this.cp) then
		ScriptCB_IFText_SetUString(this.cp,str)
		this.string = nil
		this.ustring = nil
		this.font = nil
		this.case = nil
	else
		this.ustring = str
	end
end

function IFText_fnSetFont(this,fontname)
	if(this.cp) then
		ScriptCB_IFText_SetFont(this.cp,fontname)
		this.string = nil
		this.ustring = nil
		this.font = nil
		this.case = nil
	else
		this.font = str
	end
end

function IFText_fnSetStyle(this,style)
	if(this.cp) then
		ScriptCB_IFText_SetTextStyle(this.cp,style)
		this.style = nil
	else
		this.style = style
	end
end

-- Sets the horizontal & vertical scale of the text, as a
-- multiplier. Default values for Horiz & Vertical are 1.0
function IFText_fnSetScale(this,HScale,VScale)
	HScale = HScale or 1
	VScale = VScale or 1
	if(this.cp) then
		ScriptCB_IFText_SetTextScale(this.cp,HScale, VScale)
		this.HScale = nil
		this.VScale = nil
	else
		this.HScale = HScale
		this.VScale = VScale
	end
end

-- Sets the leading of the text. This is a value added to the natural
-- height of the font, increasing or decreasing the whitespace between
-- multiple lines of text. If the string is on only one line of text,
-- this does nothing.  If the leading is > 0, it expands multiline
-- text; if < 0, it compresses multiline text. A value of 0 goes back
-- to the default interline spacing.
function IFText_fnSetLeading(this,fLeading)
	if(this.cp) then
		ScriptCB_IFText_SetLeading(this.cp, fLeading)
	else
		this.leading = fLeading -- store for later
	end
end

-- Returns the width of the string, in pixels. If things aren't pushed
-- to C yet, then this can't be calculated, and will return a negative
-- value.
function IFText_fnGetExtent(this)
	if(this.cp) then
		return ScriptCB_IFText_GetTextExtent(this.cp)
	else
		return -1 -- Can't tell, yet.
	end
end

-- Returns the display area of the string, in pixels. If things aren't pushed
-- to C yet, then this can't be calculated, and will return a negative
-- value.
function IFText_fnGetDisplayRect(this)
	if(this.cp) then
		local fLeft, fTop, fRight, fBot
		fLeft, fTop, fRight, fBot = ScriptCB_IFText_GetDisplayRect(this.cp)
		return fLeft, fTop, fRight, fBot
	else
		return -1,-1,-1,-1 -- Can't tell, yet.
	end
end

function IFText_fnSetTextBox(this, fWidth, fHeight)
	if(this.cp) then
		ScriptCB_IFText_SetTextBox(this.cp,fWidth, fHeight)
	end
end

-- Set text breaking style
function IFText_fnSetTextBreak(this, TypeStr)
	if(this.cp) then
		ScriptCB_IFText_SetTextBreak(this.cp,TypeStr)
	end
end

function IFFlashyText_fnSetup(this,delay,flipped,width,xflipped,tail)
	if(this.cp) then
		ScriptCB_IFFlashyText_Setup(this.cp,delay,flipped,width,xflipped,tail)
	end
end

function IFFlashyText_fnSetTextColor(this,r,g,b)
	if(this.cp) then
		ScriptCB_IFFlashyText_SetTextColor(this.cp, r, g, b)
	end
end

-- Presented as a commented-out reference only. Use NewIFText to actually make one.

-- gIFTextTemplate = {
-- --	type = "text",
-- 	string = "",
-- 	font = "gamefont_small",
-- 	halign = "hcenter", -- horizontal alignment : "left" "hcenter" "right"
-- 	valign = "top", -- one of "top" "vcenter" "bottom"
-- 	textw = 100, -- width onscreen
-- 	texth = 30, -- height onscreen
-- 	style = "glow",
-- 	flashy = 1,     -- intbool: whether its flashy text on creation.  0=no, other-non-nil=yes
-- 	startdelay = 0, -- float: start delay for the flashy animation
-- 	bg_flipped = nil, -- bool: is the bg triangle upside down
-- 	bg_xflipped = nil, -- bool: is the bg triangle upside down
-- 	bg_width = 0,  -- the width of the background image (-1 means use text width)
-- 	bg_tail = 0,  -- widen the background by this much on the right side (works even if the above is -1)
-- 	bgleft = "buttonleft",
-- 	bgmid = "buttonmid",
-- 	bgright = "buttonright",
-- }

-- this is the global flashy speed for vertical buttons and text, the
-- delay per element as you go down.
flashySpeed = 0.02

-- Sets the localpos_*, pushes it thru to C++ once the name is set
-- (i.e. created in C++). Pass nil for any or all params to use current
function IFImage_fnSetTexturePos(this,l,t,r,b)
	this.localpos_l = l or this.localpos_l
	this.localpos_t = t or this.localpos_t
	this.localpos_r = r or this.localpos_r
	this.localpos_b = b or this.localpos_b
	if(this.cp) then
		ScriptCB_IFImage_SetRect(this.cp,this.localpos_l,this.localpos_t,this.localpos_r,this.localpos_b)
	end
end -- fnSetTexturePos

-- Sets the UV coords, pushes it thru to C++ once the name is set
-- (i.e. created in C++). Pass nil for any or all params to use current
function IFImage_fnSetUVs(this,l,t,r,b,diag)
	this.uvs_l = l or this.uvs_l
	this.uvs_t = t or this.uvs_t
	this.uvs_r = r or this.uvs_r
	this.uvs_b = b or this.uvs_b
	this.uvs_diag = diag
	if(this.cp) then
		ScriptCB_IFImage_SetTexCoords(this.cp,this.uvs_l,this.uvs_t,this.uvs_r,this.uvs_b,this.uvs_diag)
	end
end -- fnSetUVs

-- Sets the texture, pushes it thru to C++ once the name is set
-- (i.e. created in C++) [Can also set alpha, if specified, as buttons
-- want to do both operations]
function IFImage_fnSetTexture(this, tex, a)
	this.texture = tex
	if(alpha) then
		this.alpha = a
	end
	if(this.cp) then
		ScriptCB_IFImage_SetTexture(this.cp,this.texture)
		this.texture = nil
		if(a) then
			ScriptCB_IFObj_SetAlpha(this.cp,a)
		end
	end
end -- fnSetTexture

-- Sets the localpos_*, pushes it thru to C++ once the name is set
-- (i.e. created in C++). Pass nil for any or all params to use current
function IFBorder_fnSetTexturePos(this,l,t,r,b,w,h)
	this.localpos_l = l or this.localpos_l
	this.localpos_t = t or this.localpos_t
	this.localpos_r = r or this.localpos_r
	this.localpos_b = b or this.localpos_b
	this.localpos_w = w or this.localpos_w
	this.localpos_h = h or this.localpos_h
	if(this.cp) then
		ScriptCB_IFBorder_SetRect(this.cp,this.localpos_l,this.localpos_t,this.localpos_r,this.localpos_b,this.localpos_w,this.localpos_h)
	end
end -- fnSetTexturePos

-- Sets the UV coords, pushes it thru to C++ once the name is set
-- (i.e. created in C++). Pass nil for any or all params to use current
function IFBorder_fnSetUVs(this,l,t,r,b,w,h,diag)
	this.uvs_l = l or this.uvs_l
	this.uvs_t = t or this.uvs_t
	this.uvs_r = r or this.uvs_r
	this.uvs_b = b or this.uvs_b
	this.uvs_w = w or this.uvs_w
	this.uvs_h = h or this.uvs_h
	this.uvs_diag = diag
	if(this.cp) then
		ScriptCB_IFBorder_SetTexCoords(this.cp,this.uvs_l,this.uvs_t,this.uvs_r,this.uvs_b,this.uvs_w,this.uvs_h,this.uvs_diag)
	end
end -- fnSetUVs

-- Sets the texture, pushes it thru to C++ once the name is set
-- (i.e. created in C++) [Can also set alpha, if specified, as buttons
-- want to do both operations]
function IFBorder_fnSetTexture(this, tex, a)
	this.texture = tex
	if(alpha) then
		this.alpha = a
	end
	if(this.cp) then
		ScriptCB_IFBorder_SetTexture(this.cp,this.texture)
		this.texture = nil
		if(a) then
			ScriptCB_IFObj_SetAlpha(this.cp,a)
		end
	end
end -- fnSetTexture

-- Sets the model msh for the specified model, pushes to C as appropriate
function IFModel_fnSetMsh(this, ModelStr)
	if(this.cp) then
		this.model = nil
		ScriptCB_IFModel_SetModel(this.cp,ModelStr)
	else
		this.model = ModelStr
	end
end

-- Sets the OmegaY for the specified model, pushes to C as appropriate
function IFModel_fnSetOmegaY(this, fOY)
	if(this.cp) then
		this.OmegaY = nil
		ScriptCB_IFModel_SetOmegaY(this.cp,fOY)
	else
		this.OmegaY = fOy
	end
end

-- Sets the Scale for the specified model, pushes to C as appropriate
function IFModel_fnSetScale(this, fScale)
	if(this.cp) then
		this.scale = nil
		ScriptCB_IFModel_SetScale(this.cp,fScale)
	else
		this.scale = fScale
	end
end

-- Sets the Scale for the specified model, pushes to C as appropriate
function IFModel_fnSetDepth(this, fDepth)
	if(this.cp) then
		this.depth = nil
		ScriptCB_IFModel_SetDepth(this.cp, fDepth)
	else
		this.depth = fDepth
	end
     end

function IFModel_fnAttachModel(this, attachment, hardPoint)
   ScriptCB_IFModel_AttachModel(this.cp, attachment.cp, hardPoint)
end

function IFModel_fnSetTranslation(this, x, y, z)
   if(this.cp) then
      this.x = nil
      this.y = nil
      this.z = nil
      ScriptCB_IFModel_SetTranslation(this.cp, x, y, z)
   else
      this.x = x
      this.y = y
      this.z = z
   end
end

function IFModel_fnSetRotation(this, qs, qx, qy, qz)
   if(this.cp) then
      this.qs = nil
      this.qx = nil
      this.qy = nil
      this.qz = nil
      ScriptCB_IFModel_SetRotation(this.cp, qs, qx, qy, qz)
   else
      this.qs = qs
      this.qx = qx
      this.qy = qy
      this.qz = qz
   end
end

-- Presented as a commented-out reference only. Use NewIFImage to actually make one.
-- gIFImageTemplate = {
-- --	texture = "blank", -- Ought to be specified, will show nothing if invalid
-- 	temp.localpos_l = temp.localpos_l or 0
-- 	temp.localpos_t = temp.localpos_t or 0
-- 	temp.localpos_r = temp.localpos_r or 100
-- 	temp.localpos_b = temp.localpos_b or 100
-- 	temp.uvs_l = temp.uvs_l or 0
-- 	temp.uvs_t = temp.uvs_t or 0
-- 	temp.uvs_r = temp.uvs_r or 1
-- 	temp.uvs_b = temp.uvs_b or 1
-- 	temp.uvs_diag = temp.uvs_diag or nil -- swap the uvs along the diagonal
-- }

-- Presented as a commented-out reference only. Use NewIFModel to actually make one.
-- gIFModelTemplate = {
-- 	-- Defaults. Probably need overriding anyhow.
-- 	scale = 0.5,
-- 	depth = 2.6,
-- 	lighting = nil,
-- }


-- -------------------------------------------------------------------
-- Constructors for various classes. All of these take a table, 'arg'
-- and fills in any missing (but required) components.

function NewIFObj(Template)
	local temp = Template
	temp.x = temp.x or 0
	temp.y = temp.y or 0
	return temp
end

-- More complex base types are built by calling the constructors of
-- each string.sub-type, MOST complex to LEAST. (Remember, the createObj
-- fills in values not specified (yet), so things like the type string
-- need to be inherited from the most complex one)
function NewIFText(Template)
	local temp = Template
	temp.type = "text"

	temp.string = temp.string or ""
	temp.font = temp.font or "gamefont_small"
	temp.halign = temp.halign or "hcenter" -- horizontal alignment : "left" "hcenter" "right"
	temp.valign = temp.valign or "top" -- one of "top" "vcenter" "bottom"
	temp.textw = temp.textw or 100 -- width onscreen
	temp.texth = temp.texth or 30 -- height onscreen
--	temp.style = temp.style or "glow"
	temp.flashy = temp.flashy or 1 -- intbool: whether its flashy text on creation.  0=no, other-non-nil=yes
	temp.startdelay = temp.startdelay or 0 -- float: start delay for the flashy animation
	temp.bg_flipped = temp.bg_flipped or nil -- bool: is the bg triangle upside down
	temp.bg_xflipped = temp.bg_xflipped or nil -- bool: is the bg triangle upside down
	temp.bg_width = temp.bg_width or 0  -- the width of the background image (-1 means use text width)
	temp.bg_tail = temp.bg_tail or 0  -- widen the background by this much on the right side (works even if the above is -1)
	temp.bgleft = temp.bgleft or "buttonleft"
	temp.bgmid = temp.bgmid or "buttonmid"
	temp.bgright = temp.bgright or "buttonright"

	-- Hack? If this is flagged as centered, and didn't specify an x/y position,
	-- then auto-calculate that for it.
	if((temp.halign == "hcenter") and not temp.x) then
		temp.x = temp.textw * -0.5
	end
	if((temp.valign == "vcenter") and not temp.y) then
		temp.y = temp.texth * -0.5
	end

	return NewIFObj(temp)
end

function NewIFImage(Template)
	local temp = Template
	temp.type = "image" -- temp.type or "image"
	temp.localpos_l = temp.localpos_l or 0
	temp.localpos_t = temp.localpos_t or 0
	temp.localpos_r = temp.localpos_r or 100
	temp.localpos_b = temp.localpos_b or 100
	temp.uvs_l = temp.uvs_l or 0
	temp.uvs_t = temp.uvs_t or 0
	temp.uvs_r = temp.uvs_r or 1
	temp.uvs_b = temp.uvs_b or 1
	temp.uvs_diag = temp.uvs_diag or nil -- swap the uvs along the diagonal

	if(temp.AutoHotspot) then
 		temp.tag = temp.tag or temp.AutoHotspot
 		temp.AutoHotspot = nil
 		temp.bHotspot = 1
		temp.fHotspotW = math.abs(temp.localpos_r - temp.localpos_l) + ( temp.hotspot_width or 0 )
		temp.fHotspotH = math.abs(temp.localpos_b - temp.localpos_t)
		temp.fHotspotX = math.min(temp.localpos_r,temp.localpos_l)
		temp.fHotspotY = math.min(temp.localpos_t,temp.localpos_b)
	end
	return NewIFObj(temp) 
end

function NewIFBorder(Template)
	local temp = Template
	temp.type = "border" -- temp.type or "border"
	temp.localpos_l = temp.localpos_l or 0
	temp.localpos_t = temp.localpos_t or 0
	temp.localpos_r = temp.localpos_r or 100
	temp.localpos_b = temp.localpos_b or 100
	temp.localpos_w = temp.localpos_w or 0
	temp.localpos_h = temp.localpos_h or 0
	temp.uvs_l = temp.uvs_l or 0
	temp.uvs_t = temp.uvs_t or 0
	temp.uvs_r = temp.uvs_r or 1
	temp.uvs_b = temp.uvs_b or 1
	temp.uvs_w = temp.uvs_w or 0.25
	temp.uvs_h = temp.uvs_h or 0.25
	
	temp.uvs_diag = temp.uvs_diag or nil -- swap the uvs along the diagonal

	if(temp.AutoHotspot) then
 		temp.tag = temp.tag or temp.AutoHotspot
 		temp.AutoHotspot = nil
 		temp.bHotspot = 1
		temp.fHotspotW = math.abs(temp.localpos_r - temp.localpos_l)
		temp.fHotspotH = math.abs(temp.localpos_b - temp.localpos_t)
		temp.fHotspotX = math.min(temp.localpos_r,temp.localpos_l)
		temp.fHotspotY = math.min(temp.localpos_t,temp.localpos_b)
	end
	return NewIFObj(temp) 
end

function NewIFModel(Template)
	local temp = Template
	temp.scale = temp.scale or 0.5
	temp.depth = temp.depth or 2.6
	temp.lighting = temp.lighting or nil
	temp.type = temp.type or "model"
	temp.fnSetSize = IFModel_fnSetScale
	return NewIFObj(temp)
end

function NewIFContainer(Template)
	local temp = NewIFObj(Template)
	temp.type = temp.type or "container"
	return temp
end

-- -------------------------------------------------------------------
-- Replicators for various classes. All of these take a table, 'obj'
-- and creates a C++ class hierarchy from them.

-- For a currently open object, push the IFObject components
function AddIFObjectBase(obj)
	-- Gets the pointer to the object, stores it for later
	obj.cp = ScriptCB_IFObj_GetCPointer()

	ScriptCB_IFObj_SetPos(obj.x or 0.0, obj.y or 0.0, obj.z or 0.0)
	if(obj.bInertPos) then
		obj.x = nil
		obj.y = nil
		obj.bInertPos = nil
	end

	-- Create hidden if requested
	if(obj.bCreateHidden) then
		ScriptCB_IFObj_SetVis(obj.cp, not obj.bCreateHidden)
		obj.bCreateHidden = nil
	end

	-- rotate?
	if(obj.rotX or obj.rotY or obj.rotZ) then
		ScriptCB_IFObj_SetRotation(obj.rotX or 0, obj.rotY or 0, obj.rotZ or 0)
		obj.rotX = nil
		obj.rotY = nil
		obj.rotZ = nil
	end

	if(obj.alpha) then
		ScriptCB_IFObj_SetAlpha(obj.alpha)
		obj.alpha = nil
	end

	if(obj.ScreenRelativeX) then
		ScriptCB_IFObj_SetScreenPosition(obj.ScreenRelativeX,obj.ScreenRelativeY)
		-- PC needs these for mouse. Rest can zap it
		if(gPlatformStr ~= "PC") then
			obj.ScreenRelativeX = nil
			obj.ScreenRelativeY = nil
		end
	end
	if(obj.UseSafezone) then
		ScriptCB_IFObj_SetUseSafezone(obj.UseSafezone)
	end
	if(obj.ZPos) then
		ScriptCB_IFObj_SetZOrder(obj.ZPos)
		if(gPlatformStr ~= "PC") then
			obj.ZPos = nil
		end
	end
	if(obj.ColorR) then
		ScriptCB_IFObj_SetColor(obj.ColorR,obj.ColorG,obj.ColorB)
	end

	if (obj.bHotspot) then
		if (obj.fHotspotW and obj.fHotspotH) then
			if (obj.fHotspotX and obj.fHotspotY) then
				ScriptCB_IFObj_CreateHotSpot(obj.cp, obj.fHotspotX, obj.fHotspotY, obj.fHotspotX + obj.fHotspotW, obj.fHotspotY + obj.fHotspotH)
			else
				ScriptCB_IFObj_CreateHotSpot(obj.cp, obj.fHotspotW, obj.fHotspotH)
			end
		elseif (obj.fHotspotBorder) then
			ScriptCB_IFObj_CreateHotSpot(obj.cp, obj.fHotspotBorder)
		else
			ScriptCB_IFObj_CreateHotSpot(obj.cp)
		end
		obj.bHotspot = nil
		obj.fHotspotW = nil
		obj.fHotspotH = nil
		obj.fHotspotX = nil
		obj.fHotspotY = nil
		obj.fHotspotBorder = nil
	end
end

function AddIFText(obj, name)
	if(obj.flashy and (not (obj.flashy == 0))) then
		ScriptCB_AddIFFlashyText(name)
		ScriptCB_IFFlashyText_Setup(obj.startdelay,obj.bg_flipped,obj.bg_width,obj.bg_xflipped,obj.bg_tail)
		--obj.bg_width = nil
		if(not obj.nocreatebackground) then
			ScriptCB_IFFlashyText_SetBackground(obj.bgleft,obj.bgmid,obj.bgright)
		end
		obj.nocreatebackground = nil
		obj.bgleft = nil
		obj.bgmid = nil
		obj.bgright = nil
		ScriptCB_IFFlashyText_SetBackgroundSize(obj.bgoffsetx,obj.bgoffsety,obj.bgexpandx,obj.bgexpandy)
		obj.bgoffsetx = nil
		obj.bgoffsety = nil
		obj.bgexpandx = nil
		obj.bgexpandy = nil
		ScriptCB_IFFlashyText_SetBackgroundRightJustify(obj.rightjustifybackground)
		obj.rightjustifybackground = nil
		if(obj.textcolorr) then
			ScriptCB_IFFlashyText_SetTextColor(obj.textcolorr,obj.textcolorg,obj.textcolorb)
		end
		obj.textcolorr = nil
		obj.textcolorg = nil
		obj.textcolorb = nil
	else
		ScriptCB_AddIFText(name)
	end

	-- Must push font to game before setting the base. Otherwise, hotspots
	-- are unhappy as font height isn't knowable.
	ScriptCB_IFText_SetFont(obj.font)
	AddIFObjectBase(obj)
	ScriptCB_IFText_SetJustify(obj.halign,obj.valign)
	ScriptCB_IFText_SetTextBox(obj.textw,obj.texth)

	if(obj.leading) then
		ScriptCB_IFText_SetLeading(obj.leading)
		obj.leading = nil
	end

	if(obj.HScale) then
		ScriptCB_IFText_SetTextScale(obj.HScale,obj.VScale)
		obj.HScale = nil
		obj.VScale = nil
	end


	-- Must set text last (only position, alpha, color ok to set after this)
	if(obj.ustring) then
		ScriptCB_IFText_SetUString(obj.ustring)
		obj.ustring = nil
		obj.case = nil
	elseif (obj.string) then
		ScriptCB_IFText_SetString(obj.string, obj.case)
		obj.string = nil
		obj.case = nil
	end

	if(obj.style) then
		ScriptCB_IFText_SetTextStyle(obj.style)
	end

	if(not obj.ColorR) then
-- 		-- Defaults for any w/o explicit color setting
-- 		ColorR = 194, --136,
-- 		ColorG = 42, --25,
-- 		ColorB = 38, --14,
--		ScriptCB_IFObj_SetColor(76,180,255)
		ScriptCB_IFObj_SetColor(255,255,255)
	end

	obj.string = nil
	obj.ustring = nil
	obj.font = nil
	obj.textw = nil
	obj.texth = nil
	obj.inert_all = nil
	--don't inert this since we need to know it later (to start the flashiness)
	--	obj.flashy = nil 
	--		obj.startdelay = nil
	obj.bg_flipped = nil
	obj.bg_xflipped = nil
	obj.bg_width = nil
	obj.bg_tail = nil
	obj.ColorR = nil
	obj.ColorG = nil
	obj.ColorB = nil
	obj.textw = nil
	obj.texth = nil
	obj.valign = nil
	obj.halign = nil
	obj.ZPos = nil
	obj.height = nil

	-- PC needs these for mouse
	if(gPlatformStr ~= "PC") then
		obj.x = nil
		obj.y = nil
	end

	ScriptCB_EndIFObj(name)
end

function AddIFImage(obj, name)
	if(obj.type == "image") then
		ScriptCB_AddIFImage(name)
	else
		ScriptCB_AddIFMaskImage(name)
	end
	AddIFObjectBase(obj)
	if(obj.texture) then
		ScriptCB_IFImage_SetTexture(obj.texture)
--		obj.texture = nil
	end
	ScriptCB_IFImage_SetRect(obj.localpos_l,obj.localpos_t,obj.localpos_r,obj.localpos_b)
	ScriptCB_IFImage_SetTexCoords(obj.uvs_l,obj.uvs_t,obj.uvs_r,obj.uvs_b,obj.uvs_diag)

	obj.uvs_l = nil
	obj.uvs_t = nil
	obj.uvs_r = nil
	obj.uvs_b = nil
	obj.inertUVs = nil
	obj.texture = nil
	obj.inert_all = nil
	obj.x = nil
	obj.y = nil
	obj.localpos_l = nil
	obj.localpos_t = nil
	obj.localpos_r = nil
	obj.localpos_b = nil

	if(obj.type == "maskimage") then
		if(obj.masktexture) then
			ScriptCB_IFMaskImage_SetMaskTexture(obj.masktexture)
		end
	end

	ScriptCB_EndIFObj(name)
end


function AddIFBorder(obj, name)
	ScriptCB_AddIFBorder(name)
	AddIFObjectBase(obj)
	if(obj.texture) then
		ScriptCB_IFBorder_SetTexture(obj.texture)
--		obj.texture = nil
	end
	ScriptCB_IFBorder_SetRect(obj.localpos_l,obj.localpos_t,obj.localpos_r,obj.localpos_b, obj.localpos_w, obj.localpos_h)
	ScriptCB_IFBorder_SetTexCoords(obj.uvs_l,obj.uvs_t,obj.uvs_r,obj.uvs_b,obj.uvs_w,obj.uvs_h, obj.uvs_diag)

	obj.uvs_l = nil
	obj.uvs_t = nil
	obj.uvs_r = nil
	obj.uvs_b = nil
	obj.uvs_w = nil
	obj.uvs_h = nil
	obj.inertUVs = nil
	obj.texture = nil
	obj.inert_all = nil
	obj.x = nil
	obj.y = nil
	obj.localpos_l = nil
	obj.localpos_t = nil
	obj.localpos_r = nil
	obj.localpos_b = nil
	obj.localpos_w = nil
	obj.localpos_h = nil

	ScriptCB_EndIFObj(name)
end


function AddIFModel(obj, name)
   ScriptCB_AddIFModel(name)
   AddIFObjectBase(obj)
   if(obj.model) then
      ScriptCB_IFModel_SetModel(obj.model)
   end

   -- Unfortunately Red3dModelElements have a special translation that overrides their matrix--cbb 03/30/05
   ScriptCB_IFModel_SetTranslation(obj.x or 0.0, obj.y or 0.0, obj.z or 0.0)
   ScriptCB_IFModel_SetRotation(obj.qs or 1.0, obj.qx or 0.0, obj.qy or 0.0, obj.qz or 0.0)
   if(obj.scale) then
      ScriptCB_IFModel_SetScale(obj.scale)
   end
   if(obj.depth) then
      ScriptCB_IFModel_SetDepth(obj.depth)
   end
   if(obj.OmegaY) then
      ScriptCB_IFModel_SetOmegaY(obj.OmegaY)
   end
   if(obj.lighting) then
      ScriptCB_IFModel_SetLighting(obj.lighting)
   end
   if(obj.animBanks) then
      --Hmm.  I wish Lua had `apply'....
      ScriptCB_IFModel_SetAnimationBanks(obj.animBanks[1], obj.animBanks[2], obj.animBanks[3], obj.animBanks[4], obj.animBanks[5])
   end
   if(obj.animation) then
      ScriptCB_IFModel_SetAnimation(obj.animation, 0)
   end

   ScriptCB_EndIFObj(name)
end

-- Trims unneded items from the specified container
function DoPostDelete(c)

	local NewC = {}

	-- Release lua objects once created in C++, if requested.
	local k,v
	for k,v in c do
		local type_v = type(v)

		-- Must always keep the pointers
		if (type_v == "pointer") then
			NewC[k] = v
		elseif (type_v ~= "table") then
			if((gPlatformStr == "PC") or (k ~= "type")) then
				NewC[k] = v
			end
		else -- v is a table
			-- Skip everything that's flagged as inert
			if(not v.inert) then
				if(v.type ~= "image") then
					v.x = nil
					v.y = nil
				end

				if(gPlatformStr ~= "PC") then 
					v.type = nil --not needed. PC does need this for mouse code, though.
				end

				NewC[k] = DoPostDelete(v) -- recurse down
			end -- not inert
		end -- v is a table
	end -- loop over c
	return NewC
end

function AddIFObjContainer(c, name)
	-- Sanity-check!
	if(not c) then
--		print("Uhoh... attempting to add nil container " .. name)
		return
	end

	-- Set a name on this item so that it can be looked up later
	-- by button navigation items, etc. Don't override existing name
	-- if already present.
--	c.name = c.name or name

	-- Do specific leaf-node subtypes here.
	if(c.type == "text") then
		AddIFText(c, name)
		return
	elseif ((c.type == "image") or (c.type == "maskimage")) then
		AddIFImage(c, name)
		return
	elseif (c.type == "border") then
		AddIFBorder(c, name)
		return
	elseif (c.type == "model") then
		AddIFModel(c, name)
		return
	end

	-- All IFObject params must be pushed, FIRST, then all child objects
	-- in order to set everything up. [IFScreens don't need the root obj
	-- [re]created]
	if(c.type ~= "screen") then
		ScriptCB_AddIFContainer(name)
		AddIFObjectBase(c) -- common stuff
		ScriptCB_EndIFObj(name) -- close it off
	end
	
-- 	if((c.type == "container") or (c.type == "button") or (c.type == "galaxy") or
-- 					(c.type == "listbox") or (c.type == "screen") or (c.type == "hslider") or
-- 						(c.type == "editbox")) then
-- 	else
-- 		print("Uhoh, type = ", c.type)
-- 	end

-- 	assert(((c.type == "container") or (c.type == "button") or (c.type == "galaxy") or
-- 					(c.type == "listbox") or (c.type == "screen") or (c.type == "hslider") or
-- 						(c.type == "editbox")), 
-- 				 "This is a container")

	local k,v
	for k,v in c do
		if(type(v) == "table") then
			local newname = name .. "." .. k;
			AddIFObjContainer(v, newname)
		end -- v is a table
	end

	-- Release this container once created in C++, if requested.
	c.inert_all = nil
	if(c.inert) then
		c = nil
	end
end



function AddIFScreen(table, name)
--	assert((table.type == "screen"), "This is a screen")

	ScriptCB_AddIFScreen(name)
	AddIFObjContainer(table, name)
	if(table.Viewport) then
		ScriptCB_SetIFScreenViewport(name,table.Viewport)
	end
	ScriptCB_EndIFScreen(name)
	table.ScreenName = name
end

-- Creates a popup in C, given a table and a string name
function CreatePopupInC(table, name)
--	assert((table.type ~= "screen"), "This isn't a screen")
	table.name = name -- so it can be found later

	AddIFObjContainer(table,name)
	-- Need to release glyphs we hold. Got to do it twice to ensure state
	-- changes.
	ScriptCB_IFObj_SetEnabled(table.cp, 1)
	ScriptCB_IFObj_SetEnabled(table.cp, nil)

end



-- start the flashiness for all flashy text elements in this table.  works
-- recursively, so you can just pass in an entire screen here.
function IFFlashyText_StartFlashiness(this)

	-- Do specific leaf-node subtypes here.	
	if( this.flashy and (not (this.flashy == 0)) and (not this.noTransitionFlash) and this.cp ) then
		ScriptCB_IFFlashyText_StartFlashiness( this.cp )
		return
	end

	-- Leaf case not handled above. Recurse down all subtables.
	local k,v
	for k,v in this do
		if(type(v) == "table" and (not this.noTransitionFlash)) then
			-- Recurse into this table
			IFFlashyText_StartFlashiness(v)
		end -- v is a table
	end
end

-- start the flashiness for just one of the elements in the table
-- call this with a math.random number to flash one randomly
function IFFlashyText_FlashElementNum(this,cnt)

	-- Do specific leaf-node subtypes here.	
	if( this.flashy and (not (this.flashy == 0)) and this.cp ) then
		if(cnt == 0) then
			ScriptCB_IFFlashyText_StartFlashiness( this.cp )
		end
		return cnt - 1
	end

	-- Leaf case not handled above. Recurse down all subtables.
	local k,v
	for k,v in this do
		if(type(v) == "table") then
			-- Recurse into this table
			cnt = IFFlashyText_FlashElementNum(v,cnt)
		end -- v is a table
	end
	return cnt
end

-- OFFICIALLY DECLARED ANNOYING - DEPRECATED!  9/22/05 -------------

-- start the flashiness for just one of the elements in the table
-- call this with a math.random number to flash one randomly
function IFFlashyText_DoRandomFlashiness(this)
--	-- pick a math.random element number to flash
--	local num = math.random(1,50)
--	-- loop until we flash that one
--	while (num > 0) do
--		local numbefore = num
--		num = IFFlashyText_FlashElementNum(this,num)
--		if(num == numbefore) then
--			return
--		end
--	end
end

--------------------------------------------------------------------

-- call this constantly from update, with the bool isOn set to true when
-- its active
function IFObj_UpdateBlinkyAnim(obj,isOn,minAlpha,maxAlpha,timeUp,timeDn)
	if(not obj.bAnimActive) then
		if(isOn or obj.BlinkyAnimUp) then
			local st,en,tm
			if(obj.BlinkyAnimUp) then
				st = minAlpha
				en = maxAlpha
				tm = timeUp
			else
				st = maxAlpha
				en = minAlpha
				tm = timeDn
			end
			obj.BlinkyAnimUp = not obj.BlinkyAnimUp
			AnimationMgr_AddAnimation(obj,	{ fTotalTime = tm, fStartAlpha = st, fEndAlpha = en,})
		else
			obj.BlinkyAnimUp = nil
			IFObj_fnSetAlpha(obj,1)
		end
	end
end

