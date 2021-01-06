--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
Conquest = ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams") 

--  These variables do not change
ATT = 1
DEF = 2

--  Empire Attacking (attacker is always #1)
CIS = ATT
REP = DEF

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

	    AddDeathRegion("death")
	    AddDeathRegion("death1")
	    AddDeathRegion("death2")
	    AddDeathRegion("death3")
	    AddDeathRegion("death4")




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
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    cp6 = CommandPost:New{name = "cp6"}
    
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
   
    SetPS2ModelMemory(4056000)
    
    SetMapNorthAngle(180, 1)
    SetMaxFlyHeight(25)
    SetMaxPlayerFlyHeight (25)
    AISnipeSuitabilityDist(30)
    
    
    
    SetMemoryPoolSize("Music", 33)

    ReadDataFile("ingame.lvl")
    
          
    ReadDataFile("sound\\cor.lvl;cor1cw")

    ReadDataFile("SIDE\\rep.lvl",
                "rep_inf_ep3_rifleman",
				"rep_fly_assault_DOME",
				"rep_fly_gunship_DOME",
                "rep_inf_ep3_rocketeer",
                "rep_inf_ep3_engineer",
                "rep_inf_ep3_sniper", 
                "rep_inf_ep3_officer",
                "rep_inf_ep3_jettrooper",
                "rep_hero_macewindu")
                
    ReadDataFile("SIDE\\cis.lvl",
                "cis_inf_rifleman",
		"cis_fly_droidfighter_DOME",
		"cis_inf_rocketeer",
                "cis_inf_engineer",
                "cis_inf_officer",
                "cis_inf_sniper",
                "cis_inf_droideka",
                "cis_hero_darthmaul")
                
    ReadDataFile("SIDE\\tur.lvl", 
    			"tur_bldg_laser")          
                
    
    SetupTeams{
             
        rep = {
            team = REP,
            units = 32,
            reinforcements = 150,
            soldier  = { "rep_inf_ep3_rifleman",7, 25},
            assault  = { "rep_inf_ep3_rocketeer",1, 4},
            engineer = { "rep_inf_ep3_engineer",1, 4},
            sniper   = { "rep_inf_ep3_sniper",1, 4},
            officer = {"rep_inf_ep3_officer",1, 4},
            special = { "rep_inf_ep3_jettrooper",1, 4},
            
        },
        cis = {
            team = CIS,
            units = 32,
            reinforcements = 150,
            soldier  = { "cis_inf_rifleman",7, 25},
            assault  = { "cis_inf_rocketeer",1, 4},
            engineer = { "cis_inf_engineer",1, 4},
            sniper   = { "cis_inf_sniper",1, 4},
            officer = {"cis_inf_officer",1, 4},
            special = { "cis_inf_droideka",1, 4},
        }
     }
    SetHeroClass(CIS, "cis_hero_darthmaul")
    SetHeroClass(REP, "rep_hero_macewindu")

     
    
--  Level Stats
    ClearWalkers()
    AddWalkerType(0, 3) -- 8 droidekas (special case: 0 leg pairs)
    AddWalkerType(1, 0) -- 
    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponCnt = 210
    SetMemoryPoolSize("Aimer", 22)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 250)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 18)
    SetMemoryPoolSize("EntitySoundStream", 10)
    SetMemoryPoolSize("EntitySoundStatic", 0)
    SetMemoryPoolSize("MountedTurret",12)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 375)
    SetMemoryPoolSize("SoundSpaceRegion", 38)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 140)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponCnt)
	SetMemoryPoolSize("EntityFlyer", 4)   

    SetSpawnDelay(10.0, 0.25)
   ReadDataFile("cor\\cor1.lvl","cor1_Conquest")
    SetDenseEnvironment("True")
         -- SetMaxFlyHeight(25)
     --SetMaxPlayerFlyHeight (25)
 AddDeathRegion("DeathRegion1")

    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\cor.lvl",  "cor1")
    OpenAudioStream("sound\\cor.lvl",  "cor1")
    -- OpenAudioStream("sound\\cor.lvl",  "cor1_emt")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)
    
    SetLowReinforcementsVoiceOver(REP, REP, "rep_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(REP, CIS, "rep_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, REP, "cis_off_victory_im", .1, 1)    

    SetOutOfBoundsVoiceOver(2, "Repleaving")
    SetOutOfBoundsVoiceOver(1, "Cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_cor_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_cor_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_cor_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_cor_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_cor_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_cor_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_cor_amb_victory")
    SetDefeatMusic (REP, "rep_cor_amb_defeat")
    SetVictoryMusic(CIS, "cis_cor_amb_victory")
    SetDefeatMusic (CIS, "cis_cor_amb_defeat")

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
    --Tat 1 - Dune Sea
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


