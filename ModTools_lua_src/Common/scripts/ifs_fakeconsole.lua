--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Multiplayer game name screen.

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function Fakeconsole_Listbox_CreateItem(layout)

	local insidewidth = layout.width - 20;
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * insidewidth, y=layout.y + 2,
		bInertPos = 1,
	}
	local FontHeight = fakeconsole_listbox_layout.fontheight
	Temp.showstr = NewIFText{
		x = 10, y = FontHeight * -0.5, textw = insidewidth, texth = layout.height,
		halign = "left", valign = "vcenter",
		font = fakeconsole_listbox_layout.font,
		ColorR= 255, ColorG = 255, ColorB = 255,
		style = "normal",
		nocreatebackground=1,
		inert_all = 1,
	}

	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function Fakeconsole_Listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	if(Data) then
		-- Contents to show. Do so.
		if(gBlankListbox) then
			IFText_fnSetString(Dest.showstr,"") -- reduce glyphcache usage
		else
			IFText_fnSetString(Dest.showstr,Data.ShowStr)
		end

		IFObj_fnSetColor(Dest.showstr, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.showstr, fAlpha)
	end

	IFObj_fnSetVis(Dest,Data) -- Show if there are contents	
end

fakeconsole_listbox_layout = {
	-- Height is calculated from yHeight, Spacing, showcount.
	yHeight = 22,
	ySpacing  = 0,
	showcount = 9,
	font = gListboxItemFont,

 	width = 320,
	x = 0,
	slider = 1,
	CreateFn = Fakeconsole_Listbox_CreateItem,
	PopulateFn = Fakeconsole_Listbox_PopulateItem,
}

gConsoleCmdList = {}

ifs_fakeconsole = NewIFShellScreen {
	nologo = 1,

	Enter = function(this, bFwd)


						-- MUST do this after AddIFScreen! This is done here, and not in
						-- Enter to make the memory footprint more consistent.
						fakeconsole_listbox_layout.FirstShownIdx = 1
						fakeconsole_listbox_layout.SelectedIdx = 1
						fakeconsole_listbox_layout.CursorIdx = 1
						ScriptCB_GetConsoleCmds() -- puts contents in gConsoleCmdList

		ListManager_fnFillContents(ifs_fakeconsole.listbox,gConsoleCmdList,fakeconsole_listbox_layout)
	end,

	Exit = function(this, bFwd)
		gBlankListbox = 1
		ListManager_fnFillContents(ifs_fakeconsole.listbox,gConsoleCmdList,fakeconsole_listbox_layout)
		gBlankListbox = nil
	end,

	-- Accept button bumps the page
	Input_Accept = function(this)
		if(gMouseListBoxSlider) then
			ListManager_fnScrollbarClick(gMouseListBoxSlider)
			return
		end
		if(gMouseListBox) then
			ScriptCB_SndPlaySound("shell_select_change")
			gMouseListBox.Layout.SelectedIdx = gMouseListBox.Layout.CursorIdx
			ListManager_fnFillContents(gMouseListBox,gMouseListBox.Contents,gMouseListBox.Layout)
--			return
		end

		if(this.CurButton == "_back") then -- Make PC work better - NM 8/5/04
			this:Input_Back()
			return
		end

		local Selection = gConsoleCmdList[fakeconsole_listbox_layout.SelectedIdx]
		ScriptCB_SndPlaySound("shell_menu_enter");
		ScriptCB_DoConsoleCmd(Selection.ShowStr)
		ScriptCB_PopScreen()
	end,

	--Back button quits this screen
	Input_Back = function(this)
		ScriptCB_SndPlaySound("shell_menu_exit");
		ScriptCB_PopScreen()
	end,

	Input_GeneralUp = function(this)
		ListManager_fnNavUp(this.listbox,gConsoleCmdList,fakeconsole_listbox_layout)
	end,
	Input_GeneralDown = function(this)
		ListManager_fnNavDown(this.listbox,gConsoleCmdList,fakeconsole_listbox_layout)
	end,

	Input_LTrigger = function(this)
		ListManager_fnPageUp(this.listbox,gConsoleCmdList,fakeconsole_listbox_layout)
	end,
	Input_RTrigger = function(this)
		ListManager_fnPageDown(this.listbox,gConsoleCmdList,fakeconsole_listbox_layout)
	end,

	-- No L/R functionality possible on this screen (gotta have stubs
	-- here, or the base class will override)
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,
}

function ifs_fakeconsole_fnBuildScreen(this)
	fakeconsole_listbox_layout.fontheight = ScriptCB_GetFontHeight(fakeconsole_listbox_layout.font)
	fakeconsole_listbox_layout.yHeight = fakeconsole_listbox_layout.fontheight

	this.listbox = NewButtonWindow {
		ZPos = 200, x=0, y = 0,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.48, -- middle of screen

		width = fakeconsole_listbox_layout.width + 35,
		height = fakeconsole_listbox_layout.showcount * (fakeconsole_listbox_layout.yHeight + fakeconsole_listbox_layout.ySpacing) + 30,
	}
	ListManager_fnInitList(this.listbox,fakeconsole_listbox_layout)
end

-- Set up listbox

ifs_fakeconsole_fnBuildScreen(ifs_fakeconsole)
ifs_fakeconsole_fnBuildScreen = nil

AddIFScreen(ifs_fakeconsole,"ifs_fakeconsole")
ifs_fakeconsole = DoPostDelete(ifs_fakeconsole)

