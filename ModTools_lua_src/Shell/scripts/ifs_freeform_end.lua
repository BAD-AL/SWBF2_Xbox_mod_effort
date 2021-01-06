--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_freeform_end = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,
	
	message = NewIFContainer{
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.5,
		
		image = NewIFImage { 
			texture = "ig_victory_defeat", 
			localpos_l = -128,
			localpos_t = -64,
			localpos_r = 128,
			localpos_b = 0,
			inert = 1,
		},
		
		text = NewIFText {
			font = "gamefont_large",
			y = 0,
			ColorR = 255, ColorG = 255, ColorB = 255,
			textw = 300,
			texth = 100,
			halign = "hcenter",
			valign = "top",
			nocreatebackground = 1,
			flashy = 0,
			inert = 1,
		},
	},
			
	Enter = function(this)
		gIFShellScreenTemplate_fnEnter(this, bFwd)
		
		-- switch teams if on the AI's turn
		if not ifs_freeform_main.joystick and ifs_freeform_main.joystick_other then
			ifs_freeform_main:SetActiveTeam(3 - ifs_freeform_main.playerTeam)
		end
		
		-- if the active player won...
		if ifs_freeform_main.teamVictory == ifs_freeform_main.playerTeam then
			-- show the victory display
			IFImage_fnSetUVs(this.message.image, 0, 0, 1, 0.5)
		else
			-- show the defeat display
			IFImage_fnSetUVs(this.message.image, 0, 0.5, 1, 1)
		end
		
		-- set the appropriate color
		IFObj_fnSetColor(this.message.image, ifs_freeform_main:GetTeamColor(ifs_freeform_main.teamVictory))
		
		-- set the message text
		local sideVictory = ifs_freeform_main.teamCode[ifs_freeform_main.teamVictory]
		IFText_fnSetString(this.message.text, "ifs.freeform.victory." .. sideVictory)
		
		-- set alpha to zero
		IFObj_fnSetVis(this.message, true)
		IFObj_fnSetAlpha(this.message.image, 0)
		IFObj_fnSetAlpha(this.message.text, 0)
		
		-- play a movie
		gMovieAlwaysPlay = 1
		ScriptCB_CloseMovie()
		ScriptCB_OpenMovie(gMovieStream, "")
		ifelem_shellscreen_fnStartMovie("gcwin" .. sideVictory .. "1", 0, nil, 1)
		if ScriptCB_IsMoviePlaying() then
			this.moviePlaying = true
			ScriptCB_EnableScene(false)
			ScriptCB_SetShellMusic()
			ScriptCB_SndBusFade("shellfx", 0.0, 0.0)
			StopAudioStream(gVoiceOverStream, 0)
			StopAudioStream(gMusicStream, 0)
		else
			this.moviePlaying = false
		end
		
		-- display timer
		this.displayTimer = 0
	end,
	
	Exit = function(this)
--		gIFShellScreenTemplate_fnExit(this)
		gMovieAlwaysPlay = nil
	end,
	
	Update = function(this, fDt)
		if this.moviePlaying and not ScriptCB_IsMoviePlaying() then
			this:Input_Accept()
		else
			ScriptCB_EnableCursor(nil) -- PC needs to kill the cursor - BF2 bug 6363 NM 9/27/05            
		end
		
		-- update fade
		this.displayTimer = this.displayTimer + fDt
		local alpha
		if this.displayTimer < 2 then
			alpha = this.displayTimer * 0.5
		elseif this.displayTimer < 6 then
			alpha = 1
		elseif this.displayTimer < 8 then
			alpha = (8 - this.displayTimer) * 0.5
		else
			alpha = 0
		end
		if alpha > 0 then
			IFObj_fnSetAlpha(this.message.image, alpha)
			IFObj_fnSetAlpha(this.message.text, alpha)
		else
			IFObj_fnSetVis(this.message, false)
		end
	end,
	
	Done = function(this)
		-- reset everything (like quit)
		if this.moviePlaying then
			ScriptCB_StopMovie()
			ScriptCB_SndBusFade("shellfx", 0.0, 1.0)
		end
		gMovieAlwaysPlay = nil
		ScriptCB_ClearMetagameState()
		ScriptCB_ClearCampaignState()
		ScriptCB_ClearMissionSetup();
		SetState("shell")
	end,
	
	Input_Accept = function(this)
		this:Done()
	end,
	
	Input_Back = function(this)
	end,
	
	Input_Misc = function(this)
		this:Done()
	end,
}

AddIFScreen(ifs_freeform_end,"ifs_freeform_end")
