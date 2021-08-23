--Extracted\spa9g_cmn.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
IMP = 1
ALL = 2
ATT = 1
DEF = 2

function SetupUnits()
    ReadDataFile("SIDE\\all.lvl","all_inf_pilot","all_inf_marine","all_fly_xwing_sc","all_fly_ywing_sc","all_fly_awing","all_fly_gunship_sc","all_veh_remote_terminal")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_pilot","imp_inf_marine","imp_fly_tiefighter_sc","imp_fly_tiebomber_sc","imp_fly_tieinterceptor","imp_fly_trooptrans","imp_veh_remote_terminal")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_spa_all_beam","tur_bldg_spa_all_recoilless","tur_bldg_spa_all_chaingun","tur_bldg_spa_imp_beam","tur_bldg_spa_imp_recoilless","tur_bldg_spa_imp_chaingun","tur_bldg_chaingun_roof")
end
myTeamConfig = { 
  all =   { team = ALL, units = 16, reinforcements = -1, 
    pilot =     { "all_inf_pilot", 10 }, 
    marine =     { "all_inf_marine", 6 }
   }, 
  imp =   { team = IMP, units = 16, reinforcements = -1, 
    pilot =     { "imp_inf_pilot", 10 }, 
    marine =     { "imp_inf_marine", 6 }
   }
 }


-- LockHangarWarsDoors
-- ARGS: bLock - true to lock the doors, false to unlock
-- assumes this will only be run once on start
-- if you wish to toggle, make sure to handle all 3 lists!
function LockHangarWarsDoors( bLock )
    local barrierList = {
        "all_cap1_bar1",
        "all_cap1_bar2",
        "all_cap1_bar3",
        "imp_cap1_bar1",
        "imp_cap1_bar2",
        "imp_cap1_bar3",
    }
    
    local connectionList = {
        "connection43",  -- all connections are in one group, so only need to disable one
    }
    
    local doorList = {
        "all1_door3",
        "all1_door4",
        "all1_door5",
        "imp1_door3",
        "imp1_door4",
        "imp1_door5",
    }
    
    if bLock then
        for i, door in pairs(doorList) do
            SetProperty(door, "isLocked", 1)
        end
        
        for j, connection in pairs(connectionList) do
            BlockPlanningGraphArcs(connection);
        end
    else
        for k, bar in pairs(barrierList) do
            DisableBarriers(bar);
        end 
    end
    
    LockHangarWarsDoors = nil
end
function SetupFrigateDeaths()
    OnObjectKillName(,"imp_frig1")
    OnObjectKillName(,"imp_frig2")
    OnObjectKillName(,"imp_frig3")
    OnObjectKillName(,"all_frig1")
    OnObjectKillName(,"all_frig2")
end
ScriptCB_DoFile("LinkedTurrets")

function SetupTurrets()
    turretLinkageALL = LinkedTurrets:New({ team = ALL, mainframe = "all_cap1_autodefense", 
        turrets =         { "all_cap1_autotur1", "all_cap1_autotur2", "all_cap1_autotur3", "all_cap1_autotur4", "all_cap1_autotur5", "all_cap1_autotur6" }
       })
    turretLinkageALL:Init()
    turretLinkageIMP = LinkedTurrets:New({ team = IMP, mainframe = "imp_cap1_autodefense", 
        turrets =         { "imp_cap1_autotur1", "imp_cap1_autotur2", "imp_cap1_autotur3", "imp_cap1_autotur4", "imp_cap1_autotur5", "imp_cap1_autotur6" }
       })
    turretLinkageIMP:Init()
end

function ScriptPreInit()
    SetWorldExtents(2520)
    ScriptPreInit = nil
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(5.4000000953674 * 1024 * 1024)
else
        SetPS2ModelMemory(4735000)
end
    ReadDataFile("ingame.lvl")
    SetMinFlyHeight(-480)
    SetMaxFlyHeight(1700)
    SetMinPlayerFlyHeight(-480)
    SetMaxPlayerFlyHeight(1700)
    SetAIVehicleNotifyRadius(100)
    ReadDataFile("sound\\spa.lvl;spa1gcw")
    ScriptCB_SetDopplerFactor(0.40000000596046)
    ScaleSoundParameter("explosion","MaxDistance",15)
    ScaleSoundParameter("explosion","MuteDistance",15)
    SetupUnits()
    SetupTeams(myTeamConfig)
    ClearWalkers()
    SetMemoryPoolSize("Aimer",225)
    SetMemoryPoolSize("AmmoCounter",225)
    SetMemoryPoolSize("BaseHint",50)
    SetMemoryPoolSize("Combo::DamageSample",128)
    SetMemoryPoolSize("CommandFlyer",2)
    SetMemoryPoolSize("EnergyBar",225)
    SetMemoryPoolSize("EntityCloth",0)
    SetMemoryPoolSize("EntityDroid",0)
    SetMemoryPoolSize("EntityDefenseGridTurret",0)
    SetMemoryPoolSize("EntityFlyer",32 + 8)
    SetMemoryPoolSize("EntityLight",115)
    SetMemoryPoolSize("EntityRemoteTerminal",12)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix",120)
    SetMemoryPoolSize("MountedTurret",64)
    SetMemoryPoolSize("Navigator",32)
    SetMemoryPoolSize("Obstacle",135)
    SetMemoryPoolSize("Ordnance",90)
    SetMemoryPoolSize("PathNode",80)
    SetMemoryPoolSize("PathFollower",32)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("TreeGridStack",210)
    SetMemoryPoolSize("UnitAgent",32 * 2)
    SetMemoryPoolSize("UnitController",32 * 2)
    SetMemoryPoolSize("Weapon",225)
    SetMemoryPoolSize("Asteroid",2 * 32)
    SetSpawnDelay(10,0.25)
if myScriptInit == true then
        myScriptInit()
end
    myScriptInit = nil
    true = ERROR_PROCESSING_FUNCTION
end

function OnObjectKillName(OnObjectKillNameParam0)
    GetEntityName(OnObjectKillNameParam0)
    true = ERROR_PROCESSING_FUNCTION
end

function OnDisableMainframe(OnDisableMainframeParam0)
    ShowMessageText("level.spa.hangar.mainframe.atk.down",IMP)
    ShowMessageText("level.spa.hangar.mainframe.def.down",ALL)
    BroadcastVoiceOver("IOSMP_obj_20",IMP)
    BroadcastVoiceOver("AOSMP_obj_21",ALL)
end

function OnEnableMainframe(OnEnableMainframeParam0)
    ShowMessageText("level.spa.hangar.mainframe.atk.up",IMP)
    ShowMessageText("level.spa.hangar.mainframe.def.up",ALL)
    BroadcastVoiceOver("IOSMP_obj_22",IMP)
    BroadcastVoiceOver("AOSMP_obj_23",ALL)
end

function OnDisableMainframe(OnDisableMainframeParam0)
    ShowMessageText("level.spa.hangar.mainframe.atk.down",ALL)
    ShowMessageText("level.spa.hangar.mainframe.def.down",IMP)
    BroadcastVoiceOver("IOSMP_obj_21",IMP)
    BroadcastVoiceOver("AOSMP_obj_20",ALL)
end

function OnEnableMainframe(OnEnableMainframeParam0)
    ShowMessageText("level.spa.hangar.mainframe.atk.up",ALL)
    ShowMessageText("level.spa.hangar.mainframe.def.up",IMP)
    BroadcastVoiceOver("IOSMP_obj_23",IMP)
    BroadcastVoiceOver("AOSMP_obj_22",ALL)
end

