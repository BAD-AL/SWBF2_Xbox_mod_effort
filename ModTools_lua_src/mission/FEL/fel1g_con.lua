--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")


function ScriptPostLoad()
        --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1-1"}
    cp2 = CommandPost:New{name = "cp2-1"}
    cp3 = CommandPost:New{name = "cp3-1"}
    cp4 = CommandPost:New{name = "cp4-1"}
    cp5 = CommandPost:New{name = "cp5-1"}
    cp6 = CommandPost:New{name = "cp6-1"}

    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)

conquest:Start()

    EnableSPHeroRules()

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
	StealArtistHeap(1536 * 1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(3200000)
    ReadDataFile("ingame.lvl")
    
    --  Empire Attacking (attacker is always #1)
    local ALL = 2
    local IMP = 1
    --  These variables do not change
    local ATT = 1
    local DEF = 2
    
  
    ReadDataFile("sound\\fel.lvl;fel1gcw")
    SetMaxFlyHeight(53)
    SetMaxPlayerFlyHeight (53)

    ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman_jungle",
                    "all_inf_rocketeer_jungle",
                    "all_inf_sniper_jungle",
                    "all_inf_engineer_jungle",
                    "all_inf_officer_jungle",
                    "all_inf_wookiee",
                    "all_hero_chewbacca",
                    "all_hover_combatspeeder")
                    --"all_bldg_defensegridturret")
                    
    ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_dark_trooper",
                    "imp_inf_officer",
                    "imp_hero_bobafett",
                    "imp_walk_atst")
                    --"rep_bldg_defensegridturret")

--ReadDataFile("SIDE\\geo.lvl",
                           --"geo_walk_acklay")


    
SetupTeams{
    all = {
        team = ALL,
        units = 32,
        reinforcements = 150,
        soldier = { "all_inf_rifleman_jungle",9, 25},
        assault = { "all_inf_rocketeer_jungle",1, 4},
        engineer = { "all_inf_engineer_jungle",1, 4},
        sniper  = { "all_inf_sniper_jungle",1, 4},
        officer = { "all_inf_officer_jungle",1, 4},
            special = { "all_inf_wookiee",1, 4},
                       -- turret = { "all_bldg_defensegridturret"},
    },
    imp = {
        team = IMP,
        units = 32,
        reinforcements = 150,
        soldier = { "imp_inf_rifleman", 9, 25},
        assault = { "imp_inf_rocketeer",1, 4},
        engineer = { "imp_inf_engineer",1, 4},
        sniper  = { "imp_inf_sniper",1, 4},
        officer = { "imp_inf_officer",1, 4},
            special = { "imp_inf_dark_trooper",1, 4},
                --  turret = { "imp_bldg_defensegridturret"},
    },

}
    SetHeroClass(ALL, "all_hero_chewbacca")
    SetHeroClass(IMP, "imp_hero_bobafett")

--    --  Local Stats
  --  SetTeamName (3, "locals")
  --  AddUnitClass (3, "geo_walk_acklay", 3)
   -- SetUnitCount (3, 3)
 

    --  Level Stats
    ClearWalkers()
    SetMemoryPoolSize("EntityWalker", 3)
    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
    --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
    AddWalkerType(2, 3) -- 2 attes with 3 leg pairs each
    AddWalkerType(2, 3) -- 2 atats with 3 leg pairs each

    SetMemoryPoolSize ("Aimer", 75)
	SetMemoryPoolSize ("EntityCloth",21)
    SetMemoryPoolSize ("EntityHover",3)
    SetMemoryPoolSize ("Obstacle", 500)
    SetMemoryPoolSize ("TreeGridStack", 261)
    SetMemoryPoolSize ("Weapon", 230)
    SetMemoryPoolSize ("EntityFlyer", 6)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("fel\\fel1.lvl", "fel1_conquest")
    SetDenseEnvironment("false")
    SetAIViewMultiplier(0.65)
    --AddDeathRegion("deathregion")
    --SetStayInTurrets(1)


    --  Movies
    --  SetVictoryMovie(ALL, "all_end_victory")
    --  SetDefeatMovie(ALL, "imp_end_victory")
    --  SetVictoryMovie(IMP, "imp_end_victory")
    --  SetDefeatMovie(IMP, "all_end_victory")

 --  Birdies
    SetNumBirdTypes(1)
    SetBirdType(0,1.0,"bird")

    --  Sound
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)
    
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\fel.lvl",  "fel1")
    OpenAudioStream("sound\\fel.lvl",  "fel1")
    -- OpenAudioStream("sound\\cor.lvl",  "cor1gcw_emt")

    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(1, "impleaving")
    SetOutOfBoundsVoiceOver(2, "allleaving")

    SetAmbientMusic(ALL, 1.0, "all_fel_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.8, "all_fel_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2,"all_fel_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_fel_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.8, "imp_fel_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2,"imp_fel_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_fel_amb_victory")
    SetDefeatMusic (ALL, "all_fel_amb_defeat")
    SetVictoryMusic(IMP, "imp_fel_amb_victory")
    SetDefeatMusic (IMP, "imp_fel_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --  SetSoundEffect("BirdScatter",         "birdsFlySeq1")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


    SetAttackingTeam(ATT)

  --  Camera Stats
    AddCameraShot(0.896307, -0.171348, -0.401716, -0.076796, -116.306931, 31.039505, 20.757469)
    AddCameraShot(0.909343, -0.201967, -0.355083, -0.078865, -116.306931, 31.039505, 20.757469)
    AddCameraShot(0.543199, 0.115521, -0.813428, 0.172990, -108.378189, 13.564240, -40.644150)
    AddCameraShot(0.970610, 0.135659, 0.196866, -0.027515, -3.214346, 11.924586, -44.687294)
    AddCameraShot(0.346130, 0.046311, -0.928766, 0.124267, 87.431061, 20.881388, 13.070729)
    AddCameraShot(0.468084, 0.095611, -0.860724, 0.175812, 18.063482, 19.360580, 18.178158)

end

