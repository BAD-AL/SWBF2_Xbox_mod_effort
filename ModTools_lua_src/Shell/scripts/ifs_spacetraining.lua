--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_spacetraining = NewIFShellScreen {
	nologo = 1,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1, -- requested by Greg Johnson 9/20/05
	music = "STOP",

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		gMovieAlwaysPlay = 1

		ScriptCB_CloseMovie()
		ScriptCB_EnableCursor(nil) -- PC needs to kill the cursor - BF2 bug 6363 NM 9/27/05

		local movie_files = {
			english    = "movies\\training.mvs",
			french     = "movies\\trainingfr.mvs",
			german     = "movies\\traininggr.mvs",
		}
		local movie_file = movie_files[gLangStr] or movie_files.english
		ScriptCB_OpenMovie(movie_file, "")
		ifelem_shellscreen_fnStartMovie("training", 0, nil, 1)  
		if ScriptCB_IsMoviePlaying() then
			-- 		 ScriptCB_EnableScene(false)
			ScriptCB_SetShellMusic()
			ScriptCB_SndBusFade("shellfx", 0.0, 0.0)
			StopAudioStream(gVoiceOverStream, 0)
			StopAudioStream(gMusicStream, 0)
		end
	end,

	Exit = function(this, bFwd)
		ScriptCB_StopMovie()
		ScriptCB_CloseMovie()
		-- 	     ScriptCB_EnableScene(true)
		ScriptCB_SndBusFade("shellfx", 0.0, 1.0)
		ScriptCB_OpenMovie(gMovieStream, "")
		gMovieAlwaysPlay = nil
	end,

	Update = function(this, aDt)
		if ( not ScriptCB_IsMoviePlaying() ) then
		  ScriptCB_PopScreen()
		else
			ScriptCB_EnableCursor(nil) -- PC needs to kill the cursor - BF2 bug 6363 NM 9/27/05
		end
	end,

   Input_Accept = function(this)		
		   ifelem_shellscreen_fnStopMovie()
		  end,

   Input_Start = function(this)
		if(gPlatformStr == "PC") then 
			ifelem_shellscreen_fnStopMovie()
		end
	end,

   Input_Back = function(this)
		   ifelem_shellscreen_fnStopMovie()
-- 		   ScriptCB_PopScreen()	
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

AddIFScreen(ifs_spacetraining,"ifs_spacetraining")

