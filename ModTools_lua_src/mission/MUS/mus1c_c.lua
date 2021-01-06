-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("ObjectiveGoto")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("Ambush")

--  These variables do not change
ATT = 1;
DEF = 2;
--  impublic Attacking (attacker is always #1)
IMP = 1;
CIS = 2;
SNIPERS = 3;
AMBUSH1 = 4;
AMBUSH2 = 5;
BODYGUARDS = 6;
BOSS = 7;



function ScriptPostLoad()
    SetMissionEndMovie("ingame.mvs", "musmon02")
    SetAIDifficulty(0, -3, "medium")
    SetAIDamageThreshold("Power02", 0.2)
    SetAIDamageThreshold("Power03", 0.2)
    --SetAIDamageThreshold("panel", 0.6)
    
    SetProperty("cam_cp1", "HUDIndex", 1)
    SetProperty("cam_cp3", "HUDIndex", 2)
    SetProperty("cam_cp6", "HUDIndex", 3)
    SetProperty("cam_cp2", "HUDIndex", 4)
    
    
    SetProperty("cam_cp9", "HUDIndexDisplay", 0)
    SetProperty("cam_cp8", "HUDIndexDisplay", 0)
    SetProperty("cam_cp4", "HUDIndexDisplay", 0)
    ScriptCB_SetGameRules("campaign")
    ScriptCB_PlayInGameMovie("ingame.mvs", "musmon01")  
    LockDown()
    LetsGO()
    SetProperty("fix", "MaxHealth", 99999999999)
    SetProperty("fix", "CurHealth", 99999999999)
    PlayAnimDrop()  
    EnableSPHeroRules()
    OnObjectKillName(Shortcut, "panel");
    
   

  
    
    onfirstspawn = OnCharacterSpawn(
    function(character)
        if IsCharacterHuman(character) then
            ScriptCB_PlayInGameMusic("rep_mus_amb_obj2_4_explore")
            ReleaseCharacterSpawn(onfirstspawn)
            onfirstspawn = nil
            AddAIGoal(AMBUSH2, "Deathmatch", 300)   
            Ambush("boo", 6, AMBUSH2)
            ObjStart_timer = CreateTimer("ObjStart_timer")
            SetTimerValue(ObjStart_timer, 3)
            StartTimer(ObjStart_timer)
            CountDown = OnTimerElapse(
            function()
                ClearAIGoals(ATT)
                ClearAIGoals(DEF)
                BeginObjectives() 
                ReleaseTimerElapse(CountDown)
                AddAIGoal(DEF, "Defend", 100, "cam_cp1")
                AddAIGoal(ATT, "Defend", 900, "fix")
            end,
            ObjStart_timer
            )
        end
    end)
  

    --GoToRegion
 
  
   
    -- Objective 2 -Conquest- Capture the Control Room CP
    cp3 = CommandPost:New{name = "cam_cp3"}
    --This sets up the actual objective.  This needs to happen after cps are defined
    Objective2 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, popupText = "level.mus1.objectives.campaign.2_popup", text = "level.mus1.objectives.campaign.1"}
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    Objective2:AddCommandPost(cp3)
     
    
    Objective2.OnStart = function(self) 
        AICanCaptureCP("cam_cp3", ATT, false)
        MapAddEntityMarker("cam_cp3", "hud_objective_icon", 3.0, ATT, "YELLOW", true, true, true) 
        SetProperty("cam_cp2", "IsCollidable", "1")
        SetProperty("cam_cp2", "IsVisible", "1")        
        AddAIGoal(DEF, "Defend", 300, "cam_cp3")
        ScriptCB_EnableCommandPostVO(0)
        
        --set up VO stuff
        ScriptCB_SndPlaySound("MUS_obj_01")
        vo1_timer = CreateTimer("vo1_timer")
        SetTimerValue(vo1_timer, 10)
        StartTimer(vo1_timer)
        playvo1 = OnTimerElapse(
            function()
                BroadcastVoiceOver("MUS_obj_25", ATT)
                ReleaseTimerElapse(playvo1)
                
            end,
            vo1_timer
            )   
    end     
        
    Objective2.OnComplete = function(self) 
        PlayAnimRise()
        --make the panel repairable     
        --MapAddEntityMarker("fix", "hud_objective_icon", 3.0, ATT, "YELLOW", true, true, true) 
        --SetProperty("fix", "MaxHealth", 150) 
        --SetProperty("fix", "CurHealth", 150) 
        
        ShowMessageText("level.geo1.objectives.campaign.complete", ATT)     
        ATTReinforce = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATTReinforce + 20)       
    
        SetProperty("cam_cp3", "SpawnPath", "Jump")
        SetProperty("cam_cp3", "CaptureRegion", "Temp_Untake")
        MapRemoveEntityMarker("cam_cp3") 
        
        KillObject("cam_cp1")
        RespawnObject("cam_cp6")    
        MapAddEntityMarker("cam_cp6", "hud_objective_icon", 3.0, ATT, "YELLOW", true, true, true)
        SetProperty("cam_cp6", "IsVisible", "1") 
        
        AddAIGoal(ATT, "Defend", 900, "fix")
        AddAIGoal(DEF, "Defend", 100, "cam_cp3")
        AddAIGoal(DEF, "Conquest", 300)     
        MapRemoveEntityMarker("dummy1")
        SetProperty("cam_cp6", "team", 2)
        SetProperty("cam_cp6", "SpawnPath", "cam_spawn4x")
        SetProperty("cam_cp6", "CaptureRegion", "balc")
        AddAIGoal(ATT, "Deathmatch", 900)
        --SetProperty("cam_cp4", "team", 3)
        --SetProperty("cam_cp4", "SpawnPath", "sniper")
        Ambush("sniper", 4, SNIPERS)
        AddAIGoal(SNIPERS, "Deathmatch", 900)
        
        ClearAIGoals(ATT)
        ClearAIGoals(DEF)
        
        --make sure the CP stays in friendly hands after the objective
        SetProperty("cam_cp3", "Team", self.winningTeam)
		AICanCaptureCP("cam_cp3", 3, false)
		AICanCaptureCP("cam_cp3", 4, false)
		AICanCaptureCP("cam_cp3", 5, false)
		AICanCaptureCP("cam_cp3", 6, false)
		AICanCaptureCP("cam_cp3", 7, false)
        
        if self.winningTeam == self.teamDEF then 
          	BroadcastVoiceOver("MUS_obj_06")
        end
     end
   
     --GoToRegion 

   
    Objective4 = Objective:New{teamATT = ATT, teamDEF = DEF, popupText = "level.mus1.objectives.campaign.3_popup", text = "level.mus1.objectives.campaign.B"}

    
    Objective4.OnStart = function(self)
        ScriptCB_SndPlaySound("MUS_obj_10")
            vo2_timer = CreateTimer("vo2_timer")
            SetTimerValue(vo2_timer, 7)
            StartTimer(vo2_timer)
            playvo2 = OnTimerElapse(
                function()
                    BroadcastVoiceOver("MUS_inf_02", ATT)
                    ReleaseTimerElapse(playvo2)
                    DestroyTimer(vo2_timer)
                    
                end,
                vo2_timer
                )
        
        Objective4.gotogoal8 = AddAIGoal(BODYGUARDS, "Deathmatch", 900)
        Objective4.gotogoal9    =   AddAIGoal(ATT, "conquest", 900)
        Objective4.gotogoal10 = AddAIGoal(DEF, "Defend", 100, "cam_cp3")
        Objective4.gotogoal11 = AddAIGoal(DEF, "Conquest", 300)

            
    end    
    Objective4.OnComplete = function(self)
        if self.winningTeam == self.teamDEF then 
          BroadcastVoiceOver("MUS_obj_06")
        elseif self.winningTeam == self.teamATT then
        ScriptCB_SndPlaySound("MUS_obj_21")  
        ShowMessageText("level.geo1.objectives.campaign.complete", ATT)
        end
    end
    
    
     -- Objective 1 -Conquest- Capture the Control Room CP
    cp6 = CommandPost:New{name = "cam_cp6"}
    --This sets up the actual objective.  This needs to happen after cps are defined
    Objective6 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, popupText = "level.mus1.objectives.campaign.6_popup", text = "level.mus1.objectives.campaign.1Ca"}
   --This adds the CPs to the objective.  This needs to happen after the objective is set up
    Objective6:AddCommandPost(cp6)
    
    
    Objective6.OnStart = function(self)
        SetProperty("cam_cp6", "SpawnPath", "hallspawn")
        AICanCaptureCP("cam_cp6", ATT, false)
        ScriptCB_SndPlaySound("MUS_obj_14")
        vo3_timer = CreateTimer("vo3_timer")
        SetTimerValue(vo3_timer, 4)
        StartTimer(vo3_timer)
        playvo3 = OnTimerElapse(
            function()
                BroadcastVoiceOver("MUS_inf_03", ATT)
                ReleaseTimerElapse(playvo3)
                
            end,
            vo3_timer
            )
        vo4_timer = CreateTimer("vo4_timer")
        SetTimerValue(vo4_timer, 6)
        StartTimer(vo4_timer)
        playvo4 = OnTimerElapse(
            function()
                BroadcastVoiceOver("MUS_obj_11", ATT)
                ReleaseTimerElapse(playvo4)
                
            end,
            vo4_timer
            )
     vo5_timer = CreateTimer("vo5_timer")
        SetTimerValue(vo5_timer, 9)
        StartTimer(vo5_timer)
        playvo5 = OnTimerElapse(
            function()
                BroadcastVoiceOver("MUS_inf_04", ATT)
                ReleaseTimerElapse(playvo5)
                
            end,
            vo5_timer
            )
      AddAIGoal(DEF, "defend", 900, "cam_cp3")  
   
    end     
        
    Objective6.OnComplete = function(self)
		--make sure the CP stays in friendly hands after the objective
		SetProperty("cam_cp6", "Team", self.winningTeam)
		AICanCaptureCP("cam_cp6", 3, false)
		AICanCaptureCP("cam_cp6", 4, false)
		AICanCaptureCP("cam_cp6", 5, false)
		AICanCaptureCP("cam_cp6", 6, false)
		AICanCaptureCP("cam_cp6", 7, false)
		
        if self.winningTeam == self.teamDEF then 
          	BroadcastVoiceOver("MUS_obj_06")
        elseif self.winningTeam == self.teamATT then
        	ScriptCB_PlayInGameMusic("rep_mus_amb_obj6_8_explore")        	
        end
        ShowMessageText("level.geo1.objectives.campaign.complete", ATT)
        SetProperty("cam_cp3", "AISpawnWeight", 0)
        SetProperty("cam_cp6", "SpawnPath", "cam_spawn4x")
        SetProperty("cam_cp6", "AISpawnWeight", 900)
        SetProperty("cam_cp1", "AISpawnWeight", 0)
        SetProperty("cam_cp6", "CaptureRegion", "Temp_Untake")
        ATTReinforce = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATTReinforce + 25)
        RespawnObject("cam_cp2")
        SetProperty("cam_cp2", "Team", 2)
        ClearAIGoals(ATT)
        ClearAIGoals(DEF)
        SetProperty("mus1_prop_door_garage5", "IsLocked", "0")
        MapRemoveEntityMarker("cam_cp6")
    end
    
      
    Objective7 = ObjectiveGoto:New{teamATT = ATT, teamDEF = DEF, popupText = "level.mus1.objectives.campaign.7_popup", text = "level.mus1.objectives.campaign.D", regionName = "2collect", mapIcon = nil}
    
    Objective7.OnStart = function(self)
        ScriptCB_SndPlaySound("MUS_obj_12")
        AddAIGoal(ATT, "Conquest", 600)
        AddAIGoal(ATT, "Defend", 500, "cam_cp2")
        AddAIGoal(DEF, "Defend", 500, "cam_cp6")
        AddAIGoal(DEF, "Conquest", 100)
        MapAddEntityMarker("cam_cp2", "hud_objective_icon", 3.0, ATT, "YELLOW", true, true, true)
    
    end

    Objective7.OnComplete = function(self)
        ShowMessageText("level.geo1.objectives.campaign.complete", ATT)
        ClearAIGoals(ATT)
        ClearAIGoals(DEF)
        if self.winningTeam == self.teamDEF then 
          BroadcastVoiceOver("MUS_obj_06")
        elseif self.winningTeam == self.teamATT then
          --BroadcastVoiceOver("")--victory
        end
    end    

    Objective8CP = CommandPost:New{name = "cam_cp2"}
        Objective8 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, popupText = "level.mus1.objectives.campaign.8_popup", text = "level.mus1.objectives.campaign.2"}
        Objective8:AddCommandPost(Objective8CP)
        
        Objective8.OnStart = function(self)
        AICanCaptureCP("cam_cp2", ATT, false)
        ScriptCB_SndPlaySound("MUS_obj_04")
        vo6_timer = CreateTimer("vo6_timer")
        SetTimerValue(vo6_timer, 9)
        StartTimer(vo6_timer)
        playvo6 = OnTimerElapse(
            function()
                --BroadcastVoiceOver("MUS_obj_04", ATT)
                ReleaseTimerElapse(playvo6)
                
            end,
            vo6_timer
            )
            AddAIGoal(ATT, "conquest", 600)
            AddAIGoal(ATT, "defend", 500, "cam_cp2")
    end       
        
    Objective8.OnComplete = function(self)
        KillObject("cam_cp3")
        ShowMessageText("level.geo1.objectives.campaign.complete", ATT)
        ATTReinforce = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATTReinforce + 20)
        MapRemoveEntityMarker("cam_cp2")
        SetProperty("cam_cp2", "CaptureRegion", "Temp_Untake")
        SetProperty("cam_cp2", "SpawnPath", "cam_spawn2")
            ClearAIGoals(ATT)
            ClearAIGoals(DEF)
        SetProperty("cam_cp3", "AISpawnWeight", 0)
        SetProperty("cam_cp6", "AISpawnWeight", 0)
        SetProperty("cam_cp2", "AISpawnWeight", 900)
        ScriptCB_SndPlaySound("MUS_obj_05")
        ScriptCB_PlayInGameMusic("rep_mus_objComplete_02")
         -- Music Timer -- 
         music02Timer = CreateTimer("music02")
        SetTimerValue(music02Timer, 10.0)
                              
            StartTimer(music02Timer)
            OnTimerElapse(
                function(timer)
                ScriptCB_StopInGameMusic("rep_mus_objComplete_02")
                ScriptCB_PlayInGameMusic("rep_mus_amb_obj10_12_explore")
                DestroyTimer(timer)
            end,
            music02Timer
                )  
        Recess()
        
		--make sure the CP stays in friendly hands after the objective
		SetProperty("cam_cp2", "Team", self.winningTeam)
		AICanCaptureCP("cam_cp2", 3, false)
		AICanCaptureCP("cam_cp2", 4, false)
		AICanCaptureCP("cam_cp2", 5, false)
		AICanCaptureCP("cam_cp2", 6, false)
		AICanCaptureCP("cam_cp2", 7, false)
			
        if self.winningTeam == self.teamDEF then 
          	BroadcastVoiceOver("MUS_obj_06")
        end
    end

    Objective9 = ObjectiveGoto:New{teamATT = ATT, teamDEF = DEF, popupText = "level.mus1.objectives.campaign.9_popup", text = "level.mus1.objectives.campaign.E", regionName = "Droid", mapIcon = nil}
    
    Objective9.OnStart = function(self)
            
            MapAddEntityMarker("Power01", "hud_objective_icon", 3.0, ATT, "YELLOW", true, true, true)
    end    
    
    Objective9.OnComplete = function(self)
            ShowMessageText("level.geo1.objectives.campaign.complete", ATT)
        MapRemoveEntityMarker("Power01")
        if self.winningTeam == self.teamDEF then 
          BroadcastVoiceOver("MUS_obj_06")
        elseif self.winningTeam == self.teamATT then
          --BroadcastVoiceOver("")--victory
        end
    end
    
    -- Objective 3 -Assualt- Destroy droid Prototypes
    
    
    Power02 = Target:New{name = "Power02"}
    Power02.OnDestroy = function(self)
        
    
        --ShowMessageText("level.mus1.objectives.campaign.3b", 1)
    end
    Power03 = Target:New{name = "Power03"}
    Power03.OnDestroy = function(self)
        
    
       -- ShowMessageText("level.mus1.objectives.campaign.3c", 1)
    end
  
    Objective10 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
                              popupText = "level.mus1.objectives.campaign.10_popup", text = "level.mus1.objectives.campaign.3"}

    Objective10:AddTarget(Power02)
    Objective10:AddTarget(Power03)

    
    Objective10.OnStart = function(self)
      
        ScriptCB_SndPlaySound("MUS_obj_27")
        SetReinforcementCount(AMBUSH2, 8)
        RespawnObject("cam_cp7")
        RespawnObject("cam_cp4")
        SetProperty("cam_cp7", "team", AMBUSH2)
        SetProperty("cam_cp4", "team", DEF)
        SetProperty("cam_cp4", "spawnpath", "cam_spawn3")
        
        SetProperty("cam_cp3", "AISpawnWeight", 100)
        SetProperty("cam_cp6", "AISpawnWeight", 0)
        SetProperty("cam_cp2", "AISpawnWeight", 100)
        SetProperty("cam_cp1", "AISpawnWeight", 0)
    end
    
    Objective10.OnComplete = function(self)
        
        ShowMessageText("level.geo1.objectives.campaign.complete", ATT)
        ATTReinforce = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATTReinforce + 20)
        SetReinforcementCount(AMBUSH2, 20)
        SetProperty("cam_cp4", "spawnpath", "ai_spawn4")
        SetProperty("cam_cp7", "spawnpath", "cam_spawn3")
        ShowMessageText("level.mus1.objectives.campaign.3g", ATT)
        bomblocation2 = GetPathPoint("bomb_spawn2", 0) --gets the path point
        CreateEntity("mus_flag_bomb", bomblocation2, "bomb2") --spawns the bomb
        -- SetProperty("bomb2", "captureRegion", "arm_r")
        SetProperty("bomb2", "AllowAIPickUp", 0) --makes the bomb unable to be picked up by friendlies
        SetProperty("cam_cp4", "spawnpath", "cam_spawn3")
        SetProperty("bomb2", "GeometryName", "mus_flag_bomb")
        SetProperty("bomb2", "CarriedGeometryName", "mus_icon_bomb_carried")
        if self.winningTeam == self.teamDEF then 
          BroadcastVoiceOver("MUS_obj_06")
        elseif self.winningTeam == self.teamATT then
          --BroadcastVoiceOver("")--victory
        end
    end
    
    Objective12 = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 1, popupText = "level.mus1.objectives.campaign.12_popup", text = "level.mus1.objectives.campaign.5"}
    Objective12:AddFlag{name = "bomb2", homeRegion = "b_home2", captureRegion = "arm_r",
        capRegionMarker = "hud_objective_icon", capRegionMarkerScale = 3.0, 
      icon = "", mapIcon = "flag_icon", mapIconScale = 2.0}     
    Objective12.OnStart = function(self)
        SetProperty("cam_cp4", "spawnpath", "ai_spawn4")--team 2
        SetReinforcementCount(AMBUSH2,12)
        SetProperty("cam_cp7", "spawnpath", "ai_spawn3")--5       
        SetProperty("cam_cp3", "AISpawnWeight", 100)
        SetProperty("cam_cp6", "AISpawnWeight", 0)
        SetProperty("cam_cp2", "AISpawnWeight", 100)
        SetProperty("cam_cp1", "AISpawnWeight", 0)
        
        ScriptCB_SndPlaySound("MUS_obj_13")
      
        RespawnObject("cam_cp8")
        SetProperty("cam_cp8", "team", AMBUSH1)
        
        plans_capture_on = OnFlagPickUp(
        function(flag, carrier)
            if IsCharacterHuman(carrier) then
                MapAddEntityMarker("cam_cp7", "hud_objective_icon", 4.0, ATT, "YELLOW", true)
                ScriptCB_SndPlaySound("MUS_obj_23")             
            end
        end,
        "bomb2"
        )
        
        plans_capture_off = OnFlagDrop(
        function(flag, carrier)
            if IsCharacterHuman(carrier) then
                MapRemoveEntityMarker("cam_cp7")
                ScriptCB_SndPlaySound("MUS_obj_22")             
            end
        end,
        "bomb2"
        )
    
        
    end
   
     Objective12.OnComplete = function(self)
     
        ShowMessageText("level.geo1.objectives.campaign.complete", ATT)
        ShowMessageText("level.mus1.objectives.campaign.5a", ATT)
        SetReinforcementCount(AMBUSH1, 5)   
        SetProperty("cam_cp8", "spawnpath", "ant3")
        MapRemoveEntityMarker("cam_cp7")
        ReleaseFlagPickUp(plans_capture_on)
        ReleaseFlagDrop(plans_capture_off)
        
        --create a cp for the agro geonocian's henchmen to spawn at
        SetReinforcementCount(BODYGUARDS, 20)
        
        SetProperty("cam_cp4", "Spawnpath", "geo")
        AddAIGoal(BODYGUARDS, "DeathMatch", 1)  
        if self.winningTeam == self.teamDEF then 
          BroadcastVoiceOver("MUS_obj_06")
        elseif self.winningTeam == self.teamATT then
          --BroadcastVoiceOver("")--victory     
        end
     end
     
  
    
     Objective13 = ObjectiveGoto:New{teamATT = ATT, teamDEF = DEF, popupText = "level.mus1.objectives.campaign.13_popup", text = "level.mus1.objectives.campaign.5escape", regionName = "geo"}
     
     Objective13.OnStart = function(self)
     --temp remove later
     Recess()
     SetProperty("cam_cp2", "team", 1)
     
     
        ScriptCB_SndPlaySound("MUS_obj_16") 
        SetProperty("cam_cp3", "AISpawnWeight", 0)
        SetProperty("cam_cp6", "AISpawnWeight", 0)
        SetProperty("cam_cp2", "AISpawnWeight", 900)
        SetProperty("cam_cp1", "AISpawnWeight", 0)
        AddAIGoal(ATT, "Deathmatch", 600)
        AddAIGoal(ATT, "Defend", 50, "cam_cp2") 
        AddAIGoal(DEF, "Defend", 100, "cam_cp2")
        AddAIGoal(DEF, "Deathmatch", 300)
        AddAIGoal(AMBUSH1, "Defend", 500, "cam_cp2")
        AddAIGoal(AMBUSH1, "Deathmatch", 100)       
        SetReinforcementCount(AMBUSH1, 5)
        MapAddEntityMarker("cam_cp8", "hud_objective_icon", 3.0, ATT, "YELLOW", true, true, true)
     end
     
     Objective13.OnComplete = function(self)
        SetProperty("cam_cp4", "team", BODYGUARDS)      
        ATTReinforce = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATTReinforce + 10)
        ShowMessageText("level.geo1.objectives.campaign.complete", ATT)
        ClearAIGoals(ATT)
        ClearAIGoals(DEF)
        ClearAIGoals(SNIPERS)
        ClearAIGoals(AMBUSH1)
        ClearAIGoals(AMBUSH2)
        ClearAIGoals(BOSS)
        AddAIGoal(AMBUSH2, "defend", 500, "cam_cp2")
        AddAIGoal(AMBUSH2, "deathmatch", 100)
        
        --ambush in the agro geonosian
        Ambush("geo2", 1, BOSS)
        AddAIGoal(BOSS, "Deathmatch", 100)
        local agroGeonosianIndex = GetTeamMember(BOSS, 0)       
        local agroGeonosianUnit = GetCharacterUnit( agroGeonosianIndex )
        SetAIDamageThreshold( agroGeonosianUnit, 0.6 )  --keep the AI's from killing the agro_geonosian
        AddAIGoal(BODYGUARDS, "Follow", 300, agroGeonosianIndex)    
            
        KillObject("cam_cp5")
        KillObject("cam_cp8")
        if self.winningTeam == self.teamDEF then 
          BroadcastVoiceOver("MUS_obj_06")
        elseif self.winningTeam == self.teamATT then
          --BroadcastVoiceOver("")--victory
        end
     end
  
  
  
  
    AGRO_count = 1 
    AGRO = TargetType:New{classname = "geo_inf_agro_geonosian", killLimit = 1} 
    
    Objective14 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
        popupText = "level.mus1.objectives.campaign.14_popup", textATT  = "level.mus1.objectives.campaign.6", textDEF = "Kill Everyone!",  AIGoalWeight = 0.0}
    Objective14:AddTarget(AGRO)   

    Objective14.OnStart = function(self)
        ScriptCB_PlayInGameMusic("rep_mus_act_01")
        ScriptCB_SndPlaySound("MUS_obj_17")
        ScriptCB_SndPlaySound("MUS_obj_18")
        AddAIGoal(DEF, "defend", 500, "cam_cp2")
        --AddAIGoal(DEF, "deathmatch", 100)
        AddAIGoal(ATT, "defend", 500, "cam_cp2")
    end
    
    Objective14.OnComplete = function(self)
        ScriptCB_SndPlaySound("MUS_obj_24")
        ShowMessageText("level.geo1.objectives.campaign.complete", ATT)
        SetProperty("cam_cp4", "team", 0)
        if self.winningTeam == self.teamDEF then 
          BroadcastVoiceOver("MUS_obj_06")
        elseif self.winningTeam == self.teamATT then
          --BroadcastVoiceOver("")--victory
           -- movie Timer -- 
         movie02Timer = CreateTimer("movie02")
        SetTimerValue(movie02Timer, 8)
                              
            StartTimer(movie02Timer)
            OnTimerElapse(
                function(timer)
                --ScriptCB_PlayInGameMovie("ingame.mvs", "musmon02")
                DestroyTimer(timer)
            end,
            movie02Timer
                )  
        end
    end
   
end

function BeginObjectives()  
    objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 6.0}

    objectiveSequence:AddObjectiveSet(Objective2)   
    --objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:AddObjectiveSet(Objective6)  
    objectiveSequence:AddObjectiveSet(Objective8)
    objectiveSequence:AddObjectiveSet(Objective10)        
    objectiveSequence:AddObjectiveSet(Objective12)
    objectiveSequence:AddObjectiveSet(Objective13)
    objectiveSequence:AddObjectiveSet(Objective14)
    objectiveSequence:Start() 
end
    
--START BRIDGEWORK!
-- OPEN 
function PlayAnimDrop()
    PauseAnimation("lava_bridge_raise");    
    RewindAnimation("lava_bridge_drop");
    PlayAnimation("lava_bridge_drop");
        
    -- prevent the AI from running across it
    BlockPlanningGraphArcs("Connection82");
    BlockPlanningGraphArcs("Connection83");
    EnableBarriers("Bridge");   
end

function Shortcut()
        SetProperty("hangardoor", "IsLocked", "0") 
        UnblockPlanningGraphArcs("Connection74")
        DisableBarriers("1")
end



function PlayAnimRise()
    PauseAnimation("lava_bridge_drop")
    RewindAnimation("lava_bridge_raise")
    PlayAnimation("lava_bridge_raise")
    
    
    --Objective4:Complete(ATT) 

    -- allow the AI to run across it
    UnblockPlanningGraphArcs("Connection82")
    UnblockPlanningGraphArcs("Connection83");
    DisableBarriers("Bridge")
end

function LockDown()
    BlockPlanningGraphArcs("Connection100");
    BlockPlanningGraphArcs("Connection101")
    BlockPlanningGraphArcs("Connection74")
    BlockPlanningGraphArcs("Connection75")
    EnableBarriers("1")
    EnableBarriers("hackdoor")
    --Control Room Setup
    SetProperty("hangardoor", "IsLocked", "1") 
    SetProperty("door_cont_1", "IsLocked", "1")
    SetProperty("door_cont_6", "IsLocked", "1")
    SetProperty("door_cont_3", "IsLocked", "1") 
    SetProperty("door_cont_4", "IsLocked", "1")
    SetProperty("door_cont_2", "IsLocked", "1")
    SetProperty("door_cont_7", "IsLocked", "1") 
    SetProperty("door_cont_8", "IsLocked", "1")
    SetProperty("door_cont_9", "IsLocked", "1")
    SetProperty("win2", "IsLocked", "1")
    SetProperty("window", "IsLocked", "1")
    BlockPlanningGraphArcs("Connection5")
    BlockPlanningGraphArcs("Connection23")
    BlockPlanningGraphArcs("Connection111")
    BlockPlanningGraphArcs("Connection75")
    BlockPlanningGraphArcs("Connection106")
    EnableBarriers("BALCONEY")
    EnableBarriers("bALCONEY2")
    EnableBarriers("hallway_f") 
    EnableBarriers("outside")
    SetProperty("mus1_prop_door_garage5", "IsLocked", "1")
end

function Recess()
    --Control Room Release
    UnblockPlanningGraphArcs("Connection75")
    UnblockPlanningGraphArcs("Connection100")
    UnblockPlanningGraphArcs("Connection101")
    SetProperty("door_cont_7", "IsLocked", "0") 
    SetProperty("door_cont_8", "IsLocked", "0")
    SetProperty("door_cont_9", "IsLocked", "0")
    SetProperty("door_cont_6", "IsLocked", "0")
    SetProperty("door_cont_1", "IsLocked", "0")
    SetProperty("door_cont_3", "IsLocked", "0") 
    SetProperty("door_cont_4", "IsLocked", "0")
    SetProperty("door_cont_2", "IsLocked", "0")
    SetProperty("win1", "IsLocked", "0") 
    SetProperty("win2", "IsLocked", "0")
    SetProperty("window", "IsLocked", "0")
    UnblockPlanningGraphArcs("Connection5")
    UnblockPlanningGraphArcs("Connection23")
    UnblockPlanningGraphArcs("Connection111")
    
    UnblockPlanningGraphArcs("Connection106")
    DisableBarriers("BALCONEY")
    DisableBarriers("bALCONEY2")
    DisableBarriers("hallway_f")
    DisableBarriers("hackdoor")
    DisableBarriers("outside")
end

function LetsGO()
    SetProperty("dummy", "IsCollidable", "0")
    SetProperty("dummy", "IsVisible", "0")
    
    SetProperty("dummy1", "IsCollidable", "0")
    SetProperty("dummy1", "IsVisible", "0")
    
    SetProperty("cam_cp2", "IsCollidable", "0")
    SetProperty("cam_cp2", "IsVisible", "0")
    
    SetProperty("cam_cp4", "IsCollidable", "0")
    SetProperty("cam_cp5", "IsVisible", "0")
    SetProperty("cam_cp8", "IsVisible", "0")
    SetProperty("cam_cp2", "Team", "0")
    SetProperty("cam_cp4", "Team", "0")
    SetProperty("cam_cp5", "Team", "0")
    
    KillObject("cam_cp2")
    KillObject("cam_cp4")
    KillObject("cam_cp5")
    KillObject("cam_cp6")
    KillObject("cam_cp7")
    KillObject("cam_cp8")

    SetProperty("left", "IsCollidable", "0")
    SetProperty("left", "IsVisible", "0")
    
    SetProperty("right", "IsCollidable", "0")
    SetProperty("right", "IsVisible", "0")
    
    SetProperty("right1", "IsCollidable", "0")
    SetProperty("right1", "IsVisible", "0")
    
    SetProperty("right2", "IsCollidable", "0")
    SetProperty("right2", "IsVisible", "0")
       
    SetProperty("prot01", "IsCollidable", "0")
    SetProperty("prot02", "IsCollidable", "0")
    SetProperty("prot03", "IsCollidable", "0")
    SetProperty("prot04", "IsCollidable", "0")
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
StealArtistHeap(256*1024)
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(3600000)
    ReadDataFile("ingame.lvl")



    ReadDataFile("sound\\mus.lvl;mus1cross")

    ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_dark_trooper",
                    "imp_inf_officer")
                    ----     "imp_bldg_defensegridturret")

    ReadDataFile("SIDE\\cis.lvl",
                  "cis_inf_rifleman",
                  "cis_inf_rocketeer",
                  "cis_inf_engineer",
                  "cis_inf_sniper",
                  "cis_inf_droideka",
                  "CIS_inf_officer")
                  --"cis_bldg_defensegridturret")

   ReadDataFile("SIDE\\geo.lvl",
                        "gen_inf_geonosian",
                        "geo_inf_agro_geonosian")

    
    ReadDataFile("SIDE\\tur.lvl",
                        "tur_bldg_chaingun_roof")   
    ScriptCB_SetSpawnDisplayGain(0.2, 0.5)
                                    
    SetAttackingTeam(ATT)
SetupTeams{
    imp = {
        team = IMP,
        units = 13,
        reinforcements = 40,
        soldier = { "imp_inf_rifleman"},
        assault = { "imp_inf_rocketeer"},
        engineer = { "imp_inf_engineer"},
        sniper  = { "imp_inf_sniper"},
        officer = { "imp_inf_officer"},
            special = { "imp_inf_dark_trooper"},

    },
    cis = {
        team = CIS,
        units = 10,
        reinforcements = -1,
        soldier = { "CIS_inf_rifleman",1,50},
        assault = { "CIS_inf_rocketeer",1},
        engineer = { "CIS_inf_engineer",1},
        sniper  = { "CIS_inf_sniper",1},
        officer = { "CIS_inf_officer",1},
            --special = { "cis_inf_droideka",0},

    },

}

    --this is the elite snipers that is ambushed in the lava walkway
    SetTeamName(SNIPERS, "cis")
    AddUnitClass(SNIPERS, "CIS_inf_sniper", 4)
    SetUnitCount(SNIPERS, 4)
    
    --non droidekka ambush team
    SetTeamName(AMBUSH1, "cis")
    AddUnitClass(AMBUSH1, "CIS_inf_rocketeer", 1)
    AddUnitClass(AMBUSH1, "CIS_inf_rifleman", 3,50) 
    AddUnitClass(AMBUSH1, "CIS_inf_engineer", 1)
    SetUnitCount(AMBUSH1, 6)    
    
    --ambush team front hallway
    SetTeamName(AMBUSH2, "cis")
    AddUnitClass(AMBUSH2, "CIS_inf_rocketeer",1,1)
    AddUnitClass(AMBUSH2, "CIS_inf_rifleman",3,30)
     AddUnitClass(AMBUSH2, "CIS_inf_engineer",1,1)
    AddUnitClass(AMBUSH2, "CIS_inf_droideka",1,1)
    SetUnitCount(AMBUSH2, 10)

    --geo bodyguards
    SetTeamName(BODYGUARDS, "locals")
    AddUnitClass(BODYGUARDS, "geo_inf_geonosian",2,10)  
    SetUnitCount(BODYGUARDS, 5)
    
    --agro geo BOSS
    SetTeamName(BOSS, "locals")
    AddUnitClass(BOSS, "geo_inf_agro_geonosian",1, 1)   --IMPORTANT: agro_geonosian must be the first class added to team BOSS and must have a min of 1, otherwise it'll break the objective
    SetUnitCount(BOSS, 1)
        
    
        
        --Ai choosing sides for dodgeball
        SetTeamAsFriend(SNIPERS, DEF)
        SetTeamAsFriend(BOSS, DEF)
        SetTeamAsFriend(AMBUSH2, DEF)
        SetTeamAsFriend(BODYGUARDS, DEF)
        SetTeamAsFriend(DEF, SNIPERS)
        SetTeamAsFriend(DEF, BOSS)
        SetTeamAsFriend(DEF, AMBUSH2)
        SetTeamAsFriend(DEF, BODYGUARDS)
        SetTeamAsFriend(SNIPERS, BOSS)
        SetTeamAsFriend(SNIPERS, AMBUSH2)
        SetTeamAsFriend(SNIPERS, BODYGUARDS)
        SetTeamAsFriend(BOSS, SNIPERS)
        SetTeamAsFriend(BOSS, AMBUSH2)
        SetTeamAsFriend(BOSS, BODYGUARDS)
        SetTeamAsFriend(AMBUSH2, SNIPERS)
        SetTeamAsFriend(AMBUSH2, BOSS)
        SetTeamAsFriend(AMBUSH2, BODYGUARDS) 
        SetTeamAsFriend(BODYGUARDS, SNIPERS)
        SetTeamAsFriend(BODYGUARDS, BOSS)
        SetTeamAsFriend(BODYGUARDS, AMBUSH2)
        SetTeamAsFriend(AMBUSH1, SNIPERS)
        SetTeamAsFriend(AMBUSH1, BOSS)
        SetTeamAsFriend(AMBUSH1, AMBUSH2)
        SetTeamAsFriend(AMBUSH1, BODYGUARDS)
        SetTeamAsFriend(AMBUSH1, DEF)
        SetTeamAsFriend(DEF, AMBUSH1)
        SetTeamAsFriend(SNIPERS, AMBUSH1)
        SetTeamAsFriend(AMBUSH2, AMBUSH1)
        SetTeamAsFriend(BODYGUARDS, AMBUSH1)
        SetTeamAsFriend(BOSS, AMBUSH1)
        
        SetSpawnDelayTeam(14.0, 3, DEF)
        SetSpawnDelayTeam(0.0, 0.0, BODYGUARDS)
    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 4)
    SetMemoryPoolSize("Aimer", 125)
    SetMemoryPoolSize("BaseHint", 100)
    SetMemoryPoolSize("EntitySoundStatic", 133)
    SetMemoryPoolSize("FlagItem", 1) 
    SetMemoryPoolSize("MountedTurret",13)
    SetMemoryPoolSize("Obstacle", 310)
        SetMemoryPoolSize("EntityFlyer", 4)

    ReadDataFile("mus\\mus1.lvl", "mus1_campaign")
    SetDenseEnvironment("false")
    SetMaxFlyHeight(84.16)
    SetMaxPlayerFlyHeight(84.16)
    AISnipeSuitabilityDist(30)

    --  Sound 
    voiceSlow = OpenAudioStream("sound\\global.lvl", "mus_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)     
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "cis_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_quick", voiceQuick) 
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\mus.lvl",  "mus1")
    OpenAudioStream("sound\\mus.lvl",  "mus1")
    -- OpenAudioStream("sound\\mus.lvl",  "mus_objective_vo_slow")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    -- OpenAudioStream("sound\\mus.lvl",  "mus1_emt")

    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(IMP, CIS, "imp_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, imp, "cis_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(1, "impleaving")
    -- SetOutOfBoundsVoiceOver(2, "Cisleaving")

    -- SetAmbientMusic(IMP, 1.0, "rep_mus_amb_obj1_3_explore",  0,1)
    -- SetAmbientMusic(IMP, 0.75, "rep_mus_amb_obj1_3_explore", 1,1)
    -- SetAmbientMusic(IMP, 0.25,"rep_mus_amb_obj4_5_explore",    2,1)
    -- SetAmbientMusic(CIS, 1.0, "cis_mus_amb_start",  0,1)
    -- SetAmbientMusic(CIS, 0.99, "cis_mus_amb_middle", 1,1)
    -- SetAmbientMusic(CIS, 0.1,"cis_mus_amb_end",    2,1)

    SetVictoryMusic(IMP, "rep_mus_amb_victory")
    SetDefeatMusic (IMP, "rep_mus_amb_defeat")
    -- SetVictoryMusic(CIS, "cis_mus_amb_victory")
    -- SetDefeatMusic (CIS, "cis_mus_amb_defeat")

  SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
  SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
  SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
  SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
  SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
  SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
  SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

    --Musty Baby

   	AddCameraShot(0.446393, -0.064402, -0.883371, -0.127445, -93.406929, 72.953865, -35.479401);
	
	AddCameraShot(-0.297655, 0.057972, -0.935337, -0.182169, -2.384067, 71.165306, 18.453350);
	
	AddCameraShot(0.972488, -0.098362, 0.210097, 0.021250, -42.577881, 69.453072, 4.454691);
	
	AddCameraShot(0.951592, -0.190766, -0.236300, -0.047371, -44.607018, 77.906273, 113.228661);
	
	AddCameraShot(0.841151, -0.105984, 0.526154, 0.066295, 109.567764, 77.906273, 7.873035);
	
	AddCameraShot(0.818472, -0.025863, 0.573678, 0.018127, 125.781593, 61.423031, 9.809184);
	
	AddCameraShot(-0.104764, 0.000163, -0.994496, -0.001550, -13.319855, 70.673264, 63.436607);
	
	AddCameraShot(0.971739, 0.102058, 0.211692, -0.022233, -5.680069, 68.543945, 57.904160);
	
	AddCameraShot(0.178437, 0.004624, -0.983610, 0.025488, -66.947433, 68.543945, 6.745875);

    AddCameraShot(-0.400665, 0.076364, -0896894, -0.170941, 96.201210, 79.913033, -58.604382)
end
