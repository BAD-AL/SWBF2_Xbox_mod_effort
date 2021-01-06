--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams") 

--  Empire Attacking (attacker is always #1)
ALL = 1
IMP = 2
--  These variables do not change
ATT = 1
DEF = 2
 
    
function ScriptPostLoad()
		EnableSPHeroRules()
		
	    AddDeathRegion("Death")
	    AddDeathRegion("Death1")
	    AddDeathRegion("Death2")
	    AddDeathRegion("Death3")
	    AddDeathRegion("Death4")
		
		
    	SetProperty ("LibCase1","MaxHealth",1000)
    	SetProperty ("LibCase2","MaxHealth",1000)
    	SetProperty ("LibCase3","MaxHealth",1000)
    	SetProperty ("LibCase4","MaxHealth",1000)
    	SetProperty ("LibCase5","MaxHealth",1000)
    	SetProperty ("LibCase6","MaxHealth",1000)
    	SetProperty ("LibCase7","MaxHealth",1000)
    	SetProperty ("LibCase8","MaxHealth",1000)
    	SetProperty ("LibCase9","MaxHealth",1000)
    	SetProperty ("LibCase10","MaxHealth",1000)
    	SetProperty ("LibCase11","MaxHealth",1000)
    	SetProperty ("LibCase12","MaxHealth",1000)
    	SetProperty ("LibCase13","MaxHealth",1000)
    	SetProperty ("LibCase14","MaxHealth",1000)



    	SetProperty ("LibCase1","CurHealth",1000)
    	SetProperty ("LibCase2","CurHealth",1000)
    	SetProperty ("LibCase3","CurHealth",1000)
    	SetProperty ("LibCase4","CurHealth",1000)
    	SetProperty ("LibCase5","CurHealth",1000)
    	SetProperty ("LibCase6","CurHealth",1000)
    	SetProperty ("LibCase7","CurHealth",1000)
    	SetProperty ("LibCase8","CurHealth",1000)
    	SetProperty ("LibCase9","CurHealth",1000)
    	SetProperty ("LibCase10","CurHealth",1000)
    	SetProperty ("LibCase11","CurHealth",1000)
    	SetProperty ("LibCase12","CurHealth",1000)
    	SetProperty ("LibCase13","CurHealth",1000)
    	SetProperty ("LibCase14","CurHealth",1000)


    EnableSPHeroRules()
            DisableBarriers("SideDoor1")
            DisableBarriers("MainLibraryDoors")
            DisableBarriers("SideDoor2")
            DisableBarriers("SIdeDoor3")
            DisableBarriers("ComputerRoomDoor1")
            DisableBarriers("StarChamberDoor1")
            DisableBarriers("StarChamberDoor2")
            DisableBarriers("WarRoomDoor1")
            DisableBarriers("WarRoomDoor2")
            DisableBarriers("WarRoomDoor3") 
            PlayAnimation("DoorOpen01")
            PlayAnimation("DoorOpen02")
            
                --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "CP1"}
    cp2 = CommandPost:New{name = "CP2"}
    cp3 = CommandPost:New{name = "CP3"}
    cp4 = CommandPost:New{name = "CP4"}
    cp5 = CommandPost:New{name = "CP5"}
    cp6 = CommandPost:New{name = "CP6"}
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", 
                                     textDEF = "game.modes.con2",
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    
    conquest:Start()
 end
 
function ScriptInit()
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(4030000)
    ReadDataFile("ingame.lvl")
    
   
    
    ReadDataFile("sound\\cor.lvl;cor1gcw")
    SetMapNorthAngle(180, 1)
    SetMaxFlyHeight(25)
    SetMaxPlayerFlyHeight (25)
    AISnipeSuitabilityDist(30)
    
     ReadDataFile("SIDE\\all.lvl",
                    "all_bldg_defensegridturret",
                    "all_inf_rifleman",
                    "all_inf_rocketeer",
                    "all_inf_engineer",
                    "all_inf_sniper",
                    "all_inf_officer",
                    "all_inf_wookiee",
                    "all_hero_luke_jedi")
                
                                
                
     ReadDataFile("SIDE\\imp.lvl",
                    --Insert "imp_bldg_defensegridturret", once the odf has been set up
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_officer",
                    "imp_inf_dark_trooper",                   
                    "imp_hero_emperor")
             
     ReadDataFile("SIDE\\rep.lvl",
           			"rep_fly_assault_DOME",
					"rep_fly_gunship_DOME")
					
    ReadDataFile("SIDE\\tur.lvl", 
    			"tur_bldg_laser")          
     
     
	ReadDataFile("SIDE\\cis.lvl",
					"cis_fly_droidfighter_DOME")




   -- set up teams
    SetupTeams{
        imp = {
            team = IMP,
            units = 32,
            reinforcements = 150,
            turret = "all_bldg_defensegridturret",      --change this to imp_bldg_defensegridturret once the odf has been set up
            soldier  = { "imp_inf_rifleman",7, 25},
            assault  = { "imp_inf_rocketeer",1, 4},
            engineer = { "imp_inf_engineer",1, 4},
            sniper   = { "imp_inf_sniper",1, 4},
            officer = {"imp_inf_officer",1, 4},
            special = { "imp_inf_dark_trooper",1, 4},
            
        },
        all = {
            team = ALL,
            units = 32,
            reinforcements = 150,
            turret = "all_bldg_defensegridturret",
            soldier  = { "all_inf_rifleman",7, 25},
            assault  = { "all_inf_rocketeer",1, 4},
            engineer = { "all_inf_engineer",1, 4},
            sniper   = { "all_inf_sniper",1, 4},
            officer = {"all_inf_officer",1, 4},
            special = { "all_inf_wookiee",1, 4},
        }
    }
    SetHeroClass(ALL, "all_hero_luke_jedi")    
    SetHeroClass(IMP, "imp_hero_emperor")
    

    -- SetTeamAsEnemy(DEF, 3)

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
    AddWalkerType(1, 0) -- 
    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local guyCnt = 50
    local weaponCnt = 200
    SetMemoryPoolSize("Aimer", 20)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 21)
    SetMemoryPoolSize("EntityLight", 96)
    SetMemoryPoolSize("MountedTurret", 13)
    SetMemoryPoolSize("PathFollower", guyCnt)
    SetMemoryPoolSize("Navigator", guyCnt)
    SetMemoryPoolSize("SoundSpaceRegion", 38)
    SetMemoryPoolSize("TreeGridStack", 256)
    SetMemoryPoolSize("UnitAgent", guyCnt)
    SetMemoryPoolSize("UnitController", guyCnt)
    SetMemoryPoolSize("Weapon", weaponCnt)
	SetMemoryPoolSize("EntityFlyer", 4)   

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("cor\\cor1.lvl","cor1_Conquest")
    SetDenseEnvironment("True")
      -- SetMaxFlyHeight(25)
     --SetMaxPlayerFlyHeight (25)
 AddDeathRegion("DeathRegion1")



    --  Movies
    --  SetVictoryMovie(ALL, "all_end_victory")
    --  SetDefeatMovie(ALL, "imp_end_victory")
    --  SetVictoryMovie(IMP, "imp_end_victory")
    --  SetDefeatMovie(IMP, "all_end_victory")

    --  Sound
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)
    
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\cor.lvl",  "cor1")
    OpenAudioStream("sound\\cor.lvl",  "cor1")
    -- OpenAudioStream("sound\\cor.lvl",  "cor1_emt")

    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(1, "allleaving")
    SetOutOfBoundsVoiceOver(2, "impleaving")

    SetAmbientMusic(ALL, 1.0, "all_cor_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.8, "all_cor_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2, "all_cor_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_cor_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.8, "imp_cor_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2, "imp_cor_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_cor_amb_victory")
    SetDefeatMusic (ALL, "all_cor_amb_defeat")
    SetVictoryMusic(IMP, "imp_cor_amb_victory")
    SetDefeatMusic (IMP, "imp_cor_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --  SetSoundEffect("BirdScatter",         "birdsFlySeq1")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


    SetAttackingTeam(ATT)



	AddCameraShot(0.419938, 0.002235, -0.907537, 0.004830, -15.639358, 5.499980, -176.911179);
	AddCameraShot(0.994506, 0.104463, -0.006739, 0.000708, 1.745251, 5.499980, -118.700668);
	AddCameraShot(0.008929, -0.001103, -0.992423, -0.122538, 1.366768, 16.818106, -114.422173);
	AddCameraShot(0.761751, -0.117873, -0.629565, -0.097419, 59.861904, 16.818106, -81.607773);
	AddCameraShot(0.717110, -0.013583, 0.696703, 0.013197, 98.053314, 11.354497, -85.857857);
	AddCameraShot(0.360958, -0.001053, -0.932577, -0.002721, 69.017578, 18.145807, -56.992413);
	AddCameraShot(-0.385976, 0.014031, -0.921793, -0.033508, 93.111061, 18.145807, -20.164375);
	AddCameraShot(0.695468, -0.129569, -0.694823, -0.129448, 27.284357, 18.145807, -12.377695);
	AddCameraShot(0.009002, -0.000795, -0.996084, -0.087945, 1.931320, 13.356332, -16.410583);
	AddCameraShot(0.947720, -0.145318, 0.280814, 0.043058, 11.650738, 16.955814, 28.359180);
	AddCameraShot(0.686380, -0.127550, 0.703919, 0.130810, -30.096384, 11.152356, -63.235146);
	AddCameraShot(0.937945, -0.108408, 0.327224, 0.037821, -43.701199, 8.756138, -49.974789);
	AddCameraShot(0.531236, -0.079466, -0.834207, -0.124787, -62.491230, 10.305247, -120.102989);
	AddCameraShot(0.452286, -0.179031, -0.812390, -0.321572, -50.015198, 15.394646, -114.879379);
	AddCameraShot(0.927563, -0.243751, 0.273918, 0.071982, 26.149965, 26.947924, -46.834148);
end

