--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_campaign_battle_intro = NewIFShellScreen {
    nologo = 1,
    movieIntro      = nil,
    movieBackground = nil,
    music           = "STOP",
    bNohelptext_accept = 1,
    bNohelptext_back = 1,
    bNohelptext_backPC = 1,

    Enter = function(this)
        local mission = ifs_campaign_mission[ifs_campaign_main.turnNumber]
        if mission.transition then
	        print("Battle Intro", mission.transition[1], mission.transition[2])
            gMovieAlwaysPlay = 1
            ScriptCB_CloseMovie()
            ScriptCB_OpenMovie(mission.transition[1], "")
            ifelem_shellscreen_fnStartMovie(mission.transition[2], 0, nil, 1)
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
        -- restore split screen
        ScriptCB_SetSplitscreen(ifs_campaign_main.wasSplit)
        
        -- save state
        ifs_campaign_main:SaveState()
        
        -- Enter the selected mission
        ScriptCB_EnterMission()
    end,
    
    Input_Back = function(this, joystick)
    end,
    
    Exit = function(this)
        ScriptCB_StopMovie()
        ScriptCB_CloseMovie()
        ScriptCB_EnableScene(true)
		ScriptCB_SndBusFade("shellfx", 0.0, 1.0)
        gMovieAlwaysPlay = nil
    end,    
}

AddIFScreen(ifs_campaign_battle_intro,"ifs_campaign_battle_intro")