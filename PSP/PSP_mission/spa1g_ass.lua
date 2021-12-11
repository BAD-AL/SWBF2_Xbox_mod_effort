--Extracted\spa1g_ass.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveSpaceAssault")
ScriptCB_DoFile("LinkedShields")
ScriptCB_DoFile("LinkedDestroyables")
IMP = 1
ALL = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    SetupObjectives()
    DisableBarriers("allblock")
    DisableBarriers("impblock")
    SetupShields()
    SetupDestroyables()
    AddAIGoal(ALL,"Deathmatch",100)
    AddAIGoal(IMP,"Deathmatch",100)
    SetProperty("ALL_Door01","IsLocked",1)
    SetProperty("ALL_Door02","IsLocked",1)
    SetProperty("spa1_prop_impDoor2","IsLocked",1)
    SetProperty("spa1_prop_impDoor3","IsLocked",1)
end

function SetupLinkedObjects()
    SetupShields()
    SetupDestroyables()
end

function SetupObjectives()
    assault = ObjectiveSpaceAssault:New({ teamATT = IMP, teamDEF = ALL, multiplayerRules = true })
    assault:SetupAllCriticalSystems("imp",{ 
        engines =         { "Engine_a01", "Engine_a02", "Engine_a03", "Engine_a04", "Engine_a05", "Engine_a06" }, lifesupport = "life_ext_all", bridge = "bridge_all", comm = "comms_all", sensors = "sensors_all", frigates = "cor01", 
        internalSys =         { "life_int_all", "engines_all" }
       },true)
    assault:SetupAllCriticalSystems("all",{ 
        engines =         { "engine_l", "engine_c", "engine_r" }, lifesupport = "life_ext_imp", bridge = "bridge_imp", comm = "comms_imp", sensors = "sensors_imp", frigates = "imp_mini01", 
        internalSys =         { "life_int_imp", "engines_imp" }
       },false)
    assault:Start()
end

function SetupShields()
    linkedShieldObjectsALL = { "rebelcruiser", "all_cap_rebelcruiser3", "Engine_a01", "Engine_a02", "Engine_a03", "Engine_a04", "Engine_a05", "Engine_a06", "sensors_all", "sensors_spin", "comms_all", "bridge_all", "life_ext_all" }
    shieldStuffALL = LinkedShields:New({ objs = linkedShieldObjectsALL, maxShield = 100000, addShield = 190, controllerObject = "shieldgenALL" })
    shieldStuffALL:Init()
    linkedShieldObjectsIMP = { "imp_cap_stardestroyer10", "imp_cap_stardestroyer2", "imp_cap_stardestroyer3", "imp_cap_stardestroyer4", "engine_l", "engine_c", "engine_r", "bridge_imp", "comms_imp", "sensors_spin0", "sensors_imp", "life_ext_imp", "shield_r", "shield_l", "imp_cap_stardestroyer_shield1" }
    shieldStuffIMP = LinkedShields:New({ objs = linkedShieldObjectsIMP, maxShield = 100000, addShield = 190, controllerObject = "shieldgenIMP" })
    shieldStuffIMP:Init()
end

function SetupDestroyables()
    lifeSupportLinkageALL = LinkedDestroyables:New({ 
        objectSets =         {           { "life_int_all" },           { "life_ext_all" } }
       })
    lifeSupportLinkageALL:Init()
    engineLinkageALL = LinkedDestroyables:New({ 
        objectSets =         {           { "Engine_a01", "Engine_a02", "Engine_a03", "Engine_a04", "Engine_a05", "Engine_a06" },           { "engines_all" } }
       })
    engineLinkageALL:Init()
    lifeSupportLinkageIMP = LinkedDestroyables:New({ 
        objectSets =         {           { "life_int_imp" },           { "life_ext_imp" } }
       })
    lifeSupportLinkageIMP:Init()
    engineLinkageIMP = LinkedDestroyables:New({ 
        objectSets =         {           { "engine_l", "engine_c", "engine_r" },           { "engines_imp" } }
       })
    engineLinkageIMP:Init()
end

function FriglistA()
    PauseAnimation("gate01")
    PlayAnimation("friglist01")
end

function FriglistB()
    PauseAnimation("Impmove")
    PlayAnimation("implist")
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(3454769)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(4850000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\spa.lvl;spa1gcw")
    ScriptCB_SetDopplerFactor(0.40000000596046)
    ScaleSoundParameter("explosion","MaxDistance",15)
    ScaleSoundParameter("explosion","MuteDistance",15)
    SetMinFlyHeight(-490)
    SetMaxFlyHeight(1400)
    SetMinPlayerFlyHeight(-490)
    SetMaxPlayerFlyHeight(1400)
    SetAIVehicleNotifyRadius(100)
    ReadDataFile("SIDE\\all.lvl","all_inf_pilot","all_inf_marine","all_fly_xwing_sc","all_fly_ywing_sc","all_fly_awing","all_fly_gunship_sc")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_pilot","imp_inf_marine","imp_fly_tiefighter_sc","imp_fly_tiebomber_sc","imp_fly_tieinterceptor","imp_fly_trooptrans")
    ClearWalkers()
    SetMemoryPoolSize("Aimer",173)
    SetMemoryPoolSize("BaseHint",25)
    SetMemoryPoolSize("Combo::DamageSample",64)
    SetMemoryPoolSize("CommandFlyer",2)
    SetMemoryPoolSize("EntityFlyer",32)
    SetMemoryPoolSize("EntityDroid",0)
    SetMemoryPoolSize("EntityLight",90)
    SetMemoryPoolSize("EntitySoundStream",10)
    SetMemoryPoolSize("EntitySoundStatic",3)
    SetMemoryPoolSize("MountedTurret",53)
    SetMemoryPoolSize("Navigator",32)
    SetMemoryPoolSize("Obstacle",78)
    SetMemoryPoolSize("PassengerSlot",0)
    SetMemoryPoolSize("PathFollower",32)
    SetMemoryPoolSize("PathNode",72)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("TreeGridStack",150)
    SetMemoryPoolSize("UnitAgent",74)
    SetMemoryPoolSize("UnitController",74)
    SetMemoryPoolSize("Weapon",225)
    if ScriptCB_GetPlatform() == "PSP" then
            SetupTeams({ 
                all =             { team = ALL, units = 10, reinforcements = -1, 
                pilot =               { "all_inf_pilot", 5 }, 
                marine =               { "all_inf_marine", 5 }
                }, 
                imp =             { team = IMP, units = 10, reinforcements = -1, 
                pilot =               { "imp_inf_pilot", 5 }, 
                marine =               { "imp_inf_marine", 5 }
                }
            })
    else
            SetupTeams({ 
                all =             { team = ALL, units = 16, reinforcements = -1, 
                pilot =               { "all_inf_pilot", 8 }, 
                marine =               { "all_inf_marine", 8 }
                }, 
                imp =             { team = IMP, units = 16, reinforcements = -1, 
                pilot =               { "imp_inf_pilot", 8 }, 
                marine =               { "imp_inf_marine", 8 }
                }
            })
    end
    SetSpawnDelay(10,0.25)
    true = ERROR_PROCESSING_FUNCTION
end

function OnAllShieldsDown(OnAllShieldsDownParam0)
    ShowMessageText("level.spa.hangar.shields.atk.down",IMP)
    ShowMessageText("level.spa.hangar.shields.def.down",ALL)
    EnableLockOn({ "Engine_a01", "Engine_a02", "Engine_a03", "Engine_a04", "Engine_a05", "Engine_a06", "sensors_all", "sensors_spin", "comms_all", "bridge_all", "life_ext_all" },true)
end

function OnAllShieldsUp(OnAllShieldsUpParam0)
    EnableLockOn({ "Engine_a01", "Engine_a02", "Engine_a03", "Engine_a04", "Engine_a05", "Engine_a06", "sensors_all", "sensors_spin", "comms_all", "bridge_all", "life_ext_all" },false)
end

function OnAllShieldsDown(OnAllShieldsDownParam0)
    ShowMessageText("level.spa.hangar.shields.atk.down",ALL)
    ShowMessageText("level.spa.hangar.shields.def.down",IMP)
    EnableLockOn({ "engine_l", "engine_c", "engine_r", "bridge_imp", "comms_imp", "sensors_spin0", "sensors_imp", "life_ext_imp" },true)
end

function OnAllShieldsUp(OnAllShieldsUpParam0)
    EnableLockOn({ "engine_l", "engine_c", "engine_r", "bridge_imp", "comms_imp", "sensors_spin0", "sensors_imp", "life_ext_imp" },false)
end

