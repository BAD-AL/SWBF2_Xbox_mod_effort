--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Interface screen for the metagame. Going to get kinda big, as it
-- does most of the work

-- Helper function. Builds the chunks for this screen programatically
-- (i.e. based on screensize). It makes and shoves things into the
-- 'this.Info' block, which is a container aligned to the right-middle
-- of the screen. Thus, within its space, x=0 is the right edge,
-- x=-100 is to its left. y=0 is the middle of the screen, y=-100 is
-- above that, y=100 is below.

function ifs_readyselect_fnBuildScreen(this, mode)
	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
	
	-- Make a box that's aligned to the right-middle of the screen
	-- to shove our stuff into
	this.Info = NewIFContainer {
		ScreenRelativeX = 1.0,
		ScreenRelativeY = 0.5,
		inert = 1, -- delete from Lua memory once pushed to C
	}

	-- Tweak helptext for splitscreen
	if((gPlatformStr ~= "PC") and this.Helptext_Back) then
		if ( mode == 0 ) then
			this.Helptext_Back.helpstr.font = "gamefont_small"
		else
			this.Helptext_Back.helpstr.font =  "gamefont_tiny"
		end
		IFText_fnSetString(this.Helptext_Back.helpstr, "game.spawndisplay.readydisplay.promptprev")
	end

end

ifs_readyselect1 = NewIFShellScreen {
	nologo = 1,
	bNohelptext_accept = 1,

	-- Actual contents are created in ifs_readyselect_fnBuildScreen

	-- Note: for now, the exe is handling all the inputs/events, so this
	-- screen has no Enter/Exit/Update/Input handlers. It does have an
	-- Input_Back handler to override the base class's default functionality
	-- (go to previous screen)
	Input_Back = function(this)
							 end,
	Input_GeneralLeft = function(this,bFromAI)
	end,
	Input_GeneralRight = function(this,bFromAI)
	end,
	Input_GeneralUp = function(this,bFromAI)
	end,
	Input_GeneralDown = function(this,bFromAI)
	end,
	
}

ifs_readyselect2 = NewIFShellScreen {
	nologo = 1,
	bNohelptext_accept = 1,

	-- Actual contents are created in ifs_readyselect_fnBuildScreen

	-- Note: for now, the exe is handling all the inputs/events, so this
	-- screen has no Enter/Exit/Update/Input handlers. It does have an
	-- Input_Back handler to override the base class's default functionality
	-- (go to previous screen)
	Input_Back = function(this)
							 end,
	Input_GeneralLeft = function(this,bFromAI)
	end,
	Input_GeneralRight = function(this,bFromAI)
	end,
	Input_GeneralUp = function(this,bFromAI)
	end,
	Input_GeneralDown = function(this,bFromAI)
	end,
	
}

ifs_readyselect3 = NewIFShellScreen {
	nologo = 1,
	bNohelptext_accept = 1,

	-- Actual contents are created in ifs_readyselect_fnBuildScreen

	-- Note: for now, the exe is handling all the inputs/events, so this
	-- screen has no Enter/Exit/Update/Input handlers. It does have an
	-- Input_Back handler to override the base class's default functionality
	-- (go to previous screen)
	Input_Back = function(this)
							 end,
	Input_GeneralLeft = function(this,bFromAI)
	end,
	Input_GeneralRight = function(this,bFromAI)
	end,
	Input_GeneralUp = function(this,bFromAI)
	end,
	Input_GeneralDown = function(this,bFromAI)
	end,
	
}

ifs_readyselect4 = NewIFShellScreen {
	nologo = 1,
	bNohelptext_accept = 1,

	-- Actual contents are created in ifs_readyselect_fnBuildScreen

	-- Note: for now, the exe is handling all the inputs/events, so this
	-- screen has no Enter/Exit/Update/Input handlers. It does have an
	-- Input_Back handler to override the base class's default functionality
	-- (go to previous screen)
	Input_Back = function(this)
							 end,
	Input_GeneralLeft = function(this,bFromAI)
	end,
	Input_GeneralRight = function(this,bFromAI)
	end,
	Input_GeneralUp = function(this,bFromAI)
	end,
	Input_GeneralDown = function(this,bFromAI)
	end,
	
}

if(not ScriptCB_IsSplitscreen()) then

	--its not splitscreen do it normally
	ifs_readyselect_fnBuildScreen(ifs_readyselect1, 0)
	AddIFScreen(ifs_readyselect1,"ifs_readyselect1")
	ifs_readyselect2 = nil -- flush from memory
	ifs_readyselect3 = nil -- flush from memory
	ifs_readyselect4 = nil -- flush from memory
	
else
	-- is splitscreen. Rearrange things
	
	ifs_readyselect_fnBuildScreen(ifs_readyselect1, 1)
	ifs_readyselect1.Viewport = 0
	AddIFScreen(ifs_readyselect1,"ifs_readyselect1")

	ifs_readyselect_fnBuildScreen(ifs_readyselect2, 1)
	ifs_readyselect2.Viewport = 1
	AddIFScreen(ifs_readyselect2,"ifs_readyselect2")
	ifs_readyselect2 = DoPostDelete(ifs_readyselect2)

	if(gPlatformStr == "XBox") then
		ifs_readyselect_fnBuildScreen(ifs_readyselect3, 1)
		ifs_readyselect3.Viewport = 2
		AddIFScreen(ifs_readyselect3,"ifs_readyselect3")
		ifs_readyselect3 = DoPostDelete(ifs_readyselect3)

		ifs_readyselect_fnBuildScreen(ifs_readyselect4, 1)
		ifs_readyselect4.Viewport = 3
		AddIFScreen(ifs_readyselect4,"ifs_readyselect4")
		ifs_readyselect4 = DoPostDelete(ifs_readyselect4)
	else
		ifs_readyselect3 = nil -- flush from memory
		ifs_readyselect4 = nil -- flush from memory
	end
end

ifs_readyselect_fnBuildScreen = nil -- free up memory
ifs_readyselect1 = DoPostDelete(ifs_readyselect1)


