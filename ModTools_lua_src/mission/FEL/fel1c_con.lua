--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------

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

function ScriptInit()
	StealArtistHeap(132*1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(3200000)
    ReadDataFile("ingame.lvl")
    
    --  Republic Attacking (attacker is always #1)
    local REP = 1
    local CIS = 2
    --  These variables do not change
    local ATT = 1
    local DEF = 2

    SetMemoryPoolSize("Music", 39)


    ReadDataFile("sound\\fel.lvl;fel1cw")
    SetMaxFlyHeight(53)
    SetMaxPlayerFlyHeight (53)
    ReadDataFile("SIDE\\rep.lvl",
                        "rep_inf_ep3_rifleman",
                        "rep_inf_ep3_rocketeer",
                        "rep_inf_ep3_engineer",
                        "rep_inf_ep3_sniper_felucia", 
                        "rep_inf_ep3_jettrooper",
                        "rep_inf_ep3_officer",
                        "rep_hero_aalya",
                        "rep_walk_oneman_atst")
    ReadDataFile("SIDE\\cis.lvl",
                        "cis_inf_rifleman",
                        "cis_inf_rocketeer",
                        "cis_inf_engineer",
                        "cis_inf_sniper",                            
                        "CIS_inf_officer",
                        "cis_inf_droideka",
                        "cis_hero_jangofett",
                        "cis_tread_snailtank")

      --ReadDataFile("SIDE\\geo.lvl",
                        --"geo_walk_acklay")
    
    SetAttackingTeam(ATT)
SetupTeams{
    rep = {
        team = REP,
        units = 32,
        reinforcements = 150,
        soldier = { "rep_inf_ep3_rifleman",9, 25},
        assault = { "rep_inf_ep3_rocketeer",1, 4},
        engineer = { "rep_inf_ep3_engineer",1, 4},
        sniper  = { "rep_inf_ep3_sniper_felucia",1, 4},
        officer = { "rep_inf_ep3_officer",1, 4},
        special = { "rep_inf_ep3_jettrooper",1, 4},
            
    },
    cis = {
        team = CIS,
        units = 32,
        reinforcements = 150,
        soldier = { "CIS_inf_rifleman",9, 25},
        assault = { "CIS_inf_rocketeer",1, 4},
        engineer = { "CIS_inf_engineer",1, 4},
        sniper  = { "CIS_inf_sniper",1, 4},
        officer = { "CIS_inf_officer",1, 4},
        special = { "cis_inf_droideka",1, 4},
      
    },

}

  SetHeroClass(REP, "rep_HERO_aalya")
    SetHeroClass(CIS, "cis_hero_jangofett")


    --  Level Stats 
    ClearWalkers()
    -- AddWalkerType(0, 8)
    --AddWalkerType(5, 2) -- 2 attes with 2 leg pairs each
    --AddWalkerType(3, 1) -- 3 acklays with 3 leg pairs each
    AddWalkerType(1, 2)
    AddWalkerType(0, 4)
    local weaponCnt = 260
    SetMemoryPoolSize("Aimer", 20)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 200)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityHover", 3)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntitySoundStream", 1)
    SetMemoryPoolSize("EntitySoundStatic", 0)
    SetMemoryPoolSize("EntityWalker", 5)
    SetMemoryPoolSize("MountedTurret", 6)
    SetMemoryPoolSize("Obstacle", 400)
    SetMemoryPoolSize("PathNode", 512)
    SetMemoryPoolSize("TreeGridStack", 280)
    SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("fel\\fel1.lvl", "fel1_conquest")
    SetDenseEnvironment("false")
    SetAIViewMultiplier(0.65)
    --AddDeathRegion("Sarlac01")

    --  Birdies
    SetNumBirdTypes(1)
    SetBirdType(0,1.0,"bird")
    

    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)    
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\fel.lvl",  "fel1")
    OpenAudioStream("sound\\fel.lvl",  "fel1")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    -- OpenAudioStream("sound\\fel.lvl",  "fel1_emt")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "Cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_fel_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_fel_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2,"rep_fel_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_fel_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_fel_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2,"cis_fel_amb_end",    2,1)

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


