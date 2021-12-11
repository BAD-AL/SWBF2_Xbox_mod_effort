-- ifs_pspplaylist.lua 
-- Decompiled with SWBF2CodeHelper

function ifs_pspplay_PlayList_CreateItem(layout)
    local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, 
		y = layout.y,
	}

	local HAlign = "left"  --r2
	local r3 = 3
	local WidthAdj = -5 -- r4


	Temp.map = NewIFText { 
		x = r3,
		y = layout.height * -0.5 + 2,
		halign = "left", 
		valign = "vcenter",
		font = ifs_pspplaylist.listboxfont,
		textw = layout.width +  WidthAdj, 
		texth = layout.height,
		startdelay = math.random()*0.5, 
		nocreatebackground=1, 
	}
	local r5 = layout.height * 0.75
	
	Temp.icon = NewIFImage {
		ZPos = 240, 
		localpos_l = layout.width - 5 ,
		localpos_r = layout.width - 5,
		localpos_t =   2,
		localpos_b = 2,
	}

	Temp.icon1 = NewIFImage {
		ZPos = 240, 
		localpos_l = layout.width - 3 ,
		localpos_r = layout.width - 3 ,
		localpos_t =  2,
		localpos_b =  2,
		ColorR = 128,
		ColorG = 128,
		ColorB = 128,
	}

	return Temp
end

function ifs_pspplay_PlayList_PopulateItem(ifs_pspplay_PlayList_PopulateItemParam0, ifs_pspplay_PlayList_PopulateItemParam1, ifs_pspplay_PlayList_PopulateItemParam2)
    iColor = 255
    
end
ifs_pspplay_PlayList_layout = { showcount = 7, yHeight = 22, ySpacing = 0, x = 0, slider = 1, CreateFn = ifs_pspplay_PlayList_CreateItem, PopulateFn = ifs_pspplay_PlayList_PopulateItem }

function ifs_pspplaylist_fnShowHideListboxes(ifs_pspplaylist_fnShowHideListboxesParam0, ifs_pspplaylist_fnShowHideListboxesParam1)
    
end

function ifs_pspplaylist_fnUpdateInfoBoxes(ifs_pspplaylist_fnUpdateInfoBoxesParam0)
    IFText_fnSetString(0,"")
    IFText_fnSetString(0,"")
    IFText_fnSetString(0,"")
    missionlist_GetLocalizedMapName(AnimationMgr_AddAnimation)
    IFText_fnSetUString(AnimationMgr_AddAnimation,missionlist_GetLocalizedMapName())
    missionlist_GetMapMode(AnimationMgr_AddAnimation)
    
end

function ifs_pspplaylist_fnUpdateHelptext(ifs_pspplaylist_fnUpdateHelptextParam0)
    IFText_fnSetString(AnimationMgr_AddAnimation,"common.mp.launch")
    IFText_fnSetString(AnimationMgr_AddAnimation,"common.accept")
    gHelptext_fnMoveIcon.Helptext_Delete(AnimationMgr_AddAnimation)
    IFText_fnSetString(IFObj_fnSetAlpha.helpstr("common.accept",1),"common.quit")
end

function ifs_pspplaylist_fnUpdateScreen(ifs_pspplaylist_fnUpdateScreenParam0)
    ListManager_fnFillContents(ifs_pspplay_PlayList_layout,gPickedMapList,ifs_pspplay_PlayList_layout)
    ListManager_fnSetFocus(ifs_pspplay_PlayList_layout)
    ifs_pspplaylist_fnUpdateHelptext(ifs_pspplaylist_fnUpdateScreenParam0)
    ifs_pspplaylist_fnUpdateInfoBoxes(ifs_pspplaylist_fnUpdateScreenParam0)
end

function ifs_pspplaylist_fnClearPlaylist(ifs_pspplaylist_fnClearPlaylistParam0)
    gPickedMapList = { { Map = gDelAllMapsStr, bIsRemoveAll = 1 } }
end

function ifs_pspplaylist_fnDeleteMap(ifs_pspplaylist_fnDeleteMapParam0, ifs_pspplaylist_fnDeleteMapParam1)
    
end
ifs_pspplaylist = NewIFShellScreen{
	nologo = 1, 
	bg_texture = "iface_bgmeta_space", 
	movieBackground = nil, 
	fnDone = nil, 
	Helptext_Delete = NewHelptext{  ScreenRelativeX = 0.25, ScreenRelativeY = 1, y = -15, buttonicon = "btnmisc", string = "ifs.profile.delete" }, 
	Helptext_AddMap = NewHelptext{ ScreenRelativeX = 0.55000001192093, ScreenRelativeY = 1, y = -15, buttonicon = "btnmisc2", string = "ifs.playlist.addmap" }, 
	Enter = function (this, bFwd)
		gIFShellScreenTemplate_fnEnter(this,bFwd)
		
	end, 
	Input_Accept = function (this)
		
	end, 
	Input_Back = function (this )
		ScriptCB_PopScreen("ifs_missionselect")
		ScriptCB_PopScreen()
	end,
	Input_Misc = function (this )
		
	end, 
	Input_Misc2 = function (Input_Misc2Param0)
		ScriptCB_PopScreen("ifs_missionselect")
	end, 
	Input_GeneralUp = function (this)
		ListManager_fnGetFocus()
		
	end, 
	Input_GeneralDown = function (Input_GeneralDownParam0)
		ListManager_fnGetFocus()
		
	end, 
	Input_LTrigger = function (this)
		ListManager_fnGetFocus()
		
	end, 
	Input_RTrigger = function (this)
		ListManager_fnGetFocus()
		
	end
 }

function ifs_pspplaylist_fnBuildScreen(arg1)
    ScriptCB_GetSafeScreenInfo()
    ListManager_fnInitList(arg1,ifs_pspplay_PlayList_layout)
end

ifs_pspplaylist_fnBuildScreen(ifs_pspplaylist)
ifs_pspplaylist_fnBuildScreen = nil
AddIFScreen(ifs_pspplaylist,"ifs_pspplaylist")
