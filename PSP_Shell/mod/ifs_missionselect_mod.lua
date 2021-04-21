-- PSP ifs_missionselect.lua  (preview mod)
--  mod by BAD_AL & AnthonyBF2

--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Generalized mission select screen. Done to unify the varions
-- screens. BF1 unified to one screen for a while, then was fractured
-- for the platforms. Let's try and keep this together once again!

-- Internal set of pages:
-- this.iColumn == 0   -> map selection column
-- this.iColumn == 1   -> mode selection column
-- this.iColumn == 2   -> era selection column
-- this.iColumn == 3   -> playlist selection column
-- this.iColumn == 4   -> Game Options button at bottom
-- this.iColumn == 5   -> Launch Game button at bottom
-- this.iColumn == 6   -> Sorted/Random Order button at bottom
-- 
-- The built-up list of maps is put in gPickedMaplist, which has
-- entries in the following form:
--
-- gPickedMapList = {
--   { Map = "nab1c", Side = 1, SideChar = "r" },
--   { ... }
-- }

-- new state machine to manages hiding/showing of various list boxes.


ifs_ms_state = {
   map = 0,			-- select map
   mode = 1,			-- select game mode
   era = 2, 			-- select era
   command = 3,			-- map commands: launch, add, remove, options
   playlist = 4,		-- select which map to remove from playlist
}

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_ms_MapList_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, 
		y = layout.y,
	}

	Temp.map = NewIFText { 
		x = 8,
		y = layout.height * -0.5 + 2,
		halign = "left", valign = "top",
		font = ifs_missionselect.listboxfont,
		textw = layout.width - 10, texth = layout.height,
		startdelay=math.random()*0.5, nocreatebackground=1, 
	}

	return Temp
end

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_ms_ModeList_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, 
		y = layout.y,
	}

	local IconHeight = layout.height * 0.75
	if ( gLangStr ~= "english" and gLangStr ~= "uk_english" ) then
	   IconHeight = 0.5 * IconHeight
	end

	Temp.mode = NewIFText { 
		x = 8,
		y = layout.height * -0.5 + 2,
		halign = "left", valign = "top",
		font = ifs_missionselect.listboxfont,
		textw = layout.width - IconHeight - 10, texth = layout.height,
		startdelay=math.random()*0.5, nocreatebackground=1, 
	}

	Temp.icon = NewIFImage {
		ZPos = 240, 
		localpos_l = layout.width - 5 - IconHeight,
		localpos_r = layout.width - 5,
		localpos_t = (IconHeight * -0.5) + 2,
		localpos_b = (IconHeight * 0.5) + 2,
	}

	return Temp
end

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_ms_EraList_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, 
		y = layout.y,
	}

	local IconHeight = layout.height * 0.375

	Temp.era = NewIFText { 
		x = 8,
		y = -0.5 * layout.height + 4,
		halign = "left", valign = "top",
		font = ifs_missionselect.listboxfont,
		textw = layout.width - IconHeight - 10, texth = layout.height,
		startdelay=math.random()*0.5, nocreatebackground=1, 
	}

	Temp.icon1 = NewIFImage {
		ZPos = 240, 
		localpos_l = layout.width - 5 - IconHeight,
		localpos_r = layout.width - 5,
		localpos_t = (IconHeight * -0.5) + 2,
		localpos_b = (IconHeight * 0.5) + 2,
		ColorR = 128,
		ColorG = 128,
		ColorB = 128,
	}

	return Temp
end

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_ms_PlayList_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, 
		y = layout.y,
	}

	local HAlign = "left"
	local WidthAdj = -10

	local IconHeight = layout.height * 0.75
	if ( gLangStr ~= "english" and gLangStr ~= "uk_english" ) then
	   IconHeight = 0.5 * IconHeight
	end

	Temp.map = NewIFText { 
		x = 8,
		y = layout.height * -0.5 + 2,
		halign = "left", valign = "top",
		font = ifs_missionselect.listboxfont,
		textw = layout.width - 2 * IconHeight + WidthAdj, texth = layout.height,
		startdelay=math.random()*0.5, 
		nocreatebackground=1, 
	}

	Temp.icon = NewIFImage {
		ZPos = 240, 
		localpos_l = layout.width - 5 - IconHeight,
		localpos_r = layout.width - 5,
		localpos_t = (IconHeight * -0.5) + 2,
		localpos_b = (IconHeight * 0.5) + 2,
	}

	Temp.icon1 = NewIFImage {
		ZPos = 240, 
		localpos_l = layout.width - 3 - IconHeight - 5 - IconHeight,
		localpos_r = layout.width - 3 - IconHeight - 5,
		localpos_t = (IconHeight * -0.5) + 2,
		localpos_b = (IconHeight * 0.5) + 2,
		ColorR = 128,
		ColorG = 128,
		ColorB = 128,
	}

	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_ms_MapList_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	if(Data) then
	   IFObj_fnSetColor(Dest.map, iColorR, iColorG, iColorB)
	   IFObj_fnSetAlpha(Dest.map, fAlpha)

	   -- Show the data
	   local DisplayUStr,iSource = missionlist_GetLocalizedMapName(Data.mapluafile)

	   IFText_fnSetUString(Dest.map,DisplayUStr)
	end

	IFObj_fnSetVis(Dest.map,Data)
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_ms_ModeList_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	local bShowIcon = Data and (Data.icon)

	if(Data) then
	   IFObj_fnSetColor(Dest.mode, iColorR, iColorG, iColorB)
	   IFObj_fnSetAlpha(Dest.mode, fAlpha)

	   local DisplayUStr = ScriptCB_getlocalizestr(Data.showstr)

	   -- If Data.icon exists, set the texture on it.
	   if(bShowIcon) then
	      IFImage_fnSetTexture(Dest.icon, Data.icon)
	   end

	   -- Show the data
	   IFText_fnSetUString(Dest.mode, DisplayUStr)
	end

	IFObj_fnSetVis(Dest.mode,Data)
	IFObj_fnSetVis(Dest.icon,bShowIcon)
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_ms_EraList_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	local bShowIcon = Data and (Data.icon1)
	if(Data) then
	   IFObj_fnSetColor(Dest.era, iColorR, iColorG, iColorB)
	   IFObj_fnSetAlpha(Dest.era, fAlpha)

	   local DisplayUStr = ScriptCB_getlocalizestr(Data.showstr)

	   -- If Data.icon1 exists, set the texture on icons
	   if(bShowIcon) then
	      IFImage_fnSetTexture(Dest.icon1, Data.icon1)
	      IFObj_fnSetColor(Dest.icon1, iColorR, iColorG, iColorB)
	      IFObj_fnSetAlpha(Dest.icon1, fAlpha)
	   end

	   -- Show the data
	   IFText_fnSetUString(Dest.era, DisplayUStr)
	end

	IFObj_fnSetVis(Dest.era,Data)
	IFObj_fnSetVis(Dest.icon1,bShowIcon)
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_ms_PlayList_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	local bShowIcon = Data
	local bShowIcon1 = Data

	if(Data) then
	   IFObj_fnSetColor(Dest.map, iColorR, iColorG, iColorB)
	   IFObj_fnSetAlpha(Dest.map, fAlpha)

	   local DisplayUStr,iSource = missionlist_GetLocalizedMapName(Data.Map)
	   IFText_fnSetUString(Dest.map,DisplayUStr)

	   local MapMode = missionlist_GetMapMode(Data.Map)
	   if((MapMode) and (MapMode.icon)) then
	      IFImage_fnSetTexture(Dest.icon, MapMode.icon)
	      IFObj_fnSetColor(Dest.icon, iColorR, iColorG, iColorB)
	      IFObj_fnSetAlpha(Dest.icon, fAlpha)
	   else
	      bShowIcon = nil
	   end

	   local MapEra = missionlist_GetMapEra(Data.Map)
	   if((MapEra) and (MapEra.icon1)) then
	      IFImage_fnSetTexture(Dest.icon1, MapEra.icon1)
	      IFObj_fnSetColor(Dest.icon1, iColorR, iColorG, iColorB)
	      IFObj_fnSetAlpha(Dest.icon1, fAlpha)
	   else
	      bShowIcon1 = nil
	   end
	   
	end

	-- Turn on/off depending on whether data's there or not
	IFObj_fnSetVis(Dest.map,Data)
	IFObj_fnSetVis(Dest.icon,bShowIcon)
	IFObj_fnSetVis(Dest.icon1,bShowIcon1)
end

-- snip

ifs_ms_MapList_layout = {
	showcount = 10,
--	yTop = -130 + 13, -- auto-calc'd now
	yHeight = 20,
	ySpacing  = 0,
--	width = 260,
	x = 0,
	slider = 1,
	CreateFn = ifs_ms_MapList_CreateItem,
	PopulateFn = ifs_ms_MapList_PopulateItem,
}

ifs_ms_ModeList_layout = {
	showcount = 10,
--	yTop = -130 + 13, -- auto-calc'd now
	yHeight = 20,
	ySpacing  = 0,
--	width = 260,
	x = 0,
	slider = 1,
	CreateFn = ifs_ms_ModeList_CreateItem,
	PopulateFn = ifs_ms_ModeList_PopulateItem,
}

ifs_ms_EraList_layout = {
	showcount = 10,
-- 	showcount = 3,
--	yTop = -130 + 13, -- auto-calc'd now
	yHeight = 20,
	ySpacing  = 0,
--	width = 260,
	x = 0,
	slider = 1,
	CreateFn = ifs_ms_EraList_CreateItem,
	PopulateFn = ifs_ms_EraList_PopulateItem,
}

ifs_ms_PlayList_layout = {
	showcount = 7,
--	yTop = -130 + 13, -- auto-calc'd now
	yHeight = 22,
	ySpacing  = 0,
--	width = 260,
	x = 0,
	slider = 1,
	CreateFn = ifs_ms_PlayList_CreateItem,
	PopulateFn = ifs_ms_PlayList_PopulateItem,
}

ifs_ms_CommandButton_layout = {

   yTop = -100, -- PSP   yTop = -130,
--   xTop = 50,
   -- xSpacing = 1, -- 10
   -- ySpacing = 1, -- 5
   -- yHeight = 13, -- 80
   -- UseYSpacing = 0, -- 1
   -- bNoDefaultSizing = 1,
   HardWidthMax = 80, -- 80
   font = "gamefont_tiny",
   buttonlist = { 
      { tag = "launch", string = "ifs.missionselect.buttons.text.launch", },
      { tag = "add", string = "ifs.missionselect.buttons.text.add", },
      { tag = "remove", string = "ifs.missionselect.buttons.text.remove", },
      { tag = "options", string = "ifs.missionselect.buttons.text.options", },
   },
	 bAllSquareButtons = 1,
}

function ifs_missionselect_fnShowHideListboxes(this,bShowThem)
	local A1,A2
	local fAnimTime = 0.3

	if(bShowThem) then
		A1 = 0
		A2 = 1
	else
		A1 = 1
		A2 = 0
	end

	AnimationMgr_AddAnimation(this.MapListbox,  { fStartAlpha = A1, fEndAlpha = A2,})
	AnimationMgr_AddAnimation(this.ModeListbox, { fStartAlpha = A1, fEndAlpha = A2,})
	AnimationMgr_AddAnimation(this.EraListbox,  { fStartAlpha = A1, fEndAlpha = A2,})
	AnimationMgr_AddAnimation(this.PlayListbox, { fStartAlpha = A1, fEndAlpha = A2,})
end


--- 
--- Two methods to show a preview.
--- 1. There exists a 'preview\\<mapname>.lvl file with an image in it called 'preview'
---      example "_lvl_psp\\preview\\cor1.lvl"
---
--- 2. There is a 'preview' entry in the mission list item that points to an lvl with a 'preview' image inside.
---      example "_lvl_psp\\addon\\002\\preview\\abc.lvl" 
--- 
function ifs_missionselect_fnUpdateMapPreview(this, mapSelection)
	local preview = "no_preview" -- default preview image 
	
	local percentIndex = string.find(mapSelection.mapluafile, "%",1,true)  -- Get the map name 
	local mapName = mapSelection.mapluafile 
	if( percentIndex) then 
		mapName = string.sub(mapSelection.mapluafile, 1,percentIndex-1)  -- from the mapluafile
	end 
	
	local builtInPreviewFile = string.format("preview\\%s.lvl", mapName)
	
	if(mapSelection.preview ~= nil and ScriptCB_IsFileExist(mapSelection.preview) == 1) then 
		-- preview must be an image named 'preview' inside the lvl mentioned 
		ReadDataFile(mapSelection.preview)
		preview = "preview"
	elseif(ScriptCB_IsFileExist(builtInPreviewFile) ==1) then 
		ReadDataFile(builtInPreviewFile)
		preview = "preview"
	end 
	IFMapPreview_fnSetTexture(this.MapPreview, preview)
end 

-- Helper function: adjusts the helptext in the info boxes up top
function ifs_missionselect_fnUpdateInfoBoxes(this)
	local MapSelection = missionselect_listbox_contents[ifs_ms_MapList_layout.SelectedIdx]

	if (this.iState == ifs_ms_state.map) then
	   local DisplayUStr,iSource = missionlist_GetLocalizedMapDescr(MapSelection.mapluafile)
	   IFText_fnSetUString(this.InfoboxBot.Text1, DisplayUStr)

	   -- update map preview too 
	   ifs_missionselect_fnUpdateMapPreview(this, MapSelection)
	   
	elseif (this.iState == ifs_ms_state.mode) then
	   local ModeSelection = gMissionselectModes[ifs_ms_ModeList_layout.SelectedIdx]
	   IFText_fnSetString(this.InfoboxBot.Text1, ModeSelection.descstr)
	elseif (this.iState == ifs_ms_state.era) then
	   local DisplayUStr,iSource = missionlist_GetLocalizedMapName(MapSelection.mapluafile)
	   local ModeSelection = gMissionselectModes[ifs_ms_ModeList_layout.SelectedIdx]
	   local SuffixUStr = ScriptCB_getlocalizestr(ModeSelection.showstr)
	   local SpacesUStr = ScriptCB_tounicode(" ")
	   DisplayUStr = ScriptCB_usprintf("common.pctspcts", DisplayUStr, SpacesUStr)
	   DisplayUStr = ScriptCB_usprintf("common.pctspcts", DisplayUStr, SuffixUStr)

	   local EraSelection = gMissionselectEras[ifs_ms_EraList_layout.SelectedIdx]
	   IFText_fnSetString(this.InfoboxBot.Text1, EraSelection.showstr)
	elseif (this.iState == ifs_ms_state.command) then
	   IFText_fnSetString(this.InfoboxBot.Text1, "ifs.missionselect.buttons.help." .. this.CurButton)
	elseif (this.iState == ifs_ms_state.playlist) then
	   local Selection = gPickedMapList[ifs_ms_PlayList_layout.SelectedIdx]
	   if(Selection.bIsRemoveAll) then
	      IFText_fnSetString(this.InfoboxBot.Text1, "")
	   else
	      local DisplayUStr,iSource
	      DisplayUStr,iSource = missionlist_GetLocalizedMapName(Selection.Map)
	      IFText_fnSetUString(this.InfoboxBot.Text1, DisplayUStr)

-- 	      local MapMode = missionlist_GetMapMode(Selection.Map)
-- 	      if(MapMode) then
-- 		 IFText_fnSetString(this.InfoboxBot.Text2, MapMode.showstr)
-- 	      else
-- 		 IFText_fnSetString(this.InfoboxBot.Text2, "")
-- 	      end

-- 	      local MapEra = missionlist_GetMapEra(Selection.Map)
-- 	      if(MapEra) then
-- 		 IFText_fnSetString(this.InfoboxBot.Text3, MapEra.showstr)
-- 	      else
-- 		 IFText_fnSetString(this.InfoboxBot.Text3, "")
-- 	      end
	   end
	end

end

-- Helper function: adjusts the helptext by the icons at the bottom
function ifs_missionselect_fnUpdateHelptext(this)
	local PlaylistSelection = gPickedMapList[ifs_ms_PlayList_layout.SelectedIdx]

	if(this.Helptext_Accept) then
-- 		if (this.iColumn == 5) then
-- 			IFText_fnSetString(this.Helptext_Accept.helpstr,"common.mp.launch")
-- 		elseif (this.iColumn == 6) then
-- 			IFText_fnSetString(this.Helptext_Accept.helpstr,"common.change")
-- 		else
			IFText_fnSetString(this.Helptext_Accept.helpstr,"common.select")
-- 		end
		gHelptext_fnMoveIcon(this.Helptext_Accept)
	end -- Helptext_Accept exists

	-- Adjust delete helptext, if present
-- 	if(this.Helptext_Delete) then
-- 		local DeleteAlpha = 0.25
-- 		if (this.iColumn == 3) then
-- 			if(not PlaylistSelection.bIsRemoveAll) then
-- 				DeleteAlpha = 1
-- 			end
-- 		end
-- 		IFObj_fnSetAlpha(this.Helptext_Delete, DeleteAlpha)		
-- 	end

end

-- Helper function: sets the text of the bottom buttons 
function ifs_missionselect_fnUpdateButtons(this)
   local dimmed = this.iState ~= ifs_ms_state.command

   local button = this.buttons[ifs_ms_CommandButton_layout.buttonlist[1].tag]
   button.bDimmed = dimmed or (table.getn(gPickedMapList) < 2)

   for i = 2,table.getn(ifs_ms_CommandButton_layout.buttonlist) do
      local button = this.buttons[ifs_ms_CommandButton_layout.buttonlist[i].tag]
      button.bDimmed = dimmed
   end

   if ( this.CurButton ) then
      ShowHideVerticalButtons(this.buttons, ifs_ms_CommandButton_layout)
   else
      this.CurButton = ShowHideVerticalButtons(this.buttons, ifs_ms_CommandButton_layout)
   end

   SetCurButton(this.CurButton)
end

-- Helper function: fills in the listboxes with appropriate contents
function ifs_missionselect_fnUpdateScreen(this)

	-- Refresh which modes * eras are available on this map
	if((this.iColumn == 0) or (this.iColumn == 1)) then
		local MapSelection = missionselect_listbox_contents[ifs_ms_MapList_layout.SelectedIdx]
		gMissionselectModes = missionlist_ExpandModelist(MapSelection.mapluafile)
		local NumModes = table.getn(gMissionselectModes)
		if(ifs_ms_ModeList_layout.SelectedIdx > NumModes) then
			ifs_ms_ModeList_layout.SelectedIdx = 1 -- back to top of list
		end

		local ModeSelection = gMissionselectModes[ifs_ms_ModeList_layout.SelectedIdx]
		gMissionselectEras = missionlist_ExpandEralist(MapSelection.mapluafile, ModeSelection)
		local NumEras = table.getn(gMissionselectEras)
		if(ifs_ms_EraList_layout.SelectedIdx > NumEras) then
			ifs_ms_EraList_layout.SelectedIdx = 1 -- back to top of list
		end
	end

	if (this.iState == ifs_ms_state.map) then
	   IFObj_fnSetVis(this.MapListbox, 1)
	   ifs_ms_MapList_layout.CursorIdx = ifs_ms_MapList_layout.SelectedIdx
	   ListManager_fnFillContents(this.MapListbox,missionselect_listbox_contents,ifs_ms_MapList_layout)
	   ListManager_fnSetFocus(this.MapListbox)

	   IFObj_fnSetVis(this.ModeListbox, nil)
	   ifs_ms_ModeList_layout.CursorIdx = nil

	   IFObj_fnSetVis(this.EraListbox, nil)
	   ifs_ms_EraList_layout.CursorIdx = nil

	   ifs_ms_PlayList_layout.CursorIdx = nil
	   ListManager_fnFillContents(this.PlayListbox,gPickedMapList,ifs_ms_PlayList_layout)
	elseif (this.iState == ifs_ms_state.mode) then
	   IFObj_fnSetVis(this.MapListbox, nil)
	   ifs_ms_MapList_layout.CursorIdx = nil

	   IFObj_fnSetVis(this.ModeListbox, 1)
	   ifs_ms_ModeList_layout.CursorIdx = ifs_ms_ModeList_layout.SelectedIdx
	   ListManager_fnFillContents(this.ModeListbox,gMissionselectModes,ifs_ms_ModeList_layout)
	   ListManager_fnSetFocus(this.ModeListbox)

	   IFObj_fnSetVis(this.EraListbox, nil)
	   ifs_ms_EraList_layout.CursorIdx = nil

	   ifs_ms_PlayList_layout.CursorIdx = nil
	   ListManager_fnFillContents(this.PlayListbox,gPickedMapList,ifs_ms_PlayList_layout)
	elseif (this.iState == ifs_ms_state.era) then
	   IFObj_fnSetVis(this.MapListbox, nil)
	   ifs_ms_MapList_layout.CursorIdx = nil

	   IFObj_fnSetVis(this.ModeListbox, nil)
	   ifs_ms_ModeList_layout.CursorIdx = nil
	   
	   IFObj_fnSetVis(this.EraListbox, 1)
	   ifs_ms_EraList_layout.CursorIdx = ifs_ms_EraList_layout.SelectedIdx
	   ListManager_fnFillContents(this.EraListbox,gMissionselectEras,ifs_ms_EraList_layout)
	   ListManager_fnSetFocus(this.EraListbox)

	   ifs_ms_PlayList_layout.CursorIdx = nil
	   ListManager_fnFillContents(this.PlayListbox,gPickedMapList,ifs_ms_PlayList_layout)
	elseif (this.iState == ifs_ms_state.command) then
	   IFObj_fnSetVis(this.MapListbox, 1)
	   ifs_ms_MapList_layout.CursorIdx = nil
	   ListManager_fnFillContents(this.MapListbox,missionselect_listbox_contents,ifs_ms_MapList_layout)

	   IFObj_fnSetVis(this.ModeListbox, nil)
	   ifs_ms_ModeList_layout.CursorIdx = nil

	   IFObj_fnSetVis(this.EraListbox, nil)
	   ifs_ms_EraList_layout.CursorIdx = nil

	   ifs_ms_PlayList_layout.CursorIdx = nil
	   ListManager_fnFillContents(this.PlayListbox,gPickedMapList,ifs_ms_PlayList_layout)

	   ListManager_fnSetFocus(nil)
	elseif (this.iState == ifs_ms_state.playlist) then
	   IFObj_fnSetVis(this.MapListbox, 1)
	   ifs_ms_MapList_layout.CursorIdx = nil
	   ListManager_fnFillContents(this.MapListbox,missionselect_listbox_contents,ifs_ms_MapList_layout)
	   ListManager_fnSetFocus(this.MapListbox)

	   IFObj_fnSetVis(this.ModeListbox, nil)
	   ifs_ms_ModeList_layout.CursorIdx = nil

	   IFObj_fnSetVis(this.EraListbox, nil)
	   ifs_ms_EraList_layout.CursorIdx = nil

	   ifs_ms_PlayList_layout.CursorIdx = ifs_ms_PlayList_layout.SelectedIdx
	   ListManager_fnFillContents(this.PlayListbox,gPickedMapList,ifs_ms_PlayList_layout)
	   ListManager_fnSetFocus(this.PlayListbox)
	end


	-- Always update the other chunks. Those are split off into their own
	-- functions for readability
	ifs_missionselect_fnUpdateButtons(this)
	ifs_missionselect_fnUpdateHelptext(this)
	ifs_missionselect_fnUpdateInfoBoxes(this)
end

-- Helper function: clears the playlist
function ifs_missionselect_fnClearPlaylist(this)
	gPickedMapList = {
		{ Map = gDelAllMapsStr, bIsRemoveAll = 1, },
	}
end

-- Callback function: list of maps is full, and user got a dialog to
-- that effect. This is called when that dialog is dismissed.
function ifs_missionselect_fnFullPopupDone()
	local this = ifs_missionselect
	ifs_missionselect_fnShowHideListboxes(this,1)
end

-- Helper function: given a map, mode & era, none of which are
-- wildcards, adds the map to the list.
function ifs_missionselect_fnAddMap4(this, MapSelection, ModeSelection, EraSelection)
	-- Map & mode must not be a wildcard to get here.
	assert(not MapSelection.bIsWildcard)
	assert(not ModeSelection.bIsWildcard)
	assert(not EraSelection.bIsWildcard)

	local Idx = table.getn(gPickedMapList) + 1

	-- If playlist is full, notify the user, don't add it.
	if(Idx > (this.iMaxMissions+1)) then
		ifs_missionselect_fnShowHideListboxes(this,nil)
		Popup_Ok.fnDone = ifs_missionselect_fnFullPopupDone
		Popup_Ok:fnActivate(1)
		gPopup_fnSetTitleStr(Popup_Ok, "ifs.missionselect.listfull")
		return
	end

	local NewMapfile = string.format(MapSelection.mapluafile, EraSelection.subst, ModeSelection.subst)
	print("Adding map ", NewMapfile)
	gPickedMapList[Idx] = { 
		Map = NewMapfile,
		mapluafile = NewMapfile,
		dnldable = MapSelection.dnldable,
		mapluafile = MapSelection.mapluafile,
		Side = 1,
		SideChar = EraSelection.tag,
		Team1 = EraSelection.Team1Name,
		Team2 = EraSelection.Team2Name,
	}

	-- Auto-scroll playlist cursor to last item.
	local Count = table.getn(gPickedMapList)
	ifs_ms_PlayList_layout.SelectedIdx = Count

end

-- Helper function: given a map, mode & era, expands the mode(s)
-- and adds the map based on that.
function ifs_missionselect_fnAddMap3(this, MapSelection, ModeSelection, EraSelection)

	-- Map must not be a wildcard to get here.
	assert(not MapSelection.bIsWildcard)
	assert(not EraSelection.bIsWildcard)

	if(ModeSelection.bIsWildcard) then
		-- Add all maps with given params
		local i
    for i = 1,table.getn(gMissionselectModes) do
			local ModeSelection2 = gMissionselectModes[i]
			if(not ModeSelection2.bIsWildcard) then
				-- Ensure this map supports this mode before adding.
				local Key = ModeSelection2.key .. "_" .. EraSelection.subst
				if(MapSelection[Key]) then
					ifs_missionselect_fnAddMap3(this, MapSelection, ModeSelection2, EraSelection)
				end
			end
		end
	else
		-- Not adding all maps. Call child function, if mode exists on this map
		local Key = ModeSelection.key .. "_" .. EraSelection.subst
		if(MapSelection[Key]) then
			ifs_missionselect_fnAddMap4(this, MapSelection, ModeSelection, EraSelection)
		end
	end
end

-- Helper function: given a map, mode & era, expands the era(s)
-- and adds maps based on that.
function ifs_missionselect_fnAddMap2(this, MapSelection, ModeSelection, EraSelection)
	-- Map & mode must not be a wildcard to get here.
	assert(not MapSelection.bIsWildcard)

	if(EraSelection.bIsWildcard) then
		-- Add all maps with given params
		local i
    for i = 1,table.getn(gMissionselectEras) do
			local EraSelection2 = gMissionselectEras[i]
			if(not EraSelection2.bIsWildcard) then
				-- Ensure this map supports this era before adding.
				local Key = EraSelection2.key
				if(MapSelection[Key]) then
					ifs_missionselect_fnAddMap3(this, MapSelection, ModeSelection, EraSelection2)
				end
			end
		end
	else
		-- Not adding all maps. Call child function, if era exists on this map
		local Key = EraSelection.key
		if(MapSelection[Key]) then
			ifs_missionselect_fnAddMap3(this, MapSelection, ModeSelection, EraSelection)
		end
	end
	-- snip

end

-- Helper function: given a map, mode & era, expands the map(s)
-- and adds maps based on that.
function ifs_missionselect_fnAddMap1(this, MapSelection, ModeSelection, EraSelection)
	if(MapSelection.bIsWildcard) then
		-- Add all maps with given params
		local i
    for i = 1,table.getn(missionselect_listbox_contents) do
			local MapSelection2 = missionselect_listbox_contents[i]
			if(not MapSelection2.bIsWildcard) then
				ifs_missionselect_fnAddMap2(this, MapSelection2, ModeSelection, EraSelection)
			end
		end
	else
		-- Not adding all maps. Call child function
		ifs_missionselect_fnAddMap2(this, MapSelection, ModeSelection, EraSelection)
	end
end

-- Given the current selections in the listboxes, adds the map(s)
-- selected to the listbox
function ifs_missionselect_fnAddMap(this)
	local MapSelection = missionselect_listbox_contents[ifs_ms_MapList_layout.SelectedIdx]
	local ModeSelection = gMissionselectModes[ifs_ms_ModeList_layout.SelectedIdx]
	local EraSelection = gMissionselectEras[ifs_ms_EraList_layout.SelectedIdx]
	-- Call helper functions to expand things as necessary
	ifs_missionselect_fnAddMap1(this, MapSelection, ModeSelection, EraSelection)
end

-- Deletes a map from the playlist. Done by creating a new list,
-- copying everything but the selected one over, swapping lists.
function ifs_missionselect_fnDeleteMap(this, idx)
	local Count = table.getn(gPickedMapList)
	if(Count > 0) then
		local i
		local j = 1
		local NewList = {}
		for i=1,Count do
			if(i ~= idx) then
				NewList[j] = gPickedMapList[i]
				j = j + 1
			end
		end
		
		gPickedMapList = NewList
	end -- has entries to delete
end

function ifs_missionselect_fnLaunch(this)
	-- First entry is always "remove all", so we need to have more entries than
	-- that in the list.
	print( "ifs_missionselect_fnLaunch", table.getn(gPickedMapList) )  -- PSP 
	if(table.getn(gPickedMapList) > 1) then
		this.SelectedMap = 1
		ifs_missionselect_fnDeleteMap(this, 1) -- delete the "remove all entry"
		-- PSP ScriptCB_SetMissionNames(gPickedMapList,ifs_instant_options_GetRandomizePlaylist())
		ScriptCB_SetMissionNames(gPickedMapList,this.bRandomOrder) -- PSP
		this.fnDone()
	else
		ifelm_shellscreen_fnPlaySound(this.errorSound)
	end
end


-- Added for PSP
function ifs_missionselect_TogglePlaylistOrder ()
	if ifs_missionselect.bRandomOrder then
		ifs_missionselect.bRandomOrder = nil
	else
		ifs_missionselect.bRandomOrder = 1
	end 
end 

-- Added for PSP
function ifs_missionselect_GetPlaylistOrder()
	return ifs_missionselect.bRandomOrder
end 

-- Added for PSP
function ifs_missionselect_SetPlaylistOrderDefault()
	ifs_missionselect.bRandomOrder = nil 
end 

--[[ does not exist in PSP code 
function HackBGTextureForWidescreen()
	local right, bottom, b, w = ScriptCB_GetScreenInfo()
	if (w ~= 1.0) then
		return "iface_instant_action_wide"
	end
	return "iface_instant_action"
end
--]] 

ifs_missionselect = NewIFShellScreen {
	nologo = 1,
	bAcceptIsSelect = 1,
	bg_texture = "psp_submenu_1",-- "iface_instant_action", -- PSP  bg_texture = HackBGTextureForWidescreen(), 
	
	movieBackground = nil,

	fnDone = nil, -- Callback function to do something when the user is done
	-- Sub-mode for full/era switch is on.

	iColumn = 0, -- default: leftmost column
        iState = ifs_ms_state.map,
	bRandomOrder = nil, -- PSP 
	
-- 	Helptext_Delete = NewHelptext {
-- 		ScreenRelativeX = 0.35, -- Left of center, but not in the normal 'back' position
-- 		ScreenRelativeY = 1.0, -- bot
-- 		y = -15,
-- 		buttonicon = "btnmisc",
-- 		string = "ifs.profile.delete",
-- 	},

	buttons = NewIFContainer {
	   ScreenRelativeX = 0.5, -- center
	   ScreenRelativeY = gDefaultButtonScreenRelativeY,
	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call base class

		-- ifs_instant_options_fnResetDefaults() -- Removed from PSP version

		-- stop the current movie
-- 		ifelem_shellscreen_fnStopMovie()

-- 		if(gPlatformStr == "XBox") then
-- 			ScriptCB_CloseMovie();
-- 			ScriptCB_OpenMovie("movies\\fly.mvs", "")
-- 		end

		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if(ErrorLevel >= 6) then -- session or login error, must keep going further
				ScriptCB_PopScreen()
				return
			end
		end

		this.iColumn = 0 -- default: leftmost column (all maps list)

		if(bFwd) then
			missionlist_ExpandMaplist(this.bForMP)

			-- Determine how many missions can be queued.
			this.iMaxMissions = ScriptCB_GetMaxMissionQueue()

			if(not this.bEverEntered) then
				this.bEverEntered = 1
				ifs_missionselect_fnClearPlaylist(this)
			end
			
		end
		
		if bFwd and gPlatformStr == "PSP" then 
			SetCurButton("add")
		end 
		

		if gPlatformStr == "PSP" then 
			ifs_ms_MapList_layout.SelectedIdx = 1
		end 

		this.iState = ifs_ms_state.command
		ifs_missionselect_fnUpdateScreen(this)
	end,

	Exit = function(this, bFwd)
		if(not bFwd) then
			this.SelectedMap = nil -- clear this
		end
	end,
	
	Update = function(this, fDt)
		-- Call base class functionality
		gIFShellScreenTemplate_fnUpdate(this, fDt)
	end,

	Input_Accept = function(this)
		local sound = this.acceptSound
		if (this.iState == ifs_ms_state.map) then
		   this.iState = ifs_ms_state.mode
		elseif (this.iState == ifs_ms_state.mode) then
		   this.iState = ifs_ms_state.era
		elseif (this.iState == ifs_ms_state.era) then
		   ifs_missionselect_fnAddMap(this)
		   this.iState = ifs_ms_state.command
		   SetCurButton("launch")
		elseif (this.iState == ifs_ms_state.command) then
		   if ( this.CurButton == "launch" ) then
		      ifs_missionselect_fnLaunch(this)
		   elseif ( this.CurButton == "add" ) then
		      this.iState = ifs_ms_state.map
		   elseif ( this.CurButton == "remove" ) then
		      this.iState = ifs_ms_state.playlist
		   elseif ( this.CurButton == "options" ) then
		      ifs_movietrans_PushScreen(ifs_instant_options_overview)
		   end
		elseif (this.iState == ifs_ms_state.playlist) then
		   local Selection = gPickedMapList[ifs_ms_PlayList_layout.SelectedIdx]
		   if (Selection.bIsRemoveAll) then
		      sound = this.errorSound
		      ifs_missionselect_fnClearPlaylist(this)
		   else
		      ifs_missionselect_fnDeleteMap(this, ifs_ms_PlayList_layout.SelectedIdx)

		      -- If we were on the last item, then auto-move up.
		      local Count = table.getn(gPickedMapList)
		      ifs_ms_PlayList_layout.SelectedIdx = math.min(ifs_ms_PlayList_layout.SelectedIdx, Count)

		      ifs_missionselect_fnUpdateScreen(this)
		   end

		   this.iState = ifs_ms_state.command
		   if ( table.getn(gPickedMapList) < 2 ) then
		      SetCurButton("add")
		   else
		      SetCurButton("launch")
		   end
		end

		ifelm_shellscreen_fnPlaySound(sound)
		ifs_missionselect_fnUpdateScreen(this)

--		local Selection = missionselect_listbox_contents[ifs_ms_MapList_layout.SelectedIdx]
		-----------------------------------
		-- set to non-spectator mode 
		ScriptCB_SetSpectatorMode( 0, nil )
		-----------------------------------
		
	end, -- end of Input_Accept

	Input_Back = function(this)
		if (this.iState == ifs_ms_state.map) then
		   this.iState = ifs_ms_state.command
		elseif (this.iState == ifs_ms_state.mode) then
		   this.iState = ifs_ms_state.map
		elseif (this.iState == ifs_ms_state.era) then
		   this.iState = ifs_ms_state.mode
		elseif (this.iState == ifs_ms_state.command) then
		   ScriptCB_PopScreen()
		elseif (this.iState == ifs_ms_state.playlist) then
		   this.iState = ifs_ms_state.command
		end
		   
		ifelm_shellscreen_fnPlaySound(this.exitSound)
		ifs_missionselect_fnUpdateScreen(this)
	end,
	
-- 	Input_Start = function(this)
-- 		--if we're on the first page, start should do the "launch" button
-- 		if(this.iPage == 0) then
-- 			ifs_missionselect_fnLaunch(this)
-- 		end
-- 	end,

	-- Delete a map from selected list. Done by creating a new list, copying
	-- everything but the selected one over, swapping lists.
	Input_Misc = function(this)
-- 		if (this.iColumn == 3) then
-- 			local Selection = gPickedMapList[ifs_ms_PlayList_layout.SelectedIdx]
-- 			if(Selection.bIsRemoveAll) then
-- 				ifelm_shellscreen_fnPlaySound(this.errorSound)
-- 			else
-- 				ifs_missionselect_fnDeleteMap(this, ifs_ms_PlayList_layout.SelectedIdx)

-- 				-- If we were on the last item, then auto-move up.
-- 				local Count = table.getn(gPickedMapList)
-- 				ifs_ms_PlayList_layout.SelectedIdx = math.min(ifs_ms_PlayList_layout.SelectedIdx, Count)

-- 				ifs_missionselect_fnUpdateScreen(this)
-- 			end
-- 		end -- column == 3
	end,

	Input_GeneralUp = function(this)
		local CurListbox = ListManager_fnGetFocus()
		if(CurListbox) then
			ListManager_fnNavUp(CurListbox)
			ifs_missionselect_fnUpdateScreen(this)
		end
		if ( this.iState == ifs_ms_state.command ) then
		   gDefault_Input_GeneralUp(this)
		   ifs_missionselect_fnUpdateScreen(this)
		end
	end,

	Input_GeneralDown = function(this)
		local CurListbox = ListManager_fnGetFocus()
		if(CurListbox) then
			ListManager_fnNavDown(CurListbox)
			ifs_missionselect_fnUpdateScreen(this)
		end
		if ( this.iState == ifs_ms_state.command ) then
		   gDefault_Input_GeneralDown(this)
		   ifs_missionselect_fnUpdateScreen(this)
		end
	end,

	Input_LTrigger = function(this)
		local CurListbox = ListManager_fnGetFocus()
		if(CurListbox) then
			ListManager_fnPageUp(CurListbox)
			ifs_missionselect_fnUpdateScreen(this)
		end
	end,

	Input_RTrigger = function(this)
		local CurListbox = ListManager_fnGetFocus()
		if(CurListbox) then
			ListManager_fnPageDown(CurListbox)
			ifs_missionselect_fnUpdateScreen(this)
		end
	end,
	
	Input_Select = function(this) 
		--TODO Delete this function 
		ScriptCB_Reboot()
	end 
}

function ifs_missionselect_fnBuildScreen(this)
	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen

	if(gPlatformStr == "PC") then
		this.listboxfont = "gamefont_small"
	elseif(gPlatformStr == "PS2" or gPlatformStr == "PSP") then
		this.listboxfont = "gamefont_tiny"
    else
		this.listboxfont = "gamefont_medium"
	end

	local ColumnWidthL = nil 
	local ColumnWidthC = nil
	local ColumnWidthR = nil


		-- AnthonyBF2, point of interest
	if( gPlatformStr == "PSP") then -- "PSP"
		ColumnWidthL = (w * 0.41999998688698)
		ColumnWidthC = (w * 0.25)
		ColumnWidthR = (w * 0.41999998688698)
	else 
		ColumnWidthL = (w * 0.375)
		ColumnWidthC = (w * 0.25)
		ColumnWidthR = (w * 0.375)
	end 
	
	
	-- -35 is the normal space for scrollbars, but +20 as the scrollbars
	-- have recently gotten thinner. We need as much space for text onscreen
	-- as possible
	ifs_ms_MapList_layout.width = ColumnWidthL - 35 
	ifs_ms_ModeList_layout.width = ColumnWidthL - 35
	ifs_ms_EraList_layout.width = ColumnWidthL - 35 
	ifs_ms_PlayList_layout.width = ColumnWidthR - 35

	-- Now, do the boxes above and below the columns
	local TopBoxHeight = 78
	
		-- AnthonyBF2, point of interest
	if gPlatformStr == "PSP" then -- "PSP"
		TopBoxHeight = 15 -- 28
		ifs_ms_CommandButton_layout. yTop = -100 -- 125
	end 

	local yHeight
	local padding
	if ( gLangStr == "english" or gLangStr == "uk_english" ) then
	   yHeight = ScriptCB_GetFontHeight(ifs_missionselect.listboxfont) + 2
	   padding = 30
	else
	   yHeight =  (ScriptCB_GetFontHeight(ifs_missionselect.listboxfont) + 2)
	   padding = 30 -- PSP change ; padding = 44
	end

	ifs_ms_MapList_layout.yHeight = yHeight
	ifs_ms_ModeList_layout.yHeight = yHeight
	ifs_ms_EraList_layout.yHeight = 2 * (ScriptCB_GetFontHeight(ifs_missionselect.listboxfont) + 4)
	ifs_ms_PlayList_layout.yHeight = yHeight

	local ListEntryHeight = (ifs_ms_MapList_layout.yHeight + ifs_ms_MapList_layout.ySpacing)

													   -- (4, math.floor value is the min. number of maps displayed in the maps tab and playlist tab
	ifs_ms_MapList_layout.showcount = math.min(16,math.max(8, math.floor((h - 240) / ListEntryHeight)))

	ifs_ms_ModeList_layout.showcount = ifs_ms_MapList_layout.showcount
	--ifs_ms_PlayList_layout.showcount = ifs_ms_MapList_layout.showcount
	ifs_ms_PlayList_layout.showcount = ifs_ms_MapList_layout.showcount - 2
	ifs_ms_EraList_layout.showcount = 0.5 * ifs_ms_MapList_layout.showcount
-- 	ifs_ms_ModeList_layout.showcount = ifs_ms_MapList_layout.showcount - 4
-- 	ifs_ms_PlayList_layout.showcount = ifs_ms_MapList_layout.showcount

	local ListHeightL = ifs_ms_MapList_layout.showcount * ListEntryHeight + padding

	local inherent_offcenteredness_of_the_world = nil
	if gPlatformStr == "PSP" then 
		inherent_offcenteredness_of_the_world = 0
	else 
		inherent_offcenteredness_of_the_world = 2
	end 

	this.MapListbox = NewButtonWindow { 
		ZPos = 200, 
		ScreenRelativeX = 0.5, -- left side of screen
		ScreenRelativeY = 0, -- top
		x = -((ColumnWidthR + ColumnWidthC) * 0.5) - inherent_offcenteredness_of_the_world,
		y = TopBoxHeight + ListHeightL * 0.5 + 6,
		width = ColumnWidthL,
		height = ListHeightL,
		titleText = "ifs.missionselect.selectplanet"
	}

	local ListHeightC = ifs_ms_ModeList_layout.showcount * ListEntryHeight + 30 - 4
	local ListHeightC2 = ifs_ms_EraList_layout.showcount * ListEntryHeight + 30 - 8
	this.ModeListbox = NewButtonWindow { 
		ZPos = 200, 
		ScreenRelativeX = 0.5, -- center of screen
		ScreenRelativeY = 0, -- top
		x = -((ColumnWidthR + ColumnWidthC) * 0.5) - inherent_offcenteredness_of_the_world,
		y = TopBoxHeight + ListHeightL * 0.5 + 6,
		width = ColumnWidthL,
		height = ListHeightL,
-- 		x = (ColumnWidthL + ColumnWidthC * 0.5),
-- 		y = TopBoxHeight + ListHeightC * 0.5,
-- 		width = ColumnWidthC,
-- 		height = ListHeightC,
		titleText = "ifs.missionselect.selectmode"
	}

	this.EraListbox = NewButtonWindow { 
		ZPos = 200, 
		ScreenRelativeX = 0.5, -- center of screen
		ScreenRelativeY = 0, -- top
		x = -((ColumnWidthR + ColumnWidthC) * 0.5) - inherent_offcenteredness_of_the_world,
		y = TopBoxHeight + ListHeightL * 0.5 + 6,
		width = ColumnWidthL,
		height = ListHeightL,
-- 		x = (ColumnWidthL + ColumnWidthC * 0.5),
-- 		y = TopBoxHeight + ListHeightC + ListHeightC2 * 0.5 + 2,
-- 		width = ColumnWidthC,
-- 		height = ListHeightC2,
		titleText = "ifs.missionselect.selectera"
	}

	local ListHeightR = ifs_ms_PlayList_layout.showcount * ListEntryHeight + 30
	this.PlayListbox = NewButtonWindow { 
		ZPos = 200, 
		--ScreenRelativeX = 0.5,
		--ScreenRelativeY = 0, -- top
		--x = (ColumnWidthR + ColumnWidthC) * 0.5 - inherent_offcenteredness_of_the_world,
		--y = TopBoxHeight + ListHeightR * 0.5 + 6,
		x = 361,
		--y = 86, -- when height == 130 
		y = 74,
		width = ColumnWidthR,
		--height = ListHeightR,
		height = 105,
		titleText = "ifs.missionselect.playlist"
	}

	local BotBoxHeight = 76
	local newWidth = nil 
	if (gPlatformStr == "PSP" ) then
		newWidth = w *  1.0900000333786
	else 
		newWidth = w
	end 

	local dude = 0.38
	local previewWidth = 62 --64
	local previewHeight = 62 -- 64
	
	this.InfoboxBot = NewButtonWindow { 
		--ScreenRelativeX = dude , --0.5, .9 -> right 0.1 --> left 
		--ScreenRelativeY = 0, -- top
		--x =  -inherent_offcenteredness_of_the_world,
		x = 152,
		y = TopBoxHeight + ListHeightL + BotBoxHeight * 0.5 + 15, -- Below main listboxes
		--width = newWidth,  -- PSP width = w,
		width = w - (previewWidth + 27),
		height = BotBoxHeight,

		-- Text1 is triple-height, for long descriptions. We'll either use
		-- Text1-only @ triple-height, or Text1/Text2/Text3, with one line
		-- of text in each.
		Text1 = NewIFText { 
			--x = -0.5 * w - 10 , -- PSP x = -0.5 * w + 15,
			--x = -0.26 *w -10,
			x = -160, 
			y = -BotBoxHeight * 0.5 + 4      + 1,
			halign = "left", 
			valign = "top",
			font = "gamefont_tiny", 
			--textw = ColumnWidthL + ColumnWidthC + ColumnWidthR - 20, 
			--textw = w * 0.60 , 
			textw = 325,
			texth = BotBoxHeight,
			startdelay = math.random()*0.5, nocreatebackground=1,
			textcolorr = gSelectedTextColor[1],
			textcolorg = gSelectedTextColor[2],
			textcolorb = gSelectedTextColor[3],
		},

-- 		Text2 = NewIFText { 
-- 			x = -0.5 * w + 10,
-- 			y = BotBoxHeight * 0.5 - 10,
-- 			halign = "left", valign = "top",
-- 			font = this.listboxfont,
-- 			textw = ColumnWidthL + ColumnWidthC + ColumnWidthR - 20, texth = BotBoxHeight * 0.333333,
-- 			startdelay=math.random()*0.5, nocreatebackground=1, 
-- 			textcolorr = gSelectedTextColor[1],
-- 			textcolorg = gSelectedTextColor[2],
-- 			textcolorb = gSelectedTextColor[3],
-- 		},

-- 		Text3 = NewIFText { 
-- 			x = -0.5 * w + 10,
-- 			y = BotBoxHeight * 0.75 - 10,
-- 			halign = "left", valign = "top",
-- 			font = this.listboxfont, 
-- 			textw = ColumnWidthL + ColumnWidthC + ColumnWidthR - 20, texth = BotBoxHeight * 0.333333,
-- 			startdelay=math.random()*0.5, nocreatebackground=1, 
-- 			textcolorr = gSelectedTextColor[1],
-- 			textcolorg = gSelectedTextColor[2],
-- 			textcolorb = gSelectedTextColor[3],
-- 		},
	}
	
	-- PSP screen size = 480 x 272
	-- add the map preview box
	
	this.MapPreview = NewIFMapPreview {
		--texture = "ahsoka",
		texture = "logo",
		width = previewWidth,
		height = previewHeight,
		x = w - (previewWidth - 19 ),
		y = h - (previewHeight - 10 ),
	}
	
	--this.MapBorder = NewIFBorder{}

	AddVerticalButtons(this.buttons, ifs_ms_CommandButton_layout)

	--size the background
	local wScreen,hScreen,vScreen,widescreen = ScriptCB_GetScreenInfo()
	-- calc the position of the movie preview window
	if(gPlatformStr == "PS2" or gPlatformStr == "PSP") then
		this.movieX = wScreen - 380
		this.movieY = hScreen - 260
		this.movieW = 380
		this.movieH = 310
	else
		this.movieW = 480.0
		this.movieH = 360.0
		this.movieX = wScreen - this.movieW
		this.movieY = hScreen - this.movieH + 24.0
	end

	-- Create our listboxes
	ListManager_fnInitList(this.MapListbox,ifs_ms_MapList_layout)
	ListManager_fnInitList(this.ModeListbox,ifs_ms_ModeList_layout)
	ListManager_fnInitList(this.EraListbox,ifs_ms_EraList_layout)
	ListManager_fnInitList(this.PlayListbox,ifs_ms_PlayList_layout)
end

ifs_missionselect_fnBuildScreen(ifs_missionselect)
ifs_missionselect_fnBuildScreen = nil -- dump out of memory to save

AddIFScreen(ifs_missionselect,"ifs_missionselect")


