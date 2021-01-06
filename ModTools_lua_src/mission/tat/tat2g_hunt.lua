--

-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveTDM")
    --  Empire Attacking (attacker is always #1)
ALL = 2
IMP = 1
    --  These variables do not change
ATT = 1
DEF = 2
function ScriptPostLoad()
	hunt = ObjectiveTDM:New{teamATT = 1, teamDEF = 2, pointsPerKillATT = 1, pointsPerKillDEF = 1,
						 textATT = "game.modes.hunt", textDEF = "game.modes.hunt2", multiplayerRules = true}
    
    hunt.OnStart = function(self)
    	AddAIGoal(ATT, "Deathmatch", 1000)
    	AddAIGoal(DEF, "Deathmatch", 1000)

    end
    

	hunt:Start()
     
end

---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------

function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(2097152 + 65536 * 10)
    ReadDataFile("ingame.lvl")



    AddMissionObjective(IMP, "red", "game.modes.tdm")
    --  AddMissionObjective(IMP, "orange", "level.tat2.objectives.2")
    AddMissionObjective(ALL, "green", "lgame.modes.tdm")
    --  AddMissionObjective(ALL, "orange", "level.tat2.objectives.3")


    SetMaxFlyHeight(40)
	SetMaxPlayerFlyHeight(40)

    ReadDataFile("sound\\tat.lvl;tat2gcw")

    ReadDataFile("SIDE\\des.lvl",
                             "tat_inf_jawa",
                             "tat_inf_tuskenraider",
                             "tat_inf_tuskenhunter")
                             
	--[[ Turrets are disabled in HUNT mode
	ReadDataFile("SIDE\\tur.lvl",
						"tur_bldg_chaingun_roof",
						"tur_weap_built_gunturret")	
    SetMemoryPoolSize("MountedTurret", 14)
	--]]
	
    --  Local Stats
    SetTeamName (1, "Tuskens")
    AddUnitClass (1, "tat_inf_tuskenhunter", 2, 6)
    AddUnitClass (1, "tat_inf_tuskenraider", 2, 6)
    SetUnitCount (1, 32)
    SetTeamAsEnemy(ATT, DEF)
    SetReinforcementCount(1, -1)

    --  Local Stats
    SetTeamName (2, "Jawas")
    AddUnitClass (2, "tat_inf_jawa", 25)
    SetUnitCount (2, 32)
    SetTeamAsEnemy(DEF, ATT)
    SetReinforcementCount(2, -1)
 
    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    SetMemoryPoolSize("Aimer", 14)
    SetMemoryPoolSize("Obstacle", 664)
    SetMemoryPoolSize("PathNode", 384)
    SetMemoryPoolSize("TreeGridStack", 500)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("TAT\\tat2.lvl", "tat2_hunt")
    SetDenseEnvironment("false")


    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "des_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)    
    
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("sound\\tat.lvl",  "tat2")
    OpenAudioStream("sound\\tat.lvl",  "tat2")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")

    -- SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    -- SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    -- SetOutOfBoundsVoiceOver(2, "Allleaving")
    -- SetOutOfBoundsVoiceOver(1, "Impleaving")

    SetAmbientMusic(ALL, 1.0, "all_tat_amb_hunt",  0,1)
    -- SetAmbientMusic(ALL, 0.9, "all_tat_amb_middle", 1,1)
    -- SetAmbientMusic(ALL, 0.1, "all_tat_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_tat_amb_hunt",  0,1)
    -- SetAmbientMusic(IMP, 0.9, "imp_tat_amb_middle", 1,1)
    -- SetAmbientMusic(IMP, 0.1, "imp_tat_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_tat_amb_victory")
    SetDefeatMusic (ALL, "all_tat_amb_defeat")
    SetVictoryMusic(IMP, "imp_tat_amb_victory")
    SetDefeatMusic (IMP, "imp_tat_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")



    SetAttackingTeam(ATT)

    --  Camera Stats
    --Tat2 Mos Eisley
	AddCameraShot(0.974338, -0.222180, 0.035172, 0.008020, -82.664650, 23.668301, 43.955681);
	AddCameraShot(0.390197, -0.089729, -0.893040, -0.205362, 23.563562, 12.914885, -101.465561);
	AddCameraShot(0.169759, 0.002225, -0.985398, 0.012916, 126.972809, 4.039628, -22.020613);
	AddCameraShot(0.677453, -0.041535, 0.733016, 0.044942, 97.517807, 4.039628, 36.853477);
	AddCameraShot(0.866029, -0.156506, 0.467299, 0.084449, 7.685640, 7.130688, -10.895234);
end
