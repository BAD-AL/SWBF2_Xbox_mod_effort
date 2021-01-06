--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("ObjectiveGoto")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("Ambush")
ScriptCB_DoFile("PlayMovieWithTransition") 

--  REP Attacking (attacker is always #1)
IMP = 1
REP = 2
BOO = 3
ambushTeam1 = 4
SNIPER = 5
FILL = 6
ambushTeam2 = 7
--  These variables do not change
ATT = 1
DEF = 2


--Ambush Data-------------------------------------

ambushCount1 = 12
ambushCount2 = 8

  

function ScriptPostLoad()
	SetMissionEndMovie("ingame.mvs", "kammon02")
	SetAIDifficulty(2, -3, "medium")
	ScriptCB_SetGameRules("campaign")
	AddDeathRegion("deathregion2")
	LetsGO()
    EnableSPScriptedHeroes()
		-- VO for low reinforcements -- 
    OnTicketCountChange(
		function (team, count)
			if team == ATT and count == 35 then				
				ScriptCB_SndPlaySound("KAM_obj_18")
			elseif team == DEF and count == 10 then
				--play DEF is low on reinforce sound
			end
		end
		)	
    	
	UnlockHeroForTeam(ATT)	
	
    ScriptCB_SetSpawnDisplayGain(0.2, 0.5)	
    
    ActivateRegion("hack1")
 
    ScriptCB_PlayInGameMovie("ingame.mvs", "kammon01")   
    	
    onfirstspawn = OnCharacterSpawn(
    function(character)
        if IsCharacterHuman(character) then
        
            SetProperty("transport1", "SpawnTime", 3600) 
            SetProperty("transport2", "SpawnTime", 3600) 
            SetProperty("transport4", "SpawnTime", 3600)
			SetProperty("transport4", "team", 2)
            SetProperty("boba", "Team", 0)
            SetProperty("cp5", "Team", 1)
            RespawnObject("boba")
            KillObject("dud")
            ScriptCB_PlayInGameMusic("rep_kam_amb_obj1_2_explore")
            ReleaseCharacterSpawn(onfirstspawn)
            onfirstspawn = nil
            
           	
           	
            --  Set up the ambushes here
           	SetupAmbushTrigger("ambush_trigger_1", "ambush_trigger_path_1", ambushCount1, ambushTeam1)
            SetupAmbushTrigger("hack1", "ambush_trigger_path_2", 10, ambushTeam1)			
            
      
            SetProperty("transport2", "team", 0)
            SetProperty("transport1", "team", 0)
            SetProperty("transport4", "team", 0)    
            SetProperty("transport2", "MaxHealth", 999999999)
            SetProperty("transport2", "CurHealth", 999999999) 
            SetProperty("transport1", "MaxHealth", 999999999)
            SetProperty("transport1", "CurHealth", 999999999) 
            SetProperty("transport1", "IsVisible", 0)
            SetProperty("transport2", "IsVisible", 0)
            SetProperty("transport1", "IsCollidible", 0)
            SetProperty("transport2", "IsCollidible", 0)
            SetAIDamageThreshold("transport1", 0.6 )
            SetAIDamageThreshold("transport2", 0.6 )
            PlayAnimation("escape1")
            EntityFlyerTakeOff("transport4")
        	EntityFlyerInitAsLanded("transport2")
       		EntityFlyerInitAsLanded("transport1")
       
            --3 second delay on begin objectives
            ObjStart_timer = CreateTimer("ObjStart_timer")
	    	SetTimerValue(ObjStart_timer, 3)
	    	StartTimer(ObjStart_timer)
	    	CountDown = OnTimerElapse(
    		function()
    			BeginObjectives() 
    			ReleaseTimerElapse(CountDown)
            
    		end,
    		ObjStart_timer
    		)
         end
    end)
		
    
	
    
        --This is objective 1 Start  Get in the vicinity of the facility


    Objective1 = ObjectiveGoto:New{teamATT = ATT, teamDEF = DEF,  popupText = "level.kamino1.objectives.campaign.1_popup", text = "level.kamino1.objectives.campaign.1", regionName = "hack1"}
    Objective1.OnStart = function(self) 
        EntityFlyerTakeOff("transport4")
        EntityFlyerInitAsLanded("transport2")
        EntityFlyerInitAsLanded("transport1")
        SetProperty("hackhere1", "MaxHealth", 99999999999)
        SetProperty("hackhere1", "CurHealth", 99999999999)
        Obj1_attgoal1   =   AddAIGoal(ATT, "Defend", 900, "stank")
        Obj1_defgoal2   =   AddAIGoal(DEF, "Deathmatch", 100)
        Fillgoal2 = AddAIGoal(FILL, "Conquest", 100)

		ScriptCB_EnableCommandPostVO(0)	
     	ScriptCB_SndPlaySound("KAM_obj_08")
        MapAddEntityMarker("hackhere1", "hud_objective_icon", 3.0, ATT, "YELLOW", true, true, true) 
    end
    
    Objective1.OnComplete = function(self)
    	
	   	PlayAnimation("escape1") 
	  
		SetProperty("transport4", "team", 2)
	
		SetProperty("transport4", "team", 2)
		SetProperty("transport4", "SpawnTime", 3600)
	
		

    	SetProperty("ambush", "Team", 2)	
    	if self.winningTeam == self.teamDEF then 
         	BroadcastVoiceOver("KAM_obj_07")
        elseif self.winningTeam == self.teamATT then
         	ShowMessageText("level.kamino1.changed", ATT)
           	ScriptCB_SndPlaySound("KAM_boba_01")
           	ATTReinforce = GetReinforcementCount(ATT)
  			SetReinforcementCount(ATT, ATTReinforce + 6)
  		end
        
    	
        
    end 
    
	Objective1a = Objective:New{teamATT = ATT, teamDEF = DEF, popupText = "level.kamino1.objectives.campaign.2_popup", text = "level.kamino1.objectives.campaign.1b"}
	Objective1a.OnStart = function(self)
		OnObjectKillName(HackDoor1, "hackhere1")
		SetProperty("hackhere1", "CurHealth", 500)
		SetProperty("hackhere1", "MaxHealth", 500)
		
	end
	Objective1a.OnComplete = function(self)
	 	if self.winningTeam == self.teamDEF then 
        	print("SOME TEXT WILL GO HERE")
        elseif self.winningTeam == self.teamATT then
        	ShowMessageText("level.geo1.objectives.campaign.complete", ATT)
        	SetReinforcementCount(ATT, 100)
        	ScriptCB_SndPlaySound("KAM_boba_19")
        end
        
        --makes fig8 ship show up
	   
	   	BlockPlanningGraphArcs("open")
    	RespawnObject("cp1")
    	SetProperty("cp1", "IsVisible", 0)	
    	SetProperty("cp1", "Team", 2)
    	--ShowMessageText("level.kamino1.objectives.campaign.1b", 1)
        ActivateRegion("proceed")
        
        UnblockPlanningGraphArcs("connection71")
        MapRemoveEntityMarker("hackhere1")
              SetupAmbushTrigger("a3", "a3", 8, ambushTeam2)	
            ActivateRegion("a3")
            
            SetupAmbushTrigger("a4", "a4", 12, ambushTeam1)	
            ActivateRegion("a4")
            
            SetupAmbushTrigger("a5", "a5", 8, ambushTeam2)	
			ActivateRegion("a5")
            
            SetupAmbushTrigger("a6", "a6", 8, ambushTeam2)	
           	ActivateRegion("a6")
           		
	end
		   
    Objective2 = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 1,  popupText = "level.kamino1.objectives.campaign.3_popup", text = "level.kamino1.objectives.campaign.2"}
    Objective2:AddFlag{name = "dna1", homeRegion = "", captureRegion = "Region0",
            capRegionMarker = "hud_objective_icon", capRegionMarkerScale = 3.0, 
            icon = "", mapIcon = "flag_icon", mapIconScale = 2.0}
    
    
    Objective2.OnStart = function(self)
    	RespawnObject("cp4") 
		SetProperty("cp4", "IsVisible", 0)
		AICanCaptureCP("cp4", ATT, false)
		SetProperty("cp4", "Team", 2)
    	
    	DeleteAIGoal(Obj1_attgoal1)
        DeleteAIGoal(Obj1_defgoal2)
		DisableBarriers("frog")	
		DisableBarriers("close")
		DisableBarriers("open")
    	
		Obj2_attgoal1	=	AddAIGoal(ATT, "Defend", 900, "ctf")
		Obj2_defgoal2	=	AddAIGoal(DEF, "Defend", 900, "transport3")

		--MapAddEntityMarker("CP5", "hud_objective_icon", 3.0, ATT, "YELLOW", true, true, true) 
		ActivateRegion("regionx")
		ActivateRegion("regiony")
		--ActivateRegion("region0")
		SetupAmbushTrigger("regionx", "ambush_trigger_path_5", 5, ambushTeam1)
		SetupAmbushTrigger("regiony", "ambush_trigger_path_3", 5, ambushTeam1)
		
		SetProperty("cp3", "Team", 2)
		
		SetProperty("cp5", "Team", 1)
		ScriptCB_SndPlaySound("KAM_obj_06")
		--MapRemoveEntityMarker("cp1")
		--MapRemoveEntityMarker("cp5")
		
		plans_capture_on = OnFlagPickUp(		
		function(flag, carrier)
			if IsCharacterHuman(carrier) then
				MapAddEntityMarker("cp5", "hud_objective_icon", 3.0, ATT, "YELLOW", true, true, true)	
				ScriptCB_SndPlaySound("KAM_obj_10")
				ShowMessageText("level.kamino1.objectives.campaign.pick", ATT)	
			end
		end,
		"dna1"
		)
		
		plans_capture_off = OnFlagDrop(
		function(flag, carrier)
			if IsCharacterHuman(carrier) then
			MapRemoveEntityMarker("cp5")
				ShowMessageText("level.kamino1.objectives.campaign.drop", ATT)	
			end
		end,
		"dna1"
		)
    end
	

    Objective2.OnComplete = function(self)
    MapRemoveEntityMarker("cp5")
    	if self.winningTeam == self.teamDEF then 
          BroadcastVoiceOver("kam_obj_07")
        elseif self.winningTeam == self.teamATT then
          ShowMessageText("level.kamino1.objectives.campaign.2a", ATT)
          ShowMessageText("level.geo1.objectives.campaign.complete", ATT)
          ScriptCB_SndPlaySound("KAM_obj_11")
	  ScriptCB_PlayInGameMusic("rep_kam_objComplete_01")
	  -- Music Timer -- 
		music01Timer = CreateTimer("music01")
		SetTimerValue(music01Timer, 27.0)
			  		              
		StartTimer(music01Timer)
		OnTimerElapse(
		function(timer)
		ScriptCB_StopInGameMusic("rep_kam_objComplete_01")
		ScriptCB_PlayInGameMusic("rep_kam_amb_obj3_4_explore")
		DestroyTimer(timer)
		end,
	  	music01Timer
	  	)          
        end
		
		DeleteAIGoal(Obj2_attgoal1)
        DeleteAIGoal(Obj2_defgoal2)
		KillObject("dna1")

		SetProperty("cp1", "Team", 0)
		KillObject("cp1")	
		UnblockPlanningGraphArcs("connection85");
		UnblockPlanningGraphArcs("connection48");
		UnblockPlanningGraphArcs("connection63");
		UnblockPlanningGraphArcs("connection59");
		DisableBarriers("frog")
		DisableBarriers("close")
		DisableBarriers("open")
		PlayAnimation("group")
		ScriptCB_SndPlaySound("imp_fly_trooptrans_takeoff")

    end  
    
   
      
    cp4 = CommandPost:New{name = "cp4"}
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    ObjectiveXa = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF,  popupText = "level.kamino1.objectives.campaign.4_popup", text = "level.kamino1.objectives.campaign.X", 1}
   --This adds the CPs to the objective.  This needs to happen after the objective is set up
    ObjectiveXa:AddCommandPost(cp4)
    ObjectiveXa.OnStart = function(self)
        RespawnObject("cp3")
        SetProperty("cp3", "IsVisible", 0)
        SetProperty("cp3", "Team", 2)
        ScriptCB_SndPlaySound("KAM_obj_15")
        KillObject("dna1")
        SetProperty("cp4", "IsVisible", 1)
        SetProperty("cp4", "CaptureRegion", "cp4_capture")
    
        Obj4_attgoal4   =   AddAIGoal(ATT, "Defend", 900, "cp4")
    end      
    
    ObjectiveXa.OnComplete = function(self)
    	
		--make sure the AIs can't neutralize the CP before it moves on to the next objective
		SetProperty("cp4", "Team", self.winningTeam)
		AICanCaptureCP("cp4", 2, false)
		AICanCaptureCP("cp4", 3, false)
		AICanCaptureCP("cp4", 4, false)
		AICanCaptureCP("cp4", 5, false)
		AICanCaptureCP("cp4", 6, false)
		AICanCaptureCP("cp4", 7, false)

        UnlockHeroForTeam(ATT)
        if self.winningTeam == self.teamDEF then 
          BroadcastVoiceOver("kam_obj_07")
        elseif self.winningTeam == self.teamATT then
          ShowMessageText("level.geo1.objectives.campaign.complete", ATT)	
        end
		
		SetProperty("cp4", "CaptureRegion", "death") 
				
		DeleteAIGoal(Obj4_attgoal4)
		
	 	SetupAmbushTrigger("a7", "a7", 5, BOO)	
       	ActivateRegion("a7")
       	
      -- 	MapAddEntityMarker("hackhere2", "hud_objective_icon", 3.0, ATT, "YELLOW", true, true, true) 
		RespawnObject("CP2")
		SetProperty("CP2", "IsVisible", 0)
		SetProperty("CP2", "Team", 6)
		SetProperty("CP2", "Spawnpath", "junk")
	
		SetProperty("CP5", "IsVisible", 0)
		SetProperty("CP5", "CaptureRegion", "death")
				SetProperty("cp4", "CaptureRegion", "death")
		SetProperty("CP5", "Team", 2)
       	
	end  

    
	
--
--obj7--
--    

	pod_count = 5    
	pod1 = Target:New{name = "comp1"}
	pod2 = Target:New{name = "comp2"}
	pod3 = Target:New{name = "comp3"}
	pod4 = Target:New{name = "comp4"}
	pod5 = Target:New{name = "comp5"}
	pod1.OnDestroy = function(self)
		if pod_count > 1 then
			pod_count = pod_count - 1
			ShowMessageText("level.kamino1.objectives.campaign.7-" .. pod_count)
			
		end
		Ambush("junk", 5, BOO)
	end
	pod2.OnDestroy = function(self)
		if pod_count > 1 then
			pod_count = pod_count - 1
			ShowMessageText("level.kamino1.objectives.campaign.7-" .. pod_count)
		
		end	
	
	end
	
	pod3.OnDestroy = function(self)
		if pod_count > 1 then
			pod_count = pod_count - 1
			ShowMessageText("level.kamino1.objectives.campaign.7-" .. pod_count)
		end
		Ambush("junk", 5, BOO)
	end
		
	pod4.OnDestroy = function(self)
		if pod_count > 1 then
			pod_count = pod_count - 1
			ShowMessageText("level.kamino1.objectives.campaign.7-" .. pod_count)
		end

	end
    pod5.OnDestroy = function(self)
		if pod_count > 1 then
			pod_count = pod_count - 1
			ShowMessageText("level.kamino1.objectives.campaign.7-" .. pod_count)
		end
		
	end
    Objective7 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF,  popupText = "level.kamino1.objectives.campaign.7_popup", text = "level.kamino1.objectives.campaign.7"}
    Objective7:AddTarget(pod1)
	Objective7:AddTarget(pod2)
	Objective7:AddTarget(pod3)
	Objective7:AddTarget(pod4)
   	Objective7:AddTarget(pod5)
	
	Objective7.OnStart = function(self)

	SetProperty("FDL-1", "IsLocked", 0)
	SetProperty("FDL-3", "IsLocked", 0)

	SetupAmbushTrigger("final", "final", 12, 4)	
       	ActivateRegion("a7")
	UnblockPlanningGraphArcs("Connection10");
	UnblockPlanningGraphArcs("Connection159");
	UnblockPlanningGraphArcs("Connection31");
	DisableBarriers("FRONTDOOR1-1");
	DisableBarriers("FRONTDOOR1-2");
	DisableBarriers("FRONTDOOR1-3");
		ActivateRegion("proceed2")
		RespawnObject("comp1")
		RespawnObject("comp2")
		RespawnObject("comp3")
		RespawnObject("comp4")
		RespawnObject("comp5")

		obj7_1 = AddAIGoal(3, "defend", 900, "comp1") 
		obj7_2 = AddAIGoal(4, "defend", 900, "comp1") 
		obj7_3 = AddAIGoal(5, "defend", 900, "comp1") 
		obj7_4 = AddAIGoal(7, "defend", 900, "comp1") 

		ScriptCB_SndPlaySound("KAM_obj_20")
	end
	
	Objective7.OnComplete = function(self)
		SetProperty("transport2", "ControlRegion", "death")
		ATTReinforce = GetReinforcementCount(ATT)
  		SetReinforcementCount(ATT, ATTReinforce + 20)		
		DeleteAIGoal(obj7_1) 
		DeleteAIGoal(obj7_2) 
		DeleteAIGoal(obj7_3) 
		DeleteAIGoal(obj7_4) 
		obj7_1 = AddAIGoal(3, "defend", 900, "transport2") 
		obj7_2 = AddAIGoal(4, "defend", 900, "transport2") 
		obj7_3 = AddAIGoal(5, "defend", 900, "transport2") 
		obj7_4 = AddAIGoal(7, "defend", 900, "transport2") 
		
	
		SetProperty("transport1", "IsVisible", 1)
		SetProperty("transport1", "IsCollidible", 1)
		SetProperty("transport1", "team", 2)
	  	SetProperty("transport2", "team", 2)
		KillObject("transport4")
		
		if self.winningTeam == self.teamDEF then 
	          BroadcastVoiceOver("kam_obj_03")

	        elseif self.winningTeam == self.teamATT then
	          ScriptCB_SndPlaySound("KAM_inf_05")
	          ScriptCB_PlayInGameMusic("rep_kam_objComplete_02")
	           -- Music Timer -- 
		   music02Timer = CreateTimer("music02")
		  SetTimerValue(music02Timer, 26.0)
		  		              
		  	StartTimer(music02Timer)
		  	OnTimerElapse(
		  		function(timer)
		  		ScriptCB_StopInGameMusic("rep_kam_objComplete_02")
		  		ScriptCB_PlayInGameMusic("rep_kam_immVict_01")
		  		DestroyTimer(timer)
		  	end,
		  	music02Timer
                        ) 	          
	          ShowMessageText("level.geo1.objectives.campaign.complete", ATT)
	          SetProperty("CP2", "Team", 0)
	          KillObject("CP2")
		end
		
		
		
	    SetProperty("transport2", "IsVisible", 1)
	    SetProperty("transport2", "IsCollidible", 1)
    
	end 

    ship_count = 2    
    ship1 = Target:New{name = "transport1"}
    ship2 = Target:New{name = "transport2"}
	ship1.OnDestroy = function(self)    
		if ship_count > 1 then
			ship_count = ship_count - 1
			ShowMessageText("level.kamino1.objectives.campaign.8-" .. ship_count)

			
		end
	end
	
	ship2.OnDestroy = function(self)
		if ship_count > 1 then
			ship_count = ship_count - 1
			ShowMessageText("level.kamino1.objectives.campaign.8-" .. ship_count)
			ScriptCB_SndPlaySound("KAM_inf_01")
			SetProperty("cp3", "Team", 0)
			KillObject("cp3")
			SetProperty("transport2", "IsVisible", 0)  
			SetProperty("transport2", "IsCollidible", 0)
					
	
		end
	end
    

    
	Objective8 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF,  popupText = "level.kamino1.objectives.campaign.8_popup", text = "level.kamino1.objectives.campaign.8", timeLimit = 300,
										timeLimitWinningTeam = DEF}
	Objective8:AddTarget(ship1)
	Objective8:AddTarget(ship2)
			
	Objective8.OnStart = function(self)
		duh()

          
        SetProperty("transport1", "SpawnTime", 3600) 
        SetProperty("transport2", "SpawnTime", 3600) 
        SetProperty("cp3", "ControlRegion", "cp5_control")
        SetProperty("boba", "ControlRegion", "cp5_control")
        KillObject("boba")
            poop_timer = CreateTimer("poop_timer")
            SetTimerValue(poop_timer, 180)
            StartTimer(poop_timer)
            playpoop = OnTimerElapse(
                function()
                
                    ReleaseTimerElapse(playpoop)
                ScriptCB_SndPlaySound("KAM_obj_22")
                    
                end,
                poop_timer
                )
    
        dookie_timer = CreateTimer("dookie_timer")
            SetTimerValue(dookie_timer, 12)
            StartTimer(dookie_timer)
            playdookie = OnTimerElapse(
                function()
                    ReleaseTimerElapse(playdookie)
                   	EntityFlyerTakeOff("transport1")
                    
                end,
                dookie_timer
                )
    DeleteAIGoal(Fillgoal2)
    Fillgoal2 = AddAIGoal(FILL, "Defend", 100, "transport2")
        Escape_timer = CreateTimer("Escape_timer")
            SetTimerValue(Escape_timer, 275)
            StartTimer(Escape_timer)
            playEscape = OnTimerElapse(
                function()
                    PauseAnimation("sit2")
                    PlayAnimation("group1")
                    ReleaseTimerElapse(playEscape)
                    ScriptCB_SndPlaySound("rep_fly_gunship_takeoff")
                    
                end,
                Escape_timer
                )
        ScriptCB_SndPlaySound("KAM_obj_21")
        
    wait_timer = CreateTimer("wait_timer")
        SetTimerValue(wait_timer, 265)
        StartTimer(wait_timer)
        playwait = OnTimerElapse(
            function()
                EntityFlyerTakeOff("transport2")
                
                ReleaseTimerElapse(playwait)
                
            end,
            wait_timer
            )
    wait1_timer = CreateTimer("wait1_timer")
    SetTimerValue(wait1_timer, 268)
    StartTimer(wait1_timer)
    playwait1 = OnTimerElapse(
        function()
            ScriptCB_SndPlaySound("KAM_obj_23")
            ReleaseTimerElapse(playwait1)
            
        end,
        wait1_timer
        )
    
    SetProperty("cp3", "Team", FILL)
    SetProperty("CP5", "Team", 2) 
    SetupAmbushTrigger("a9", "a9", 9, BOO)  
    ActivateRegion("a9")
    SetupAmbushTrigger("a10", "a10", 9, BOO)    
    ActivateRegion("a10")
    SetProperty("transport1", "MaxHealth", 2500)
    SetProperty("transport1", "CurHealth", 2500)
    SetProperty("transport2", "MaxHealth", 2500)
    SetProperty("transport2", "CurHealth", 2500)
        
    Obj8_01 = AddAIGoal(ATT, "Defend", 900, "transport2")
    Obj8_02 = AddAIGoal(DEF, "Defend", 900, "transport2")

		
	end
    
	Objective8.OnComplete = function(self)
		if self.winningTeam == self.teamDEF then 
          BroadcastVoiceOver("kam_obj_02")
        elseif self.winningTeam == self.teamATT then
          ShowMessageText("level.geo1.objectives.campaign.complete", ATT)
          			ScriptCB_SndPlaySound("KAM_inf_02")
	    			       -- movie Timer -- 
		 movie02Timer = CreateTimer("movie02")
		SetTimerValue(movie02Timer, 7)
				              
			StartTimer(movie02Timer)
			OnTimerElapse(
				function(timer)
    	--		PlayMovieWithTransition("ingame.mvs", "kammon02")
				DestroyTimer(timer)
			end,
			movie02Timer
                )  
          vo9_timer = CreateTimer("vo9_timer")
	    	SetTimerValue(vo9_timer, 4)
	    	StartTimer(vo9_timer)
	    	playvo9 = OnTimerElapse(
	    		function()
	    			ScriptCB_SndPlaySound("KAM_inf_03")
	    			ReleaseTimerElapse(playvo9)
	    			
	    		end,
	    		vo9_timer
	    		)
        end
	end 



      ----
      --TDM            - KILL EM ALL
      ----
	Objective9 = ObjectiveTDM:New{teamATT = 1, teamDEF = 2, 
								 popupText = "level.mus1.objectives.campaign.9_popup", textATT = "level.kamino1.objectives.campaign.9",
								textDEF = "you faqers are dead"}
	Objective9.OnStart = function(self)	
		SetReinforcementCount(DEF, 25)
		ShowMessageText("level.kamino1.objectives.campaign.9b")
	end
	Objective9.OnComplete = function(self)
		
		ScriptCB_SndPlaySound("KAM_obj_14")
	
	end 


	function BeginObjectives()  
			objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 6.0}
		objectiveSequence:AddObjectiveSet(Objective1)
		objectiveSequence:AddObjectiveSet(Objective1a)
		objectiveSequence:AddObjectiveSet(Objective2)
		objectiveSequence:AddObjectiveSet(ObjectiveXa)
	

		objectiveSequence:AddObjectiveSet(Objective7)
		objectiveSequence:AddObjectiveSet(Objective8)

		objectiveSequence:Start()
	end
	

	
end


function LetsGO()
	--making all assault object invulnarable to ai
	KillObject("cp11")
	KillObject("cp22")
	SetProperty("CP5", "HUDIndex", 1)
	SetProperty("CP6", "HUDIndex", 2)
	SetProperty("cp7", "HUDIndex", 3)
		SetProperty("boba", "team", 1)
		KillObject("cp6")
		KillObject("cp7")
	SetAIDamageThreshold("comp1", 0.6 )
	SetAIDamageThreshold("comp2", 0.6 )
	SetAIDamageThreshold("comp3", 0.6 )
	SetAIDamageThreshold("comp4", 0.6 )
	SetAIDamageThreshold("comp5", 0.6 )
	SetProperty("cp1", "IsVisible", "0")

	SetAIDamageThreshold("hackhere1", 0.6 )
	--SetAIDamageThreshold("hackhere2", 0.6 )
	SetProperty("FDU-1", "IsLocked", 1)
	SetProperty("FDU-2", "IsLocked", 1)    
	SetProperty("FDU-3", "IsLocked", 1)	        
	SetProperty("cp1", "IsVisible", 0)
	SetProperty("kam_bldg_podroom_door32", "IsLocked", 1)
	SetProperty("FDL-1", "IsLocked", 1)
	SetProperty("FDL-2", "IsLocked", 1)
	SetProperty("FDl-3", "IsLocked", 1)
	SetProperty("kam_bldg_podroom_door33", "IsLocked", 1)
		SetProperty("kam_bldg_podroom_door32", "IsLocked", 1)
				SetProperty("kam_bldg_podroom_door34", "IsLocked", 1)
	SetProperty("kam_bldg_podroom_door35", "IsLocked", 1)
		SetProperty("kam_bldg_podroom_door27", "IsLocked", 1)	    
			SetProperty("kam_bldg_podroom_door28", "IsLocked", 1)		
	SetProperty("kam_bldg_podroom_door36", "IsLocked", 1)
		SetProperty("kam_bldg_podroom_door20", "IsLocked", 1)

	SetProperty("cp1", "IsVisible", 0)
	SetProperty("cp2", "IsVisible", 0)
	SetProperty("cp3", "IsVisible", 0)
	SetProperty("cp4", "IsVisible", 0)
	


--    SetProperty("dna1", "GeometryName", "kam_icon_embryo")
--    SetProperty("dna2", "GeometryName", "kam_icon_embryo")
--    SetProperty("dna3", "GeometryName", "kam_icon_embryo")
--    SetProperty("dna4", "GeometryName", "kam_icon_embryo")
--    
--    SetProperty("dna1", "CarriedGeometryName", "kam_icon_embryo")
--    SetProperty("dna2", "CarriedGeometryName", "kam_icon_embryo")
--    SetProperty("dna3", "CarriedGeometryName", "kam_icon_embryo")
--    SetProperty("dna4", "CarriedGeometryName", "kam_icon_embryo")
	
	SetProperty("dna1", "AllowAIPickUp", 0)
    SetProperty("dna2", "AllowAIPickUp", 0)
    SetProperty("dna3", "AllowAIPickUp", 0)
    SetProperty("dna4", "AllowAIPickUp", 0)

    SetProperty("cp1", "Team", 0)
    SetProperty("cp2", "Team", 0)
    SetProperty("cp3", "Team", 0)
    SetProperty("cp4", "Team", 0)
    SetProperty("cp5", "Team", 0)
    SetProperty("boba", "Team", 1)
    

    
    --KillObject("cp3")
    --KillObject("cp4")
    
    SetProperty("cp1", "CaptureRegion", "DEATH")
    SetProperty("cp2", "CaptureRegion", "DEATH")
    SetProperty("cp3", "CaptureRegion", "DEATH")
    SetProperty("cp4", "CaptureRegion", "DEATH")
    SetProperty("CP5", "CaptureRegion", "DEATH")
    
    BlockPlanningGraphArcs("connection71")
    
    
        
   --Objective1
    BlockPlanningGraphArcs("connection85")
        BlockPlanningGraphArcs("connection48")
            BlockPlanningGraphArcs("connection63")
                BlockPlanningGraphArcs("connection59")
                         UnblockPlanningGraphArcs("close")
                         UnblockPlanningGraphArcs("open")
                         EnableBarriers("frog")
                         DisableBarriers("close")
                         DisableBarriers("open")
        
    --blocking Locked Doors
    BlockPlanningGraphArcs("connection194");
        BlockPlanningGraphArcs("connection200");
            BlockPlanningGraphArcs("connection118");
               EnableBarriers("FRONTDOOR2-3");
               	EnableBarriers("FRONTDOOR2-1");  
                	EnableBarriers("FRONTDOOR2-2");  
   
    --Lower cloning facility
    BlockPlanningGraphArcs("connection10")
        BlockPlanningGraphArcs("connection159")
            BlockPlanningGraphArcs("connection31")
               EnableBarriers("FRONTDOOR1-3")
                EnableBarriers("FRONTDOOR1-1")  
                 EnableBarriers("FRONTDOOR1-2")
    
    KillObject("cp1")
    KillObject("cp3")
    KillObject("cp2") 
    KillObject("cp4")      
end
function duh()
		EntityFlyerInitAsLanded("transport1")
		SetProperty("transport1", "IsVisible", 1) 
		SetProperty("transport1", "IsCollidable", 1) 
		PauseAnimation("sit")
		RewindAnimation("test")
		PlayAnimation("test")
end
		
function HackDoor1()
	Objective1a:Complete(ATT)
	SetProperty("FDU-1", "IsLocked", 0)
	SetProperty("FDU-3", "IsLocked", 0)	    

	UnblockPlanningGraphArcs("Connection194")
	UnblockPlanningGraphArcs("Connection200")
	UnblockPlanningGraphArcs("Connection118")
	DisableBarriers("FRONTDOOR2-1");
	DisableBarriers("FRONTDOOR2-2");
	DisableBarriers("FRONTDOOR2-3");
end 

function HackDoor2()
	ObjectiveZ:Complete(ATT)
	
	
	SetProperty("FDL-1", "IsLocked", 0)
	UnblockPlanningGraphArcs("Connection10");
		UnblockPlanningGraphArcs("Connection159");
		UnblockPlanningGraphArcs("Connection31");
		DisableBarriers("FRONTDOOR1-1");
		DisableBarriers("FRONTDOOR1-2");
		DisableBarriers("FRONTDOOR1-3");
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
	StealArtistHeap(2*1024*1024)
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(3000000)
    ReadDataFile("ingame.lvl")





    ReadDataFile("sound\\kam.lvl;kam1cross")
    ReadDataFile("SIDE\\rep.lvl",
                             "rep_inf_ep2_jettrooper_sniper",
                             "rep_inf_ep2_jettrooper_rifleman",
                             "rep_inf_ep2_rocketeer_chaingun",
                             "uta_fly_ride_gunship")
                           
                            
        ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_dark_trooper",
                             "imp_hero_bobafett", 
                             "imp_inf_officer")

	ReadDataFile("SIDE\\tur.lvl",
						"tur_bldg_chaingun_roof",
						"tur_weap_built_gunturret")	
  
    SetupTeams{
          imp = {
            team = IMP,
            units = 12,
            reinforcements = 8,
            soldier = { "imp_inf_rifleman",1,50},
            assault = { "imp_inf_rocketeer",1,50},
            engineer = { "imp_inf_engineer",1,50},
            sniper  = { "imp_inf_sniper",1,50},
            officer = { "imp_inf_officer",1,4},
            special = { "imp_inf_dark_trooper",1,4},   
           -- turret   = { "imp_bldg_defensegridturret"},         
        },
          rep = {
            team = REP,
            units = 12,
            reinforcements = -1,
            soldier = { "rep_inf_ep2_jettrooper_rifleman",5,50},
            sniper  = { "rep_inf_ep2_jettrooper_sniper",8,50},
 
        },
    
    }   
    SetHeroClass(IMP, "imp_hero_bobafett")
    
    SetAttackingTeam(ATT)


--Pools of extra characters for Ambushes.
    AddUnitClass(ambushTeam1, "rep_inf_ep2_jettrooper_rifleman",1,50)
    AddUnitClass(ambushTeam1, "rep_inf_ep2_jettrooper_sniper",1,4)
    SetUnitCount(ambushTeam1, ambushCount1)
    ClearAIGoals(ambushTeam1)
    AddAIGoal(ambushTeam1, "Deathmatch", 100)
    
    AddUnitClass(BOO, "rep_inf_ep2_rocketeer_chaingun",1,50)
    SetUnitCount(BOO, 9)
    ClearAIGoals(BOO)
    AddAIGoal(BOO, "Deathmatch", 100)
    
    AddUnitClass(SNIPER, "rep_inf_ep2_jettrooper_sniper",1,50)
    SetUnitCount(SNIPER, 4)
    ClearAIGoals(SNIPER)
    AddAIGoal(SNIPER, "Deathmatch", 100)
     

    AddUnitClass(FILL, "rep_inf_ep2_rocketeer_chaingun",2,50)
    SetUnitCount(FILL, 6)
    ClearAIGoals(FILL)
   
	
	AddUnitClass(ambushTeam2, "rep_inf_ep2_jettrooper_rifleman",1,50)
    AddUnitClass(ambushTeam2, "rep_inf_ep2_jettrooper_sniper",2,3)
    SetUnitCount(ambushTeam2, ambushCount2)
    ClearAIGoals(ambushTeam2)
    AddAIGoal(ambushTeam2, "Deathmatch", 100)
	
	SetSpawnDelayTeam(5.0, 3, DEF)
   	SetSpawnDelayTeam(12.0, 3, FILL)	
   	
--  Teams for Dodgeball
--		SetTeamAsEnemy(BOO, IMP)
--		SetTeamAsEnemy(FILL, IMP)
--		SetTeamAsEnemy(IMP, FILL)
--		SetTeamAsEnemy(ambushTeam1, IMP)
--		SetTeamAsEnemy(ambushTeam2, IMP)
--		SetTeamAsEnemy(ambushTeam2, IMP)

		SetTeamAsFriend(2, 3)
		SetTeamAsFriend(2, 4)
		SetTeamAsFriend(2, 5)
		SetTeamAsFriend(2, 6)
		SetTeamAsFriend(2, 7)
		SetTeamAsFriend(3, 2)
		SetTeamAsFriend(3, 4)
		SetTeamAsFriend(3, 5)
		SetTeamAsFriend(3, 6)
		SetTeamAsFriend(3, 7)
		SetTeamAsFriend(4, 2)
   		SetTeamAsFriend(4, 3)
   		SetTeamAsFriend(4, 5)
   		SetTeamAsFriend(4, 6)
   		SetTeamAsFriend(4, 7)
   		SetTeamAsFriend(5, 2)
   		SetTeamAsFriend(5, 3)
   		SetTeamAsFriend(5, 4)
   		SetTeamAsFriend(5, 6)
   		SetTeamAsFriend(5, 7)
   		SetTeamAsFriend(6, 2)
   		SetTeamAsFriend(6, 3)
   		SetTeamAsFriend(6, 4)
   		SetTeamAsFriend(6, 5)
   		SetTeamAsFriend(6, 7)
   		SetTeamAsFriend(7, 2)
   		SetTeamAsFriend(7, 3)
   		SetTeamAsFriend(7, 4)
   		SetTeamAsFriend(7, 5)
   		SetTeamAsFriend(7, 6)
   		
    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- droidekas
	local weaponCnt = 280
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
	SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 17)
	SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntityLight", 64)    
	SetMemoryPoolSize("EntitySoundStatic", 85)
    SetMemoryPoolSize("EntitySoundStream", 3)
	SetMemoryPoolSize("FlagItem", 3)
    SetMemoryPoolSize("MountedTurret",44)
    SetMemoryPoolSize("Obstacle", 810)
    SetMemoryPoolSize("SoundSpaceRegion", 36)
    SetMemoryPoolSize("Weapon", weaponCnt)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("KAM\\kam1.lvl", "kamino1_campaign")
    SetDenseEnvironment("false")

    --  AI
    SetAllowBlindJetJumps(0)

    --  Sound
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "kam_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)     
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "imp_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_quick", voiceQuick)   
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    -- OpenAudioStream("sound\\kam.lvl",  "kam_objective_vo_slow")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\kam.lvl",  "kam1")
    OpenAudioStream("sound\\kam.lvl",  "kam1")


    -- SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(REP, IMP, "rep_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(IMP, REP, "imp_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    -- SetAmbientMusic(REP, 1.0, "rep_kam_amb_start",  0,1)
    -- SetAmbientMusic(REP, 0.99, "rep_kam_amb_middle", 1,1)
    -- SetAmbientMusic(REP, 0.1,"rep_kam_amb_end",    2,1)
    -- SetAmbientMusic(IMP, 1.0, "rep_kam_amb_obj1_2_explore",  0,1)
    -- SetAmbientMusic(IMP, 0.75, "rep_kam_amb_obj3_explore", 1,1)
    -- SetAmbientMusic(IMP, 0.25,"rep_kam_amb_obj1_2_explore",    2,1)

    -- SetVictoryMusic(REP, "rep_kam_amb_victory")
    -- SetDefeatMusic (REP, "rep_kam_amb_defeat")
    SetVictoryMusic(IMP, "cis_kam_amb_victory")
    SetDefeatMusic (IMP, "cis_kam_amb_defeat")

    --SetOutOfBoundsVoiceOver(2, "repleaving")
    SetOutOfBoundsVoiceOver(1, "impleaving")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")



    SetAttackingTeam(ATT)

    AddDeathRegion("deathregion")
		    AddCameraShot(0.564619, -0.121047, 0.798288, 0.171142, 68.198814, 79.137611, 110.850922);

            AddCameraShot(-0.281100, 0.066889, -0.931340, -0.221616, 10.076019, 82.958336, -26.261774);

            AddCameraShot(0.209553, -0.039036, -0.960495, -0.178923, 92.558563, 58.820618, 130.675919);

            AddCameraShot(0.968794, 0.154227, 0.191627, -0.030506, -173.914413, 69.858940, 52.532421);

            AddCameraShot(0.744389, 0.123539, 0.647364, -0.107437, 97.475639, 53.216236, 76.477089);

            AddCameraShot(-0.344152, 0.086702, -0.906575, -0.228393, 95.062233, 105.285820, -37.661552);
end
