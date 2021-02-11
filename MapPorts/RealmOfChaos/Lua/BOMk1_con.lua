--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
print("BOMc_con start")

if( printf == nil ) then 
    printf = function(...)
        print(string.format(unpack(arg)))
    end 
end 

function MemInfo(debugStr)
    if( ScriptCB_GetPlatform() == "PC") then 
        local k,t = gcinfo ()
        --print("MemInfo:" .. k .. " kb threshold: " .. t  .. " kb ".. debugStr )
        printf("MemInfo: used: %d kb threshold: %d kb %s",k,t, debugStr )
    end
end 

ScriptCB_DoFile("ObjectiveConquest")
MemInfo("BOMc_con:ObjectiveConquest ")
ScriptCB_DoFile("setup_teams") 
MemInfo("BOMc_con:setup_teams ")
	
	--  REP Attacking (attacker is always #1)
    REP = 1;
    CIS = 2;
    --  These variables do not change
    ATT = REP;
    DEF = CIS;

MemInfo("BOMc_con:After attack setup")

function ScriptPostLoad()
    MemInfo("BOMc_con:ScriptPostLoad:begin")
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    cp6 = CommandPost:New{name = "cp6"}
    cp7 = CommandPost:New{name = "cp7"}
    cp8 = CommandPost:New{name = "cp8"}
    
    
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
    conquest:AddCommandPost(cp7)
    conquest:AddCommandPost(cp8)   

    --[[
    OnObjectKillTeam(
        function(object, killer)
            print("OnObjectKillTeam(CIS)")
            MemInfo("ObjectKilled(CIS):")
            local k,t = gcinfo()
            local my_message = "u:" .. k .."kb-t:" .. t .."kb"
            IFText_fnSetString(ifs_pausemenu.buttons._titlebar_, my_message)
            dofile("exec.lua") -- 'dofile()'' not implemented on Xbox 
        end,
    CIS
    )
    ]]
    conquest:Start()

    --[[
        map  1  2  3  4  5  6  7  8 
         xb  2  7  3  1  4  6  0  5
         4 1 3 2
    ]]

    EnableSPHeroRules()
    MemInfo("BOMc_con:ScriptPostLoad:end")
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
    MemInfo("BOMc_con:ScriptInit:start")
    --try this?
    -- Designers, these two lines *MUST* be first.
    --StealArtistHeap(2048*1024) -- (2MB)
    --SetPS2ModelMemory(3000000)
    --StealArtistHeap(3072*1024) -- (3MB) gets 2 player to load ! (but visibility kinda sux)
    
    --StealArtistHeap(2560*1024) -- (2.5MB) -- visibility is still shit
    --SetPS2ModelMemory(4200000)  -- did not notice a difference with this removed (xbox)
    local mb = 1 -- steal this many megabytes
    printf("Gonna Steal %d MB", mb)
    StealArtistHeap( mb * 1024 * 1024) 
    print("Stole it!")
    SetPS2ModelMemory(4200000)
    
    --print("XMSc_con: Show Loadscreen")
    --ReadDataFile("dc:Load\\common.lvl")
    --print("XMSc_con: Show Loadscreen - Done")
    MemInfo("ReadDataFile(ingame.lvl):start")
    ReadDataFile("ingame.lvl")
    MemInfo("ReadDataFile(ingame.lvl):end")
    
   
    SetMaxFlyHeight(1000)
    SetMaxPlayerFlyHeight (1000)
    
    --SetMemoryPoolSize ("ClothData",20)
    --SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    --SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    --SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    --SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    --SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    --SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    --SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
    
    MemInfo("ReadDataFile('sound\\yav.lvl;yav1cw'):start")
    ReadDataFile("sound\\yav.lvl;yav1cw")
    MemInfo("ReadDataFile(sound\\yav.lvl;yav1cw):end")
    --ReadDataFile("SIDE\\tur.lvl",  "tur_bldg_laser", "tur_bldg_tower")

    MemInfo("ReadDataFile('DC:SIDE\\rep.lvl'):start")
    ReadDataFile("DC:SIDE\\rep.lvl",
                    "rep_inf_ep3_rifleman",
                    "rep_inf_ep3_rocketeer",
                    "rep_inf_ep3_engineer",
                    "rep_inf_ep2_jettrooper_sniper",
                    "rep_inf_ep2_rocketeer_chaingun",
                    "rep_inf_ep3_jettrooper",
                    "rep_hover_fightertank"
                    --"rep_hover_barcspeeder",
                    --"rep_walk_oneman_atst"
                    --,"rep_walk_atte"
                )
    MemInfo("ReadDataFile('DC:SIDE\\rep.lvl'):end")
    ReadDataFile("DC:SIDE\\cis.lvl",
                    "cis_inf_rifleman",
                    "cis_inf_rocketeer",
                    "cis_inf_engineer",
                    "cis_inf_sniper",
                    "cis_inf_officer",
                    "cis_inf_droideka",

                    "cis_hover_aat"
                    --"cis_tread_hailfire"
                )
    MemInfo("ReadDataFile('DC:SIDE\\cis.lvl'):end")

	SetupTeams{
            rep = {
                team = REP,
                units = 30,
                reinforcements = 150,
                soldier  = { "rep_inf_ep3_rifleman",1, 4},
                assault  = { "rep_inf_ep3_rocketeer",1, 4},
                engineer = { "rep_inf_ep3_engineer",1, 4},
                sniper   = { "rep_inf_ep2_jettrooper_sniper",9, 25},
                officer = {"rep_inf_ep2_rocketeer_chaingun",1,1},
                special = { "rep_inf_ep3_jettrooper",1,4},
                
            },
            cis = {
                team = CIS,
                units = 30,
                reinforcements = 150,
                soldier  = { "cis_inf_rifleman",1,4},
                assault  = { "cis_inf_rocketeer",1,4},
                engineer = { "cis_inf_engineer",9,25},
                sniper   = { "cis_inf_sniper",1, 4},
                officer = {"cis_inf_officer",1, 4},
                special = { "cis_inf_droideka",1, 4},
            }
    }
    MemInfo("SetupTeams:end")
    --ReadDataFile("DC:SIDE\\des.lvl", "tat_inf_jawa")
    --ReadDataFile("DC:SIDE\\geo.lvl","gen_inf_geonosian")
    --SetHeroClass(ALL, "tat_inf_jawa")
    --SetHeroClass(IMP, "gen_inf_geonosian")

    --  Level Stats
    ClearWalkers()
    MemInfo("AddWalkerType:start")
    AddWalkerType(0, 4) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 1024
    MemInfo("SetMemoryPoolSize:start")
    --SetMemoryPoolSize("Aimer", 100)
    --SetMemoryPoolSize("AmmoCounter", weaponCnt)
    --SetMemoryPoolSize("BaseHint", 1024)
    --SetMemoryPoolSize("EnergyBar", weaponCnt)
    --SetMemoryPoolSize("EntityCloth", 32)
    
	SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    --SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 32)
    --SetMemoryPoolSize("MountedTurret", 32)
	--SetMemoryPoolSize("Navigator", 128)
    --SetMemoryPoolSize("Obstacle", 1024)
	--SetMemoryPoolSize("PathNode", 1024)
    --SetMemoryPoolSize("SoundSpaceRegion", 64)
    --SetMemoryPoolSize("TreeGridStack", 1024)
	--SetMemoryPoolSize("UnitAgent", 128)
	--SetMemoryPoolSize("UnitController", 128)
    --SetMemoryPoolSize("Weapon", weaponCnt)
    SetMemoryPoolSize("SoldierAnimation", 248)
    MemInfo("SetMemoryPoolSize:end")
    
    SetSpawnDelay(10.0, 0.25)
    MemInfo("BOMc_con:ScriptInit:LoadConquest_Start")
    ReadDataFile("dc:BOM\\BOM.lvl", "BOM_conquest")
    MemInfo("BOMc_con:ScriptInit:LoadConquest_End")
    SetDenseEnvironment("false")




    --  Sound
    MemInfo("BOMc_con:ScriptInit:Sound_Start")
    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")

    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")

    -- Removing the lines below gets 4-player to load again 
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    --OpenAudioStream("sound\\yav.lvl",  "yav1")
    --OpenAudioStream("sound\\yav.lvl",  "yav1")
    --OpenAudioStream("sound\\yav.lvl",  "yav1_emt")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(2, "cisleaving")
    SetOutOfBoundsVoiceOver(1, "repleaving")

    SetAmbientMusic(REP, 1.0, "rep_yav_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_yav_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_yav_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_yav_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_yav_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_yav_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_yav_amb_victory")
    SetDefeatMusic (REP, "rep_yav_amb_defeat")
    SetVictoryMusic(CIS, "cis_yav_amb_victory")
    SetDefeatMusic (CIS, "cis_yav_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",      "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut",     "binocularzoomout")
    --SetSoundEffect("BirdScatter",             "birdsFlySeq1")
    --SetSoundEffect("WeaponUnableSelect",      "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")
    MemInfo("BOMc_con:ScriptInit:Sound_End")


--OpeningSateliteShot
    MemInfo("BOMc_con:ScriptInit:CameraShot_Start")
    AddCameraShot(0.908386, -0.209095, -0.352873, -0.081226, -45.922508, -19.114113, 77.022636);

    AddCameraShot(-0.481173, 0.024248, -0.875181, -0.044103, 14.767292, -30.602322, -144.506851);
    AddCameraShot(0.999914, -0.012495, -0.004416, -0.000055, 1.143253, -33.602314, -76.884430);
    AddCameraShot(0.839161, 0.012048, -0.543698, 0.007806, 19.152437, -49.802273, 24.337317);
    AddCameraShot(0.467324, 0.006709, -0.883972, 0.012691, 11.825212, -49.802273, -7.000720);
    AddCameraShot(0.861797, 0.001786, -0.507253, 0.001051, -11.986043, -59.702248, 23.263165);
    AddCameraShot(0.628546, -0.042609, -0.774831, -0.052525, 20.429928, -48.302277, 9.771714);
    AddCameraShot(0.765213, -0.051873, 0.640215, 0.043400, 57.692474, -48.302277, 16.540724);
    AddCameraShot(0.264032, -0.015285, -0.962782, -0.055734, -16.681797, -42.902290, 129.553268);
    AddCameraShot(-0.382320, 0.022132, -0.922222, -0.053386, 20.670977, -42.902290, 135.513001);

    MemInfo("BOMc_con:ScriptInit:CameraShot_End")

    AddDeathRegion("LavaDeath1")
    MemInfo("BOMc_con:ScriptInit:end")
end

