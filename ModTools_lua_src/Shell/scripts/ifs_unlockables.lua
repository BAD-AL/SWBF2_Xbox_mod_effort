--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


ifs_unlockables_vbutton_layout = {
--	yTop = 0,
	ySpacing  = 5,
	width = 275,
	font = gMenuButtonFont,
	buttonlist = { 
		
		--these should be numbered consecutively, starting with "1"
		{ tag = "1", string = "2", name = "ifs.unlock.name1", movie = "nabbonus" },
		{ tag = "2", string = "2", name = "ifs.unlock.name2", movie = "batbonus" },
		{ tag = "3", string = "2", name = "ifs.unlock.name3", movie = "geobonus" },
		{ tag = "4", string = "2", name = "ifs.unlock.name4", movie = "kambonus" },
		{ tag = "5", string = "2", name = "ifs.unlock.name5", movie = "wepbonus" },
		{ tag = "6", string = "2", name = "ifs.unlock.name6", movie = "tatbonus" },
		{ tag = "7", string = "2", name = "ifs.unlock.name7", movie = "yavbonus" },
		{ tag = "8", string = "2", name = "ifs.unlock.name8", movie = "hotbonus" },
		{ tag = "9", string = "2", name = "ifs.unlock.name9", movie = "besbonus" },
		{ tag = "10", string = "2", name = "ifs.unlock.name10", movie = "endbonus" },
		{ tag = "11", string = "2", name = "ifs.unlock.name11", movie = "repbonus" },
	
	},
	title = "ifs.unlock.title",
	-- rotY = 35,
}

--stop viewing the movie/image
function ifs_viewunlockable_StopViewing(this)
	-- if we were playing a movie, stop it
	if(this.curItem.movie) then
--		ScriptCB_SetIgnoreControllerRemoval(nil)
		ifelem_shellscreen_fnStopMovie()
		IFObj_fnSetVis(this.backImg,1)
	end
	-- noise	
    ifelm_shellscreen_fnPlaySound(this.exitSound)
	-- done
	ScriptCB_PopScreen()	
end


-- this is the viewing screen that actually shows the item of interest.  it is
-- called from either ifs_dounlock or ifs_unlockables
-- you should set ifs_viewunlockable.curItem to one of the items in the table
-- above before you enter this screen
ifs_viewunlockable = NewIFShellScreen {
	nologo = 1,
	bNohelptext_accept = 1,
	
	-- whether we're showing something
	bIsViewing = nil,

	backImg = NewIFImage { 
		ScreenRelativeX = 0,
		ScreenRelativeY = 0,
		UseSafezone = 0,
		ZPos = 255, -- behind all.
		texture = "iface_bgmeta_space", 
		localpos_l = 0,
		localpos_t = 0,
		inert = 1, -- Delete this out of lua once created (we'll never touch it again)
	},

	Enter = function(this, bFwd)
--		print("ifs_viewunlockable.Enter()")
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
        gMovieAlwaysPlay = 1
		
		-- no music play for the trailer(11th)
--		print("+++this.curItem.tag=", this.curItem.tag, (this.curItem.tag == "6") )
		if( this.curItem.tag == "11" ) then
			ScriptCB_SetShellMusic()
		end
		
		if(gPlatformStr == "XBox") then
			ScriptCB_CloseMovie();
			if (ScriptCB_IsPAL() == 1) then
				ScriptCB_OpenMovie("movies\\bonuspal.mvs", "")
			else
				ScriptCB_OpenMovie("movies\\bonus.mvs", "")
			end
		end		
		
		if (this.curItem.img) then
			-- show the image
			IFObj_fnSetVis(this.backImg,1)
			IFImage_fnSetTexture(this.backImg, this.curItem.img)
		elseif(this.curItem.movie) then
			-- hide the background
			IFObj_fnSetVis(this.backImg,nil)
			-- start the movie
--			ScriptCB_SetIgnoreControllerRemoval(1)
			ifelem_shellscreen_fnStartMovie(this.curItem.movie, 1, nil, 2)  
		else
--			print("you should set this.curItem.img or this.curItem.movie before entering")
            gMovieAlwaysPlay = nil
			ScriptCB_PopScreen()
		end
	end,

	Exit = function(this, bFwd)
		
		-- set soundtrack back
		if( this.curItem.tag == "11" ) then
			ScriptCB_SetShellMusic("shell_soundtrack")
		end
		
		if(gPlatformStr == "XBox") then
			ScriptCB_CloseMovie();
			ScriptCB_OpenMovie(gMovieStream, "");
		end
	end,	

	Input_Accept = function(this)		
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		ifs_viewunlockable_StopViewing(this)
	end,
	Input_Back = function(this)
		ifs_viewunlockable_StopViewing(this)
	end,
	
	-- we need to override all of these since we don't have a buttonlist on this screen
	Input_GeneralUp = function(this)
	end,
	Input_GeneralRight = function(this)
	end,
	Input_GeneralDown = function(this)
	end,
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralUp2 = function(this)
	end,
	Input_GeneralRight2 = function(this)
	end,
	Input_GeneralDown2 = function(this)
	end,
	Input_GeneralLeft2 = function(this)
	end,	
}


-- this is the menu screen that shows the big list of locked/unlocked items
ifs_unlockables = NewIFShellScreen {
	bg_texture = "iface_bgmeta_space",
	nologo = 1,
	-- bNohelptext = 1,
	movieIntro      = nil,
	movieBackground = nil,
	
--	title = NewIFText {
--		string = "ifs.unlock.title",
--		font = "gamefont_large",
--		textw = 460, -- center on screen. Fixme: do real centering!
--		ScreenRelativeX = 0.5, -- center
--		ScreenRelativeY = 0, -- top
--		y = 10,
--		inert = 1, -- delete out of Lua mem when pushed to C
--	},

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = gDefaultButtonScreenRelativeY, -- center
	},

	Enter = function(this, bFwd)
--		print("ifs_unlockables.Enter()")
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		
		-- set the text for all the buttons
		local n = table.getn(ifs_unlockables_vbutton_layout.buttonlist)
		for i=1,n do 
			local item = ifs_unlockables_vbutton_layout.buttonlist[i]
			if(ScriptCB_UnlockableState(item.tag)) then
				RoundIFButtonLabel_fnSetString(this.buttons[item.tag],item.name)
				item.unlocked = 1
			else
				RoundIFButtonLabel_fnSetString(this.buttons[item.tag], "ifs.unlock.notyet")
				item.unlocked = nil
			end
			if( i == 11 ) then
				RoundIFButtonLabel_fnSetString(this.buttons[item.tag],item.name)
				item.unlocked = 1
			end
		end
		
		-- stop the shell movie
		ifelem_shellscreen_fnStopMovie()
	end,

	Exit = function(this, bFwd)
        gMovieAlwaysPlay = nil
	end,	

	Input_Accept = function(this)		
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		--is the selection unlocked?
		local item = ifs_unlockables_vbutton_layout.buttonlist[tonumber(this.CurButton)]
		if(not item.unlocked) then
			--still locked
            ifelm_shellscreen_fnPlaySound(this.errorSound)          
		else
            ifelm_shellscreen_fnPlaySound(this.acceptSound)
			--unlocked, do the action
			if(item.img or item.movie) then
				ifs_viewunlockable.curItem = item
				ifs_movietrans_PushScreen(ifs_viewunlockable)
			end
		end	
	end,
}

----------------------------------------------------------------------------------------
-- save the profile
----------------------------------------------------------------------------------------

--function ifs_dounlock_SaveThenQuit(this)
--	ifs_dounlock_StartSaveProfile()
--end

--function ifs_dounlock_StartSaveProfile()
--	print("ifs_dounlock_StartProfileSave")

-- don't save here, since we'll do it when we get to ifs_briefing
	-- only do this if the profile is dirty
--	if(ScriptCB_IsCurProfileDirty()) then
--		ifs_saveop.doOp = "SaveProfile"
--		ifs_saveop.OnSuccess = ifs_dounlock_SaveProfileSuccess
--		ifs_saveop.OnCancel = ifs_dounlock_SaveProfileCancel
--		ifs_movietrans_PushScreen(ifs_saveop)
--	else
--		print("ifs_dounlock_StartProfileSave Profile not dirty")
--		ScriptCB_PopScreen()
--	end
--end

--function ifs_dounlock_SaveProfileSuccess()
--	print("ifs_dounlock_SaveProfileSuccess")
--	local this = ifs_dounlock
--	
--	-- bail from ifs_saveop
--	ScriptCB_PopScreen()
--	-- bail from this
--	ScriptCB_PopScreen()
--end
--
--function ifs_dounlock_SaveProfileCancel()
--	print("ifs_dounlock_SaveProfileCancel")
--	local this = ifs_dounlock
--	
--	-- bail from ifs_saveop
--	ScriptCB_PopScreen()
--	-- bail from this
--	ScriptCB_PopScreen()
--end

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

-- this is the screen that is called when a new unlockable is unlocked.
-- you should set "ifs_dounlock.unlockNum" to the index of which one was unlocked
-- this screen handles all the profile unlocking and whatnot
ifs_dounlock = NewIFShellScreen {
--	bg_texture = "iface_bgmeta_space",
	nologo = 1,
	bNohelptext_back = 1,
		
	-- the item to unlock when you enter this screen
	unlockNum = 1, -- nil,
	
	box = NewButtonWindow { 
		ZPos = 200, 
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.5,
		width = 460,
		height = 220,
		titleText = "ifs.unlock.title",

		subtitle = NewIFText {
			string = "ifs.unlock.title",
			font = "gamefont_large",
			textw = 460, -- center on screen.
			texth = 65,
			y = -100,
			nocreatebackground = 1,
		},

		body = NewIFText {
			string = "ifs.unlock.body",
			font = "gamefont_small",
			y = -35,
			textw = 360,
			texth = 140,
			nocreatebackground = 1,
		},
	},

	Enter = function(this, bFwd)
--		print("ifs_dounlock.Enter()")
		-- unlock it in the profile

		gIFShellScreenTemplate_fnEnter(this, bFwd)

		if (this.unlockNum) then
			ScriptCB_UnlockUnlockable(this.unlockNum)

			-- set the title text
			local item = ifs_unlockables_vbutton_layout.buttonlist[this.unlockNum]
			IFText_fnSetString(this.box.subtitle,item.name)

		end		
	end,

	Exit = function(this, bFwd)
		-- clear it			
		if (not bFwd) then
			this.unlockNum = nil
		end
	end,

	Input_Accept = function(this)
		ScriptCB_PopScreen()
--		ifs_dounlock_SaveThenQuit(this)
		-- view the unlocked item
--		ifs_viewunlockable.curItem = ifs_unlockables_vbutton_layout.buttonlist[this.unlockNum]
--      ifs_movietrans_PushScreen(ifs_viewunlockable)
	end,	

	Input_Back = function(this)
--		ifs_dounlock_SaveThenQuit(this)
	end,	

	-- we need to override all of these since we don't have a buttonlist on this screen
	Input_GeneralUp = function(this)
	end,
	Input_GeneralRight = function(this)
	end,
	Input_GeneralDown = function(this)
	end,
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralUp2 = function(this)
	end,
	Input_GeneralRight2 = function(this)
	end,
	Input_GeneralDown2 = function(this)
	end,
	Input_GeneralLeft2 = function(this)
	end,	
}


-- create the screen.  need this to fit the background image to the full screen
function ifs_viewunlockable_CreateScreen(this)
 	local r,b,v,widescreen = ScriptCB_GetScreenInfo()
 	this.backImg.localpos_r = r*widescreen
 	this.backImg.localpos_b = b
 	this.backImg.uvs_b = v
end

ifs_viewunlockable_CreateScreen(ifs_viewunlockable)
ifs_viewunlockable_CreateScreen = nil
AddIFScreen(ifs_viewunlockable,"ifs_viewunlockable")

ifs_unlockables.buttons.ScreenRelativeX = 0.75
ifs_unlockables_vbutton_layout.width = 500
ifs_unlockables.CurButton = AddVerticalButtons(ifs_unlockables.buttons,ifs_unlockables_vbutton_layout)
AddIFScreen(ifs_unlockables,"ifs_unlockables")



AddIFScreen(ifs_dounlock,"ifs_dounlock")