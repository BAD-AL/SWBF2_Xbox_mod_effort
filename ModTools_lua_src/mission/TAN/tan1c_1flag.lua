--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveOneFlagCTF")

--  These variables do not change
ATT = 1
DEF = 2

--  Republic Attacking (attacker is always #1)
REP = ATT
CIS = DEF

 ---------------------------------------------------------------------------
 -- FUNCTION:    ScriptInit
 -- PURPOSE:     This function is only run once
 -- INPUT:
 -- OUTPUT:
 -- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
 --              mission script must contain a version of this function, as
 --              it is called from C to start the mission.
 ---------------------------------------------------------------------------
 
 --PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

    SoundEvent_SetupTeams( CIS, 'cis', REP, 'rep' )

    AddDeathRegion("turbinedeath")
    KillObject("blastdoor")
    DisableBarriers("barracks")
    DisableBarriers("liea")
    
        -- Turbine Stuff -- 
    BlockPlanningGraphArcs("turbine")
    OnObjectKillName(destturbine, "turbineconsole")
    OnObjectRespawnName(returbine, "turbineconsole")

    SetMapNorthAngle(180)
    
    ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
                           textATT = "game.modes.1flag", textDEF = "game.modes.1flag2",
                           captureLimit = 5, flag = "flag", flagIcon = "flag_icon", 
                           flagIconScale = 3.0, homeRegion = "1flag_team1_capture",
                           captureRegionATT = "1flag_team1_capture", captureRegionDEF = "1flag_team2_capture",
                           capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
                           capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, multiplayerRules = true}
    ctf:Start()
    
    EnableSPHeroRules()

   --Setup Timer-- 

    timeConsole = CreateTimer("timeConsole")

    SetTimerValue(timeConsole, 0.3)

    StartTimer(timeConsole)
    OnTimerElapse(
        function(timer)
            SetProperty("turbineconsole", "CurHealth", GetObjectHealth("turbineconsole") + 1)
            DestroyTimer(timer)
        end,
    timeConsole
    )

        
end

function destturbine()
    UnblockPlanningGraphArcs("turbine")
    PauseAnimation("Turbine Animation")
    RemoveRegion("turbinedeath")
--    SetProperty("woodr", "CurHealth", 15)
end

function returbine()
    BlockPlanningGraphArcs("turbine")
    PlayAnimation("Turbine Animation")
    AddDeathRegion("turbinedeath")
--    SetProperty("woodr", "CurHealth", 15)
end

function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(700000)
    SetPS2ModelMemory(5050000)
    ReadDataFile("ingame.lvl")
    SetWorldExtents(1064.5)

    ReadDataFile("sound\\tan.lvl;tan1cw")

    ReadDataFile("SIDE\\rep.lvl",
                             "rep_inf_ep3_rifleman",
                             "rep_inf_ep3_rocketeer",
                             "rep_inf_ep3_engineer",
                             "rep_inf_ep3_jettrooper",
                             "rep_inf_ep3_sniper",
                             "rep_inf_ep3_officer",
                             "rep_hero_yoda")
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             "cis_inf_engineer",
                             "cis_inf_sniper",
                             "cis_inf_officer",
                             "cis_inf_droideka",
                             "cis_hero_grievous")


    SetupTeams{

        rep={
            team = REP,
            units = 32,
            reinforcements = -1,
            soldier = {"rep_inf_ep3_rifleman",7, 25},
            assault = {"rep_inf_ep3_rocketeer",1, 4},
            engineer = {"rep_inf_ep3_engineer",1, 4},
            sniper  = {"rep_inf_ep3_sniper",1, 4},
            officer = {"rep_inf_ep3_officer",1, 4},
            special = {"rep_inf_ep3_jettrooper",1, 4},
            
            
        },
        
        cis={
            team = CIS,
            units = 32,
            reinforcements = -1,
            soldier = {"cis_inf_rifleman",7, 25},
            assault = {"cis_inf_rocketeer",1, 4},
            engineer = {"cis_inf_engineer",1, 4},
            sniper = {"cis_inf_sniper",1, 4},
            officer = {"cis_inf_officer",1, 4},
            special = {"cis_inf_droideka",1, 4},
        }
    }
    
            --  Hero Setup Section  --

        SetHeroClass(REP, "rep_hero_yoda")
        SetHeroClass(CIS, "cis_hero_grievous")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 5)  -- number of droidekas

     local weaponCnt = 177
     local guyCnt = 32
     SetMemoryPoolSize("FlagItem", 1)
     SetMemoryPoolSize ("Aimer", 15)
     SetMemoryPoolSize ("AmmoCounter", weaponCnt)
     SetMemoryPoolSize ("EnergyBar", weaponCnt)
     SetMemoryPoolSize ("EntityCloth", 18)
     SetMemoryPoolSize ("EntitySoundStream", 14)
     SetMemoryPoolSize ("EntitySoundStatic", 30)
     SetMemoryPoolSize ("EntityFlyer", 6)
     SetMemoryPoolSize ("MountedTurret", 0)
     SetMemoryPoolSize ("Navigator", guyCnt)
     SetMemoryPoolSize ("Obstacle", 300)
     SetMemoryPoolSize ("PathFollower", guyCnt)
     SetMemoryPoolSize ("PathNode", 384)
     SetMemoryPoolSize ("SoundspaceRegion", 15)
     SetMemoryPoolSize ("TreeGridStack", 200)
     SetMemoryPoolSize ("UnitAgent", guyCnt)
     SetMemoryPoolSize ("UnitController", guyCnt)
     SetMemoryPoolSize ("Weapon", weaponCnt)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("tan\\tan1.lvl", "tan1_1flag")
    SetDenseEnvironment("false")
    AISnipeSuitabilityDist(30)
    --AddDeathRegion("Sarlac01")
    -- SetMaxFlyHeight(90)
    -- SetMaxPlayerFlyHeight(90)

    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)    
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\tan.lvl",  "tan1")
    OpenAudioStream("sound\\tan.lvl",  "tan1")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    -- OpenAudioStream("sound\\tan.lvl",  "tan1_emt")

    -- SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "Cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_tan_amb_start",  0,1)
    SetAmbientMusic(REP, 0.9, "rep_tan_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.1, "rep_tan_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_tan_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.9, "cis_tan_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.1, "cis_tan_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_tan_amb_victory")
    SetDefeatMusic (REP, "rep_tan_amb_defeat")
    SetVictoryMusic(CIS, "cis_tan_amb_victory")
    SetDefeatMusic (CIS, "cis_tan_amb_defeat")

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
    AddCameraShot(0.233199, -0.019441, -0.968874, -0.080771, -240.755920, 11.457644, 105.944176);
    AddCameraShot(-0.395561, 0.079428, -0.897092, -0.180135, -264.022278, 6.745873, 122.715752);
    AddCameraShot(0.546703, -0.041547, -0.833891, -0.063371, -309.709900, 5.168304, 145.334381);

end


