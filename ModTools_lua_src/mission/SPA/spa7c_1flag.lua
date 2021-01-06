--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
-- SPA7 - Felucia
--
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("spa7c_cmn")

myGameMode = "spa7_1flag"

function SetupUnits()
    ReadDataFile("SIDE\\rep.lvl",   
        "rep_inf_ep3_pilot",
--~         "rep_inf_ep3_marine",
        "rep_fly_assault_dome",
        "rep_fly_anakinstarfighter_sc",
        "rep_fly_arc170fighter_sc",        
        "rep_veh_remote_terminal",
--~ 		"rep_fly_gunship_sc",
--~         "rep_fly_arc170fighter_dome",
        "rep_fly_vwing")
        
    ReadDataFile("SIDE\\cis.lvl",
        "cis_inf_pilot",
--~         "cis_inf_marine",
        "cis_fly_fedlander_dome",
        "cis_fly_droidfighter_sc",  
--~         "cis_fly_droidfighter_dome",
--~ 		"cis_fly_droidgunship",
        "cis_fly_greviousfighter",
        "cis_fly_tridroidfighter")
		
	ReadDataFile("SIDE\\tur.lvl",
		"tur_bldg_spa_cis_beam",
--~ 		"tur_bldg_spa_cis_cannon",
		"tur_bldg_spa_cis_chaingun",
		"tur_bldg_spa_rep_beam",
--~ 		"tur_bldg_spa_rep_cannon",
		"tur_bldg_spa_rep_chaingun",
		"tur_bldg_chaingun_roof"
	)
end

myTeamConfig = {
	rep = {
		team = REP,
		units = 32,
		reinforcements = -1,
		pilot    = { "rep_inf_ep3_pilot",32},
--~ 		marine   = { "rep_inf_ep3_marine",10},
	},
	cis = {
		team = CIS,
		units = 32,
		reinforcements = -1,
		pilot    = { "cis_inf_pilot",32},
--~ 		marine   = { "cis_inf_marine",10},
	}
}

function myScriptInit()
	SetMemoryPoolSize("FlagItem", 1)
	SetMemoryPoolSize("CommandFlyer", 0)
end	


---------------------------------------------------------------------------
-- FUNCTION:    ScriptPostLoad
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptPostLoad' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
--------------------------------------------------------------------------- 
function ScriptPostLoad()
	--This makes sure the flag is colorized when it has been dropped on the ground
    SetClassProperty("com_item_flag", "DroppedColorize", 1)

	LockHangarWarsDoors( true )
	SetupFrigateDeaths()
	SetupTurrets()
	
    --This is all the actual ctf objective setup
	ctf = ObjectiveOneFlagCTF:New{
		teamATT = REP, teamDEF = CIS,
		-- need new text
		textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", flag = "cmn_flag",
		homeRegion = "1flag_home", captureRegionATT = "1flag_rep_cap", captureRegionDEF = "1flag_cis_cap",
		capRegionDummyObjectATT = "1flag_rep_marker", capRegionDummyObjectDEF = "1flag_cis_marker",
		multiplayerRules = true, hideCPs = true,
		AIGoalWeight = 0.0,
	}
	SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )
	
    ctf:Start()
	
	-- get them going?
    AddAIGoal(REP, "Deathmatch", 100)
    AddAIGoal(CIS, "Deathmatch", 100)
end