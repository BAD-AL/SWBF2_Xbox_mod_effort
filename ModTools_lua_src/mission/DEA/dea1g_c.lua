--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
    
    --  Empire Attacking (attacker is always #1)
    IMP = 1
    ALL = 2
    hangar_ambush = 5
    snipers = 6
    flag_rebel = 7
    --  These variables do not change
    ATT = 1
    DEF = 2
    
    
-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("ObjectiveGoto")
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("Ambush")





function ScriptPostLoad()

    
    SetAIDifficulty(0, -1, "medium")
    TrashStuff();
    SetMissionEndMovie("ingame.mvs", "deamon02")
    BlockPlanningGraphArcs("compactor")
    BlockPlanningGraphArcs("Connection146")
    ScriptCB_SetGameRules("campaign")
    ScriptCB_PlayInGameMovie("ingame.mvs", "deamon01")


    SetProperty("CAM_CP2", "Value_ATK_Empire", 10)
    SetProperty("CAM_CP2", "Value_DEF_Alliance", 10)
    
    SetClassProperty("jed_knight_01", "MaxHealth", 1500)
    SetClassProperty("jed_knight_01", "CurHealth", 1500)
    SetClassProperty("jed_knight_01", "AddHealth", 0.0)
--      SetProperty("trans02", "MaxHealth", 150)
--      SetProperty("trans02", "CurHealth", 150)

    
    --delete the other alliance CPs for the first couple of objectives.
    KillObject("CAM_CP4")
    KillObject("CAM_CP5")
    KillObject("CAM_CP2")
    KillObject("CAM_CP7")
    KillObject("CAM_CP1")
    KillObject("CAM_CP8")
    SetProperty("Panel-Tak", "CurHealth", 0)
    
    SetProperty("obj6_shuttle", "MaxHealth", 1e+37)
    SetProperty("obj6_shuttle", "CurHealth", 1e+37)
    
    
    ActivateRegion("cam_cp2_capture")
    ActivateRegion("obj6_ambush2")
    ActivateRegion("obj6_ambush3")
    
    --Sets CPs un-capturable by AI
    
    AICanCaptureCP("CAM_CP2", ATT, false)
    
    SetProperty("Dr-LeftMain", "IsLocked", 1)
    SetProperty("dea1_prop_door_blast0", "IsLocked", 1)
    
    --close the door by the initial spawn
    SetProperty("dea1_prop_door0", "IsLocked", 1)
    BlockPlanningGraphArcs("start_room_door")
    EnableBarriers("start_room_barrier")
    
    DisableBarriers("dr_left")
    BlockPlanningGraphArcs("Connection41")    
    BlockPlanningGraphArcs("Connection115")

    ActivateRegion("transtrip")
    KillObject("grate01")
    
    SetProperty("Trans01", "CurHealth", 1e+37)
    
        

    
    EntityFlyerInitAsLanded("trans01")
    --    EntityFlyerInitAsFlying("trans02")

    PlayAnimation("incoming01");
    
    landingTimer = CreateTimer("landingTimer")
    SetTimerValue(landingTimer, 8)
    StartTimer(landingTimer)
    
    shuttle_land = OnTimerElapse(
        function(timer)
            DestroyTimer(landingTimer)
            PauseAnimation("incoming01");
            RewindAnimation("incoming03");
            PlayAnimation("incoming03");
            ReleaseTimerElapse(shuttle_land)
        end,
        landingTimer
        )
    PlayAnimExtend();
    PlayAnimTakExtend();

    OnObjectRespawnName(PlayAnimExtend, "Panel-Chasm");
    OnObjectKillName(PlayAnimRetract, "Panel-Chasm");
    OnObjectRespawnName(PlayAnimTakExtend, "Panel-Tak");
    OnObjectKillName(PlayAnimTakRetract, "Panel-Tak");
    OnObjectKillName(CompactorConnectionOn, "grate01")
    EnableSPScriptedHeroes()
    
    --Objective1:Start()
    onfirstspawn = OnCharacterSpawn(
        function(character)
            if IsCharacterHuman(character) then
                ScriptCB_PlayInGameMusic("imp_dea_amb_obj1_2_explore")
                ReleaseCharacterSpawn(onfirstspawn)
                onfirstspawn = nil
                start_timer = CreateTimer("start_timer")
                SetTimerValue(start_timer, 3)
                StartTimer(start_timer)
                begin_objectives = OnTimerElapse(
                    function()
                        BeginObjectives()
                        ReleaseTimerElapse(begin_objectives)
                    end,
                    start_timer
                    )
             end
        end)

            
    --This is objective 1  Go to the hangar
    Objective1 = ObjectiveGoto:New{teamATT = ATT, teamDEF = DEF, text = "level.dea1.objectives.1", popupText = "level.dea1.objectives.campaign.1_popup", AIGoalWeight = 0, regionName = "transreg"}

    Objective1.OnStart = function(self)
    MapAddEntityMarker("Trans01", "hud_objective_icon_circle", 3.0, ATT, "YELLOW", true, true, true) 
    ScriptCB_EnableCommandPostVO(0)
    --ScriptCB_SndPlaySound("DEA_obj_10")
    SetProperty("Panel-Chasm", "CurHealth", 0)
    BroadcastVoiceOver("DEA_obj_27", ATT)
    PlayAnimRetract()
    
    
    end

    Objective1.OnComplete = function(self)
        MapRemoveEntityMarker("Trans01")
--      ScriptCB_SndPlaySound("DEA_obj_11")
        SetProperty("imp_base", "SpawnPath", "CAM_CP1Spawn")
        --BatchChangeTeams(3, ATT, 3)
        AllowAISpawn(ATT, true) 
        RespawnObject("CAM_CP1")
        SetProperty("CAM_CP1", "SpawnPath", "imp_base_spawn")
        ShowMessageText("game.objectives.complete", ATT)
        
        
        --KillObject("all_spawn")
        BroadcastVoiceOver("DEA_obj_28", ATT)
    end             

    --Objective 2 - Defend the Hangar
    Objective2CP = CommandPost:New{name = "CAM_CP1"}
    Objective2 = ObjectiveConquest:New{teamATT = DEF, teamDEF = ATT, textATT = "blah", textDEF = "level.dea1.objectives.campaign.2", popupText = "level.dea1.objectives.campaign.2_popup", AIGoalWeight = 0, timeLimit = 120}--set back to 120 
    Objective2:AddCommandPost(Objective2CP)
    
    Objective2.OnStart = function(self)
        Ambush("defend_ambush", 3, 5)
        AddAIGoal(5, "Defend", 99999, "CAM_CP1")
        SetAIDamageThreshold("obj6_shuttle", 0.2)
        hangar_ambush_timer = CreateTimer("hangar_ambush_timer")
        SetTimerValue(hangar_ambush_timer, 45)
        StartTimer(hangar_ambush_timer)
        MapAddEntityMarker("CAM_CP1", "hud_objective_icon_circle", 3.0, ATT, "YELLOW", true, true, true) 
        hangar_ambush_go = OnTimerElapse(
            function(timer)
                SetProperty("Dr-LeftMain", "IsLocked", 0)
                Ambush("hangar_ambush_spawn", 6, 5)
                --ShowMessageText("level.dea1.hangar_ambush", ATT)
                SetTimerValue(hangar_ambush_timer, 10)
                
                ReleaseTimerElapse(hangar_ambush_go)
                UnblockPlanningGraphArcs("Connection41")
                hangar_ambush_off = OnTimerElapse(
                    function(timer)
                        BlockPlanningGraphArcs("Connection41")
                        ReleaseTimerElapse(hangar_ambush_off)
                        SetProperty("Dr-LeftMain", "IsLocked", 1)
                    end,
                    hangar_ambush_timer
                    )
            end,
            hangar_ambush_timer
            )
        
        imp_base_spawnswitch_t = CreateTimer("imp_base_spawnswitch_t")
        SetTimerValue(imp_base_spawnswitch_t, 4)
        StartTimer(imp_base_spawnswitch_t)
        imp_base_spawnswitch = OnTimerElapse(
            function(timer)
                SetProperty("imp_base", "SpawnPath", "imp_base_spawn")
                ReleaseTimerElapse(imp_base_spawnswitch)
            end,
            imp_base_spawnswitch_t
            )
        AddAIGoal(ATT, "Defend", 9999, "CAM_CP1")
        -- tell the alliance to take over that CP
        AddAIGoal(DEF, "Conquest", 9999)
        SetProperty("cam_cp1", "Value_ATK_Alliance", 100)
        -- but not the other one, since you can't capture it
        SetProperty("imp_base", "Value_ATK_Alliance", 0)
        SetProperty("imp_base", "Value_DEF_Alliance", 0)
        -- and have these guys defend it
        SetProperty("cam_cp1", "Value_DEF_Empire", 100)
        SetProperty("imp_base", "Value_DEF_Empire", 0)
        SetProperty("cam_cp2", "Value_ATK_Empire", 0)
        
        SetProperty("CAM_CP2", "Value_DEF_Alliance", 0)
    
    end
    
    Objective2.OnComplete = function(self, winningTeam)
        if winningTeam == ATT then
            RespawnObject("CAM_CP2")
            MapRemoveEntityMarker("CAM_CP1")
            ClearAIGoals(ATT)
            ClearAIGoals(DEF)
            ClearAIGoals(5)
            ShowMessageText("game.objectives.complete", ATT)
            SetProperty("CAM_CP1", "Team", 1)
            AICanCaptureCP("CAM_CP1", DEF, false)
            AICanCaptureCP("CAM_CP1", 5, false)
            AICanCaptureCP("CAM_CP1", 6, false)
            AICanCaptureCP("CAM_CP1", 7, false)
            KillObject("imp_base")
            --Give player's team more reinforcements
            ATT_ReinforcementCount = GetReinforcementCount(ATT)
            SetReinforcementCount(ATT, ATT_ReinforcementCount + 15)
            BroadcastVoiceOver("DEA_obj_37", ATT)
            ScriptCB_PlayInGameMusic("imp_dea_objComplete_01")
            -- Music Timer -- 
         music01Timer = CreateTimer("music01")
        SetTimerValue(music01Timer, 15.0)
                              
            StartTimer(music01Timer)
            OnTimerElapse(
                function(timer)
                ScriptCB_StopInGameMusic("imp_dea_objComplete_01")
                ScriptCB_PlayInGameMusic("imp_dea_act_01")
                DestroyTimer(timer)
            end,
            music01Timer
        ) 
        end
    end
            
    --Objective 3 - Capture the Denention Block
    
    Objective3CP = CommandPost:New{name = "CAM_CP2"}
    Objective3 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.dea1.objectives.campaign.3", popupText = "level.dea1.objectives.campaign.3_popup", AIGoalWeight = 0}
    Objective3:AddCommandPost(Objective3CP)

    Objective3.OnStart = function(self)
        KillObject("all_spawn")
        BroadcastVoiceOver("DEA_obj_29", ATT)
        sniperspawn = OnEnterRegion(
            function()
                Ambush("sniper_spawn2", 2, 6)
                --ShowMessageText("rara", ATT)
                AddAIGoal(snipers, "Deathmatch", 9999)
                ReleaseEnterRegion(sniperspawn)
            end,
            "sniper_spawn2"
            )
        AddAIGoal(ATT, "Defend", 99999, "CAM_CP2")
        AddAIGoal(DEF, "Defend", 99999, "CAM_CP2")
    end
    
    Objective3.OnComplete = function(self)
        RespawnObject("all_spawn")
        SetProperty("all_spawn", "SpawnPath", "CAM_CP5Spawn")
        KillObject("CAM_CP1")
        SetProperty("CAM_CP5", "Team", 2)
        SetProperty("CAM_CP2", "Team", 1)
        AICanCaptureCP("CAM_CP5", ATT, false)
        AICanCaptureCP("CAM_CP2", DEF, false)
        AICanCaptureCP("CAM_CP2", 5, false)
        AICanCaptureCP("CAM_CP2", 6, false)
        AICanCaptureCP("CAM_CP2", 7, false)
        Ambush("obj4_ambush_spawn", 6, 5)
        --ShowMessageText("level.dea1.platform_ambush", ATT)
        
        --sets the geometry, and carried geometry
        
        Ambush("plans_spawn", 1, flag_rebel)
        
        --spawn the plans
        PlansSpawn = GetPathPoint("plans_spawn", 0) --gets the path point
        CreateEntity("dea_icon_disk", PlansSpawn, "plans") --spawns the flag
        
        MapAddEntityMarker(GetCharacterUnit(GetTeamMember(flag_rebel, 0)), "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true)
        --ShowMessageText("rara", ATT)
        
        ShowMessageText("game.objectives.complete", ATT)
        ClearAIGoals(DEF)
        ClearAIGoals(ATT)
        BroadcastVoiceOver("DEA_obj_31", ATT)
        
        --Give player's team more reinforcements
        ATT_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATT_ReinforcementCount + 15)
        
        
    end

    
    --Objective 4 - get the plans from that jerk
    Objective4 = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 1, text = "level.dea1.objectives.campaign.4", popupText = "level.dea1.objectives.campaign.4_popup", AIGoalWeight = 0}
    Objective4:AddFlag{name = "plans", homeRegion = "", captureRegion = "planreturn01",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                mapIcon = "flag_icon", mapIconScale = 2.0}
    
    Objective4.OnStart = function(self)
        AddAIGoal(flag_rebel, "Destroy", 99999, "flagguy_defend")
        SetTeamAsEnemy(flag_rebel, IMP)
        SetTeamAsEnemy(IMP, flag_rebel)
        SetTeamAsFriend(flag_rebel, ALL)
        SetTeamAsFriend(ALL, flag_rebel)
        SetTeamAsFriend(flag_rebel, hangar_ambush)
        SetTeamAsFriend(hangar_ambush, flag_rebel)
        BroadcastVoiceOver("DEA_obj_30", ATT)
        AddAIGoal(ATT, "Deathmatch", 99999)
        AddAIGoal(DEF, "Deathmatch", 500)
        AddAIGoal(DEF, "Defend", 500, "CAM_CP2")
        --Ambush, send some dudes at the player for the beginning of this objective
        
        AddAIGoal(5, "Defend", 99999, "CAM_CP2")
        --set up markers for capture location
        plans_capture_on = OnFlagPickUp(
        function(flag, carrier)
            if IsCharacterHuman(carrier) then
                ShowMessageText("level.dea1.objectives.campaign.4_pickup", ATT)
                MapAddEntityMarker("CAM_CP2", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true)               
            end
        end,
        "plans"
        )
        
        plans_capture_off = OnFlagDrop(
        function(flag, carrier)
            if IsCharacterHuman(carrier) then
                MapRemoveEntityMarker("CAM_CP2")
                ShowMessageText("level.dea1.objectives.campaign.4_drop", ATT)               
            end
        end,
        "plans"
        )
        
        --This makes the plans not pick-upable by AI after the first guy drops them
        plans_aipickup_off = OnFlagDrop(
        function(flag, carrier)
            if not IsCharacterHuman(carrier) then
                SetProperty("plans", "AllowAIPickUp", 0)
                ReleaseFlagDrop(plans_aipickup_off)             
            end
            --make sure there's no more marker on the dead guy
            MapRemoveEntityMarker(GetCharacterUnit(GetTeamMember(flag_rebel, 0)))
        end,
        "plans"
        )
    end
                
    Objective4.OnComplete = function (self)
        BroadcastVoiceOver("DEA_obj_38", ATT)
        ScriptCB_PlayInGameMusic("imp_dea_objComplete_02")
         -- Music Timer -- 
         music02Timer = CreateTimer("music02")
        SetTimerValue(music02Timer, 33.0)
                              
            StartTimer(music02Timer)
            OnTimerElapse(
                function(timer)
                ScriptCB_StopInGameMusic("imp_dea_objComplete_02")
                ScriptCB_PlayInGameMusic("imp_dea_amb_obj5_explore")
                DestroyTimer(timer)
            end,
            music02Timer
        ) 
        ReleaseFlagPickUp(plans_capture_on)
        ReleaseFlagDrop(plans_capture_off)
        ShowMessageText("game.objectives.complete", ATT)
        --Give player's team more reinforcements
        ATT_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATT_ReinforcementCount + 10)
        MapRemoveEntityMarker("CAM_CP2")
        
    end
    
    Objective5CP = CommandPost:New{name = "CAM_CP5"}
    Objective5 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.dea1.objectives.campaign.5", popupText = "level.dea1.objectives.campaign.5_popup", AIGoalWeight = 0}
    Objective5:AddCommandPost(Objective5CP)
    
    Objective5.OnStart = function(self)
        BroadcastVoiceOver("DEA_obj_17", ATT)
        KillObject("all_spawn")
        RespawnObject("CAM_CP5")
        ClearAIGoals(ATT)
        ClearAIGoals(DEF)
        ClearAIGoals(5)
        ClearAIGoals(6)
        ClearAIGoals(7)
        AddAIGoal(ATT, "Defend", 99999, "CAM_CP5")
        AddAIGoal(DEF, "Defend", 99999, "CAM_CP5")
        fire_control_ambush = OnEnterRegion(
            function(region, character)
                if IsCharacterHuman(character) then
                    Ambush("fire_control_ambush_spawn", 4, 5)
                end
            end,
            "fire_control_ambush"
            )
    end
    
    Objective5.OnComplete = function(self)
        BroadcastVoiceOver("DEA_obj_39", ATT)
        KillObject("CAM_CP2")
        SetProperty("Dr-LeftMain", "IsLocked", 1)
        SetProperty("CAM_CP5", "Team", 1)
        SetProperty("dea1_prop_door_blast0", "IsLocked", 0)
        RespawnObject("CAM_CP7")
        --KillObject("CAM_CP5")
        AICanCaptureCP("CAM_CP5", DEF, false)
        --Give player's team more reinforcements
        ATT_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATT_ReinforcementCount + 10) 
        ShowMessageText("game.objectives.complete", ATT)    
    end
    

    --Objective6 - Destroy the Shuttle Before it takes off

    Shuttle = Target:New{name = "obj6_shuttle", killedByPlayer = true}
    
    Objective6 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
                              text = "level.dea1.objectives.campaign.6", popupText = "level.dea1.objectives.campaign.6_popup", timeLimit = 180, timeLimitWinningTeam = DEF}
    Objective6:AddTarget(Shuttle)

    --This is objective 6  Go to the TIE Hangar
    
    Objective6.OnStart = function(self)
        BroadcastVoiceOver("DEA_obj_33", ATT)
        ScriptCB_PlayInGameMusic("imp_dea_immVict_01")
        ClearAIGoals(ATT)
        ClearAIGoals(DEF)
        ClearAIGoals(5)
--      AddAIGoal(ATT, "Destroy", 99999, "obj6_shuttle")
--      AddAIGoal(DEF, "Defend", 99999, "obj6_shuttle")
        AddAIGoal(5, "Deathmatch", 999999)
        SetProperty("obj6_shuttle", "MaxHealth", 9000)
        SetProperty("obj6_shuttle", "CurHealth", 9000)
        SetProperty("obj6_shuttle", "Team", DEF)        --Very important that the shuttle is on the other team,
                                                        --since players can turn off friendly fire! - BradR
        Ambush("obj6_ambush1", 6, 5)
        --ShowMessageText("level.dea1.obj6_ambush1", ATT)
        obj6_ambush2 = OnEnterRegion(
            function(region, character)
                if IsCharacterHuman(character) then
                    Ambush("obj6_ambush2", 6, 5)
                    --ShowMessageText("level.dea1.obj6_ambush2", ATT)
                    ReleaseEnterRegion(obj6_ambush2)
                end
            end,
            "obj6_ambush2"
            )
            
        obj6_ambush3 = OnEnterRegion(
            function(region, character)
                if IsCharacterHuman(character) then
                    Ambush("obj6_ambush3", 3, 5)
                    --ShowMessageText("level.dea1.obj6_ambush3", ATT)
                    ReleaseEnterRegion(obj6_ambush3)
                    RespawnObject("CAM_CP8")
                    KillObject("CAM_CP5")
                end
            end,
            "obj6_ambush3"
            )
        
    end
    
    Objective6.OnComplete = function(self, winningTeam)
    
        if winningTeam == ATT then
            BroadcastVoiceOver("DEA_obj_40", ATT)
                    -- add Jedi as a new unit
            --local characterindex = GetTeamMember(4, 0)
            --BatchChangeTeams(4, DEF, 1)
            --SetHeroClass(ALL, "jed_knight_01")
            --SelectCharacterClass(characterindex, "jed_knight_01")
            --SpawnCharacter(characterindex, GetPathPoint("jedi", 0)) 
            --Give player's team more reinforcements
            ATT_ReinforcementCount = GetReinforcementCount(ATT)
            SetReinforcementCount(ATT, ATT_ReinforcementCount + 5) 
            ShowMessageText("game.objectives.complete", ATT)
            
        elseif winningTeam == DEF then
            BroadcastVoiceOver("DEA_obj_34", ATT)
        end     
    end    

--This is objective 7  Destroy The Rebel Leader
    
    Objective7 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, text = "level.dea1.objectives.campaign.7", popupText = "level.dea1.objectives.campaign.7_popup"}

    JediKiller = TargetType:New{classname = "jed_knight_01", killLimit = 1}
    Objective7:AddTarget(JediKiller)
    
    Objective7.OnStart = function(self)
    	Ambush("jedi", 1, 4, 0.5)
        jedigoal = AddAIGoal(4, "Defend", 100, "CAM_CP7")
        BroadcastVoiceOver("DEA_obj_19", ATT)
        UnblockPlanningGraphArcs("Connection115")
        SetProperty("CAM_CP7", "Value_ATK_Empire", 10)
        SetProperty("CAM_CP7", "Value_DEF_Alliance", 10)
        ClearAIGoals(ATT)
        ClearAIGoals(DEF)
        AddAIGoal(ATT, "Deathmatch", 99999)
        AddAIGoal(ATT, "Deathmatch", 99999)
    end
    
    Objective7.OnComplete = function(self, winningTeam)
        if winningTeam == ATT then
            ShowMessageText("game.objectives.complete", ATT)
            BroadcastVoiceOver("DEA_obj_36", ATT)
            BroadcastVoiceOver("DEA_obj_35", ATT)
        end
    end
    
    --Objective8        
    --This is the actual objective setup
    Objective8 = ObjectiveTDM:New{teamATT = ATT, teamDEF = DEF, 
                           textATT = "level.dea1.objectives.8",
                           textDEF = "Kill Everyone!"}
    
    Objective8.OnStart = function(self)
        SetReinforcementCount(DEF, 20)
        --ScriptCB_SndPlaySound("DEA_obj_23")
    end
    
    Objective8.OnComplete = function(self)
        
        --ScriptCB_SndPlaySound("DEA_obj_20")
    end

function BeginObjectives()
--This creates the objective "container" and specifies order of objectives, and gets that running           
    objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 11.5}
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:AddObjectiveSet(Objective2)
    objectiveSequence:AddObjectiveSet(Objective3)
    objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:AddObjectiveSet(Objective5)
    objectiveSequence:AddObjectiveSet(Objective6)
    objectiveSequence:AddObjectiveSet(Objective7)
    --objectiveSequence:AddObjectiveSet(Objective8)
    objectiveSequence:Start()
end








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
    SetPS2ModelMemory(4000000)
    ReadDataFile("ingame.lvl")

    ReadDataFile("sound\\dea.lvl;dea1gcw")

    
    SetMaxFlyHeight(72)
    SetMaxPlayerFlyHeight (72)
    AISnipeSuitabilityDist(30)

    ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman_fleet",
                    "all_inf_rocketeer_fleet",
                    "all_inf_engineer_fleet",
                    "all_inf_sniper_fleet",
                    --"all_inf_officer",
                    "all_inf_wookiee")
    ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_officer",
                    "imp_inf_dark_trooper",
                    "imp_fly_ai_trooptrans")
    ReadDataFile("SIDE\\tur.lvl",
                    "tur_bldg_mortar")
    ReadDataFile("SIDE\\jed.lvl",
                    "jed_knight_01")
                
    ScriptCB_SetSpawnDisplayGain(0.2, 0.5)          

     

    --  Level Stats
    ClearWalkers()
    --    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
    --    AddWalkerType(1, 0) -- 8 droidekas (special case: 0 leg pairs)
    --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
    --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    SetMemoryPoolSize ("EntityFlyer",9)
    SetMemoryPoolSize ("EntityLight",180)
    SetMemoryPoolSize ("EntitySoundStatic", 30)
    SetMemoryPoolSize ("SoundSpaceRegion", 50)  
    SetMemoryPoolSize ("FlagItem", 1)
    SetMemoryPoolSize ("RedOmniLight", 130)
    SetMemoryPoolSize ("Obstacle", 261)
    SetMemoryPoolSize ("Weapon", 260)

    SetupTeams{
        imp={
            team = IMP,
            units = 8,
            reinforcements = 25,
            soldier = {"imp_inf_rifleman", 10},
            assault = {"imp_inf_rocketeer", 2},
            engineer = {"imp_inf_engineer", 2},
            sniper  = {"imp_inf_sniper", 2},
            special = {"imp_inf_dark_trooper", 2},
            officer = {"imp_inf_officer", 2},
        },
        all={
            team = ALL,
            units = 8, --set back to 10
            reinforcements = -1,
            soldier = {"all_inf_rifleman_fleet",4},
            engineer = {"all_inf_engineer_fleet",1},
            assault = {"all_inf_rocketeer_fleet",2},
            sniper  = {"all_inf_sniper_fleet",0},
            special = {"all_inf_wookiee",1},
            
        }
        -- 10, 4, 4, 4, 3

    }

    AllowAISpawn(IMP, false)
    --SetHeroClass(ALL, "jed_knight_01")

    --  Local Stats
    SetUnitCount (3, 11)
    AddUnitClass (3, "imp_inf_rifleman", 11)
    
    --Adding Jedi Pool
     AddUnitClass(4, "jed_knight_01", 4)
     SetUnitCount(4, 1)
     SetReinforcementCount(4, -1)
     SetTeamAsEnemy(4, 1)
     SetTeamAsEnemy(1, 4)
     SetTeamAsFriend(4, 2)
     SetTeamAsFriend(2, 4)
     SetTeamAsFriend(4, 6)
     SetTeamAsFriend(6, 4)
     
    --additional rebel teams
    --SetTeamName(hangar_ambush, "Alliance_ambush")
    SetUnitCount(hangar_ambush, 6)
    AddUnitClass(hangar_ambush, "all_inf_rifleman_fleet", 3)
    AddUnitClass(hangar_ambush, "all_inf_wookiee", 1)
    AddUnitClass(hangar_ambush, "all_inf_engineer_fleet", 1)
    AddUnitClass(hangar_ambush, "all_inf_rocketeer_fleet", 1)
    SetReinforcementCount(hangar_ambush, -1)
    
    --sniper team
    --SetTeamName(snipers, "Alliance_snipers")
    SetUnitCount(snipers, 2)
    AddUnitClass(snipers, "all_inf_sniper_fleet", 2)
    SetReinforcementCount(snipers, -1)
    
    --flag rebel team
    --SetTeamName(flag_rebel, "rebel_flag_guy")
    SetUnitCount(flag_rebel, 1)
    AddUnitClass(flag_rebel, "all_inf_rifleman_fleet", 2)
    SetReinforcementCount(flag_rebel, -1)
    
    SetTeamAsEnemy(hangar_ambush, IMP)
    SetTeamAsFriend(hangar_ambush, ALL)
    SetTeamAsFriend(ALL, hangar_ambush)
    
    
    
    SetTeamAsEnemy(snipers, IMP)
    SetTeamAsFriend(snipers, ALL)
    SetTeamAsFriend(ALL, snipers)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dea\\dea1.lvl", "dea1_Campaign")
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

    --  Sound
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "dea_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow) 
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "imp_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "all_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl",  "global_vo_quick", voiceQuick)   
    
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    -- OpenAudioStream("sound\\dea.lvl",  "dea_objective_vo_slow")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\dea.lvl",  "dea1")
    OpenAudioStream("sound\\dea.lvl",  "dea1")
    -- OpenAudioStream("sound\\cor.lvl",  "dea1gcw_emt")

    --SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    --SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    --SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    --SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(1, "impleaving")
    SetOutOfBoundsVoiceOver(2, "allleaving")

    -- SetAmbientMusic(ALL, 1.0, "all_dea_amb_start",  0,1)
    -- SetAmbientMusic(ALL, 0.9, "all_dea_amb_middle", 1,1)
    -- SetAmbientMusic(ALL, 0.1,"all_dea_amb_end",    2,1)
    -- SetAmbientMusic(IMP, 1.0, "imp_dea_amb_start",  0,1)
    -- SetAmbientMusic(IMP, 0.9, "imp_dea_amb_middle", 1,1)
    -- SetAmbientMusic(IMP, 0.1,"imp_dea_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_dea_amb_victory")
    SetDefeatMusic (ALL, "all_dea_amb_defeat")
    SetVictoryMusic(IMP, "imp_dea_amb_victory")
    SetDefeatMusic (IMP, "imp_dea_amb_defeat")

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

