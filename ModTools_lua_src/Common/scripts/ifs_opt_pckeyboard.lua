--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- pc keyboard options screen
-----------------------------------
-- key press popup

ifs_opt_pckeyboard_Popup_KeyPress = NewPopup {		
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.5,
	height = 100,
	width = 180,
	ZPos = 50,

	title = NewIFText {
		string = "ifs.GameOpt.pc_keybindpopup",
		font = "gamefont_medium",
		textw = 160,
		texth = 80,
		y = -40,
		inert = 1,
	},

	buttons = NewIFContainer {
	},

	Input_GeneralUp = function(this)
	end,
	Input_GeneralDown = function(this)
	end,
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,
	
	Enter = function(this)
		print("Entered the enter function")
		this.gDelay = 0.35
	end,
	
	Input_Back = function(this)
	end,

	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt)  -- call base class
		this.gDelay = this.gDelay - fDt
		
		if (this.gDelay > 0.0) then
			return
		end
		
		rtype = ScriptCB_SetBinding(ifs_opt_pckeyboard_listbox_layout.SelectedIdx)
		if(rtype == 1) then
			print("Detected Input")
			ifs_opt_pckeyboard.RepaintListbox(ifs_opt_pckeyboard)
			gPopup_fnInput_Back(this)
		end
	end
}

--AddVerticalButtons(ifs_opt_pckeyboard_Popup_KeyPress.buttons,Vertical_YesNoButtons_layout)
CreatePopupInC(ifs_opt_pckeyboard_Popup_KeyPress,"ifs_opt_pckeyboard_Popup_KeyPress")

---------------------------------------------

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_opt_pckeyboard_Listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y=layout.y - 10
	}
	Temp.actionStr = NewIFText{
		x = 10, y = 0, textw = 0.25 * layout.width, valign = "vcenter", halign = "left", font = "gamefont_medium",
		--ColorR= 255, ColorG = 255, ColorB = 255,
		flashy = 0,
		texth = layout.height,
	}
	Temp.keyStr = NewIFText{ 
		x = layout.width*.33, y = 0, 
		textw = 0.75 * layout.width, valign = "vcenter", halign = "left", font = "gamefont_medium",
		ColorR= 255, ColorG = 255, ColorB = 255,
		flashy = 0,
		texth = layout.height,
	}

		
	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_opt_pckeyboard_Listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	if(Data) then
		IFText_fnSetString(Dest.actionStr,Data.actionStr)
		IFText_fnSetString(Dest.keyStr,Data.keyStr)

		IFObj_fnSetColor(Dest.actionStr, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.actionStr, fAlpha)
		IFObj_fnSetColor(Dest.keyStr, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.keyStr, fAlpha)
	end

	IFObj_fnSetVis(Dest,Data) -- Show if there are contents
end

ifs_opt_pckeyboard_listbox_layout = {
	showcount = 20,
--	yTop = -130 + 13,
	yHeight = 22,
	ySpacing  = 7,
	width = 430,
	x = 0,
	slider = 1,
	CreateFn = ifs_opt_pckeyboard_Listbox_CreateItem,
	PopulateFn = ifs_opt_pckeyboard_Listbox_PopulateItem,
	font = "gamefont_tiny",
	
}


ifs_opt_pckeyboard_listbox_contents = {
--	{ actionStr = "Fire", keyStr = "Ctrl"},
}

ifs_opt_pckeyboard = NewIFShellScreen {
	nologo = 1,
	bNohelptext = 1,
    movieIntro      = nil, -- played before the screen is displayed
    movieBackground = nil, -- played while the screen is displayed

	title = NewIFText {
		string = "ifs.GameOpt.pc_keyconfigtitle",
		font = "gamefont_large",
		y = 0,
		textw = 460, -- center on screen. Fixme: do real centering!
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0, -- top
		ColorR= 255, ColorG = 255, ColorB = 255, -- Something that's readable!
	},

	Enter = function(this)
		-- Reset listbox, show it. [Remember, Lua starts at 1!]
		ifs_opt_pckeyboard_listbox_layout.FirstShownIdx = 1
		ifs_opt_pckeyboard_listbox_layout.SelectedIdx = 1
		ifs_opt_pckeyboard_listbox_layout.CursorIdx = 1

		ScriptCB_GetKeyBoardCmds()
		ListManager_fnFillContents(this.listbox,ifs_opt_pckeyboard_listbox_contents,ifs_opt_pckeyboard_listbox_layout)
	end,

	-- Accept button bumps the page
	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		ifs_opt_pckeyboard_Popup_KeyPress:fnActivate(1)
	end,

	Input_GeneralUp = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputUp(this)) then
			return
		end

--		ListManager_fnNavUp(this.listbox,ifs_opt_pckeyboard_listbox_contents,ifs_opt_pckeyboard_listbox_layout)
	end,
	
	Input_GeneralDown = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputDown(this)) then
			return
		end
--		ListManager_fnNavDown(this.listbox,ifs_opt_pckeyboard_listbox_contents,ifs_opt_pckeyboard_listbox_layout)
	end,

	Input_GeneralLeft = function(this)
	end,
	
	Input_GeneralRight = function(this)
	end,
	
	Input_Misc2 = function(this)
		ListManager_fnNavDown(this.listbox,ifs_opt_pckeyboard_listbox_contents,ifs_opt_pckeyboard_listbox_layout)
	end,
	Input_Misc1 = function(this)
		ListManager_fnNavUp(this.listbox,ifs_opt_pckeyboard_listbox_contents,ifs_opt_pckeyboard_listbox_layout)
	end,
-- 	Update = function(this, fDt)
-- 		-- Call default base class's update function (make button bounce)
-- 		gIFShellScreenTemplate_fnUpdate(this,fDt)
-- 	end,

	-- Callback (from C++) to repaint the listbox with the current contents
	-- in the global stats_listbox_contents
 	RepaintListbox = function(this)
		ScriptCB_GetKeyBoardCmds()	
 		ListManager_fnFillContents(this.listbox,ifs_opt_pckeyboard_listbox_contents,ifs_opt_pckeyboard_listbox_layout)
	end,
}

-- Helper function, sets up parts of this screen that need any
-- programmatic work (i.e. scaling to screensize)
function ifs_opt_pckeyboard_fnInitScreen(this)
	-- Inset slightly from fulls screen size
	local w,h = ScriptCB_GetSafeScreenInfo()
	w = w * 0.95
	h = h * 0.92

	this.listbox = NewButtonWindow { ZPos = 200, x=0, y = 0,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.54, -- middle of screen
		width = w,
		height = h,
	}

	ifs_opt_pckeyboard_listbox_layout.width = w - 50
	ifs_opt_pckeyboard_listbox_layout.showcount = math.floor(h / (ifs_opt_pckeyboard_listbox_layout.yHeight + ifs_opt_pckeyboard_listbox_layout.ySpacing)) - 1
	
	ListManager_fnInitList(ifs_opt_pckeyboard.listbox,ifs_opt_pckeyboard_listbox_layout)
end

ifs_opt_pckeyboard_fnInitScreen(ifs_opt_pckeyboard)

AddIFScreen(ifs_opt_pckeyboard,"ifs_opt_pckeyboard")
