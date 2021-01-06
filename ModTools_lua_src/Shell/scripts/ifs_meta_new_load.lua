--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

----------------------------------------------------------------------------------------
-- check if there is enough room on the hard disk to save one new game.
----------------------------------------------------------------------------------------

function ifs_meta_new_load_StartCheckFreeSpace()
	print("ifs_meta_new_load_CheckFreeSpace")
	
	ifs_saveop.doOp = "StartGC"
	ifs_saveop.OnSuccess = ifs_meta_new_load_CheckFreeSpaceSuccess
	ifs_saveop.OnCancel = ifs_meta_new_load_CheckFreeSpaceCancel
	ifs_movietrans_PushScreen(ifs_saveop);
end

function ifs_meta_new_load_CheckFreeSpaceSuccess()
	print("ifs_meta_new_load_CheckFreeSpaceSuccess")
	
	-- push forward on enter
	ifs_meta_new_load.NewOnEnter = 1	
	ScriptCB_PopScreen()	
end

function ifs_meta_new_load_CheckFreeSpaceCancel()
	print("ifs_meta_new_load_CheckFreeSpaceCancel")
	-- we shouldn't really get here, the fail condition should boot to the dashboard?
	ifs_meta_new_load_CheckFreeSpaceSuccess()
end

----------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------

ifs_meta_new_load = NewIFShellScreen {
	movieIntro      = nil, -- WAS "ifs_meta_intro",
	movieBackground = "shell_sub_left", -- WAS "ifs_meta",

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- top
		y = 20, -- go slightly down from center
	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		
		if(this.NewOnEnter) then
			this.NewOnEnter = nil
			-- tell the SaveGameManager that we're starting a new game
			ScriptCB_StartNewMetagame()
			-- go to the new game screen
            ScriptCB_PushScreen("ifs_meta_tutorial")
		end

		-- if we've got a metagame in progress
		if(bFwd and ScriptCB_IsMetagameStateSaved()) then
			-- jump forward
            ifs_movietrans_PushScreen(ifs_meta_top)
		else
			-- if we don't jump forward, that means we're either loading a game
			-- or starting a new one.  so in both cases we don't want to save
			-- when we enter ifs_meta_main.
			ifs_meta_main.NoPromptSave = 1
			-- and we want to clear the last game's win/lose record
			ScriptCB_SetLastBattleVictoryValid(nil)			
		end
	end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		if(this.CurButton == "new") then
			ifs_meta_new_load_StartCheckFreeSpace()			
			return
		elseif (this.CurButton == "load") then
			ifs_meta_load.Mode = "Load"
			ifs_movietrans_PushScreen(ifs_meta_load)
		end
	end,
	
}

local vbutton_layout = {
--	yTop = -70,
	xWidth = 400,
	width = 400,
	xSpacing = 10,
	ySpacing = 5,
	font = gMenuButtonFont,
	buttonlist = { 
		{ tag = "new", string = "ifs.meta.load.new", },
		{ tag = "load", string = "ifs.meta.load.load", },
	},
	title = "ifs.sp.meta",
	rotY = 35,
}

ifs_meta_new_load.CurButton = AddVerticalButtons(ifs_meta_new_load.buttons,vbutton_layout)
AddIFScreen(ifs_meta_new_load,"ifs_meta_new_load")