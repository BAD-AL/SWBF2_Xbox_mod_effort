--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveOneFlagCTF")

--  These variables do not change
ATT = 1
DEF = 2

--  Republic Attacking (attacker is always #1)
REP = ATT
CIS = DEF

--PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()   
    EnableSPHeroRules()
    
    SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )

    
       --This is the actual objective setup
    ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
                           textATT = "game.modes.1flag", textDEF = "game.modes.1flag2",
                           captureLimit = 5, flag = "flag", flagIcon = "flag_icon", 
                           flagIconScale = 3.0, homeRegion = "flag_home",
                           captureRegionATT = "flag_capture1", captureRegionDEF = "flag_capture2",
                           capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
                           capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, multiplayerRules = true, hideCPs = true}
    ctf:Start()

    
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
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(3200000)
    ReadDataFile("ingame.lvl")
    
    SetMemoryPoolSize("Music", 39)  


    ReadDataFile("sound\\fel.lvl;fel1cw")
    SetMaxFlyHeight(53)
    SetMaxPlayerFlyHeight (53)
    ReadDataFile("SIDE\\rep.lvl",
                             
                             "rep_inf_ep3_rifleman",
                             "rep_inf_ep3_rocketeer",
                             "rep_inf_ep3_engineer",
                             "rep_inf_ep3_jettrooper",
                             "rep_inf_ep3_sniper_felucia", 
                             "rep_hero_aalya",
                             "rep_inf_ep3_officer",
                             "REP_walk_atte")
                             --"Rep_hover_swampspeeder")
                                                  --  "rep_bldg_defensegridturret")
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_hover_aat",
                             --"cis_hover_stap",     
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             "cis_inf_engineer",
                             "cis_inf_sniper",
                             "cis_hero_jangofett",
                             "cis_inf_officer",
                             "cis_inf_droideka")
                           --  "cis_bldg_defensegridturret")

      SetAttackingTeam(ATT)
SetupTeams{
    rep = {
        team = REP,
        units = 32,
        reinforcements = -1,
        soldier = { "rep_inf_ep3_rifleman",9, 25},
        assault = { "rep_inf_ep3_rocketeer",1, 4},
        engineer = { "rep_inf_ep3_engineer",1, 4},
        sniper  = { "rep_inf_ep3_sniper_felucia",1, 4},
        officer = { "rep_inf_ep3_officer",1, 4},
        special = { "rep_inf_ep3_jettrooper",1, 4},
              --          turret = { "rep_bldg_defensegridturret"},
            
    },

}   

SetupTeams{
    cis = {
        team = CIS,
        units = 32,
        reinforcements = -1,
        soldier = { "CIS_inf_rifleman",9, 25},
        assault = { "CIS_inf_rocketeer",1, 4},
        engineer = { "CIS_inf_engineer",1, 4},
        sniper  = { "CIS_inf_sniper",1, 4},
        officer = { "CIS_inf_officer",1, 4},
        special = { "cis_inf_droideka",1, 4},
                      --  turret = { "cis_bldg_defensegridturret"},
      
    },

}

    SetHeroClass(REP, "rep_hero_aalya")
    SetHeroClass(CIS, "cis_hero_jangofett")

    --  Level Stats
    ClearWalkers()
    -- AddWalkerType(0, 8)
    --SetMemoryPoolSize("EntityWalker", -2)
    -- AddWalkerType(0, 3) -- 3 droidekas (special case: 0 leg pairs)
    AddWalkerType(3, 1) -- 1 atte with 3 leg pairs each
    SetMemoryPoolSize("CommandWalker", 2)
    SetMemoryPoolSize("EntityHover", 5)
       SetMemoryPoolSize("EntityFlyer", 6)
    --  SetMemoryPoolSize("EntityBuildingArmedDynamic", 16)
    --    SetMemoryPoolSize("MountedTurret", 25)
    -- SetMemoryPoolSize("PowerupItem", 60)
    -- SetMemoryPoolSize("EntityMine", 40)
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("TreeGridStack", 280)
    SetMemoryPoolSize("BaseHint", 101)
    SetMemoryPoolSize("Obstacle", 340)
    SetMemoryPoolSize("FlagItem", 2)
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("fel\\fel1.lvl", "fel1_1ctf")
    SetDenseEnvironment("false")
    SetAIViewMultiplier(0.65)
    --AddDeathRegion("Sarlac01")
    
    --  Birdies
    SetNumBirdTypes(1)
    SetBirdType(0,1.0,"bird")
    

    --  Sound Stats
    
    musicStream = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", musicStream)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", musicStream)
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\fel.lvl",  "fel1")
    OpenAudioStream("sound\\fel.lvl",  "fel1")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    -- OpenAudioStream("sound\\fel.lvl",  "fel1_emt")

    -- SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "Cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_fel_amb_start",  0,1)
    SetAmbientMusic(REP, 0.9, "rep_fel_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.1,"rep_fel_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_fel_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.9, "cis_fel_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.1,"cis_fel_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_fel_amb_victory")
    SetDefeatMusic (REP, "rep_fel_amb_defeat")
    SetVictoryMusic(CIS, "cis_fel_amb_victory")
    SetDefeatMusic (CIS, "cis_fel_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")



    --  Camera Stats
  AddCameraShot(0.896307, -0.171348, -0.401716, -0.076796, -116.306931, 31.039505, 20.757469)
    AddCameraShot(0.909343, -0.201967, -0.355083, -0.078865, -116.306931, 31.039505, 20.757469)
    AddCameraShot(0.543199, 0.115521, -0.813428, 0.172990, -108.378189, 13.564240, -40.644150)
    AddCameraShot(0.970610, 0.135659, 0.196866, -0.027515, -3.214346, 11.924586, -44.687294)
    AddCameraShot(0.346130, 0.046311, -0.928766, 0.124267, 87.431061, 20.881388, 13.070729)
    AddCameraShot(0.468084, 0.095611, -0.860724, 0.175812, 18.063482, 19.360580, 18.178158)

end


