--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
-- This is the Campaign Sript for Theed: Imperial Deplomacy, map name NAB2G_C (Designer: P. Baker)

-- Load the gametype scripts to be used.
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("ObjectiveTDM") 
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("MultiObjectiveContainer") 
--ScriptCB_DoFile("ObjectiveAssault") 
ScriptCB_DoFile("setup_teams") 
ScriptCB_DoFile("Ambush")
ScriptCB_SetGameRules("campaign")


--  Attacker is always #1
ATT = 1
DEF = 2
GAR = DEF
IMP = ATT
QUE = 3
ROY = 4
NEW = 5


   
ambushTeam1 = GAR   --ambush team
ambushCount1 = 3    --how many guys to spawn in at an ambush
                        
ambushTeam2 = GAR
ambushCount2 = 3

ambushTeam3 = GAR       
ambushCount3 = 3

ambushTeam4 = GAR
ambushCount4 = 3

ambushTeam5 = GAR       
ambushCount5 = 3

ambushTeam6 = GAR
ambushCount6 = 3

numRoyalGuards = 14         --the total number of guards
numInitialRoyalGuards = 8   --the number of guards in the first wave (the second wave will have numRoyalGuards - numInitialRoyalGuards dudes)

extraStormtrooperTeam = 5
numExtraStormtroopers = 16

Console1 = 2




--objective3SpawnCountATT = 20  --how many guys to spawn in when objective3 starts for the Attackers
--objective3SpawnCountDEF = 25  --how many guys to spawn in when objective3 starts for the Defenders
    

    
function ScriptPostLoad ()

    SetAIDifficulty(0, -2, "medium")
    
    SetAIDifficulty(0, -1, "hard")

    AICanCaptureCP("plaza1", ATT, false)
    AICanCaptureCP("plaza1", DEF, false)
    AICanCaptureCP("plaza1", NEW, false)

    SetMissionEndMovie("ingame.mvs", "nabmon02")

    DisableAIAutoBalance() 
    
    SetProperty("lconsole3", "MaxHealth", 1e+37)
    SetProperty("lconsole3", "CurHealth", 1e+37)


    SetMapNorthAngle(180, 1)
    
    timeoutTimer = CreateTimer("timeout")
    SetTimerValue(timeoutTimer, 180)
    
    OnTimerElapse(
        function(timer)
            MissionVictory(DEF)
            ShowTimer(nil)
            DestroyTimer(timer)
        end,
        timeoutTimer
        )

    timePop = CreateTimer("timePop")
    SetTimerValue(timePop, 1.3)

    onfirstspawn = OnCharacterSpawn(
        function(character)
            if IsCharacterHuman(character) then
                ReleaseCharacterSpawn(onfirstspawn)
                onfirstspawn = nil
                ScriptCB_EnableCommandPostVO(0)
                ScriptCB_PlayInGameMusic("rep_nab_amb_obj1_2_explore")
                StartTimer(timePop)                                
                OnTimerElapse(
                    function(timer)
                        ScriptCB_SndPlaySound("NAB_obj_22")
                        StartObjectives()
                end,
                timePop
                )   
             end
        end)
        
--        onfirstspawn = OnCharacterSpawn(
--        function(character)
--            if IsCharacterHuman(character) then
--                ReleaseCharacterSpawn(onfirstspawn)
--                onfirstspawn = nil
--                ScriptCB_EnableCommandPostVO(0)
--                StartTimer(timePop)                                
--                OnTimerElapse(
--                  function(timer)
--                      StartObjectives()
--                      DestroyTimer(timer)
--                      StartTimer(timeoutTimer)
--                          StartTimer(FirstTransport)
--                          StartTimer(RealFirstTransport)
--                  end,
--              timePop
--              )          
--             end
--        end)
        
-- Turret Kill Conditions --

    OnObjectKillName(LConsoleKill, "lconsole1");
    OnObjectKillName(LConsoleKill, "lconsole2");
--  KillObject("tankspawn")
--  KillObject("tank01")
--  KillObject("tank02")
    
    

GuardSwitch = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            SwitchPathGar()
            DeactivateRegion("guardcontrol")
        end
    end,
    "guardcontrol"
    )
    
TurretWarning = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            TurretTalk()
            DeactivateRegion("turrettalk")
        end
    end,
    "turrettalk"
    )
    
    
-- Mission Setup -- 
    SetProperty("newhot", "IsVisible", 0)
    SetProperty("tankspawn", "IsVisible", 0)
    SetProperty ("Plaza", "SpawnPath","")
    SetProperty ("Plaza","team",DEF)
    ActivateRegion("turrettalk")
    
    SetProperty ("Office","team",DEF)
    SetProperty ("GuardPost","team",DEF)
    SetProperty ("Palace","team",DEF)
    BlockPlanningGraphArcs("blockleft")
    SetAIDamageThreshold("lconsole3", 0.8)
    
    SetProperty("cgun1", "MaxHealth", 38500)
    SetProperty("cgun1", "CurHealth", 38500)
    SetProperty("cgun2", "MaxHealth", 38500)
    SetProperty("cgun2", "CurHealth", 38500)
    SetProperty("cgun3", "MaxHealth", 38500)
    SetProperty("cgun3", "CurHealth", 38500)

    ScriptCB_PlayInGameMovie("ingame.mvs","nabmon01")

    KillObject ("Embassy")
    KillObject ("Office")
    KillObject ("GuardPost")
    KillObject ("Palace")
    KillObject ("Plaza")

--Set up the ambushes here
    SetupAmbushTrigger("ambush_trigger_plaza", "ambush_trigger_path_plaza", ambushCount1, ambushTeam1)
    SetupAmbushTrigger("ambush_trigger_plaza", "obj1path1", ambushCount2, ambushTeam2)
    SetupAmbushTrigger("ambush_trigger_plaza", "obj1path2", ambushCount3, ambushTeam3)
    SetupAmbushTrigger("plaza1cap", "obj1path4", ambushCount2, ambushTeam2)
    SetupAmbushTrigger("plaza1cap", "obj1path5", ambushCount3, ambushTeam3)
    SetupAmbushTrigger("ambush_trigger_embassy", "ambush_trigger_path_embassy", ambushCount2, ambushTeam2)
    SetupAmbushTrigger("ambush_trigger_uppereast", "ambush_trigger_path_uppereast", ambushCount3, ambushTeam3)
    SetupAmbushTrigger("ambush_trigger_upperwest", "ambush_trigger_path_upperwest", ambushCount4, ambushTeam4)
--    SetupAmbushTrigger("ambush_trigger_centerleft", "ambush_trigger_path_centerleft", ambushCount5, ambushTeam5)
--    SetupAmbushTrigger("ambush_trigger_centerright", "ambush_trigger_path_centerright", ambushCount6, ambushTeam6) 
    
    AddAIGoal(GAR, "Deathmatch", 1)
    AddAIGoal(IMP, "Deathmatch", 1)
    AddAIGoal(QUE, "Deathmatch", 1)
    AddAIGoal(ROY, "Deathmatch", 1)
        
----------------------------------------------------------------------------------------------------------------  
--
--  1. Conquest Objective for Plaza
--  
    Objective1CP = CommandPost:New{name = "plaza1", hideCPs = false}
    Objective1 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.naboo2.objectives.Campaign.1", popupText = "level.naboo2.objectives.Campaign.1_popup"}
    Objective1:AddCommandPost(Objective1CP)
    
    Objective1.OnStart = function (self)
--      SetSpawnDelayTeam(10.0, 1.5, NEW)
--        AICanCaptureCP("plaza1", ATT, false)
        Objective1.defGoal1 = AddAIGoal(NEW, "Defend", 500, "insert")
        Objective1.defGoal2 = AddAIGoal(NEW, "Defend", 500, "cgun1")
        Objective1.defGoal3 = AddAIGoal(NEW, "Defend", 200, "plaza1")
        --Ambush("nabgar1", numRoyalGuards, ROY)
        --Ambush("nabgar1", ambushCount4, ambushTeam4)
        AddAIGoal (DEF, "Deathmatch",1)
        AddAIGoal (ATT, "Deathmatch",1)
        --SetUnitCount(ATT, 1)
        --SetReinforcementCount(ATT, 5)
        SetProperty("newhot", "AISpawnWeight", "3000")
        SetProperty ("plaza1", "SpawnPath","firstspawn")
        --Moderate Hack: makes sure the teams always have at least one goal
        
    end
    
    Objective1.OnComplete = function (self)
    	ShowMessageText("game.objectives.complete", ATT)
        SetProperty("plaza1", "CaptureRegion", "distraction")
        KillObject("insert")
        SetProperty ("Plaza", "SpawnPath","plazapath")
        SetProperty ("plaza1", "SpawnPath","plaza1spawn")
--      SetReinforcementCount (ATT,50)
        local CurReinforcements = GetReinforcementCount(ATT)
              SetReinforcementCount(ATT, CurReinforcements + 20)
        BatchChangeTeams(extraStormtrooperTeam, ATT, numExtraStormtroopers)
        AllowAISpawn(ATT, true)
--        AddUnitClass(IMP, "imp_inf_rifleman",10)
--        AddUnitClass(IMP, "imp_inf_rocketeer",3)
--        AddUnitClass(IMP, "imp_inf_pilot_atst",2)
--        AddUnitClass(IMP, "imp_inf_sniper",2)
--        AddUnitClass(IMP, "imp_inf_dark_trooper",2)
        RespawnObject("Plaza")
        Objective1.defGoal1 = AddAIGoal(IMP, "Defend", 5000, "Plaza")
        if self.winningTeam == DEF then
            ScriptCB_SndPlaySound("NAB_obj_28")
        else
            --play the win sound
            ScriptCB_SndPlaySound("NAB_obj_25")
        end
    end
    
    ----------------------------------------------------------------------------------------------------------------   
    --  
    --  3. Conquest Objective for Office
    --  
    
--  Objective3CP = CommandPost:New{name = "Office", hideCPs = false}
--  Objective3 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.naboo2.objectives.Campaign.3", popupText = "level.naboo2.objectives.Campaign.3_popup"}
--  Objective3:AddCommandPost(Objective3CP)
--  
--  Objective3.OnStart = function (self)
--      SetReinforcementCount (ATT,175)
--        BatchChangeTeams(extraStormtrooperTeam, ATT, numExtraStormtroopers)
--        AllowAISpawn(ATT, true)
--        AddUnitClass(IMP, "imp_inf_rifleman",10)
--        AddUnitClass(IMP, "imp_inf_rocketeer",3)
--        AddUnitClass(IMP, "imp_inf_pilot_atst",2)
--        AddUnitClass(IMP, "imp_inf_sniper",2)
--        AddUnitClass(IMP, "imp_inf_dark_trooper",2)
--      ScriptCB_SndPlaySound("nab_obj_13")
--      RespawnObject ("Office")
--      --SetUnitCount(ATT, 20)     --Currently, we can't do this because the AI's won't spawn in if they have no goals...can probably put this in later once Greg fixes his spawning logic
--      SetReinforcementCount(ATT, 150)
--      SetProperty ("Office","Value_ATK_Empire",10)
--      SetProperty ("Office","Value_DEF_Alliance",10)
--      DeactivateRegion("cp_trigger_left")
--      DeactivateRegion("cp_trigger_center")
--      DeactivateRegion("cp_trigger_right")
--    end

--  MainframeString = "level.tan1.objectives.2-"
--    Cconsole01 = Target:New{name = "cconsole1"}
--    Cconsole02 = Target:New{name = "cconsole2"}
--
--    Objective3_1 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, text = "level.naboo2.objectives.Campaign.3_1", popupText = "level.naboo2.objectives.Campaign.3_1_popup"}
--    Objective3_1:AddTarget(Cconsole01)
--    Objective3_1:AddTarget(Cconsole02)
    
    
    Objective3_2CP = CommandPost:New{name = "Plaza", hideCPs = false}
    Objective3_2 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.naboo2.objectives.Campaign.3_2", popupText = "level.naboo2.objectives.Campaign.3_2_popup"}
    Objective3_2:AddCommandPost(Objective3_2CP)
    
    Objective3_2.OnStart = function (self)
    	SetObjectTeam("plaza1", 1)
        SetupAmbushTrigger("plazatrigger", "plazaambush1", ambushCount1, ambushTeam1)
        SetupAmbushTrigger("plazatrigger", "plazaambush2", ambushCount2, ambushTeam2)
        SetupAmbushTrigger("plazatrigger", "plazaambush3", ambushCount3, ambushTeam3)
        SetupAmbushTrigger("EmbassyCapture", "plazaambush2", ambushCount2, ambushTeam2)
        SetupAmbushTrigger("EmbassyCapture", "plazaambush3", ambushCount3, ambushTeam3)
        SetupAmbushTrigger("EmbassyCapture", "plazabushnew", ambushCount1, ambushTeam1)
        
        SetProperty("Plaza", "AISpawnWeight", "3000")
        SetProperty ("Plaza", "SpawnPath","newobjpath2")
        AICanCaptureCP("Plaza", ATT, false)
        
    end
    
    Objective3_2.OnComplete = function (self)
    	ShowMessageText("game.objectives.complete", ATT)
        SetObjectTeam("tankspawn", 2)
        Ambush("newamb", ambushCount4, ambushTeam4)
        SetProperty("Plaza", "CaptureRegion", "distraction")
        SetProperty("Plaza1", "AISpawnWeight", "10")
--      SetProperty("Plaza", "AISpawnWeight", "3000")
        SetProperty ("Plaza", "SpawnPath","plazapath")
        local CurReinforcements2 = GetReinforcementCount(ATT)
                                        SetReinforcementCount(ATT, CurReinforcements2 + 40)
        ClearAIGoals(DEF);
        DeleteAIGoal(Objective1.defGoal1)
        
        Objective3_2.defGoal1 = AddAIGoal(DEF, "Defend", 5000, "Plaza")
        Objective3_2.defGoal2 = AddAIGoal(IMP, "Defend", 5000, "GuardPost")
        ActivateRegion("guardcontrol")
        if self.winningTeam == DEF then
            ScriptCB_SndPlaySound("NAB_obj_28")
        else
            --play the win sound
            ScriptCB_SndPlaySound("NAB_obj_26")
            ScriptCB_PlayInGameMusic("rep_nab_objComplete_01")
             -- Music Timer -- 
         music01Timer = CreateTimer("music01")
        SetTimerValue(music01Timer, 12.0)
                              
            StartTimer(music01Timer)
            OnTimerElapse(
                function(timer)
                ScriptCB_StopInGameMusic("rep_nab_objComplete_01")
                ScriptCB_PlayInGameMusic("rep_nab_amb_obj3_4_explore")
                DestroyTimer(timer)
            end,
            music01Timer
        )
        end
    end
    ---------------------------------------------------------------------------------------------------------------
    --
    --  4. Conquest Objective for GuardPost
    --
    Objective4CP = CommandPost:New{name = "GuardPost", hideCPs = false}
    Objective4 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.naboo2.objectives.Campaign.4", popupText = "level.naboo2.objectives.Campaign.4_popup"}
    Objective4:AddCommandPost(Objective4CP)
    
    Objective4.OnStart = function (self)
    	SetObjectTeam("Plaza", 1)
        AICanCaptureCP("GuardPost", ATT, false)
        RespawnObject ("GuardPost")     
    end 
    
    Objective4.OnComplete = function (self)
    	ShowMessageText("game.objectives.complete", ATT)
        SetProperty("GuardPost", "CaptureRegion", "distraction")
        SetProperty ("GuardPost", "SpawnPath", "GuardPostSpawn")
        local CurReinforcements2 = GetReinforcementCount(ATT)
                                        SetReinforcementCount(ATT, CurReinforcements2 + 5)
        if self.winningTeam == DEF then
            ScriptCB_SndPlaySound("NAB_obj_28")
        else
            --play the win sound
            ScriptCB_SndPlaySound("NAB_obj_23")
        end
    end
    
    Cconsole4_1 = Target:New{name = "lconsole3"}

    Objective4_1 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, text = "level.naboo2.objectives.Campaign.4_1", popupText = "level.naboo2.objectives.Campaign.4_1_popup"}
    Objective4_1:AddTarget(Cconsole4_1)
    
    Objective4_1.OnStart = function (self)
    	SetObjectTeam("GuardPost", 1)
    	SetProperty("lconsole3", "MaxHealth", 250)
    	SetProperty("lconsole3", "CurHealth", 250)
        Ambush("consolepro", ambushCount3, ambushTeam3)
        Ambush("consolepro", ambushCount2, ambushTeam2)
    end
    
    Objective4_1.OnComplete = function (self)
    	ShowMessageText("game.objectives.complete", ATT)
        DeleteAIGoal(Objective3_2.defGoal2)
    	KillObject("cgun1")
    	KillObject("cgun2")
    	KillObject("cgun3")
        SetObjectTeam("cgun1", 0)
        SetObjectTeam("cgun2", 0)
        SetObjectTeam("cgun3", 0)
        local CurReinforcements2 = GetReinforcementCount(ATT)
                                        SetReinforcementCount(ATT, CurReinforcements2 + 20)
        if self.winningTeam == DEF then
            ScriptCB_SndPlaySound("NAB_obj_29")
        else
            --play the win sound
            ScriptCB_SndPlaySound("NAB_obj_17")
            ScriptCB_PlayInGameMusic("rep_nab_act_01")
        end
    end
    
    ----------------------------------------------------------------------------------------------------------------
    ----
    --  5. Kill the royal guard jedis
    ----
    
    Objective5 = Objective:New{teamATT = ATT, teamDEF = DEF, text ="level.naboo2.objectives.campaign.5", popupText = "level.naboo2.objectives.campaign.5_popup"}
    Objective5.OnStart = function (self)
--      SetObjectTeam("newhot", 2)
        Ambush("ambush_trigger_path_royal", numInitialRoyalGuards, ROY, 0.2)
        
        
        jed_count = numRoyalGuards
        queen_dead = false
        Objective5JedKill = OnObjectKill( 
            function(object, killer)
                local CheckObjectiveComplete = function()
                    if queen_dead then
                        Objective5:Complete(ATT)
                        ReleaseObjectKill(Objective5JedKill)
                    end
                end
                
                if GetObjectTeam(object) == ROY then
                    if jed_count > 0 then
                        jed_count = jed_count - 1 
                    end
                    
                    --Mark the jedi guards after a few of them are dead
                    if jed_count == (numRoyalGuards - 4) then
                        MapAddClassMarker("jed_knight_01", "hud_objective_icon", 3.5, ATT, "YELLOW", true)
                        MapAddClassMarker("jed_knight_02", "hud_objective_icon", 3.5, ATT, "YELLOW", true)
                        MapAddClassMarker("jed_knight_03", "hud_objective_icon", 3.5, ATT, "YELLOW", true)
                        MapAddClassMarker("jed_knight_04", "hud_objective_icon", 3.5, ATT, "YELLOW", true)
                    end
                    
                    if jed_count == (numRoyalGuards - numInitialRoyalGuards) then
                        --when we get rid of all the initial guards...
                        
--                      ShowMessageText ("level.naboo2.objectives.campaign.7",1)
                        --TODO: put a VO and a MessageText here
                        ScriptCB_SndPlaySound("NAB_obj_27")  
                        --spawn the queen
                        Ambush("ambush_trigger_path_queen", 1, QUE, 0.7)  
                        MapAddClassMarker("gar_inf_naboo_queen", "hud_objective_icon", 3.5, ATT, "YELLOW", true)
                        ShowTimer(timeoutTimer)
                        StartTimer(timeoutTimer)                        
                        
                        --spawn the rest of the guards
                        Ambush("ambush_trigger_path_royal", jed_count, ROY, 0.2)
                        Objective5.guardAIGoal = AddAIGoal(ROY, "Defend", 5000, GetTeamMember(QUE, 0))
                        MapRemoveClassMarker("jed_knight_01")   --remove the markers because you aren't *required* to kill the rest of the guards
                        MapRemoveClassMarker("jed_knight_02")
                        MapRemoveClassMarker("jed_knight_03")
                        MapRemoveClassMarker("jed_knight_04")
                    elseif jed_count == 0 then  
                        CheckObjectiveComplete()
                    end 
                elseif GetObjectTeam(object) == QUE then
                    queen_dead = true
                    CheckObjectiveComplete()
                end 
            end 
            )  
    end
        
    Objective5.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
        if self.winningTeam == self.teamDEF then 
            ScriptCB_SndPlaySound("NAB_obj_29")
        elseif self.winningTeam == self.teamATT then
            ScriptCB_SndPlaySound("NAB_obj_16")
            StopTimer(timeoutTimer)
            --ShowMessageText("your team lost localize") 
        end
    end
end        
    -----------------------------------------------------------------------------------------------------------------
    --
    --  objective "container"           
    --  
    function StartObjectives() 
    objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 10.0}
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:AddObjectiveSet(Objective3_2)
    objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:AddObjectiveSet(Objective4_1)
    objectiveSequence:AddObjectiveSet(Objective5)
    objectiveSequence:Start()
end

function SwitchPathGar()
    SetProperty ("GuardPost", "SpawnPath", "officepath2")
    SetObjectTeam("tankspawn", 0)
end

function TurretTalk()
    ScriptCB_SndPlaySound("NAB_obj_24")
end

function LConsoleKill()
    Console1 = Console1 - 1 
        if Console1 == 0 then      
           LTurretOff()
          else
            ShowMessageText("level.myg1.obj.c8", 1)
        end
end

function LConsoleKill2()
    ShowMessageText("level.myg1.obj.c8", 1)
end

function LTurretOff()
    ShowMessageText("level.myg1.obj.c8", 1)
end
    

-----------------------------
    -- 
    --  SCRIPTINIT
    --

function ScriptInit()
    StealArtistHeap(1400*1024)
    SetPS2ModelMemory(2900000)
    ReadDataFile("ingame.lvl")

    local weaponCnt = 200
    SetMemoryPoolSize("Aimer", 69)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 150)
    SetMemoryPoolSize("Combo::Attack", 144)
    SetMemoryPoolSize("Combo::Transition", 150)
    SetMemoryPoolSize("Combo::Condition", 150)
    SetMemoryPoolSize("Combo::DamageSample", 950)
    SetMemoryPoolSize("Combo::Deflect", 20)
    SetMemoryPoolSize("Combo::State", 200)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityHover", 6)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntitySoundStream", 1)
    SetMemoryPoolSize("EntitySoundStatic", 44)
    SetMemoryPoolSize("MountedTurret", 21)
    SetMemoryPoolSize("Navigator", 54)
    SetMemoryPoolSize("Obstacle", 450)
    SetMemoryPoolSize("PathFollower", 54)
    SetMemoryPoolSize("PathNode", 300)
    SetMemoryPoolSize("ShieldEffect", 0)
    SetMemoryPoolSize("TreeGridStack", 350)
    SetMemoryPoolSize("UnitAgent", 54)
    SetMemoryPoolSize("UnitController", 54)
    SetMemoryPoolSize("Weapon", weaponCnt)
    
    ReadDataFile("sound\\nab.lvl;nab2gcw")
    
    ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_hover_fightertank",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_officer",
                    "imp_inf_dark_trooper")
                             
    ReadDataFile("SIDE\\gar.lvl",
                             "gar_inf_soldier",
                             "gar_inf_naboo_queen")
                             
    ReadDataFile("SIDE\\jed.lvl",
                    "jed_knight_01",
                    "jed_knight_02",
                    "jed_knight_03",
                     "jed_knight_04")                             
      
    ReadDataFile("SIDE\\all.lvl",
--                     "gar_inf_naboo_queen",
                     "all_hover_combatspeeder")
                     
    ReadDataFile("SIDE\\tur.lvl",
                "tur_bldg_recoilless_nab_auto") 

    ReadDataFile("SIDE\\tur.lvl", 
                "tur_weap_built_gunturret",
                "tur_bldg_laser")          
                 
                
    ScriptCB_SetSpawnDisplayGain(0.2, 0.5)          
    
   
   -- set up teams
    SetupTeams{
        imp = {
            team = IMP,
            units = 12,
            reinforcements = 50,
            soldier  = { "imp_inf_rifleman", 12, 50},
            assault  = { "imp_inf_rocketeer", 4, 50},
            engineer = { "imp_inf_engineer", 3, 50},
            sniper   = { "imp_inf_sniper", 3, 50},
            officer =  { "imp_inf_officer", 3, 4},
            special = { "imp_inf_dark_trooper", 3, 4},
        },
        all = {
            team = GAR,
            units = 21,
            reinforcements = -1,
            soldier  = { "gar_inf_soldier", 4, 50 },
        },  
    }
    
    SetupTeams{
        all = {
            team = NEW,
            units = 10,
            reinforcements = -1,
            soldier = { "gar_inf_soldier"},
        }
    }
    
    --AllowAISpawn(IMP, false)
    
    --the queen's team
    AddUnitClass(QUE, "gar_inf_naboo_queen")
    SetUnitCount(QUE, 1)
    SetTeamAsEnemy(QUE, ATT)
    ClearAIGoals(QUE)
    AddAIGoal(QUE, "Deathmatch", 100)
    --SetTeamAsFriend(ambushTeam1, CIS)
    
    --the royal guards (a bunch of jedis)
    AddUnitClass(ROY, "jed_knight_01",4,50)
    AddUnitClass(ROY, "jed_knight_02",4,50)
    AddUnitClass(ROY, "jed_knight_03",4,50)
    AddUnitClass(ROY, "jed_knight_03",3,50)
    SetUnitCount(ROY, numRoyalGuards)
    SetTeamAsEnemy(ROY, ATT)
    ClearAIGoals(ROY)
--  AddAIGoal(ROY, "Deathmatch", 100)
    AddAIGoal(ROY, "Defend", 6000, "tankspawn")
    
    -- Friends and Enemies Section -

    SetTeamAsEnemy(NEW, ATT)
    SetTeamAsFriend(GAR, QUE)
    SetTeamAsFriend(GAR, ROY)
    SetTeamAsFriend(GAR, NEW)
    SetTeamAsFriend(QUE, GAR)
    SetTeamAsFriend(QUE, ROY)
    SetTeamAsFriend(QUE, NEW)
    SetTeamAsFriend(ROY, GAR)
    SetTeamAsFriend(ROY, QUE)
    SetTeamAsFriend(ROY, NEW)
    SetTeamAsFriend(NEW, QUE)
    SetTeamAsFriend(NEW, ROY)
    SetTeamAsFriend(NEW, GAR)       
    
    
    -- NEW TEAM
    
    
    
    --
    
    --an extra pool for stormtroopers
    --AddUnitClass(extraStormtrooperTeam, "imp_inf_rifleman")
    --SetUnitCount(extraStormtrooperTeam, numExtraStormtroopers)

    

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- 8 droidekas with 0 leg pairs each

--    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("NAB\\nab2.lvl","naboo2_Campaign")
    SetDenseEnvironment("true")
    --AddDeathRegion("Water")
    AddDeathRegion("Waterfall")
    --SetMaxFlyHeight(20)

    

    --  Sound

    voiceSlow = OpenAudioStream("sound\\global.lvl", "nab_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow) 
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "imp_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "all_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl",  "global_vo_quick", voiceQuick)       
         
     OpenAudioStream("sound\\global.lvl",  "cw_music")
     -- OpenAudioStream("sound\\nab.lvl",  "nab_objective_vo_slow")
     -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
     OpenAudioStream("sound\\nab.lvl",  "nab2")
     OpenAudioStream("sound\\nab.lvl",  "nab2")
     OpenAudioStream("sound\\nab.lvl",  "nab2_emt")

     -- SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
     -- SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
     SetBleedingVoiceOver(IMP, GAR, "imp_off_com_report_enemy_losing",   1)
     SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

     -- SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
     -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
     SetLowReinforcementsVoiceOver(IMP, GAR, "imp_off_defeat_im", .1, 1)
     SetLowReinforcementsVoiceOver(IMP, GAR, "imp_off_victory_im", .1, 1)

     SetOutOfBoundsVoiceOver(1, "impleaving")
     SetOutOfBoundsVoiceOver(2, "allleaving")

     -- SetAmbientMusic(ALL, 1.0, "all_nab_amb_start",  0,1)
     -- SetAmbientMusic(ALL, 0.99, "all_nab_amb_middle", 1,1)
     -- SetAmbientMusic(ALL, 0.1,"all_nab_amb_end",    2,1)
     -- SetAmbientMusic(IMP, 1.0, "imp_nab_amb_start",  0,1)
     -- SetAmbientMusic(IMP, 0.99, "imp_nab_amb_middle", 1,1)
     -- SetAmbientMusic(IMP, 0.1,"imp_nab_amb_end",    2,1)

     -- SetVictoryMusic(ALL, "all_nab_amb_victory")
     -- SetDefeatMusic (ALL, "all_nab_amb_defeat")
     SetVictoryMusic(IMP, "cis_nab_amb_victory")
     SetDefeatMusic (IMP, "cis_nab_amb_defeat")

     SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
     SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
     
     SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
     SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
     SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
     SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
     SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

    

    --  Camera Stats
    --Nab2 Theed
    --Palace
            AddCameraShot(0.038177, -0.005598, -0.988683, -0.144973, -0.985535, 18.617458, -123.316505);

            AddCameraShot(0.993106, -0.109389, 0.041873, 0.004612, 6.576932, 24.040697, -25.576218);

            AddCameraShot(0.851509, -0.170480, 0.486202, 0.097342, 158.767715, 22.913860, -0.438658);

            AddCameraShot(0.957371, -0.129655, -0.255793, -0.034641, 136.933548, 20.207420, 99.608246);

            AddCameraShot(0.930364, -0.206197, 0.295979, 0.065598, 102.191856, 22.665434, 92.389435);

            AddCameraShot(0.997665, -0.068271, 0.002086, 0.000143, 88.042351, 13.869274, 93.643898);

            AddCameraShot(0.968900, -0.100622, 0.224862, 0.023352, 4.245263, 13.869274, 97.208542);

            AddCameraShot(0.007091, -0.000363, -0.998669, -0.051089, -1.309990, 16.247049, 15.925866);

            AddCameraShot(-0.274816, 0.042768, -0.949121, -0.147705, -55.505108, 25.990822, 86.987534);

            AddCameraShot(0.859651, -0.229225, 0.441156, 0.117634, -62.493008, 31.040747, 117.995369);

            AddCameraShot(0.703838, -0.055939, 0.705928, 0.056106, -120.401054, 23.573559, -15.484946);

            AddCameraShot(0.835474, -0.181318, -0.506954, -0.110021, -166.314774, 27.687098, -6.715797);

            AddCameraShot(0.327573, -0.024828, -0.941798, -0.071382, -109.700180, 15.415476, -84.413605);

            AddCameraShot(-0.400505, 0.030208, -0.913203, -0.068878, 82.372711, 15.415476, -42.439548);

end

