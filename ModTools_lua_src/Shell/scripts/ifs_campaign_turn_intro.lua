--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_campaign_turn_intro = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,

	Enter = function(this)
		local mission = ifs_campaign_mission[ifs_campaign_main.turnNumber]
		if mission.intro then
			print ("Turn Intro", mission.intro[1], mission.intro[2])
			gMovieAlwaysPlay = 1
			ScriptCB_CloseMovie()
			ScriptCB_OpenMovie(mission.intro[1], "")	-- was gMovieStream
			ifelem_shellscreen_fnStartMovie(mission.intro[2], 0, nil, 1)
			if ScriptCB_IsMoviePlaying() then
				ScriptCB_EnableScene(false)
				ScriptCB_SetShellMusic()
				ScriptCB_SndBusFade("shellfx", 0.0, 0.0)
				StopAudioStream(gVoiceOverStream, 0)
				StopAudioStream(gMusicStream, 0)
			end
		end
	end,

	Update = function(this, fDt)
		if not ScriptCB_IsMoviePlaying() then
			this:Input_Accept(this, nil)
		else
			ScriptCB_EnableCursor(nil) -- PC needs to kill the cursor - BF2 bug 6363 NM 9/27/05
		end
	end,
	
	Input_Accept = function(this, joystick)
		ScriptCB_PopScreen()
		
--		-- if on the first mission, or still on the same planet (e.g., space to ground)
--		if ifs_campaign_main.turnNumber <= 1 or ifs_campaign_mission[ifs_campaign_main.turnNumber - 1].planet == ifs_campaign_mission[ifs_campaign_main.turnNumber].planet then
			-- go to the battle screen
			ScriptCB_PushScreen("ifs_campaign_battle")
--		else
--			-- go to the overview screen
--			ScriptCB_PushScreen("ifs_campaign_overview")
--		end
	end,
	
	Input_Back = function(this, joystick)
	end,
	
	Exit = function(this)
		ScriptCB_StopMovie()
		ScriptCB_CloseMovie()
		ScriptCB_EnableScene(true)
		ScriptCB_SetShellMusic(ifs_campaign_main.shellMusic)
		ScriptCB_SndBusFade("shellfx", 0.0, 1.0)
		gMovieAlwaysPlay = nil
	end,	
}

AddIFScreen(ifs_campaign_turn_intro,"ifs_campaign_turn_intro")