--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

function HackBGTextureForWidescreen()
	local right, bottom, b, w = ScriptCB_GetScreenInfo()
	if (w ~= 1.0) then
		return "movie_BG2_wide"
	end
	return "movie_BG2"
end

ifs_meta_tutorial = NewIFShellScreen {
	nologo = 1,
	--bNohelptext_accept = 1,
	--bNohelptext_back = 1,
    music = "STOP",
	bg_texture       = HackBGTextureForWidescreen(),
		
	winner = nil,
	
	isEnabled = nil,
	
	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		
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

--		print("++++movieFile", movieFile)								
		-- play GC tutorial movie
		--ifelem_shellscreen_fnStartMovie("tutorial08", 0, nil, 1)
		if(gPlatformStr == "PS2") then
			ifelem_shellscreen_fnStartMovie("tutorial08", 0, nil, nil, 50, 60, 400, 336)
		else
			local movie_left, movie_top, movie_width, movie_height
			movie_left = 90;
			movie_top = 60;
			movie_width = 450;
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

			ifelem_shellscreen_fnStartMovie("tutorial08", 0, nil, nil, movie_left, movie_top, movie_width, movie_height)
		end
	end,

	Exit = function(this, bFwd)
        ScriptCB_SoundEnable();
        ifelem_shellscreen_fnStopMovie()
		ScriptCB_CloseMovie();
		ScriptCB_OpenMovie(gMovieStream, "");        
	end,

	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this,fDt)
	
		if( not ScriptCB_IsMoviePlaying() ) then
			ifs_meta_tutorial_fnQuit( this )
		end
	end,

	Input_Back = function(this)
		ScriptCB_PopScreen( "ifs_meta_new_load" )
	end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end
		ifs_meta_tutorial_fnQuit( this )
	end,

	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,
	Input_GeneralUp = function(this)
	end,
	Input_GeneralDown = function(this)
	end,
}

function ifs_meta_tutorial_fnQuit( this )
	ScriptCB_PushScreen( "ifs_meta_opts" )
end

AddIFScreen(ifs_meta_tutorial,"ifs_meta_tutorial")
