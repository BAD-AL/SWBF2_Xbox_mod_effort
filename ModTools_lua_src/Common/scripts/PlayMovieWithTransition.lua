--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

if not __PLAYMOVIEWITHTRANSITION_LUA__ then
__PLAYMOVIEWITHTRANSITION_LUA__ = 1

--
--fades to a black screen before playing an in-game movie
--
function PlayMovieWithTransition(movieFileName, movieIDName, transitionTime)
	if not transitionTime then
		transitionTime = 1.0
	end
	
	local movieTimer = CreateTimer("movieTimer")
	SetTimerValue(movieTimer, transitionTime)
	StartTimer(movieTimer)
	
	BeginScreenTransition(0, transitionTime, 0, 0, "FADE", "FADE")
	
	local myTimerResponse = OnTimerElapse(
		function(timer)
			ScriptCB_PlayInGameMovie(movieFileName, movieIDName)
			StopTimer(movieTimer)
			ReleaseTimerElapse(myTimerResponse)
		end,
		movieTimer
	)
end


end --__PLAYMOVIEWITHTRANSITION_LUA__