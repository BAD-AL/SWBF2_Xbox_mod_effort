-- SPACE 2 Battle over Coruscant
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


    --  Republic Attacking (attacker is always #1)
    REP = 1
    CIS = 2
    --  These variables do not change
    ATT = 1
    DEF = 2

--Load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("Objective")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("ObjectiveGoto")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("LinkedDestroyables")
ScriptCB_DoFile("LinkedShields")
ScriptCB_DoFile("PlayMovieWithTransition")
ScriptCB_DoFile("LinkedTurrets")
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
--    DisableSmallMapMiniMap()
    SetupTurrets() 
    SetAIDifficulty(2, -11, "medium")  
    SetProperty("Hangarobj", "IsVisible", 0)
    SetProperty("Hangarobj", "IsCollidable ", 0)
	SetProperty("spa_prop_liquidgen", "Team", 2)
    SetProperty("shi-ject", "IsVisible", 0)
    SetProperty("shi-ject", "IsCollidable ", 0)
    SetProperty("shi-ject", "MaxHealth", 999999)
    SetProperty("shi-ject", "CurHealth", 999999)

    ScriptCB_SetGameRules("campaign")
    ScriptCB_PlayInGameMovie("ingame.mvs", "sb2mon01")
    SetMissionEndMovie("ingame.mvs", "sb2mon02")
    SetProperty("CP4", "SpawnPath", "SP_spawn")
    PlayAnimationFromTo("Frig_01", 0, 119);
    ActivateRegion("obj_1reg")
    SetupLinkedObjects()

    SetAIDamageThreshold("comms_cis", 0.2)
    SetAIDamageThreshold("cisbridge01", 0.6)
    
    SetProperty("cisbridge01", "MaxHealth", 20000)
    SetProperty("cisbridge01", "CurHealth", 20000)
    
    SetProperty("ciseng01", "MaxHealth", 99999)
    SetProperty("ciseng01", "CurHealth", 99999)
    SetProperty("ciseng02", "MaxHealth", 99999)
    SetProperty("ciseng02", "CurHealth", 99999)
        
    SetProperty("rep_prop_shipturret3", "MaxHealth", 30000)
    SetProperty("rep_prop_shipturret3", "CurHealth", 30000)
    SetProperty("rep_prop_shipturret", "MaxHealth", 30000)
    SetProperty("rep_prop_shipturret", "CurHealth", 30000)

    SetProperty("rep_prop_shipturret3", "Team", 0)
    SetProperty("rep_prop_shipturret", "Team", 0)

    SetProperty("Rtlow01", "Team", 0)
    SetProperty("rtlow02", "Team", 0)
    SetProperty("rtlow3", "Team", 0)
    SetProperty("rtlow4", "Team", 0)
    SetProperty("rtlow5", "Team", 0)
    SetProperty("rtlow6", "Team", 0)

    SetProperty("cis_fedcruiser_door1", "IsLocked", 1)
    SetProperty("cis_fedcruiser_door2", "IsLocked", 1)
    
    SetProperty("rep_door01", "IsLocked", 1)
    SetProperty("rep_door02", "IsLocked", 1)
    
    SetProperty("lockedcis01", "IsLocked", 1)
    SetProperty("lockedcis02", "IsLocked", 1)
        
    SetProperty("fedmini01", "MaxHealth", 9999999)
    SetProperty("fedmini01", "CurHealth", 9999999)
    
    OnObjectKillName(PlayAnimCIS_mini01List, "fedmini01");

    --Objective1:Start()
    onfirstspawn = OnCharacterSpawn(
        function(character)
            if IsCharacterHuman(character) then
                ReleaseCharacterSpawn(onfirstspawn)
                onfirstspawn = nil
                BeginObjectivesTimer()
                ScriptCB_EnableCommandPostVO(0)
                ScriptCB_PlayInGameMusic("rep_spa2_amb_obj1_2_explore")
            end
        end)

    --This is objective 1 Start  Get into a ship and exit into space
    
    Objective1 = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.spa2.objectives.campaign.1", popupText = "level.spa2.objectives.long.1"}
    Objective1Complete = OnEnterRegion(
        function(region, character) 
            if IsCharacterHuman(character) then 
                Objective1:Complete(ATT)
                ReleaseEnterRegion(Objective1Complete)
            end
        end,
        "obj_1reg"
        )
    
        Objective1:AddHint("level.spa2.objectives.popup.1a")
        Objective1:AddHint("level.spa2.objectives.popup.1b")
    
    Objective1.OnStart = function(self)
        objectiveSequence.delayNextSetTime = 0.5
        ScriptCB_EnableCommandPostVO(0)
        ScriptCB_SndPlaySound("SPA2_obj_57")
        Objective1.Defgoal1 = AddAIGoal(ATT, "Defend", 100, "CP1")
        Objective1.Defgoal2 = AddAIGoal(DEF, "Defend", 100, "CP4")
        SetProperty("CP4", "SpawnPath", "CP4spawn")
        shieldStuffCIS:ChangeAddShield(50000)
    end

    Objective1.OnComplete = function(self)
        ShowMessageText("level.spa2.objectives.campaign.c", 1)
    end

--Objective 2 Start.  Kill 5 fighters
    ship_count = 5 
    objective2Ships = {"cis_fly_droidfighter_sc", "cis_fly_tridroidfighter"}
    Objective2 = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.spa2.objectives.campaign.2", popupText = "level.spa2.objectives.long.2"}
    
        Objective2:AddHint("level.spa2.objectives.popup.2a")
        Objective2:AddHint("level.spa2.objectives.popup.2b")
        Objective2:AddHint("level.spa2.objectives.popup.2c")

    Objective2.OnStart = function(self) 
        SetProperty("CP1", "Team", "2")
        ScriptCB_SndPlaySound("SPA2_obj_58")
        
        Objective2ShipKillStart(objective2Ships)    
        
        SetProperty("Rtlow01", "Team", 1)
        SetProperty("Rtlow02", "Team", 1)
        SetProperty("rtlow3", "Team", 1)
        SetProperty("rtlow4", "Team", 1)
        SetProperty("Rtlow5", "Team", 1)
        SetProperty("rtlow6", "Team", 1)
    end
    

    Objective2.OnComplete = function(self)
        ShowMessageText("level.spa2.objectives.campaign.c", 1)
        SetProperty("fedmini01", "MaxHealth", 30000)
        SetProperty("fedmini01", "CurHealth", 30000)
        
    end

    --This is objective 3  Destroy the Frigate
    frigate01 = Target:New{name = "fedmini01"}
    frigate01.OnDestroy = function(self)
        ShowMessageText("level.spa2.objectives.campaign.c", 1)
    end
    
    Objective3 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
                              text = "level.spa2.objectives.campaign.3", popupText = "level.spa2.objectives.long.3"}
    Objective3:AddTarget(frigate01)
    
        Objective3:AddHint("level.spa2.objectives.popup.3a")

    Objective3.OnStart = function(self)
            ScriptCB_SndPlaySound("SPA2_obj_59")
            ScriptCB_PlayInGameMusic("rep_spa2_objComplete_01")
            
     -- Music Timer -- 
     music01Timer = CreateTimer("music01")
    SetTimerValue(music01Timer, 14.0)
                          
        StartTimer(music01Timer)
        OnTimerElapse(
            function(timer)
            ScriptCB_StopInGameMusic("rep_spa2_objComplete_01")
            ScriptCB_PlayInGameMusic("rep_spa2_amb_obj3_5_explore")
            DestroyTimer(timer)
        end,
        music01Timer
        ) 
    end
    
    Objective3.OnComplete = function(self)
        shieldStuffCIS:ChangeAddShield(100)
    end

    --This is objective 4  Destroy the Shields
    shield01 = Target:New{name = "shield_cis", iconScale = 0.0}
    shield01.OnDestroy = function(self)
        ShowMessageText("level.spa2.objectives.campaign.c", 1)
    end
    
    Objective4 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
                              text = "level.spa2.objectives.campaign.4", popupText = "level.spa2.objectives.long.4"}
    Objective4:AddTarget(shield01)
    
        Objective4:AddHint("level.spa2.objectives.popup.4a")
    
    Objective4.OnStart = function(self)
    MapAddEntityMarker("shi-ject", "hud_objective_icon", 3.0, 1, "YELLOW", true)
        ScriptCB_SndPlaySound("SPA2_obj_60")
        SetProperty("rep_prop_shipturret3", "Team", 1)
        SetProperty("rep_prop_shipturret", "Team", 1)       
    end
    
    Objective4.OnComplete = function(self)
    MapRemoveEntityMarker("shi-ject")
        end


    --This is objective 5  Destroy the Comms
    Crit01 = Target:New{name = "comms_cis"}
    Crit01.OnDestroy = function(self)
        ShowMessageText("level.spa2.objectives.campaign.c", 1)
    end
    
    Objective5 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
                              text = "level.spa2.objectives.campaign.5", popupText = "level.spa2.objectives.long.5"}
    Objective5:AddTarget(Crit01)
    
        Objective5:AddHint("level.spa2.objectives.popup.5a")
        Objective5:AddHint("level.spa2.objectives.popup.5b")
                
    Objective5.OnStart = function(self)
    SetProperty("comms_cis", "MaxHealth", 20000)
    SetProperty("comms_cis", "CurHealth", 20000)
        ScriptCB_SndPlaySound("SPA2_obj_61")
    end
    
    Objective5.OnComplete = function(self)
        ActivateRegion("CP1Control")
        SetProperty("CP1", "SpawnPath", "Ambushlove")
        SetProperty("cis_fedcruiser_door1", "IsLocked", 0)
        SetProperty("cis_fedcruiser_door2", "IsLocked", 0)
    end

    --This is objective 6 Enter the enemy hangar
    
    Objective6 = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.spa2.objectives.campaign.6", popupText = "level.spa2.objectives.long.6"}
    
        Objective6:AddHint("level.spa2.objectives.popup.6a")
        Objective6:AddHint("level.spa2.objectives.popup.6b")

    Objective6.OnStart = function(self)
        Objective6Complete = OnCharacterLandedFlyer(
            function(player,flyer)
                if IsCharacterHuman(player) and IsCharacterInRegion (player, "CP1Control") then
                    Objective6:Complete(ATT)
                end
            end
            )   
        ScriptCB_SndPlaySound("SPA2_obj_62")
        ScriptCB_PlayInGameMusic("rep_spa2_objComplete_02")
     player_entered_hangar = 0
     player_left_hangar = 1
     
     playhangarmusic = OnEnterRegion(
        function(region, character)
            if IsCharacterHuman(character) and player_entered_hangar == 0 then
                print ("explore music should play")
                ScriptCB_StopInGameMusic("rep_spa2_amb_action_01")
                ScriptCB_PlayInGameMusic("rep_spa2_amb_obj7_explore")
                player_entered_hangar = 1
                player_left_hangar = 0
            end
        end,
        "CP1Control"
        )
        
     playspacemusic = OnLeaveRegion(
        function(region, character)
            if IsCharacterHuman(character) and player_left_hangar == 0 then
                print ("action music should play")
                ScriptCB_StopInGameMusic("rep_spa2_amb_obj7_explore")
                ScriptCB_PlayInGameMusic("rep_spa2_amb_action_01")              
                player_entered_hangar = 0
                player_left_hangar = 1
            end
        end,
        "CP1Control"
        )
     
     
     -- Music Timer -- 
    music02Timer = CreateTimer("music02")
    SetTimerValue(music02Timer, 33.0)
                      
    StartTimer(music02Timer)
    OnTimerElapse(
        function(timer)
        ScriptCB_StopInGameMusic("rep_spa2_objComplete_02")
        ScriptCB_PlayInGameMusic("rep_spa2_amb_action_01")
        DestroyTimer(timer)
    end,
    music02Timer
        )   
        MapAddEntityMarker("Hangarobj", "hud_objective_icon", 3.0, 1, "YELLOW", true)
    end

    Objective6.OnComplete = function(self)
        ShowMessageText("level.spa2.objectives.campaign.c", 1)
        MapRemoveEntityMarker("Hangarobj")
    end

    --This is objective 7  Destroy the Fuel Control Tanks
    Crit02 = Target:New{name = "engine_cis"}
    Crit02.OnDestroy = function(self)
        ShowMessageText("level.spa2.objectives.campaign.c", 1)
    end
    
    Objective7 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
                              text = "level.spa2.objectives.campaign.7", popupText = "level.spa2.objectives.long.7"}
    Objective7:AddTarget(Crit02)
    
        Objective7:AddHint("level.spa2.objectives.popup.7a")
        Objective7:AddHint("level.spa2.objectives.popup.7b")

    Objective7.OnStart = function(self)
    ScriptCB_SndPlaySound("SPA2_obj_64")
    SetProperty("ciseng01", "MaxHealth", 15000)
    SetProperty("ciseng01", "CurHealth", 15000)
    SetProperty("ciseng02", "MaxHealth", 15000)
    SetProperty("ciseng02", "CurHealth", 15000)
    end
    
    Objective7.OnComplete = function(self)
        ReleaseEnterRegion(playhangarmusic)
        ReleaseLeaveRegion(playspacemusic)
    end

    --This is objective 8  Destroy the Bridge
    Crit03 = Target:New{name = "cisbridge01"}
    Crit03.OnDestroy = function(self)
        ShowMessageText("level.uta1.objectives.temp.5c", 1)
    end
    
    Objective8 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
                              text = "level.spa2.objectives.campaign.8", popupText = "level.spa2.objectives.long.8"}
    Objective8:AddTarget(Crit03)
    
    Objective8.OnStart = function(self)
        ScriptCB_SndPlaySound("SPA2_obj_65")
        ScriptCB_PlayInGameMusic("rep_spa2_ImminentVict_01")
    
--      BeginScreenTransition(0, .8, .5, .5, "FADE", "FADE")    
    end
    
    Objective8.OnComplete = function(self)
    ScriptCB_SndPlaySound("SPA2_obj_66")
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
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:AddObjectiveSet(Objective2)
    objectiveSequence:AddObjectiveSet(Objective3)
    objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:AddObjectiveSet(Objective5)
    objectiveSequence:AddObjectiveSet(Objective6)
    objectiveSequence:AddObjectiveSet(Objective7)
    objectiveSequence:AddObjectiveSet(Objective8)

    objectiveSequence:Start()
end

function SetupLinkedObjects()
    SetupShields()
    SetupDestroyables()
--    SetupTurrets()  
end

function SetupShields()
    -- CIS Shielded objects    
    linkedShieldObjectsCIS = { "cis_fly_fedcruiser5", "cis_fly_fedcruiser1", "cis_fly_fedcruiser8", "cis_fly_fedcruiser9", 
                                "cisbridge01", "cis_prop_shipturret3", "cis_prop_shipturret1", "ciseng02", "ciseng01", "comms_cis"}
    shieldStuffCIS = LinkedShields:New{objs = linkedShieldObjectsCIS, maxShield = 70000, addShield = 2000, controllerObject = "shield_cis"}
    shieldStuffCIS:Init()
    
    function shieldStuffCIS:OnAllShieldsDown() 
        ShowMessageText("level.spa.hangar.shields.atk.down", REP)
        ShowMessageText("level.spa.hangar.shields.def.down", CIS)
        EnableLockOn({"cisbridge01", "ciseng02", "ciseng01", "comms_cis"}, true)
    end
end

function SetupDestroyables()
    --CIS destroyables
    engineLinkageCIS = LinkedDestroyables:New{ objectSets = {{"ciseng01", "ciseng02"}, {"engine_cis"}} }
    engineLinkageCIS:Init()
    
end

function Objective2ShipKillStart(shipClasses)
    Objective2ShipKill = {}     --reminder: don't reuse this variable name (it's global!)
    for i, ship in ipairs (shipClasses) do
        Objective2ShipKill[i] = OnObjectKillClass (
            function (object, killer)
                if killer and IsCharacterHuman (killer) then
                    ship_count = ship_count - 1
                    if ship_count > 0 then
                        ShowMessageText("level.spa.count." .. ship_count, 1)
                    elseif ship_count == 0 then
                        Objective2:Complete (ATT)
                        
                        --release all the "kill" event responses
                        for i, func in pairs(Objective2ShipKill) do
                            ReleaseObjectKill(func)
                        end
                    end
                end                     
            end,
            ship
            )
    end
end

function PlayAnimCIS_mini01List()
    PauseAnimation("Frig_01");
    RewindAnimation("Frig_02");
    SetAnimationStartPoint("Frig_02");
    PlayAnimation("Frig_02");
end

function SetupTurrets() 
    --CIS turrets
    LinkedTurretsCIS = LinkedTurrets:New{ team = CIS, mainframe = "spa_prop_liquidgen", 
                                          turrets = {"cisturr01","cisturr02", "cisturr03", "cisturr04", "cisturr05",
                                          			 "cisturr06","cisturr07", "cisturr08", "cisturr09", "cisturr10",
                                          			 "cisturr11","cisturr12"} }
    LinkedTurretsCIS:Init()
    function LinkedTurretsCIS:OnDisableMainframe()
        ShowMessageText("level.spa.hangar.mainframe.atk.down", REP)
        ShowMessageText("level.spa.hangar.mainframe.def.down", CIS)
        
        KillObject("cisturr01")
        KillObject("cisturr02")
        KillObject("cisturr03")
        KillObject("cisturr04")
        KillObject("cisturr05")
        KillObject("cisturr06")
        KillObject("cisturr07")
        KillObject("cisturr08")
        KillObject("cisturr09")
        KillObject("cisturr10")
        KillObject("cisturr11")
        KillObject("cisturr12")
        
        BroadcastVoiceOver( "ROSMP_obj_20", REP )
        BroadcastVoiceOver( "COSMP_obj_21", CIS )

    end
    function LinkedTurretsCIS:OnEnableMainframe()
        ShowMessageText("level.spa.hangar.mainframe.atk.up", REP)
        ShowMessageText("level.spa.hangar.mainframe.def.up", CIS)
        
        BroadcastVoiceOver( "ROSMP_obj_22", REP )
        BroadcastVoiceOver( "COSMP_obj_23", CIS )

    end
end


------------------------------------------------
-- Set flyer's controller config to some preset.
-- 1 is the default, obiwan.  2 is the second preset, anakin.
--
-- I'm thinking right now that the way this is implemented,
-- we're going to have trouble if this level is played in
-- splitscreen since I think the functions used look for the
-- primary viewport when there is no pausing port.  whee.
-- Popups don't show up in splitscreen by design anyway, 
-- so I'm not really sure what's supposed to happen in this case.
--
function SetFlyerControllerConfig(presetIdx)
    -- pc does not have all these obiwan anakin things.
    if(gPlatformStr ~= "PC") then
        print ("setting controller config...")
        -- shift over to flyer control mode
        local currentMode = ScriptCB_GetControlMode()
        if ( currentMode ~= 2 ) then
            ScriptCB_SetControlMode(2)
        end
        
        print ("presetIdx", presetIdx)
        local gAnalogButtonFunction0 = 17
        local controlMode = 2  -- 2 == flyer control
        local Mappings = gControllerPresets2[presetIdx].btndefs
        print ("looping...")

        local i,j,k,v
        j = 1
        for k,v in Platform_btn_map do
            if((v.type ~= 5) and (v.type ~= 99)) then 
                if ( v.name ~= "bsel" and v.name ~= "bstr" ) then
                    -- Get the Global functionID assigned to this button
                    --print ("k: ", k, " button: ", Mappings[j][2])
                    ScriptCB_SetFunctionIdForButtonId(k, Mappings[j][2], controlMode)

                    if(v.name == "lang") then
                        ScriptCB_SetFunctionIdForAnalogId(0, controlMode, Mappings[j][2] - gAnalogButtonFunction0)
                    elseif (v.name == "rang") then
                        ScriptCB_SetFunctionIdForAnalogId(1, controlMode, Mappings[j][2] - gAnalogButtonFunction0)
                    end
                end
                j = j + 1 -- move on in parallel array
            end -- type ~= 5
        end -- k,v loop over Platform_btn_map

        ScriptCB_SetYAxisFlip(gControllerPresets2[presetIdx].yFlip)
        ScriptCB_SetControlMode(currentMode)
    end
end

-- To flip only the y-axis
-- SetFlyerYAxisFlip( 0 or 1 ).
--
function SetFlyerYAxisFlip(flip)
    -- change axis on flyer control
    local currentMode = ScriptCB_GetControlMode()
    if ( currentMode ~= 2 ) then
        ScriptCB_SetControlMode(2)
    end
    
    ScriptCB_SetYAxisFlip(flip)
    
    -- set control mode back
    ScriptCB_SetControlMode(currentMode)
end

-- Get current y-axis status.  Returns 0 or 1.
--
function GetFlyerYAxisFlip()
    -- change axis on flyer control
    local currentMode = ScriptCB_GetControlMode()
    if ( currentMode ~= 2 ) then
        ScriptCB_SetControlMode(2)
    end
    
    local flip = ScriptCB_GetYAxisFlip()
    
    -- set control mode back
    ScriptCB_SetControlMode(currentMode)
    
    return flip
end

-- Bring up flyer config select display
-- Call this up when the hint/tip popup pops up.  This will cause the
-- player controller stuff to start paying attention to 
--
function TurnOnFlyerConfigSelect()
    ShowSelectionTextPopup("level.spa2.objectives.popup.selectConfig")
end
--
--------------------------------------------

function ScriptPreInit()
   SetWorldExtents(2600)
end

function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(1024 * 1024)
    SetPS2ModelMemory(4007152)
    ReadDataFile("ingame.lvl")
    ReadDataFile("SPA\\spa_sky.lvl", "cor")

     SetMinFlyHeight(-300)
     SetMaxFlyHeight(2000)
     SetMinPlayerFlyHeight(-300)
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
        "rep_inf_ep3_pilot",
        "rep_inf_ep3_marine",
        "rep_fly_assault_dome",
        "rep_fly_anakinstarfighter_sc",
        "rep_fly_arc170fighter_sc",        
        "rep_veh_remote_terminal",
        "rep_fly_vwing")
        
    ReadDataFile("SIDE\\cis.lvl",
        "cis_inf_pilot",
        "cis_inf_marine",
        "cis_fly_fedlander_dome",
        "cis_fly_droidfighter_sc",  
        "cis_fly_tridroidfighter")

     ReadDataFile("SIDE\\tur.lvl",
        "tur_bldg_chaingun_roof",
        "tur_bldg_spa_cis_recoilless",
        "tur_bldg_spa_cis_chaingun")

ScriptCB_SetSpawnDisplayGain(0.2, 0.5)        

SetupTeams{

         rep = {
            team = REP,
            units = 10,
            reinforcements = -1,
            pilot    = { "rep_inf_ep3_pilot",6},
            marine   = { "rep_inf_ep3_marine",4},
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
    SetMemoryPoolSize ("Aimer", 300)
    SetMemoryPoolSize ("BaseHint",39)
    SetMemoryPoolSize ("EntityDroid",0)
    SetMemoryPoolSize ("EntityFlyer", 34)
	SetMemoryPoolSize ("EntityLight", 50)
    SetMemoryPoolSize ("EntityRemoteTerminal",5)
    SetMemoryPoolSize ("FLEffectObject::OffsetMatrix", 180)
    SetMemoryPoolSize ("Obstacle",80)
    SetMemoryPoolSize ("PathNode",65)
    SetMemoryPoolSize ("UnitAgent",82)
    SetMemoryPoolSize ("TreeGridStack",200)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("spa\\spa2.lvl")
    SetDenseEnvironment("false")
    --AddDeathRegion("Sarlac01")
    -- SetMaxFlyHeight(90)
    -- SetMaxPlayerFlyHeight(90)

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
       -- OpenAudioStream("sound\\tat.lvl",  "tat1_emt")
   
       SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
       SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
       SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
       SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)
   
       SetOutOfBoundsVoiceOver(1, "Repleaving")
       SetOutOfBoundsVoiceOver(2, "Cisleaving")
   
       --SetAmbientMusic(REP, 1.0, "rep_spa2_amb_start",  0,1)
       --SetAmbientMusic(REP, 0.99, "rep_spa2_Amb01", 1,1)
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
    --Space Combat: Battle Over Corusant
    --Outside Shot
    AddCameraShot(0.726591, -0.504678, 0.382918, 0.265968, 365.396027, 2957.564697, -36.765766);
--  AddCameraShot(-0.304055, 0.030133, -0.947536, -0.093904, -351.252655, 854.305054, -1436.355469);
    AddCameraShot(0.971899, -0.218453, 0.085563, 0.019232, -374.445801, 1470.382690, 1090.691895);
    AddCameraShot(0.973537, -0.056299, -0.221117, -0.012787, -833.998962, 747.533630, -65.654213);
    AddCameraShot(-0.239058, -0.015277, -0.968909, 0.061917, -334.911804, 761.257263, -1047.765747);
    
     AddLandingRegion("CP1Control")
     AddLandingRegion("CP2CONTROL")
     AddLandingRegion("cp4control")

    if (gPlatformStr == "PS2") then
        ScriptCB_DisableFlyerShadows()
    end     

end



    
