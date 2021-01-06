--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


-- movie player is disabled in game
gMovieDisabled = 1

-- override for default ScriptCB_Push screen which pushes and plays the 
-- destination screen's transition movie before entering, then starts the 
-- screen's background movie when entering the screen
function ifs_movietrans_PushScreen(nextScreen)   
--    assert((nextScreen.type == "screen"), "This is a screen")

    ScriptCB_PushScreen(nextScreen.ScreenName)
end