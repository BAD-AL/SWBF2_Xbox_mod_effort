-- SPACE 4 Battle over Mustafar
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("Objective")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("LinkedShields")
ScriptCB_DoFile("LinkedTurrets")
ScriptCB_DoFile("PlayMovieWithTransition")
    
--  Empire Attacking (attacker is always #1)
IMP = 1
CIS = 2
--  These variables do not change
ATT = 1
DEF = 2
 
 
 function ScriptPostLoad()
    SetAIDifficulty(2, -9, "medium")   
    KillObject("CAM_cp1")
    SetProperty("CP2", "Team", 2)
    SetAIDamageThreshold("cis_gunship", 0.3)
    SetProperty("land_box01", "IsVisible", 0)
    SetProperty("land_box01", "IsCollidable ", 0)
    SetProperty("shield_object", "IsVisible", 0)
    SetProperty("shield_object", "IsCollidable ", 0)
    SetProperty("shield_object", "MaxHealth", 999999)
    SetProperty("shield_object", "CurHealth", 999999)
--    DisableSmallMapMiniMap()
    ScriptCB_SetGameRules("campaign")
    SetProperty("cis_gunship", "MaxHealth", 16000)
    SetProperty("cis_gunship", "CurHealth", 16000)
    SetProperty("imp_door01", "IsLocked", 1)
    SetProperty("imp_door02", "IsLocked", 1)
    SetProperty("imp_door03", "IsLocked", 1)
    SetProperty("cis_door02", "IsLocked", 1)
    SetProperty("cis_door01", "IsLocked", 1)
    ScriptCB_PlayInGameMovie("ingame.mvs", "sb4mon01")
    SetMissionEndMovie("ingame.mvs", "sb4mon02")
    OnObjectKillName(PlayAnimCIS_mini02List, "CIS_mini02");
    
    ScriptCB_SetSpawnDisplayGain(0.2, 0.5)
    SetupLinkedObjects()

    onfirstspawn = OnCharacterSpawn(
        function(character)
            if IsCharacterHuman(character) then
                ReleaseCharacterSpawn(onfirstspawn)
                onfirstspawn = nil
                BeginObjectivesTimer()
                ScriptCB_EnableCommandPostVO(0)
                ScriptCB_PlayInGameMusic("rep_spa4_act_01")
            end
        end)
   
    --This is objective 3  Destroy the Landing Craft
    Command01 = Target:New{name = "cis_gunship", iconScale = 1.5}
    Command01.OnDestroy = function(self)
        ShowMessageText("level.spa2.objectives.campaign.c", 1)
    end
    
    Objective5 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
                              text = "level.spa4.objectives.campaign.5", popupText = "level.spa4.objectives.long.5"}
    Objective5:AddTarget(Command01)
    
    Objective5.OnStart = function(self)
--          ScriptCB_PlayInGameMusic("rep_spa4_amb_obj1_explore")
        ScriptCB_SndPlaySound("SPA4_inf_01")
        ScriptCB_SndPlaySound("SPA4_obj_20")
        shieldStuffCIS:ChangeAddShield(50000)
    end
    
    Objective5.OnComplete = function(self)
        ATTReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATTReinforcementCount + 20)    
        RespawnObject("CAM_cp1")
        KillObject("CAM_cp3")
        MapRemoveEntityMarker("cis_gunship")
        SetProperty("CAM_cp1", "Team", 1)
    end
 
--Objective 2 Start.  Kill 10 fighters
    ship_count = 8 
    objective1Ships = {"cis_fly_droidfighter_sc", "cis_fly_tridroidfighter", "cis_fly_greviousfighter"}
    Objective1 = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.spa4.objectives.campaign.1", popupText = "level.spa4.objectives.long.1"}
    
    Objective1.OnStart = function(self) 
        obj1GoalATT = AddAIGoal(ATT, "Deathmatch", 100)
        obj1GoalDEF = AddAIGoal(DEF, "Deathmatch", 100)
        ScriptCB_PlayInGameMusic("rep_spa4_objComplete_01")
        -- Music Timer -- 
        music01Timer = CreateTimer("music01")
        SetTimerValue(music01Timer, 16.0)
                              
            StartTimer(music01Timer)
            OnTimerElapse(
                function(timer)
                ScriptCB_StopInGameMusic("rep_spa4_objComplete_01")
                ScriptCB_PlayInGameMusic("rep_spa4_amb_obj2_3_explore")
                DestroyTimer(timer)
            end,
            music01Timer
                )  
        ScriptCB_SndPlaySound("SPA4_obj_21")
        ScriptCB_SndPlaySound("SPA4_obj_22")
--      BeginScreenTransition(0, .3, .4, .5, "FADE", "FADE")    
        Objective1ShipKillStart(objective1Ships)    
    end
    

    Objective1.OnComplete = function(self)
        ATTReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATTReinforcementCount + 15)    
        DeleteAIGoal(obj1GoalATT)
        DeleteAIGoal(obj1GoalDEF)
        ShowMessageText("level.spa2.objectives.campaign.c", 1)
        shieldStuffCIS:ChangeAddShield(500)
        SetProperty("CP2", "Team", 0)
        PlayAnimationFromTo("mini02", 0, 119)
    end

 
-- Start of Objective 3, Destroy the Shields
    shield01 = Target:New{name = "shieldgenCIS", iconScale = 0.0}
    shield01.OnDestroy = function(self)
        ShowMessageText("level.spa2.objectives.campaign.c", 1)
    end
    
    Objective2 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
                              text = "level.spa4.objectives.campaign.2", popupText = "level.spa4.objectives.long.2"}
    Objective2:AddTarget(shield01)
    
    Objective2.OnStart = function(self)
    MapAddEntityMarker("shield_object", "hud_objective_icon", 3.0, 1, "YELLOW", true)
            ScriptCB_SndPlaySound("SPA4_obj_23")    
--          BeginScreenTransition(0, .3, .4, .5, "FADE", "FADE")            
    end
    
    Objective2.OnComplete = function(self)
        ATTReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATTReinforcementCount + 15)
        MapRemoveEntityMarker("shield_object")
    end

    --setup objective 3 - Land in yonder hangar
    --
    Objective4 = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                            text = "level.spa4.objectives.campaign.4", popupText = "level.spa4.objectives.long.4"}
    Objective4.OnStart = function(self)
        --useful helper functions for the HUD markers
        local PutMarkerOnBomber = function()
            MapAddEntityMarker("cis_bomber", "hud_objective_icon", 3.0, 1, "YELLOW", true)
            MapRemoveEntityMarker("land_box01")
        end     
        local PutMarkerOnLandingRegion = function()
            MapAddEntityMarker("land_box01", "hud_objective_icon", 3.0, 1, "YELLOW", true)
            MapRemoveEntityMarker("cis_bomber")
        end
            
        -----------------------------------------------------
        -- Event responses to keep the markers updated
        self.initBomber = OnObjectInitName(
            function()
                PutMarkerOnBomber()
            end,
            "cis_bomber"
        )
        
        self.enterBomber = OnCharacterEnterVehicle(
            function (player, vehicle)
                if IsCharacterHuman(player) and GetEntityClass(vehicle) == GetEntityClassPtr("cis_fly_greviousfighter") then
                    PutMarkerOnLandingRegion()
                end
            end
        )
        
        self.landedBomber = OnCharacterLandedFlyer(
            function(player,vehicle)
                if IsCharacterHuman(player) and IsCharacterInRegion (player, "CAM_cp1Control") and 
                GetEntityClass(vehicle) == GetEntityClassPtr("cis_fly_greviousfighter") then
                    Objective4:Complete(ATT)
                end
            end
        )
        
        pickupmusic = OnEnterRegion(
            function(region, character) 
                if IsCharacterHuman(character) then 
                    ScriptCB_PlayInGameMusic("rep_spa4_immVict_01")
                end
            end,
        "Pickupreg"
        )       
        
        
        -----------------------------------------------------
        -- Init logic
        ActivateRegion("CAM_cp1Control")    --the region has to be activated before you can test whether a player is inside it...
        PutMarkerOnBomber()                 --just in case the bomber's already sitting there
        ActivateRegion("Pickupreg")         -- This region triggers music

        att_obj4_aigoal = AddAIGoal(ATT, "Deathmatch", 100)
        def_obj4_aigoal = AddAIGoal(DEF, "Deathmatch", 100) 
        ScriptCB_SndPlaySound("SPA4_obj_24")
        ScriptCB_PlayInGameMusic("rep_spa4_objComplete_02")
                
        -- Music Timer -- 
        music03Timer = CreateTimer("music03")
        SetTimerValue(music03Timer, 19.0)
                              
        StartTimer(music03Timer)
        OnTimerElapse(
            function(timer)
                ScriptCB_StopInGameMusic("rep_spa4_objComplete_02")
                ScriptCB_PlayInGameMusic("rep_spa4_amb_explore_04")
                DestroyTimer(timer)
            end,
            music03Timer
        ) 
    end
    
     Objective4.OnComplete = function(self)
        --clean up the event responses for this objective
        ReleaseObjectInit(self.initBomber)
        ReleaseCharacterLandedFlyer(self.landedBomber)
        ReleaseCharacterEnterVehicle(self.enterBomber)
        
        --clean up the map markers for this objective
        MapRemoveEntityMarker("land_box01")
        MapRemoveEntityMarker("cis_bomber")
        
        ScriptCB_SndPlaySound("SPA4_obj_25")
        ShowMessageText("level.spa2.objectives.campaign.c", ATT)
    end
 end

    function BeginObjectivesTimer()
    beginobjectivestimer = CreateTimer("beginobjectivestimer")
    OnTimerElapse(BeginObjectives, beginobjectivestimer)
    SetTimerValue(beginobjectivestimer, 3)
    StartTimer(beginobjectivestimer)
    end
 
    function BeginObjectives()
--This creates the objective "container" and specifies order of objectives, and gets that running           
    objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 6.0}
    objectiveSequence:AddObjectiveSet(Objective5)
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:AddObjectiveSet(Objective2)
    objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:Start()
    end
 
    function Objective1ShipKillStart(shipClasses)
        Objective1ShipKill = {}     --reminder: don't reuse this variable name (it's global!)
        for i, ship in ipairs (shipClasses) do
            Objective1ShipKill[i] = OnObjectKillClass (
                function (object, killer)
                    if killer and IsCharacterHuman (killer) then
                        ship_count = ship_count - 1
                        if ship_count > 0 then
                            ShowMessageText("level.spa.count." .. ship_count, 1)
                        elseif ship_count == 0 then
                            Objective1:Complete (ATT)
                            
                            --release all the "kill" event responses
                            for i, func in pairs(Objective1ShipKill) do
                                ReleaseObjectKill(func)
                            end
                        end
                    end                     
                end,
                ship
                )
        end
    end
 
 function SetupLinkedObjects()
    SetupShields()
 end
 
 function SetupShields()
    -- CIS Shielded objects    
    linkedShieldObjectsCIS = {"cis_fly_fedcruiser", "cis_fly_fedcruiser2", "cis_fly_fedcruiser3", "cis_fly_fedcruiser4",
                                "cis_fedcruiser_destruct1", "cis_fedcruiser_destruct2", "sensors_cis", "cis_fedcruiser_destruct4", "life_ext_cis"}
    shieldStuffCIS = LinkedShields:New{objs = linkedShieldObjectsCIS, maxShield = 150000, addShield = 1000, controllerObject = "shieldgenCIS"}
    shieldStuffCIS:Init()
    
    function shieldStuffCIS:OnAllShieldsDown() 
        ShowMessageText("level.spa.hangar.shields.atk.down", REP)
        ShowMessageText("level.spa.hangar.shields.def.down", CIS)
        EnableLockOn({"cis_fedcruiser_destruct1", "cis_fedcruiser_destruct2", "sensors_cis", "cis_fedcruiser_destruct4", "life_ext_cis"}, true)
    end
    
    function shieldStuffCIS:OnAllShieldsUp()
        ShowMessageText("level.spa.hangar.shields.atk.up", REP)
        ShowMessageText("level.spa.hangar.shields.def.up", CIS)
        EnableLockOn({"cis_fedcruiser_destruct1", "cis_fedcruiser_destruct2", "sensors_cis", "cis_fedcruiser_destruct4", "life_ext_cis"}, false)
    end
end
 
     function PlayAnimCIS_mini02List()
      PauseAnimation("mini02");
      PlayAnimation("turretevac");


    end
 

function ScriptPreInit()
   SetWorldExtents(2000)
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
     SetPS2ModelMemory(4608000)
     ReadDataFile("ingame.lvl")
    ReadDataFile("SPA\\spa_sky.lvl", "mus")
     
     ReadDataFile("sound\\spa.lvl;spa4cross")
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

     ReadDataFile("SIDE\\imp.lvl",
        "imp_inf_marine",
        "imp_inf_pilot",
        "imp_fly_tiefighter_sc",
        "imp_fly_tiebomber_sc",
        "imp_fly_tieinterceptor",
        "imp_fly_trooptrans",
        "imp_veh_remote_terminal")

    ReadDataFile("SIDE\\cis.lvl",
        "cis_inf_pilot",
        "cis_inf_marine",
        "cis_fly_fedlander_dome",
        "cis_fly_droidfighter_sc",  
        "cis_fly_droidfighter_dome",
        "cis_fly_greviousfighter",
        "cis_fly_droidgunship",
        "cis_fly_tridroidfighter")

    ReadDataFile("SIDE\\tur.lvl",
        "tur_bldg_spa_imp_beam",
        "tur_bldg_spa_imp_chaingun",
        "tur_bldg_spa_imp_recoilless")
        
SetupTeams{

        imp = {
            team = IMP,
            units = 10,
            reinforcements = 35,
            pilot    = { "imp_inf_pilot",6},
            marine   = { "imp_inf_marine",4},
        },

           cis = {
            team = CIS,
            units = 22,
            reinforcements = -1,
            pilot    = { "cis_inf_pilot",2},
            marine   = { "cis_inf_marine",20},
        }
     }

    --  Level Stats
    ClearWalkers()
    local weaponcnt = 220
    SetMemoryPoolSize("Aimer",187)
    SetMemoryPoolSize("AmmoCounter", weaponcnt)
    SetMemoryPoolSize("BaseHint", 15)
    SetMemoryPoolSize("CommandFlyer", 1)
    SetMemoryPoolSize("EnergyBar", weaponcnt)
    SetMemoryPoolSize("EntityDroid", 0)
    SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityLight", 100)
    SetMemoryPoolSize("EntityRemoteTerminal",6)
    SetMemoryPoolSize("EntitySoundStream",4)
    SetMemoryPoolSize("EntitySoundStatic", 2)
    SetMemoryPoolSize("FlagItem", 1)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 190)
    SetMemoryPoolSize("MountedTurret", 29)
    SetMemoryPoolSize("Navigator", 32)
    SetMemoryPoolSize("Obstacle",60)
    SetMemoryPoolSize("PathFollower", 32)
    SetMemoryPoolSize("PathNode",48)
    SetMemoryPoolSize("TreeGridStack",175)
    SetMemoryPoolSize("UnitAgent", 52)
    SetMemoryPoolSize("UnitController", 52)
    SetMemoryPoolSize("Weapon", weaponcnt)
    
    --if(gPlatformStr == "XBox") then 
    --    SetMemoryPoolSize ("Asteroid", 400)
    --elseif( gPlatformStr == "PS2") then
        SetMemoryPoolSize ("Asteroid", 200)
    --else -- PC
    --    SetMemoryPoolSize ("Asteroid", 600)
    --end

     SetSpawnDelay(10.0, 0.25)
     ReadDataFile("spa\\spa4.lvl")
     SetDenseEnvironment("false")
     --AddDeathRegion("deathregion")
     --SetStayInTurrets(1)


    --if(gPlatformStr == "XBox") then 
         --SetMaxCollisionDistance(1500)
        --FillAsteroidRegion("Ast-01", "spa_prop_jagged_asteroid_medium_stop", 200, 3.0,1.0,1.0, 0.0,-1.0,-1.0);
        --FillAsteroidPath("Ast-Path01", 120, "spa_prop_jagged_asteroid_large_stop", 50, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
        --FillAsteroidPath("Ast-Path01", 60, "spa_prop_jagged_asteroid_medium_stop", 50, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
        --FillAsteroidPath("Ast-Path02", 120, "spa_prop_jagged_asteroid_large_stop", 50, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
        --FillAsteroidPath("Ast-Path02", 60, "spa_prop_jagged_asteroid_medium_stop", 50, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
    --elseif( gPlatformStr == "PS2") then
         SetMaxCollisionDistance(1000)
        FillAsteroidRegion("Ast-01", "spa_prop_jagged_asteroid_medium_stop", 150, 3.0,1.0,1.0, 0.0,-1.0,-1.0);
        FillAsteroidPath("Ast-Path01", 120, "spa_prop_jagged_asteroid_large_stop", 25, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
        FillAsteroidPath("Ast-Path01", 60, "spa_prop_jagged_asteroid_medium_stop", 25, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
    --else -- PC
         --SetMaxCollisionDistance(2000)
        --FillAsteroidRegion("Ast-01", "spa1_prop_asteroid_03", 300, 3.0,1.0,1.0, 0.0,-1.0,-1.0);
        --FillAsteroidPath("Ast-Path01", 10, "spa1_prop_asteroid_03", 300, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
    
    --end


     --  Movies
     --  SetVictoryMovie(ALL, "all_end_victory")
     --  SetDefeatMovie(ALL, "imp_end_victory")
     --  SetVictoryMovie(IMP, "imp_end_victory")
     --  SetDefeatMovie(IMP, "all_end_victory")

        --  Sound   
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "spa1_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow) 
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "cis_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl",  "global_vo_quick", voiceQuick)  
        
      OpenAudioStream("sound\\global.lvl",  "cw_music")
      -- OpenAudioStream("sound\\spa.lvl",  "spa1_objective_vo_slow")
      -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
      OpenAudioStream("sound\\spa.lvl",  "spa")
      OpenAudioStream("sound\\spa.lvl",  "spa")
   
      -- SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
      -- SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
      -- SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
      -- SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)
   
      SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_defeat_im", .1, 1)
      SetLowReinforcementsVoiceOver(CIS, IMP, "cis_off_victory_im", .1, 1)
      SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
      SetLowReinforcementsVoiceOver(IMP, CIS, "imp_off_victory_im", .1, 1)
   
      SetOutOfBoundsVoiceOver(1, "impleaving")
      SetOutOfBoundsVoiceOver(2, "cisleaving")
   
      -- SetAmbientMusic(CIS, 1.0, "cis_spa_amb_start",  0,1)
      -- SetAmbientMusic(CIS, 0.99, "cis_spa_amb_middle", 1,1)
      -- SetAmbientMusic(CIS, 0.1,"cis_spa_amb_end",    2,1)
      -- SetAmbientMusic(IMP, 1.0, "rep_spa_amb_start",  0,1)
      -- SetAmbientMusic(IMP, 0.99, "rep_spa_amb_middle", 1,1)
      -- SetAmbientMusic(IMP, 0.1,"rep_spa_amb_end",    2,1)
   
      SetVictoryMusic(CIS, "cis_spa_amb_victory")
      SetDefeatMusic (CIS, "cis_spa_amb_defeat")
      SetVictoryMusic(IMP, "cis_spa_amb_victory")
      SetDefeatMusic (IMP, "cis_spa_amb_defeat")
   
      SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
      SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
        --  SetSoundEffect("BirdScatter",         "birdsFlySeq1")
      SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
      SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
      SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
      SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
      SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")
   
   
    AddLandingRegion("CAM_cp1Control")
    AddLandingRegion("CAM_cp2Control")
    
    
    AddCameraShot(0.989499, -0.065530, -0.128549, -0.008513, -838.517334, -71.441086, -195.525452);
    AddCameraShot(0.884973, 0.040352, 0.463410, -0.021130, -203.267563, -60.196301, -447.777649);
    AddCameraShot(-0.431075, -0.029634, -0.899706, 0.061850, 231.895462, -301.567230, -1920.007813);
    AddCameraShot(0.839080, 0.028718, 0.542931, -0.018582, -270.640900, -330.972931, -1771.432617);

    if (gPlatformStr == "PS2") then
        ScriptCB_DisableFlyerShadows()
    end
 end

