--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
-- SPA8 - Hoth
--
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("spa8g_cmn")

myGameMode = "spa8_1flag"

function SetupUnits()
    ReadDataFile("SIDE\\all.lvl",
        "all_inf_pilot",
--~         "all_inf_marine",
        "all_fly_xwing_sc",
        "all_fly_ywing_sc",
        "all_fly_awing",
--~ 		"all_fly_gunship_sc",
        "all_veh_remote_terminal")
     ReadDataFile("SIDE\\imp.lvl",
        "imp_inf_pilot",
--~         "imp_inf_marine",
        "imp_fly_tiefighter_sc",
        "imp_fly_tiebomber_sc",
        "imp_fly_tieinterceptor",
--~         "imp_fly_trooptrans",
        "imp_veh_remote_terminal")
		
    ReadDataFile("SIDE\\tur.lvl",
		"tur_bldg_spa_all_beam",
--~ 		"tur_bldg_spa_all_cannon",
		"tur_bldg_spa_all_chaingun",
		"tur_bldg_spa_imp_beam",
--~ 		"tur_bldg_spa_imp_cannon",
		"tur_bldg_spa_imp_chaingun",
		"tur_bldg_chaingun_roof"
	)
end

myTeamConfig = {
	 all = {
		team = ALL,
		units = 32,
		reinforcements = -1,
		pilot    = { "all_inf_pilot", 32 },
--~ 		marine   = { "all_inf_marine",6},
	},

	imp = {
		team = IMP,
		units = 32,
		reinforcements = -1,
		pilot    = { "imp_inf_pilot", 32},
--~ 		marine   = { "imp_inf_marine",6},
	}
}

function myScriptInit()
	SetMemoryPoolSize("FlagItem", 1)
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
--~ 	SetProperty("imp_flag", "GeometryName", "com_icon_imperial_flag")
--~     SetProperty("imp_flag", "CarriedGeometryName", "com_icon_imperial_flag")
--~     SetProperty("cmn_flag", "GeometryName", "com_icon_alliance")
--~     SetProperty("cmn_flag", "CarriedGeometryName", "com_icon_alliance_flag")

	--This makes sure the flag is colorized when it has been dropped on the ground
    SetClassProperty("com_item_flag", "DroppedColorize", 1)
	
	ctf = ObjectiveOneFlagCTF:New{
		teamATT = IMP, teamDEF = ALL,
		-- need new text
		textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", flag = "cmn_flag",
		homeRegion = "home_1flag", captureRegionATT = "imp_cap_1flag", captureRegionDEF = "all_cap_1flag",
		capRegionDummyObjectATT = "1flag_imp_marker", capRegionDummyObjectDEF = "1flag_all_marker",
		multiplayerRules = true, hideCPs = true,
		AIGoalWeight = 0.0,
	}
	SoundEvent_SetupTeams( IMP, 'imp', ALL, 'all' )
    ctf:Start()

	SetupTurrets()
	LockHangarWarsDoors( true )
	SetupFrigDeathAnims()
	
    AddAIGoal(IMP, "Deathmatch", 100)
    AddAIGoal(ALL, "Deathmatch", 100)
end