--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


function ifs_sp_yoda_startFullscreenMovie(this,movieName,localized, bIsOuttro)
	print("ifs_sp_yoda_startFullscreenMovie: ",movieName)
	-- hide the background
	IFObj_fnSetVis(this.backImg,nil)
	IFObj_fnSetVis(this.Box,nil)
	IFObj_fnSetVis(this.iconModel,nil)
	IFObj_fnSetVis(this.Helptext_Back,nil)
	if(gPlatformStr ~= "PC") then
		IFObj_fnSetVis(this.Helptext_Accept,nil)
	else
		IFObj_fnSetVis(this.buttons.accept,nil)
	end

	local langShort = strlower(string.sub(gLangStr, 1, 3))
	local movieFile = "movies\\tut" .. langShort .. gMovieTutorialPostFix .. ".mvs"
	if( ScriptCB_IsFileExist(movieFile) == 0 ) then
		movieFile = "movies\\tuteng" .. gMovieTutorialPostFix .. ".mvs"
	end
	
	-- stop voice over
	if(gVoiceOverStream and gVoiceOverStream > 0) then
		StopAudioStream(gVoiceOverStream, 0)
	end
	-- stop music
	ScriptCB_SetShellMusic()

	-- Do NOT pop up the missing controller request during his movie
	ScriptCB_SetIgnoreControllerRemoval(1)

	if (localized) then
		ScriptCB_CloseMovie()
		ScriptCB_OpenMovie(movieFile, "")
	else
		if(gPlatformStr == "XBox") then
			ScriptCB_CloseMovie()
			local movie_pre = string.sub( movieName, 1, 3 )
			print( "+++ movie_pre", movie_pre )
			print( "+++ movie_language", langShort )
			local movie_name = nil
			if( ( movie_pre == "nab" ) or ( movie_pre == "tat" ) ) then
				movie_name = "movies\\his_" .. movie_pre .. langShort .. ".mvs"
				if( ScriptCB_IsFileExist(movie_name) == 0 ) then
					movie_name = "movies\\his_" .. movie_pre .. "eng.mvs"
				end
			elseif (ScriptCB_IsPAL() == 1) then
				movie_name = "movies\\his_" .. movie_pre .. "pal.mvs"
				if( ScriptCB_IsFileExist(movie_name) == 0 ) then
					movie_name = "movies\\his_" .. movie_pre .. ".mvs"
				end
			else
				movie_name = "movies\\his_" .. movie_pre .. ".mvs"
			end
			print( "+++ movie_name", movie_name )
			ScriptCB_OpenMovie(movie_name, "")
		end		
	end

	ScriptCB_EnableCursor(0)
	
	-- start the movie
	ScriptCB_SetShellMusic()
	if(bIsOuttro and this.playOuttroMovie_left) then
		local right, bottom, b, w = ScriptCB_GetScreenInfo()
		local left, top, width, height
		if (w ~= 1.0) then
			-- fully visible in widescreen with bars on either side
			left   = right * (1 - 1/w) * 0.5
			top    = bottom * (1 - 1/w) * 0.5
			width  = right/w
			height = bottom/w

			left = left + (this.playOuttroMovie_left / right)*width
			top = top + (this.playOuttroMovie_top / bottom)*height
			width = this.playOuttroMovie_width/w
			height = this.playOuttroMovie_height/w

			IFImage_fnSetTexture(this.backImg,"movie_bg2_wide")
			IFObj_fnSetVis(this.backImg,1) -- re-enable
		else
			left = this.playOuttroMovie_left
			top = this.playOuttroMovie_top
			width = this.playOuttroMovie_width
			height = this.playOuttroMovie_height

			IFImage_fnSetTexture(this.backImg,"movie_bg2")
			IFObj_fnSetVis(this.backImg,1) -- re-enable
		end

		ifelem_shellscreen_fnStartMovie(movieName, 0, nil, nil, 
										left, top, width, height)
	else
		-- Fullscreen
		ifelem_shellscreen_fnStartMovie(movieName, 0, nil, 2)
	end
	this.moviePlaying   = 1
	this.movieLocalized = localized
end

function ifs_sp_yoda_exitFullscreenMovie(this)
--	print("ifs_sp_yoda_exitFullscreenMovie")
	
	-- don't reshow the screen if we're going to launch right away
	if(this.exitMovieFunc ~= ifs_sp_yoda_exitMovieLaunch) then
		-- show the background image
		IFImage_fnSetTexture(this.backImg,"his_brief_BG")
		IFObj_fnSetVis(this.backImg,1)
		IFObj_fnSetVis(this.Box,1)
		IFObj_fnSetVis(this.iconModel,1)

		if(gPlatformStr ~= "PC") then
			IFObj_fnSetVis(this.Helptext_Accept,nil)
		else
			IFObj_fnSetVis(this.buttons.accept,1)
		end

		--IFObj_fnSetVis(this.Helptext_Accept,1)
		IFObj_fnSetVis(this.Helptext_Back,1)

		ScriptCB_EnableCursor(1)
	end

	-- done movie
	ifelem_shellscreen_fnStopMovie()

	if (this.movieLocalized) then
		this.movieLocalized = nil
		ScriptCB_CloseMovie()
		ScriptCB_OpenMovie(gMovieStream, "")
	end

	-- Now pop up the missing controller request, once the movie's over.
	ScriptCB_SetIgnoreControllerRemoval(nil)

	this.moviePlaying = nil
	--call the exit function
	if (this.exitMovieFunc) then
		this.exitMovieFunc(this)
	end
    ScriptCB_SetShellMusic(gCurCampaign[ifs_sp_briefing.iSelected].briefingmusic)
end

function ifs_sp_yoda_exitMovieReenter(this)
	-- reenter this screen
	this.Enter(this,1)
end

function ifs_sp_yoda_exitMovieLaunch(this)
	ScriptCB_EnterMission()
end


ifs_sp_yoda = NewIFShellScreen {
	nologo = 1,
	movieIntro       = nil,
	movieBackground  = nil,
	music            = "STOP",
	movieLocalized   = nil,

	-- background image.  we need to make our own since we want to hide it when the movie is visible
	backImg = NewIFImage { 
		ScreenRelativeX = 0,
		ScreenRelativeY = 0,
		UseSafezone = 0,
		ZPos = 128, -- behind all.
		texture = "his_brief_BG", 
		localpos_l = 0,
		localpos_t = 0,
		inert = 1, -- Delete this out of lua once created (we'll never touch it again)
	},
	iconModel = NewIFModel {
		ScreenRelativeX = 0.85,
		ScreenRelativeY = 0.25,
		x = 0, y = 0,
		scale = LargeScale,
		OmegaY = 0.2,
		lighting = 1,
		ColorR = 76,
		ColorG = 180,
		ColorB = 255,
	},

	buttons = NewIFContainer {
		ScreenRelativeX = 0, -- center
		ScreenRelativeY = 0, -- top
	},

	

	
	Enter = function(this, bFwd)       
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		
		-- right align the launch button	
		if(gPlatformStr == "PC") then
			local w,h = ScriptCB_GetSafeScreenInfo()
			gIFShellScreenTemplate_fnMoveClickableButton(this.buttons.accept,this.buttons.accept.label,w)
		end

		-- stop previous movie
		--ifelem_shellscreen_fnStopMovie()

		if(gPlatformStr == "XBox") then
			ScriptCB_CloseMovie()
		end
						
		-- does the last planet have an exit movie?
		if(this.playExitMovie) then
			-- start the exit movie
			ifs_sp_yoda_startFullscreenMovie(this,this.playExitMovie,this.playExitMovieLocalized, nil)
			-- clear it so we only see it once
			this.playExitMovie = nil
			-- done.  we'll reenter this function when the movie is over
			this.exitMovieFunc = ifs_sp_yoda_exitMovieReenter
			return
		end
		
		-- if this is the last mission of the campaign, we want to go back to the
		-- era select screen, but only after we've played the exit movie
		if(this.popAfterExitMovie) then
--			print("ifs_sp_yoda.popAfterExitMovie")
			this.popAfterExitMovie = nil
			-- tell the previous screen to pop too
			ifs_sp_briefing.popOnEnter = 1
			ScriptCB_PopScreen()
			return
		end
		
		-- does this planet have an intro movie?
		if(this.playIntroMovie) then
			-- start the intro movie
			ifs_sp_yoda_startFullscreenMovie(this,this.playIntroMovie,this.playIntroMovieLocalized, nil)
			-- clear it so we only see it once
			this.playIntroMovie = nil
			-- done. we'll reenter this function when movie is done
			this.exitMovieFunc = ifs_sp_yoda_exitMovieReenter
			return
		end
		
		-- Compress the text's interline spacing if necessary
		if(gLangStr ~= "english") then
			IFText_fnSetLeading(this.Box.description,-2)
		end

		-- set the description text to the current planet
		local Selection = gCurCampaign[ifs_sp_briefing.iSelected]
		IFText_fnSetString(this.Box.description,Selection.description)		
		IFText_fnSetString(this.Box.border.titleBarElement,Selection.showstr)
		
		print( "Selection.iconmodel = ", Selection.iconmodel )
		if( Selection.iconmodel ) then
			IFModel_fnSetMsh(this.iconModel,Selection.iconmodel)
		end
		
		AnimationMgr_AddAnimation(this.iconModel,{ fTotalTime = 1,fStartAlpha = 0, fEndAlpha = 1,
									fStartX = 0,fEndX   = 0,fStartY = 0,fEndY   = 0,
									fStartW = 0,fStartH = 0,fEndW   = 0.5,fEndH   = 0.5,})
		IFObj_fnSetAlpha(this.iconModel,1,1) -- constant for this item
		
		if (Selection.voiceover) then
			PlayAudioStreamUsingProperties("sound\shell.lvl", Selection.voiceover, 1)
		end
        
        if( Selection.briefingmusic ) then
			ScriptCB_SetShellMusic(Selection.briefingmusic)
			print("playing music" .. Selection.briefingmusic)
		end
		
		-- start the movie when we enter
		local w,h,v,widescreen = ScriptCB_GetScreenInfo() -- note this isn't the safe dimensions!
		
		if( bFwd ) then
			if(gPlatformStr == "XBox") then
				ScriptCB_CloseMovie()
				if(Selection) then
					print( "+++Selection.movie", Selection.movie, string.sub(Selection.movie, 5, 7) )
					if( string.sub(Selection.movie, 5, 7) == "fly" ) then
						ScriptCB_OpenMovie("movies\\fly.mvs", "")
					else
						if (ScriptCB_IsPAL() == 1) then
							ScriptCB_OpenMovie("movies\\hispal.mvs", "")
						else
							ScriptCB_OpenMovie("movies\\his.mvs", "")
						end
					end
				end
			end		

			-- calc the position of the movie preview window
			local movieW
			local movieH
			local movieX
			local movieY
			if(gPlatformStr ~= "PC") then
				movieW = 480.0
				movieH = 360.0
				movieX = w - movieW
				movieY = h - movieH + 24.0
			else
				movieW = 500.0
				movieH = 400.0
				movieX = w - 490
				movieY = h - movieH + 24.0 - 20
			end

			ifelem_shellscreen_fnStartMovie(Selection.movie, 0, nil, nil, movieX, movieY, movieW, movieH)
		end       

	end,
	
	Exit = function(this, bFwd)
		ifelm_shellscreen_fnPlaySound(this.exitSound)
		-- are we waiting for a movie to stop?
		if(this.moviePlaying) then
			this.exitMovieFunc = nil
			ifs_sp_yoda_exitFullscreenMovie(this)
		else
			--stop the fly through movie
			ifelem_shellscreen_fnStopMovie()
		end
		
		if(gPlatformStr == "XBox") then
			ScriptCB_CloseMovie()
			ScriptCB_OpenMovie(gMovieStream, "")
		end		
		
		if(gVoiceOverStream and gVoiceOverStream > 0) then
			StopAudioStream(gVoiceOverStream, 0)
		end
	end,
	
	Update = function(this, fDt)
		-- Call base class functionality
		gIFShellScreenTemplate_fnUpdate(this, fDt)
		
		-- are we waiting for a movie to stop?
		if(this.moviePlaying and not ScriptCB_IsMoviePlaying()) then
			ifs_sp_yoda_exitFullscreenMovie(this)
		end
	end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		if(this.moviePlaying) then
			ifs_sp_yoda_exitFullscreenMovie(this)
			return
		end
		
		-- does this planet have an outtro movie?
		if(this.playOuttroMovie) then
			-- stop fly through movie 
			ifelem_shellscreen_fnStopMovie()

			-- start the intro movie
			ifs_sp_yoda_startFullscreenMovie(this,this.playOuttroMovie,this.playOuttroMovieLocalized,1)
			-- clear it so we only see it once
			this.playOuttroMovie = nil
			this.playOuttroMovie_left = nil
			this.playOuttroMovie_top = nil
			this.playOuttroMovie_width = nil
			this.playOuttroMovie_height = nil

			-- Launch the mission when we're done
			this.exitMovieFunc = ifs_sp_yoda_exitMovieLaunch
			return
		end
		
		if( this.CurButton == "accept" ) then
			-- no movie, so just launch now
			ScriptCB_EnterMission()
		end
	end,
	

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

-- build the screen
function ifs_sp_yoda_fnBuildScreen(this)	
	-- note this isn't the safe dimensions!
	local w,h,v,widescreen = ScriptCB_GetScreenInfo()

	--size the background
 	this.backImg.localpos_r = w*widescreen
 	this.backImg.localpos_b = h
 	this.backImg.uvs_b = v	
 	
	w,h = ScriptCB_GetSafeScreenInfo()

	-- Had to make box wider to fit German onscreen. NM 7/5/04
	-- Do NOT change this w/o re-verifying bugs 6009, 6015, 6018
	local BoxW
	local BoxH

	if(gPlatformStr == "PC") then
		BoxW = w * 0.75
		BoxH = h * 0.60
	else
		BoxW = w * 0.8
		BoxH = h * 0.75
	end
	local TextW = BoxW - 32
	local TextH = BoxH - 32

	this.Box = NewIFContainer {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.5,
		width = BoxW,
		height = BoxH,
		--rotY = 35,
		header = "Foo",
		x = -35, -- a little right of center (due to tilt)
		y = 10,
		
		border = NewButtonWindow {
				titleText = "title",
				font = "gamefont_tiny",
				x = 0,
				y = 0,
				width = BoxW,
				height = BoxH,
				ZPos = 220,
		},		
		
		description = NewIFText {
			string = "text",
			font = "gamefont_tiny",
			halign = "left",
			valign = "top",
			flashy = 0,
			textw = TextW,
			texth = TextH,
			x = TextW * -0.5,
			y = TextH * -0.5,
		}		
	}

	if(gPlatformStr == "PC") then
		this.buttons.accept = NewClickableIFButton 
		{ 
			x = w * 0.098,
			y = h - 15,
			btnw = w*.2, 
			btnh = ScriptCB_GetFontHeight("gamefont_large"),
			--font = "gamefont_large", 
			--bg_width = w*.1,
			nocreatebackground = 1,
		}
		this.buttons.accept.label.bHotspot = 1
		this.buttons.accept.label.fHotspotW = this.buttons.accept.btnw
		this.buttons.accept.label.fHotspotH = this.buttons.accept.btnh
		this.buttons.accept.tag = "accept"
		RoundIFButtonLabel_fnSetString(this.buttons.accept ,"ifs.onlinelobby.launch")
	end

end


ifs_sp_yoda_fnBuildScreen(ifs_sp_yoda)
ifs_sp_yoda_fnBuildScreen = nil
AddIFScreen(ifs_sp_yoda,"ifs_sp_yoda")