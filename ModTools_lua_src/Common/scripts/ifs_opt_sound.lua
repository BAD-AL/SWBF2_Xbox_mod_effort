--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Helper function, sets text of

local output_modelist_content = {
	{ string = "ifs.soundopt.outputmode.mono", }, 
	{ string = "ifs.soundopt.outputmode.headphones", }, 
	{ string = "ifs.soundopt.outputmode.stereo", }, 
--	{ string = "ifs.soundopt.outputmode.dolby", }, 
	{ string = "ifs.soundopt.outputmode.surround", }, 
	{ string = "ifs.soundopt.outputmode.4point0", }, 
	{ string = "ifs.soundopt.outputmode.5point1", }, 
	{ string = "ifs.soundopt.outputmode.7point1", }, 
}

local mixerlist_content_hw = {
	{ string = "ifs.soundopt.mixconfig.software", }, 
	{ string = "ifs.soundopt.mixconfig.hardware", }, 
	{ string = "ifs.soundopt.mixconfig.disabled", }, 
}

local mixerlist_content_nohw = {
	{ string = "ifs.soundopt.mixconfig.software", }, 
	{ string = "ifs.soundopt.mixconfig.disabled", }, 
}

----------------------------------------------------------------------------------------
-- save the profile in slot 1
----------------------------------------------------------------------------------------

function ifs_opt_sound_StartSaveProfile()
	--  print("ifs_opt_top_StartSaveProfile")
	
	ifs_saveop.doOp = "SaveProfile"
	ifs_saveop.OnSuccess = ifs_opt_sound_SaveProfileSuccess
	ifs_saveop.OnCancel = ifs_opt_sound_SaveProfileCancel
	local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
	ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
	ifs_saveop.saveProfileNum = iProfileIdx
	ifs_movietrans_PushScreen(ifs_saveop)
end

function ifs_opt_sound_SaveProfileSuccess()
	--  print("ifs_opt_top_SaveProfileSuccess")
	local this = ifs_opt_sound
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()

	-- Replace current screen with next screen from tabs
	if(this.NextScreen ~= -1) then
		ScriptCB_SetIFScreen(this.NextScreen)
	else
		this:Input_Back(1)
	end
	this.NextScreen = nil
end

function ifs_opt_sound_SaveProfileCancel()
	--  print("ifs_opt_top_SaveProfileCancel")
	local this = ifs_opt_sound
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()

	-- Replace current screen with next screen from tabs
	if(this.NextScreen ~= -1) then
		ScriptCB_SetIFScreen(this.NextScreen)
	else
		this:Input_Back(1)
	end
	this.NextScreen = nil
end
    
function ModeList_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local tinyH=ScriptCB_GetFontHeight("gamefont_tiny")
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y=layout.y,
	}

	local YPos = layout.height * -0.5 + 3
	Temp.text = NewIFText {
		x = 10, y = YPos,
		textw = layout.width - 20, texth = layout.height,
		halign = "left", font = "gamefont_tiny", nocreatebackground=1,
	}

	return Temp
end

function ModeList_PopulateItem(Dest,Data)
	if (Data) then
		IFText_fnSetString(Dest.text,Data.string)
		IFObj_fnSetVis(Dest.text,1)
	else
		IFObj_fnSetVis(Dest.text,nil)
	end
end

outputmodelist_layout = {
	showcount = 7,
	width = 240,
	totalheight = 120,
	yHeight = 15,
	ySpacing = 2,
	x = 0,
	y = -5,
	slider = nil, -- not with 3 items
	CreateFn = ModeList_CreateItem,
	PopulateFn = ModeList_PopulateItem,
}

mixerlist_layout = {
	showcount = 3,
	width = 240,
	totalheight = 50,
	yHeight = 15,
	ySpacing = 2,
	x = 0,
	y = -5,
	slider = nil, -- not with 3 items
	CreateFn = ModeList_CreateItem,
	PopulateFn = ModeList_PopulateItem,
}

function ifs_opt_sound_fnAddOutputMode(this)

	local offset_x = 85
	local offset_y = 230
	-- dropdown box
	this.res_dropdown_btn = NewPCDropDownButton {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0,
		x = offset_x,
		y = offset_y,
		btnw = ifs_opt_sound_getBarSize(this), -- made wider to fix 9173 - NM 8/25/04
		btnh = 20,
		font = "gamefont_medium",
		tag = "_mode_btn",
		string = "",
	}
	
	-- source listbox
	this.modelist_listbox = NewButtonWindow { 
		ZPos = 100, 
		x = offset_x, 
		y = offset_y + outputmodelist_layout.totalheight / 2 + 15,
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0,
		bg_texture = "border_dropdown",
		width = ifs_opt_sound_getBarSize(this), --outputmodelist_layout.width,
		height = outputmodelist_layout.totalheight + 10,
	}
	ListManager_fnInitList(this.modelist_listbox,outputmodelist_layout)
	ListManager_fnFillContents(this.modelist_listbox,output_modelist_content,outputmodelist_layout)


	local offset_x1 = 85
	local offset_y1 = 300
	-- dropdown box
	this.mixer_dropdown_btn = NewPCDropDownButton {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0,
		x = offset_x1,
		y = offset_y1,
		btnw = ifs_opt_sound_getBarSize(this), -- made wider to fix 9173 - NM 8/25/04
		btnh = 20,
		font = "gamefont_medium",
		tag = "_mixer_btn",
		string = "",
	}
	
	-- source listbox
	this.mixerlist_listbox = NewButtonWindow { 
		ZPos = 100, 
		x = offset_x1, 
		y = offset_y1 + mixerlist_layout.totalheight / 2 + 15,
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0,
		bg_texture = "border_dropdown",
		width = ifs_opt_sound_getBarSize(this), --mixerlist_layout.width,
		height = mixerlist_layout.totalheight + 10,
	}
	ListManager_fnInitList(this.mixerlist_listbox,mixerlist_layout)

	local hweffects, hwmixing = ScriptCB_HWSupport()
	local mixerlist_content
	if ( hwmixing ) then
	   mixerlist_content = mixerlist_content_hw
	else
	   mixerlist_content = mixerlist_content_nohw
	end

	ListManager_fnFillContents(this.mixerlist_listbox,mixerlist_content,mixerlist_layout)	
end

function ifs_opt_sound_fnShowDropbox( this, enable )	
	IFObj_fnSetVis(this.modelist_listbox, enable)
	this.bModeDropBoxesOpen = enable
end

function ifs_opt_sound_fnShowMixerDropbox( this, enable )	
	IFObj_fnSetVis(this.mixerlist_listbox, enable)
	this.bMixerDropBoxesOpen = enable
end

function ifs_opt_sound_fnClickModeButtons( this )
	--print( "this.bSourceDropBoxesOpen =", this.bSourceDropBoxesOpen )
	--print( "this.CurButton =", this.CurButton )
	
	if( this.bModeDropBoxesOpen ) then
		--print( "gMouseListBox =", gMouseListBox )
		--print( "this.source_listbox =", this.source_listbox )
		if( gMouseListBox == this.modelist_listbox ) then
			if( gMouseListBox.Layout.CursorIdx ) then
				ScriptCB_SetOutputMode( gMouseListBox.Layout.CursorIdx )
			end
			gMouseListBox.Layout.SelectedIdx = gMouseListBox.Layout.CursorIdx
			print( "gMouseListBox.Layout.CursorIdx = ", gMouseListBox.Layout.CursorIdx )			
		end
		ifs_opt_sound_fnShowDropbox( this, nil )
		IFObj_fnSetVis(this.mixer_dropdown_btn, 1)
	elseif( this.bMixerDropBoxesOpen ) then
		if( gMouseListBox == this.mixerlist_listbox ) then
			if( gMouseListBox.Layout.CursorIdx ) then
				ScriptCB_SetMixConfig( gMouseListBox.Layout.CursorIdx )
			end
			gMouseListBox.Layout.SelectedIdx = gMouseListBox.Layout.CursorIdx
			print( "111gMouseListBox.Layout.CursorIdx = ", gMouseListBox.Layout.CursorIdx )			
		end
		ifs_opt_sound_fnShowMixerDropbox( this, nil )	
		IFObj_fnSetVis(this.res_dropdown_btn, 1)
	else
		-- open the drop box
		if( this.CurButton == "_mode_btn" ) then
			ifs_opt_sound_fnShowDropbox( this, 1 )
			IFObj_fnSetVis(this.mixer_dropdown_btn, nil)
		elseif( this.CurButton == "_mixer_btn" ) then
			ifs_opt_sound_fnShowMixerDropbox( this, 1 )
		end
	end
end


function ifs_opt_sound_fnUpdateSliders(this)

    --  print("curbutton=",this.CurButton )
    local VolMusic, VolSfx, VolVoice, VolBattleVoice, MaxVol, VolMaster = ScriptCB_GetVolumes()

    this.sliders.master.thumbposn = (VolMaster / MaxVol)
    HSlider_MoveThumb(this.sliders.master)
    this.sliders.music.thumbposn = (VolMusic / MaxVol)
    HSlider_MoveThumb(this.sliders.music)
    this.sliders.sfx.thumbposn = (VolSfx / MaxVol)
    HSlider_MoveThumb(this.sliders.sfx)
    this.sliders.voice.thumbposn = (VolVoice / MaxVol)
    HSlider_MoveThumb(this.sliders.voice)
    this.sliders.battlevoice.thumbposn = (VolBattleVoice / MaxVol)
    HSlider_MoveThumb(this.sliders.battlevoice)

    if(MaxVol == 10) then
        -- #%)(#%( rounding errors on PS2. This is a shortcut that seems to work
        -- better than divide by 10, multiply by 100
        RoundIFButtonLabel_fnSetUString(this.buttons.master, ScriptCB_tounicode(string.format("%d%%",VolMaster * 10)))
        RoundIFButtonLabel_fnSetUString(this.buttons.music, ScriptCB_tounicode(string.format("%d%%",VolMusic * 10)))
        RoundIFButtonLabel_fnSetUString(this.buttons.sfx,   ScriptCB_tounicode(string.format("%d%%",VolSfx * 10)))
        RoundIFButtonLabel_fnSetUString(this.buttons.voice, ScriptCB_tounicode(string.format("%d%%",VolVoice * 10)))
        RoundIFButtonLabel_fnSetUString(this.buttons.battlevoice, ScriptCB_tounicode(string.format("%d%%",VolBattleVoice * 10)))
    else
        RoundIFButtonLabel_fnSetUString(this.buttons.master, ScriptCB_tounicode(string.format("%d%%",(VolMaster / MaxVol) * 100)))
        RoundIFButtonLabel_fnSetUString(this.buttons.music, ScriptCB_tounicode(string.format("%d%%",VolMusic / MaxVol * 100)))
        RoundIFButtonLabel_fnSetUString(this.buttons.sfx,   ScriptCB_tounicode(string.format("%d%%",VolSfx / MaxVol * 100)))
        RoundIFButtonLabel_fnSetUString(this.buttons.voice, ScriptCB_tounicode(string.format("%d%%",VolVoice / MaxVol * 100)))
        RoundIFButtonLabel_fnSetUString(this.buttons.battlevoice, ScriptCB_tounicode(string.format("%d%%",VolBattleVoice / MaxVol * 100)))
    end

	if(gPlatformStr == "PC") and this.bShellMode then
		IFObj_fnSetVis(this.cancelbutton, ScriptCB_HasProfileChanged())
	end
end

function ifs_opt_sound_fnUpdateRadios(this)
    if (ScriptCB_EffectsEnabled()) then
		ifelem_SelectRadioButton(this.radiobuttons.effects, 2, true)
    else
		ifelem_SelectRadioButton(this.radiobuttons.effects, 1, true)
    end
    
    if (ScriptCB_GetBassManagement()) then
		ifelem_SelectRadioButton(this.radiobuttons.bassmang, 2, true)
    else
		ifelem_SelectRadioButton(this.radiobuttons.bassmang, 1, true)
    end
end

function ifs_opt_sound_fnIsASlider(button)  
    return (button == "master" or 
            button == "music"  or 
            button == "sfx"    or
            button == "voice"  or 
            button == "battlevoice")
end

function ifs_opt_sound_getBarSize(this)
    -- Ask game for screen size, used to make sliders
    local w
    local h
    w,h = ScriptCB_GetSafeScreenInfo()

    this.sliders.ScreenRelativeX = this.buttonlabels.ScreenRelativeX

    local SizeOfBar = 0.75 - this.buttonlabels.ScreenRelativeX

    return w * SizeOfBar
end

function ifs_opt_sound_updateLogo(this)
    if (gPlatformStr == "PC") then
        local shellActive = ScriptCB_GetShellActive()    
        if (shellActive) then
            local EAXversion  = ScriptCB_GetEAXVersion()
            
            -- display eax logo
            if (EAXversion < 3) then
                IFImage_fnSetTexture(this.soundlogo, "eax_logo")
            else
                IFImage_fnSetTexture(this.soundlogo, "eaxhd_logo")
            end
            
            -- if EAX is enabled 
            if (EAXversion > 0) then 
                IFObj_fnSetAlpha(this.soundlogo, 1)   -- bright
                
                if (EAXversion >= 3) then
                    IFObj_fnSetAlpha(this.logoInfos.envmorphing, 1)
                    --IFObj_fnSetAlpha(this.logoInfos.envpanning,  1)
                    -- don't support environmental panning
                    IFObj_fnSetVis(this.logoInfos.envpanning,  nil)
                end
                
                if (EAXversion >= 2) then
                    IFObj_fnSetAlpha(this.logoInfos.occulsion,   1)
                end
                
                if (EAXversion >= 1) then
                    IFObj_fnSetAlpha(this.logoInfos.reverb,      1)
                end
                
            else
                IFObj_fnSetAlpha(this.soundlogo, 0.3) -- dim
                
                IFObj_fnSetAlpha(this.logoInfos.envmorphing, 0.3)
                --IFObj_fnSetAlpha(this.logoInfos.envpanning,  0.3)
                -- don't support environmental panning
                IFObj_fnSetVis(this.logoInfos.envpanning,  nil)
                IFObj_fnSetAlpha(this.logoInfos.occulsion,   0.3)
                IFObj_fnSetAlpha(this.logoInfos.reverb,      0.3)
            end
        else
            IFObj_fnSetVis(this.soundlogo,             nil)
            IFObj_fnSetVis(this.logoInfos.envmorphing, nil)
            IFObj_fnSetVis(this.logoInfos.envpanning,  nil)
            IFObj_fnSetVis(this.logoInfos.occulsion,   nil)
            IFObj_fnSetVis(this.logoInfos.reverb,      nil)
        end
    else
        IFObj_fnSetVis(this.soundlogo, nil)
    end
end

function ifs_opt_sound_closeShellSound(this)
    -- movie player depends upon the sound engine
    ScriptCB_CloseMovie()
end

function ifs_opt_sound_restoreShellSound(bgMovie)
    -- read sound data
    ReadDataFileInGame("sound\\shell.lvl")

    -- open voice over stream
    gVoiceOverStream = OpenAudioStream("sound\\shell.lvl", "shell_vo")
    -- open music stream
    gMusicStream     = OpenAudioStream("sound\\shell.lvl", "shell_music")
    
    -- open movie stream    
    ScriptCB_OpenMovie(gMovieStream, "")
    ScriptCB_SetMovieAudioBus("shellmovies")
    
    -- set playback interval to 0
    ScriptCB_SetShellMusicInterval()
    
    -- restart background movie 
    if (bgMovie) then
        ifelem_shellscreen_fnStartMovie(bgMovie, 0, nil, 1)
    end
end

-- Updates buttons, hilighlights, etc. To be called when something changes.
function ifs_opt_sound_fnUpdateButtons(this)
    local OutputMode = ScriptCB_GetOutputMode()
    local MixConfig  = ScriptCB_GetMixConfig()
    
    -- setup the other text
    -- see enum SpeakerConfig in sndenginebase.h for values
    if (OutputMode == 1) then
        RoundIFButtonLabel_fnSetString(this.buttons.output, "ifs.soundopt.outputmode.mono")
    elseif (OutputMode == 2) then
        RoundIFButtonLabel_fnSetString(this.buttons.output, "ifs.soundopt.outputmode.headphones")
    elseif (OutputMode == 3) then
        RoundIFButtonLabel_fnSetString(this.buttons.output, "ifs.soundopt.outputmode.stereo")
    elseif (OutputMode == 4) then
        if (MixConfig == 1 or gPlatformStr == "PS2") then
            RoundIFButtonLabel_fnSetString(this.buttons.output, "ifs.soundopt.outputmode.dolby")
        else
            RoundIFButtonLabel_fnSetString(this.buttons.output, "ifs.soundopt.outputmode.surround")
        end
    elseif (OutputMode == 5) then
        RoundIFButtonLabel_fnSetString(this.buttons.output, "ifs.soundopt.outputmode.4point0")
    elseif (OutputMode == 6) then
        RoundIFButtonLabel_fnSetString(this.buttons.output, "ifs.soundopt.outputmode.5point1")
    elseif (OutputMode == 7) then
        RoundIFButtonLabel_fnSetString(this.buttons.output, "ifs.soundopt.outputmode.7point1")
    end

	-- set output mode string
	if( OutputMode > 0 and ScriptCB_GetShellActive() ) then
		RoundIFButtonLabel_fnSetString( this.res_dropdown_btn, output_modelist_content[OutputMode].string )		
		if( outputmodelist_layout.SelectedIdx ~= OutputMode ) then
			--print("outputmodelist_layout.SelectedIdx =  ", OutputMode)
			outputmodelist_layout.SelectedIdx = OutputMode
			outputmodelist_layout.CursorIdx = OutputMode
			ListManager_fnMoveCursor(this.modelist_listbox, outputmodelist_layout)
		end
	end	
    
    -- highlight / dim bass management option
    if ((MixConfig == 2) and (OutputMode >= 6)) then
        IFObj_fnSetAlpha(this.buttons.bassmang.label, 1.0)
        IFObj_fnSetAlpha(this.radiobuttons.bassmang[1].radiotext, 1.0)
        IFObj_fnSetAlpha(this.radiobuttons.bassmang[2].radiotext, 1.0)
        this.buttons.bassmang.hidden = nil
    else
        IFObj_fnSetAlpha(this.buttons.bassmang.label, 0.5)
        IFObj_fnSetAlpha(this.radiobuttons.bassmang[1].radiotext, 0.5)
        IFObj_fnSetAlpha(this.radiobuttons.bassmang[2].radiotext, 0.5)
        this.buttons.bassmang.hidden = 1
    end
    
    -- highlight / dim effects depending on support
    local hweffects, hwmixing = ScriptCB_HWSupport()
    if ( (MixConfig == 2 and hweffects) or MixConfig == 1 ) then
        IFObj_fnSetAlpha(this.buttons.effects.label, 1.0)
        IFObj_fnSetAlpha(this.radiobuttons.effects[1].radiotext, 1.0)
        IFObj_fnSetAlpha(this.radiobuttons.effects[2].radiotext, 1.0)
        this.buttons.effects.hidden = nil
    else
        IFObj_fnSetAlpha(this.buttons.effects.label, 0.5)
        IFObj_fnSetAlpha(this.radiobuttons.effects[1].radiotext, 0.5)
        IFObj_fnSetAlpha(this.radiobuttons.effects[2].radiotext, 0.5)
        this.buttons.effects.hidden = 1
    end
    
    -- highlight / dim mixing configuration depending on support
    if (hwmixing) then
        IFObj_fnSetAlpha(this.buttons.mixconfig.label, 1.0)
        this.buttons.mixconfig.hidden = nil
    else
        IFObj_fnSetAlpha(this.buttons.mixconfig.label, 0.5)
        this.buttons.mixconfig.hidden = 1
    end

    -- see enum MixConfig in win/sndengine.h for values
    if (MixConfig == 1 or MixConfig == 3) then
        RoundIFButtonLabel_fnSetString(this.buttons.mixconfig, "ifs.soundopt.mixconfig.software")
        if( ScriptCB_GetShellActive() ) then
			RoundIFButtonLabel_fnSetString( this.mixer_dropdown_btn, "ifs.soundopt.mixconfig.software" )
			mixerlist_layout.SelectedIdx = 1
			mixerlist_layout.CursorIdx = 1
			ListManager_fnMoveCursor(this.mixerlist_listbox, mixerlist_layout)
        end
    elseif (MixConfig == 2) then
        RoundIFButtonLabel_fnSetString(this.buttons.mixconfig, "ifs.soundopt.mixconfig.hardware")
        if( ScriptCB_GetShellActive() ) then
			RoundIFButtonLabel_fnSetString( this.mixer_dropdown_btn, "ifs.soundopt.mixconfig.hardware" )
			mixerlist_layout.SelectedIdx = 2
			mixerlist_layout.CursorIdx = 2
			ListManager_fnMoveCursor(this.mixerlist_listbox, mixerlist_layout)
        end
    elseif (MixConfig == 4) then
        RoundIFButtonLabel_fnSetString(this.buttons.mixconfig, "ifs.soundopt.mixconfig.disabled")
        if( ScriptCB_GetShellActive() ) then
			RoundIFButtonLabel_fnSetString( this.mixer_dropdown_btn, "ifs.soundopt.mixconfig.disabled" )
			mixerlist_layout.SelectedIdx = 3
			mixerlist_layout.CursorIdx = 3
			ListManager_fnMoveCursor(this.mixerlist_listbox, mixerlist_layout)
        end
    end

    if (ScriptCB_EffectsEnabled()) then
        RoundIFButtonLabel_fnSetString(this.buttons.effects, "ifs.soundopt.effects.on")
    else
        RoundIFButtonLabel_fnSetString(this.buttons.effects, "ifs.soundopt.effects.off")
    end
    
    if (ScriptCB_GetBassManagement()) then
        RoundIFButtonLabel_fnSetString(this.buttons.bassmang, "ifs.soundopt.effects.on")
    else
        RoundIFButtonLabel_fnSetString(this.buttons.bassmang, "ifs.soundopt.effects.off")
    end

    ifs_opt_sound_updateLogo(this)

	if(gPlatformStr == "PC") and this.bShellMode then
		IFObj_fnSetVis(this.cancelbutton, ScriptCB_HasProfileChanged())
	end
end

-- Left (button/trigger) pressed. Update things. iAmount will be 1 if dpad
-- left, 10 if trigger
function ifs_opt_sound_fnLeft(this, iAmount)
    local VolMusic, VolSfx, VolVoice, VolBattleVoice, MaxVol, VolMaster = ScriptCB_GetVolumes()

    if (this.CurButton == "master") then
        VolMaster = math.max(VolMaster - iAmount, 0)
        elseif(this.CurButton == "music") then
        VolMusic = math.max(VolMusic - iAmount, 0)
    elseif (this.CurButton == "sfx") then
        VolSfx = math.max(VolSfx - iAmount, 0)
    elseif (this.CurButton == "voice") then
        VolVoice = math.max(VolVoice - iAmount, 0)
    elseif (this.CurButton == "battlevoice") then
        VolBattleVoice = math.max(VolBattleVoice - iAmount, 0)
    elseif (this.CurButton == "mixconfig") then
        ifelm_shellscreen_fnPlaySound(this.acceptSound)
        ScriptCB_PreviousMixConfig()
    elseif (this.CurButton == "output") then
        ifelm_shellscreen_fnPlaySound(this.acceptSound)
        ScriptCB_PreviousOutputMode()
    elseif (this.CurButton == "effects") then 
        ifelm_shellscreen_fnPlaySound(this.acceptSound)
        ScriptCB_ToggleEffects()
    end
    
    if (ScriptCB_GetMixConfigChanged()) then
        ifs_opt_sound_closeShellSound() 
        ifs_opt_sound_restoreShellSound(ifs_opt_top.movieBackground)
    end

    -- update bus gains     
    ScriptCB_SetVolumes(VolMusic, VolSfx, VolVoice, VolBattleVoice, VolMaster)
    
    -- play audition SFX / voice
    if (this.CurButton == "master") then
        ScriptCB_ShellPlayDelayedStream("shell_auditionSFX", 0, 0.0, "Root", 0)
    elseif (this.CurButton == "sfx") then
        ScriptCB_ShellPlayDelayedStream("shell_auditionSFX", 0, 0.0, "soundfx", 0)
    elseif (this.CurButton == "voice") then
        ScriptCB_ShellPlayDelayedStream("shell_auditionVO",  0, 0.0, "voiceover", 0)
    elseif (this.CurButton == "battlevoice") then
        ScriptCB_ShellPlayDelayedStream("shell_auditionVO",  0, 0.0, "battlechatter", 0)
    end
    
    if (this.CurButton == "bassmang") then
        if (ScriptCB_GetBassManagement()) then
            ScriptCB_SetBassManagement(nil)
        else
            ScriptCB_SetBassManagement(1)
        end
    end
    
    ifs_opt_sound_fnUpdateButtons(this)
    ifs_opt_sound_fnUpdateSliders(this)
end

-- Right (button/trigger) pressed. Update things. iAmount will be 1 if dpad
-- right, 10 if trigger
function ifs_opt_sound_fnRight(this, iAmount)
    local VolMusic, VolSfx, VolVoice, VolBattleVoice, MaxVol, VolMaster = ScriptCB_GetVolumes()

    if (this.CurButton == "master") then
        VolMaster = math.min(VolMaster + iAmount, MaxVol)
        elseif(this.CurButton == "music") then
        VolMusic = math.min(VolMusic + iAmount, MaxVol)
    elseif (this.CurButton == "sfx") then
        VolSfx = math.min(VolSfx + iAmount, MaxVol)
    elseif (this.CurButton == "voice") then
        VolVoice = math.min(VolVoice + iAmount, MaxVol)
    elseif (this.CurButton == "battlevoice") then
        VolBattleVoice = math.min(VolBattleVoice + iAmount, MaxVol)
    elseif (this.CurButton == "output") then
        ifelm_shellscreen_fnPlaySound(this.acceptSound)
        ScriptCB_NextOutputMode()
    elseif (this.CurButton == "mixconfig") then
        ifelm_shellscreen_fnPlaySound(this.acceptSound)
        ScriptCB_NextMixConfig()
    elseif (this.CurButton == "effects") then
        ifelm_shellscreen_fnPlaySound(this.acceptSound)
        ScriptCB_ToggleEffects()
    end
    
    if (ScriptCB_GetMixConfigChanged()) then
        ifs_opt_sound_closeShellSound() 
        ifs_opt_sound_restoreShellSound(ifs_opt_top.movieBackground)
    end
    
    -- update bus gains     
    ScriptCB_SetVolumes(VolMusic, VolSfx, VolVoice, VolBattleVoice, VolMaster)
    
    -- play audition SFX / voice
    if (this.CurButton == "master") then
        ScriptCB_ShellPlayDelayedStream("shell_auditionSFX", 0, 0.0, "Root", 0)
    elseif (this.CurButton == "sfx") then
        ScriptCB_ShellPlayDelayedStream("shell_auditionSFX", 0, 0.0, "soundfx", 0)
    elseif (this.CurButton == "voice") then
        ScriptCB_ShellPlayDelayedStream("shell_auditionVO",  0, 0.0, "voiceover", 0)
    elseif (this.CurButton == "battlevoice") then
        ScriptCB_ShellPlayDelayedStream("shell_auditionVO",  0, 0.0, "battlechatter", 0)
    end
    
    if (this.CurButton == "bassmang") then
        if (ScriptCB_GetBassManagement()) then
            ScriptCB_SetBassManagement(nil)
        else
            ScriptCB_SetBassManagement(1)
        end
    end

    ifs_opt_sound_fnUpdateButtons(this)
    ifs_opt_sound_fnUpdateSliders(this)
end

-- Callback for when the "reset to defaults?" popup is over.  If
-- bResult is true, user wanted to reset them
function ifs_opt_sound_fnAskedResetDone(bResult)
    local this = ifs_opt_sound

    -- Re-show UI
    IFObj_fnSetVis(this.buttons, 1)
    IFObj_fnSetVis(this.buttonlabels, 1)
    IFObj_fnSetVis(this.sliders, 1)

    if(bResult) then
        ScriptCB_ResetSoundToDefault()
        ifs_opt_sound_fnUpdateButtons(this)
        ifs_opt_sound_fnUpdateSliders(this)
    end
end

local image_background = nil
local dim_backdrop = 1
if( 1 ) then
--if( gPCBetaBuild ) then
	if( ScriptCB_GetShellActive() ) then
		--print("set background iface_bg_1")
		image_background = "iface_bg_1"
		dim_backdrop = nil
	end
end

ifs_opt_sound = NewIFShellScreen {
    nologo = 1,
    movieIntro      = nil, -- played before the screen is displayed
    movieBackground = nil, -- played while the screen is displayed
    bNohelptext_backPC = 1,
    bDimBackdrop = dim_backdrop,
	bg_texture = image_background,

    -- Note: this ScreenRelativeX is used to determine the size of
    -- the sliders
    buttonlabels = NewIFContainer {
        ScreenRelativeX = 0.4, -- right-justified to this
        ScreenRelativeY = 0,
    },

    buttons = NewIFContainer {
        ScreenRelativeX = 1, -- text right-justified within this
        ScreenRelativeY = 0,
    },
    
    radiobuttons = NewIFContainer {
		ScreenRelativeX = 0.4,
		ScreenRelativeY = 0,
		y = -3,
    },

    sliders = NewIFContainer {
        --      ScreenRelativeX = 0.4, -- auto-copied from buttonlabels
        ScreenRelativeY = 0,
    },
    
    soundlogo = NewIFImage {
        -- IFObj
        ScreenRelativeX = 0.2,
        ScreenRelativeY = 0.72,
        UseSafezone     = 0,
        
        -- IFImage 
        localpos_l      = 0,
        localpos_t      = 0,
        localpos_r      = 212,
        localpos_b      = 66,
    },
    
    logoInfos = NewIFContainer {
        font = "gamefont_small",
        ScreenRelativeX = 0.5,
        ScreenRelativeY = 0.70
    },

    bNohelptext_accept = 1, -- we have our own, renamed version

    -- When entering this screen, check if we need to save (triggered
    -- by a subscreen or something). If so, start that process.
    Enter = function(this, bFwd)
        ScriptCB_MarkCurrentProfile()
        this.bResetProfile = nil
        
		if(gPlatformStr == "PC") then
			-- use shell mode?
			this.bShellMode = 
				ScriptCB_GetShellActive() and 
				ScriptCB_GetGameRules() ~= "metagame" and 
				ScriptCB_GetGameRules() ~= "campaign"
				
			-- if in the shell...
			if( this.bShellMode ) then
				-- hide done and cancel buttons
				IFObj_fnSetVis(this.donebutton, 1)
				IFObj_fnSetVis(this.cancelbutton, false)
				
				-- show options and sound tabs
				ifs_main.option_mp = nil		-- set to option			
				ifelem_tabmanager_SetSelected(this, gPCMainTabsLayout, "_tab_options")
				ifelem_tabmanager_SetSelected(this, gPCOptionsTabsLayout, "_tab_sound", 1)
				
				-- set pc profile & title version text
				UpdatePCTitleText(this)
			else
				-- show done and cancel buttons
				IFObj_fnSetVis(this.donebutton, true)
				IFObj_fnSetVis(this.cancelbutton, true)
				
				-- show sound tabs
                ifelem_tabmanager_SelectTabGroup(this, nil, 1, nil)
                ifelem_tabmanager_SetSelected(this, gPCOptionsTabsLayout, "_tab_sound", 1)
                
                -- hide PC profile & title version text
                HidePCTitleText(this)
			end
			
			-- dim tabs for PC Demo
			ifs_DimTabsPCDemo(this)
        else
--            gHelptext_fnMoveIcon(this.Helptext_Reset)
        end

        -- set label visibility 
        local shellActive = ScriptCB_GetShellActive()
        local isPC        = (gPlatformStr == "PC")

        this.buttonlabels.output.hidden    = (gPlatformStr == "XBox") or (isPC and not shellActive)
        this.buttonlabels.mixconfig.hidden = not isPC or not shellActive
        this.buttonlabels.effects.hidden   = not isPC or not shellActive
        this.buttonlabels.reset.hidden     = not isPC --or not shellActive

        this.buttonlabels.bassmang.hidden = not isPC
        
        IFObj_fnSetVis(this.buttons.bassmang, nil)
        IFObj_fnSetVis(this.buttons.effects, nil)
        
        -- hide some of the labels
        if (this.buttonlabels.output.hidden) then
            IFObj_fnSetVis(this.buttonlabels.output,    nil)
            IFObj_fnSetVis(this.buttons.output,         nil)
        end
        if (this.buttonlabels.mixconfig.hidden) then
            IFObj_fnSetVis(this.buttonlabels.mixconfig, nil)
            IFObj_fnSetVis(this.buttons.mixconfig,      nil)
        end
        if (this.buttonlabels.effects.hidden) then
            IFObj_fnSetVis(this.buttonlabels.effects,   nil)
            IFObj_fnSetVis(this.buttons.effects,        nil)
	        IFObj_fnSetVis(this.radiobuttons.effects,   nil)
        end
        if (this.buttonlabels.reset.hidden) then
            IFObj_fnSetVis(this.buttonlabels.reset,     nil)
            IFObj_fnSetVis(this.buttons.reset,          nil)
        end
        if (this.buttonlabels.bassmang.hidden) then
            IFObj_fnSetVis(this.buttonlabels.bassmang,  nil)
            IFObj_fnSetVis(this.buttons.bassmang,       nil)
            IFObj_fnSetVis(this.radiobuttons.bassmang,  nil)
        end
        
        -- use new button for reset
        if(gPlatformStr == "PC") then			
			IFObj_fnSetVis(this.resetbutton,		   ( not this.buttonlabels.reset.hidden ) )			
            IFObj_fnSetVis(this.buttonlabels.reset,     nil)
            IFObj_fnSetVis(this.buttons.reset,          nil)						
	        if( ScriptCB_GetShellActive() ) then
				-- initialize dropdown listbox
				ListManager_fnFillContents(this.modelist_listbox,output_modelist_content,outputmodelist_layout)
				local hweffects, hwmixing = ScriptCB_HWSupport()
				local mixerlist_content
				if ( hwmixing ) then
				   mixerlist_content = mixerlist_content_hw
				else
				   mixerlist_content = mixerlist_content_nohw
				end
				
				ListManager_fnFillContents(this.mixerlist_listbox,mixerlist_content,mixerlist_layout)	
	        
				IFObj_fnSetVis(this.modelist_listbox,   nil)
				IFObj_fnSetVis(this.buttons.output,     nil)
				IFObj_fnSetVis(this.mixerlist_listbox,  nil)
				IFObj_fnSetVis(this.buttons.mixconfig,  nil)
			end        
        end
        
        -- make sure music is constantly playing
        ScriptCB_SetShellMusicInterval(0.0)
        if (not shellActive) then
            -- turn off in game buses
            ScriptCB_SndBusFade("soundfx",       0.0, 0.0);
            ScriptCB_SndBusFade("ambience",      0.0, 0.0);
            ScriptCB_SndBusFade("voiceover",     0.0, 0.0);
            ScriptCB_SndBusFade("battlechatter", 0.0, 0.0);
            -- fade in music bus as we need to hear it for the music slider
            ScriptCB_SndBusFade("ingame_spawnducked",        0.5, 1.0);           
        end

        ifs_opt_sound_updateLogo(this)
        
        if( ScriptCB_GetShellActive() ) then
			ifs_opt_sound_fnShowMixerDropbox(this, false)
			ifs_opt_sound_fnShowDropbox(this, false)
			IFObj_fnSetVis(this.mixer_dropdown_btn, 1)
			IFObj_fnSetVis(this.res_dropdown_btn, 1)
		end

        gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
        AnimationMgr_AddAnimation(this.buttonlabels, {fStartAlpha = 0, fEndAlpha = 1,})
        AnimationMgr_AddAnimation(this.sliders,      {fStartAlpha = 0, fEndAlpha = 1,})
        AnimationMgr_AddAnimation(this.soundlogo,    {fStartAlpha = 0, fEndAlpha = 1,})
        
        ifs_opt_sound_fnUpdateButtons(this)
        ifs_opt_sound_fnUpdateSliders(this)
        ifs_opt_sound_fnUpdateRadios(this)
        -- reset the current button to the first item
        this.CurButton = "master"

    end, -- function Enter()
    
    Exit = function(this, bFwd)
        if( this.bResetProfile ) then
            ScriptCB_ReloadMarkedProfile()
            if (ScriptCB_GetMixConfigChanged()) then
                ifs_opt_sound_closeShellSound() 
                ifs_opt_sound_restoreShellSound(ifs_opt_top.movieBackground)
            end
        end
        if(gCurHiliteButton) then
            IFButton_fnSelect(gCurHiliteButton,nil)
        end

        -- set label visiblity 
        local shellActive = ScriptCB_GetShellActive()
        
        if (not shellActive) then
            -- turn on in game subbuses
            ScriptCB_SndBusFade("soundfx",     1.0, 1.0);
            ScriptCB_SndBusFade("ambience",    1.0, 1.0);
            ScriptCB_SndBusFade("voiceover",   1.0, 1.0);
            ScriptCB_SndBusFade("battlechatter", 1.0, 1.0);
            -- fade out music bus  
            ScriptCB_SndBusFade("ingame_spawnducked",      0.5, 0.0);
        end
        -- reset music play interval
        ScriptCB_SetShellMusicInterval(10.0)
    end,

    Input_Accept = function(this) 
        -- If the tab manager handled this event, then we're done
		if(gPlatformStr == "PC") then
			-- Check tabs to see if we have a hit
			this.NextScreen = ifelem_tabmanager_HandleInputAccept(this, gPCOptionsTabsLayout, 1, 1)
			if(not this.NextScreen) then
				this.NextScreen = ifelem_tabmanager_HandleInputAccept(this, gPCMainTabsLayout, nil, 1)
			end

			-- If nextscreen was handled via a callback, we're done
			if(this.NextScreen == -1) then
				this.NextScreen = nil
				return
			end

			if(this.NextScreen) then
				if(ScriptCB_IsCurProfileDirty()) then
					ifs_opt_sound_StartSaveProfile()
					return
				else
					-- No need to save. Just jump there
					ScriptCB_SetIFScreen(this.NextScreen)
					this.NextScreen = nil
					return
				end
			end -- this.Nextscreen is valid (i.e. clicked on a tab)
		end -- cur platform == PC

		-- Check radio buttons
		if ( ifelem_HandleRadioButtonInputAccept(this) ) then
			return
		end

        local mixConfig = ScriptCB_GetMixConfig()
        local effects   = ScriptCB_EffectsEnabled()   		

        if(this.CurButton == "_back"  ) then
            this.bResetProfile = 1
            this:Input_Back()
            return
        end
        
        if(this.CurButton == "_ok" ) then -- Make PC work better - NM 8/5/04
					ifelm_shellscreen_fnPlaySound(this.acceptSound)
					this.bResetProfile = nil
					if(ScriptCB_IsCurProfileDirty()) then
						this.NextScreen = -1 -- flag special behavior
						ifs_opt_sound_StartSaveProfile()
					else
						this:Input_Back(1)
					end
					return
        end
        
        if (this.CurButton == "reset" ) then
            ScriptCB_ResetSoundToDefault()
            
            if (ScriptCB_GetMixConfigChanged()) then
                ifs_opt_sound_closeShellSound() 
                ifs_opt_sound_restoreShellSound(ifs_opt_top.movieBackground)
            end
        end
        
        -- Only the PC needs to handle this input (consoles are L/R/U/D + Back) - NM 8/3/04
        if(gPlatformStr ~= "PC" ) then
            return
        end

        --      print("ifs_opt_sound Input_Accept. gMouseOverHorz = ",gMouseOverHorz)
        --      if(gMouseOverHorz) then
        --          print("  gMouseOverHorz.MousePercentage = ",gMouseOverHorz.MousePercentage)
        --      end

        if(gMouseOverHorz) then
            -- Convert mouse percentage into 0..10 scale used on this screen
            local VolMusic, VolSfx, VolVoice, VolBattleVoice, MaxVol, VolMaster = ScriptCB_GetVolumes()
            local NewVal = math.floor(MaxVol * gMouseOverHorz.fHitX + 0.5)
            NewVal = math.max(0,NewVal)
            NewVal = math.min(MaxVol,NewVal)

            if(gMouseOverHorz.tag == "music") then
                VolMusic = NewVal
            elseif (gMouseOverHorz.tag == "sfx") then
                VolSfx = NewVal
            elseif (gMouseOverHorz.tag == "voice") then
                VolVoice = NewVal
            elseif (gMouseOverHorz.tag == "battlevoice") then
                VolBattleVoice = NewVal
            elseif (gMouseOverHorz.tag == "master") then
                VolMaster = NewVal
            end

            -- update bus gains     
            ScriptCB_SetVolumes(VolMusic, VolSfx, VolVoice, VolBattleVoice, VolMaster)
            ifs_opt_sound_fnUpdateSliders(this)
            
            if (gMouseOverHorz.tag == "master") then
                ScriptCB_ShellPlayDelayedStream("shell_auditionSFX", 0, 0.0, "Root", 0)
            elseif (gMouseOverHorz.tag == "sfx") then
                ScriptCB_ShellPlayDelayedStream("shell_auditionSFX", 0, 0.0, "soundfx", 0)
            elseif (gMouseOverHorz.tag == "voice") then
                ScriptCB_ShellPlayDelayedStream("shell_auditionVO",  0, 0.0, "voiceover", 0)
            elseif (gMouseOverHorz.tag == "battlevoice") then
                ScriptCB_ShellPlayDelayedStream("shell_auditionVO",  0, 0.0, "battlechatter", 0)
            end

            ifs_opt_sound_fnUpdateButtons(this)
            return
        end

		ifs_opt_sound_fnClickModeButtons(this)

        ifs_opt_sound_fnUpdateSliders(this)
        
--        print("opt_sound, CurButton = ",this.CurButton)
        if (this.CurButton == "output") then
            ifelm_shellscreen_fnPlaySound(this.acceptSound)
            ScriptCB_NextOutputMode()
        elseif (this.CurButton == "mixconfig") then
            ifelm_shellscreen_fnPlaySound(this.acceptSound)
            ScriptCB_NextMixConfig()
        elseif (this.CurButton == "effects") then
            ifelm_shellscreen_fnPlaySound(this.acceptSound)
            ScriptCB_ToggleEffects()
        end
        
        if (ScriptCB_GetMixConfigChanged()) then
            ifs_opt_sound_closeShellSound() 
            ifs_opt_sound_restoreShellSound(ifs_opt_top.movieBackground)
        end
        
        --if (this.CurButton == "bassmang") then
            --ifelm_shellscreen_fnPlaySound(this.acceptSound)
            --if (ScriptCB_GetBassManagement()) then
                --ScriptCB_SetBassManagement(nil)
            --else
                --ScriptCB_SetBassManagement(1)
            --end
        --end
        ifs_opt_sound_fnUpdateButtons(this)
    end,

	Input_Back = function(this)
		if (gPlatformStr == "PC") and this.bShellMode then
			-- rethink interface state, but don't leave
			this:Exit(false)
			this:Enter(true)
		else
			ScriptCB_PopScreen()
		end
    end,

	Input_Start = function(this)
		if not this.bShellMode then
 			this.bResetProfile = 1
			ScriptCB_PopScreen()
		end
	end,
	
    Input_GeneralLeft = function(this)
        ifs_opt_sound_fnLeft(this, 1)
    end,
    Input_LTrigger = function(this)
        ifs_opt_sound_fnLeft(this, 10)
    end,

  Input_GeneralRight = function(this)
        ifs_opt_sound_fnRight(this, 1)
    end,
    Input_RTrigger = function(this)
        ifs_opt_sound_fnRight(this, 10)
    end,

    Input_GeneralUp = function(this)
        -- If base class handled this work, then we're done
        if(gShellScreen_fnDefaultInputUp(this)) then
            return
        end

        -- if this is a slider
        if (this.CurButton) then
            if (ifs_opt_sound_fnIsASlider(this.CurButton)) then
                HSlider_fnSetAlpha(this.sliders[this.CurButton],0.4) -- dim unselected one
                if(gPlatformStr ~= "PC") then
                    gMouseOverHorz = nil
                end
            end
        end
        
        -- Call default function
        gDefault_Input_GeneralUp(this)
        
        -- if this is a slider
        if (ifs_opt_sound_fnIsASlider(this.CurButton)) then
            HSlider_fnSetAlpha(this.sliders[this.CurButton],1.0) -- brite selected one
            if(gPlatformStr ~= "PC") then
                gMouseOverHorz = this.sliders[this.CurButton]
            end
        end
        ifs_opt_sound_fnUpdateButtons(this)
    end,

    Input_GeneralDown = function(this)
        -- If base class handled this work, then we're done
        if(gShellScreen_fnDefaultInputDown(this)) then
            return
        end

        -- if this is a slider
        if (this.CurButton) then
            if (ifs_opt_sound_fnIsASlider(this.CurButton)) then
                HSlider_fnSetAlpha(this.sliders[this.CurButton],0.4) -- dim unselected one
                if(gPlatformStr ~= "PC") then
                    gMouseOverHorz = nil
                end
            end
        end
        
        -- Call default function
        gDefault_Input_GeneralDown(this)
        
        -- if this is a slider
        if (ifs_opt_sound_fnIsASlider(this.CurButton)) then
            HSlider_fnSetAlpha(this.sliders[this.CurButton],1.0) -- brite selected one
            if(gPlatformStr ~= "PC") then
                gMouseOverHorz = this.sliders[this.CurButton]
            end
        end
        ifs_opt_sound_fnUpdateButtons(this)
    end,

    Input_Misc = function(this)
        if(gPlatformStr ~= "PC") then
            Popup_YesNo_Large.CurButton = "no" -- default
            Popup_YesNo_Large.fnDone = ifs_opt_sound_fnAskedResetDone
            -- Hide UI
            IFObj_fnSetVis(this.buttons, nil)
            IFObj_fnSetVis(this.buttonlabels, nil)
            IFObj_fnSetVis(this.sliders, nil)
            -- Show dialog
            Popup_YesNo_Large:fnActivate(1)
                        gPopup_fnSetTitleStr(Popup_YesNo_Large, "ifs.soundopt.resetprompt")
        end
    end,

    Update = function(this, fDt)
        gIFShellScreenTemplate_fnUpdate(this, fDt)  -- always call base class
        
        HSlider_fnSetAlpha(this.sliders.master, 0.5)
        HSlider_fnSetAlpha(this.sliders.music,0.5) -- dim unselected one
        HSlider_fnSetAlpha(this.sliders.sfx,0.5) -- dim unselected one  
        HSlider_fnSetAlpha(this.sliders.voice,0.5) -- dim unselected one        
        HSlider_fnSetAlpha(this.sliders.battlevoice,0.5) -- dim unselected one        
        if(gMouseOverHorz) then
            HSlider_fnSetAlpha(gMouseOverHorz,1.0) -- brite selected one
            --          this.CurButton = gMouseOverHorz.tag
        end
        
        --      if (this.CurButton ~= nil) then     
        --          if (ifs_opt_sound_fnIsASlider(this.CurButton)) then
        --              HSlider_fnSetAlpha(this.sliders[this.CurButton],1.0) -- brite selected one
        --          end            
        --      end
        
    end
}

ifs_opt_sound_vbutton_layout = {
    yTop = 55,
    yHeight = 35,
    ySpacing = 0,
    width = 300,
    sliderheight = 24,
    font = "gamefont_medium",
    RightJustify = 1,
    bRightJustifyText = 1,
    bRightJustifyButton = 1,
    buttonlist = {
        -- Title is for the left column, string the % on the right,
        -- sliders created by code later
        { tag = "master",      title = "ifs.soundopt.mastervol",        string = "" , noCreateHotspot = true,},
        { tag = "music",       title = "ifs.soundopt.musicvol",         string = "" , noCreateHotspot = true,},
        { tag = "sfx",         title = "ifs.soundopt.sfxvol",           string = "" , noCreateHotspot = true,},
        { tag = "voice",       title = "ifs.soundopt.speechvol",        string = "" , noCreateHotspot = true,},
        { tag = "battlevoice", title = "ifs.soundopt.battlespeechvol",  string = "" , noCreateHotspot = true,},
        { tag = "output",      title = "ifs.soundopt.outputmode.title", string = "" , noCreateHotspot = true,},
        { tag = "bassmang",    title = "ifs.soundopt.bassmanagement",   string = "" , noCreateHotspot = true,},
        { tag = "mixconfig",   title = "ifs.soundopt.mixconfig.title",  string = "" , noCreateHotspot = true,},
        { tag = "effects",     title = "ifs.soundopt.effects.title",    string = "" , noCreateHotspot = true,},
        { tag = "reset",       title = "",                              string = "common.reset", width =400,},
    },
    --nocreatebackground = 1,
    flashy = 0,
}

function ifs_opt_sound_fnBuildSliders(this,layout,w,h)
    local yTop = layout.yTop or 0
    local yHeight = layout.yHeight or 40
    local ySpacing = layout.ySpacing or 10

    local screenw
    local screenh
    screenw,screenh = ScriptCB_GetSafeScreenInfo()

    this.sliders.x = w * (0.5) + 20 -- 100

    yTop = yTop + 3 -- make text centered w/ strings

    local i
    local Count = table.getn(layout.buttonlist)
    for i = 1,Count do
        if (ifs_opt_sound_fnIsASlider(layout.buttonlist[i].tag)) then
            local label = layout.buttonlist[i].tag
            this.sliders[label] = NewHSlider { y = yTop, width = w, height = layout.sliderheight, thumbwidth = 10, 
                                               texturebg = "slider_sound", texturefg = "slider_fg" }
            this.sliders[label].tag = label
            HSlider_fnSetAlpha(this.sliders[label],0.4) -- dim unselected one
            yTop = yTop + yHeight + ySpacing
        else
            local label  = layout.buttonlist[i].tag
            local button = this.buttons[label]
            button.label.textw  = 500 -- I really want to see this text
            button.label.halign = "Left"
            if (gPlatformStr == "PC") then
                IFObj_fnSetPos(button, (screenw * 0.43 * -1.0), button.y)
            else
                IFObj_fnSetPos(button, button.x - (screenw * 0.43), button.y)
            end
        end
    end
    
end

function ifs_opt_sound_fnBassMangChangedCB(buttongroup, btnNum)
	local oldSelection = ifelem_GetSelectedRadioButton(buttongroup)
	local oldSetting = ScriptCB_GetBassManagement()
	ScriptCB_SetBassManagement( btnNum == 2 )
	if ScriptCB_GetBassManagement() == oldSetting then
		return oldSelection
	end
	
    ifs_opt_sound_updateLogo(ifs_opt_sound)

	if(gPlatformStr == "PC") and this.bShellMode then
		IFObj_fnSetVis(this.cancelbutton, ScriptCB_HasProfileChanged())
	end
end

function ifs_opt_sound_fnEffectsChangedCB(buttongroup, btnNum)
	ScriptCB_ToggleEffects()
end

function ifs_opt_sound_fnBuildScreen(this)

    local w
    local h
    w,h = ScriptCB_GetSafeScreenInfo()
    
    if((gPlatformStr == "PS2") or (gPlatformStr == "XBox")) then
        ifs_opt_sound_vbutton_layout.yHeight = 50
    end

    local BarW = ifs_opt_sound_getBarSize(this)
    
    if(gPlatformStr ~= "PC") then
        this.title = NewIFText {
            string = "ifs.SoundOpt.title",
            font = "gamefont_large",
            y = 0,
            textw = 460, -- center on screen. Fixme: do real centering!
            ScreenRelativeX = 0.5, -- center
            ScreenRelativeY = 0, -- top
            inert = 1, -- delete out of Lua mem when pushed to C
            nocreatebackground = 1,
        }
    else
		-- add pc profile & title version text
		AddPCTitleText( this )    
    end

		-- Fix for BF2 bug 10654 - in German, these strings are HUGE. They'll
		-- wrap in the middle of a word against the safezone unless they're
		-- shrunk. Only need to do this on the PS2, as the XBox's extra
		-- resolution has enough pixels to handle this. NM 8/18/05
		local ButtonFont = ifs_opt_sound_vbutton_layout.font
		if((gPlatformStr == "PS2") and (gLangStr == "german")) then
			ifs_opt_sound_vbutton_layout.font = "gamefont_tiny"
		end

    ifs_opt_sound_vbutton_layout.bNoDefaultSizing = 1
    AddVerticalText(this.buttonlabels,ifs_opt_sound_vbutton_layout)

		-- Restore default font for right-side %ages
		ifs_opt_sound_vbutton_layout.font = ButtonFont
    
		local k,v
		local LabelWidth = (w * this.buttonlabels.ScreenRelativeX) - 8
		for k,v in ifs_opt_sound_vbutton_layout.buttonlist do
			local Tag = v.tag
			this.buttonlabels[Tag].textw = LabelWidth
			this.buttonlabels[Tag].x = -LabelWidth
		end
			
-- 		for k,v in ifs_opt_sound.buttonlabels do
-- 			if(type(v) == "table") then
-- 				v.x      = -(v.textw)
-- 				v.halign = "right"
-- 			end
-- 		end

    ifs_opt_sound_vbutton_layout.width = 60
    ifs_opt_sound.CurButton = AddVerticalButtons(ifs_opt_sound.buttons,ifs_opt_sound_vbutton_layout)
    
    ifs_opt_sound_fnBuildSliders(ifs_opt_sound, ifs_opt_sound_vbutton_layout, BarW, h)
    
    -- build radio buttons
	-- add radio buttons
	local radio_layout = {
		spacing = w * 0.125,
		font = "gamefont_medium",
		strings = {"common.no", "common.yes"},
		x = 15,
		y = 0,
	}
	radio_layout.callback = ifs_opt_sound_fnBassMangChangedCB
	ifelem_AddRadioButtonGroup(this, radio_layout.x, this.buttons.bassmang.y, radio_layout, "bassmang")
	radio_layout.callback = ifs_opt_sound_fnEffectsChangedCB
	ifelem_AddRadioButtonGroup(this, radio_layout.x, this.buttons.effects.y, radio_layout, "effects")
	


    -- Fixup vertical positioning/centering
    --      for k,v in ifs_opt_sound_vbutton_layout.buttonlist do
    --          local Tag = v.tag
    --          ifs_opt_sound.buttonlabels[Tag].valign = "vcenter"
    --          ifs_opt_sound.buttons[Tag].label.valign = "vcenter"
    --          ifs_opt_sound.buttonlabels[Tag].texth = ifs_opt_sound_vbutton_layout.yHeight
    --          ifs_opt_sound.buttons[Tag].label.texth = ifs_opt_sound_vbutton_layout.yHeight
    --      end

    if (gPlatformStr == "PC") then
        this.logoInfos["envmorphing"] = NewIFText { y = 0,  font = "gamefont_small", textw = 300, texth = 50, halign = "left", valign = "vcenter", string = "ifs.soundopt.eax.envmorphing" }
        this.logoInfos["occulsion"]   = NewIFText { y = 30, font = "gamefont_small", textw = 300, texth = 50, halign = "left", valign = "vcenter", string = "ifs.soundopt.eax.occlusion" }
        this.logoInfos["reverb"]      = NewIFText { y = 60, font = "gamefont_small", textw = 300, texth = 50, halign = "left", valign = "vcenter", string = "ifs.soundopt.eax.reverb" }
        this.logoInfos["envpanning"]  = NewIFText { y = 90, font = "gamefont_small", textw = 300, texth = 50, halign = "left", valign = "vcenter", string = "ifs.soundopt.eax.envpanning" }
    end
    
    
    -- Accept/Cancel buttons are PC only
    if(gPlatformStr ~= "PC") then
        this.Helptext_Reset = NewHelptext {
            ScreenRelativeX = 0.0, -- left side of screen
            ScreenRelativeY = 1.0, -- bot
            y = -40,
            buttonicon = "btnmisc",
            string = "ifs.SoundOpt.reset",
--            bRightJustify = 1,
        }
    else
        ifelem_tabmanager_Create(this, gPCMainTabsLayout, gPCOptionsTabsLayout)

		local BackButtonW = 150 -- made 130 to fix 6198 on PC - NM 8/18/04
		local BackButtonH = 25
		
        this.cancelbutton = NewPCIFButton -- NewRoundIFButton 
        {
            ScreenRelativeX = 0.0, -- left
            ScreenRelativeY = 1.0, -- bottom
            y = -15, -- just above bottom
            x = BackButtonW * 0.5,
            btnw = BackButtonW, 
            btnh = BackButtonH,
            font = "gamefont_medium", 
            bg_width = BackButtonW, 
			noTransitionFlash = 1,
            tag = "_back",
			string = "common.cancel",
        }
        
		this.resetbutton = NewPCIFButton
		{
			ScreenRelativeX = 0.5, -- right
			ScreenRelativeY = 1.0, -- bottom
			y = -15, -- just above bottom						
			btnw = BackButtonW * 1.5,
			btnh = BackButtonH,
			font = "gamefont_medium",
			noTransitionFlash = 1,
			tag = "reset",
			string = "common.reset",
		}
		
        this.donebutton = NewPCIFButton -- NewRoundIFButton 
        {
            ScreenRelativeX = 1.0, -- right
            ScreenRelativeY = 1.0, -- bottom
            y = -15, -- just above bottom
            x = -BackButtonW * 0.5,
            btnw = BackButtonW, 
            btnh = BackButtonH,
            font = "gamefont_medium", 
            bg_width = BackButtonW, 
			noTransitionFlash = 1,
            tag = "_ok",
			string = "common.accept",
        }
        
        -- add modelist dropdown box
        if( ScriptCB_GetShellActive() ) then
			ifs_opt_sound_fnAddOutputMode( this )
		end
    end
end

ifs_opt_sound_fnBuildScreen(ifs_opt_sound)
ifs_opt_sound_fnBuildSliders = nil -- dump out of memory when done.
ifs_opt_sound_fnBuildScreen = nil
ifs_opt_sound_vbutton_layout = nil

AddIFScreen(ifs_opt_sound,"ifs_opt_sound")
ifs_opt_sound = DoPostDelete(ifs_opt_sound)
