--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

local dim_backdrop = 1
local image_background = nil
if( ScriptCB_GetShellActive() ) then
	--print("set background iface_bg_1")
	image_background = "iface_bg_1"
	dim_backdrop = nil
end

function ifs_opt_pcvideo_StartSaveProfile()
	--  print("ifs_opt_top_StartSaveProfile")
	
	ifs_saveop.doOp = "SaveProfile"
	ifs_saveop.OnSuccess = ifs_opt_pcvideo_SaveProfileSuccess
	ifs_saveop.OnCancel = ifs_opt_pcvideo_SaveProfileCancel
	local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
	ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
	ifs_saveop.saveProfileNum = iProfileIdx
	ifs_movietrans_PushScreen(ifs_saveop)
end

function ifs_opt_pcvideo_SaveProfileSuccess()
	--  print("ifs_opt_top_SaveProfileSuccess")
	local this = ifs_opt_pcvideo
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()

	-- Replace current screen with next screen from tabs
	if(this.NextScreen ~= -1) then
		ScriptCB_SetIFScreen(this.NextScreen)
	else
		if(this.bShellMode) then
			-- rethink interface state, but don't leave
			this:Exit(false)
			this:Enter(true)
		else
			ScriptCB_PopScreen()
		end
	end
	this.NextScreen = nil
end

function ifs_opt_pcvideo_SaveProfileCancel()
	--  print("ifs_opt_top_SaveProfileCancel")
	local this = ifs_opt_pcvideo
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()

	-- Replace current screen with next screen from tabs
	if(this.NextScreen ~= -1) then
		ScriptCB_SetIFScreen(this.NextScreen)
	else
		if(this.bShellMode) then
			-- rethink interface state, but don't leave
			this:Exit(false)
			this:Enter(true)
		else
			ScriptCB_PopScreen()
		end
	end
	this.NextScreen = nil
end

ifs_opt_pcvideo = NewIFShellScreen {
    nologo = 1,
    movieIntro      = nil, -- played before the screen is displayed
    movieBackground = nil, -- played while the screen is displayed
    bNohelptext_backPC = 1,
	bg_texture = image_background,
	bDimBackdrop = dim_backdrop,

	ApplySettings = function(this, bCancelable)
		local generalForm = this.formcontainergeneral.form
		local customForm = this.formcontainercustom.form

		-- apply all the changes, then bail
		if(ScriptCB_GetShellActive()) then
			-- only change resolutions in the shell
			local values = customForm.elements["resolution"].values
			local index = customForm.elements["resolution"].selValue
			ScriptCB_SetResolution(values[index].data["resX"],values[index].data["resY"])
		end
		-- change other options all the time
		ScriptCB_SetHUDScale(generalForm.elements["hudscale"].selValue)
				
		ScriptCB_SetPCVideoOptions(
									generalForm.elements["overallquality"].selValue, customForm.elements["lightingquality"].selValue,
									customForm.elements["texturedetail"].selValue, customForm.elements["texturequality"].selValue,
									this.iMultiSample, this.iMultiSampleQuality,
									customForm.elements["waterquality"].selValue, customForm.elements["terrainquality"].selValue,
									customForm.elements["particlequality"].selValue, customForm.elements["shadowquality"].selValue,
									customForm.elements["specularquality"].selValue, customForm.elements["lightbloom"].selValue,
									customForm.elements["bumpmapping"].selValue, customForm.elements["motionblur"].selValue, 
									customForm.elements["distortion"].selValue, generalForm.elements["windowed"].selValue,
									generalForm.elements["brightness"].selValue, generalForm.elements["contrast"].selValue, 
									customForm.elements["viewdistance"].selValue, customForm.elements["loddistance"].selValue, 
									generalForm.elements["vsync"].selValue
									)
									
		ScriptCB_SetPCBrightnessContrast(generalForm.elements["brightness"].selValue, generalForm.elements["contrast"].selValue)

		this.bChangedSettings = nil or bCancelable
		if(gPlatformStr == "PC") and this.bShellMode then
			--IFObj_fnSetVis(this.donebutton, this.bChangedSettings)
			IFObj_fnSetVis(this.cancelbutton, this.bChangedSettings)
		end
	end,


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
				--IFObj_fnSetVis(this.donebutton, false)
				IFObj_fnSetVis(this.cancelbutton, false)
				
				-- show options and video tabs
				ifelem_tabmanager_SetSelected(this, gPCMainTabsLayout, "_tab_options")
				ifelem_tabmanager_SetSelected(this, gPCOptionsTabsLayout, "_tab_video", 1)
				
				-- set PC profile & title version text
				UpdatePCTitleText(this)
			else
				-- show done and cancel buttons
				IFObj_fnSetVis(this.donebutton, true)
				IFObj_fnSetVis(this.cancelbutton, true)
				
				-- show video tab
				ifelem_tabmanager_SelectTabGroup(this, nil, 1, nil)
				ifelem_tabmanager_SetSelected(this, gPCOptionsTabsLayout, "_tab_video", 1)
				
                -- hide PC profile & title version text
				HidePCTitleText(this)
			end
			
			-- dim tabs for PC Demo
			ifs_DimTabsPCDemo(this)          
		end

		local generalForm = this.formcontainergeneral.form    
		local customForm = this.formcontainercustom.form    

		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function      
		Form_Enter(generalForm, bFwd)
		Form_Enter(customForm, bFwd)

		-- hide or grey out some options that aren't available on this graphics card
		if(ScriptCB_IsPCVideoFixedFunction() ) then
			customForm.elements["bumpmapping"].hidden = 1
		end
		-- hide some options if we're in game
		if(not ScriptCB_GetShellActive()) then
			customForm.elements["resolution"].hidden = 1
			customForm.elements["texturedetail"].hidden = 1
			customForm.elements["texturequality"].hidden = 1
			customForm.elements["multisample"].hidden = 1
			generalForm.elements["windowed"].hidden = 1
			generalForm.elements["vsync"].hidden = 1
			customForm.elements["resolution"].hidden = 1
			generalForm.elements["overallquality"].hidden = 1
		end

		SetCurButton(this.CurButton)
		Form_ShowHideElements(generalForm)
		Form_ShowHideElements(customForm)

		-- fill the resolution content list here
		if(ScriptCB_GetShellActive()) then
			local index = ScriptCB_FillResolutionTable(nil, nil)
			customForm.elements["resolution"].selValue = index         
			customForm.elements["resolution"].values = ifs_opt_pcvideo_reslistbox_contents
			Form_UpdateElement(customForm, "resolution")
			this.resX = customForm.elements["resolution"].values[index].data.resX
			this.resY = customForm.elements["resolution"].values[index].data.resY
		end

		-- fill the antialiasing content list here
		--if (ScriptCB_GetShellActive()) then
		local iWidth, iHeight
		for idx, resItem in customForm.elements["resolution"].values do
			if ( idx == customForm.elements["resolution"].selValue ) then
				iWidth = resItem.data.resX
				iHeight = resItem.data.resY
				break
			end
		end

		-- multisample table will be limited to options usable by iWidth x iHeight
		local index = ScriptCB_FillMultisampleTable(iWidth, iHeight)

		customForm.elements["multisample"].selValue = index         
		customForm.elements["multisample"].values = ifs_opt_pcvideo_fsaalistbox_contents
		Form_UpdateElement(customForm, "multisample")
		this.iMultiSample = customForm.elements["multisample"].values[index].data.multisampleType
		this.iMultiSampleQuality = customForm.elements["multisample"].values[index].data.multisampleQuality
		--end
		
		-- go back and limit options by selected multisample table
		local fsaaType = customForm.elements["multisample"].values[customForm.elements["multisample"].selValue].data.multisampleType
		local fsaaQuality = customForm.elements["multisample"].values[customForm.elements["multisample"].selValue].data.multisampleQuality
        ScriptCB_FillResolutionTable(fsaaType, fsaaQuality)
		customForm.elements["resolution"].values = ifs_opt_pcvideo_reslistbox_contents
		ListManager_fnFillContents(customForm.dropdowns["resolution"].listbox,
			customForm.elements["resolution"].values,
			customForm.dropdowns["resolution"].listbox.Layout)


		--get all the other video options
		generalForm.elements["overallquality"].selValue, customForm.elements["lightingquality"].selValue,
		customForm.elements["texturedetail"].selValue, customForm.elements["texturequality"].selValue,
		generalForm.elements["brightness"].selValue, generalForm.elements["contrast"].selValue,
		customForm.elements["viewdistance"].selValue, customForm.elements["loddistance"].selValue,
		customForm.elements["waterquality"].selValue, customForm.elements["terrainquality"].selValue,
		customForm.elements["particlequality"].selValue, customForm.elements["shadowquality"].selValue,
		customForm.elements["specularquality"].selValue, customForm.elements["lightbloom"].selValue,
		customForm.elements["bumpmapping"].selValue, customForm.elements["motionblur"].selValue, 
		customForm.elements["distortion"].selValue,	generalForm.elements["windowed"].selValue, 
		generalForm.elements["vsync"].selValue = ScriptCB_GetPCVideoOptions()

		generalForm.elements["hudscale"].selValue = ScriptCB_GetHUDScale()
		
		-- store the original brightness and contrast values, in case we cancel.
		-- need to do this since these are changed in real time
		this.fOriginalBrightness = generalForm.elements["brightness"].selValue
		this.fOriginalContrast = generalForm.elements["contrast"].selValue

		SetCurButton(this.CurButton)
				
		Form_SetValues(generalForm)
		Form_SetValues(customForm)
	end, -- function Enter()
  
	Exit = function(this)
		if( this.bResetProfile ) then
			ScriptCB_ReloadMarkedProfile()

			-- update brightness/contrast since it may have changed in the reload
			local generalForm = this.formcontainergeneral.form
			if ( this.fOriginalBrightness ~= generalForm.elements["brightness"].selValue
					or this.fOriginalContrast ~= generalForm.elements["contrast"].selValue ) then
				--ScriptCB_SetPCBrightnessContrast(this.fOriginalBrightness, this.fOriginalContrast)
			end
		end      
		if(gCurHiliteButton) then
			IFButton_fnSelect(gCurHiliteButton,nil)
		end
	end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this,1)) then
			return
		end

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
				-- Close any open dropboxes. Fixes #13353 - NM 9/19/05
				if(this.formcontainergeneral.form) then
					Form_CloseDropboxes(this.formcontainergeneral.form)
				end
				if(this.formcontainercustom.form) then
					Form_CloseDropboxes(this.formcontainercustom.form)
				end

				this.bResetProfile = nil -- accept changes made here
				-- update brightness/contrast since it may have changed in the reload
				local generalForm = this.formcontainergeneral.form
				if ( this.fOriginalBrightness ~= generalForm.elements["brightness"].selValue
						or this.fOriginalContrast ~= generalForm.elements["contrast"].selValue ) then
					--ScriptCB_SetPCBrightnessContrast(this.fOriginalBrightness, this.fOriginalContrast)
				end
				
				-- exiting this screen triggers an auto-save.  update 'original' settings.
				this.fOriginalBrightness = generalForm.elements["brightness"].selValue
				this.fOriginalContrast = generalForm.elements["contrast"].selValue

				if(ScriptCB_IsCurProfileDirty()) then
					ifs_opt_pcvideo_StartSaveProfile()
					return
				else
					-- No need to save. Just jump there
					ScriptCB_SetIFScreen(this.NextScreen)
					this.NextScreen = nil
					return
				end
			end -- this.Nextscreen is valid (i.e. clicked on a tab)
		end -- cur platform == PC


		if(not this.formcontainergeneral) then
--			print("Uhoh, this.formcontainergeneral is nil. Punting...")
		elseif (not this.formcontainergeneral.form) then
--			print("Uhoh, this.formcontainergeneral.form is nil. Punting...")
		elseif (not this.formcontainercustom) then
--			print("Uhoh, this.formcontainergeneral is nil. Punting...")
		elseif (not this.formcontainercustom.form) then
--			print("Uhoh, this.formcontainergeneral.form is nil. Punting...")
		else
			if(Form_InputAccept(this.formcontainergeneral.form, this) == true) then
				return
			end
			if(Form_InputAccept(this.formcontainercustom.form, this) == true) then
				return
			end
		end
				
		-- if we're on the 'cancel' button, then bail
		if (this.CurButton == "cancel") then
			this.bResetProfile = 1

			-- reset the brightness and contrast
			ScriptCB_SetPCBrightnessContrast(this.fOriginalBrightness, this.fOriginalContrast)
			ScriptCB_SndPlaySound("shell_menu_exit");
			if (gPlatformStr == "PC") and this.bShellMode then
				-- rethink interface state, but don't leave
				this:Exit(false)
				this:Enter(true)
			else
				-- bail       
				ScriptCB_PopScreen()
			end

			--if we selected the apply button
		elseif (this.CurButton == "apply") then
		
			ScriptCB_SndPlaySound("shell_menu_enter");              
			this:ApplySettings()
			local generalForm = this.formcontainergeneral.form
			local customForm = this.formcontainercustom.form			
			this.fOriginalBrightness = generalForm.elements["brightness"].selValue
			this.fOriginalContrast = generalForm.elements["contrast"].selValue
			if (gPlatformStr == "PC") and this.bShellMode then
				if(ScriptCB_IsCurProfileDirty()) then
					this.NextScreen = -1 -- flag special behavior
					ifs_opt_pcvideo_StartSaveProfile()
				else
					-- rethink interface state, but don't leave
					this:Exit(false)
					this:Enter(true)
				end
			else
				if(ScriptCB_IsCurProfileDirty()) then
					this.NextScreen = -1 -- flag special behavior
					ifs_opt_pcvideo_StartSaveProfile()
				else
					-- done
					ScriptCB_PopScreen()
				end
			end
		elseif (this.CurButton == "autodetect") then
		
			ScriptCB_SndPlaySound("shell_menu_enter");

			local generalForm = this.formcontainergeneral.form
			local customForm = this.formcontainercustom.form

			-- get the autodetected options
			local autodetect = {}
			local iMultiSample, iMultiSampleQuality
			local iResolutionIndex
			local brightness, contrast, vsync, windowed
			autodetect.overallquality, autodetect.lightingquality,
			iResolutionIndex, iMultiSample, autodetect.texturedetail, autodetect.texturequality,
			autodetect.brightness, autodetect.contrast, autodetect.viewdistance, autodetect.loddistance,
			autodetect.waterquality, autodetect.terrainquality, autodetect.particlequality, autodetect.shadowquality, autodetect.specularquality,
			autodetect.lightbloom, autodetect.bumpmapping, autodetect.motionblur, autodetect.distortion,
			windowed, vsync = ScriptCB_GetAutodetectPCVideoOptions()

			if( ScriptCB_GetShellActive() ) then
				this.resX, this.resY = ScriptCB_GetIdealResolution()
				--go from res to index?
				for idx, resItem in customForm.elements["resolution"].values do
					if (resItem.data.resX == this.resX and resItem.data.resY == this.resY) then
						customForm.elements["resolution"].selValue = idx
	   						this.resX = customForm.elements["resolution"].values[idx].data.resX
							this.resY = customForm.elements["resolution"].values[idx].data.resY
						break
					end
				end
				
				local multisampleIndex = 1
				customForm.elements["multisample"].selValue = multisampleIndex
				this.iMultiSample = customForm.elements["multisample"].values[multisampleIndex].data.multisampleType
				this.iMultiSampleQuality = customForm.elements["multisample"].values[multisampleIndex].data.multisampleQuality
			end

			for key, value in pairs(autodetect) do	
				if( generalForm.elements[key] and (not generalForm.elements[key].hidden) ) then
					generalForm.elements[key].selValue = value
				elseif( customForm.elements[key] and (not customForm.elements[key].hidden) ) then
					customForm.elements[key].selValue = value
				end
			end

			Form_SetValues(generalForm)
			Form_SetValues(customForm)
			
			this:ApplySettings(true)
			
			this.bChangedSettings = true
			if(gPlatformStr == "PC") and this.bShellMode then
				--IFObj_fnSetVis(this.donebutton, this.bChangedSettings)
				IFObj_fnSetVis(this.cancelbutton, this.bChangedSettings)
			end
		end
	end,
  
    UpdateOverallQuality = function(this, value)
		local generalForm = this.formcontainergeneral.form
		local customForm = this.formcontainercustom.form
		generalForm.elements["overallquality"].selValue = value
		
		if( generalForm.elements["overallquality"].selValue < 4 ) then
			if( ScriptCB_GetShellActive() ) then
				local resIndex, multisampleIndex				
				this.resX, this.resY = ScriptCB_GetCustomResolution(generalForm.elements["overallquality"].selValue)
				--go from res to index?
				for idx, resItem in customForm.elements["resolution"].values do
					if (resItem.data.resX == this.resX and resItem.data.resY == this.resY) then
						customForm.elements["resolution"].selValue = idx
						break
					end
				end
				
				local multisampleIndex = 1
				customForm.elements["multisample"].selValue = multisampleIndex
				this.iMultiSample = customForm.elements["multisample"].values[multisampleIndex].data.multisampleType
				this.iMultiSampleQuality = customForm.elements["multisample"].values[multisampleIndex].data.multisampleQuality
			end

			customForm.elements["lightingquality"].selValue, resIndex, multisampleIndex,
			customForm.elements["texturedetail"].selValue, customForm.elements["texturequality"].selValue,
			customForm.elements["viewdistance"].selValue, customForm.elements["loddistance"].selValue,
			customForm.elements["waterquality"].selValue, customForm.elements["terrainquality"].selValue,
			customForm.elements["particlequality"].selValue, customForm.elements["shadowquality"].selValue,
			customForm.elements["specularquality"].selValue, customForm.elements["lightbloom"].selValue,
			customForm.elements["bumpmapping"].selValue, customForm.elements["motionblur"].selValue, 
			customForm.elements["distortion"].selValue = ScriptCB_GetCustomVideoOptions(generalForm.elements["overallquality"].selValue)    
			Form_SetValues(customForm)
			Form_SetValues(generalForm)
			
			this.bChangedSettings = true
			if(gPlatformStr == "PC") and this.bShellMode then
				--IFObj_fnSetVis(this.donebutton, this.bChangedSettings)
				IFObj_fnSetVis(this.cancelbutton, this.bChangedSettings)
			end
		end
    end,
  
	OnRadioChanged = function(buttongroup, btnNum)
		-- 'buttongroup' is the button group (radiobuttons[key])
		local this = ifs_opt_pcvideo
		local form = this.formcontainergeneral.form
		for key, element in pairs(form.elements) do
			if ( type(element) == "table" ) then
				if ( element.tag == buttongroup.tag ) then
					form.elements[element.tag].selValue = btnNum
					Form_SetValues(form)
				end
			end
		end
		form = this.formcontainercustom.form
		for key, element in pairs(form.elements) do
			if ( type(element) == "table" and element.tag == buttongroup.tag ) then
				form.elements[element.tag].selValue = btnNum
				Form_SetValues(form)
			end
		end
		
		this.bChangedSettings = true
		this:ApplySettings(true)
		if(gPlatformStr == "PC") and this.bShellMode then
			--IFObj_fnSetVis(this.donebutton, this.bChangedSettings)
			IFObj_fnSetVis(this.cancelbutton, this.bChangedSettings)
		end
	end,
  
    OnElementChanged = function(form, element)
		local this = ifs_opt_pcvideo
		
		local generalForm = this.formcontainergeneral.form
		local customForm = this.formcontainercustom.form
    
  		if( form == customForm)  then
  			generalForm.elements["overallquality"].selValue = 4
			Form_SetValues(generalForm)
  		end
    
		if( element.tag == "overallquality" )  then
			this:UpdateOverallQuality(form.elements["overallquality"].selValue)				
		elseif( element.tag == "multisample" ) then
		
			this.iMultiSample = customForm.elements["multisample"].values[customForm.elements["multisample"].selValue].data.multisampleType
			this.iMultiSampleQuality = customForm.elements["multisample"].values[customForm.elements["multisample"].selValue].data.multisampleQuality
			
			-- limit options in resolution by new multisample selection
			ScriptCB_FillResolutionTable(this.iMultiSample, this.iMultiSampleQuality)
			customForm.elements["resolution"].values = ifs_opt_pcvideo_reslistbox_contents
			ListManager_fnFillContents(customForm.dropdowns["resolution"].listbox,
				customForm.elements["resolution"].values,
				customForm.dropdowns["resolution"].listbox.Layout)
		
			for idx, resItem in form.elements["resolution"].values do
				if (IsVideoModeSupported(resItem.data.resX, resItem.data.resY, this.iMultiSample, this.iMultiSampleQuality)) then
					resItem.bUnselectable = nil
				else
					resItem.bUnselectable = 1
				end
			end
			
            if (not IsVideoModeSupported(this.resX, this.resY, this.iMultiSample, this.iMultiSampleQuality)) then
                this.resX, this.resY = GetMaxScreenSizeForMultisamplingMode(this.iMultiSample, this.iMultiSampleQuality);
                local selectIdx = 1
                if (this.resX ~= nil) then
                    for idx, resItem in form.elements["resolution"].values do
                        if (resItem.data.resX == this.resX and resItem.data.resY == this.resY) then
                            selectIdx = idx
                            break
                        end
                    end
                else
                    resItem = form.elements["resolution"].values[selectIdx]
                    this.resX = resItem.data.resX
                    this.resY = resItem.data.resY
                end
                
                form.elements["resolution"].selValue = selectIdx
            end
            
			Form_UpdateElement(form, "resolution")            

		elseif( element.tag == "resolution" ) then
		-- update multisample table based on resolution selection
			ScriptCB_FillMultisampleTable(this.resX, this.resY)
			customForm.elements["multisample"].values = ifs_opt_pcvideo_fsaalistbox_contents
			ListManager_fnFillContents(customForm.dropdowns["multisample"].listbox,
				customForm.elements["multisample"].values,
				customForm.dropdowns["multisample"].listbox.Layout)

            for idx, fsaaItem in form.elements["multisample"].values do
                if (IsVideoModeSupported(this.resX, this.resY, fsaaItem.multisampleType, fsaaItem.multisampleQuality)) then
					fsaaItem.bUnselectable = nil
				else
					fsaaItem.bUnselectable = 1
				end
            end
          
            fsaaItem = form.elements["multisample"].values[form.elements["multisample"].selValue]
            if (not IsVideoModeSupported(this.resX, this.resY, fsaaItem.data.multisampleType, fsaaItem.data.multisampleQuality)) then
                this.iMultiSample, this.iMultiSampleQuality = GetMaxMultisamplingModeForScreenSize(this.resX, this.resY);
                local selectIdx = 1
                if (this.iMultiSample ~= nil) then
                    for idx, fsaaItem in form.elements["multisample"].values do
                        if (fsaaItem.data.multisampleType == this.iMultiSample and fsaaItem.data.multisampleQuality == this.iMultiSampleQuality) then
                            selectIdx = idx
                            break
                        end
                    end
                else
                    fsaaItem = form.elements["multisample"].values[selectIdx]
                    this.iMultiSample = fsaaItem.data.multisampleType
                    this.iMultiSampleQuality = fsaaItem.data.multisampleQuality
                end
                form.elements["multisample"].selValue = selectIdx

            end
			Form_UpdateElement(form, "multisample")

		elseif ( element.tag == "brightness" or element.tag == "contrast" ) then
			ScriptCB_SetPCBrightnessContrast(form.elements["brightness"].selValue, form.elements["contrast"].selValue)
			Form_UpdateElement(form, "brightness")
			Form_UpdateElement(form, "contrast")
		end

		this.bChangedSettings = true
		this:ApplySettings(true)
		if(gPlatformStr == "PC") and this.bShellMode then
			--IFObj_fnSetVis(this.donebutton, this.bChangedSettings)
			IFObj_fnSetVis(this.cancelbutton, this.bChangedSettings)
		end
    end,
  

	Input_Back = function(this)
		ScriptCB_SndPlaySound("shell_menu_exit")

		local generalForm = this.formcontainergeneral.form    
		local customForm = this.formcontainercustom.form    

		if(Form_Back(generalForm)) then
			return
		end
		if(Form_Back(customForm)) then
			return
		end

		-- bail       
		ScriptCB_SndPlaySound("shell_menu_exit")
		this:ApplySettings()
		this.fOriginalBrightness = generalForm.elements["brightness"].selValue
		this.fOriginalContrast = generalForm.elements["contrast"].selValue
		-- done

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
			ScriptCB_SetPCBrightnessContrast(this.fOriginalBrightness, this.fOriginalContrast)
			ScriptCB_PopScreen()
		end
	end,
	
    Input_GeneralRight = function(this)
        ScriptCB_SndPlaySound("shell_menu_ok");
        local generalForm = this.formcontainergeneral.form    
        local customForm = this.formcontainercustom.form           
   		Form_GeneralRight(generalForm)
   		Form_GeneralRight(customForm)
    end,

    Input_GeneralLeft = function(this)
		ScriptCB_SndPlaySound("shell_menu_ok");
        local generalForm = this.formcontainergeneral.form    
        local customForm = this.formcontainercustom.form           
   		Form_GeneralLeft(generalForm)
   		Form_GeneralLeft(customForm)
    end,

    Input_GeneralUp = function(this)
        -- If base class handled this work, then we're done
        if(gShellScreen_fnDefaultInputUp(this)) then
            return
        end
      
        local generalForm = this.formcontainergeneral.form    
        local customForm = this.formcontainercustom.form           
      
        if(Form_GeneralUp(generalForm)) then
			return
		end
        if(Form_GeneralUp(customForm)) then
			return
		end

        -- update the general buttons
        gDefault_Input_GeneralUp(this)
    end,

    Input_GeneralDown = function(this)
        -- If base class handled this work, then we're done
        if(gShellScreen_fnDefaultInputDown(this)) then
            return
        end
      
        local generalForm = this.formcontainergeneral.form    
        local customForm = this.formcontainercustom.form           

        if(Form_GeneralDown(generalForm)) then
			return
		end
        if(Form_GeneralDown(customForm)) then
			return
		end

         -- update general buttons
         gDefault_Input_GeneralDown(this)
    end,

    Update = function(this, fDt)
        gIFShellScreenTemplate_fnUpdate(this, fDt)  -- always call base class
        local generalForm = this.formcontainergeneral.form    
        local customForm = this.formcontainercustom.form           
		Form_Update(generalForm, fDt)
		Form_Update(customForm, fDt)
    end,
}


ifs_opt_pcvideo_general_options_layout = {
    yTop = 25,
    yHeight = 25,
    ySpacing  = 0,
    UseYSpacing = 1,
    xSpacing = 20,
  
    width = 330,
    font = "gamefont_tiny",
    flashy = 0,
    
    elements = {
        -- Title is for the left column, string the option (filled in by code later)
		{ tag = "brightness", title = "ifs.videoopt.brightness", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 0.5, control = "slider", minValue = 0.2, maxValue = 0.8 },
        { tag = "contrast", title = "ifs.videoopt.contrast", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 0.5, control = "slider", minValue = 0.2, maxValue = 0.8 },
        --{ tag = "vsync", title = "ifs.VideoOpt.vsync", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 1, control = "button", values = {"common.off", "common.on"} },
		--{ tag = "windowed", hidden = 1, title = "ifs.VideoOpt.windowed", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 1, control = "button", values = {"common.off", "common.on"} },
        --{ tag = "hudscale",  hidden = 1, title = "ifs.videoopt.hudscale", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 1.0, control = "slider", minValue = 0.25, maxValue = 1.0 },
        --{ tag = "overallquality", title = "ifs.videoopt.overallquality", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 1, control = "dropdown", values = {"ifs.VideoOpt.low", "ifs.VideoOpt.med", "ifs.VideoOpt.high", "ifs.VideoOpt.custom"} },
        { tag = "vsync", title = "ifs.VideoOpt.vsync", fnChanged = ifs_opt_pcvideo.OnRadioChanged, selValue = 1, control = "radio", values = {"common.off", "common.on"} },
		{ tag = "windowed", hidden = 1, title = "ifs.VideoOpt.windowed", fnChanged = ifs_opt_pcvideo.OnRadioChanged, selValue = 1, control = "radio", values = {"common.off", "common.on"} },
        { tag = "hudscale",  hidden = 1, title = "ifs.videoopt.hudscale", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 1.0, control = "slider", minValue = 0.25, maxValue = 1.0 },
        { tag = "overallquality", title = "ifs.videoopt.overallquality", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 1, control = "dropdown", values = {"ifs.VideoOpt.low", "ifs.VideoOpt.med", "ifs.VideoOpt.high", "ifs.VideoOpt.custom"} },
    },
}

ifs_opt_pcvideo_custom_options_layout = {
    yTop = 25,
    yHeight = 25,
    ySpacing  = 0,
    UseYSpacing = 1,
    xSpacing = 20,
  
    width = 330,
    font = "gamefont_tiny",
    flashy = 0,
    
    elements = {
        -- Title is for the left column, string the option (filled in by code later)
        { tag = "viewdistance", title = "ifs.VideoOpt.viewdistance", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 0.5, control = "slider", minValue = 0.0, maxValue = 1.0 },
        { tag = "loddistance", title = "ifs.VideoOpt.loddistance", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 0.5, control = "slider", minValue = 0.0, maxValue = 1.0 },
        { tag = "resolution", title = "ifs.VideoOpt.resolution", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 1, control = "dropdown", values = {}},
        { tag = "multisample", title = "ifs.VideoOpt.multisample", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 1, control = "dropdown", values = {"1", "2", "3", "4",}},	-- fill in values just so showcount can get set better
        { tag = "texturequality", hidden = 1, title = "ifs.videoopt.texturequality", fnChanged = ifs_opt_pcvideo.OnRadioChanged, selValue = 1, control = "radio", values = {"ifs.VideoOpt.16bit", "ifs.VideoOpt.32bit", "ifs.VideoOpt.compressed"} },
        { tag = "texturedetail", title = "ifs.videoopt.texturedetail", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 1, control = "dropdown", values = {"ifs.VideoOpt.low", "ifs.VideoOpt.med", "ifs.VideoOpt.high"} },
        { tag = "terrainquality", hidden = 1, title = "ifs.videoopt.terrainquality", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 1, control = "dropdown", values = {"ifs.VideoOpt.low", "ifs.VideoOpt.med", "ifs.VideoOpt.high"} },
        { tag = "waterquality", title = "ifs.videoopt.waterquality", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 1, control = "dropdown", values = {"ifs.VideoOpt.low", "ifs.VideoOpt.med", "ifs.VideoOpt.high"} },
        { tag = "particlequality", hidden = 1, title = "ifs.VideoOpt.particlequality", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 1, control = "dropdown", values = {"ifs.VideoOpt.low", "ifs.VideoOpt.med", "ifs.VideoOpt.high"} },
        { tag = "shadowquality", title = "ifs.VideoOpt.shadows", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 1, control = "dropdown", values = {"common.off", "ifs.VideoOpt.low", "ifs.VideoOpt.high"} },
        { tag = "specularquality", hidden = 1, title = "ifs.VideoOpt.specularquality", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 1, control = "dropdown", values = {"common.off", "ifs.VideoOpt.low", "ifs.VideoOpt.high"} },
        { tag = "bumpmapping", hidden = 1, title = "ifs.VideoOpt.bumpmapping", fnChanged = ifs_opt_pcvideo.OnRadioChanged, selValue = 1, control = "radio", values = {"common.off", "common.on"} },
        { tag = "motionblur", hidden = 1, title = "ifs.videoopt.motionblur", fnChanged = ifs_opt_pcvideo.OnRadioChanged, selValue = 1, control = "radio", values = {"common.off", "common.on"} },
        { tag = "distortion", hidden = 1, title = "ifs.videoopt.distortion", fnChanged = ifs_opt_pcvideo.OnRadioChanged, selValue = 1, control = "radio", values = {"common.off", "common.on"} },
        { tag = "lightingquality", title = "ifs.videoopt.lightingquality", fnChanged = ifs_opt_pcvideo.OnElementChanged, selValue = 1, control = "dropdown", values = {"ifs.VideoOpt.low", "ifs.VideoOpt.med", "ifs.VideoOpt.high"} },
        { tag = "lightbloom", title = "ifs.videoopt.lightbloom", fnChanged = ifs_opt_pcvideo.OnRadioChanged, selValue = 1, control = "radio", values = {"common.off", "common.on"} },
    },
}


---------------------------------------------- GENERAL OPTIONS CODE ------------------------------------


function ifs_opt_pcvideo_fnBuildScreen(this,layout)
	-- Ask game for screen size, used to make sliders
	local w
	local h
	w,h = ScriptCB_GetSafeScreenInfo()
  
	-- add pc profile & title version text
	AddPCTitleText( this )

	ifs_opt_pcvideo_general_options_layout.width = w * 0.50
	ifs_opt_pcvideo_custom_options_layout.width = w * 0.50

	this.formcontainergeneral = NewIFContainer {
		ScreenRelativeX = 0.24,
		ScreenRelativeY = 0,
		x = 0,
		y = 50,
	}
  
	this.formcontainercustom = NewIFContainer {
		ScreenRelativeX = 0.77,
		ScreenRelativeY = 0,
		x = 0,
		y = 50,
	}  
	
	this.formcontainergeneral.title = NewIFText {
		halign = "hcenter",
		valign = "vcenter",
		textw = ifs_opt_pcvideo_general_options_layout.width,
		string = "ifs.videoopt.titlegeneral",
		font = "gamefont_medium", 
		flashy=0,
	}

	this.formcontainercustom.title = NewIFText {
		halign = "hcenter",
		valign = "vcenter",
		textw = ifs_opt_pcvideo_custom_options_layout.width,
		string = "ifs.videoopt.titlecustom",
		font = "gamefont_medium", 
		flashy=0,
	}
	
	for k, element in pairs(ifs_opt_pcvideo_general_options_layout.elements) do
		element.width = ifs_opt_pcvideo_general_options_layout.width * 0.40
	end
	for k, element in pairs(ifs_opt_pcvideo_custom_options_layout.elements) do
		element.width = ifs_opt_pcvideo_custom_options_layout.width * 0.40
	end
  
	Form_CreateVertical(this.formcontainergeneral, ifs_opt_pcvideo_general_options_layout);
	Form_CreateVertical(this.formcontainercustom, ifs_opt_pcvideo_custom_options_layout);
	this.formcontainercustom.form.dropdowns.x = this.formcontainercustom.form.dropdowns.x + 10
	this.formcontainergeneral.form.dropdowns.x = this.formcontainergeneral.form.dropdowns.x + 10
	this.formcontainercustom.form.dropdowns.y = this.formcontainercustom.form.dropdowns.y + 2
	this.formcontainergeneral.form.dropdowns.y = this.formcontainergeneral.form.dropdowns.y + 2
	this.formcontainercustom.form.radiobuttons.x = this.formcontainercustom.form.radiobuttons.x + 5
	this.formcontainergeneral.form.radiobuttons.x = this.formcontainergeneral.form.radiobuttons.x + 5
	this.formcontainercustom.form.buttons.x = this.formcontainercustom.form.buttons.x - 30
	this.formcontainergeneral.form.buttons.x = this.formcontainergeneral.form.buttons.x - 30
	this.formcontainercustom.form.buttons.y = this.formcontainercustom.form.buttons.y + 3
	this.formcontainergeneral.form.buttons.y = this.formcontainergeneral.form.buttons.y + 3
	this.formcontainercustom.form.sliders.y = this.formcontainercustom.form.sliders.y + 3
	this.formcontainergeneral.form.sliders.y = this.formcontainergeneral.form.sliders.y + 3
	
	local BackButtonW = 150
	local BackButtonH = 25
  
	this.cancelbutton = NewPCIFButton
	{
		ScreenRelativeX = 0.0, -- right
		ScreenRelativeY = 1.0, -- bottom
		y = -15, -- just above bottom
		x = BackButtonW * 0.5,
		btnw = BackButtonW,
		btnh = BackButtonH,
		font = "gamefont_medium",
		bg_width = BackButtonW,
		noTransitionFlash = 1,
		tag = "cancel",
		string = "common.cancel",
	}

	this.autodetectbutton = NewPCIFButton
	{
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 1.0,
		y = -15,
		x = 0,
		btnw = BackButtonW*1.5,
		btnh = BackButtonH,
		font = "gamefont_medium",
		noTransitionFlash = 1,
		tag = "autodetect",
		string = "common.reset",
	}
	
	this.donebutton =   NewPCIFButton
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
		tag = "apply",
		string = "common.accept",
	}

--	this.Background = NewIFImage
--	{
--		ZPos = 255,
--		x = w/2,  --centered on the x
--		y = h/2, -- inertUVs = 1,
--		alpha = 10,
--		localpos_l = -w/1.5, localpos_t = -h/1.5,
--		localpos_r = w/1.5, localpos_b =  h/1.5,
--		texture = "opaque_black",
--		ColorR = 20, ColorG = 20, ColorB = 150, -- blue
--	}

	ifelem_tabmanager_Create(this, gPCMainTabsLayout, gPCOptionsTabsLayout)
end


ifs_opt_pcvideo_fnBuildScreen(ifs_opt_pcvideo,ifs_opt_pcvideo_general_options_layout)
ifs_opt_pcvideo_fnBuildScreen = nil

AddIFScreen(ifs_opt_pcvideo,"ifs_opt_pcvideo")





