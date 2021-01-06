    --
    -- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
    --

    -- load the gametype script

        ScriptCB_DoFile("LinkedShields")
        ScriptCB_DoFile("ObjectiveCTF")
        ScriptCB_DoFile("ObjectiveConquest")
        ScriptCB_DoFile("ObjectiveAssault")
        ScriptCB_DoFile("MultiObjectiveContainer")
        ScriptCB_DoFile("setup_teams")
        ScriptCB_DoFile("Ambush")    

        IMP = 1
        ALL = 2
        AMB = 3
    --  These variables do not change
        ATT = 1
        DEF = 2
 
 


 
 
function ScriptPostLoad()

    ForceAIOutOfVehicles(2, true)
    ForceAIOutOfVehicles(3, true)
    SetAIDifficulty(1, -3, "medium") 
    SetupShields()
    ScriptCB_SetGameRules("campaign")
    SetMissionEndMovie("ingame.mvs", "polmon02")

    DisableAIAutoBalance()    

    SetProperty ("DataBank","Team",0)

	SetAIDamageThreshold("DataBank", 1)
	
	SetProperty ("DataBank","MaxHealth",999999)
	SetProperty ("DataBank","CurHealth",999999)
    	
    	
    onfirstspawn = OnCharacterSpawn( 
        function(character)
            if IsCharacterHuman(character) then
            	ReleaseCharacterSpawn(onfirstspawn)
                onfirstspawn = nil
                objectives_timer = CreateTimer("objectives_timer")
                SetTimerValue(objectives_timer, 2)
                StartTimer(objectives_timer)
                begin_objectives = OnTimerElapse(
                    function(timer)
                        StartObjectives ()
                        ScriptCB_EnableCommandPostVO(0)
                        ScriptCB_SndPlaySound("pol_obj_02")
                        ScriptCB_PlayInGameMusic("imp_pol_amb_obj1_explore")
                    end,
                    objectives_timer
                    )
            end
        end
        )
 
-- Kill cps
    KillObject ("CP2Camp") 
    KillObject ("CP1Camp") 
    KillObject ("CP5Camp") 
    
    DisableBarriers("Barrier485")
    DisableBarriers("Barrier486")
    DisableBarriers("Barrier487") 

    ScriptCB_PlayInGameMovie("ingame.mvs","polmon01")

    
--   Capture Objective 1 ------------------------------------------------------------- 



    Objective1CP = CommandPost:New{name = "CP4Camp", hideCPs = false}
    Objective1 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.pol1.objectives.Campaign.1", popupText = "level.pol1.objectives.Campaign.1_popup"}
    Objective1:AddCommandPost(Objective1CP) 

    Objective1.OnStart = function (self)
         -- need to make the cp1 invisible?
        --SetProperty ("CP3Camp","Value_ATK_Alliance",0)
        --SetProperty ("CP3Camp","Value_DEF_Empire",0)
        SetProperty ("cavern_dock", "ClassAllDEF", "")
        SetAIDamageThreshold("DataBank",1)
        SetProperty ("CP4Camp", "SpawnPath", "Radar_Ambush")
        --SetupAmbushTrigger("CP4CaptureCamp", "Radar_Ambush", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_10", "Radar_Ambush", 9, AMB) 
        
        SetupAmbushTrigger("ambush_trigger_3", "ambush_path_3", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_4", "ambush_path_4", 4, AMB) 
        SetupAmbushTrigger("ambush_trigger_1", "ambush_path_8", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_5", "ambush_path_5", 4, AMB) 
        SetupAmbushTrigger("ambush_trigger_2", "ambush_path_2", 9, AMB) 
        
        
        SetProperty ("CP4Camp", "AISpawnWeight", 100)
        AICanCaptureCP("CP4Camp", DEF, true)
        AICanCaptureCP("CP4Camp", ATT, false)
        AICanCaptureCP("CP3Camp", DEF, false)
        AICanCaptureCP("CP3Camp", AMB, false)

        DefGoal = AddAIGoal (DEF, "Defend", 1, "CP4Camp")
        AttGoal = AddAIGoal (ATT, "Conquest", 1, "CP4Camp")
        AmbGoal = AddAIGoal (AMB, "Defend", 1, "CP4Camp")
        
        --ScriptCB_SndPlaySound("pol_obj_02")
    end
    
    Objective1.OnComplete = function (self)
        DeleteAIGoal(DefGoal)
        DeleteAIGoal(AttGoal)
        DeleteAIGoal(AmbGoal)

        SetProperty ("CP4Camp", "SpawnPath", "CP4SpawnPathCamp")
        OBJ1_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, OBJ1_ReinforcementCount + 40)
        
		SetProperty ("CP4Camp","Team", self.winningTeam)
		AICanCaptureCP("CP4Camp", DEF, false)
		AICanCaptureCP("CP4Camp", AMB, false)
		ShowMessageText("game.objectives.complete", ATT)
        	
		if self.winningTeam == self.teamDEF then 
			BroadcastVoiceOver("pol_obj_08")
        end
    end

--   Aquire Objective 2 -------------------------------------------------------------

    

--  Objective2.OnStart = function (self)
--      ShowMessageText("level.pol1.objectives.campaign.2", ATT)
--  end

    Objective2 = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 1, text = "level.pol1.objectives.campaign.2", popupText = "level.pol1.objectives.campaign.2_popup"}

    Objective2:AddFlag{name = "pol_icon_disk", captureRegion = "CP4CaptureCamp",
            capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
            mapIcon = "flag_icon", mapIconScale = 2.0}

    Objective2.OnStart = function (self)
--      SetProperty ("CP3Camp", "Team", 1)    
--      SetProperty ("CP3Camp","Value_ATK_Alliance",0)
--      SetProperty ("CP3Camp","Value_DEF_Alliance",0)
--      SetProperty ("CP3Camp","Value_DEF_Empire",0)
--      SetProperty ("CP3Camp","Value_ATK_Empire",0)
--      SetProperty ("CP1Camp","Value_DEF_Alliance",10)
--      SetProperty ("CP1Camp","Value_DEF_Alliance",10)

        SetProperty ("CP3Camp", "CaptureRegion", "fakecapture")

            disk_capture_on = OnFlagPickUp( 
        function(flag, carrier)
            if IsCharacterHuman(carrier) then
                --ShowMessageText("level.dea1.objectives.campaign.4_pickup", ATT)
                MapAddEntityMarker("CP4Camp", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true)
                ScriptCB_PlayInGameMusic("imp_pol_amb_holodisk_return")
            end
        end,
        "pol_icon_disk"
        )
        
        disk_capture_off = OnFlagDrop(
            function(flag, carrier)
                if IsCharacterHuman(carrier) then
                    MapRemoveEntityMarker("CP4Camp")
                    --ShowMessageText("level.dea1.objectives.campaign.4_drop", ATT)             
                end
            end,
            "pol_icon_disk"
            )    
        SetAIDamageThreshold("DataBank",1)
        SetProperty ("CP4Camp", "AISpawnWeight", 100)
        SetProperty ("CP1Inviso", "AISpawnWeight", 100)

        SetupAmbushTrigger("ambush_trigger_1", "ambush_path_8", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_2", "ambush_path_2", 9, AMB) 
        
        
        SetupAmbushTrigger("ambush_trigger_3", "ambush_path_3", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_4", "ambush_path_4", 4, AMB) 
        SetupAmbushTrigger("ambush_trigger_1", "ambush_path_8", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_5", "ambush_path_5", 4, AMB) 
        SetupAmbushTrigger("ambush_trigger_7", "ambush_path_7", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_10", "ambush_path_10", 9, AMB) 

        SetProperty ("CP4Camp", "Team", 1)
        AICanCaptureCP("CP4Camp", DEF, false)
        AICanCaptureCP("CP4Camp", ATT, true)
        AICanCaptureCP("CP3Camp", DEF, false)
        AICanCaptureCP("CP3Camp", AMB, false)

        ScriptCB_SndPlaySound("pol_obj_01")
        
        DEFGoal = AddAIGoal (DEF, "Defend" , 100, "pol_icon_disk")
        ATTGoal1 = AddAIGoal (ATT, "Defend" , 50, "pol_icon_disk")
        ATTGoal2 = AddAIGoal (ATT, "Defend" , 50, "CP4Camp")
        
        AMBGoal = AddAIGoal (AMB, "Deathmatch", 1)
        -- spawn Holodisk   
        Holocron1Spawn = GetPathPoint("HolodiskSpawn", 0) --gets the path point
        CreateEntity("pol_icon_disk", Holocron1Spawn, "pol_icon_disk") --spawns the disk
        SetProperty ("pol_icon_disk", "AllowAIPickUp", 0)
        ScriptCB_PlayInGameMusic("imp_pol_objComplete_01")
         -- Music Timer -- 
         music01Timer = CreateTimer("music01")
        SetTimerValue(music01Timer, 32.0)
                              
            StartTimer(music01Timer)
            OnTimerElapse(
                function(timer)
                ScriptCB_StopInGameMusic("imp_pol_objComplete_01")
                ScriptCB_PlayInGameMusic("imp_pol_amb_pol_icon_disk_retrieve")
                DestroyTimer(timer)
            end,
            music01Timer
                    )       
        end
    Objective2.OnComplete = function (self)
        ScriptCB_PlayInGameMusic("imp_pol_amb_holodisk_return")
        DeleteAIGoal(DEFGoal)
        DeleteAIGoal(ATT1Goal)
        DeleteAIGoal(ATT2Goal)
        DeleteAIGoal(AMBGoal)
        ReleaseFlagPickUp(disk_capture_on)
        ReleaseFlagDrop(disk_capture_off)
        OBJ2_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, OBJ2_ReinforcementCount + 40)
        ShowMessageText("game.objectives.complete", ATT)
        if self.winningTeam == self.teamDEF then 
            BroadcastVoiceOver("pol_obj_08")
            --ShowMessageText("your team lost localize")
        end 
    end

--  Defend Objective 3 --------------------------------------------------------


        Objective3CP = CommandPost:New{name = "CP4Camp", hideCPs = false}
        Objective3 = ObjectiveConquest:New{teamATT = DEF, teamDEF = ATT, textDEF = "level.pol1.objectives.Campaign.3", popupText = "level.pol1.objectives.Campaign.3_popup", timeLimit = 120, timeLimitWiningTeam = ATT}
        Objective3:AddCommandPost(Objective3CP)
    

    Objective3.OnStart = function (self)
    
    AmbushGoal = AddAIGoal (AMB,"Conquest", 100, "CP4Camp")
        ATTGoal = AddAIGoal (ATT,"Defend", 100, "CP4Camp")
    
        MapAddEntityMarker("CP4Camp", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true)             
        SetAIDamageThreshold("DataBank",1)
        
        SetProperty ("CP4Camp", "AISpawnWeight", 100)
        SetProperty ("CP1Inviso", "AISpawnWeight", 100)
        SetProperty ("CP3Camp", "Team", 1)
        ScriptCB_SndPlaySound("pol_obj_04")
        ScriptCB_PlayInGameMusic("imp_pol_amb_action_01")
        
        SetProperty ("CP4Camp", "Team", 1)
        AICanCaptureCP("CP4Camp", DEF, true)
        AICanCaptureCP("CP4Camp", AMB, true)
        AICanCaptureCP("CP3Camp", DEF, false)
        AICanCaptureCP("CP3Camp", AMB, false)
        AICanCaptureCP("CP4Camp", ATT, false)
        Ambush("Radar_Ambush", 6, AMB)

        SetupAmbushTrigger("ambush_trigger_3", "ambush_path_3", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_4", "ambush_path_4", 4, AMB) 
        SetupAmbushTrigger("ambush_trigger_5", "ambush_path_5", 4, AMB) 
        SetupAmbushTrigger("ambush_trigger_7", "ambush_path_7", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_8", "ambush_path_7", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_2", "ambush_path_2", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_10", "ambush_path_10", 9, AMB) 



        RadarAmbushTimer = CreateTimer("RadarAmbushTimer")
        SetTimerValue(RadarAmbushTimer, 60)
        StartTimer(RadarAmbushTimer)
        ReflectingPoolAmbush = OnTimerElapse(
            function (timer) 
                ReflectingPoolAmbush2 = Ambush("Radar_Ambush", 6, AMB)
            end,
            RadarAmbushTimer
            )
        end
    
    
    Objective3.OnComplete = function (self)
        MapRemoveEntityMarker("CP4Camp")
        
        OBJ3_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, OBJ3_ReinforcementCount + 45)
        DeleteAIGoal(AmbushGoal)
        DeleteAIGoal(ATTGoal)
        BlockPlanningGraphArcs (1)
        EnableBarriers("Barrier485")
        EnableBarriers("Barrier486")
        EnableBarriers("Barrier487")
        --SetProperty ("pol1_prop_door4","IsLocked", 1) 
        RespawnObject ("CP5Camp")
        
        --make sure the CP has the correct team and generally stays that way
        SetProperty ("CP4Camp", "Team", self.winningTeam)
        AICanCaptureCP("CP4Camp", ATT, false)
        AICanCaptureCP("CP4Camp", DEF, false)
        AICanCaptureCP("CP4Camp", AMB, false)
        
        if self.winningTeam == self.teamATT then 
            BroadcastVoiceOver("pol_obj_08") 	
        end 
    end


--  Assault objective 4 -------------------------------------------------------
    

    --      object_count = 1 
            databank = Target:New{name = "DataBank"}
    
    --  databank.OnDestroy = function(self, objectPtr)
    --      object_count = object_count - 1 
    --      ShowMessageText("level.pol1.objectives.campaign.2b" .. object_count, 1)
    --  end

    Objective4 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, text = "level.pol1.objectives.Campaign.4", popupText = "level.pol1.objectives.Campaign.4_popup"}
    Objective4:AddTarget(databank)
    
    Objective4.OnStart = function (self)
    -- make cp1 capturable and visable
        --ForceAIOutOfVehicles(2, false)
        --ForceAIOutOfVehicles(3, false)
        
        --SetProperty ("CP4Camp", "CaptureRegion", "fakecapture2")
        SetProperty ("CP4Camp", "SpawnPath", "FinalPush")

        --KillObject ("CP1Inviso")
        --RespawnObject ("CP1Camp")

        SetAIDamageThreshold("DataBank",1)
	SetProperty ("DataBank","MaxHealth",2000)
        SetProperty ("DataBank","CurHealth",2000)

        --SetProperty ("CP1Camp", "Team", ATT)
        
        SetProperty ("CP4Camp", "AISpawnWeight", 100)
        SetProperty ("CP5Camp", "AISpawnWeight", 50)
        SetProperty ("CP1Inviso", "AISpawnWeight", 50)
        
        SetProperty ("cavern_dock", "ClassAllDEF", "all_hover_combatspeeder")
       
        SetProperty ("CP3Camp", "CaptureRegion", "CP3CaptureCamp")

        SetupAmbushTrigger("ambush_trigger_3", "ambush_path_3", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_4", "ambush_path_4", 4, AMB) 
        SetupAmbushTrigger("ambush_trigger_1", "ambush_path_1", 4, AMB) 
        SetupAmbushTrigger("ambush_trigger_1", "ambush_path_8", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_2", "ambush_path_2", 9, AMB) 
        
        SetupAmbushTrigger("ambush_trigger_5", "ambush_path_5", 4, AMB) 
        SetupAmbushTrigger("ambush_trigger_7", "ambush_path_7", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_8", "ambush_path_7", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_2", "ambush_path_2", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_10", "ambush_path_10", 9, AMB) 

        --ambush = AddAIGoal (AMB, "Deathmatch",100)

        RespawnObject ("CP5Camp")
        --AICanCaptureCP("CP4Camp", DEF, false)
        AICanCaptureCP("CP5Camp", ATT, false)
        --AICanCaptureCP ("CP4Camp", AMB, false)
        AICanCaptureCP("CP3Camp", DEF, true)
        AICanCaptureCP("CP3Camp", AMB, true)
        DEFDefendGoal = AddAIGoal (DEF, "Defend", 50, "DataBank")
        DEFCaptureGoal = AddAIGoal (DEF, "Conquest", 50, "CP3Camp")
        AMBDefendGoal = AddAIGoal (AMB, "Defend",50, "DataBank")
        AMBCaptureGoal = AddAIGoal (AMB, "Conquest",50, "CP3Camp")
        
        ATTDefendGoal = AddAIGoal (ATT, "Defend", 50, "CP5Camp")
        ScriptCB_SndPlaySound("pol_obj_05")
        ScriptCB_PlayInGameMusic("imp_pol_objComplete_02")
             music02Timer = CreateTimer("music02")
         SetTimerValue(music02Timer, 12.0)
                              
            StartTimer(music02Timer)
            OnTimerElapse(
                function(timer)
                ScriptCB_StopInGameMusic("imp_pol_objComplete_02")
                ScriptCB_PlayInGameMusic("imp_pol_amb_obj4_explore")
                DestroyTimer(timer)
            end,
            music02Timer
                        ) 
    end
    
    Objective4.OnComplete = function (self)
    
    
        DeleteAIGoal(DEFDefendGoal)
        DeleteAIGoal(DEFconquestGoal)
        DeleteAIGoal(AMBDefendGoal)
        DeleteAIGoal(AMBConquestGoal)

        DeleteAIGoal(ATTDefendGoal)
        --DeleteAIGoal (ATTCaptureGoal)
		ShowMessageText("game.objectives.complete", ATT)

        --DeleteAIGoal(Ambush)
        OBJ4_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, OBJ4_ReinforcementCount + 55)
        if self.winningTeam == self.teamDEF then 
            BroadcastVoiceOver("pol_obj_08")
            --ShowMessageText("your team lost localize")
        end 
    end
--  Capture Objective 5 ---------------------------------------------------------

    
    
    
    Objective5CP = CommandPost:New{name = "CP3CAMP", hideCPs = false}
    Objective5 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.pol1.objectives.Campaign.5", popupText = "level.pol1.objectives.Campaign.5_popup"}
    Objective5:AddCommandPost(Objective5CP) 
    
    Objective5.OnStart = function (self)
        SetupAmbushTrigger("ambush_trigger_3", "ambush_path_3", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_4", "ambush_path_4", 4, AMB) 
        SetupAmbushTrigger("ambush_trigger_1", "ambush_path_8", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_5", "ambush_path_5", 4, AMB) 
        SetupAmbushTrigger("ambush_trigger_7", "ambush_path_7", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_8", "ambush_path_7", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_2", "ambush_path_2", 9, AMB) 
        SetupAmbushTrigger("ambush_trigger_10", "ambush_path_10", 9, AMB) 

        SetProperty ("CP3Camp","Team",2)
        SetProperty ("CP4Camp", "SpawnPath", "FinalPush")

        SetProperty ("CP4Camp", "AISpawnWeight", 100)
        SetProperty ("CP3Camp", "AISpawnWeight", 100)

        AICanCaptureCP("CP3Camp", AMB, true)
        AICanCaptureCP("CP3Camp", DEF, true)
        AICanCaptureCP("CP3Camp", ATT, false)
        
        AICanCaptureCP ("CP4Camp", AMB, false)
        AICanCaptureCP("CP4Camp", DEF, false)
        AICanCaptureCP("CP5Camp", ATT, false)
        
        

        
        
        ambush = AddAIGoal (AMB, "Defend",100, "CP3Camp")
        attackers = AddAIGoal (ATT, "Conquest", 100, "CP3Camp")
        def = AddAIGoal (DEF, "Defend", 100, "CP3Camp")
        
        
        
        ScriptCB_SndPlaySound("pol_obj_06")
        ScriptCB_PlayInGameMusic("imp_pol_immVict_01")
        UnblockPlanningGraphArcs (1)
        DisableBarriers("Barrier485")
        DisableBarriers("Barrier486")
        DisableBarriers("Barrier487")
    end
      
    Objective5.OnComplete = function(self)
        DeleteAIGoal(ambush)
        DeleteAIGoal(attackers)
        DeleteAIGoal(def)
		SetProperty ("CP3Camp", "Team", self.winningTeam)
		AICanCaptureCP("CP3Camp", ATT, true)
		AICanCaptureCP("CP3Camp", DEF, false)
		AICanCaptureCP("CP3Camp", AMB, false)
		ShowMessageText("game.objectives.complete", ATT)
        	
        if self.winningTeam == self.teamDEF then 
            BroadcastVoiceOver("pol_obj_08")
        elseif self.winningTeam == self.teamATT then
            BroadcastVoiceOver("pol_obj_07")
            --ShowMessageText("your team lost localize") 
        end
    end

    
    
    
end        
--  This creates the objective "container" and specifies order of objectives, and gets that shit running            
    
    function StartObjectives() 
	  objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 10.0 }
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:AddObjectiveSet(Objective2)
    objectiveSequence:AddObjectiveSet(Objective3)
    objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:AddObjectiveSet(Objective5)
    objectiveSequence:Start()
   
end
 
function SetupShields()
    -- POL Shielded objects    
    linkedShieldObjectsPOL = { "pol1_prop_health_shield", "pol1_prop_hanger_shield", "pol1_prop_cavern_shield"}
    shieldStuffPOL = LinkedShields:New{objs = linkedShieldObjectsPOL, maxShield = 999999, addShield = 999999,
                                              controllerObject = "shields"}
    shieldStuffPOL:Init()
end
 
 --------------------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
----------------------------------------------------------------------------------------
 
 
 function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(4100000)
    --EnableSPHeroRules()
    SetMapNorthAngle(0)
   -- SetMaxFlyHeight(25)
     --SetMaxPlayerFlyHeight (25)
    AISnipeSuitabilityDist(30)
    
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\pol.lvl;pol1gcw")
        ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman_urban",
                    "all_inf_rocketeer",
                    "all_inf_engineer",
                    "all_inf_sniper",
                    "all_inf_officer",
                    "all_inf_wookiee",
                    "all_hover_combatspeeder")
                
                                
                
     ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_officer",
                    "imp_inf_dark_trooper")                 
                    

    ReadDataFile("SIDE\\tur.lvl", 
                "tur_bldg_laser")          

   -- set up teams
    SetupTeams{
        imp = {
            team = IMP,
            units = 24,
            reinforcements = 70,
            soldier  = { "imp_inf_rifleman",8, 16},
            assault  = { "imp_inf_rocketeer",4, 6},
            engineer = { "imp_inf_engineer",3, 4},
            sniper   = { "imp_inf_sniper",1, 4},
            officer = {"imp_inf_officer",1, 4},
            special = { "imp_inf_dark_trooper",2, 4},
            
        },
        all = {
            team = ALL,
            units = 10,
            reinforcements = -1,
           soldier  = { "all_inf_rifleman_urban",4, 6},
            assault  = { "all_inf_rocketeer",2, 2},
            engineer = { "all_inf_engineer",1, 2},
            sniper   = { "all_inf_sniper",1, 2},
            officer = {"all_inf_officer",1, 4},
            special = { "all_inf_wookiee",1, 4},
        }
    }
    
         SetupTeams{
        all = {
            team = AMB,
    
            units = 30,
            reinforcements = 0,
            assault  = { "all_inf_rocketeer",8,15},
            sniper   = { "all_inf_rifleman_urban",8,15},
            special = { "all_inf_wookiee",8,15},
        }
     }

    SetTeamAsEnemy(DEF, ATT)
    SetTeamAsEnemy(ATT, DEF)
    SetTeamAsEnemy(ATT, AMB)
    SetTeamAsEnemy(AMB, ATT)
    
    SetTeamAsFriend(AMB, DEF)
    SetTeamAsFriend(DEF, AMB)
    
    
    
    --SetHeroClass(ALL, "all_hero_leia")
    
    --SetHeroClass(IMP, "imp_hero_darthvader")
     
     
     --  Level Stats
     ClearWalkers()
    --      AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
    --      AddWalkerType(1, 0) -- 8 droidekas (special case: 0 leg pairs)
    --      AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
    --      AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponCnt = 360
    SetMemoryPoolSize ("Aimer", 50)
    SetMemoryPoolSize ("AmmoCounter", weaponCnt)
    SetMemoryPoolSize ("BaseHint", 280)
    SetMemoryPoolSize ("EnergyBar", weaponCnt)
    SetMemoryPoolSize ("EntityCloth", 24)
    SetMemoryPoolSize ("EntityFlyer", 4)   
    SetMemoryPoolSize ("EntityHover",3)
    SetMemoryPoolSize ("EntityLight", 70)
    SetMemoryPoolSize ("FlagItem", 1)
    SetMemoryPoolSize ("MountedTurret",16)
    SetMemoryPoolSize ("Obstacle", 400)
    SetMemoryPoolSize ("PathNode", 512)
    SetMemoryPoolSize ("ShieldEffect", 0)
    SetMemoryPoolSize ("SoundSpaceRegion", 34)
    SetMemoryPoolSize("EntitySoundStatic", 9)      
    SetMemoryPoolSize ("TentacleSimulator", 20)
    SetMemoryPoolSize ("TreeGridStack", 200)
    SetMemoryPoolSize ("Weapon", weaponCnt)

    SetMemoryPoolSize ("Asteroid", 100)
    
     SetSpawnDelay(10.0, 0.25)
     ScriptCB_SetSpawnDisplayGain(0.2, 0.5) 
     ReadDataFile("pol\\pol1.lvl","pol1_Campaign")
     SetDenseEnvironment("true")   
     AddDeathRegion("deathregion1")
 -- SetStayInTurrets(1)

--asteroids start!
SetParticleLODBias(3000)
SetMaxCollisionDistance(1500)
--    FillAsteroidPath("pathas01", 10, "pol1_prop_asteroid_01", 20, 1.0,0.0,0.0, -1.0,0.0,0.0);
--    FillAsteroidPath("pathas01", 20, "pol1_prop_asteroid_02", 40, 1.0,0.0,0.0, -1.0,0.0,0.0);
--    FillAsteroidPath("pathas02", 10, "pol1_prop_asteroid_01", 10, 1.0,0.0,0.0, -1.0,0.0,0.0);
--    FillAsteroidPath("pathas03", 10, "pol1_prop_asteroid_02", 20, 1.0,0.0,0.0, -1.0,0.0,0.0);
--    FillAsteroidPath("pathas04", 5, "pol1_prop_asteroid_02", 2, 1.0,0.0,0.0, -1.0,0.0,0.0);      

-- asteroids end!
    
     --  Movies
     --  SetVictoryMovie(ALL, "all_end_victory")
     --  SetDefeatMovie(ALL, "imp_end_victory")
     --  SetVictoryMovie(IMP, "imp_end_victory")
     --  SetDefeatMovie(IMP, "all_end_victory")

     --  Sound
     
    voiceSlow = OpenAudioStream("sound\\global.lvl", "pol_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow) 
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "imp_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "all_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl",  "global_vo_quick", voiceQuick)   
     
     OpenAudioStream("sound\\global.lvl",  "gcw_music")
     -- OpenAudioStream("sound\\pol.lvl",  "pol_objective_vo_slow")
     -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
     OpenAudioStream("sound\\pol.lvl",  "pol1")
     OpenAudioStream("sound\\pol.lvl",  "pol1")
     -- OpenAudioStream("sound\\pol.lvl",  "pol1gcw_emt")

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

     -- SetAmbientMusic(ALL, 1.0, "all_pol_amb_start",  0,1)
     -- SetAmbientMusic(ALL, 0.99, "all_pol_amb_middle", 1,1)
     -- SetAmbientMusic(ALL, 0.1,"all_pol_amb_end",    2,1)
     -- SetAmbientMusic(IMP, 1.0, "imp_pol_amb_start",  0,1)
     -- SetAmbientMusic(IMP, 0.99, "imp_pol_amb_middle", 1,1)
     -- SetAmbientMusic(IMP, 0.1,"imp_pol_amb_end",    2,1)

     SetVictoryMusic(ALL, "all_pol_amb_victory")
     SetDefeatMusic (ALL, "all_pol_amb_defeat")
     SetVictoryMusic(IMP, "imp_pol_amb_victory")
     SetDefeatMusic (IMP, "imp_pol_amb_defeat")

     SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
     SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
     --  SetSoundEffect("BirdScatter",         "birdsFlySeq1")
     SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
     SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
     SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
     SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
     SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

     SetAttackingTeam(ATT)



    AddCameraShot(0.461189, -0.077838, -0.871555, -0.147098, 85.974007, 30.694353, -66.900795);
    AddCameraShot(0.994946, -0.100380, -0.002298, -0.000232, 109.076401, 27.636383, -10.235785);
    AddCameraShot(0.760383, 0.046402, 0.646612, -0.039459, 111.261696, 27.636383, 46.468048);
    AddCameraShot(-0.254949, 0.066384, -0.933546, -0.243078, 73.647552, 32.764030, 50.283028);
    AddCameraShot(-0.331901, 0.016248, -0.942046, -0.046116, 111.003563, 28.975283, 7.051458);
    AddCameraShot(0.295452, -0.038140, -0.946740, -0.122217, 19.856682, 36.399086, -9.890361);
    AddCameraShot(0.958050, -0.115837, -0.260254, -0.031467, -35.103737, 37.551651, 109.466576);
    AddCameraShot(-0.372488, 0.036892, -0.922789, -0.091394, -77.487892, 37.551651, 40.861832);
    AddCameraShot(0.717144, -0.084845, -0.686950, -0.081273, -106.047691, 36.238495, 60.770439);
    AddCameraShot(0.452958, -0.104748, -0.862592, -0.199478, -110.553474, 40.972584, 37.320778);
    AddCameraShot(-0.009244, 0.001619, -0.984956, -0.172550, -57.010258, 30.395561, 5.638251);
    AddCameraShot(0.426958, -0.040550, -0.899315, -0.085412, -87.005966, 30.395561, 19.625088);
    AddCameraShot(0.153632, -0.041448, -0.953179, -0.257156, -111.955055, 36.058708, -23.915501);
    AddCameraShot(0.272751, -0.002055, -0.962055, -0.007247, -117.452736, 17.298250, -58.572723);
    AddCameraShot(0.537097, -0.057966, -0.836668, -0.090297, -126.746666, 30.472836, -148.353333);
    AddCameraShot(-0.442188, 0.081142, -0.878575, -0.161220, -85.660973, 29.013374, -144.102219);
    AddCameraShot(-0.065409, 0.011040, -0.983883, -0.166056, -84.789032, 29.013374, -139.568787);
    AddCameraShot(0.430906, -0.034723, -0.898815, -0.072428, -98.038002, 47.662624, -128.643265);
    AddCameraShot(-0.401462, 0.047050, -0.908449, -0.106466, 77.586563, 47.662624, -147.517365);
    AddCameraShot(-0.269503, 0.031284, -0.956071, -0.110983, 111.260330, 16.927542, -114.045715);
    AddCameraShot(-0.338119, 0.041636, -0.933134, -0.114906, 134.970169, 26.441256, -82.282082);

end
