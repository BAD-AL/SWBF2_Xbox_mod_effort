--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_freeform_pickscenario_vbutton_layout = {
--	yTop = -70,
	xWidth = 400,
	width = 400,
	xSpacing = 10,
	ySpacing = 5,
	font = gMenuButtonFont,
	buttonlist = { 	
		{ tag = "load", string = "ifs.meta.load.btnload", },
		{ tag = "1", string = "ifs.meta.Configs.1", },
		{ tag = "2", string = "ifs.meta.Configs.2", },
		{ tag = "3", string = "ifs.meta.Configs.3", },
		{ tag = "4", string = "ifs.meta.Configs.4", },
		{ tag = "custom", string = "ifs.meta.Configs.custom", },
	},
	title = "ifs.meta.Configs.title",
--	rotY = 35,
}


ifs_freeform_pickscenario = NewIFShellScreen {
	movieIntro      = nil, -- WAS "ifs_freeform_pickscenario_intro",
	movieBackground = "shell_sub_left", -- WAS "ifs_freeform_pickscenario",
	music           = "shell_soundtrack",
	bAcceptIsSelect = 1,

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = gDefaultButtonScreenRelativeY, -- center
	},

	Input_Accept = function(this)
		-- tabs
		if(gPlatformStr == "PC") then
   			if(ifelem_tabmanager_HandleInputAccept(this, gPCSinglePlayerTabsLayout)) then
   				return
   			end
		end

		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
 		if (this.CurButton == "load") then
 			-- load existing game
			ifs_freeform_load.Mode = "Load"
			ifs_freeform_load.SkipPromptSave = 1
			ifs_saveop.saveProfileNum = ScriptCB_GetPrimaryController()
			ifs_movietrans_PushScreen(ifs_freeform_load)
		elseif (this.CurButton == "custom") then
			-- go to custom setup
			ifs_movietrans_PushScreen(ifs_freeform_customsetup)
		else
			-- always clear the quit player here
			ScriptCB_SetQuitPlayer(1)
			if (this.CurButton == "1") then
				-- rebel scenario
				ifs_freeform_start_all(ifs_freeform_main)
			elseif (this.CurButton == "2") then
				-- cis scenario
				ifs_freeform_start_cis(ifs_freeform_main)
			elseif (this.CurButton == "3") then
				-- republic scenario
				ifs_freeform_start_rep(ifs_freeform_main)
			elseif (this.CurButton == "4") then
				-- empire scenario
				ifs_freeform_start_imp(ifs_freeform_main)
			end
			if( this.CurButton ~= nil ) then
				-- start new game
				ifs_movietrans_PushScreen(ifs_freeform_main)
			end
		end
	end,
	
	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		-- tabs	
		if(gPlatformStr == "PC") then
			ifelem_tabmanager_SetSelected(this, gPCSinglePlayerTabsLayout, "_tab_meta")
		end

		-- Resize buttons to be minimal width
		this.CurButton = ShowHideVerticalButtons(ifs_freeform_pickscenario.buttons,ifs_freeform_pickscenario_vbutton_layout)
		SetCurButton(this.CurButton)
	end,
}

function ifs_freeform_pickscenario_fnBuildScreen( this ) 
	if(gPlatformStr == "PC") then
		-- Add tabs to screen
		ifelem_tabmanager_Create(this, gPCSinglePlayerTabsLayout)
	end
end

ifs_freeform_pickscenario_fnBuildScreen( ifs_freeform_pickscenario )
ifs_freeform_pickscenario_fnBuildScreen = nil

ifs_freeform_pickscenario.CurButton = AddVerticalButtons(ifs_freeform_pickscenario.buttons,ifs_freeform_pickscenario_vbutton_layout)
AddIFScreen(ifs_freeform_pickscenario,"ifs_freeform_pickscenario")
