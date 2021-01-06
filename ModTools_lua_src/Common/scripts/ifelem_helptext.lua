--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Code to create & modify 'helptext' -- a button icon and associated
-- text.

-- Code to make a new helptext. In the template, pass in the following:
-- 
-- Template.ScreenRelativeX, .ScreenRelativeX, .x, .y -- self-explanatory
-- Template.buttonicon = "btna" -- texture for button
-- Template.string = text to show.
-- Template.bRightJustify . nil = left, 1 = right justify

function NewHelptext(Template)
	local TextW = 460

	local ret = NewIFContainer {
		ScreenRelativeX = Template.ScreenRelativeX,
		ScreenRelativeY = Template.ScreenRelativeY,
		y = Template.y, -- just above bottom
		x = Template.x,
				
		icon = NewIFImage { 
			ZPos = 200, -- behind most.
			
			texture = Template.buttonicon,
			localpos_l = Template.bRightJustify and -gHelptextIconWidth or 0,
			localpos_t = gHelptextIconHeight * -0.5,
			localpos_r = Template.bRightJustify and 0 or gHelptextIconWidth,
			localpos_b = gHelptextIconHeight * 0.5,
--			inert = 1, -- Delete this out of lua once created (we'll never touch it again)
		},
		
		helpstr = NewIFText {
			string = Template.string,
			font = "gamefont_small",
			textw = TextW,
			x = Template.bRightJustify and -TextW-20 or 20,
			y = -8,
			ColorR = gHelptextTextColor[1], ColorG = gHelptextTextColor[2], ColorB = gHelptextTextColor[3], alpha = gHelptextTextAlpha,
			halign = Template.bRightJustify and "right" or "left",
			nocreatebackground = 1,
		},
	} -- end of ret

	return ret
end

-- Helper function for right-justified icon + text containers. Each
-- container must have a .icon and a .helpstr field.
function gHelptext_fnMoveIcon(Container)
--	local fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(Container.helpstr)
--	local TextW = fRight - fLeft + 10
--	IFImage_fnSetTexturePos(Container.icon,-TextW -gHelptextIconWidth, gHelptextIconHeight * -0.5, -TextW, gHelptextIconHeight * 0.5)
end

