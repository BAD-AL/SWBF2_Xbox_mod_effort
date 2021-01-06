--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_meta_movie = NewIFShellScreen {

	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,
	music = "STOP",
	
	winner = nil,
	
	isEnabled = nil,

	title = NewIFText {
		string = "common.none",
		font = "gamefont_large",
		textw = 500, -- overridden to safe width in fnBuildScreen
		texth = 65,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- top
		nocreatebackground = 1,
		ZPos = 100,
	},
	
	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		
		-- stop previous movie
		ifelem_shellscreen_fnStopMovie()
		
		if(gPlatformStr == "XBox") then
			ScriptCB_CloseMovie();
			ScriptCB_OpenMovie("movies\\meta.mvs", "")
		end		
		
		-- if we just finished saving the profile, then bail from here
		-- done save player 1
		if(this.SaveProfile2OnEnter) then
			this.SaveProfile2OnEnter = nil
			ifs_meta_movie_SaveAndExit2()
			return
		end
		-- done player 2
		if(this.PopToSPOnEnter) then
			this.PopToSPOnEnter = nil
			ScriptCB_PopScreen( "ifs_sp" )
			return
		end
		
        -- stop any sound
        ScriptCB_SoundDisable();
		ifs_meta_movie.isEnabled = 1
		
		IFObj_fnSetVis( ifs_meta_movie.title, nil )
		if( ifs_meta_movie.winner ) then
			print("+++ifs_meta_movie.winner = ", ifs_meta_movie.winner)
			ScriptCB_EnableCursor(0)
			if( metagame_state.gamefinished == 1 ) then			
				local winner_name = ScriptCB_getlocalizestr(ifs_meta_movie.winner .. "_m")
				local ShowUStr = ScriptCB_usprintf( "ifs.meta.movie.text", winner_name )
				IFText_fnSetUString( ifs_meta_movie.title, ShowUStr )				
				IFObj_fnSetVis( ifs_meta_movie.title, 1 )
				
				-- play winning movie
				if( ifs_meta_movie.winner == "common.sides.all.name" ) then
					ifelem_shellscreen_fnStartMovie("Rebel_win", 0, nil, 2)
				elseif( ifs_meta_movie.winner == "common.sides.cis.name" ) then
					ifelem_shellscreen_fnStartMovie("CIS_win", 0, nil, 2)
				elseif( ifs_meta_movie.winner == "common.sides.imp.name" ) then
					ifelem_shellscreen_fnStartMovie("Imperial_win", 0, nil, 2)
				elseif( ifs_meta_movie.winner == "common.sides.rep.name" ) then
					ifelem_shellscreen_fnStartMovie("Republic_win", 0, nil, 2)
				end
			else
				-- play secret base movie				
				if( ifs_meta_movie.winner == "common.sides.all.name" ) then
					ifelem_shellscreen_fnStartMovie("Rebel_base", 0, nil, 2)
				elseif( ifs_meta_movie.winner == "common.sides.cis.name" ) then
					ifelem_shellscreen_fnStartMovie("CIS_base", 0, nil, 2)
				elseif( ifs_meta_movie.winner == "common.sides.imp.name" ) then
					ifelem_shellscreen_fnStartMovie("Imperial_base", 0, nil, 2)
				elseif( ifs_meta_movie.winner == "common.sides.rep.name" ) then
					ifelem_shellscreen_fnStartMovie("Republic_base", 0, nil, 2)
				end			
			end
		end
	end,

	Exit = function(this, bFwd)
		ifs_meta_movie.isEnabled = nil
        ScriptCB_SoundEnable();
        ifelem_shellscreen_fnStopMovie()
		ScriptCB_EnableCursor(1)
        
		if(gPlatformStr == "XBox") then
			ScriptCB_CloseMovie();
			ScriptCB_OpenMovie(gMovieStream, "");
		end        
	end,

	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this,fDt)
	
		if( not ScriptCB_IsMoviePlaying() ) then
			ifs_meta_movie_fnQuit( this )
		end
	end,

	Input_Back = function(this)
	end,

	Input_Accept = function(this)
		ifs_meta_movie_fnQuit( this )
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

function ifs_meta_movie_fnQuit( this )
	ifs_meta_movie.isEnabled = nil
	if( metagame_state.gamefinished == 1 ) then
		metagame_state.gamefinished = nil
		metagame_state.pickteam = 3 - metagame_state.pickteam
		ifs_meta_movie_SaveAndExit()
		return
	else
		-- play secret bonus finished vo
		if( ifs_meta_movie.winner == "common.sides.all.name" ) then
            ScriptCB_ShellPlayDelayedStream("all_hoth_rebellion_complete", 0, 0)
		elseif( ifs_meta_movie.winner == "common.sides.cis.name" ) then
            ScriptCB_ShellPlayDelayedStream("cis_geonosis_blockade_complete", 0, 0)
		elseif( ifs_meta_movie.winner == "common.sides.imp.name" ) then
            ScriptCB_ShellPlayDelayedStream("imp_endor_deathstar_complete", 0, 0)
		elseif( ifs_meta_movie.winner == "common.sides.rep.name" ) then
            ScriptCB_ShellPlayDelayedStream("rep_kamino_insurgence_complete", 0, 0)
		end	
		ScriptCB_PopScreen( )
	end
end


----------------------------------------------------------------------------------------
-- if we finished the game, save the profile then exit
----------------------------------------------------------------------------------------

function ifs_meta_movie_SaveAndExit()
	print("ifs_login_SaveAndExit")
	local this = ifs_meta_movie
		
	ifs_saveop.doOp = "SaveProfile"
	ifs_saveop.OnSuccess = ifs_meta_movie_SaveProfileSuccess
	ifs_saveop.OnCancel = ifs_meta_movie_SaveProfileCancel
	local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
	ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
	ifs_saveop.saveProfileNum = iProfileIdx
	ifs_movietrans_PushScreen(ifs_saveop)
end

function ifs_meta_movie_SaveProfileSuccess()
	print("ifs_meta_movie_SaveProfileSuccess")
	-- do player2 once we reenter
	ifs_meta_movie.SaveProfile2OnEnter = 1
	-- pop ifs_saveop
	ScriptCB_PopScreen()
end

function ifs_meta_movie_SaveProfileCancel()
	print("ifs_meta_movie_SaveProfileCancel")
	-- do player2 once we reenter
	ifs_meta_movie.SaveProfile2OnEnter = 1
	-- pop ifs_saveop
	ScriptCB_PopScreen()
end

--------------------------------
-- save profile2
--------------------------------

function ifs_meta_movie_SaveAndExit2()
	print("ifs_login_SaveAndExit2")
	local this = ifs_meta_movie
		
	ifs_saveop.doOp = "SaveProfile"
	ifs_saveop.OnSuccess = ifs_meta_movie_SaveProfile2Success
	ifs_saveop.OnCancel = ifs_meta_movie_SaveProfile2Cancel
	ifs_saveop.saveName = ScriptCB_GetProfileName(2)
	ifs_saveop.saveProfileNum = 2
	ifs_movietrans_PushScreen(ifs_saveop)
end

function ifs_meta_movie_SaveProfile2Success()
	print("ifs_meta_movie_SaveProfile2Success")
	-- do player2 once we reenter
	ifs_meta_movie.PopToSPOnEnter = 1
	-- pop ifs_saveop
	ScriptCB_PopScreen()
end

function ifs_meta_movie_SaveProfile2Cancel()
	print("ifs_meta_movie_SaveProfile2Cancel")
	-- do player2 once we reenter
	ifs_meta_movie.PopToSPOnEnter = 1
	-- pop ifs_saveop
	ScriptCB_PopScreen()
end

----------------------------------------------------------------------------------------
-- done save profile2
----------------------------------------------------------------------------------------




AddIFScreen(ifs_meta_movie,"ifs_meta_movie")
