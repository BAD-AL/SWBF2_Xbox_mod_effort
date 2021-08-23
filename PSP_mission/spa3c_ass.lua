--Extracted\spa3c_ass.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveSpaceAssault")
ScriptCB_DoFile("LinkedShields")
ScriptCB_DoFile("LinkedDestroyables")
REP = 1
CIS = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    SetupObjectives()
    DisableSmallMapMiniMap()
    SetupShields()
    SetupDestroyables()
    AddAIGoal(REP,"Deathmatch",100)
    AddAIGoal(CIS,"Deathmatch",100)
    PauseAnimation("cis01")
    SetProperty("repdoor01","IsLocked",1)
    SetProperty("repdoor02","IsLocked",1)
    SetProperty("cisdoor01","IsLocked",1)
    SetProperty("cisdoor02","IsLocked",1)
end

function SetupObjectives()
    assault = ObjectiveSpaceAssault:New({ teamATT = REP, teamDEF = CIS, multiplayerRules = true })
    assault:SetupAllCriticalSystems("rep",{ 
        engines =         { "Engine1", "Engine2" }, lifesupport = "life_ext_cis", bridge = "bridge_cis", comm = "comms_cis", sensors = "sensors_cis", frigates = "CIS_mini01", 
        internalSys =         { "life_int_cis", "engine_cis" }
       },true)
    assault:SetupAllCriticalSystems("cis",{ engines = "Engine3", lifesupport = "life_ext_rep", bridge = "bridge_rep", comm = "comms_rep", sensors = "sensors_rep", frigates = "REP_mini03", 
        internalSys =         { "life_int_rep", "engine_rep" }
       },false)
    assault:Start()
    DisableBarriers("cis_blk01")
    DisableBarriers("cis_blk02")
    DisableBarriers("rep_blk01")
    DisableBarriers("rep_blk02")
end

function SetupShields()
    linkedShieldObjectsCIS = { "Engine1", "Engine2", "life_ext_cis", "sensors_cis", "comms_cis", "bridge_cis", "cis_fly_fedcruiser0", "cis_fly_fedcruiser2", "cis_fly_fedcruiser3", "cis_fly_fedcruiser4" }
    shieldStuffCIS = LinkedShields:New({ objs = linkedShieldObjectsCIS, maxShield = 40000, addShield = 200, controllerObject = "shieldgenCIS" })
    shieldStuffCIS:Init()
    linkedShieldObjectsREP = { "sensors_rep", "life_ext_rep", "comms_rep", "rep_cap_assultship0", "rep_cap_assultship2", "rep_cap_assultship3", "rep_cap_assultship4", "bridge_rep", "Engine3" }
    shieldStuffREP = LinkedShields:New({ objs = linkedShieldObjectsREP, maxShield = 40000, addShield = 200, controllerObject = "shieldgenREP" })
    shieldStuffREP:Init()
end

function SetupDestroyables()
    lifeSupportLinkageCIS = LinkedDestroyables:New({ 
        objectSets =         {           { "life_int_cis" },           { "life_ext_cis" } }
       })
    lifeSupportLinkageCIS:Init()
    engineLinkageCIS = LinkedDestroyables:New({ 
        objectSets =         {           { "Engine1", "Engine2" },           { "engine_cis" } }
       })
    engineLinkageCIS:Init()
    lifeSupportLinkageREP = LinkedDestroyables:New({ 
        objectSets =         {           { "life_int_rep" },           { "life_ext_rep" } }
       })
    lifeSupportLinkageREP:Init()
    engineLinkageREP = LinkedDestroyables:New({ 
        objectSets =         {           { "Engine3" },           { "engine_rep" } }
       })
    engineLinkageREP:Init()
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(4016177)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(5049000)
end
    ReadDataFile("ingame.lvl")
    SetMinFlyHeight(-1900)
    SetMaxFlyHeight(2000)
    SetMinPlayerFlyHeight(-1900)
    SetMaxPlayerFlyHeight(2000)
    SetAIVehicleNotifyRadius(100)
    ReadDataFile("sound\\spa.lvl;spa2cw")
    ScriptCB_SetDopplerFactor(0.40000000596046)
    ScaleSoundParameter("tur_weapons","MinDistance",3)
    ScaleSoundParameter("tur_weapons","MaxDistance",3)
    ScaleSoundParameter("tur_weapons","MuteDistance",3)
    ScaleSoundParameter("Ordnance_Large","MinDistance",3)
    ScaleSoundParameter("Ordnance_Large","MaxDistance",3)
    ScaleSoundParameter("Ordnance_Large","MuteDistance",3)
    ScaleSoundParameter("explosion","MaxDistance",5)
    ScaleSoundParameter("explosion","MuteDistance",5)
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_pilot","rep_inf_ep3_marine","rep_fly_assault_dome","rep_fly_anakinstarfighter_sc","rep_fly_arc170fighter_sc","rep_fly_gunship_sc","rep_fly_arc170fighter_dome","rep_fly_vwing")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_pilot","cis_inf_marine","cis_fly_fedlander_dome","cis_fly_droidfighter_sc","cis_fly_droidfighter_dome","cis_fly_greviousfighter","cis_fly_droidgunship","cis_fly_tridroidfighter")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            rep =             { team = REP, units = 10, reinforcements = -1, 
              pilot =               { "rep_inf_ep3_pilot", 2 }, 
              marine =               { "rep_inf_ep3_marine", 8 }
             }, 
            cis =             { team = CIS, units = 10, reinforcements = -1, 
              pilot =               { "cis_inf_pilot", 2 }, 
              marine =               { "cis_inf_marine", 8 }
             }
           })
else
        SetupTeams({ 
            rep =             { team = REP, units = 16, reinforcements = -1, 
              pilot =               { "rep_inf_ep3_pilot", 10 }, 
              marine =               { "rep_inf_ep3_marine", 6 }
             }, 
            cis =             { team = CIS, units = 16, reinforcements = -1, 
              pilot =               { "cis_inf_pilot", 10 }, 
              marine =               { "cis_inf_marine", 6 }
             }
           })
end
    ClearWalkers()
    SetMemoryPoolSize("Aimer",186)
    SetMemoryPoolSize("AmmoCounter",240)
    SetMemoryPoolSize("BaseHint",35)
    SetMemoryPoolSize("CommandFlyer",2)
    SetMemoryPoolSize("EnergyBar",240)
    SetMemoryPoolSize("EntityDroid",0)
    SetMemoryPoolSize("EntityFlyer",32)
    SetMemoryPoolSize("EntityLight",120)
    SetMemoryPoolSize("EntitySoundStream",11)
    SetMemoryPoolSize("EntitySoundStatic",4)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix",165)
    SetMemoryPoolSize("MountedTurret",48)
    SetMemoryPoolSize("Navigator",32)
    SetMemoryPoolSize("Obstacle",120)
    SetMemoryPoolSize("PathFollower",32)
    SetMemoryPoolSize("PathNode",48)
    SetMemoryPoolSize("TreeGridStack",200)
    SetMemoryPoolSize("UnitAgent",64)
    SetMemoryPoolSize("UnitController",64)
    SetMemoryPoolSize("Weapon",240)
    true = ERROR_PROCESSING_FUNCTION
end

function OnAllShieldsDown(OnAllShieldsDownParam0)
    ShowMessageText("level.spa.hangar.shields.atk.down",REP)
    ShowMessageText("level.spa.hangar.shields.def.down",CIS)
    BroadcastVoiceOver("ROSMP_obj_16",REP)
    BroadcastVoiceOver("COSMP_obj_17",CIS)
    EnableLockOn({ "Engine1", "Engine2", "life_ext_cis", "bridge_cis", "comms_cis", "sensors_cis" },true)
end

function OnAllShieldsUp(OnAllShieldsUpParam0)
    EnableLockOn({ "Engine1", "Engine2", "life_ext_cis", "bridge_cis", "comms_cis", "sensors_cis" },false)
    ShowMessageText("level.spa.hangar.shields.atk.up",REP)
    ShowMessageText("level.spa.hangar.shields.def.up",CIS)
    BroadcastVoiceOver("ROSMP_obj_18",REP)
    BroadcastVoiceOver("COSMP_obj_19",CIS)
end

function OnAllShieldsDown(OnAllShieldsDownParam0)
    ShowMessageText("level.spa.hangar.shields.atk.down",CIS)
    ShowMessageText("level.spa.hangar.shields.def.down",REP)
    BroadcastVoiceOver("ROSMP_obj_17",REP)
    BroadcastVoiceOver("COSMP_obj_16",CIS)
    EnableLockOn({ "sensors_rep", "life_ext_rep", "comms_rep", "bridge_rep", "Engine3" },true)
end

function OnAllShieldsUp(OnAllShieldsUpParam0)
    EnableLockOn({ "sensors_rep", "life_ext_rep", "comms_rep", "bridge_rep", "Engine3" },false)
    ShowMessageText("level.spa.hangar.shields.atk.up",CIS)
    ShowMessageText("level.spa.hangar.shields.def.up",REP)
    BroadcastVoiceOver("ROSMP_obj_19",REP)
    BroadcastVoiceOver("COSMP_obj_18",CIS)
end

