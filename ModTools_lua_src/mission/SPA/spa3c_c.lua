-- SPACE 3 Battle over Kashyyyk
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("Ambush")
ScriptCB_DoFile("PlayMovieWithTransition")
ScriptCB_DoFile("LinkedDestroyables")
ScriptCB_DoFile("LinkedTurrets")
ScriptCB_DoFile("LinkedShields")
---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------

    --  Republic Attacking (attacker is always #1)
    REP = 1
    CIS = 2
    --  These variables do not change
    ATT = 1
    DEF = 2
    
    hangar_ambush = 4
    Ambush_02 = 5
    
function ScriptPostLoad()
	SetAIDifficulty(2, -8, "medium")   
    SetupDestroyables()
    SetupTurrets()
    SetupShields()
--    DisableSmallMapMiniMap()
    SetClassProperty("com_item_holocron", "LifeSpan", 5.0)
    
    ScriptCB_SetGameRules("campaign")
    SetProperty("cap_box01", "IsVisible", 0)
    SetProperty("cap_box01", "IsCollidible ", 0)
    ActivateRegion("cp2control")
    ActivateRegion("nono")
    ScriptCB_PlayInGameMovie("ingame.mvs", "sb3mon01")
    SetMissionEndMovie("ingame.mvs", "sb3mon02")
    SetProperty("CP1", "SpawnPath", "SP_spawn")
    
    SetProperty("rep_eng_door", "IsLocked", 1)
    SetProperty("rep_shi_door", "IsLocked", 1)
    SetProperty("rep_lif_door", "IsLocked", 1)
    
    SetProperty("cis_eng_door", "IsLocked", 1)
    SetProperty("cis_shi_door", "IsLocked", 1)
    SetProperty("cis_lif_door", "IsLocked", 1)
---------------------------------------------------------       
    SetProperty("Target_cis01", "MaxHealth", 999999)
    SetProperty("Target_cis01", "CurHealth", 999999)
    
    SetProperty("Target_cis02", "MaxHealth", 999999)
    SetProperty("Target_cis02", "CurHealth", 999999)
---------------------------------------------------------  
    SetProperty("Engine2", "MaxHealth", 999999)
    SetProperty("Engine2", "CurHealth", 999999)
    
    SetProperty("Engine1", "MaxHealth", 999999)
    SetProperty("Engine1", "CurHealth", 999999)
---------------------------------------------------------  
    SetProperty("life_ext_cis", "MaxHealth", 999999)
    SetProperty("life_ext_cis", "CurHealth", 999999)
---------------------------------------------------------  

    SetProperty("Target_cis01", "MaxHealth", 999999)
    SetProperty("Target_cis01", "CurHealth", 999999)
    
    SetProperty("Target_cis02", "MaxHealth", 999999)
    SetProperty("Target_cis02", "CurHealth", 999999)
---------------------------------------------------------
    SetProperty("life_int_cis", "MaxHealth", 3500)
    SetProperty("life_int_cis", "CurHealth", 3500)
    
    SetProperty("engine_cis", "MaxHealth", 3000)
    SetProperty("engine_cis", "CurHealth", 3000)

    SetAIDamageThreshold("CIS_mini01", 0.7)
    SetAIDamageThreshold("CIS_mini02", 0.7)

    SetAIDamageThreshold("Target_cis01", 0.5)
    SetAIDamageThreshold("Target_cis02", 0.5)

    SetAIDamageThreshold("engine_cis", 0.8)
    SetAIDamageThreshold("life_int_cis", 0.8)
    
    SetProperty("REP04", "Team", 0)
    SetProperty("REP04", "DisableTime", 1e+37)
    
    OnObjectKillName(CISM1_turr, "CIS_mini01");
    OnObjectKillName(CISM2_turr, "CIS_mini02");
    
    SetProperty( "rep_eng_lightg", "IsVisible", 0)
    SetProperty( "rep_shi_lightg", "IsVisible", 0)
    SetProperty( "rep_lif_lightg", "IsVisible", 0)
    
    SetProperty( "cis_eng_lightg", "IsVisible", 0)
    SetProperty( "cis_shi_lightg", "IsVisible", 0)
    SetProperty( "cis_lif_lightg", "IsVisible", 0)

--- SetProperty( "rep_eng_lightr", "IsVisible", 0)
--  SetProperty( "rep_shi_lightr", "IsVisible", 0)
--  SetProperty( "rep_lif_lightr", "IsVisible", 0)
    
    SetProperty( "cis_eng_lightr", "IsVisible", 1)
    SetProperty( "cis_shi_lightr", "IsVisible", 1)
    SetProperty( "cis_lif_lightr", "IsVisible", 1)
    

    -- Block paths and barriers off
    
    -- cis side is open
    --BlockPlanningGraphArcs("cis_blk01","cis_blk02")
    DisableBarriers("cis_blk01")
    DisableBarriers("cis_blk02")
    
    -- rep side is closed
    --DisableBarriers("rep_blk01")
    --DisableBarriers("rep_blk02")
    BlockPlanningGraphArcs("rep_blk01","rep_blk02")
    
    
local NO
    NO = OnEnterRegion(
        function(region, character) 
            if character == 0 then 
                ShowPopup("level.spa3.objectives.popup.nono")
            end
        end,
        "nono"
        )
        

local Support2
    Support2 = OnEnterRegion(
        function(region, character) 
            if IsCharacterHuman(character) then 
                Hinttimer() 
                SetProperty("REP04", "DisableTime", 0)
                landboxes()
                ReleaseEnterRegion(Support2)
            end
        end,
        "transportinfo"
        )
        
        
--    cis01frigate = { "mini01-1", "mini01-2", "mini01-2", "mini01-2", "CIS_mini01"}
--    cis02frigate = { "mini02-1", "mini02-2", "mini02-2", "mini02-2", "CIS_mini02"}
    
--  OnObjectKillMatch (function(object, killer) for i, turret in pairs(cis01frigate) do KillObject(turret) end end, "frig_crit")
--  OnObjectKillMatch (function(object, killer) for i, turret in pairs(cis02frigate) do KillObject(turret) end end, "frig_crit02")   
    
  OnObjectKillName(PlayAnimCIS_mini01List, "CIS_mini01");
  OnObjectKillName(PlayAnimCIS_mini02List, "CIS_mini02");
    
       --Objective1:Start()
    onfirstspawn = OnCharacterSpawn(
        function(character)
            if IsCharacterHuman(character) then
                ReleaseCharacterSpawn(onfirstspawn)
                onfirstspawn = nil
                BeginObjectivesTimer()
     ScriptCB_PlayInGameMusic("rep_spa3_amb_obj1_explore")   
        SetProperty("REP04", "Team", 1)
            end
        end)
    
    --setup objective 1 - Assault the frigates
    --
    
    frig01 = Target:New{name = "CIS_mini01"}
    frig02 = Target:New{name = "CIS_mini02"}

    Objective1 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
                                            text = "level.spa3.objectives.campaign.1", popupText = "level.spa3.objectives.long.1"}
    Objective1:AddTarget(frig01)
    Objective1:AddTarget(frig02)

    Objective1.OnSingleTargetDestroyed = function(self, target)
        local numTargets = self:GetNumSingleTargets()
        if numTargets > 0 then
            ShowMessageText("level.spa3.objectives.campaign.1-" .. numTargets, 1)
            ScriptCB_SndPlaySound("SPA2_obj_19")
        end
    end

    Objective1.OnStart = function(self)
        SetProperty("CP1", "SpawnPath", "CP1Spawn")
        ScriptCB_SndPlaySound("SPA3_obj_11")
        ScriptCB_SndPlaySound("SPA3_obj_13")
--        BeginScreenTransition(0, .8, .5, .5, "FADE", "FADE")
    end

    Objective1.OnComplete = function(self)
        ATTReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATTReinforcementCount + 15)    
        ShowMessageText("level.spa2.objectives.campaign.c", ATT)
        ScriptCB_PlayInGameMusic("rep_spa3_objComplete_01")   
      
      -- Music Timer -- 
          music01Timer = CreateTimer("music01")
          SetTimerValue(music01Timer, 17.0)
                      
    StartTimer(music01Timer)
    OnTimerElapse(
        function(timer)
        ScriptCB_StopInGameMusic("rep_spa3_objComplete_01")
        ScriptCB_PlayInGameMusic("rep_spa3_amb_obj2_3_explore")
        DestroyTimer(timer)
    end,
    music01Timer
        )    
    end
    
    
    
    
    --setup objective 2 - Destroy the Ship-to-ship guns
    --
    
    Engine01 = Target:New{name = "Target_cis01"}
    Engine02 = Target:New{name = "Target_cis02"}

    Objective2 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
                                            text = "level.spa3.objectives.campaign.2", popupText = "level.spa3.objectives.long.2"}
    Objective2:AddTarget(Engine01)
    Objective2:AddTarget(Engine02)

    Objective2.OnSingleTargetDestroyed = function(self, target)
        local numTargets = self:GetNumSingleTargets()
        if numTargets > 0 then
            ShowMessageText("level.spa3.objectives.campaign.2-" .. numTargets, 1)
	        ScriptCB_SndPlaySound("SPA2_obj_19")
        end
    end

    Objective2.OnStart = function(self)
    ScriptCB_SndPlaySound("SPA3_obj_18")
--    BeginScreenTransition(0, .8, .5, .5, "FADE", "FADE")
	SetProperty("Target_cis01", "MaxHealth", 15000)
	SetProperty("Target_cis01", "CurHealth", 15000)
	SetProperty("Target_cis02", "MaxHealth", 15000)
	SetProperty("Target_cis02", "CurHealth", 15000)
    end

    Objective2.OnComplete = function(self)
        ScriptCB_SndPlaySound("SPA3_obj_19")    
        ATTReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATTReinforcementCount + 15)            
        ShowMessageText("level.spa2.objectives.campaign.c", ATT)
    end
    
    --setup objective 3 - Land in yonder hangar
    --
    Objective3 = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                            text = "level.spa3.objectives.campaign.3", popupText = "level.spa3.objectives.long.3"}
    Objective3.OnStart = function(self)
        shuttle_entered_hangar = OnEnterRegionName(
            function(region, character)
                --if IsCharacterHuman(character) and not GetCharacterVehicle(character) then
                    ReleaseEnterRegion(shuttle_entered_hangar)
                    player_entered_hangar = OnEnterRegion(
                    function(region, character)
                        if IsCharacterHuman(character) then
                            Objective3:Complete(ATT)
                            ReleaseEnterRegion(player_entered_hangar)
                        end
                    end
                    ,
                    "cp2control"
                    )
                --end
            end,
            "cp2control",
            "REP04"
            )
        ActivateRegion("transportinfo")
        MapAddEntityMarker("REP04", "hud_objective_icon", 2.0, 1, "YELLOW", true)
        ReleaseEnterRegion(NO)
        SetProperty("REP04", "Team", 1)
        SetProperty("CP2", "SpawnPath", "CP2backSpawn")
        
      Objective3.CAMGoal1 = AddAIGoal(ATT, "Defend", 100, "REP04")
--        Objective3.CAMGoal1 = AddAIGoal(ATT, "DeathMatch", 100)
        Objective3.CAMGoal2 = AddAIGoal(DEF, "Destroy", 100, "REP04")

    end
     
     Objective3.OnComplete = function(self)
        ATTReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATTReinforcementCount + 10)    
        MapRemoveEntityMarker("land_box01")
        Ambush("CP2backSpawn", 5, 4)
        Objective1.CP2Goal1 = AddAIGoal(4, "Defend", 99999, "plans")
        Ambush("CP2backSpawn", 5, 5)
        Objective1.CP2Goal1 = AddAIGoal(5, "Defend", 99999, "plans")
        ScriptCB_PlayInGameMusic("rep_spa3_amb_obj4_explore")   
        ShowMessageText("level.spa2.objectives.campaign.c", ATT)
        ScriptCB_SndPlaySound("SPA3_obj_21")
        ---------------------------------------------------------
        SetProperty("Engine2", "MaxHealth", 30000)
        SetProperty("Engine2", "CurHealth", 30000)
        
        SetProperty("Engine1", "MaxHealth", 30000)
        SetProperty("Engine1", "CurHealth", 30000)
        ---------------------------------------------------------
        SetProperty("life_ext_cis", "MaxHealth", 64000)
        SetProperty("life_ext_cis", "CurHealth", 64000)
        ---------------------------------------------------------
        DeleteAIGoal(Objective3.CAMGoal1)
        DeleteAIGoal(Objective3.CAMGoal2)
        
        SetProperty( "cis_eng_lightg", "IsVisible", 1)
        SetProperty( "cis_lif_lightg", "IsVisible", 1)
        
        SetProperty( "cis_eng_lightr", "IsVisible", 0)
        SetProperty( "cis_lif_lightr", "IsVisible", 0)
        
        SetProperty("cis_eng_door", "IsLocked", 0)
        SetProperty("cis_lif_door", "IsLocked", 0)
    end
    
  ----
    --Objective 4 - Destroy the internal CRIT systems
    ----
    Fourthobj_onekilled = 0
    Engine = Target:New{name = "engine_cis"}
    Life_support = Target:New{name = "life_int_cis"}
    
    Objective4 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
                              text = "level.spa3.objectives.campaign.4", popupText = "level.spa3.objectives.long.4"}
    Objective4:AddTarget(Engine)
    Objective4:AddTarget(Life_support)

    Objective4.OnStart = function(self)
        Engine_killed = OnObjectKillName( 
            function(object, killer) 
                if killer and IsCharacterHuman(killer) then
                    if Fourthobj_onekilled == 0 then
                Fourthobj_onekilled = 1
                ShowMessageText("level.spa.hangar.engines.atk.down", 1)
                ReleaseObjectKill(Engine_killed)
                ReleaseObjectKill(Life_support_killed)
                    end
                end 
            end,
            "engine_cis" 
        )

        Life_support_killed = OnObjectKillName( 
            function(object, killer) 
                if killer and IsCharacterHuman(killer) then
                    if Fourthobj_onekilled == 0 then
                Fourthobj_onekilled = 1
                ShowMessageText("level.spa.hangar.lifesupport.atk.down", 1)
                ReleaseObjectKill(Engine_killed)
                ReleaseObjectKill(Life_support_killed)
                    end
                end 
            end,
            "life_int_cis" 
        )
--        BeginScreenTransition(0, .8, .5, .5, "FADE", "FADE")       
    SetProperty("REP04", "DisableTime", 60)
    end
    
    Objective4.OnComplete = function(self)
        ATTReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATTReinforcementCount + 15)    
        ShowMessageText("level.spa2.objectives.campaign.c", 1)
        SetProperty("cis_shi_door", "IsLocked", 0)
        SetProperty( "cis_shi_lightg", "IsVisible", 1)
        SetProperty( "cis_shi_lightr", "IsVisible", 0)
    end
    
    -- Objective 5 Cap the Holocron
    Objective5 = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 1, 
                                        text = "level.spa3.objectives.campaign.5", popupText = "level.spa3.objectives.long.5"}
    Objective5:AddFlag{name = "plans", homeRegion = "planhome", captureRegion = "plancap",
                capRegionMarker = "rep_icon", capRegionMarkerScale = 1.5,
            icon = "", mapIcon = "flag_icon", mapIconScale = 1.5}
      
    Objective5.OnStart = function(self)
    SetProperty("plans", "AllowAIPickUp", 0)
    SetProperty("CP2", "SpawnPath", "CP2Spawn")
    Ambush("Hangar_Ambush", 5, 4)
    ScriptCB_SndPlaySound("SPA3_obj_22")
    ScriptCB_PlayInGameMusic("rep_spa3_ImminentVict_01")
    MapAddEntityMarker("cap_box01", "hud_objective_icon", 2.0, 1, "YELLOW", true)
--        BeginScreenTransition(0, .8, .5, .5, "FADE", "FADE")
    end
        
    Objective5.OnComplete = function(self)
    ShowMessageText("level.spa2.objectives.campaign.c", ATT)
    ScriptCB_SndPlaySound("SPA3_obj_09")
    MapRemoveEntityMarker("cap_box01")
    end
    
    function BeginObjectives()
    --This creates the objective "container" and specifies order of objectives, and gets that running           
        objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 5.5}
        objectiveSequence:AddObjectiveSet(Objective1)
        objectiveSequence:AddObjectiveSet(Objective2)
        objectiveSequence:AddObjectiveSet(Objective3)
        objectiveSequence:AddObjectiveSet(Objective4)
        objectiveSequence:AddObjectiveSet(Objective5)
        objectiveSequence:Start()    
    end

end
    
    
    function Hinttimer()
        hint3timer = CreateTimer("hint3timer")
        hint3a = OnTimerElapse(PlayHint3a, hint3timer)
        SetTimerValue(hint3timer, .5)
        StartTimer(hint3timer)
        ScriptCB_SndPlaySound("SPA3_obj_20")
    end
        
    function BeginObjectivesTimer()
        beginobjectivestimer = CreateTimer("beginobjectivestimer")
        OnTimerElapse(BeginObjectives, beginobjectivestimer)
        SetTimerValue(beginobjectivestimer, 3)
        StartTimer(beginobjectivestimer)
    end
    
    function landboxes()
        MapRemoveEntityMarker("REP04")
        MapAddEntityMarker("land_box01", "hud_objective_icon", 2.0, 1, "YELLOW", true)
    end

    function PlayHint3a()
        ReleaseTimerElapse(hint3a)
        ShowPopup("level.spa3.objectives.popup.3a")
        SetTimerValue(hint3timer, .0000001)
        StartTimer(hint3timer)
        hint3b = OnTimerElapse(PlayHint3b, hint3timer)
    end
    
    function PlayHint3b()
        ShowPopup("level.spa3.objectives.popup.3b")
        DestroyTimer(hint3timer)
    end

function SetupTurrets() 
    --CIS turrets
    LinkedTurretsCIS = LinkedTurrets:New{ team = CIS, mainframe = "cis_main", 
                                          turrets = {"cis_bldg_boxturret","cis_bldg_boxturret1", "cis_bldg_boxturret2", "cis_bldg_boxturret5", "cis_at01",
                                          			 "cis_at02", "cis_at03", "cis_at04", "cis_at05", "cis_at06"} }
    LinkedTurretsCIS:Init()
    function LinkedTurretsCIS:OnDisableMainframe()
        ShowMessageText("level.spa.hangar.mainframe.atk.down", REP)
        ShowMessageText("level.spa.hangar.mainframe.def.down", CIS)
    end
    function LinkedTurretsCIS:OnEnableMainframe()
        ShowMessageText("level.spa.hangar.mainframe.atk.up", REP)
        ShowMessageText("level.spa.hangar.mainframe.def.up", CIS)
    end
end

function SetupShields()
    -- REP Shielded objects    
    linkedShieldObjectsREP = { "sensors_rep", "life_ext_rep", "comms_rep", "rep_cap_assultship0", "rep_cap_assultship2", "rep_cap_assultship3",
    							"rep_cap_assultship4", "bridge_rep", "Engine3" }
    shieldStuffREP = LinkedShields:New{objs = linkedShieldObjectsREP, maxShield = 200000, addShield = 1000, controllerObject = "com_item_healthrecharge2"}    
    shieldStuffREP:Init()
   
end

function ScriptPreInit()
    SetWorldExtents(1900)
end

function SetupDestroyables()
    --CIS destroyables
    engineLinkageCIS = LinkedDestroyables:New{ objectSets = {{"Engine1", "Engine2"}, {"engine_cis"}} }
    engineLinkageCIS:Init()
    
    lifeSupportLinkageCIS = LinkedDestroyables:New{ objectSets = {{"life_int_cis"}, {"life_ext_cis"}} }
    lifeSupportLinkageCIS:Init()
end

-- Frigates Listing


function CISM1_turr()
	KillObject("mini01-1");
	KillObject("mini01-2");
	KillObject("mini01-3");
	KillObject("mini01-4");
	DeleteEntity("mini01-1");
	DeleteEntity("mini01-2");
	DeleteEntity("mini01-3");
	DeleteEntity("mini01-4");
end

function CISM2_turr()
    KillObject("mini02-1");
    KillObject("mini02-2");
    KillObject("mini02-3");
    KillObject("mini02-4");
	DeleteEntity("mini02-1");
	DeleteEntity("mini02-2");
	DeleteEntity("mini02-3");
	DeleteEntity("mini02-4");

end

function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(5000000)
    ReadDataFile("ingame.lvl")
    ReadDataFile("SPA\\spa_sky.lvl", "kas")        

     SetMinFlyHeight(-1900)
     SetMaxFlyHeight(2000)
     SetMinPlayerFlyHeight(-1900)
     SetMaxPlayerFlyHeight(2000)
     SetAIVehicleNotifyRadius(100)
    
    ReadDataFile("sound\\spa.lvl;spa2cw")
     ScriptCB_SetDopplerFactor(0.4)
     ScaleSoundParameter("tur_weapons",   "MinDistance",   3.0);
     ScaleSoundParameter("tur_weapons",   "MaxDistance",   3.0);
     ScaleSoundParameter("tur_weapons",   "MuteDistance",   3.0);
     ScaleSoundParameter("Ordnance_Large",   "MinDistance",   3.0);
     ScaleSoundParameter("Ordnance_Large",   "MaxDistance",   3.0);
     ScaleSoundParameter("Ordnance_Large",   "MuteDistance",   3.0);
     ScaleSoundParameter("explosion",   "MaxDistance",   5.0);
     ScaleSoundParameter("explosion",   "MuteDistance",  5.0);
     
    ReadDataFile("SIDE\\rep.lvl",   
        "rep_inf_ep3_marine",
        "rep_inf_ep3_pilot",
        "rep_fly_assault_dome",
        "rep_fly_anakinstarfighter_sc",
        "rep_fly_arc170fighter_sc",        
        "rep_fly_gunship_sc",        
        "rep_fly_arc170fighter_dome",
        "rep_fly_vwing")
    
    ReadDataFile("SIDE\\cis.lvl",
        "cis_inf_pilot",
        "cis_inf_marine",
        "cis_fly_fedlander_dome",
        "cis_fly_droidfighter_sc",  
        "cis_fly_droidfighter_dome",
        "cis_fly_greviousfighter",
--        "cis_fly_droidgunship",
        "cis_fly_tridroidfighter")
    
    ReadDataFile("SIDE\\tur.lvl",
        "tur_bldg_spa_rep_beam",
        "tur_bldg_spa_rep_chaingun",
        "tur_bldg_spa_cis_chaingun",
        "tur_bldg_spa_cis_recoilless",
        "tur_bldg_chaingun_roof")

ScriptCB_SetSpawnDisplayGain(0.2, 0.5)        

SetupTeams{

         rep = {
            team = REP,
            units = 10,
            reinforcements = 30,
            pilot    = { "rep_inf_ep3_pilot",6},
            marine   = { "rep_inf_ep3_marine",4},
        },
           cis = {
            team = CIS,
            units = 16,
            reinforcements = -1,
            pilot    = { "cis_inf_pilot",2},
            marine   = { "cis_inf_marine",14},
        }
     }
     
     
        --additional hangar_ambush teams
    SetTeamName(hangar_ambush, "cis")
    SetUnitCount(hangar_ambush, 5)
    AddUnitClass(hangar_ambush, "cis_inf_pilot", 2)
    AddUnitClass(hangar_ambush, "cis_inf_marine", 3)
    SetReinforcementCount(hangar_ambush, -1)
         
         
    SetTeamAsEnemy(hangar_ambush, REP)
    SetTeamAsFriend(hangar_ambush, CIS)
    SetTeamAsFriend(CIS, hangar_ambush)
    
    SetTeamName(Ambush_02, "cis")
    SetUnitCount(Ambush_02, 5)
    AddUnitClass(Ambush_02, "cis_inf_marine", 5)
    SetReinforcementCount(Ambush_02, -1)
                 
    SetTeamAsEnemy(Ambush_02, REP)
    SetTeamAsFriend(Ambush_02, CIS)
    SetTeamAsFriend(CIS, Ambush_02)
    
    --  Level Stats
    ClearWalkers()
    local numGuys = 56
    local numWeapons = 210
    SetMemoryPoolSize ("Aimer", 185)
    SetMemoryPoolSize ("AmmoCounter", numWeapons)
    SetMemoryPoolSize ("BaseHint",55)
    SetMemoryPoolSize ("CommandFlyer",2)
    SetMemoryPoolSize ("EnergyBar", numWeapons)
    SetMemoryPoolSize ("EntityDroid",0)
    SetMemoryPoolSize ("EntityFlyer", 32)
    SetMemoryPoolSize ("EntityRemoteTerminal",12)
    SetMemoryPoolSize ("FlagItem", 1)
    SetMemoryPoolSize ("MountedTurret", 50)
    SetMemoryPoolSize ("Navigator", numGuys)
    SetMemoryPoolSize ("Obstacle",116)
    SetMemoryPoolSize ("PathFollower", numGuys)
    SetMemoryPoolSize ("PathNode",90)
    SetMemoryPoolSize ("TreeGridStack",173)
    SetMemoryPoolSize ("UnitAgent",numGuys)
    SetMemoryPoolSize ("UnitController", numGuys)
    SetMemoryPoolSize ("Weapon", numWeapons)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("spa\\spa3.lvl", "spa3_campaign")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregionrep")
    AddDeathRegion("deathregioncis")


    SetParticleLODBias(15000)


    --  Sound Stats    

    voiceSlow = OpenAudioStream("sound\\global.lvl", "spa1_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)     
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "cis_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_quick", voiceQuick) 
    
       OpenAudioStream("sound\\global.lvl",  "cw_music")
       OpenAudioStream("sound\\spa.lvl",  "spa")
       OpenAudioStream("sound\\spa.lvl",  "spa")
       -- OpenAudioStream("sound\\spa.lvl",  "spa1_objective_vo_slow")
       -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
       -- OpenAudioStream("sound\\tat.lvl",  "tat1_emt")
   
       SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
       SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
       SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
       SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)
   
       SetOutOfBoundsVoiceOver(1, "Repleaving")
       SetOutOfBoundsVoiceOver(2, "Cisleaving")
   
       --SetAmbientMusic(REP, 1.0, "rep_spa_amb_start",  0,1)
       --SetAmbientMusic(REP, 0.99, "rep_spa_amb_middle", 1,1)
       --SetAmbientMusic(REP, 0.1,"rep_spa_amb_end",    2,1)
       --SetAmbientMusic(CIS, 1.0, "cis_spa_amb_start",  0,1)
       --SetAmbientMusic(CIS, 0.99, "cis_spa_amb_middle", 1,1)
       --SetAmbientMusic(CIS, 0.1,"cis_spa_amb_end",    2,1)
   
       SetVictoryMusic(REP, "rep_spa_amb_victory")
       SetDefeatMusic (REP, "rep_spa_amb_defeat")
       SetVictoryMusic(CIS, "cis_spa_amb_victory")
       SetDefeatMusic (CIS, "cis_spa_amb_defeat")
   
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
    --Space Combat: Battle Over Kashyyyk
	AddCameraShot(0.961253, -0.041344, -0.272296, -0.011712, 846.781738, 42.129261, 1632.990479);
	AddCameraShot(0.950207, 0.025974, 0.310420, -0.008485, 919.840332, 42.129261, 1735.540771);
	AddCameraShot(0.948213, -0.126931, -0.288596, -0.038632, -753.106201, 743.622070, 2686.222900);
	AddCameraShot(-0.325839, 0.049463, -0.933437, -0.141696, 2249.083496, 743.622070, -1105.532593);
     AddLandingRegion("CP1Control")
     AddLandingRegion("CP2Control")


    if (gPlatformStr == "PS2") then
        ScriptCB_DisableFlyerShadows()
    end     

end



    
