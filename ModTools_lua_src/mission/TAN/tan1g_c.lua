--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("ObjectiveGoto")
ScriptCB_DoFile("Ambush")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_SetGameRules("campaign")

--  Empire Attacking (attacker is always #1)
ALL = 2
IMP = 1
--  These variables do not change
ATT = 1
DEF = 2

ambushTeam2 = 5
ambushCount2 = 3

ambushTeam3 = 6
ambushCount3 = 5

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

SetMissionEndMovie("ingame.mvs", "tanmon02")

SetAIDifficulty(1, 0, "medium")

SetAIDifficulty(1, -3, "hard")

DisableAIAutoBalance()

AddDeathRegion("turbinedeath")

SetMapNorthAngle(180)

-- Turbine Stuff -- 
    BlockPlanningGraphArcs("turbine")
    OnObjectKillName(destturbine, "turbineconsole")
    OnObjectRespawnName(returbine, "turbineconsole")
    OnObjectKillName(DoorKill, "doorkill")

SetClassProperty("all_hero_leia", "MaxHealth", 1500)
SetClassProperty("all_hero_leia", "CurHealth", 1500)
SetAIDamageThreshold("mainframe01", 0.3)
SetAIDamageThreshold("mainframe02", 0.3)
SetAIDamageThreshold("mainframe03", 0.3)
SetAIDamageThreshold("mainframe04", 0.3)
SetAIDamageThreshold("mainframe05", 0.3)
SetAIDamageThreshold("mainframe06", 0.3)
SetAIDamageThreshold("mainframe07", 0.3)
SetAIDamageThreshold("mainframe08", 0.3)
--PauseAnimation("Turbine Animation")

   -- spawn Holodisk   
   -- Holocron1Spawn = GetPathPoint("codespawn", 0) --gets the path point
   -- CreateEntity("com_item_holocron", Holocron1Spawn, "holodisk") --spawns the disk
 
   EnableSPScriptedHeroes()
    
   
    --Start up Movie
    
    ScriptCB_PlayInGameMovie("ingame.mvs", "tanmon01")
    --ScriptCB_PlayInGameMovie("ingame.mvs", "tan1h00")
    

    -- Setting Up Music Region Triggers 

    ActivateRegion("techroommus")
    MusicTriggerTechRoom = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            TechRoomMus() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("techroommus")
        end
    end,
    "techroommus"
    )

    ActivateRegion("OPENSPAWN")
    MusicTriggerTechRoom = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            SettingOpenSpawn() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("OPENSPAWN")
        end
    end,
    "OPENSPAWN"
    )
    
    -- Creating Path Triggers --
    
    Trigger01 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            TriggerPath1() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("trigger01")
        end
    end,
    "trigger01"
    )
    
    Trigger02 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            TriggerPath2() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("trigger02")
        end
    end,
    "trigger02"
    )
    
    Trigger03 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            TriggerPath3() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("trigger03")
        end
    end,
    "trigger03"
    )
    
    Trigger04 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            TriggerPath4() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("trigger04")
        end
    end,
    "trigger04"
    )
    
    Trigger04 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            ScriptCB_SndPlaySound("TAN_obj_07")
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("turbinevo")
        end
    end,
    "turbinevo"
    )
    
    Trigger06 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            MapRemoveEntityMarker("CP4_OBJ")
            DeactivateRegion("goto2")
        end
    end,
    "goto2"
    )
    
    ScriptCB_SetSpawnDisplayGain(0.2, 0.5)
    
    --Setup Timer-- 
    timePop = CreateTimer("timePop")
    SetTimerValue(timePop, 0.3)
    
    doorunlock = CreateTimer("doorunlock")
    SetTimerValue(doorunlock, 1.7)

    --Setup Objective 1
    onfirstspawn = OnCharacterSpawn(
        function(character)
            if IsCharacterHuman(character) then
                ReleaseCharacterSpawn(onfirstspawn)
                onfirstspawn = nil
                --StartObjectives()
                ScriptCB_PlayInGameMusic("imp_tan_amb_obj1_explore")
                StartTimer(timePop)
                OnTimerElapse(
                    function(timer)
                        StartObjectives()
                        ScriptCB_EnableCommandPostVO(0)
                        ScriptCB_SndPlaySound("TAN_obj_01")
                        DestroyTimer(timer)
                    end,
                timePop
                )
                
                StartTimer(doorunlock)
                OnTimerElapse(
                    function(timer)
--                      SetProperty("blastdoor", "IsLocked", 0)
--                      SetUnitCount(IMP, 12)
                        SetSpawnDelay(11.2, 1.1)
                        KillObject("blastdoor")
                        SetProperty("CP3_OBJ", "SpawnPath", "CP3_OBJ_SPAWN")
                        Ambush("ambush1", ambushCount3, ambushTeam3)
                    end,
                doorunlock
                )
                
                --BeginObjectives()
             end
        end)

    Objective1CP = CommandPost:New{name = "CP2_OBJ"}
    Objective1 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.tan1.objectives.1", popupText = "level.tan1.objectives.pop.1"}
    Objective1:AddCommandPost(Objective1CP)
    
    Objective1.OnStart = function(self) 
        SetProperty("blastdoor", "IsLocked", 1)   
        SetProperty("lpodroom1", "IsLocked", 1)
        SetProperty("lpodroom2", "IsLocked", 1)
        SetProperty("lpodroom3", "IsLocked", 1)
        SetProperty("rpodroom1", "IsLocked", 1)
        SetProperty("rpodroom2", "IsLocked", 1)
        SetProperty("conference1", "IsLocked", 1)
        SetProperty("engine01", "IsLocked", 1)
        SetProperty("techroom1", "IsLocked", 1)
        SetProperty("techroom2", "IsLocked", 1)
        SetProperty("blasteng1", "IsLocked", 1)
        SetProperty("blasteng2", "IsLocked", 1)
        SetProperty("blastbar1", "IsLocked", 1)
        
        --Setting CPs Invisible
        
        SetProperty("CP1_OBJ", "IsVisible", 0)
        SetProperty("CP3_OBJ", "IsVisible", 0)
        SetProperty("CP5_OBJ", "IsVisible", 0)
        SetProperty("CP4_OBJ", "IsVisible", 0)
        
        BlockPlanningGraphArcs("group1")
        BlockPlanningGraphArcs("group2")
        BlockPlanningGraphArcs("group3")
        BlockPlanningGraphArcs("group4")
        BlockPlanningGraphArcs("group5")
        
        
        AICanCaptureCP("CP2_OBJ", ATT, false)
        SetProperty("CP3_OBJ", "AISpawnWeight", "200")
    end
    
  --this stuff runs when the objective is completed 
    Objective1.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
        SetSpawnDelay(10.0, 0.25)
        ATT_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATT_ReinforcementCount + 10)
        --KillObject("bardoor1")
        --KillObject("bardoor2")
        --KillObject("bardoor3")
--        ScriptCB_PlayInGameMovie("ingame.mvs", "tan1h01")
        SetProperty("techroom1", "IsLocked", 0)
        SetProperty("techroom2", "IsLocked", 0)
        
        SetProperty("CP2_OBJ", "captureRegion", "CP2_OBJ_DISTRACTION")
        SetProperty("CP2_OBJ", "SpawnPath", "CP2_OBJ_SPAWN2")
        SetObjectTeam("CP2_OBJ", 1)
        --SetProperty("tan4_bldg_turbine_base", "Attacheffect", "com_inf_rechargedroid_exp")
        UnblockPlanningGraphArcs("group1")
        UnlockHeroForTeam(1)
        SetObjectTeam("CP3_OBJ", 0)
        SetObjectTeam("CP5_OBJ", 2)
        ActivateRegion("goto1")
    end
    
    goto1 = ObjectiveGoto:New{teamATT = ATT, teamDEF = DEF, text = "level.tan1.objectives.goto1", popupText = "level.tan1.objectives.pop.goto1", regionName = "goto1"}
    
 
    goto1.OnStart = function(self)
        SetObjectTeam("CP2_OBJ", 1)
        ScriptCB_SndPlaySound("TAN_obj_16")
        ScriptCB_PlayInGameMusic("imp_tan_amb_obj2_explore")
        --local intromovie = CreateTimer("intromovie")
        --OnTimerElapse(IntroMovieDone, intromovie)
        --SetTimerValue(intromovie, 1.0)
        --StartTimer(intromovie)
        MapAddEntityMarker("mainframe01", "hud_objective_icon", 3.0, 1, "YELLOW", true)
        --ShowMessageText("level.kas2.objectives.1c", ATT)
    end
    
    goto1.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
        MapRemoveEntityMarker("mainframe01")
    end
        --setup objective 2 - Assault
    --
    
    
    MainframeString = "level.tan1.objectives.2-"
    Mainframe01 = Target:New{name = "mainframe01"}
    Mainframe02 = Target:New{name = "mainframe02"}
    Mainframe03 = Target:New{name = "mainframe03"}
    Mainframe04 = Target:New{name = "mainframe04"}
    Mainframe05 = Target:New{name = "mainframe05"}
    Mainframe06 = Target:New{name = "mainframe06"}
    Mainframe07 = Target:New{name = "mainframe07"}
    Mainframe08 = Target:New{name = "mainframe08"}  

    Objective2 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, text = "level.tan1.objectives.2", popupText = "level.tan1.objectives.pop.2"}
    Objective2:AddTarget(Mainframe01)
    Objective2:AddTarget(Mainframe02)
    Objective2:AddTarget(Mainframe03)
    Objective2:AddTarget(Mainframe04)
    Objective2:AddTarget(Mainframe05)
    Objective2:AddTarget(Mainframe06)
    Objective2:AddTarget(Mainframe07)
    Objective2:AddTarget(Mainframe08)
    
    Objective2.OnSingleTargetDestroyed = function(self, target)
        local numTargets = self:GetNumSingleTargets()
        if numTargets > 0 then
            ShowMessageText(MainframeString .. (numTargets + 1), 1)
        end
        
        if numTargets == 4 then
            ScriptCB_SndPlaySound("TAN_inf_01")
        end
    end

    
    Objective2.OnStart = function(self)
        --local intromovie = CreateTimer("intromovie")
        --OnTimerElapse(IntroMovieDone, intromovie)
        --SetTimerValue(intromovie, 1.0)
        --StartTimer(intromovie)
        ScriptCB_SndPlaySound("TAN_obj_05")
        ScriptCB_PlayInGameMusic("imp_tan_amb_action_01")
        --ScriptCB_SndBusFade("voiceover", 0.0, 0.0)
    end
    
    function IntroMovieDone(timer)
        -- remove the intro timer hack
        DestroyTimer(timer)
        --ScriptCB_SndBusFade("voiceover", 1.0, 0.0)
        --ScriptCB_SndPlaySound("TAN_obj_04")
    end
    
    Objective2.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
        ATT_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATT_ReinforcementCount + 10)
        SetProperty("blasteng1", "IsLocked", 0)
        SetProperty("blasteng2", "IsLocked", 0)
        SetProperty("conference1", "IsLocked", 0)
        UnblockPlanningGraphArcs("group2")
        DisableBarriers("barracks")
        SetProperty("blastbar1", "IsLocked", 0)
        ActivateRegion("trigger01")
        
        -- Setup Spawn path til end of misison 
        SetObjectTeam("CP6_OBJ", 2)
        SetProperty("CP6_OBJ", "AISpawnWeight", "2000")
        SetProperty("CP6_OBJ", "SpawnPath", "CP6_OBJ_TRIGGER01")
        
        SetObjectTeam("CP4_OBJ", 2)
        SetObjectTeam("CP5_OBJ", 0)
        
        if self.winningTeam == DEF then
            ScriptCB_SndPlaySound("TAN_obj_08")
        else
            --play the win sound
            ScriptCB_SndPlaySound("TAN_obj_06")
            ScriptCB_PlayInGameMusic("imp_tan_objComplete_01")
             -- Music Timer -- 
         music01Timer = CreateTimer("music01")
        SetTimerValue(music01Timer, 14.0)
                              
            StartTimer(music01Timer)
            OnTimerElapse(
                function(timer)
                ScriptCB_StopInGameMusic("imp_tan_objComplete_01")
                ScriptCB_PlayInGameMusic("imp_tan_amb_codes_retrieve")
                DestroyTimer(timer)
            end,
            music01Timer
        ) 
        end
        
              -- TEMP spawn Holodisk   
        Holocron1Spawn = GetPathPoint("codespawn", 0) --gets the path point
        CreateEntity("tan4_icon_disk", Holocron1Spawn, "holodisk") --spawns the disk
--        SetProperty("holodisk", "CarriedGeometryName", "tan4_icon_disk")
        SetProperty("holodisk", "AllowAIPickUp", 0)
        Ambush("conference", ambushCount3, ambushTeam3)
    end
   
    
    --Turbine Stuff
    
    --Objective3.OnStart = function(self)
        --ScriptCB_SndPlaySound("TAN_obj_05")
    --end
    
--    Turbine_count= 1
--    
--    Turbine = Target:New{name = "Turbine_generator"}
--    Objective3 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, text = "level.tan1.objectives.3"}
--    Objective3:AddTarget(Turbine)
--    
--    Turbine.OnDestroy = function(self)
--        ShowMessageText("You Destroyed the Turbine!", team)
--        RemoveRegion("turbinedeath")
--        PauseAnimation("Turbine Animation")
----        UnblockPlanningGraphArcs("group4")
--        SetProperty("engine01", "IsLocked", 0)
--        --ScriptCB_SndPlaySound("TntvIV_inf_03")
--    end
--    
--    --Objective3.OnComplete = function(self)
--            --Holocron1Spawn = GetPathPoint("codespawn", 0) --gets the path point
--            --CreateEntity("com_item_holocron", Holocron1Spawn, "holodisk") --spawns the disk
--    --end
       
    --Objective 5 Stuff
    

        
    Objective5 = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 1, 
                                text = "level.tan1.objectives.5", showTeamPoints = false,
                                popupText = "level.tan1.objectives.pop.5",
                                AIGoalWeight = 0.0}
        
    Objective5:AddFlag{name = "holodisk", captureRegion = "accesscode",
            capRegionMarker = "all_icon", capRegionMarkerScale = 3.0, 
            mapIcon = "flag_icon", mapIconScale = 2.0}
            
    Objective5.OnStart = function (self)
        MapAddEntityMarker("CP4_OBJ", "hud_objective_icon", 3.0, ATT, "YELLOW", true)
        ActivateRegion("turbinevo")
        ActivateRegion("goto2")
        --rather than have the AI in CTF mode, just put them in Deathmatch mode for this goal
        Objective5.dmGoal1 = AddAIGoal(ATT, "Deathmatch", 100)
        Objective5.dmGoal2 = AddAIGoal(DEF, "Deathmatch", 100)
        Objective5.ctfGoal1 = AddAIGoal(ATT, "Defend", 100, "holodisk")
        Objective5.ctfGoal2 = AddAIGoal(DEF, "Defend", 300, "holodisk")
        plans_capture_on = OnFlagPickUp(
        function(flag, carrier)
            if IsCharacterHuman(carrier) then
                MapAddEntityMarker("CP3_OBJ", "hud_objective_icon", 3.0, ATT, "YELLOW", true)
                ShowMessageText("level.tan1.objectives.capreturn")
                ScriptCB_SndPlaySound("TAN_obj_10")
                ScriptCB_PlayInGameMusic("imp_tan_amb_codes_return")
            end
        end,
        "holodisk"
        )
    end
    
    Objective5.OnComplete = function (self)
        --clean up the goals that we assigned to the AI
        ShowMessageText("game.objectives.complete", ATT)
        ATT_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATT_ReinforcementCount + 10)
        DeleteAIGoal(Objective5.dmGoal1)
        DeleteAIGoal(Objective5.dmGoal2)
        DeleteAIGoal(Objective5.ctfGoal1)
        DeleteAIGoal(Objective5.ctfGoal2)
        SetProperty("CP6_OBJ", "SpawnPath", "CP6_OBJ_SPAWN")
        SetProperty("CP6_OBJ", "AISpawnWeight", "300")
        
        if self.winningTeam == DEF then
            ScriptCB_SndPlaySound("TAN_obj_13")
        else
            --play the win sound
            ScriptCB_SndPlaySound("TAN_obj_12")
            ScriptCB_PlayInGameMusic("imp_tan_objComplete_02")
             -- Music Timer -- 
         music02Timer = CreateTimer("music02")
        SetTimerValue(music02Timer, 17.0)
                              
            StartTimer(music02Timer)
            OnTimerElapse(
                function(timer)
                ScriptCB_StopInGameMusic("imp_tan_objComplete_02")
                ScriptCB_PlayInGameMusic("imp_tan_immVict_01")
                DestroyTimer(timer)
            end,
            music02Timer
                        ) 
        end
        
    end
          
    
    
    
    --End of Assault Stuff
    
    --Start of Leia
    
    Objective4= ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, text = "level.tan1.objectives.4", popupText = "level.tan1.objectives.pop.4"}
    
    Objective4.OnStart = function (self)
        MapRemoveEntityMarker("CP3_OBJ")
        --MapRemoveClassMarker("all_hero_leia")
        SetAIDamageThreshold("all_hero_leia", 0.8)
        SetObjectTeam("CP4_OBJ", 0)
        SetObjectTeam("CP6_OBJ", 2)
        UnblockPlanningGraphArcs("group3")
        SetProperty("rpodroom2", "IsLocked", 0)
        SetProperty("rpodroom1", "IsLocked", 0)
        SetProperty("lpodroom1", "IsLocked", 0)
        SetProperty("lpodroom2", "IsLocked", 0)
        SetProperty("lpodroom3", "IsLocked", 0)
        
          -- add Leia as a new unit
        
        local characterindex = GetTeamMember(4, 0)
        BatchChangeTeams(4, DEF, 1)
        SetHeroClass(ALL, "all_hero_leia")
        local classindex = AddUnitClass(DEF, "all_hero_leia", 1, 1)
        SelectCharacterClass(characterindex, classindex)
        SpawnCharacter(characterindex, GetPathPoint("leia_spawn", 0)) 
    end  
  
    Princess = TargetType:New{classname = "all_hero_leia", killLimit = 1, iconScale = 0.0}
    Objective4:AddTarget(Princess)
    
    Objective4.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
--        ScriptCB_PlayInGameMovie("ingame.mvs", "tan1h02")
        ScriptCB_SndPlaySound("TAN_obj_17")
    end
    
-- VO for low reinforcements -- 
    OnTicketCountChange(
        function (team, count)
            if team == ATT and count == 35 then             
                ScriptCB_SndPlaySound("rep_off_com_report_us_overwhelmed")
            elseif team == DEF and count == 10 then
                --play DEF is low on reinforce sound
            end
        end
        )
        
        
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

function StartObjectives()    
    objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 3.0}
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:AddObjectiveSet(goto1)
    objectiveSequence:AddObjectiveSet(Objective2)
    --objectiveSequence:AddObjectiveSet(Objective3)
    objectiveSequence:AddObjectiveSet(Objective5)
    objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:Start()
end

-- Music Trigger Functions 
 
  function TechRoomMus()
            -- ShowMessageText("level.tan1.objectives.4", 1)
 end
 
  function SettingOpenSpawn()
        SetProperty("CP3_OBJ", "SpawnPath", "CP3_OBJ_SPAWN")
  end
  
  function TriggerPath1()
        SetProperty("CP6_OBJ", "SpawnPath", "CP6_OBJ_TRIGGER02")
        ActivateRegion("trigger02")
  end
  
  function TriggerPath2()
        SetProperty("CP6_OBJ", "SpawnPath", "CP6_OBJ_TRIGGER03")
        ActivateRegion("trigger03")
        Ambush("snipethis", ambushCount2, ambushTeam2)
  end
  
  function TriggerPath3()
        SetProperty("CP6_OBJ", "SpawnPath", "CP3_OBJ_SPAWN")
        ActivateRegion("trigger04") 
  end
  
  function TriggerPath4()
        SetProperty("CP6_OBJ", "SpawnPath", "CP5_OBJ_SPAWN")
        --ActivateRegion("trigger04")   
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

function DoorKill()
    SetProperty("engine01", "IsLocked", 0)
end 

 function ScriptInit()
     -- Designers, these two lines *MUST* be first!
     SetPS2ModelMemory(4500000)
     ReadDataFile("ingame.lvl")
     SetWorldExtents(1064.5)
     
     ReadDataFile("sound\\tan.lvl;tan1gcw")

     --SetMaxFlyHeight(43)
     --SetMaxPlayerFlyHeight (43)
    AISnipeSuitabilityDist(30)

     ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman_fleet",
                    "all_inf_rocketeer_fleet",
                    "all_inf_sniper_fleet",
                    "all_hero_leia")
                    
     ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_officer",
                    "imp_inf_sniper",
                    "imp_inf_engineer",
                    "imp_inf_dark_trooper",
                    "imp_hero_darthvader")
                    --"imp_hover_speederbike",
                    --"imp_walk_atst_jungle",
                    
    SetupTeams{

        all={
            team = ALL,
            units = 14,
            reinforcements = -1,
            soldier = {"all_inf_rifleman_fleet"},
            assault = {"all_inf_rocketeer_fleet"},
            sniper  = {"all_inf_sniper_fleet"},
            
            
        },
        
        imp={
            team = IMP,
            units = 12,
            reinforcements = 60,
            soldier = {"imp_inf_rifleman"},
            assault = {"imp_inf_rocketeer"},
            engineer = {"imp_inf_engineer"},
            sniper  = {"imp_inf_sniper"},
            officer = {"imp_inf_officer"},
            special = {"imp_inf_dark_trooper"},
        }
    }


-- Hero Setup -- 

         SetHeroClass(IMP, "imp_hero_darthvader")
         --SetHeroClass(ALL, "all_hero_leia")
         
    AddUnitClass(ambushTeam2, "all_inf_sniper_fleet")
        SetUnitCount(ambushTeam2, ambushCount2)
    SetTeamAsEnemy(ambushTeam2, IMP)
    SetTeamAsEnemy(IMP, ambushTeam2)
    SetTeamAsFriend(ambushTeam2, ALL)
    SetTeamAsFriend(ALL, ambushTeam2)
    ClearAIGoals(ambushTeam2)
    AddAIGoal(ambushTeam2, "Deathmatch", 100)
    
    AddUnitClass(ambushTeam3, "all_inf_rifleman_fleet")
        SetUnitCount(ambushTeam3, ambushCount3)
    SetTeamAsEnemy(ambushTeam3, IMP)
    SetTeamAsEnemy(IMP, ambushTeam3)
    SetTeamAsFriend(ambushTeam3, ALL)
    SetTeamAsFriend(ambushTeam3, ambushTeam2)
    SetTeamAsFriend(ambushTeam2, ambushTeam3)
    SetTeamAsFriend(ALL, ambushTeam3)
    ClearAIGoals(ambushTeam3)
    AddAIGoal(ambushTeam3, "Deathmatch", 100)
     
     --Adding Leia Pool
     AddUnitClass(4, "imp_inf_rifleman", 1)
       SetUnitCount(4, 2)

     --  Level Stats
     ClearWalkers()
     --    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(1, 3) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
     --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
     SetMemoryPoolSize("FlagItem", 1)
     SetMemoryPoolSize("Obstacle", 200)
     SetMemoryPoolSize("EntityFlyer", 6)
     SetMemoryPoolSize("SoundSpaceRegion", 15)
     SetMemoryPoolSize("Weapon", 260)

     SetSpawnDelay(10.0, 0.25)
     ReadDataFile("tan\\tan1.lvl", "tan1_obj")
     SetDenseEnvironment("false")
     AddDeathRegion("deathregion")
     --AddDeathRegion("turbinedeath")
     --AddDeathRegion("deathregion")
     --SetStayInTurrets(1)


     --  Movies
     --  SetVictoryMovie(ALL, "all_end_victory")
     --  SetDefeatMovie(ALL, "imp_end_victory")
     --  SetVictoryMovie(IMP, "imp_end_victory")
     --  SetDefeatMovie(IMP, "all_end_victory")

     --  Sound
    voiceSlow = OpenAudioStream("sound\\global.lvl", "tan_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow) 
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "imp_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "all_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl",  "global_vo_quick", voiceQuick)

     OpenAudioStream("sound\\global.lvl",  "gcw_music")
     -- OpenAudioStream("sound\\tan.lvl",  "tan_objective_vo_slow")
     -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
     OpenAudioStream("sound\\tan.lvl",  "tan1")
     OpenAudioStream("sound\\tan.lvl",  "tan1")
     -- OpenAudioStream("sound\\tan.lvl",  "tan1_emt")

     SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
     SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
     SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
     SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

     SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
     SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
     SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
     SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

     SetOutOfBoundsVoiceOver(2, "allleaving")
     SetOutOfBoundsVoiceOver(1, "impleaving")

     -- SetAmbientMusic(ALL, 1.0, "all_tan_amb_start",  0,1)
     -- SetAmbientMusic(ALL, 0.99, "all_tan_amb_middle", 1,1)
     -- SetAmbientMusic(ALL, 0.1,"all_tan_amb_end",    2,1)
     -- SetAmbientMusic(IMP, 1.0, "ImpTan01_StartLevel",  0,1)
     -- SetAmbientMusic(IMP, 0.93, "ImpTan01_ExpAmb1", 1,1)
     -- SetAmbientMusic(IMP, 0.1,"imp_tan_amb_end",    2,1)

     --SetVictoryMusic(ALL, "all_tan_amb_victory")
     --SetDefeatMusic (ALL, "all_tan_amb_defeat")
     SetVictoryMusic(IMP, "imp_tan_amb_victory")
     SetDefeatMusic (IMP, "imp_tan_amb_defeat")

     SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
     SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
     --  SetSoundEffect("BirdScatter",         "birdsFlySeq1")
     SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
     SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
     SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
     SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
     SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

     SetAttackingTeam(ATT)


    AddCameraShot(0.233199, -0.019441, -0.968874, -0.080771, -240.755920, 11.457644, 105.944176);
    AddCameraShot(-0.395561, 0.079428, -0.897092, -0.180135, -264.022278, 6.745873, 122.715752);
    AddCameraShot(0.546703, -0.041547, -0.833891, -0.063371, -309.709900, 5.168304, 145.334381);
    
 end

