--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


-- determine whether the music for the next screen is playing
function ifs_movietrans_ScreenMusicPlaying(nextScreen)
    if (nextScreen.music) then
        return ScriptCB_IsShellMusicPlaying(nextScreen.music)
    end
    return 0
end


-- start / stop screen music
function ifs_movietrans_ScreenMusicPlay(nextScreen)
    if (nextScreen.music) then
        if (nextScreen.music == "STOP") then
            ScriptCB_SetShellMusic()
        else
            ScriptCB_SetShellMusic(nextScreen.music)
        end
    end
end


-- pushes the next screen with no transition
function ifs_movietrans_PushScreenEnd(nextScreen)
    -- fade in new music
    ScriptCB_SndBusFade("shellmusic", 1.0, 1.0)
    -- start music for next screen now
    ifs_movietrans_ScreenMusicPlay(nextScreen)
    -- push the next screen
    ScriptCB_PushScreen(nextScreen.ScreenName)
end


-- override for default ScriptCB_Push screen which pushes and plays the 
-- destination screen's transition movie before entering, then starts the 
-- screen's background movie when entering the screen
function ifs_movietrans_PushScreen(nextScreen)   
--  assert((nextScreen.type == "screen"), "This is a screen")
    
    -- setup next movies 
    local currentMovie
    local nextMovie
    
    -- does the next screen have an intro ? 
    if (nextScreen.movieIntro) then
        currentMovie = nextScreen.movieIntro
        nextMovie    = nextScreen.movieBackground
        
    -- does it have a background movie ? 
    elseif (nextScreen.movieBackground) then
        currentMovie = nextScreen.movieBackground
        nextMovie    = nil

    -- don't play anything        
    else
        currentMovie = nil
        nextMovie    = nil
    end

    -- schedule movie playback
    --ifelem_shellscreen_fnStartMovie(currentMovie, 0, nextMovie, 1)
    -- disabled transitions
    ifelem_shellscreen_fnStartMovie(nextMovie, 1, nil, 1)
    
    -- save the screen to transition to
    if (nextScreen.movieIntro and 
            not ScriptCB_InMultiplayer() and 
--          not ScriptCB_IsMetagameStateSaved() and
                not ScriptCB_GetInTrainingMission() and
        not ScriptCB_IsCampaignStateSaved()) then
    
        -- if the music is not playing for the next screen ? 
        if (0 == ifs_movietrans_ScreenMusicPlaying(nextScreen)) then
            -- fade out current music
            ScriptCB_SndBusFade("shellmusic", 0.0, 1.0)
        end
    
        ifs_movietrans.nextScreen   = nextScreen
        ifs_movietrans.introEffects = string.format("%s%d", "shell_transition", ifs_movietrans.whooshSound)
        
        -- move onto the next whoosh sound
        ifs_movietrans.whooshSound = ifs_movietrans.whooshSound + 1
        if (ifs_movietrans.whooshSound == 11) then
            ifs_movietrans.whooshSound = 1
        end
        
        -- move to the movie transition screen
        ScriptCB_PushScreen("ifs_movietrans")
    else
    
        ifs_movietrans_PushScreenEnd(nextScreen)
    end
end


-- movie transition screen, plays a movie and pushes the next screen
ifs_movietrans = NewIFShellScreen{
    
    nextScreen   = nil, -- screen to push after the intro movie is completed
    introEffects = nil, -- transition sound effects
    whooshSound  = 1,
    bNohelptext  = 1,
    enterSound   = "",
    exitSound    = "",
    bNohelptext_backPC = 1,
    
    Enter = function(this, bFwd)
        -- ignore controller input for 2^20 frames
        ScriptCB_SetIgnoreInputs(1048576)
        if(this.Helptext_Accept) then
            gHelptext_fnMoveIcon(this.Helptext_Accept)
        end
    end,
    

    Exit = function(this, bFwd)
        -- reenable controller inputs
        ScriptCB_SetIgnoreInputs(0)
    end,
    
    
    Update = function(this, fDt)        
        if (this.nextScreen) then
            
            -- has the intro movie started ? 
            if (this.introEffects and ScriptCB_IsPropertyPlayingNow(this.nextScreen.movieIntro)) then
                -- play transition sfx 
                ScriptCB_SndPlaySound(this.introEffects, 0)
                this.introEffects = nil
            end
            
            
            -- has the intro movie finished ? 
            -- disabled movie transitions
            --if (not ScriptCB_AreMoviePropertiesPlaying(this.nextScreen.movieIntro)) then
                
                ifs_movietrans_PushScreenEnd(this.nextScreen)
                this.nextScreen = nil
            --end
        else
            ScriptCB_PopScreen()
        end
    end,
}

-- add screen to GUI manager
AddIFScreen(ifs_movietrans, "ifs_movietrans")