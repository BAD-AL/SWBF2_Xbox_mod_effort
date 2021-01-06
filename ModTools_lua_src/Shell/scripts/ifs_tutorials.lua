--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


ifs_tutorials_vbutton_layout = {
	ySpacing  = 5,
	width = 275,
	font = "gamefont_medium",
	buttonlist = {
	
		--these should be numbered consecutively, starting with "1"
		{ tag = "1", string = "2", name = "ifs.tutorials.name1", movie = "tutorial01gcw" },
		{ tag = "2", string = "2", name = "ifs.tutorials.name2", movie = "tutorial02" },
		{ tag = "3", string = "2", name = "ifs.tutorials.name3", movie = "tutorial03" },
		{ tag = "4", string = "2", name = "ifs.tutorials.name4", movie = "tutorial04" },
		{ tag = "5", string = "2", name = "ifs.tutorials.name5", movie = "tutorial05" },
		{ tag = "6", string = "2", name = "ifs.tutorials.name6", movie = "tutorial06" },
		{ tag = "7", string = "2", name = "ifs.tutorials.name7", movie = "tutorial07" },
		{ tag = "8", string = "2", name = "ifs.tutorials.name8", movie = "tutorial08" },
	
	},
	title = "ifs.tutorials.title",
   	-- rotY = 35,
}

----------------------------------------------------------------------------------------
-- this is the menu screen that shows the big list of tutorials
----------------------------------------------------------------------------------------

ifs_tutorials = NewIFShellScreen {
--	bg_texture = "iface_bgmeta_space",
	nologo = 1,
	movieIntro      = nil, -- WAS "ATTE_in",
	movieBackground = "shell_sub_left", -- WAS "ATTE_screen",
	music           = "shell_soundtrack",
	
	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
		y = 20, -- go slightly down from center
	},

	Enter = function(this, bFwd)
		print("ifs_tutorials.Enter()")
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		
		-- set the text for all the buttons
		local n = table.getn(ifs_tutorials_vbutton_layout.buttonlist)
		for i=1,n do 
			local item = ifs_tutorials_vbutton_layout.buttonlist[i]
			RoundIFButtonLabel_fnSetString(this.buttons[item.tag],item.name)
		end		
		
	end,

	Exit = function(this, bFwd)
        gMovieAlwaysPlay = nil
	end,	

	Input_Accept = function(this)		
		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		
		--is the selection unlocked?
		local item = ifs_tutorials_vbutton_layout.buttonlist[tonumber(this.CurButton)]
		ifs_viewtutorial.curItem = item
		ifs_movietrans_PushScreen(ifs_viewtutorial)
	end,
}

----------------------------------------------------------------------------------------
-- this is the viewing screen that actually shows the item of interest.  it is
-- called from ifs_tutorials
-- you should set ifs_viewtutorial.curItem to one of the items in the table
-- above before you enter this screen
----------------------------------------------------------------------------------------

function ifs_viewtutorial_StopViewing(this)
--		ScriptCB_SetIgnoreControllerRemoval(nil)

	this.noPop = 1

	-- if we were playing a movie, stop it
	ifelem_shellscreen_fnStopMovie()
	-- noise	
    ifelm_shellscreen_fnPlaySound(this.exitSound)
	-- done
	ScriptCB_PopScreen()	
end

function HackBGTextureForWidescreen()
	local right, bottom, b, w = ScriptCB_GetScreenInfo()
	if (w ~= 1.0) then
		return "movie_BG2_wide"
	end
	return "movie_BG2"
end

ifs_viewtutorial = NewIFShellScreen {
	nologo = 1,
	bNohelptext_accept = 1,
	music           = "STOP",
	bg_texture       = HackBGTextureForWidescreen(),

	Enter = function(this, bFwd)
		print("ifs_viewtutorial.Enter()")
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
        	gMovieAlwaysPlay = 1

		this.noPop = nil

		-- stop and close shell movie
		ifelem_shellscreen_fnStopMovie()
		ScriptCB_CloseMovie();

		-- open and start localized shell movie
		local langShort = strlower(string.sub(gLangStr, 1, 3))
		local movieFile = "movies\\tut" .. langShort .. gMovieTutorialPostFix .. ".mvs"
		if( ScriptCB_IsFileExist(movieFile) == 0 ) then
			movieFile = "movies\\tuteng" .. gMovieTutorialPostFix .. ".mvs"
		end
		ScriptCB_OpenMovie(movieFile, "");

		-- start the movie
--			ScriptCB_SetIgnoreControllerRemoval(1)
		if(gPlatformStr == "PS2") then
			ifelem_shellscreen_fnStartMovie(this.curItem.movie, 0, nil, nil, 50, 60, 400, 336)
		else
			local movie_left, movie_top, movie_width, movie_height
			movie_left = 90;
			movie_top = 60;
			movie_width = 460;
			movie_height = 350;

			local right, bottom, b, w = ScriptCB_GetScreenInfo()
			if (w ~= 1.0) then
				-- resize to 4x3 section in center of widescreen
				local left, top, width, height
				left   = right * (1 - 1/w) * 0.5
				top    = bottom * (1 - 1/w) * 0.5
				width  = right/w
				height = bottom/w

				movie_left = left + (movie_left / right)*width
				movie_top = top + (movie_top / bottom)*height
				movie_width = movie_width/w
				movie_height = movie_height/w
			end

			ifelem_shellscreen_fnStartMovie(this.curItem.movie, 0, nil, nil, movie_left, movie_top, movie_width, movie_height)
		end
	end,

	Exit = function(this, bFwd)
		ScriptCB_CloseMovie();
		ScriptCB_OpenMovie(gMovieStream, "");
	end,

	Input_Accept = function(this)		
		ifs_viewtutorial_StopViewing(this)
	end,
	Input_Back = function(this)
		ifs_viewtutorial_StopViewing(this)
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
    
    Update = function(this, fDt)        
        if (not this.noPop and not ScriptCB_AreMoviePropertiesPlaying(this.curItem.movie)) then
            ifs_viewtutorial_StopViewing(this);
        end
    end,
}


----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

AddIFScreen(ifs_viewtutorial,"ifs_viewtutorial")
ifs_tutorials.CurButton = AddVerticalButtons(ifs_tutorials.buttons,ifs_tutorials_vbutton_layout)
AddIFScreen(ifs_tutorials,"ifs_tutorials")
