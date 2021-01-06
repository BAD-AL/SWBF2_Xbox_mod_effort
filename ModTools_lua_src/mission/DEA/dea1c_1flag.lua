--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")
--  These variables do not change
ATT = 1
DEF = 2

--  Alliance Attacking (attacker is always #1)
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

function ScriptPostLoad()

    TrashStuff();
    --lock the hangar doors
    
    SetProperty("Dr-LeftMain", "IsLocked", 1)
    SetProperty("dea1_prop_door_blast0", "IsLocked", 1)
    
    SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )

    PlayAnimExtend();
    PlayAnimTakExtend();

    BlockPlanningGraphArcs("Connection41")    
    BlockPlanningGraphArcs("Connection115")
    BlockPlanningGraphArcs("compactor")
    OnObjectKillName(CompactorConnectionOn, "grate01")
    
    DisableBarriers("start_room_barrier")
    DisableBarriers("dr_left")
    DisableBarriers("circle_bar1")
    DisableBarriers("circle_bar2")

    OnObjectRespawnName(PlayAnimExtend, "Panel-Chasm");
    OnObjectKillName(PlayAnimRetract, "Panel-Chasm");

    OnObjectRespawnName(PlayAnimTakExtend, "Panel-Tak");
    OnObjectKillName(PlayAnimTakRetract, "Panel-Tak");

--  SetProperty("flag", "GeometryName", "com_icon_neutral_flag")
--    SetProperty("flag", "CarriedGeometryName", "com_icon_neutral_flag_carried")
    
    ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
           textATT = "game.modes.1flag", textDEF = "game.modes.1flag2",
           captureLimit = 5, flag = "flag", flagIcon = "flag_icon", 
           flagIconScale = 3.0, homeRegion = "Flag_Home",
           captureRegionATT = "Team2Cap", captureRegionDEF = "Team1Cap",
           capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
           capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, multiplayerRules = true, hideCPs = true}
           
    ctf:Start()
    EnableSPHeroRules()
 end

function CompactorConnectionOn()
    UnblockPlanningGraphArcs ("compactor")
end
--START BRIDGEWORK!

-- OPEN
function PlayAnimExtend()
      PauseAnimation("bridgeclose");    
      RewindAnimation("bridgeopen");
      PlayAnimation("bridgeopen");
        
    -- allow the AI to run across it
    UnblockPlanningGraphArcs("Connection122");
    DisableBarriers("BridgeBarrier");
    
end
-- CLOSE
function PlayAnimRetract()
      PauseAnimation("bridgeopen");
      RewindAnimation("bridgeclose");
      PlayAnimation("bridgeclose");
            
    -- prevent the AI from running across it
    BlockPlanningGraphArcs("Connection122");
    EnableBarriers("BridgeBarrier");
      
end

--START BRIDGEWORK TAK!!!

-- OPEN
function PlayAnimTakExtend()
      PauseAnimation("TakBridgeOpen");  
      RewindAnimation("TakBridgeClose");
      PlayAnimation("TakBridgeClose");
        
    -- allow the AI to run across it
    UnblockPlanningGraphArcs("Connection128");
    DisableBarriers("Barrier222");
    
end
-- CLOSE
function PlayAnimTakRetract()
      PauseAnimation("TakBridgeClose");
      RewindAnimation("TakBridgeOpen");
      PlayAnimation("TakBridgeOpen");
            
    -- prevent the AI from running across it
    BlockPlanningGraphArcs("Connection128");
    EnableBarriers("Barrier222");
      
end


function TrashStuff()

    trash_open = 1
    trash_closed = 0
    
    trash_timer = CreateTimer("trash_timer")
    SetTimerValue(trash_timer, 7)
    StartTimer(trash_timer)
    trash_death = OnTimerElapse(
        function(timer)
            if trash_open == 1 then
                AddDeathRegion("deathregion")
                SetTimerValue(trash_timer, 5)
                StartTimer(trash_timer)
                trash_closed = 1
                trash_open = 0
                print("death region added")
            
            elseif trash_closed == 1 then
                RemoveRegion("deathregion")
                SetTimerValue(trash_timer, 15)
                StartTimer(trash_timer)
                print("death region removed")
                trash_closed = 0
                trash_open = 1
            end
        end,
        trash_timer
        )
end



function ScriptInit()
    StealArtistHeap(550*1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(4200000)
    ReadDataFile("ingame.lvl")
  
    ReadDataFile("sound\\dea.lvl;dea1cw")

    
    SetMaxFlyHeight(72)
    SetMaxPlayerFlyHeight (72)
    AISnipeSuitabilityDist(30)

    ReadDataFile("SIDE\\rep.lvl",
                "rep_inf_ep3_rifleman",
                "rep_inf_ep3_rocketeer",
                "rep_inf_ep3_engineer",
                "rep_inf_ep3_sniper",
                "rep_inf_ep3_officer",
                "rep_inf_ep3_jettrooper",
                "rep_hero_obiwan")
                
    ReadDataFile("SIDE\\cis.lvl",
                "cis_inf_rifleman",
                "cis_inf_rocketeer",
                "cis_inf_engineer",
                "cis_inf_sniper",
                "cis_inf_droideka",
                "cis_inf_officer")
                
    ReadDataFile("SIDE\\imp.lvl",
                "imp_hero_emperor")

    SetAttackingTeam(ATT)

SetupTeams{
        rep = {
        team = REP,
        units = 32,
        reinforcements = -1,
        soldier  = { "rep_inf_ep3_rifleman", 7, 25},
        assault  = { "rep_inf_ep3_rocketeer",1, 4},
        engineer = { "rep_inf_ep3_engineer",1, 4},
        sniper   = { "rep_inf_ep3_sniper",1, 4},
        officer  = { "rep_inf_ep3_officer",1, 4},
        special  = { "rep_inf_ep3_jettrooper",1, 4},
            
        },
        cis = {
        team = CIS,
        units = 32,
        reinforcements = -1,
        soldier  = { "cis_inf_rifleman",7, 25},
        assault  = { "cis_inf_rocketeer",1, 4},
        engineer = { "cis_inf_engineer",1, 4},
        sniper   = { "cis_inf_sniper",1, 4},
        officer  = { "cis_inf_officer",1, 4},
        special  = { "cis_inf_droideka",1, 4},
        }
     }

        SetHeroClass(REP, "rep_hero_obiwan")
        SetHeroClass(CIS, "imp_hero_emperor")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 3) -- 3 droidekas (special case: 0 leg pairs)
    --    AddWalkerType(1, 0) -- 8 droidekas (special case: 0 leg pairs)
    --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
    --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponCnt = 180
    local guyCnt = 40
    SetMemoryPoolSize ("Aimer", 9)
    SetMemoryPoolSize ("AmmoCounter", weaponCnt)
    SetMemoryPoolSize ("EnergyBar", weaponCnt)
    SetMemoryPoolSize ("EntityLight", 170)
    SetMemoryPoolSize ("EntitySoundStatic", 30)
    SetMemoryPoolSize ("SoundSpaceRegion", 50)
    SetMemoryPoolSize ("FlagItem", 1)
    SetMemoryPoolSize ("MountedTurret", 3)
    SetMemoryPoolSize ("Navigator", guyCnt)
    SetMemoryPoolSize ("Obstacle", 275)
    SetMemoryPoolSize ("PathFollower", guyCnt)
    SetMemoryPoolSize ("UnitAgent", guyCnt)
    SetMemoryPoolSize ("UnitController", guyCnt)
    SetMemoryPoolSize ("Weapon", weaponCnt)
    SetMemoryPoolSize ("EntityFlyer", 6)
    --  Local Stats
    --SetTeamName (3, "locals")
    --AddUnitClass (3, "ewk_inf_trooper", 4)
    --AddUnitClass (3, "ewk_inf_repair", 6)
    --SetUnitCount (3, 14)
    --SetTeamAsFriend(3,ATT)
    --SetTeamAsEnemy(3,DEF)


    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dea\\dea1.lvl", "dea1_CTF-SingleFlag")
    SetDenseEnvironment("true")
    AddDeathRegion("DeathRegion01")
    AddDeathRegion("DeathRegion02")
    AddDeathRegion("DeathRegion03")
    AddDeathRegion("DeathRegion04")
    AddDeathRegion("DeathRegion05")
    --SetStayInTurrets(1)


    --  Movies
    --  SetVictoryMovie(ALL, "all_end_victory")
    --  SetDefeatMovie(ALL, "imp_end_victory")
    --  SetVictoryMovie(IMP, "imp_end_victory")
    --  SetDefeatMovie(IMP, "all_end_victory")

    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\dea.lvl",  "dea1")
    OpenAudioStream("sound\\dea.lvl",  "dea1")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    --OpenAudioStream("sound\\dea.lvl",  "dea1_emt")

    -- SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)


    -- SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "Cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_dea_amb_start",  0,1)
    SetAmbientMusic(REP, 0.9, "rep_dea_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.1,"rep_dea_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_dea_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.9, "cis_dea_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.1,"cis_dea_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_dea_amb_victory")
    SetDefeatMusic (REP, "rep_dea_amb_defeat")
    SetVictoryMusic(CIS, "cis_dea_amb_victory")
    SetDefeatMusic (CIS, "cis_dea_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --  SetSoundEffect("BirdScatter",         "birdsFlySeq1")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


    SetAttackingTeam(ATT)



    AddCameraShot(-0.404895, 0.000992, -0.514360, -0.002240, -121.539894, 62.536297, -257.699493)
    --Homestead
    AddCameraShot(0.040922, -0.004049, -0.994299, -0.098381, -103.729523, 55.546598, -225.360893)
    --Sarlac Pit
    AddCameraShot(-1.0, 0.0, -0.514360, 0.0, -55.381485, 50.450953, -96.514324)
end

