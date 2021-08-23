--Extracted\spa7c_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("spa7c_cmn")
myGameMode = "spa7_1flag"

function SetupUnits()
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_pilot","rep_fly_assault_dome","rep_fly_anakinstarfighter_sc","rep_fly_arc170fighter_sc","rep_veh_remote_terminal","rep_fly_vwing")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_pilot","cis_fly_fedlander_dome","cis_fly_droidfighter_sc","cis_fly_greviousfighter","cis_fly_tridroidfighter")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_spa_cis_beam","tur_bldg_spa_cis_chaingun","tur_bldg_spa_rep_beam","tur_bldg_spa_rep_chaingun","tur_bldg_chaingun_roof")
end
myTeamConfig = { 
  rep =   { team = REP, units = 16, reinforcements = -1, 
    pilot =     { "rep_inf_ep3_pilot", 16 }
   }, 
  cis =   { team = CIS, units = 16, reinforcements = -1, 
    pilot =     { "cis_inf_pilot", 16 }
   }
 }

function myScriptInit()
    SetMemoryPoolSize("FlagItem",1)
    SetMemoryPoolSize("CommandFlyer",0)
end

function ScriptPostLoad()
    SetClassProperty("com_item_flag","DroppedColorize",1)
    LockHangarWarsDoors(true)
    SetupFrigateDeaths()
    SetupTurrets()
    ctf = ObjectiveOneFlagCTF:New({ teamATT = REP, teamDEF = CIS, textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", flag = "cmn_flag", homeRegion = "1flag_home", captureRegionATT = "1flag_rep_cap", captureRegionDEF = "1flag_cis_cap", capRegionDummyObjectATT = "1flag_rep_marker", capRegionDummyObjectDEF = "1flag_cis_marker", multiplayerRules = true, hideCPs = true, AIGoalWeight = 0 })
    SoundEvent_SetupTeams(REP,"rep",CIS,"cis")
    ctf:Start()
    AddAIGoal(REP,"Deathmatch",100)
    AddAIGoal(CIS,"Deathmatch",100)
end

