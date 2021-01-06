-- SPACE 1 Battle over Yavin
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("LinkedShields")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("PlayMovieWithTransition")
--ScriptCB_DoFile("ObjectiveHangar")

--  Empire Attacking (attacker is always #1)
IMP = 1
ALL = 2
--  These variables do not change
ATT = 1
DEF = 2

    function ScriptPostLoad()
--    DisableSmallMapMiniMap()
    SetAIDifficulty(1, -2, "medium")   
    ScriptCB_SetGameRules("campaign")
    ScriptCB_PlayInGameMovie("ingame.mvs", "sb1mon01")
    SetMissionEndMovie("ingame.mvs", "sb1mon02")
    EnableLockOn({"mini01", "mini02", "mini03", "mini04", "mini05"}, true)
    DisableBarriers("impblock")
    BlockPlanningGraphArcs (1)
    SetProperty("CP2", "SpawnPath", "CAM_CP2Spawn")
    SetProperty("CP1", "SpawnPath", "CAM_CP1Spawn")
    
    SetProperty("ALL_Door02", "IsLocked", 1)
    SetProperty("ALL_Door01", "IsLocked", 1)

    SetProperty("mini01", "MaxHealth", 25000)
    SetProperty("mini02", "MaxHealth", 25000)
    SetProperty("mini03", "MaxHealth", 25000)
    SetProperty("mini04", "MaxHealth", 25000)
    SetProperty("mini05", "MaxHealth", 25000)
    
    SetProperty("mini01", "CurHealth", 25000)
    SetProperty("mini02", "CurHealth", 25000)
    SetProperty("mini03", "CurHealth", 25000)
    SetProperty("mini04", "CurHealth", 25000)
    SetProperty("mini05", "CurHealth", 25000)
    
    SetProperty("cor01", "MaxHealth", 25000)
    SetProperty("cor01", "CurHealth", 25000)
    SetProperty("cor02", "MaxHealth", 25000)
    SetProperty("cor02", "CurHealth", 25000)
    
    SetAIDamageThreshold("cor01", 0.7)
    SetAIDamageThreshold("cor02", 0.7)
    
    SetAIDamageThreshold("mini01", 0.3)
    SetAIDamageThreshold("mini02", 0.3)
    SetAIDamageThreshold("mini03", 0.3)
    SetAIDamageThreshold("mini04", 0.3)
    SetAIDamageThreshold("mini05", 0.3)

    SetAIDamageThreshold("All_Tur01", 0.7)
    SetAIDamageThreshold("All_Tur02", 0.7)
    SetAIDamageThreshold("All_Tur03", 0.7)
    SetAIDamageThreshold("All_Tur04", 0.7)  

    SetProperty("All_Tur01", "MaxHealth", 999999)
    SetProperty("All_Tur02", "MaxHealth", 999999)
    SetProperty("All_Tur03", "MaxHealth", 999999)
    SetProperty("All_Tur04", "MaxHealth", 999999)   

    SetProperty("All_Tur01", "CurHealth", 999999)
    SetProperty("All_Tur02", "CurHealth", 999999)
    SetProperty("All_Tur03", "CurHealth", 999999)
    SetProperty("All_Tur04", "CurHealth", 999999)


        --Engine 1
    SetProperty("Engine_a01", "MaxHealth", 999999)
    SetProperty("Engine_a01", "CurHealth", 999999)
        --Engine 2
    SetProperty("Engine_a02", "MaxHealth", 999999)
    SetProperty("Engine_a02", "CurHealth", 999999)
        --Engine 3
    SetProperty("Engine_a03", "MaxHealth", 999999)
    SetProperty("Engine_a03", "CurHealth", 999999)
        --Engine 4
    SetProperty("Engine_a04", "MaxHealth", 999999)
    SetProperty("Engine_a04", "CurHealth", 999999)
        --Engine 5
    SetProperty("Engine_a05", "MaxHealth", 999999)
    SetProperty("Engine_a05", "CurHealth", 999999)
        --Engine 6
    SetProperty("Engine_a06", "MaxHealth", 999999)
    SetProperty("Engine_a06", "CurHealth", 999999)

    IMPFRIG01 = OnObjectKillName(Imp01evac, "IMP_mini01");
    IMPFRIG02 = OnObjectKillName(Imp02evac, "IMP_mini02");
    
            -- Lock doors
    
    SetProperty("ALL_Door3", "IsLocked", 1)
    SetProperty("ALL_Door4", "IsLocked", 1)
    SetProperty("ALL_Door5", "IsLocked", 1)
    
    SetProperty("Impdoor01", "IsLocked", 1)
    SetProperty("Impdoor02", "IsLocked", 1)
    SetProperty("Impdoor03", "IsLocked", 1)
    
        -- Show lights
    
    SetProperty( "imp_eng_lightg", "IsVisible", 0)
    SetProperty( "imp_shi_lightg", "IsVisible", 0)
    SetProperty( "imp_lif_lightg", "IsVisible", 0)
    
    SetProperty( "all_eng_lightg", "IsVisible", 0)
    SetProperty( "all_shi_lightg", "IsVisible", 0)
    SetProperty( "all_lif_lightg", "IsVisible", 0)  
    
    -- Timer to Beat -- 
timeoutTimer = CreateTimer("timeout")
    SetTimerValue(timeoutTimer, 600)
    
    OnTimerElapse(
        function(timer)
            MissionVictory(DEF)
            ScriptCB_SndPlaySound("SPA1_obj_60")
            ShowTimer(nil)
            DestroyTimer(timer)
        end,
        timeoutTimer
        )
       
    --Objective1:Start()
    onfirstspawn = OnCharacterSpawn(
        function(character)
        ScriptCB_PlayInGameMusic("imp_spa1_amb_obj1_explore")        
            if IsCharacterHuman(character) then
                ReleaseCharacterSpawn(onfirstspawn)
                onfirstspawn = nil
                BeginObjectivesTimer()
            end
        end)
    
    ----
    --Objective 1 - Assault
    ----
    
     --setup objective 1 - Destroy the 5 transports
        
    trans01 = Target:New{name = "mini01"}
    trans02 = Target:New{name = "mini02"}
    trans03 = Target:New{name = "mini03"}
    trans04 = Target:New{name = "mini04"}
    trans05 = Target:New{name = "mini05"}
    

    Objective1 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
                                                text = "level.spa1.objectives.campaign.1",
                                                popupText = "level.spa1.objectives.long.1",
                                                timeLimit = 180, timeLimitWinningTeam = DEF,
                                                AIGoalWeight = 0}
    Objective1:AddTarget(trans01)
    Objective1:AddTarget(trans02)
    Objective1:AddTarget(trans03)
    Objective1:AddTarget(trans04)
    Objective1:AddTarget(trans05)
    
    Objective1.OnStart = function(self)
        obj1GoalATT = AddAIGoal(ATT, "Deathmatch", 100)
        obj1GoalDEF = AddAIGoal(DEF, "Deathmatch", 100)
        ScriptCB_EnableCommandPostVO(0)
        ScriptCB_SndPlaySound("SPA1_obj_52")

        PlayAnimationFromTo("gate01", 0, 179);
        PlayAnimationFromTo("gate02", 0, 179);
        
        PlayAnimation("port01")
        PlayAnimation("port02")
        PlayAnimation("port03")
        PlayAnimation("port04")
        PlayAnimation("port05")
        
        Hinttimer()


    end
    
    Objective1.OnComplete = function(self, winningTeam)
        if winningTeam == ATT then
            ShowMessageText("level.spa2.objectives.campaign.c", 1)
            ATTReinforcementCount = GetReinforcementCount(ATT)
            SetReinforcementCount(ATT, ATTReinforcementCount + 10)    
        end
        
        if winningTeam == DEF then
        ScriptCB_SndPlaySound("SPA1_obj_59")
        end
    end

    Objective1.OnSingleTargetDestroyed = function(self, target)
        local numTargets = self:GetNumSingleTargets()
        if numTargets > 0 then
            ShowMessageText("level.spa5.objectives.campaign.1-" .. numTargets, 1)
--          ScriptCB_SndPlaySound("SPA2_obj_19")
        end
    end
    
    --setup objective 2 - Destroy the 2 Frigates
        
    Frig01 = Target:New{name = "cor01"}
    Frig02 = Target:New{name = "cor02"}

    Objective2 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF,
                                                text = "level.spa1.objectives.campaign.2", popupText = "level.spa1.objectives.long.2", AIGoalWeight=0}
    Objective2:AddTarget(Frig01)
    Objective2:AddTarget(Frig02)
    
    Objective2.OnStart = function(self)
    
        EnableLockOn({"cor01", "cor02"}, true)
        
        ScriptCB_SndPlaySound("SPA1_obj_53")  
        ScriptCB_PlayInGameMusic("imp_spa1_objComplete_01")
    
-- Music Timer -- 
        music01Timer = CreateTimer("music01")
        SetTimerValue(music01Timer, 20.0)
                      
    StartTimer(music01Timer)
    OnTimerElapse(
        function(timer)
        ScriptCB_StopInGameMusic("imp_spa1_objComplete_01")
        ScriptCB_PlayInGameMusic("imp_spa1_amb_obj2_3_explore")
        DestroyTimer(timer)
    end,
    music01Timer
        )         
        FrigDeath01 = OnObjectKillName(FriglistA, "cor01");
        FrigDeath02 = OnObjectKillName(FriglistB, "cor02");
    end
    
    Objective2.OnComplete = function(self)
        ATTReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATTReinforcementCount + 15)    
        ShowMessageText("level.spa2.objectives.campaign.c", 1)
        ScriptCB_SndPlaySound("SPA1_obj_55")
    end
    
    Objective2.OnSingleTargetDestroyed = function(self, target)
        local numTargets = self:GetNumSingleTargets()
        if numTargets > 0 then
            ShowMessageText("level.spa5.objectives.campaign.2-" .. numTargets, 1)
--          ScriptCB_SndPlaySound("SPA2_obj_19")
        end
    end
    
    --Objective 2 Start.  Kill 15 fighters
    ship_count = 10 
    objective3Ships = {"all_fly_xwing_sc", "all_fly_awing", "all_fly_ywing_sc"}
    Objective3 = Objective:New{teamATT = ATT, teamDEF = DEF,
                                                text = "level.spa1.objectives.campaign.3", popupText = "level.spa1.objectives.long.3"}
    Objective3.OnStart = function(self)
        StartTimer(timeoutTimer)
        ShowTimer(timeoutTimer)
        ReleaseObjectKill(FrigDeath01)
        ReleaseObjectKill(FrigDeath02)
        ScriptCB_SndPlaySound("SPA1_obj_61")
        ScriptCB_SndPlaySound("SPA1_obj_62")
        
--      BeginScreenTransition(0, .8, .5, .5, "FADE", "FADE")    
        Objective3ShipKillStart(objective3Ships)    
    end
    
    Objective3.OnComplete = function(self)
        ATTReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATTReinforcementCount + 20)    
        ShowMessageText("level.spa2.objectives.campaign.c", 1)
        ScriptCB_PlayInGameMusic("mp_spa1_objComplete_02")
        ScriptCB_SndPlaySound("SPA1_obj_63")
         -- Music Timer -- 
         music02Timer = CreateTimer("music02")
        SetTimerValue(music02Timer, 37.0)
                              
            StartTimer(music02Timer)
            OnTimerElapse(
                function(timer)
                ScriptCB_StopInGameMusic("mp_spa1_objComplete_02")
                ScriptCB_PlayInGameMusic("imp_spa1_immVict_01")
                DestroyTimer(timer)
            end,
            music02Timer
        ) 
    end
    --setup objective 4 - Destroy the 4 Deck guns
        
    gun01 = Target:New{name = "All_Tur01"}
    gun02 = Target:New{name = "All_Tur02"}
    gun03 = Target:New{name = "All_Tur03"}
    gun04 = Target:New{name = "All_Tur04"}
    
    Objective4 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF,
                                                text = "level.spa1.objectives.campaign.4", popupText = "level.spa1.objectives.long.4", AIGoalWeight=0}
    Objective4:AddTarget(gun01)
    Objective4:AddTarget(gun02)
    Objective4:AddTarget(gun03)
    Objective4:AddTarget(gun04)
    
    Objective4.OnStart = function(self)
        PlayAnimationFromTo("i_mini01_move", 0, 179);
        PlayAnimationFromTo("i_mini02_move", 0, 179);  
        EnableLockOn({"All_Tur01", "All_Tur02", "All_Tur03", "All_Tur04"}, true)
        ScriptCB_SndPlaySound("SPA1_obj_64")   
        
        SetProperty("All_Tur01", "MaxHealth", 18000)
        SetProperty("All_Tur02", "MaxHealth", 18000)
        SetProperty("All_Tur03", "MaxHealth", 18000)
        SetProperty("All_Tur04", "MaxHealth", 18000)    
        
        SetProperty("All_Tur01", "CurHealth", 18000)
        SetProperty("All_Tur02", "CurHealth", 18000)
        SetProperty("All_Tur03", "CurHealth", 18000)
        SetProperty("All_Tur04", "CurHealth", 18000)
     
    end
    
    Objective4.OnComplete = function(self)
        ATTReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATTReinforcementCount + 15)    
        ShowMessageText("level.spa2.objectives.campaign.c", 1)
        ScriptCB_SndPlaySound("SPA1_obj_65")   
    end
    
    Objective4.OnSingleTargetDestroyed = function(self, target)
        local numTargets = self:GetNumSingleTargets()
        if numTargets > 0 then
            ShowMessageText("level.spa.guns." .. numTargets, 1)
--          ScriptCB_SndPlaySound("SPA2_obj_19")
        end
    end 
    
        --setup objective 5 - Destroy the 6 engines
        
    engine01 = Target:New{name = "Engine_a01"}
    engine02 = Target:New{name = "Engine_a02"}
    engine03 = Target:New{name = "Engine_a03"}
    engine04 = Target:New{name = "Engine_a04"}
    engine05 = Target:New{name = "Engine_a05"}
    engine06 = Target:New{name = "Engine_a06"}
    

    Objective5 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF,
                                                    text = "level.spa1.objectives.campaign.5", popupText = "level.spa1.objectives.long.5", AIGoalWeight=0}
    Objective5:AddTarget(engine01)
    Objective5:AddTarget(engine02)
    Objective5:AddTarget(engine03)
    Objective5:AddTarget(engine04)
    Objective5:AddTarget(engine05)
    Objective5:AddTarget(engine06)
    
    Objective5.OnStart = function(self)
        EnableLockOn({"Engine_a01", "Engine_a02", "Engine_a03", "Engine_a04", "Engine_a05", "Engine_a06"}, true)
        --Engine 1
    SetProperty("Engine_a01", "MaxHealth", 20000)
    SetProperty("Engine_a01", "CurHealth", 20000)
        --Engine 2
    SetProperty("Engine_a02", "MaxHealth", 15000)
    SetProperty("Engine_a02", "CurHealth", 15000)
        --Engine 3
    SetProperty("Engine_a03", "MaxHealth", 15000)
    SetProperty("Engine_a03", "CurHealth", 15000)
        --Engine 4
    SetProperty("Engine_a04", "MaxHealth", 15000)
    SetProperty("Engine_a04", "CurHealth", 15000)
        --Engine 5
    SetProperty("Engine_a05", "MaxHealth", 15000)
    SetProperty("Engine_a05", "CurHealth", 15000)
        --Engine 6
    SetProperty("Engine_a06", "MaxHealth", 20000)
    SetProperty("Engine_a06", "CurHealth", 20000)
    end

    Objective5.OnComplete = function(self)
        ShowMessageText("level.spa2.objectives.campaign.c", 1)
        ScriptCB_SndPlaySound("SPA1_obj_48")      
        ShowTimer(nil)        
    end
    
    Objective5.OnSingleTargetDestroyed = function(self, target)
        local numTargets = self:GetNumSingleTargets()
        if numTargets > 0 then
            ShowMessageText("level.spa.engines." .. numTargets, 1)
--          ScriptCB_SndPlaySound("SPA2_obj_19")
        end
    end 
   
--setup objective 6 - Destroy the 3 Criticals
        
    crit01 = Target:New{name = "life_ext_all"}
    crit02 = Target:New{name = "comms_all"}
    crit03 = Target:New{name = "sensors_all"}

    Objective6 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF,
                                                text = "level.spa1.objectives.campaign.6", popupText = "level.spa1.objectives.long.6"}
    Objective6:AddTarget(crit01)
    Objective6:AddTarget(crit02)
    Objective6:AddTarget(crit03)

    Objective6.OnStart = function(self)
        ScriptCB_SndPlaySound("SPA1_obj_57") 
    ScriptCB_PlayInGameMusic("imp_spa1_immVict_01")       
    end
    
    Objective6.OnComplete = function(self)
        ShowMessageText("level.spa2.objectives.campaign.c", 1)
        ScriptCB_SndPlaySound("SPA1_obj_58")   
    end
    
    Objective6.OnSingleTargetDestroyed = function(self, target)
        local numTargets = self:GetNumSingleTargets()
        if numTargets > 0 then
            ShowMessageText("level.spa.systems." .. numTargets, 1)
--          ScriptCB_SndPlaySound("SPA2_obj_19")
        end
    end 
    
    function BeginObjectivesTimer()
    beginobjectivestimer = CreateTimer("beginobjectivestimer")
    OnTimerElapse(BeginObjectives, beginobjectivestimer)
    SetTimerValue(beginobjectivestimer, 5)
    StartTimer(beginobjectivestimer)
    end    
    
function BeginObjectives()
--This creates the objective "container" and specifies order of objectives, and gets that running           
    objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 8.5}
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:AddObjectiveSet(Objective2)
    objectiveSequence:AddObjectiveSet(Objective3)
    objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:AddObjectiveSet(Objective5)
--    objectiveSequence:AddObjectiveSet(Objective6)
    objectiveSequence:Start()
end

end

function Objective3ShipKillStart(shipClasses)
    Objective3ShipKill = {}     --reminder: don't reuse this variable name (it's global!)
    for i, ship in ipairs (shipClasses) do
        Objective3ShipKill[i] = OnObjectKillClass (
            function (object, killer)
                if killer and IsCharacterHuman (killer) then
                    ship_count = ship_count - 1
                    if ship_count > 0 then
                        ShowMessageText("level.spa.count." .. ship_count, 1)
                    elseif ship_count == 0 then
                        Objective3:Complete (ATT)
                        
                        --release all the "kill" event responses
                        for i, func in pairs(Objective3ShipKill) do
                            ReleaseObjectKill(func)
                        end
                    end
                end                     
            end,
            ship
            )
    end
end

-- Frigates Listing

function FriglistA()
      PauseAnimation("gate01");
--      RewindAnimation("at13evac");
--      SetAnimationStartPoint("at13evac");
      PlayAnimation("at13evac");
end

function FriglistB()
      PauseAnimation("gate02");
--      RewindAnimation("at16evac");
--      SetAnimationStartPoint("at16evac");
      PlayAnimation("at16evac");
end

function Imp01evac()
      PauseAnimation("i_mini01_move");
--      RewindAnimation("at13evac");
--      SetAnimationStartPoint("at13evac");
      PlayAnimation("it4evac");
end

function Imp02evac()
      PauseAnimation("i_mini02_move");
--      RewindAnimation("at16evac");
--      SetAnimationStartPoint("at16evac");
      PlayAnimation("it1evac");
end

    function Hinttimer()
        hintVOtimer = CreateTimer("hintVOtimer")
        hintVO = OnTimerElapse(PlayVO, hintVOtimer)
        SetTimerValue(hintVOtimer, 45)
        StartTimer(hintVOtimer)
    end

function PlayVO()
        ScriptCB_SndPlaySound("SPA1_obj_51")
        ReleaseTimerElapse(hintVO)
        DestroyTimer(hintVOtimer)
end
function ScriptPreInit()
   SetWorldExtents(2060)
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
     StealArtistHeap(1024*1024)
     SetPS2ModelMemory(4850000)
     ReadDataFile("ingame.lvl")
     ReadDataFile("SPA\\spa_sky.lvl", "yav")

     ReadDataFile("sound\\spa.lvl;spa1gcw")
     ScriptCB_SetDopplerFactor(0.4)
     ScaleSoundParameter("tur_weapons",   "MinDistance",   3.0);
     ScaleSoundParameter("tur_weapons",   "MaxDistance",   3.0);
     ScaleSoundParameter("tur_weapons",   "MuteDistance",   3.0);
     ScaleSoundParameter("Ordnance_Large",   "MinDistance",   3.0);
     ScaleSoundParameter("Ordnance_Large",   "MaxDistance",   3.0);
     ScaleSoundParameter("Ordnance_Large",   "MuteDistance",   3.0);
     ScaleSoundParameter("explosion",   "MaxDistance",   5.0);
     ScaleSoundParameter("explosion",   "MuteDistance",  5.0);

     SetMinFlyHeight(-1900)
     SetMaxFlyHeight(2000)
     SetMinPlayerFlyHeight(-1900)
     SetMaxPlayerFlyHeight(2000)
     SetAIVehicleNotifyRadius(100)

     ReadDataFile("SIDE\\all.lvl",
        "all_inf_pilot",
        "all_inf_marine",
        "all_fly_xwing_sc",
        "all_fly_ywing_sc",
        "all_fly_awing")
     ReadDataFile("SIDE\\imp.lvl",
        "imp_inf_pilot",
        "imp_inf_marine",
        "imp_fly_tiefighter_sc",
        "imp_fly_tiebomber_sc",
        "imp_fly_tieinterceptor")

     ReadDataFile("SIDE\\tur.lvl",
        "tur_bldg_spa_all_recoilless",
        "tur_bldg_spa_all_beam",
        "tur_bldg_spa_imp_recoilless",
        "tur_bldg_spa_imp_chaingun",
        "tur_bldg_chaingun_roof")
        
     --  Level Stats
     ClearWalkers()
     local weaponCnt = 280
     SetMemoryPoolSize ("Aimer", 220)
     SetMemoryPoolSize ("AmmoCounter", weaponCnt)
     SetMemoryPoolSize ("BaseHint", 54)
     SetMemoryPoolSize ("EnergyBar", weaponCnt)
     SetMemoryPoolSize ("EntityDroid", 0)
     SetMemoryPoolSize ("EntityFlyer", 40)
     SetMemoryPoolSize ("EntityLight", 75)
     SetMemoryPoolSize ("EntityRemoteTerminal", 12)
     SetMemoryPoolSize ("EntitySoundStream", 12)
     SetMemoryPoolSize ("EntitySoundStatic", 3)
     SetMemoryPoolSize ("FLEffectObject::OffsetMatrix", 180)
     SetMemoryPoolSize ("MountedTurret", 64)
     SetMemoryPoolSize ("Navigator", 32)
     SetMemoryPoolSize ("Obstacle", 111)
     SetMemoryPoolSize ("PathFollower", 32)
     SetMemoryPoolSize ("PathNode", 100)
     SetMemoryPoolSize ("SoundSpaceRegion", 10)
     SetMemoryPoolSize ("TreeGridStack", 300)
     SetMemoryPoolSize ("UnitAgent", 75)
     SetMemoryPoolSize ("UnitController", 75)
     SetMemoryPoolSize ("Weapon", weaponCnt)
     
    --if(gPlatformStr == "XBox") then 
    --    SetMemoryPoolSize ("Asteroid", 400)
    --elseif( gPlatformStr == "PS2") then
        SetMemoryPoolSize ("Asteroid", 80)
    --else -- PC
    --    SetMemoryPoolSize ("Asteroid", 600)
    --end

SetupTeams{

         all = {
            team = ALL,
            units = 26,
            reinforcements = -1,
            pilot    = { "all_inf_pilot",2},
            marine   = { "all_inf_marine",24},
        },

        imp = {
            team = IMP,
            units = 6,
            reinforcements = 20,
            pilot    = { "imp_inf_pilot",5},
            marine   = { "imp_inf_marine",5},

        }
     }

    
     SetSpawnDelay(10.0, 0.25)
     ReadDataFile("spa\\spa1.lvl", "spa1_Campaign")
     SetDenseEnvironment("false")
     AddDeathRegion("deathregionimp")
     AddDeathRegion("deathregionall")
     --SetStayInTurrets(1)
     ScriptCB_SetSpawnDisplayGain(0.2, 0.5)
     
     
    SetParticleLODBias(3000)
     
    --if(gPlatformStr == "XBox") then 
         --SetMaxCollisionDistance(1500)
        --FillAsteroidRegion("asteroid_region1", "spa_prop_jagged_asteroid_medium_stop", 50, 2.0,1.0,1.0, 0.0,-1.0,-1.0);
        --FillAsteroidRegion("asteroid_region1", "spa_prop_jagged_asteroid_large_stop", 100, 3.0,1.0,1.0, 0.0,-1.0,-1.0);
        --FillAsteroidPath("asteroid_path1", 120, "spa_prop_jagged_asteroid_large", 50, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
        --FillAsteroidPath("asteroid_path1", 60, "spa_prop_jagged_asteroid_medium", 50, 1.0,1.0,1.0, 0.0,-1.0,-1.0); 
        --FillAsteroidPath("asteroid_path2", 120, "spa_prop_jagged_asteroid_large_stop", 50, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
        --FillAsteroidPath("asteroid_path2", 60, "spa_prop_jagged_asteroid_medium_stop", 100, 2.0,1.0,1.0, 0.0,-1.0,-1.0); 

    --elseif( gPlatformStr == "PS2") then
         SetMaxCollisionDistance(1000)
--        FillAsteroidRegion("asteroid_region1", "spa_prop_jagged_asteroid_medium_stop", 25, 2.0,1.0,1.0, 0.0,-1.0,-1.0);
--        FillAsteroidRegion("asteroid_region1", "spa_prop_jagged_asteroid_large_stop", 50, 3.0,1.0,1.0, 0.0,-1.0,-1.0);
        FillAsteroidPath("asteroid_path1", 120, "spa_prop_jagged_asteroid_large", 20, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
        FillAsteroidPath("asteroid_path1", 60, "spa_prop_jagged_asteroid_medium", 20, 1.0,1.0,1.0, 0.0,-1.0,-1.0); 
        FillAsteroidPath("asteroid_path2", 120, "spa_prop_jagged_asteroid_large_stop", 20, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
        FillAsteroidPath("asteroid_path2", 60, "spa_prop_jagged_asteroid_medium_stop", 20, 2.0,1.0,1.0, 0.0,-1.0,-1.0); 
    --else -- PC
         --SetMaxCollisionDistance(2000)
        --FillAsteroidRegion("asteroid_region1", "spa_prop_jagged_asteroid_medium_stop", 50, 2.0,1.0,1.0, 0.0,-1.0,-1.0);
        --FillAsteroidRegion("asteroid_region1", "spa_prop_jagged_asteroid_large_stop", 200, 3.0,1.0,1.0, 0.0,-1.0,-1.0);
        --FillAsteroidPath("asteroid_path1", 120, "spa_prop_jagged_asteroid_large", 50, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
        --FillAsteroidPath("asteroid_path1", 60, "spa_prop_jagged_asteroid_medium", 50, 1.0,1.0,1.0, 0.0,-1.0,-1.0); 
        --FillAsteroidPath("asteroid_path2", 120, "spa_prop_jagged_asteroid_large_stop", 50, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
        --FillAsteroidPath("asteroid_path2", 60, "spa_prop_jagged_asteroid_medium_stop", 200, 2.0,1.0,1.0, 0.0,-1.0,-1.0); 
    
    --end
     

     --  Sound
     
    voiceSlow = OpenAudioStream("sound\\global.lvl", "spa1_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow) 
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "imp_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "all_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl",  "global_vo_quick", voiceQuick)   
     
     OpenAudioStream("sound\\global.lvl",  "gcw_music")
     -- OpenAudioStream("sound\\spa.lvl",  "spa1_objective_vo_slow")
     -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
     -- OpenAudioStream("sound\\gcw.lvl",  "gcw_vo")
     OpenAudioStream("sound\\spa.lvl",  "spa")
     OpenAudioStream("sound\\spa.lvl",  "spa")

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

     -- SetAmbientMusic(ALL, 1.0, "all_spa_amb_start",  0,1)
     -- SetAmbientMusic(ALL, 0.99, "all_spa_amb_middle", 1,1)
     -- SetAmbientMusic(ALL, 0.1,"all_spa_amb_end",    2,1)
     -- SetAmbientMusic(IMP, 1.0, "imp_spa_amb_start",  0,1)
     -- SetAmbientMusic(IMP, 0.99, "imp_spa_amb_middle", 1,1)
     -- SetAmbientMusic(IMP, 0.1,"imp_spa_amb_end",    2,1)

     SetVictoryMusic(ALL, "all_spa_amb_victory")
     SetDefeatMusic (ALL, "all_spa_amb_defeat")
     SetVictoryMusic(IMP, "imp_spa_amb_victory")
     SetDefeatMusic (IMP, "imp_spa_amb_defeat")

   SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
   SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
     --  SetSoundEffect("BirdScatter",         "birdsFlySeq1")
   SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
   SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
   SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
   SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
   SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


    SetAttackingTeam(ATT)
    --Star Dest far
	AddCameraShot(0.792356, 0.005380, -0.610022, 0.004142, -1083.259766, 205.730942, 524.492249);
	--All Cru far
	AddCameraShot(-0.362954, -0.002066, -0.931790, 0.005304, -149.122910, -97.288933, -1759.549927);
	--All Cru Angle
	AddCameraShot(0.599707, -0.046312, 0.796507, 0.061510, 544.123230, 93.926430, -522.673523);
	--Star Dest Angle
    AddCameraShot(0.181770, -0.005491, -0.982877, -0.029689, -16.614826, 307.607605, -2127.639648);
    
    AddLandingRegion("CP1Control")
    AddLandingRegion("CP2Control")

    if (gPlatformStr == "PS2") then
        ScriptCB_DisableFlyerShadows()
    end     
 end
