--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
ScriptCB_DoFile("setup_teams")

-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")


    --  Empire Attacking (attacker is always #1)
    local ALL = 1
    local IMP = 2
    --  These variables do not change
    local ATT = 1
    local DEF = 2

function ScriptPostLoad()

    EnableSPHeroRules()
    
    --CP SETUP for CONQUEST
    
    cp1 = CommandPost:New{name = "CON_CP1"}
    cp2 = CommandPost:New{name = "con_CP1a"}
    cp3 = CommandPost:New{name = "CON_CP2"}
    cp4 = CommandPost:New{name = "CON_CP5"}
    cp5 = CommandPost:New{name = "CON_CP6"}
    cp6 = CommandPost:New{name = "CON_CP7"}


    
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
   
    conquest:Start()
    DisableBarriers("Barrier445");
 end
 function ScriptInit()
     -- Designers, these two lines *MUST* be first!
     SetPS2ModelMemory(4880000)
     ReadDataFile("ingame.lvl")

     ReadDataFile("sound\\uta.lvl;uta1gcw")

    ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman",
                    "all_inf_rocketeer",
                    "all_inf_sniper",
                    "all_inf_engineer",
                    "all_inf_officer",
                    "all_inf_wookiee",
                    "all_hero_hansolo_tat",
                    "all_hover_combatspeeder")
                    
    ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_officer",
                    "imp_inf_dark_trooper",
                    "imp_hero_bobafett",
                    "imp_fly_destroyer_dome",
                    "imp_hover_fightertank")

  SetupTeams{
    all = {
        team = ALL,
        units = 32,
        reinforcements = 150,
        soldier = { "all_inf_rifleman",9, 25},
        assault = { "all_inf_rocketeer",1, 4},
        engineer = { "all_inf_engineer",1, 4},
        sniper  = { "all_inf_sniper",1, 4},
        officer = { "all_inf_officer",1, 4},
        special = { "all_inf_wookiee",1, 4},
    },
}   

SetupTeams{
    imp = {
        team = IMP,
        units = 32,
        reinforcements = 150,
        soldier = { "imp_inf_rifleman",9, 25},
        assault = { "imp_inf_rocketeer",1, 4},
        engineer = { "imp_inf_engineer",1, 4},
        sniper  = { "imp_inf_sniper",1, 4},
        officer = { "imp_inf_officer",1, 4},
        special = { "imp_inf_dark_trooper",1, 4},
     },
}
--Setting up Heros--

    SetHeroClass(IMP, "imp_hero_bobafett")
    SetHeroClass(ALL, "all_hero_hansolo_tat")



     --  Level Stats
     ClearWalkers()
     --    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(1, 4) -- 8 ATST (special case: 1 leg pairs)
     --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
     --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
     SetMemoryPoolSize ("EntityHover",6)
     SetMemoryPoolSize("EntityFlyer", 8)
     SetMemoryPoolSize ("EntityLight",80)
     SetMemoryPoolSize("EntitySoundStatic", 27)       
     SetMemoryPoolSize ("Obstacle", 400)
     SetMemoryPoolSize ("Weapon", 260)

     ReadDataFile("uta\\uta1.lvl", "uta1_Conquest")
     SetDenseEnvironment("false")
     AddDeathRegion("deathregion")
     SetMaxFlyHeight(29.5)
     SetMaxPlayerFlyHeight(29.5)


     --  Sound
     
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick) 
     
     OpenAudioStream("sound\\global.lvl",  "gcw_music")
     -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
     -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
     OpenAudioStream("sound\\uta.lvl",  "uta1")
     OpenAudioStream("sound\\uta.lvl",  "uta1")
     -- OpenAudioStream("sound\\uta.lvl",  "uta1_emt")

     SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
     SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
     SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
     SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

     SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
     SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
     SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
     SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

     SetOutOfBoundsVoiceOver(1, "allleaving")
     SetOutOfBoundsVoiceOver(2, "impleaving")

     SetAmbientMusic(ALL, 1.0, "all_uta_amb_start",  0,1)
     SetAmbientMusic(ALL, 0.8, "all_uta_amb_middle", 1,1)
     SetAmbientMusic(ALL, 0.2, "all_uta_amb_end",    2,1)
     SetAmbientMusic(IMP, 1.0, "imp_uta_amb_start",  0,1)
     SetAmbientMusic(IMP, 0.8, "imp_uta_amb_middle", 1,1)
     SetAmbientMusic(IMP, 0.2, "imp_uta_amb_end",    2,1)

     SetVictoryMusic(ALL, "all_uta_amb_victory")
     SetDefeatMusic (ALL, "all_uta_amb_defeat")
     SetVictoryMusic(IMP, "imp_uta_amb_victory")
     SetDefeatMusic (IMP, "imp_uta_amb_defeat")

     SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
     SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
     --  SetSoundEffect("BirdScatter",         "birdsFlySeq1")
     SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
     SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
     SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
     SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
     SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


--  Camera Stats - Utapau: Sinkhole
    AddCameraShot(-0.428091, 0.045649, -0.897494, -0.095703, 162.714951, 45.857063, 40.647118)
    AddCameraShot(-0.194861, -0.001600, -0.980796, 0.008055, -126.179787, 16.113789, 70.012894);
    AddCameraShot(-0.462548, -0.020922, -0.885442, 0.040050, -16.947638, 4.561796, 156.926956);
    AddCameraShot(0.995310, 0.024582, -0.093535, 0.002310, 38.288612, 4.561796, 243.298508);
    AddCameraShot(0.827070, 0.017093, 0.561719, -0.011609, -24.457638, 8.834146, 296.544586);
    AddCameraShot(0.998875, 0.004912, -0.047174, 0.000232, -45.868237, 2.978215, 216.217880);

 end

