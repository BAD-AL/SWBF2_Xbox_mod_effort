--Extracted\tat2c_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

function ScriptPostLoad()
    cp1 = CommandPost:New({ name = "cp1" })
    cp2 = CommandPost:New({ name = "cp2" })
    cp3 = CommandPost:New({ name = "cp3" })
    cp6 = CommandPost:New({ name = "cp6" })
    cp7 = CommandPost:New({ name = "cp7" })
    cp8 = CommandPost:New({ name = "cp8" })
    conquest = ObjectiveConquest:New({ teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true })
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    conquest:AddCommandPost(cp8)
    conquest:Start()
    AddAIGoal(1,"conquest",1000)
    AddAIGoal(2,"conquest",1000)
    AddAIGoal(3,"conquest",1000)
    EnableSPHeroRules()
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(3012241)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(2097152 + 65536 * 10)
end
    ReadDataFile("ingame.lvl")
    REP = 1
    CIS = 2
    DES = 3
    ATT = 1
    DEF = 2
    SetTeamAggressiveness(REP,0.94999998807907)
    SetTeamAggressiveness(CIS,0.94999998807907)
    SetMaxFlyHeight(40)
    ReadDataFile("sound\\tat.lvl;tat2cw")
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rocketeer","rep_inf_ep3_rifleman","rep_inf_ep3_sniper","rep_inf_ep3_engineer","rep_inf_ep3_jettrooper","rep_inf_ep3_officer","rep_hero_obiwan")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_sniper","cis_inf_officer","cis_hero_darthmaul","cis_inf_droideka")
    ReadDataFile("SIDE\\des.lvl","tat_inf_jawa")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_tat_barge","tur_bldg_laser")
    SetAttackingTeam(ATT)
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            rep =             { team = REP, units = 10, reinforcements = 75, 
              soldier =               { "rep_inf_ep3_rifleman", 1, 50 }, 
              assault =               { "rep_inf_ep3_rocketeer", 1, 50 }, 
              engineer =               { "rep_inf_ep3_engineer", 1, 50 }, 
              sniper =               { "rep_inf_ep3_sniper", 1, 50 }, 
              officer =               { "rep_inf_ep3_officer", 1, 50 }, 
              special =               { "rep_inf_ep3_jettrooper", 1, 50 }
             }
           })
        SetupTeams({ 
            cis =             { team = CIS, units = 10, reinforcements = 75, 
              soldier =               { "CIS_inf_rifleman", 1, 50 }, 
              assault =               { "CIS_inf_rocketeer", 1, 50 }, 
              engineer =               { "CIS_inf_engineer", 1, 50 }, 
              sniper =               { "CIS_inf_sniper", 1, 50 }, 
              officer =               { "CIS_inf_officer", 1, 50 }, 
              special =               { "cis_inf_droideka", 1, 50 }
             }
           })
else
        SetupTeams({ 
            rep =             { team = REP, units = 25, reinforcements = 250, 
              soldier =               { "rep_inf_ep3_rifleman", 1, 50 }, 
              assault =               { "rep_inf_ep3_rocketeer", 1, 50 }, 
              engineer =               { "rep_inf_ep3_engineer", 1, 50 }, 
              sniper =               { "rep_inf_ep3_sniper", 1, 50 }, 
              officer =               { "rep_inf_ep3_officer", 1, 50 }, 
              special =               { "rep_inf_ep3_jettrooper", 1, 50 }
             }
           })
        SetupTeams({ 
            cis =             { team = CIS, units = 25, reinforcements = 250, 
              soldier =               { "CIS_inf_rifleman", 1, 50 }, 
              assault =               { "CIS_inf_rocketeer", 1, 50 }, 
              engineer =               { "CIS_inf_engineer", 1, 50 }, 
              sniper =               { "CIS_inf_sniper", 1, 50 }, 
              officer =               { "CIS_inf_officer", 1, 50 }, 
              special =               { "cis_inf_droideka", 1, 50 }
             }
           })
end
    SetTeamName(3,"locals")
    AddUnitClass(3,"tat_inf_jawa",7)
    SetUnitCount(3,7)
    SetTeamAsFriend(3,ATT)
    SetTeamAsFriend(3,DEF)
    SetTeamAsFriend(ATT,3)
    SetTeamAsFriend(DEF,3)
    SetHeroClass(CIS,"cis_hero_darthmaul")
    SetHeroClass(REP,"rep_hero_obiwan")
    ClearWalkers()
    AddWalkerType(0,3)
    AddWalkerType(1,0)
    AddWalkerType(2,0)
    AddWalkerType(3,0)
    SetMemoryPoolSize("Aimer",23)
    SetMemoryPoolSize("AmmoCounter",230)
    SetMemoryPoolSize("BaseHint",325)
    SetMemoryPoolSize("EnergyBar",230)
    SetMemoryPoolSize("EntityCloth",19)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntityHover",1)
    SetMemoryPoolSize("EntitySoundStream",2)
    SetMemoryPoolSize("EntitySoundStatic",43)
    SetMemoryPoolSize("MountedTurret",15)
    SetMemoryPoolSize("Navigator",50)
    SetMemoryPoolSize("Obstacle",667)
    SetMemoryPoolSize("PathFollower",50)
    SetMemoryPoolSize("PathNode",256)
    SetMemoryPoolSize("TreeGridStack",325)
    SetMemoryPoolSize("UnitAgent",50)
    SetMemoryPoolSize("UnitController",50)
    SetMemoryPoolSize("Weapon",230)
    SetSpawnDelay(10,0.25)
    ReadDataFile("TAT\\tat2.lvl","tat2_con")
    SetDenseEnvironment("false")
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetAmbientMusic(REP,1,"rep_tat_amb_start",0,1)
    SetAmbientMusic(REP,0.80000001192093,"rep_tat_amb_middle",1,1)
    SetAmbientMusic(REP,0.20000000298023,"rep_tat_amb_end",2,1)
    SetAmbientMusic(CIS,1,"cis_tat_amb_start",0,1)
    SetAmbientMusic(CIS,0.80000001192093,"cis_tat_amb_middle",1,1)
    SetAmbientMusic(CIS,0.20000000298023,"cis_tat_amb_end",2,1)
    SetVictoryMusic(REP,"rep_tat_amb_victory")
    SetDefeatMusic(REP,"rep_tat_amb_defeat")
    SetVictoryMusic(CIS,"cis_tat_amb_victory")
    SetDefeatMusic(CIS,"cis_tat_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(0.97433799505234,-0.22217999398708,0.035172000527382,0.0080199996009469,-82.664649963379,23.668300628662,43.955680847168)
    AddCameraShot(0.39019700884819,-0.089729003608227,-0.89304000139236,-0.2053620070219,23.563562393188,12.914884567261,-101.46556091309)
    AddCameraShot(0.16975900530815,0.0022249999456108,-0.98539799451828,0.012915999628603,126.97280883789,4.0396280288696,-22.020612716675)
    AddCameraShot(0.67745298147202,-0.041535001248121,0.73301601409912,0.044941999018192,97.517807006836,4.0396280288696,36.853477478027)
    AddCameraShot(0.86602902412415,-0.15650600194931,0.46729901432991,0.084449000656605,7.6856398582458,7.1306881904602,-10.895234107971)
end

