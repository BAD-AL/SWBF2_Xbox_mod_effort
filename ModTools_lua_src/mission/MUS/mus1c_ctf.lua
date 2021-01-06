    --
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


ScriptCB_DoFile("objectivectf")
ScriptCB_DoFile("setup_teams")

--  These variables do not change
ATT = 1
DEF = 2

--  republic Attacking (attacker is always #1)
REP = ATT
CIS = DEF
 
 --PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()
     PlayAnimRise()
    UnblockPlanningGraphArcs("Connection74")
        DisableBarriers("1")
    DisableBarriers("BALCONEY")
    DisableBarriers("bALCONEY2")
    DisableBarriers("hallway_f")
    DisableBarriers("hackdoor")
    DisableBarriers("outside")
     
    OnObjectRespawnName(PlayAnimRise, "DingDong");
    OnObjectKillName(PlayAnimDrop, "DingDong");
 --Capture the Flag for stand-alone multiplayer
                -- These set the flags geometry names.
                --GeometryName sets the geometry when hte flag is on the ground
                --CarriedGeometryName sets the geometry that appears over a player's head that is carrying the flag
        SetProperty("FLAG1", "GeometryName", "com_icon_republic_flag")
        SetProperty("FLAG1", "CarriedGeometryName", "com_icon_republic_flag_carried")
        SetProperty("FLAG2", "GeometryName", "com_icon_cis_flag")
        SetProperty("FLAG2", "CarriedGeometryName", "com_icon_cis_flag_carried")

                --This makes sure the flag is colorized when it has been dropped on the ground
        SetClassProperty("com_item_flag", "DroppedColorize", 1)
    SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )
    --This is all the actual ctf objective setup
    ctf = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 5,  textATT = "game.modes.ctf", textDEF = "game.modes.ctf2",  multiplayerRules = true}
    ctf:AddFlag{name = "FLAG1", homeRegion = "FLAG1_HOME", captureRegion = "FLAG2_HOME",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:AddFlag{name = "FLAG2", homeRegion = "FLAG2_HOME", captureRegion = "FLAG1_HOME",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:Start()
    EnableSPHeroRules()

 end
 --START BRIDGEWORK!

-- OPEN
function PlayAnimDrop()
      PauseAnimation("lava_bridge_raise");    
      RewindAnimation("lava_bridge_drop");
      PlayAnimation("lava_bridge_drop");
        
    -- prevent the AI from running across it
    BlockPlanningGraphArcs("Connection82");
    BlockPlanningGraphArcs("Connection83");
    EnableBarriers("Bridge");
    
end
-- CLOSE
function PlayAnimRise()
      PauseAnimation("lava_bridge_drop");
      RewindAnimation("lava_bridge_raise");
      PlayAnimation("lava_bridge_raise");
            

        -- allow the AI to run across it
    UnblockPlanningGraphArcs("Connection82");
    UnblockPlanningGraphArcs("Connection83");
    DisableBarriers("Bridge");
 end


function ScriptInit()
StealArtistHeap(128*1024)
    -- Designers, these two lines *MUST* be first!
        SetPS2ModelMemory(3600000)
    ReadDataFile("ingame.lvl")

   



    ReadDataFile("sound\\mus.lvl;mus1cw")

    ReadDataFile("SIDE\\rep.lvl",
                             "rep_inf_ep3_rifleman",
                             "rep_inf_ep3_rocketeer",
                             "rep_inf_ep3_engineer",
                             "rep_inf_ep3_jettrooper",
                             "rep_inf_ep3_sniper_felucia",
                             "rep_inf_ep3_officer",
                             "rep_hero_obiwan")
                             --"rep_bldg_defensegridturret")
                             
    ReadDataFile("SIDE\\cis.lvl",     
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             "cis_inf_engineer",
                             "cis_inf_sniper",
                             "CIS_inf_officer",
                             "cis_hero_darthmaul",
                             "cis_inf_droideka")
                             --"cis_bldg_defensegridturret")


    --  SetAttackingTeam(ATT)
SetupTeams{
    REP = {
        team = REP,
        units = 32,
reinforcements = -1,
        soldier = { "rep_inf_ep3_rifleman",7, 25},
        assault = { "rep_inf_ep3_rocketeer",1, 4},
        engineer = { "rep_inf_ep3_engineer", 1, 4},
        sniper  = { "rep_inf_ep3_sniper_felucia",1, 4},
        officer = { "rep_inf_ep3_officer", 1, 4},
        special = { "rep_inf_ep3_jettrooper",1, 4},
            --turret = { "rep_bldg_defensegridturret"},
    },

}   

SetupTeams{
    CIS = {
        team = CIS,
        units = 32,
reinforcements = -1,
        soldier = { "CIS_inf_rifleman",7, 25},
        assault = { "CIS_inf_rocketeer",1, 4},
        engineer = { "CIS_inf_engineer", 1, 4},
        sniper  = { "CIS_inf_sniper",1, 4},
        officer = { "CIS_inf_officer", 1, 4},
        special = { "cis_inf_droideka",1, 4},
     -- turret = { "cis_bldg_defensegridturret"},
    },

}
    SetHeroClass(REP, "rep_hero_obiwan")
    SetHeroClass(CIS, "cis_hero_darthmaul")
    
    ClearWalkers()
    SetMemoryPoolSize("Aimer", 0)
    SetMemoryPoolSize("EntityFlyer", 4)
    SetMemoryPoolSize("EntityCloth", 19)
    SetMemoryPoolSize("EntitySoundStatic", 133)
    SetMemoryPoolSize("MountedTurret", 0)
    SetMemoryPoolSize("Obstacle", 290)

    SetSpawnDelay(10.0, 0.25)
    SetDenseEnvironment("false")
    --AddDeathRegion("Sarlac01")
        SetMaxFlyHeight(84.16)
SetMaxPlayerFlyHeight(90)
    AISnipeSuitabilityDist(30)
    SetMemoryPoolSize("FlagItem", 2) 
    
    ReadDataFile("mus\\mus1.lvl", "MUS1_CTF")
     
    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)     
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\mus.lvl",  "mus1")
    OpenAudioStream("sound\\mus.lvl",  "mus1")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    -- OpenAudioStream("sound\\mus.lvl",  "mus1_emt")


    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_mus_amb_start",  0,1)
    SetAmbientMusic(REP, 0.9, "rep_mus_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.1,"rep_mus_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_mus_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.9, "cis_mus_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.1,"cis_mus_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_mus_amb_victory")
    SetDefeatMusic (REP, "rep_mus_amb_defeat")
    SetVictoryMusic(CIS, "cis_mus_amb_victory")
    SetDefeatMusic (CIS, "cis_mus_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


   	AddCameraShot(0.446393, -0.064402, -0.883371, -0.127445, -93.406929, 72.953865, -35.479401);
	
	AddCameraShot(-0.297655, 0.057972, -0.935337, -0.182169, -2.384067, 71.165306, 18.453350);
	
	AddCameraShot(0.972488, -0.098362, 0.210097, 0.021250, -42.577881, 69.453072, 4.454691);
	
	AddCameraShot(0.951592, -0.190766, -0.236300, -0.047371, -44.607018, 77.906273, 113.228661);
	
	AddCameraShot(0.841151, -0.105984, 0.526154, 0.066295, 109.567764, 77.906273, 7.873035);
	
	AddCameraShot(0.818472, -0.025863, 0.573678, 0.018127, 125.781593, 61.423031, 9.809184);
	
	AddCameraShot(-0.104764, 0.000163, -0.994496, -0.001550, -13.319855, 70.673264, 63.436607);
	
	AddCameraShot(0.971739, 0.102058, 0.211692, -0.022233, -5.680069, 68.543945, 57.904160);
	
	AddCameraShot(0.178437, 0.004624, -0.983610, 0.025488, -66.947433, 68.543945, 6.745875);

    AddCameraShot(-0.400665, 0.076364, -0896894, -0.170941, 96.201210, 79.913033, -58.604382)
end




