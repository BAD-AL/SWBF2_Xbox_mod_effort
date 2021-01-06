--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("ObjectiveGoto")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("Ambush")
ScriptCB_SetGameRules("campaign")


--  Empire Attacking (attacker is always #1)
REP = 1
CIS = 2
--  These variables do not change
ATT = 1
DEF = 2
    
--Ambush Data-------------------------------------
ambushTeam1 = 4
ambushCount1 = 4

WookieTeam= 3

--ambushTeam3 = 6
--ambushCount3 = 5

--ambushTeam4 = 7	
--ambushCount4 = 15

    

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

	SetMissionEndMovie("ingame.mvs", "kasmon02")
	
	SetAIDifficulty(2, -4, "medium")
	
	SetAIDifficulty(0, 1, "hard")
	
	DisableAIAutoBalance()

	--Regions -- 
	
	ScriptCB_PlayInGameMovie("ingame.mvs", "kasmon01")
    
    EnableSPScriptedHeroes()
    KillObject("CP1")
    ATT_ReinforcementCount = GetReinforcementCount(ATT)
--    AddAIGoal(WookieTeam, "Deathmatch", 100)
    AddAIGoal(WookieTeam, "Defend", 500, "CP3")
    
    --UnlockHeroForTeam(1)
   
    
   --CP Visiblity
    
    SetProperty("CP2", "IsVisible", 0)
    SetObjectTeam("seatur1", 1)
    SetObjectTeam("seatur2", 1)
    BlockPlanningGraphArcs("seawall1")
    BlockPlanningGraphArcs("woodl")
    BlockPlanningGraphArcs("woodc")
    BlockPlanningGraphArcs("woodr")
    
    
    
   --Gate Stuff--
    
    OnObjectKillName(PlayAnimDown, "gatepanel");
    OnObjectRespawnName(PlayAnimUp, "gatepanel");
    OnObjectKillName(woodl, "woodl");
    OnObjectKillName(woodc, "woodc");
    OnObjectKillName(woodr, "woodr");
    
           
            --Setup Timer-- 
    timePop = CreateTimer("timePop")
	SetTimerValue(timePop, 0.3)

-- ON FIRST SPAWN --
  
      onfirstspawn = OnCharacterSpawn(
        function(character)
            if IsCharacterHuman(character) then
                ReleaseCharacterSpawn(onfirstspawn)
                onfirstspawn = nil
                StartTimer(timePop)
                OnTimerElapse(
        			function(timer)
            			StartObjectives()
            			ScriptCB_EnableCommandPostVO(0)
                		ScriptCB_SndPlaySound("KAS_obj_01")
                		ScriptCB_PlayInGameMusic("rep_kas_amb_obj1_3_explore")
            			DestroyTimer(timer)
        			end,
        		timePop
        		)          
             end
        end)
     
    --OBJECTIVE STUFF STARTS HERE BABY
    
    --Objective1 Stuff
    
    Objective1CP = CommandPost:New{name = "CP3", hideCPs = false}
    Objective1 = ObjectiveConquest:New{teamATT = DEF, teamDEF = ATT, 
    	textDEF = "level.kas2.objectives.1", 
    	popupText = "level.kas2.objectives.pop.1",
    	timeLimit = 180, timeLimitWinningTeam = ATT}
    Objective1:AddCommandPost(Objective1CP)
    
    Objective1.OnStart = function(self)
    	Objective1.defendGoalWok = AddAIGoal(WookieTeam, "Defend", 1000, "CP3")
    	Objective1.destroyGoal1 = AddAIGoal(CIS, "Destroy", 10, "woodl")
    	Objective1.destroyGoal2 = AddAIGoal(CIS, "Destroy", 10, "woodr")
    	Objective1.destroyGoal3 = AddAIGoal(CIS, "Destroy", 10, "woodc")
    	SetProperty("CP3", "Value_DEF_CIS", "2000")
    	SetProperty("CP3", "Value_ATK_CIS", "5000")
    	SetProperty("CP6", "Value_ATK_CIS", "2000")
    	SetProperty("woodl", "MaxHealth", 1e+37)
    	SetProperty("woodc", "MaxHealth", 1e+37)
    	SetProperty("woodr", "MaxHealth", 1e+37)
    	SetProperty("woodl", "CurHealth", 1e+37)
    	SetProperty("woodc", "CurHealth", 1e+37)
    	SetProperty("woodr", "CurHealth", 1e+37)
    	SetProperty("oil", "MaxHealth", 1e+37)
    	SetProperty("oil", "CurHealth", 1e+37)
    	MapAddEntityMarker("CP3", "hud_objective_icon", 3.0, 1, "YELLOW", true)
    	--SetProperty("CP3", "AISpawnWeight", "1000")	
    	--SetProperty("CP3", "Value_ATK_Republic", "1000")
    	--SetProperty("CP3", "Value_DEF_CIS", "2000")
    	--SetProperty("CP6", "Value_DEF_CIS", "1000")
    	--KillObject("CP1")
    	--KillObject("tank1")
    	--KillObject("tank2")
    end
    
    Objective1.OnComplete = function(self)
    		DeleteAIGoal(Objective1.defendGoalWok)
    		MapRemoveEntityMarker("CP3")
    		ATT_ReinforcementCount = GetReinforcementCount(ATT)
        	SetReinforcementCount(ATT, ATT_ReinforcementCount + 50)
    		--SetProperty("CP3", "AISpawnWeight", "10")
    		--SetProperty("CP5", "AISpawnWeight", "10")
    		--SetProperty("CP1", "AISpawnWeight", "1000")
    		SetProperty("CP6", "AISpawnWeight", "1000")
    		--SetProperty("CP2", "AISpawnWeight", "750")
    		--SetProperty("CP3", "AllyPath", "wookiepath2")
    		--SetProperty("CP1", "AllyPath", "wookiepath2")
    		--RemoveAIGoal(ATT, "Defend", 10000, "CP3")
    		if self.winningTeam == DEF then
    		   	ScriptCB_SndPlaySound("KAS_inf_01")
    		  else
--    			ScriptCB_PlayInGameMovie("ingame.mvs", "Kas2cam2")
	    	end
    end
    
    --Objective1CP = CommandPost:New{name = "CP3"}
    --Objective1 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.kas2.objectives.1"}
    --Objective1:AddCommandPost(Objective1CP)
    
     goto1 = ObjectiveGoto:New{teamATT = ATT, teamDEF = DEF, text = "level.kas2.objectives.1c", 
     														 popupText = "level.kas2.objectives.pop.1c",
     														 regionName = "goto1"}
 
    goto1.OnStart = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
    	MapAddEntityMarker("CP1", "hud_objective_icon", 3.0, 1, "YELLOW", true)
    	--ShowMessageText("level.kas2.objectives.1c", ATT)
    	ScriptCB_SndPlaySound("KAS_obj_03")
    	RespawnObject("CP1")
    	ScriptCB_PlayInGameMusic("rep_kas_amb_fallback_01")
    	goto1.defendGoal1 = AddAIGoal(REP, "Defend", 100, "gatepanel");
    	goto1.defendGoal2 = AddAIGoal(REP, "Defend", 300, "oil");
    	goto1.defendGoal3 = AddAIGoal(WookieTeam, "Defend", 100, "gatepanel");
    	goto1.defendGoal4 = AddAIGoal(WookieTeam, "Defend", 300, "oil");
    	SetProperty("woodl", "MaxHealth", 5000)
        SetProperty("woodc", "MaxHealth", 5000)
        SetProperty("woodr", "MaxHealth", 5000)
        SetProperty("woodl", "CurHealth", 5000)
        SetProperty("woodc", "CurHealth", 5000)
        SetProperty("woodr", "CurHealth", 5000)

    end
    
    goto1.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
    	DeleteAIGoal(goto1.defendGoal1)
    	DeleteAIGoal(goto1.defendGoal2)
    	DeleteAIGoal(goto1.defendGoal3)
    	DeleteAIGoal(goto1.defendGoal4)
    	DeleteAIGoal(Objective1.destroyGoal1)
    	DeleteAIGoal(Objective1.destroyGoal2)
    	DeleteAIGoal(Objective1.destroyGoal3)
    	
    	MapRemoveEntityMarker("CP1")
    	--SetProperty("wookiebaseveh", "ControlZone", "CP1")
    	if self.winningTeam == DEF then
        	ScriptCB_SndPlaySound("KAS_inf_01")
	    end
    end
    
    --Objective 2 stuff
    AAT_count = 5 
    AAT = TargetType:New{classname = "cis_hover_aat", killLimit = 5, icon = nil}
    
    AAT.OnDestroy = function(self, objectPtr)
        AAT_count = AAT_count - 1 
        ShowMessageText("level.kas2.objectives.2-" .. AAT_count, ATT)
        --SetProperty("AATCP" .. AAT_count, "Team", "0")
    end
    
    Objective2 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
        text = "level.kas2.objectives.2", AIGoalWeight = 0.0}
    Objective2:AddTarget(AAT)
    
    Objective2.OnComplete = function(self)
    		ShowMessageText("game.objectives.complete", ATT)
    		ShowMessageText("level.kas2.objectives.2c", ATT)
    		if self.winningTeam == DEF then
        		ScriptCB_SndPlaySound("KAS_inf_01")
	    	end
    end
        
    
    --Objective 3 Stuff
    Spider_count = 3 
    Spider = TargetType:New{classname = "cis_walk_spider", killLimit = 3, icon = nil}
    
    Spider.OnDestroy = function(self, objectPtr)
        Spider_count = Spider_count - 1 
        ShowMessageText("level.kas2.objectives.3-" .. Spider_count, ATT)
        --SetProperty("AATCP" .. AAT_count, "Team", "0")
    end
    
    Objective3 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
        text = "level.kas2.objectives.3", 
        popupText = "level.kas2.objectives.pop.3",
        AIGoalWeight = 0.0}
    Objective3:AddTarget(Spider)
    
    Objective3.OnComplete = function(self)
    		ShowMessageText("game.objectives.complete", ATT)
    		ShowMessageText("level.kas2.objectives.3c", ATT)
    end
    
   --Objective4 Stuff
    
    Objective4CP = CommandPost:New{name = "CP1", hideCPs = false}
    Objective4 = ObjectiveConquest:New{teamATT = DEF, teamDEF = ATT, text = "level.kas2.objectives.4", popupText = "level.kas2.objectives.pop.4",
    				timeLimit = 480, timeLimitWinningTeam = ATT}
    Objective4:AddCommandPost(Objective4CP)
    
    Objective4.OnStart = function(self)
    		ScriptCB_SndPlaySound("KAS_obj_02_TEMP")
    		SetProperty("baserush", "AISpawnWeight", "30000")
    		SetProperty("CP2", "AISpawnWeight", "20000")
    		SetObjectTeam("baserush", 2)
    		SetProperty("CP1", "Value_DEF_CIS", "2000")
    		SetProperty("CP1", "Value_ATK_CIS", "2000")
    		SetProperty("CP1", "Value_ATK_Republic", "2000")
    		SetProperty("CP1", "Value_DEF_Republic", "2000")
    		KillObject("CP3")
    		KillObject("CP5")
    		Ambush("droideka1", ambushCount1, ambushTeam1)
--    		UnlockHeroForTeam(1)
    		SetProperty("CP1", "AISpawnWeight", "1000")

			-- set these to 0 since we want to kill them, not capture them
    		SetProperty("gatepanel", "Value_ATK_CIS", "0")
    		-- add goals to kill them    		
    		Objective4.destroyGoal1 = AddAIGoal(CIS, "Destroy", 300, "gatepanel");
    		-- and let the good guys defend a little, otherwise they stay around the CP too much
    		Objective4.defendGoal1 = AddAIGoal(REP, "Defend", 100, "gatepanel");

    		
   	end
   	
   	Objective4.OnComplete = function(self)
   			ShowMessageText("game.objectives.complete", ATT)
   			DeleteAIGoal(Objective4.destroyGoal1)
   			DeleteAIGoal(Objective4.destroyGoal2)
   			DeleteAIGoal(Objective4.defendGoal1)
   			KillObject("baserush")
   			if self.winningTeam == DEF then
        		ScriptCB_SndPlaySound("KAS_inf_01")
	    	end
    end
    
   oil = Target:New{name = "oil"}

    Objective6 = ObjectiveAssault:New{teamATT = DEF, teamDEF = ATT, textDEF = "level.kas2.objectives.4",
    																popupText = "level.kas2.objectives.pop.4",
    															    timeLimit = 240, timeLimitWinningTeam = ATT}
    Objective6:AddTarget(oil)
  
  Objective6.OnStart = function(self)
  	SetProperty("oil", "MaxHealth", 86000.0)
    SetProperty("oil", "CurHealth", 86000.0)
  	Objective6.defendGoalWok = AddAIGoal(WookieTeam, "Defend", 1000, "oil")
    MapAddEntityMarker("oil", "hud_objective_icon", 3.0, 1, "YELLOW", true)
    ScriptCB_SndPlaySound("KAS_obj_12")
    ScriptCB_PlayInGameMusic("rep_kas_amb_act_01")
    SetProperty("baserush", "AISpawnWeight", "30000")
    SetProperty("CP2", "AISpawnWeight", "20000")
    SetObjectTeam("baserush", 2)
    SetProperty("CP1", "Value_DEF_CIS", "0")
    SetProperty("CP1", "Value_ATK_CIS", "0")
    SetProperty("CP1", "Value_ATK_Republic", "0")
    SetProperty("CP1", "Value_DEF_Republic", "0")
    
    
    SetObjectTeam("CP3", 2)
    SetObjectTeam("CP5", 2)
    KillObject("CP3")
    KillObject("CP5")
    Ambush("droideka1", ambushCount1, ambushTeam1)
--    UnlockHeroForTeam(1)
    SetProperty("CP1", "AISpawnWeight", "1000")

   -- set these to 0 since we want to kill them, not capture them
    SetProperty("gatepanel", "Value_ATK_CIS", "0")
    -- add goals to kill them    		
    Objective6.destroyGoal1 = AddAIGoal(CIS, "Destroy", 300, "gatepanel");
    -- and let the good guys defend a little, otherwise they stay around the CP too much
    Objective6.defendGoal1 = AddAIGoal(REP, "Defend", 100, "gatepanel");
    Objective6.destroyGoal2 = AddAIGoal(CIS, "Destroy", 1000, "oil");
    Objective6.defendGoal2 = AddAIGoal(REP, "Defend", 300, "oil");
  end
  
    Objective6.OnComplete = function(self)
    
    	if self.winningTeam == ATT then
	    	ShowMessageText("game.objectives.complete", ATT)
	    	DeleteAIGoal(Objective6.defendGoalWok)
	   	    DeleteAIGoal(Objective6.destroyGoal1)
	   	    DeleteAIGoal(Objective6.defendGoal1)
	   	    DeleteAIGoal(Objective6.destroyGoal2)
	   	    DeleteAIGoal(Objective6.defendGoal2)
	   	    MapRemoveEntityMarker("oil")
	   	    KillObject("baserush")
	   	    RespawnObject("CP3")
	        RespawnObject("CP5")
	--        SetProperty("oil", "MaxHealth", 1e+37)
	--    	SetProperty("oil", "CurHealth", 1e+37)
	        ATT_ReinforcementCount = GetReinforcementCount(ATT)
	        SetReinforcementCount(ATT, ATT_ReinforcementCount + 25)
        end
        
        if self.winningTeam == DEF then
        	ScriptCB_SndPlaySound("KAS_obj_16")
          else
--          	ScriptCB_PlayInGameMovie("ingame.mvs", "Kas2cam1")
	    end
    end
    
    --Objective 5 Stuff
    Objective5CP1 = CommandPost:New{name = "CP2"}
    Objective5CP2 = CommandPost:New{name = "CP3"}
    Objective5CP3 = CommandPost:New{name = "CP5"}
    Objective5CP4 = CommandPost:New{name = "CP6"}
    Objective5 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.kas2.objectives.5", popupText = "level.kas2.objectives.pop.5"}
    Objective5:AddCommandPost(Objective5CP1)
    Objective5:AddCommandPost(Objective5CP2)
    Objective5:AddCommandPost(Objective5CP3)
    Objective5:AddCommandPost(Objective5CP4)
    
    
    Objective5.OnStart = function(self)
    	UnlockHeroForTeam(1)
        Objective5.defendGoalWok = AddAIGoal(WookieTeam, "Conquest", 1000)
        Objective5.defendGoalWok2 = AddAIGoal(ATT, "Conquest", 5000)
        -- Setup for Last OBj-- 
        SetProperty("CP2", "Value_ATK_Republic", "800")
        SetProperty("CP3", "Value_ATK_Republic", "500")
        SetProperty("CP5", "Value_ATK_Republic", "500")
        SetProperty("CP6", "Value_ATK_Republic", "500")
        
        SetProperty("CP2", "Value_ATK_CIS", "800")
        SetProperty("CP3", "Value_ATK_CIS", "500")
        SetProperty("CP5", "Value_ATK_CIS", "500")
        SetProperty("CP6", "Value_ATK_CIS", "500")
        
        SetProperty("CP2", "Value_DEF_CIS", "800")
        SetProperty("CP3", "Value_DEF_CIS", "500")
        SetProperty("CP5", "Value_DEF_CIS", "500")
        SetProperty("CP6", "Value_DEF_CIS", "500")
        
        
        SetProperty("CP3", "AISpawnWeight", "1000")
        SetProperty("CP6", "AISpawnWeight", "1500")
        SetProperty("CP5", "AISpawnWeight", "1000")
        SetProperty("CP2", "AISpawnWeight", "1000")
        
      SetSpawnDelayTeam(7.0, 4.0, DEF)
      AICanCaptureCP("CP2", ATT, false)
      AICanCaptureCP("CP3", ATT, false)
      AICanCaptureCP("CP5", ATT, false)
      AICanCaptureCP("CP6", ATT, false)
      AICanCaptureCP("CP2", WookieTeam, false)
      AICanCaptureCP("CP3", WookieTeam, false)
      AICanCaptureCP("CP5", WookieTeam, false)
      AICanCaptureCP("CP6", WookieTeam, false)
      ScriptCB_SndPlaySound("KAS_obj_14")
      ScriptCB_SndPlaySound("KAS_Yoda_03")
      ScriptCB_PlayInGameMusic("rep_kas_amb_act_02")
      SetProperty("CP2", "captureRegion", "CP2CAPTURE")
      SetProperty("CP2", "Value_ATK_Republic", "100")
      SetProperty("CP2", "IsVisible", 1)

      --SetReinforcementCount(DEF, 120)
      Disable1()
      Disable2()
      Disable3()
      Disable4()
      
    end
    
    Objective5.OnComplete = function(self) 
    	ShowMessageText("game.objectives.complete", ATT)
    	if self.winningTeam == DEF then
    		ScriptCB_SndPlaySound("KAS_obj_09")
    	else
    		--play the win sound
	    	ScriptCB_SndPlaySound("KAS_obj_15")
	    end
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
end

    --OBJECTIVE SEQUENCER

function StartObjectives()    
	objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 6.0}
    --objectiveSequence:AddObjectiveSet(Objective1,Objective2,Objective3)
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:AddObjectiveSet(goto1)
    --objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:AddObjectiveSet(Objective6)
    objectiveSequence:AddObjectiveSet(Objective5)
    objectiveSequence:Start()  
 end
 
 function PlayAnimDown()
 	PauseAnimation("thegateup");
 	RewindAnimation("thegatedown");
   	PlayAnimation("thegatedown");
   	ShowMessageText("level.kas2.objectives.gateopen",1)
   	ScriptCB_SndPlaySound("KAS_obj_13")
--   	PlayAnimation("gatepanel");
   	--SetProperty("gatepanel", "MaxHealth", 1e+37)
    --SetProperty("gatepanel", "CurHealth", 1e+37)
      
            
   -- Allowing AI to run under gate   
    UnblockPlanningGraphArcs("seawall1");
    DisableBarriers("seawalldoor1");
    DisableBarriers("vehicleblocker");
      
end

function PlayAnimUp()
    PauseAnimation("thegatedown");
    RewindAnimation("thegateup");
   	PlayAnimation("thegateup");
      
            
   -- Allowing AI to run under gate   
    BlockPlanningGraphArcs("seawall1");
    EnableBarriers("seawalldoor1");
    EnableBarriers("vehicleblocker");
      
end

function woodl()
	UnblockPlanningGraphArcs("woodl");
	DisableBarriers("woodl");
end
	
function woodc()
	UnblockPlanningGraphArcs("woodc");
	DisableBarriers("woodc");
end
	
function woodr()
	UnblockPlanningGraphArcs("woodr");
	DisableBarriers("woodr");
end

function Disable1()
   	CP2DisableCapture = OnFinishCaptureName(
		function (postPtr)
			if GetObjectTeam(postPtr) == ATT then
				SetProperty("CP2", "Value_ATK_CIS", "0")
				SetProperty("CP2", "Value_DEF_CIS", "0")
				SetProperty("CP2", "CaptureRegion", "distraction")
				SetObjectTeam("CP2", 1)
				MapRemoveEntityMarker("CP2")
				ReleaseFinishCapture(CP2DisableCapture)
			end
		end,
		"CP2"
		)
end

function Disable2()
   	CP3DisableCapture = OnFinishCaptureName(
		function (postPtr)
			if GetObjectTeam(postPtr) == ATT then
				SetProperty("CP3", "Value_ATK_CIS", "0")
				SetProperty("CP3", "Value_DEF_CIS", "0")
			    SetProperty("CP3", "CaptureRegion", "distraction")
			    SetObjectTeam("CP3", 1)
			    MapRemoveEntityMarker("CP3")
			    ReleaseFinishCapture(CP3DisableCapture)
			end
		end,
		"CP3"
		)
end

function Disable3()
   	CP5DisableCapture = OnFinishCaptureName(
		function (postPtr)
			if GetObjectTeam(postPtr) == ATT then
				SetProperty("CP5", "Value_ATK_CIS", "0")
				SetProperty("CP5", "Value_DEF_CIS", "0")
				SetProperty("CP5", "CaptureRegion", "distraction")
				SetObjectTeam("CP5", 1)
				MapRemoveEntityMarker("CP5")
				ReleaseFinishCapture(CP5DisableCapture)
			end
		end,
		"CP5"
		)
end

function Disable4()
   	CP6DisableCapture = OnFinishCaptureName(
		function (postPtr)
			if GetObjectTeam(postPtr) == ATT then
--				SetProperty("CP6", "Value_ATK_CIS", "0")
--				SetProperty("CP6", "Value_DEF_CIS", "0")
				SetProperty("CP6", "CaptureRegion", "distraction")
				SetObjectTeam("CP6", 1)
				MapRemoveEntityMarker("CP6")
				ReleaseFinishCapture(CP6DisableCapture)
			end
		end,
		"CP6"
		)
end


function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(900 * 1024)
    SetPS2ModelMemory(3500000)
    ReadDataFile("ingame.lvl")

    SetMaxFlyHeight(70)
    
    
    

    ReadDataFile("sound\\kas.lvl;kas2cw")
    ReadDataFile("SIDE\\rep.lvl",
                             "rep_inf_ep3_rifleman",
                             "rep_inf_ep3_rocketeer",
                             "rep_inf_ep3_sniper_felucia",
                             "rep_inf_ep3_engineer",
                             "rep_inf_ep3_jettrooper",
                             "rep_inf_ep3_officer",
                             "rep_fly_cat_dome",
                             "rep_hero_yoda",
                             "rep_hover_fightertank")
                             --"rep_hover_swampspeeder")
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_tread_snailtank",
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             "cis_inf_engineer",
                             "cis_inf_sniper",
                             "cis_fly_gunship_dome",
                             "cis_hover_stap",
                             "cis_inf_officer",
                             "cis_walk_spider")
    ReadDataFile("SIDE\\wok.lvl",
                             "wok_inf_basic")
                             
	ReadDataFile("SIDE\\tur.lvl",
							"tur_bldg_beam",
							"tur_bldg_recoilless_kas")
    SetupTeams{

		rep={
			team = REP,
			units = 10,
			reinforcements = 30,
			soldier	= {"rep_inf_ep3_rifleman"},
			assault = {"rep_inf_ep3_rocketeer"},
			engineer = {"rep_inf_ep3_engineer"},
			sniper	= {"rep_inf_ep3_sniper_felucia"},
			officer	= {"rep_inf_ep3_officer"},
			special = {"rep_inf_ep3_jettrooper",1,4},
			
			
		},
		
		cis={
			team = CIS,
			units = 33,
			reinforcements = -1,
			soldier = {"cis_inf_rifleman"},
			assault = {"cis_inf_rocketeer"},
			engineer = {"cis_inf_engineer"},
			sniper	= {"cis_inf_sniper",2,2},
			officer	= {"cis_inf_officer"},
			special = {"cis_inf_droideka",0},
		}
	}
	
   ScriptCB_SetSpawnDisplayGain(0.2, 0.5) 	


-- Hero Setup -- 			
    SetHeroClass(REP, "rep_hero_yoda")

-- Ambush Pools -- 

	AddUnitClass(ambushTeam1, "cis_inf_rocketeer")
    	SetUnitCount(ambushTeam1, ambushCount1)
	SetTeamAsEnemy(ambushTeam1, REP)
	ClearAIGoals(ambushTeam1)
	AddAIGoal(ambushTeam1, "Deathmatch", 100)	


    --  Attacker Stats
    --SetUnitCount(ATT, 25)
    --SetReinforcementCount(ATT, 250)
    SetTeamAsEnemy(DEF,3)
    SetTeamAsEnemy(3,DEF)

    --  Defender Stats
    --SetUnitCount(DEF, 32)
    --SetReinforcementCount(DEF, -1)
    SetTeamAsFriend(ATT,3)
    SetTeamAsFriend(3,ATT)

    --  Level Stats
    ClearWalkers()
    --AddWalkerType(0, 4) -- 4 droidekas (special case: 0 leg pairs)
    AddWalkerType(1, 0) --
    AddWalkerType(2, 1) -- 2 spider walkers with 2 leg pairs each
    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponCnt = 300
    SetMemoryPoolSize("Aimer", 65)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 220)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 58)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntityHover", 13)
    SetMemoryPoolSize("EntityLight", 60)
    SetMemoryPoolSize("EntitySoundStream", 3)
    SetMemoryPoolSize("EntitySoundStatic", 111)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 87)
    SetMemoryPoolSize("MountedTurret", 18)
    SetMemoryPoolSize("Navigator", 58)
    SetMemoryPoolSize("Obstacle", 300)
    SetMemoryPoolSize("PathFollower", 58)
    SetMemoryPoolSize("PathNode", 256)
    SetMemoryPoolSize("ShieldEffect", 0)
    SetMemoryPoolSize("TentacleSimulator", 12)
    SetMemoryPoolSize("TreeGridStack", 275)
    SetMemoryPoolSize("Weapon", weaponCnt)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("KAS\\kas2.lvl", "kas2_obj")
    SetDenseEnvironment("false")
    SetMaxFlyHeight(65)
    SetMaxPlayerFlyHeight(65)

    --  Birdies
    SetNumBirdTypes(1)
    SetBirdType(0,1.0,"bird")

    --  Fishies
    SetNumFishTypes(1)
    SetFishType(0,0.8,"fish")

    --  Local Stats
    SetTeamName(3, "locals")
    SetTeamIcon(3, "all_icon")
    AddUnitClass(3, "wok_inf_warrior",4)
    AddUnitClass(3, "wok_inf_rocketeer",4)
    AddUnitClass(3, "wok_inf_mechanic",3)
    

    SetUnitCount(3, 11)

    --  Sound
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "kas_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)     
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "cis_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_quick", voiceQuick)   
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    -- OpenAudioStream("sound\\kas.lvl",  "KAS_objective_vo_slow")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\kas.lvl",  "kas")
    OpenAudioStream("sound\\kas.lvl",  "kas")
    
    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    -- SetAmbientMusic(REP, 1.0, "rep_kas_amb_start",  0,1)
    -- SetAmbientMusic(REP, 0.9, "rep_kas_amb_middle", 1,1)
    -- SetAmbientMusic(REP, 0.1, "rep_kas_amb_end",    2,1)
    -- SetAmbientMusic(CIS, 1.0, "cis_kas_amb_start",  0,1)
    -- SetAmbientMusic(CIS, 0.9, "cis_kas_amb_middle", 1,1)
    -- SetAmbientMusic(CIS, 0.1, "cis_kas_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_kas_amb_victory")
    SetDefeatMusic (REP, "rep_kas_amb_defeat")
    -- SetVictoryMusic(CIS, "cis_kas_amb_victory")
    -- SetDefeatMusic (CIS, "cis_kas_amb_defeat")

    SetOutOfBoundsVoiceOver(1, "repleaving")
    SetOutOfBoundsVoiceOver(2, "cisleaving")

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

    --Kas2 Docks
    --Wide beach shot
	AddCameraShot(0.977642, -0.052163, -0.203414, -0.010853, 66.539520, 21.864969, 168.598495);
	AddCameraShot(0.969455, -0.011915, 0.244960, 0.003011, 219.552948, 21.864969, 177.675674);
	AddCameraShot(0.995040, -0.013447, 0.098558, 0.001332, 133.571289, 16.216759, 121.571236);
	AddCameraShot(0.350433, -0.049725, -0.925991, -0.131394, 30.085188, 32.105236, -105.325264);



-- GOOD SHOTS -- 
	-- Gate to Right


--Kinda Cool -- 
	
    AddCameraShot(0.163369, -0.029669, -0.970249, -0.176203, 85.474831, 47.313362, -156.345627);
	AddCameraShot(0.091112, -0.011521, -0.987907, -0.124920, 97.554062, 53.690968, -179.347076);
	AddCameraShot(0.964953, -0.059962, 0.254988, 0.015845, 246.471008, 20.362143, 153.701050);  

end
