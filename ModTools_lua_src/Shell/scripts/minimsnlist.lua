--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- List of missions presented to the user for IA/MP/splitscreen/etc.
-- This list is kept in alphabetical order (in English, anyhow).
--
-- Each entry should be in the following form:
-- {    -- starts a table entry
--   mapluafile = "END1", -- base name of map, w/o attacking side, no ".lua" either
--   showstr = "planets.endor.name1", -- localization key in DB of item to show
--   side_a = 1,  -- [OPTIONAL] Put this in the table if there is a "a" version of the map
--   side_c = 1,  -- [OPTIONAL] Put this in the table if there is a "c" version of the map
--   side_i = 1,  -- [OPTIONAL] Put this in the table if there is a "i" version of the map
--   side_r = 1,  -- [OPTIONAL] Put this in the table if there is a "r" version of the map
--   side_a_team1 = "common.sides.all.name" -- [OPTIONAL] -- localized name of team1 in an 'a' version of this map
--   side_a_team2 = "common.sides.imp.name" -- [OPTIONAL] -- localized name of team2 in an 'a' version of this map
--    -- Note, there's also OPTIONAL side_c_team1, side_i_team1, side_r_team1,
--    -- side_c_team2, side_i_team2, side_r_team2 fields. 
-- 
-- },   -- ends a table entry
--
-- Below, things are in one-entry-per-line string.format to make it easier to
-- comment in/out maps by commenting in/out a single line

-- Maplist for the Demo clients, by platform
demops2_missionselect_listbox_contents = {
	{ mapluafile = "END1", showstr = "planets.endor.mapname1", side_a = 1},
--	{ mapluafile = "HOT1", showstr = "planets.hoth.mapname1", side_i = 1},
--	{ mapluafile = "KAM1", showstr = "planets.kamino.mapname1", side_c = 1},
}

-- Maplist for the Demo clients, by platform
demoxbox_missionselect_listbox_contents = {
	{ mapluafile = "END1", showstr = "planets.endor.mapname1", side_a = 1},
--	{ mapluafile = "HOT1", showstr = "planets.hoth.mapname1", side_i = 1},
	{ mapluafile = "KAM1", showstr = "planets.kamino.mapname1", side_c = 1},
}

-- Maplist for the Demo clients, by platform
demopc_missionselect_listbox_contents = {
	{ mapluafile = "END1", showstr = "planets.endor.mapname1", side_a = 1},
--	{ mapluafile = "HOT1", showstr = "planets.hoth.mapname1", side_i = 1},
--	{ mapluafile = "KAM1", showstr = "planets.kamino.mapname1", side_c = 1},
}

-- Maplist for the MP dedicated host at Demo. Formatted the way
-- ScriptCB_SetMissionNames() expects.
gDemo_XBox_HostMapList = {
	{ Map = "END1A", Side = 1, Team1 = "common.sides.all.name", Team2 = "common.sides.imp.name", },
	{ Map = "KAM1C", Side = 1, Team1 = "common.sides.cis.name", Team2 = "common.sides.rep.name", },
}

-- Maplist for the MP dedicated host at Demo. Formatted the way
-- ScriptCB_SetMissionNames() expects.
gDemo_PS2_HostMapList = {
	{ Map = "END1A", Side = 1, Team1 = "common.sides.all.name", Team2 = "common.sides.imp.name", },
	{ Map = "KAM1C", Side = 1, Team1 = "common.sides.cis.name", Team2 = "common.sides.rep.name", },
}

-- only loop through these two maps for demo mode
demomode_missionselect_listbox_contents = {
	{ mapluafile = "END1", showstr = "planets.endor.mapname1", side_a = 1},
--	{ mapluafile = "KAM1", showstr = "planets.kamino.mapname1", side_c = 1},
}

sp_missionselect_listbox_contents = {
--	{ mapluafile = "BES1", showstr = "planets.bespin.mapname1", side_r = 1, side_a = 1},
--	{ mapluafile = "BES2", showstr = "planets.bespin.mapname2", side_r = 1, side_a = 1},

	{ mapluafile = "END1", showstr = "planets.endor.mapname1", side_a = 1},

--	{ mapluafile = "GEO1", showstr = "planets.geonosis.mapname1", side_r = 1},

	{ mapluafile = "HOT1", showstr = "planets.hoth.mapname1", side_i = 1},

	{ mapluafile = "KAM1", showstr = "planets.kamino.mapname1", side_c = 1},

--	{ mapluafile = "KAS1", showstr = "planets.kashyyyk.mapname1", side_c = 1, side_i = 1},
--	{ mapluafile = "KAS2", showstr = "planets.kashyyyk.mapname2", side_c = 1, side_i = 1},

--	{ mapluafile = "NAB1", showstr = "planets.naboo.mapname1", side_c = 1, side_i = 1},
--	{ mapluafile = "NAB2", showstr = "planets.naboo.mapname2", side_c = 1, side_a = 1},

--	{ mapluafile = "RHN1", showstr = "planets.rhenvar.mapname1", side_r = 1, side_i = 1},
--	{ mapluafile = "RHN2", showstr = "planets.rhenvar.mapname2", side_c = 1, side_a = 1},

--	{ mapluafile = "TAT1", showstr = "planets.tatooine.mapname1", side_r = 1, side_i = 1},
--	{ mapluafile = "TAT2", showstr = "planets.tatooine.mapname2", side_r = 1, side_i = 1},

--	{ mapluafile = "YAV1", showstr = "planets.yavin.mapname1", side_c = 1, side_i = 1},
--	{ mapluafile = "YAV2", showstr = "planets.yavin.mapname2", side_r = 1, side_i = 1},

}

mp_missionselect_listbox_contents = {
--	{ mapluafile = "BES1", showstr = "planets.bespin.mapname1", side_r = 1, side_a = 1},
--	{ mapluafile = "BES2", showstr = "planets.bespin.mapname2", side_r = 1, side_a = 1},

	{ mapluafile = "END1", showstr = "planets.endor.mapname1", side_a = 1},

--	{ mapluafile = "GEO1", showstr = "planets.geonosis.mapname1", side_r = 1},

	{ mapluafile = "HOT1", showstr = "planets.hoth.mapname1", side_i = 1},

	{ mapluafile = "KAM1", showstr = "planets.kamino.mapname1", side_c = 1},

--	{ mapluafile = "KAS1", showstr = "planets.kashyyyk.mapname1", side_c = 1, side_i = 1},
--	{ mapluafile = "KAS2", showstr = "planets.kashyyyk.mapname2", side_c = 1, side_i = 1},

--	{ mapluafile = "NAB1", showstr = "planets.naboo.mapname1", side_c = 1, side_i = 1},
--	{ mapluafile = "NAB2", showstr = "planets.naboo.mapname2", side_c = 1, side_a = 1},

--	{ mapluafile = "RHN1", showstr = "planets.rhenvar.mapname1", side_r = 1, side_i = 1},
--	{ mapluafile = "RHN2", showstr = "planets.rhenvar.mapname2", side_c = 1, side_a = 1},

--	{ mapluafile = "TAT1", showstr = "planets.tatooine.mapname1", side_r = 1, side_i = 1},
--	{ mapluafile = "TAT2", showstr = "planets.tatooine.mapname2", side_r = 1, side_i = 1},

--	{ mapluafile = "YAV1", showstr = "planets.yavin.mapname1", side_c = 1, side_i = 1},
--	{ mapluafile = "YAV2", showstr = "planets.yavin.mapname2", side_r = 1, side_i = 1},


}


-- Singleplayer campaigns. Each of these tables has a set of
-- string.sub-tables, one string.sub-table per mission. These are run through in
-- order. Note: there is a math.max of 255 missions in a campaign. Todo:
-- add in listings for VOs, backgrounds, etc.
--
-- Optional params per line:
--   side = 2,    -- forces the user to team 2 (defender). If omitted, team 1 (attacker) is forced
--   intromovie = "", --movie played before yoda
--   outtromovie = "", --movie played after yoda, before mission
--   exitmovie = "", --movie played after mission is done (and you win)
-- [More will be coming, which refer to text to print, voiceover, etc.]

SPCampaign_CW = {
	--Player is CIS
	{
		mapluafile = "nab1c_h",
		side = 1,
		showstr = "ifs.sp.cw.map1name",
		description = "ifs.sp.cw.map1descr",
		movie = "nab1fly",
		voiceover = "cis_missionbriefing_nab1",
		outtromovie = "nab1h01",
        briefingmusic = "shell_droidinvasion",
		
	}, --Player is CIS
	{
	mapluafile = "nab2c_h",
		side = 1,
		showstr = "ifs.sp.cw.map2name",
		description = "ifs.sp.cw.map2descr",
		movie = "nab2fly",
		voiceover = "cis_missionbriefing_nab2",
		outtromovie = "nab2h01",
        briefingmusic = "shell_droidinvasion",
	}, --Player is CIS
	{
		mapluafile = "kas1c_h",
		side = 1,
		showstr = "ifs.sp.cw.map3name",
		description = "ifs.sp.cw.map3descr",
		movie = "kas1fly",
		voiceover = "cis_missionbriefing_kas1",
        briefingmusic = "shell_droidinvasion",
		unlockable = 1,
	}, 

	--Player is Republic
	{
		mapluafile = "geo1r_h",
		side = 1,
		showstr = "ifs.sp.cw.map4name",
		description = "ifs.sp.cw.map4descr",
		movie = "geo1fly",
		outtromovie = "geo1h01",
		voiceover = "rep_missionbriefing_geo1",
        briefingmusic = "shell_clonewars",
		unlockable = 2,
	},
	
	--Player is Republic
	{
		mapluafile = "kam1c_h",
		side = 2,
		showstr = "ifs.sp.cw.map5name",
		description = "ifs.sp.cw.map5descr",
		movie = "kam1fly",
		intromovie = "kam1h01",
		outtromovie = "kam1h02",
		voiceover = "rep_missionbriefing_kam1",
        briefingmusic = "shell_clonewars",
		unlockable = 3,	
	},--Player is Republic
	{
		mapluafile = "rhn1r_h",
		side = 1,
		showstr = "ifs.sp.cw.map6name",
		description = "ifs.sp.cw.map6descr",
		movie = "rhn1fly",
		voiceover = "rep_missionbriefing_rhn1",
        briefingmusic = "shell_clonewars",
			
	},--Player is Republic
	{
		mapluafile = "kas2c_h",
		side = 2,
		showstr = "ifs.sp.cw.map7name",
		description = "ifs.sp.cw.map7descr", side = 2,
		movie = "kas2fly",
		voiceover = "rep_missionbriefing_kas1",
        briefingmusic = "shell_clonewars",
		exitmovie = "kas2h01",
		unlockable = 4,
	},--Player is Republic
}

SPCampaign_GCW = {
	--Player is the Empire
	{
		mapluafile = "tat1i_h",
		side = 1,
		showstr = "ifs.sp.gcw.map1name",
		description = "ifs.sp.gcw.map1descr",
		movie = "tat1fly",
		outtromovie = "tat1h01",
		voiceover = "imp_missionbriefing_tat1",
        briefingmusic = "shell_imperialmarch",
	},--Player is the Empire
	{
		mapluafile = "tat2i_h",
		side = 1,		
		showstr = "ifs.sp.gcw.map2name",
		description = "ifs.sp.gcw.map2descr",
		movie = "tat2fly",
		intromovie = "tat2h01",
		voiceover = "imp_missionbriefing_tat2",
        briefingmusic = "shell_imperialmarch",
		unlockable = 5,
	},--Player is the Empire
	{
		mapluafile = "rhn2a_h",
		side = 2,
		showstr = "ifs.sp.gcw.map3name",
		description = "ifs.sp.gcw.map3descr",
		movie = "rhn2fly",
		voiceover = "imp_missionbriefing_rhn1",
        briefingmusic = "shell_imperialmarch",
	},--Player is the Empire
	{
		mapluafile = "yav2i_h",
		side = 1,		
		showstr = "ifs.sp.gcw.map4name",
		description = "ifs.sp.gcw.map4descr",
		movie = "yav2fly",
		intromovie = "yav2h01",
		voiceover = "imp_missionbriefing_yav1",
        briefingmusic = "shell_imperialmarch",
	},--Player is the Alliance
	{
		mapluafile = "yav1i_h",
		side = 2,		
		showstr = "ifs.sp.gcw.map5name",
		description = "ifs.sp.gcw.map5descr",
		movie = "yav1fly",
		intromovie = "yav1h01",
		voiceover = "all_missionbriefing_yav1",
        briefingmusic = "shell_clash",
		unlockable = 6,
	},--Player is the Alliance

	--Player is the Alliance
	{
		mapluafile = "hot1i_h",
		side = 2,		
		showstr = "ifs.sp.gcw.map6name",
		description = "ifs.sp.gcw.map6descr", side = 2,
		movie = "hot1fly",
		outtromovie = "hot1h02",
		voiceover = "all_missionbriefing_hot1",
        briefingmusic = "shell_clash",
		unlockable = 7,
	},--Player is the Alliance
	{
		mapluafile = "bes2a_h",
		side = 1,
		showstr = "ifs.sp.gcw.map7name",
		description = "ifs.sp.gcw.map7descr",
		movie = "bes2fly",
		intromovie = "bes2h01",
		voiceover = "all_missionbriefing_bes1",
        briefingmusic = "shell_clash",
	},--Player is the Alliance
	{
		mapluafile = "bes1a_h",
		side = 1,
		showstr = "ifs.sp.gcw.map8name",
		description = "ifs.sp.gcw.map8descr",
		movie = "bes1fly",
		outtromovie = "bes1h01",
		voiceover = "all_missionbriefing_bes2",
        briefingmusic = "shell_clash",
		unlockable = 8,
	},--Player is the Alliance
	{
		mapluafile = "end1a_h",
		side = 1,		
		showstr = "ifs.sp.gcw.map9name",
		description = "ifs.sp.gcw.map9descr",
		movie = "end1fly",
		outtromovie = "end1h02",
		exitmovie = "end1h03",
		voiceover = "all_missionbriefing_end1",
        briefingmusic = "shell_clash",
		unlockable = 9,
	},--Player is the Alliance
}
