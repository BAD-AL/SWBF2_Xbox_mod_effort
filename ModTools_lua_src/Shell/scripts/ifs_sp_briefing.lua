--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Single player Tabs layout
--gPCSinglePlayerTabsLayout = {
--	{ tag = "_tab_campaign",	string = "ifs.sp.campaign",			screen = "ifs_sp_briefing",				xPos = 225, width = 250,},
--	{ tag = "_tab_meta",		string = "ifs.sp.meta",				screen = "ifs_freeform_pickscenario",	xPos = 430, width = 250,},	
--	{ tag = "_tab_instant",		string = "ifs.sp.ia",				screen = "ifs_missionselect",			xPos = 700, width = 250,},
--}

ifs_sp_briefing_vbutton_layout = {
--	yTop = -70, -- auto-calc'd now
	xWidth = 205,
	width = 205,
	xSpacing = 6,
	ySpacing = 5,
	font = gMenuButtonFont,
	buttonlist = { 
		{ tag = "training",		string = "ifs.sp.camp.training", },
		{ tag = "rise",			string = "ifs.sp.camp.rise", },
--		{ tag = "rebel",		string = "ifs.sp.camp.rebel", },
--		{ tag = "cis",			string = "ifs.sp.camp.cis", },
--		{ tag = "republic",		string = "ifs.sp.camp.republic", },
--		{ tag = "custom",		string = "ifs.sp.camp.custom", },
	},
	title = "ifs.sp.campaign",
}

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_sp_briefing_Listbox_CreateItem(layout)

    local insidewidth = layout.width - 20;
    -- Make a coordinate system pegged to the top-left of where the cursor would go.
    local Temp = NewIFContainer {
        x = layout.x - 0.5 * insidewidth, y=layout.y
    }
    Temp.showstr = NewIFText{
        x = 5, y = -10, textw = insidewidth,
        halign = "left",
        font = "gamefont_medium",
        style = "normal",
        nocreatebackground=1,
        inert_all = 1,
    }

    return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_sp_briefing_Listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	if(gBlankListbox) then
		IFText_fnSetString(Dest.showstr,"") -- reduce glyphcache usage
	elseif (Data) then
		IFText_fnSetString(Dest.showstr,Data.showstr)

		if(Data.bDimmed) then
			IFObj_fnSetColor(Dest.showstr, 127, 127, 127)
		else
			IFObj_fnSetColor(Dest.showstr, iColorR, iColorG, iColorB)
			IFObj_fnSetAlpha(Dest.showstr, fAlpha)
		end
	end

	IFObj_fnSetVis(Dest,Data) -- Show if there are contents 
end

ifs_sp_briefing_listbox_layout = {
    -- Height is calculated from yHeight, Spacing, showcount.
    yHeight = 30,
    ySpacing  = 0,
    showcount = 8,

    width = 400,
    x = 0,
    slider = 1,
    CreateFn = ifs_sp_briefing_Listbox_CreateItem,
    PopulateFn = ifs_sp_briefing_Listbox_PopulateItem,
}


-- Callback (from C++) -- saving is done. Do something.
--function ifs_archive_fnSaveProfileDone(this)
--  Popup_LoadSave:fnActivate(nil)
--  local this = ifs_sp_briefing
--  IFObj_fnSetVis(this,1)
--  ifs_sp_briefing_fnUpdateScreen(this)
--end

----------------------------------------------------------------------------------------
-- save progress for player 1
----------------------------------------------------------------------------------------

function ifs_sp_briefing_StartSaveProfile1()
    print("ifs_sp_briefing_StartSaveProfile1")
    local this = ifs_sp_briefing
    
    -- is the profile dirty?
    if(ScriptCB_IsProfileDirty(1)) then

			-- start save profiles
			ifs_saveop.doOp = "SaveProfile"
			ifs_saveop.OnSuccess = ifs_sp_briefing_SaveProfile1Success
			ifs_saveop.OnCancel = ifs_sp_briefing_SaveProfile1Cancel
			local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
			ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
			ifs_saveop.saveProfileNum = iProfileIdx
			ifs_movietrans_PushScreen(ifs_saveop)
    else
			ifs_sp_briefing_StartSaveProfile2()
			return
    end
end

function ifs_sp_briefing_SaveProfile1Success()
    print("ifs_sp_briefing_SaveProfile1Success")
    local this = ifs_sp_briefing

    this.returningFromProfile1Save = 1
    ScriptCB_PopScreen()
end

function ifs_sp_briefing_SaveProfile1Cancel()
    print("ifs_sp_briefing_SaveProfile1Cancel")
    local this = ifs_sp_briefing

    this.returningFromProfile1Save = 1
    ScriptCB_PopScreen()
end

-------------------------------------
-- save progress for player 2
-------------------------------------

function ifs_sp_briefing_StartSaveProfile2()
    print("ifs_sp_briefing_StartSaveProfile2")
    local this = ifs_sp_briefing

    if(ScriptCB_IsProfileDirty(2)) then
        -- start save profiles
        ifs_saveop.doOp = "SaveProfile"
        ifs_saveop.OnSuccess = ifs_sp_briefing_SaveProfile2Success
        ifs_saveop.OnCancel = ifs_sp_briefing_SaveProfile2Cancel
        ifs_saveop.saveName = ScriptCB_GetProfileName(2)
        ifs_saveop.saveProfileNum = 2
        ifs_movietrans_PushScreen(ifs_saveop)
    else
        -- skip it
        this.returningFromProfile2Save = 1
        this:Enter(nil)
        return
    end
end

function ifs_sp_briefing_SaveProfile2Success()
    print("ifs_sp_briefing_SaveProfile2Success")
    local this = ifs_sp_briefing

    this.returningFromProfile2Save = 1
    ScriptCB_PopScreen()
end

function ifs_sp_briefing_SaveProfile2Cancel()
    print("ifs_sp_briefing_SaveProfile2Cancel")
    local this = ifs_sp_briefing

    this.returningFromProfile2Save = 1
    ScriptCB_PopScreen()
end

----------------------------------------------------------------------------------------
-- the second half of the enter function (after the progress save)
----------------------------------------------------------------------------------------

function ifs_sp_briefing_PostSaveEnter(this)
    print("ifs_sp_briefing_PostSaveEnter")

    -- Flag missions as locked if the user hasn't progressed that far
--  for i=this.iProgress+1,this.iMaxMissions do
--      gCurCampaign[i].bLocked = 1
--  end

--          this.iProgress = this.iMaxMissions

    -- Default: show the latest mission.
    --this.iSelected = this.iProgress
    -- show the last mission played, unless we won, then show the next
    this.iSelected = this.iNumLastMission

--  print("SP Progress = ", this.iProgress, ", Max = ",this.iMaxMissions, ", numlastmission = ",this.iNumLastMission)
--  print(" this.bSetVis = ",this.bSetVis)

end


-- Callback when the "play training" dialog is done. If bResult is
-- true, the user selected 'yes'
function ifs_sp_briefing_fnPostAskTraining(bResult)
	local this = ifs_sp_briefing

	if(bResult) then
		gPickedMapList = {} -- zap maplist
		local Idx = 1
		gPickedMapList[Idx] = {
			Map = "geo1c_c",
			dnldable = nil,
			mapluafile = "geo1c_c",
			Side = 1,
			SideChar = "g",
		}
		ScriptCB_SetInTrainingMission(1)
		ScriptCB_SetMissionNames(gPickedMapList,this.bRandomOrder)
		ScriptCB_EnterMission()
	else
		-- Skipping training. Stay on this screen, and enable Rise of the Empire
		ScriptCB_SetSPProgress(1,2)
		AnimationMgr_AddAnimation(this.buttons, {fStartAlpha = 0, fEndAlpha = 1,})
	end
end

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

ifs_sp_briefing = NewIFShellScreen {
	bAcceptIsSelect = 1,
    nologo = 1,
    bg_texture = "single_player_campaign", --nil, -- "iface_bgmeta_space",
    movieIntro      = nil, -- WAS "ifs_sp_briefing_intro",
    movieBackground = nil, --"shell_sub_left", -- WAS "ifs_sp_briefing",
    music           = "shell_soundtrack",
    exitSound       = "",

    title = NewIFText {
        string = "ifs.sp.campaign1.title",
        font = "gamefont_large",
        textw = 460,
        texth = 100,
        y = 0,
        ScreenRelativeX = 0.5, -- center
        ScreenRelativeY = 0, -- top
        --inert = 1,
        nocreatebackground = 1,
    },

    listbox = NewButtonWindow {
        ZPos = 200, x=0, y = 0,
        ScreenRelativeX = 0.5, -- center
        ScreenRelativeY = 0.48, -- middle of screen

        width = ifs_sp_briefing_listbox_layout.width + 35,
        height = ifs_sp_briefing_listbox_layout.showcount * (ifs_sp_briefing_listbox_layout.yHeight + ifs_sp_briefing_listbox_layout.ySpacing) + 30,
    },

    Enter = function(this, bFwd)
		-- tabs	
		if(gPlatformStr == "PC") then
			ifelem_tabmanager_SetSelected(this, gPCSinglePlayerTabsLayout, "_tab_campaign")
		end

		-- Resize buttons to be minimal width
--		this.CurButton = ShowHideVerticalButtons(this.buttons,ifs_sp_briefing_vbutton_layout)

        gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
    
        ifs_sp_briefing_listbox_layout.FirstShownIdx = 1
        ifs_sp_briefing_listbox_layout.SelectedIdx = 1
        ifs_sp_briefing_listbox_layout.CursorIdx = 1
        ListManager_fnFillContents(this.listbox,SPCampaign1,ifs_sp_briefing_listbox_layout)
        
        --if(gPlatformStr == "PC") then
		--	IFObj_fnSetVis( ifs_sp_briefing.listbox, nil )
		--end
    end,

    Exit = function(this, bFwd)
        -- Clear SP state if we back out of here.
        if(not bFwd) then
					--ScriptCB_SaveCampaignState()
					ScriptCB_SetGameRules("instantaction")
					gMovieAlwaysPlay = nil
        end
    end,

    Input_Accept = function(this)
    
		if( ( gPlatformStr ~= "PC" ) or ( this.CurButton == "_back" ) ) then	
			-- If base class handled this work, then we're done
			if(gShellScreen_fnDefaultInputAccept(this)) then
				return
			end
		else
			-- if is pc
			print("this.CurButton = ", this.CurButton )

			if( this.CurButton == "training" ) then
				ScriptCB_SetGameRules("campaign")
				AnimationMgr_AddAnimation(this.buttons, {fStartAlpha = 1, fEndAlpha = 0,})
				Popup_Ask_Historical.CurButton = "yes" -- default
				Popup_Ask_Historical.fnDone = ifs_sp_briefing_fnPostAskTraining
				Popup_Ask_Historical:fnActivate(1)
				gPopup_fnSetTitleStr(Popup_Ask_Historical, "ifs.sp.asktraining")
			elseif (this.CurButton == "rise") then
				-- press rise of empire button
				-- Ken, do something in ifs_freeform_rise_newload's "new" code.
				ifs_movietrans_PushScreen(ifs_freeform_rise_newload)
			end

			-- If the tab manager handled this event, then we're done
			if(ifelem_tabmanager_HandleInputAccept(this, gPCSinglePlayerTabsLayout)) then
				return
			end
			
			-- force do nothing for now
			--return
		end
		
		local Selection = SPCampaign1[ifs_sp_briefing_listbox_layout.SelectedIdx]
		if(Selection.bDimmed) then
			ifelm_shellscreen_fnPlaySound(this.errorSound) -- Can't launch!
		else
			--	        print("Selection = ", Selection)
			this.iSelected = 1
			this.iProgress = 2
			this.iCampaignNum = 1
			--ScriptCB_SaveCampaignState(this.iCampaignNum,this.iSelected == this.iProgress,this.iSelected)
			ScriptCB_SetMissionNames(Selection.mapluafile,nil) -- launch mission

			ScriptCB_SetGameRules("campaign")

			if(Selection.side) then
				ScriptCB_SetPlayerSide(Selection.side,0)
				ScriptCB_SetPlayerSide(Selection.side,1)
			end
			
			ScriptCB_CloseMovie();
			-- Reset difficulty to what's in profile
			ScriptCB_SetDifficulty(ScriptCB_GetDifficulty())
			ScriptCB_EnterMission()
		end
	end, -- Input_Accept


    Input_Back = function(this)
        ScriptCB_PopScreen()
    end,


    Input_GeneralUp = function(this)
        ListManager_fnNavUp(this.listbox,SPCampaign1,ifs_sp_briefing_listbox_layout)
    end,
    Input_GeneralDown = function(this)
        ListManager_fnNavDown(this.listbox,SPCampaign1,ifs_sp_briefing_listbox_layout)
    end,

    Input_LTrigger = function(this)
        ListManager_fnPageUp(this.listbox,SPCampaign1,ifs_sp_briefing_listbox_layout)
    end,
    Input_RTrigger = function(this)
        ListManager_fnPageDown(this.listbox,SPCampaign1,ifs_sp_briefing_listbox_layout)
    end,

    iCheatStage = 0,

    -- Disable these buttons
    Input_GeneralLeft = function(this)
    end,

    Input_GeneralRight = function(this)
    end, 
 
--  fnSaveProfileDone = ifs_archive_fnSaveProfileDone,
}

function ifs_sp_briefing_fnBuildScreen( this ) 
	if(gPlatformStr == "PC") then
		-- Add tabs to screen
		ifelem_tabmanager_Create(this, gPCSinglePlayerTabsLayout)

		ifs_sp_briefing_vbutton_layout.xWidth = 250
		ifs_sp_briefing_vbutton_layout.width = 250

		this.buttons = NewIFContainer {
			ScreenRelativeX = 0.5, -- center
			ScreenRelativeY = gDefaultButtonScreenRelativeY, -- center
		}

		this.CurButton = AddVerticalButtons(this.buttons,ifs_sp_briefing_vbutton_layout)
	
		IFText_fnSetString( this.title, "ifs.sp.campaign" )
	end
end

--------------------------CAMPAIGN LIST-------------------------------------------------
----------------------------------------------------------------------------------------

ifs_sp_campaign_list = NewIFShellScreen {
	bAcceptIsSelect = 1,
    nologo = 1,
    bg_texture = "single_player_campaign", --nil, -- "iface_bgmeta_space",
    movieIntro      = nil, -- WAS "ifs_sp_briefing_intro",
    movieBackground = nil, --"shell_sub_left", -- WAS "ifs_sp_briefing",
    music           = "shell_soundtrack",
    exitSound       = "",

    title = NewIFText {
        string = "ifs.sp.campaign1.title",
        font = "gamefont_large",
        textw = 460,
        texth = 100,
        y = 0,
        ScreenRelativeX = 0.5, -- center
        ScreenRelativeY = 0, -- top
        --inert = 1,
        nocreatebackground = 1,
    },

    --listbox = NewButtonWindow {
    --    ZPos = 200, x=0, y = 0,
    --    ScreenRelativeX = 0.5, -- center
    --    ScreenRelativeY = 0.48, -- middle of screen

    --    width = ifs_sp_briefing_listbox_layout.width + 35,
    --    height = ifs_sp_briefing_listbox_layout.showcount * (ifs_sp_briefing_listbox_layout.yHeight + ifs_sp_briefing_listbox_layout.ySpacing) + 30,
    --},

    Enter = function(this, bFwd)
		if(gPlatformStr == "PC") then
			-- set pc profile & title version text
			UpdatePCTitleText(this)
		end
		local form = this.mainForm.form

		-- get defaults if appropriate
		form.elements["clist"].selValue = 1		
		Form_SetValues(form)
		Form_UpdateAllElements(form)
		Form_ShowHideElements(form)
		
		-- tabs	
		--if(gPlatformStr == "PC") then
		--	ifelem_tabmanager_SetSelected(this, gPCSinglePlayerTabsLayout, "_tab_campaign")
		--end

		-- Resize buttons to be minimal width
--		this.CurButton = ShowHideVerticalButtons(this.buttons,ifs_sp_briefing_vbutton_layout)

		if(this.Helptext_Accept) then
			IFButton_fnSelect(this.Helptext_Accept, false, false)
		end
		if(this.Helptext_Back) then
			IFButton_fnSelect(this.Helptext_Back, false, false)
		end


        gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
    
        --ifs_sp_briefing_listbox_layout.FirstShownIdx = 1
        --ifs_sp_briefing_listbox_layout.SelectedIdx = 1
        --ifs_sp_briefing_listbox_layout.CursorIdx = 1
        --ListManager_fnFillContents(this.listbox,SPCampaign1,ifs_sp_briefing_listbox_layout)
        
        --if(gPlatformStr == "PC") then
		--	IFObj_fnSetVis( ifs_sp_briefing.listbox, nil )
		--end
    end,

    Exit = function(this, bFwd)
        -- Clear SP state if we back out of here.
        Form_CloseDropboxes(this.mainForm.form)
        if(not bFwd) then
					--ScriptCB_SaveCampaignState()
					ScriptCB_SetGameRules("instantaction")
					gMovieAlwaysPlay = nil
        end
    end,

    Input_Accept = function(this)
    
		--if( ( gPlatformStr ~= "PC" ) or ( this.CurButton == "_back" ) ) then	
			-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this, 1)) then
			return
		end
		--end
		
		-- process the form's input
		if(Form_InputAccept(this.mainForm.form, this) == true) then
			return
		end

		if(this.CurButton == "_accept") then
			--local Selection = SPCampaign1[ifs_sp_briefing_listbox_layout.SelectedIdx]
			local form = this.mainForm.form
			local Selection = SPCampaign1[form.elements["clist"].selValue]
			if(Selection.bDimmed) then
				ifelm_shellscreen_fnPlaySound(this.errorSound) -- Can't launch!
			else
				--	        print("Selection = ", Selection)
				this.iSelected = 1
				this.iProgress = 2
				this.iCampaignNum = 1
				--ScriptCB_SaveCampaignState(this.iCampaignNum,this.iSelected == this.iProgress,this.iSelected)
				ScriptCB_SetMissionNames(Selection.mapluafile,nil) -- launch mission

				ScriptCB_SetGameRules("campaign")
	
				-- the commented-out arguments made this assert - the default is the same, however
				if(Selection.side) then
					ScriptCB_SetPlayerSide(Selection.side)--,0)
					ScriptCB_SetPlayerSide(Selection.side)--,1)
				end
			
				ScriptCB_CloseMovie();
				-- Reset difficulty to what's in profile
				ScriptCB_SetDifficulty(ScriptCB_GetDifficulty())
				ScriptCB_EnterMission()
			end
		end
	end, -- Input_Accept


    Input_Back = function(this)
        ScriptCB_PopScreen()
    end,


    Input_GeneralUp = function(this)
    end,
    Input_GeneralDown = function(this)
    end,

    Input_LTrigger = function(this)
    end,
    Input_RTrigger = function(this)
    end,

    -- Disable these buttons
    Input_GeneralLeft = function(this)
    end,

    Input_GeneralRight = function(this)
    end, 
    
    Update = function(this, fDt)
        gIFShellScreenTemplate_fnUpdate(this, fDt)  -- always call base class
		Form_Update(this.mainForm.form, fDt)
    end,

 
--  fnSaveProfileDone = ifs_archive_fnSaveProfileDone,
}

local gCListMission = 1

function campaign_list_changeFunc(form, element)
	-- fill me in!
	
end

function ifs_sp_campaign_list_fnBuildScreen( this ) 
	if(gPlatformStr == "PC") then
		-- add pc profile & title version text
		AddPCTitleText( this )
	
		-- no tabs here...
		-- Add tabs to screen
		--ifelem_tabmanager_Create(this, gPCMainTabsLayout, gPCSinglePlayerTabsLayout)
	end
	
    local BackButtonW = 150
    local BackButtonH = 25
	
	this.Helptext_Accept = NewPCIFButton -- NewRoundIFButton			
	{
		ScreenRelativeX = 1.0,
		ScreenRelativeY = 1.0,
		x = -BackButtonW * 0.5,
		btnw = BackButtonW, -- made wider to fix 9173 - NM 8/25/04
		btnh = BackButtonH,
		font = "gamefont_small",
		--ColorR = 189, ColorG = 208, ColorB = 242,
		tag = "_accept",
	}
	RoundIFButtonLabel_fnSetString( this.Helptext_Accept, "common.accept" )

	this.Helptext_Back = NewPCIFButton -- NewRoundIFButton
	{
		ScreenRelativeX = 0.0,
		ScreenRelativeY = 1.0,
		x = BackButtonW * 0.5,
		btnw = BackButtonW, -- made wider to fix 9173 - NM 8/25/04
		btnh = BackButtonH,
		font = "gamefont_small",
		--ColorR = 189, ColorG = 208, ColorB = 242,
		tag = "_back",
	}
	RoundIFButtonLabel_fnSetString( this.Helptext_Back, "common.back" )
	
	-- the important form
	this.mainForm = NewIFContainer {
				ScreenRelativeX = 0.4,
				ScreenRelativeY = 0.3,
				--x = 100,
				--y = 50,
			}

	local layout = {
		yTop = 0, --25,
		yHeight = 20,--40,
		ySpacing  = 0,
		UseYSpacing = 1,
		xSpacing = 20,
		
		--title = tagsList.title,
		
		width = 800,
		font = "gamefont_medium",--small",
		flashy = 0,
    
		elements = {
			{
				tag = "clist",
				title = "",
				fnChanged = campaign_list_changeFunc,
				selValue = 1,
				control = "dropdown",
				values = {},
			},
		},
    }
    
	local NUM_ITEMS = table.getn(SPCampaign1)
    -- loop through the tags and get the button layout for them
    for i = 1,NUM_ITEMS do
			layout.elements[1].values[i] = SPCampaign1[i].showstr
    end

	Form_CreateVertical(this.mainForm, layout)
end

--------------------
--------------------

ifs_sp_briefing_fnBuildScreen( ifs_sp_briefing )
ifs_sp_briefing_fnBuildScreen = nil
 
ListManager_fnInitList(ifs_sp_briefing.listbox,ifs_sp_briefing_listbox_layout)
AddIFScreen(ifs_sp_briefing,"ifs_sp_briefing")

--CAMPAIGN LIST--
ifs_sp_campaign_list_fnBuildScreen(ifs_sp_campaign_list)
ifs_sp_campaign_list_fnBuildScreen = nil
AddIFScreen(ifs_sp_campaign_list,"ifs_sp_campaign_list")