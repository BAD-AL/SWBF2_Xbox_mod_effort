-- XBOX BF1
--missionlist.lua 
--generated from Phantom's program
-- verified (cbadal)

sp_missionselect_listbox_contents = { 
 { mapluafile = "BES1", showstr = "planets.bespin.mapname1", side_r = 1, side_a = 1},
 { mapluafile = "BES2", showstr = "planets.bespin.mapname2", side_r = 1, side_a = 1},
 { mapluafile = "END1", showstr = "planets.endor.mapname1", side_a = 1},
 { mapluafile = "GEO1", showstr = "planets.geonosis.mapname1", side_r = 1},
 { mapluafile = "HOT1", showstr = "planets.hoth.mapname1", side_i = 1},
 { mapluafile = "KAM1", showstr = "planets.kamino.mapname1", side_c = 1},
 { mapluafile = "KAS1", showstr = "planets.kashyyyk.mapname1", side_c = 1, side_i = 1},
 { mapluafile = "KAS2", showstr = "planets.kashyyyk.mapname2", side_c = 1, side_i = 1},
 { mapluafile = "NAB1", showstr = "planets.naboo.mapname1", side_c = 1, side_i = 1},
 { mapluafile = "NAB2", showstr = "planets.naboo.mapname2", side_c = 1, side_a = 1},
 { mapluafile = "RHN1", showstr = "planets.rhenvar.mapname1", side_r = 1, side_i = 1},
 { mapluafile = "RHN2", showstr = "planets.rhenvar.mapname2", side_c = 1, side_a = 1},
 { mapluafile = "TAT1", showstr = "planets.tatooine.mapname1", side_r = 1, side_i = 1},
 { mapluafile = "TAT2", showstr = "planets.tatooine.mapname2", side_r = 1, side_i = 1},
 { mapluafile = "YAV1", showstr = "planets.yavin.mapname1", side_c = 1, side_i = 1},
 { mapluafile = "YAV2", showstr = "planets.yavin.mapname2", side_r = 1, side_i = 1}}

mp_missionselect_listbox_contents = { 
 { mapluafile = "BES1", showstr = "planets.bespin.mapname1", side_r = 1, side_a = 1},
 { mapluafile = "BES2", showstr = "planets.bespin.mapname2", side_r = 1, side_a = 1},
 { mapluafile = "END1", showstr = "planets.endor.mapname1", side_a = 1},
 { mapluafile = "GEO1", showstr = "planets.geonosis.mapname1", side_r = 1},
 { mapluafile = "HOT1", showstr = "planets.hoth.mapname1", side_i = 1},
 { mapluafile = "KAM1", showstr = "planets.kamino.mapname1", side_c = 1},
 { mapluafile = "KAS1", showstr = "planets.kashyyyk.mapname1", side_c = 1, side_i = 1},
 { mapluafile = "KAS2", showstr = "planets.kashyyyk.mapname2", side_c = 1, side_i = 1},
 { mapluafile = "NAB1", showstr = "planets.naboo.mapname1", side_c = 1, side_i = 1},
 { mapluafile = "NAB2", showstr = "planets.naboo.mapname2", side_c = 1, side_a = 1},
 { mapluafile = "RHN1", showstr = "planets.rhenvar.mapname1", side_r = 1, side_i = 1},
 { mapluafile = "RHN2", showstr = "planets.rhenvar.mapname2", side_c = 1, side_a = 1},
 { mapluafile = "TAT1", showstr = "planets.tatooine.mapname1", side_r = 1, side_i = 1},
 { mapluafile = "TAT2", showstr = "planets.tatooine.mapname2", side_r = 1, side_i = 1},
 { mapluafile = "YAV1", showstr = "planets.yavin.mapname1", side_c = 1, side_i = 1},
 { mapluafile = "YAV2", showstr = "planets.yavin.mapname2", side_r = 1, side_i = 1}}

attract_mode_maps = { "bes1a", "bes1r", "bes2a", "bes2r", "end1a", "geo1r", "hot1i", "kam1c", "kas1c", "kas1i", "kas2c", "kas2i", "nab1c", "nab1i", "nab2a", "nab2c", "rhn1i", "rhn1r", "tat1i", "tat1r", "tat2i", "tat2r", "yav1c", "yav1i", "yav2i", "yav2r", "nab1c_h", "nab2c_h", "kas1c_h", "geo1r_h", "kam1c_h", "rhn1r_h", "kas2c_h", "tat1i_h", "tat2i_h", "rhn2a_h", "yav2i_h", "yav1i_h", "hot1i_h", "bes2a_h", "bes1a_h", "end1a_h"}

SPCampaign_CW = { 
 { mapluafile = "nab1c_h", side = 1, showstr = "ifs.sp.cw.map1name", description = "ifs.sp.cw.map1descr", movie = "nab1fly", voiceover = "cis_missionbriefing_nab1", intromovie = "nab1h01", outtromovie = "tutorial01cw", outtromovie_left = 90, outtromovie_top = 60, outtromovie_width = 460, outtromovie_height = 350, outtromovielocalized = 1, briefingmusic = "shell_droidinvasion", iconmodel = "com_icon_CIS"},
 { mapluafile = "nab2c_h", side = 1, showstr = "ifs.sp.cw.map2name", description = "ifs.sp.cw.map2descr", movie = "nab2fly", voiceover = "cis_missionbriefing_nab2", outtromovie = "nab2h01", briefingmusic = "shell_droidinvasion", unlockable = 1, iconmodel = "com_icon_CIS"},
 { mapluafile = "kas1c_h", side = 1, showstr = "ifs.sp.cw.map3name", description = "ifs.sp.cw.map3descr", movie = "kas1fly", voiceover = "cis_missionbriefing_kas1", briefingmusic = "shell_droidinvasion", unlockable = 2, iconmodel = "com_icon_CIS"},
 { mapluafile = "geo1r_h", side = 1, showstr = "ifs.sp.cw.map4name", description = "ifs.sp.cw.map4descr", movie = "geo1fly", outtromovie = "geo1h01", voiceover = "rep_missionbriefing_geo1", briefingmusic = "shell_clonewars", unlockable = 3, iconmodel = "com_icon_republic"},
 { mapluafile = "kam1c_h", side = 2, showstr = "ifs.sp.cw.map5name", description = "ifs.sp.cw.map5descr", movie = "kam1fly", intromovie = "kam1h01", outtromovie = "kam1h02", voiceover = "rep_missionbriefing_kam1", briefingmusic = "shell_clonewars", unlockable = 4, iconmodel = "com_icon_republic"},
 { mapluafile = "rhn1r_h", side = 1, showstr = "ifs.sp.cw.map6name", description = "ifs.sp.cw.map6descr", movie = "rhn1fly", voiceover = "rep_missionbriefing_rhn1", briefingmusic = "shell_clonewars", unlockable = 5, iconmodel = "com_icon_republic"},
 { mapluafile = "kas2c_h", side = 2, showstr = "ifs.sp.cw.map7name", description = "ifs.sp.cw.map7descr", side = 2, movie = "kas2fly", voiceover = "rep_missionbriefing_kas1", briefingmusic = "shell_clonewars", exitmovie = "kas2h01", iconmodel = "com_icon_republic"}}

SPCampaign_GCW = { 
 { mapluafile = "tat1i_h", side = 1, showstr = "ifs.sp.gcw.map1name", description = "ifs.sp.gcw.map1descr", movie = "tat1fly", intromovie = "tat1h01", outtromovie = "tutorial01gcw", outtromovie_left = 90, outtromovie_top = 60, outtromovie_width = 460, outtromovie_height = 350, outtromovielocalized = 1, voiceover = "imp_missionbriefing_tat1", briefingmusic = "shell_imperialmarch", iconmodel = "com_icon_imperial"},
 { mapluafile = "tat2i_h", side = 1, showstr = "ifs.sp.gcw.map2name", description = "ifs.sp.gcw.map2descr", movie = "tat2fly", intromovie = "tat2h01", voiceover = "imp_missionbriefing_tat2", briefingmusic = "shell_imperialmarch", unlockable = 6, iconmodel = "com_icon_imperial"},
 { mapluafile = "rhn2a_h", side = 2, showstr = "ifs.sp.gcw.map3name", description = "ifs.sp.gcw.map3descr", movie = "rhn2fly", voiceover = "imp_missionbriefing_rhn1", briefingmusic = "shell_imperialmarch", iconmodel = "com_icon_imperial"},
 { mapluafile = "yav2i_h", side = 1, showstr = "ifs.sp.gcw.map4name", description = "ifs.sp.gcw.map4descr", movie = "yav2fly", intromovie = "yav2h01", voiceover = "imp_missionbriefing_yav1", briefingmusic = "shell_imperialmarch", iconmodel = "com_icon_imperial"},
 { mapluafile = "yav1i_h", side = 2, showstr = "ifs.sp.gcw.map5name", description = "ifs.sp.gcw.map5descr", movie = "yav1fly", intromovie = "yav1h01", voiceover = "all_missionbriefing_yav1", briefingmusic = "shell_clash", unlockable = 7, iconmodel = "com_icon_alliance"},
 { mapluafile = "hot1i_h", side = 2, showstr = "ifs.sp.gcw.map6name", description = "ifs.sp.gcw.map6descr", side = 2, movie = "hot1fly", outtromovie = "hot1h02", voiceover = "all_missionbriefing_hot1", briefingmusic = "shell_clash", unlockable = 8, iconmodel = "com_icon_alliance"},
 { mapluafile = "bes2a_h", side = 1, showstr = "ifs.sp.gcw.map7name", description = "ifs.sp.gcw.map7descr", movie = "bes2fly", intromovie = "bes2h01", voiceover = "all_missionbriefing_bes1", briefingmusic = "shell_clash", unlockable = 9, iconmodel = "com_icon_alliance"},
 { mapluafile = "bes1a_h", side = 1, showstr = "ifs.sp.gcw.map8name", description = "ifs.sp.gcw.map8descr", movie = "bes1fly", outtromovie = "bes1h01", voiceover = "all_missionbriefing_bes2", briefingmusic = "shell_clash", unlockable = 10, iconmodel = "com_icon_alliance"},
 { mapluafile = "end1a_h", side = 1, showstr = "ifs.sp.gcw.map9name", description = "ifs.sp.gcw.map9descr", movie = "end1fly", outtromovie = "end1h02", exitmovie = "end1h03", voiceover = "all_missionbriefing_end1", briefingmusic = "shell_clash", iconmodel = "com_icon_alliance"}
}

