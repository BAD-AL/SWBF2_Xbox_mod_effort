	-- redefine the tables here 
	sp_missionselect_listbox_contents = {
		-- In the below list, the first '%s' will be replaced by the era,
		-- and the second will be replaced by the multiplayer variant name
		-- (the part after "mode_")
	
		-- *****************  \/ MOD LEVELS GO HERE \/ ************************************
		{ isModLevel = 1, mapluafile = "ABC%s_%s", era_g = 1, era_c = 1, mode_con_g = 1, mode_con_c  = 1,},
		
		-- *****************  /\ MOD LEVELS GO HERE /\ ************************************
	
	    { mapluafile = "bes2%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1,  mode_ctf_c = 1, mode_ctf_g = 1, mode_eli_g = 1, },
		{ mapluafile = "cor1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1,  mode_eli_g = 1, },
		{ mapluafile = "dag1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1,},
		{ mapluafile = "dea1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1, },
		{ mapluafile = "end1%s_%s", era_g = 1,                            mode_con_g = 1, mode_hunt_g = 1, mode_1flag_g = 1, },
		{ mapluafile = "fel1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,},
		{ mapluafile = "geo1%s_%s",            era_c = 1, mode_con_c = 1, mode_ctf_c = 1, mode_hunt_c = 1, mode_xl_c = 1},
		{ mapluafile = "hot1%s_%s", era_g = 1,            mode_con_g = 1, mode_1flag_g = 1, mode_hunt_g = 1, mode_xl_g = 1},
		{ mapluafile = "kam1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,},
		{ mapluafile = "kas2%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_hunt_c = 1,  mode_ctf_c = 1, mode_ctf_g = 1, mode_eli_g = 1,},
		{ mapluafile = "mus1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1,},
		{ mapluafile = "myg1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1, mode_eli_g = 1,},
		{ mapluafile = "nab2%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1,  mode_hunt_c = 1, mode_eli_g = 1,},
		{ mapluafile = "pol1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1,},
	    { mapluafile = "rhn1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1, mode_hunt_c = 1, mode_eli_g = 1,},
	    { mapluafile = "rhn2%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,  mode_eli_g = 1,},
		{ mapluafile = "spa1%s_%s", era_g = 1,            mode_assault_g = 1, mode_1flag_g = 1,},
	--    { mapluafile = "spa2%s_%s",            era_c = 1, mode_con_c = 1, mode_con_g = 1, },
		{ mapluafile = "spa3%s_%s",            era_c = 1, mode_assault_c = 1, mode_1flag_c = 1,},
		--{ mapluafile = "spa4%s_%s", era_g = 1,            mode_con_c = 1, mode_con_g = 1, },
		{ mapluafile = "spa6%s_%s",            era_c = 1, mode_assault_c = 1, mode_1flag_c = 1, },
		{ mapluafile = "spa7%s_%s",            era_c = 1, mode_assault_c = 1, mode_1flag_c = 1, },
		{ mapluafile = "spa8%s_%s", era_g = 1,            mode_assault_g = 1, mode_1flag_g = 1,},
		{ mapluafile = "spa9%s_%s", era_g = 1,            mode_assault_g = 1, mode_1flag_g = 1,},
		{ mapluafile = "tan1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,},
		{ mapluafile = "tat2%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1, mode_hunt_g = 1, mode_eli_g = 1,},
		{ mapluafile = "tat3%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,},
		{ mapluafile = "uta1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,},
		{ mapluafile = "yav1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,},
		{ mapluafile = "yav2%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,  mode_eli_g = 1,},
		--{ isModLevel = 1, mapluafile = "ABC%s_%s", era_g = 1, era_c = 1, mode_con_g = 1, mode_con_c  = 1,},
		--{ mapluafile = "kor1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, },
		--{ mapluafile = "sal1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, },
		--{ mapluafile = "spa3%s_%s", era_g = 1,            mode_con_c = 1, mode_con_g = 1, },
		--{ mapluafile = "spa4%s_%s", era_g = 1,            mode_con_c = 1, mode_con_g = 1, },
	}
	mp_missionselect_listbox_contents = sp_missionselect_listbox_contents
	
	-- *****************  \/ Any necessary 'ReadDataFile' calls needed by the mods \/ ************************************
	ReadDataFile("ABC\\core.lvl")
	
	
	
	-- *****************  /\ Any necessary 'ReadDataFile' calls needed by the mods /\ ************************************
