--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Shell Screen template, associated code.

-- Some tuning values
gShellAnimTime = 0.4 -- default on animations if not specified

gPrevMovie = nil
gMovieAlwaysPlay = nil

-- Helper array. Turns a StateVoice icon into UV coords.
-- Values for what the StateIcon/VoiceIcon will be. From xbOnline.h:
--0     ONLINEICON_NONE = 0,                   // No icon
--1     ONLINEICON_FRIEND_ONLINE,              // Friend is online
--2     ONLINEICON_FRIEND_RECEIVEDREQUEST,     // Friend request received
--3     ONLINEICON_FRIEND_SENTREQUEST,         // Friend request sent
--4     ONLINEICON_FRIEND_RECEIVEDINVITE,      // Game invite from friend
--5     ONLINEICON_FRIEND_SENTINVITE,          // Game invite to friend
--6     ONLINEICON_PLAYER_VOICE,               // Player has voice capability        
--7     ONLINEICON_PLAYER_MUTED,               // Player has been muted
--8     ONLINEICON_PLAYER_TVCHAT,              // TV Chat -  no voice comm.               
-- See page 22-23 of xboxliverecUI.pdf for the mapping of what
-- these should look like. These are mapped out of lobby_icons.tga
gXLFriendsEnum2UVs = {
	{ u=0.75, v=0.75,}, -- ONLINEICON_NONE
	{ u=0.5 , v=0.25,}, -- ONLINEICON_FRIEND_ONLINE
	{ u=0.0 , v=0.25,}, -- ONLINEICON_FRIEND_RECEIVEDREQUEST
	{ u=0.25, v=0.25,}, -- ONLINEICON_FRIEND_SENTREQUEST
	{ u=0.0 , v=0.5 ,}, -- ONLINEICON_FRIEND_RECEIVEDINVITE
	{ u=0.25, v=0.5 ,}, -- ONLINEICON_FRIEND_SENTINVITE
	{ u=0.25, v=0.0 ,}, -- ONLINEICON_PLAYER_VOICE
	{ u=0.75, v=0.0 ,}, -- ONLINEICON_PLAYER_MUTED
	{ u=0.0 , v=0.0 ,}, -- ONLINEICON_PLAYER_TVCHAT
	{ u=0.5 , v=0.0 ,}, -- ONLINEICON_PLAYER_VOICE2
}

-- Utility function for after a controller error has happened. Used to
-- restore any open popups, etc. NOTE: error_popup.lua can call this
-- with this == nil
function ifelem_shellscreen_fnPostControllerError(this)
	-- HACK for 3774, 6326 - hide DNAS stuff if present (only in PS2 shell)
	-- Thou shalt have no bitmaps before the DNAS logo. Restore them.
	if(ifs_mpps2_dnas and ifs_mpps2_dnas.dnasImg) then
		IFObj_fnSetVis(ifs_mpps2_dnas.dnasImg, 1)
		IFObj_fnSetVis(ifs_mpps2_dnas.dnasTM, 1)
		IFObj_fnSetVis(ifs_mpps2_dnas.buttons, 1)
		IFObj_fnSetVis(ifs_mpps2_dnas.errorText, 1)
	end

	-- Fix for 10993, 11067 - hide any popups, because the artists cannot be
	-- severed from their love of transparency. Two popups in the same
	-- space is unreadable. - NM 8/19/05
	if(Popup_Ok) then
		IFObj_fnSetVis(Popup_Ok, 1)
	end
	if(Popup_YesNo) then
		IFObj_fnSetVis(Popup_YesNo, 1)
	end
	if(Popup_YesNo_Large) then
		IFObj_fnSetVis(Popup_YesNo_Large, 1)
	end
	if(Popup_LoadSave2) then
		IFObj_fnSetVis(Popup_LoadSave2, 1)
	end
	if(Popup_Tutorial) then
		IFObj_fnSetVis(Popup_Tutorial, 1)
	end
	if(Popup_YesNo_Gamespy) then
		IFObj_fnSetVis(Popup_YesNo_Gamespy, 1)
	end
	if(Popup_Ask_Historical) then
		IFObj_fnSetVis(Popup_Ask_Historical, 1)
	end
	if(Popup_Ok_Large) then
		IFObj_fnSetVis(Popup_Ok_Large, 1)
	end
end

-- Starts a movie. Does nothing if already playing.  It's safe to omit
-- left/top/width/height if fullscreen is true.
function ifelem_shellscreen_fnStartMovie(movieName, loop, nextMovieName, fullscreen, left, top, width, height)
	
	if (movieName and not gMovieDisabled and 
		(gMovieAlwaysPlay or (ScriptCB_GetGameRules() ~= "metagame" and ScriptCB_GetGameRules() ~= "campaign"))) then
		-- setup full screen parameters
		if (fullscreen) then
			local right, bottom, b, w = ScriptCB_GetScreenInfo()
			if (fullscreen == 2) then
				-- fully visible in widescreen with bars on either side
				left   = right * (1 - 1/w) * 0.5
				top    = bottom * (1 - 1/w) * 0.5
				width  = right/w
				height = bottom/w
			else
				left   = 0
				top    = 0
				width  = right  - left
				height = bottom - top
			end
		end
		
		-- is another movie specified
		if (not nextMovieName) then
			nextMovieName = ""
		end

--		print("+++ ifelem_shellscreen_fnStartMovie:", movieName )
		
		-- if the movie isn't currently playing     
		if (not ScriptCB_AreMoviePropertiesPlaying(movieName)) then
			-- play it
			ScriptCB_PlayMovie(movieName, loop, nextMovieName, left, top, width, height)
		end    
	else
		gPrevMovie = movieName
	end
end

-- plays a sound
function ifelm_shellscreen_fnPlaySound(sound)
	if (sound) then 
		--print("PLAYSOUND " .. sound)
		ScriptCB_SndPlaySound(sound)
	end
end

-- 
function ifelem_shellscreen_fnPostError(this,bUserHitYes,ErrorLevel,ErrorMessage)
--	print("Default fnPostError(..,",bUserHitYes,ErrorLevel)
	if(ErrorLevel >= 6) then
		ScriptCB_PopScreen()
	end
end

-- Stops a movie, if playing.
function ifelem_shellscreen_fnStopMovie()
	if (not gMovieDisabled) then
		if (ScriptCB_IsMoviePlaying()) then
			ScriptCB_StopMovie()
		end
	end
end

function gIFShellScreenTemplate_CommonUpdate(this, fDt)
	local ErrorLevel,ErrorMessage = ScriptCB_GetLatestError()
	if(ErrorLevel > 0) then
		ScriptCB_OpenErrorBox(ErrorLevel,ErrorMessage)
	end
	
	-- every so often, flash one of the interface elements
	if( not this.nextFlashyTime or this.nextFlashyTime <= 0 ) then
		IFFlashyText_DoRandomFlashiness(this)
		this.nextFlashyTime = math.random() * 15 + 10
	end
	this.nextFlashyTime = this.nextFlashyTime - fDt
	
	if(this.buttons and this.buttons.FriendIcon and ScriptCB_GetFriendListIcon) then
		this.nextFriendIconUpdate = this.nextFriendIconUpdate - fDt
		if(this.nextFriendIconUpdate < 0) then
			this.nextFriendIconUpdate = 0.25 -- 1/4 second between updates
			local IconIdx = ScriptCB_GetFriendListIcon()
			local UVs = gXLFriendsEnum2UVs[IconIdx+1] -- lua counts from 1
			IFImage_fnSetUVs(this.buttons.FriendIcon,UVs.u,UVs.v,UVs.u+0.25,UVs.v+0.25)
		end
	end

	ScriptCB_UpdateScreen()
end

gFlashObj_CurSizeAdd = 0.5
gFlashObj_CurDir = 2

function FlashObj_fnHilight(this,fDt)
 		gFlashObj_CurSizeAdd = gFlashObj_CurSizeAdd + fDt * gFlashObj_CurDir
		if(gFlashObj_CurSizeAdd > 1) then
 			gFlashObj_CurSizeAdd = 1
			gFlashObj_CurDir = -math.abs(gFlashObj_CurDir)
		elseif (gFlashObj_CurSizeAdd < 0.3) then
 			gFlashObj_CurSizeAdd = 0.3
			gFlashObj_CurDir = math.abs(gFlashObj_CurDir)
		end

		IFObj_fnSetAlpha(this,gFlashObj_CurSizeAdd)
end

gMouseOverImage_Old = nil

-- Default for update function
function gIFShellScreenTemplate_fnUpdate(this, fDt)
	AnimationMgr_Update(fDt) -- always call this.

	local Button_CurSizeAdd = gButton_CurSizeAdd
	local Button_CurDir = gButton_CurDir

	-- flash image objects
	if( gMouseOverImage ) then
		if( gMouseOverImage.bIsFlashObj ) then
			gMouseOverImage_Old = gMouseOverImage
			FlashObj_fnHilight( gMouseOverImage, fDt )
		end
	elseif( gMouseOverImage_Old and gMouseOverImage_Old.bIsFlashObj ) then
		-- set alpha back
		IFObj_fnSetAlpha(gMouseOverImage_Old,gMouseOverImage_Old.flash_alpha)
		gMouseOverImage_Old = nil
	end

	if(gCurHiliteButton) then
		IFButton_fnHilight(gCurHiliteButton,1,fDt)
	end
	
	if(gCurHiliteButton2) then
		-- Restore entry values so we don't go at double-speed.
		gButton_CurSizeAdd = Button_CurSizeAdd
		gButton_CurDir = Button_CurDir
		IFButton_fnHilight(gCurHiliteButton2,1,fDt)
	end

	if(gCurHiliteButton3) then
		-- Restore entry values so we don't go at double-speed.
		gButton_CurSizeAdd = Button_CurSizeAdd
		gButton_CurDir = Button_CurDir
		IFButton_fnHilight(gCurHiliteButton3,1,fDt)
	end

	if(gCurHiliteButton4) then
		-- Restore entry values so we don't go at double-speed.
		gButton_CurSizeAdd = Button_CurSizeAdd
		gButton_CurDir = Button_CurDir
		IFButton_fnHilight(gCurHiliteButton4,1,fDt)
	end

	local Listbox_CurSizeAdd = gListbox_CurSizeAdd
	local Listbox_CurDir = gListbox_CurDir
	
	if(gCurEditbox) then
		IFEditbox_fnBounceCursor(gCurEditbox,fDt)
	end

	if(gCurHiliteListbox) then
		ListManager_fnHilight(gCurHiliteListbox,fDt)
	end
	if(gCurHiliteListbox2) then
		-- Restore entry values so we don't go at double-speed.
		gListbox_CurSizeAdd = Listbox_CurSizeAdd
		gListbox_CurDir = Listbox_CurDir
		ListManager_fnHilight(gCurHiliteListbox2,fDt)
	end

	gIFShellScreenTemplate_CommonUpdate(this, fDt)
end

--same as above but for a clickable button
function gIFShellScreenTemplate_fnMoveClickableButton(ObjToMove,TextToGetWidthFrom,xAdd)
	local fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(TextToGetWidthFrom)
	IFObj_fnSetPos(ObjToMove,xAdd+50-(fRight - fLeft),ObjToMove.y)
end

--centers the clickable button
function gIFShellScreenTemplate_fnCenterClickableButton(ObjToMove,TextToGetWidthFrom,xAdd,string)
	local fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(TextToGetWidthFrom)
	IFObj_fnSetPos(ObjToMove,xAdd-(fRight - fLeft)/2,ObjToMove.y)
	IFObj_fnCreateHotspot(TextToGetWidthFrom)
	IFText_fnSetTextBox(TextToGetWidthFrom,(fRight-fLeft),(fBot-fTop))
	IFText_fnSetString(TextToGetWidthFrom,string)
end

-- Default for Reactivate function
function gIFShellScreenTemplate_fnReactivate(this)
	-- Set currently hilighted button to whatever this screen has
	if(this.buttons and this.CurButton) then
		gCurHiliteButton = this.buttons[this.CurButton]
		if(gCurHiliteButton) then
			IFButton_fnSelect(gCurHiliteButton,1) -- make sure texture changesb
			IFButton_fnHilight(gCurHiliteButton,1,0)  -- hilight it, dt = 0
		end
	end
end

-- Default for enter function
function gIFShellScreenTemplate_fnEnter(this, bFwd)
	gCurAnimationList = nil -- clear all anims
	if(this.Helptext_Accept) and (gPlatformStr ~= "PC") then
		gHelptext_fnMoveIcon(this.Helptext_Accept)
	end

	if(this.title) then
		AnimationMgr_AddAnimation(this.title, { fStartAlpha = 0, fEndAlpha = 1,})
	end

	-- start flashiness for all the text elements
	IFFlashyText_StartFlashiness(this)	
	
	-- Always clear this value
	this.iLastXLiveSilentTimer = nil

	gCurScreenStr = this.ScreenName -- e.g. "ifs_main"
	gCurScreenTable = this

	-- Set currently hilighted button to whatever this screen has
	if(this.buttons and this.CurButton) then
		gCurHiliteButton = this.buttons[this.CurButton]
		if(gCurHiliteButton) then
			IFButton_fnSelect(gCurHiliteButton,1) -- make sure texture changesb
			IFButton_fnHilight(gCurHiliteButton,1,0)  -- hilight it, dt = 0
		end
	end
	
	if (bFwd) then
		ifelm_shellscreen_fnPlaySound(this.enterSound);
	else
		ifelm_shellscreen_fnPlaySound(this.exitSound);
	end
	
	if (this.music) then
		if (this.music == "STOP") then
			ScriptCB_SetShellMusic()
		else
			ScriptCB_SetShellMusic(this.music)
		end
	end
	
	ifelem_shellscreen_fnStartMovie(this.movieBackground, 1, nil, 1)
end

-- Default for exit function
function gIFShellScreenTemplate_fnLeave(this, bFwd)
	if(gCurHiliteButton) then
		IFButton_fnHilight(gCurHiliteButton,nil,0) -- unhilight it
		gCurHiliteButton = nil -- clear this.
	end
	
	gCurHiliteListbox = nil -- clear this also
end

function gIFShellScreenTemplate_fnInput_Back(this)
	ScriptCB_PopScreen()
end

function gIFShellScreenTemplate_fnHandleMouse(this, fMouseX, fMouseY)
	gHandleMouse(this,fMouseX,fMouseY)
end

-- Presented as a commented-out reference only. Use NewIFObj to actually make one.

-- -- On top of gIFScreenTemplate, does a nice background for the shell.
-- gIFShellScreenTemplate = {


-- 	enterSound      = "",                    -- played when the screen is entered forwards
-- 	exitSound       = "shell_menu_exit",     -- played when the screen is entered backwards
-- 	acceptSound     = "shell_menu_accept",   -- played when an option is accepted
-- 	cancelSound     = "shell_menu_cancel",   -- played when settings are cancelled
-- 	errorSound      = "shell_menu_error",    -- played when the selection is an error
-- 	selectSound     = "shell_select_change", -- played when menu selection changes
-- 	movieIntro      = nil,                   -- played before the screen is displayed
-- 	movieBackground = nil,                   -- played while the screen is displayed
-- 	music           = nil,                   -- music for the screen, setting this value to 
-- 	-- "STOP" stops background music for this screen
	
	

-- 	-- bWasAcceptOnBack will be non-nil when the user hit the accept
-- 	-- button on the "Back" button. Probably most useful in determining
-- 	-- which sfx to play.
-- 	Input_Back = function(this,bFromButtonPress)
-- 								 ScriptCB_PopScreen()
-- 							 end,

-- 	Enter = gIFShellScreenTemplate_fnEnter,
-- 	Leave = gIFShellScreenTemplate_fnLeave,
-- 	Update = gIFShellScreenTemplate_fnUpdate,
-- 	fnPostError = ifelem_shellscreen_fnPostError,

-- 	HandleMouse = function(this, fMouseX, fMouseY)
-- 		gHandleMouse(this,fMouseX,fMouseY)
-- 	end
-- }

-- Adds a background image to a screen. MUST be called before AddIFScreen(this)
function ifelem_shellscreen_fnAddBackground(this, TextureName)
	this.bg = nil -- remove any previous background
	this.bg = NewIFImage { 
		ScreenRelativeX = 0,
		ScreenRelativeY = 0,
		UseSafezone = 0,
		ZPos = 255, -- behind all.

		texture = TextureName, 
		localpos_l = 0,
		localpos_t = 0,
		-- Size, UVs aren't fully specified here, but a few lines down
		inert = 1, -- Delete this out of lua once created (we'll never touch it again)
	}
	
	-- Ask game for screen size, fill in values
	local r,b,v,w
	r,b,v,w=ScriptCB_GetScreenInfo()
	this.bg.localpos_r = r * w
	this.bg.localpos_b = b
	this.bg.uvs_b = v
end

function NewIFShellScreen_common(temp,Template)
	if(Template.bg_texture and (ScriptCB_GetShellActive())) then
		ifelem_shellscreen_fnAddBackground(temp, Template.bg_texture)
	else
		temp.bg = nil
	end

	if(Template.bDimBackdrop) then
		Template.bDimBackdrop = nil -- clear flag
		w,h,v,widescreen=ScriptCB_GetScreenInfo()
		
		-- Make semitransparent 
		temp.DimBackground = NewIFImage 
		{
				UseSafezone = 0,
				ZPos = 255,
			ScreenRelativeX = 0.5,
			ScreenRelativeY = 0.5,
--				alpha = 1,
--				x = 0,  --centered on the x
--  				y = 0,
 				localpos_l = w * -1.0,
 				localpos_t = h * -0.5,
 				localpos_r = w *  1.0,
 				localpos_b = h *  0.5,
 				uvs_b = v,
				texture = "opaque_black",
				ColorR = 0, ColorG = 0, ColorB = 0, -- black
		}
	end

	-- Add a friends icon if requested. Screen is responsible for moving it
	-- later.
	if(Template.bFriendsIcon) then
		local IconSize = ScriptCB_GetFontHeight("gamefont_medium") * 1.2

		temp.buttons.FriendIcon = NewIFImage { 
			texture = "lobby_icons", 
			localpos_l = 0, localpos_t = 4, 
			localpos_b = IconSize + 4, localpos_r = IconSize,
			bInertPos = 1,
			ZPos = 10, -- on top of almost everything
		}
		temp.nextFriendIconUpdate = 0 -- update ASAP on entry
	end

	-- Helptext icons show up only on consoles
	if(gPlatformStr ~= "PC") then
		if((not Template.bNohelptext) and (not Template.bNohelptext_back)) then
			temp.Helptext_Back = NewHelptext {
				ScreenRelativeX = 0.0, -- left
				ScreenRelativeY = 1.0, -- bottom
				y = -15, -- just above bottom
				x = 0,
				buttonicon = "btnb",
				string = "common.back",
			}
		end -- should have a back icon

		if((not Template.bNohelptext) and (not Template.bNohelptext_accept)) then
			temp.Helptext_Accept = NewHelptext {
				ScreenRelativeX = 1.0, -- right
				ScreenRelativeY = 1.0, -- bottom
				y = -15, -- just above bottom of screen
				x = 0,
				buttonicon = "btna",
				string = "common.accept",
				bRightJustify = 1,
			}

			if(Template.bAcceptIsSelect) then
				Template.bAcceptIsSelect = nil
				IFText_fnSetString(temp.Helptext_Accept.helpstr, "common.select")
			end

		end  -- should have an accept icon
	else -- this is a PC build
		if((not Template.bNohelptextPC) and (not Template.bNohelptext_backPC)) then
			local BackButtonW = 150 -- made 130 to fix 6198 on PC - NM 8/18/04
			local BackButtonH = 25

			temp.Helptext_Back = NewPCIFButton
			{
				ScreenRelativeX = 0.0, -- left
				ScreenRelativeY = 1.0, -- bottom
				y = -15, -- just above bottom
				x = BackButtonW * 0.5,
				btnw = BackButtonW, 
				btnh = BackButtonH,
				font = "gamefont_medium", 
				bg_tail = 20,
				tag = "_back",
			} -- end of Helptext_Back
			
			RoundIFButtonLabel_fnSetString(temp.Helptext_Back,"common.back")
		end -- should have a back icon
	end 
end


-- Default for update function
function gIFShellScreenTemplate2_fnUpdate(this, fDt)
	AnimationMgr_Update(fDt) -- always call this.

	if(gCurHiliteButton2) then
		IFButton_fnHilight(gCurHiliteButton2,1,fDt)
	end
	if(gCurHiliteListbox2) then
		ListManager_fnHilight(gCurHiliteListbox2,fDt)
	end

	gIFShellScreenTemplate_CommonUpdate(this, fDt)
end

-- Default for Reactivate function
function gIFShellScreenTemplate2_fnReactivate(this)
	-- Set currently hilighted button to whatever this screen has
	if(this.CurButton) then
		gCurHiliteButton2 = this.buttons[this.CurButton]
		if(gCurHiliteButton2) then
			IFButton_fnSelect(gCurHiliteButton2,1) -- make sure texture changes
			IFButton_fnHilight(gCurHiliteButton2,1,0)  -- hilight it, dt = 0
		end
	end
end

-- Default for enter function
function gIFShellScreenTemplate2_fnEnter(this)
	if(this.Helptext_Accept) and (gPlatformStr ~= "PC") then
		gHelptext_fnMoveIcon(this.Helptext_Accept)
	end

	if(this.buttons) then
		AnimationMgr_AddAnimation(this.buttons, { fStartAlpha = 0, fEndAlpha = 1,})
	end
	if(this.listbox) then
		AnimationMgr_AddAnimation(this.listbox, { fStartAlpha = 0, fEndAlpha = 1,})
	end
	if(this.title) then
		AnimationMgr_AddAnimation(this.title, { fStartAlpha = 0, fEndAlpha = 1,})
	end

	-- Set currently hilighted button to whatever this screen has
	if(this.CurButton) then
		gCurHiliteButton2 = this.buttons[this.CurButton]
		if(gCurHiliteButton2) then
			IFButton_fnSelect(gCurHiliteButton2,1) -- make sure texture changes
			IFButton_fnHilight(gCurHiliteButton2,1,0)  -- hilight it, dt = 0
		end
	end
end

-- Default for enter function
function gIFShellScreenTemplate2_fnLeave(this)
	if(gCurHiliteButton2) then
		IFButton_fnHilight(gCurHiliteButton2,nil,0) -- unhilight it
		gCurHiliteButton2 = nil -- clear this.
	end
	gCurHiliteListbox2 = nil -- clear this also
end

-- Mouse-helper functions. These return a bool as to whether they did
-- all the work or not
function gShellScreen_fnDefaultInputAccept(this, bSkipListBox)
	if(gMouseListBoxSlider) then
		ListManager_fnScrollbarClick(gMouseListBoxSlider)
		return 1 -- note we did all the work
	end

	-- Clicking on editboxes does zilch (clicks outside of current
	-- editbox are ignored
	if((gCurEditbox) and (gCurEditbox.bMouseover)) then
		return 1 -- note we did all the work
	end

	-- If the current editbox is sticky, but a different one is clicked
	-- on, then switch focus
	if(gCurEditbox and gCurEditbox.bStickyFocus and gMouseOverEditbox) then
		IFEditbox_fnHilight(gCurEditbox, nil)
		gCurEditbox = gMouseOverEditbox
		IFEditbox_fnHilight(gCurEditbox, 1)
	end


	if((not bSkipListBox) and gMouseListBox) then
		ScriptCB_SndPlaySound("shell_select_change")
		gMouseListBox.Layout.SelectedIdx = gMouseListBox.Layout.CursorIdx
		ListManager_fnFillContents(gMouseListBox,gMouseListBox.Contents,gMouseListBox.Layout)
		return 1 -- note we did all the work
	end
	
	if((this.CurButton) and (this.CurButton == "_back")) then
		this:Input_Back()
		return 1 -- note we did all the work
	end
	
	return nil -- didn't do any work
end

function gShellScreen_fnDefaultInputUp(this)
	-- Clicking on editboxes does zilch
	if(gCurEditbox) then
		return 1 -- note we did all the work
	end

	if(gMouseListBox) then
		ListManager_fnNavUp(gMouseListBox,gMouseListBox.Contents,gMouseListBox.Layout)
		return 1 -- note we did all the work
	end

	return nil -- didn't do any work
end

function gShellScreen_fnDefaultInputDown(this)
	-- Clicking on editboxes does zilch
	if(gCurEditbox) then
		return 1 -- note we did all the work
	end

	if(gMouseListBox) then
		ListManager_fnNavDown(gMouseListBox,gMouseListBox.Contents,gMouseListBox.Layout)
		return 1 -- note we did all the work
	end

	return nil -- didn't do any work
end

-- For button presses, follow link if applicable, activate as necessary
function gDefault_Input_GeneralUp(this)
	-- If base class handled this work, then we're done
	if(gShellScreen_fnDefaultInputUp(this)) then
		return
	end

	if this.buttons then
		this.CurButton = FollowButtonLink(this.buttons,this.CurButton,"link_up")
		gCurHiliteButton = this.buttons[this.CurButton]
	end
end

function gDefault_Input_GeneralDown(this)
	-- If base class handled this work, then we're done
	if(gShellScreen_fnDefaultInputDown(this)) then
		return
	end

	if this.buttons then
		this.CurButton = FollowButtonLink(this.buttons,this.CurButton,"link_down")
		gCurHiliteButton = this.buttons[this.CurButton]
	end
end

function gDefault_Input_GeneralRight(this)
	if this.buttons then
		this.CurButton = FollowButtonLink(this.buttons,this.CurButton,"link_right")
		gCurHiliteButton = this.buttons[this.CurButton]
	end
end

function gDefault_Input_GeneralLeft(this)
	if this.buttons then
		this.CurButton = FollowButtonLink(this.buttons,this.CurButton,"link_left")
		gCurHiliteButton = this.buttons[this.CurButton]
	end
end

function gDefault_Input_GeneralUp2(this)
	-- If base class handled this work, then we're done
	if(gShellScreen_fnDefaultInputUp(this)) then
		return
	end

	if this.buttons then
		this.CurButton = FollowButtonLink(this.buttons,this.CurButton,"link_up")
		gCurHiliteButton2 = this.buttons[this.CurButton]
	end
end

function gDefault_Input_GeneralDown2(this)
	-- If base class handled this work, then we're done
	if(gShellScreen_fnDefaultInputDown(this)) then
		return
	end

	if this.buttons then
		this.CurButton = FollowButtonLink(this.buttons,this.CurButton,"link_down")
		gCurHiliteButton2 = this.buttons[this.CurButton]
	end
end

function gDefault_Input_GeneralRight2(this)
	if this.buttons then
		this.CurButton = FollowButtonLink(this.buttons,this.CurButton,"link_right")
		gCurHiliteButton2 = this.buttons[this.CurButton]
	end
end

function gDefault_Input_GeneralLeft2(this)
	if this.buttons then
		this.CurButton = FollowButtonLink(this.buttons,this.CurButton,"link_left")
		gCurHiliteButton2 = this.buttons[this.CurButton]
	end
end


-- Wrapper around NewIFScreen, makes a shell-screen w/ fancy
-- background, etc.
function NewIFShellScreen(Template)
	local temp = Template

	temp.enterSound = temp.enterSound or "" -- played when the screen is entered forwards
	temp.exitSound = temp.exitSound or "shell_menu_exit" -- played when the screen is entered backwards
	temp.acceptSound = temp.acceptSound or "shell_menu_accept"   -- played when an option is accepted
	temp.cancelSound = temp.cancelSound or "shell_menu_cancel"   -- played when settings are cancelled
	temp.errorSound = temp.errorSound or "shell_menu_error" -- played when the selection is an error
	temp.selectSound = temp.selectSound or "shell_select_change" -- played when menu selection changes
	temp.movieIntro = nil -- DISABLED NM 3/24/05 temp.movieIntro or nil -- played before the screen is displayed
	temp.movieBackground = temp.movieBackground or nil -- played while the screen is displayed
	temp.music = temp.music or nil                   -- music for the screen, setting this value to 
	-- "STOP" stops background music for this screen

	temp.Enter = temp.Enter or gIFShellScreenTemplate_fnEnter
	temp.Reactivate = temp.Reactivate or gIFShellScreenTemplate_fnReactivate
	temp.Leave = temp.Leave or gIFShellScreenTemplate_fnLeave
	temp.Update = temp.Update or gIFShellScreenTemplate_fnUpdate
	temp.fnPostError = temp.fnPostError or ifelem_shellscreen_fnPostError
	temp.Input_Back = temp.Input_Back or gIFShellScreenTemplate_fnInput_Back
	temp.type = "screen"

	if(gPlatformStr == "PC") then
		temp.HandleMouse = temp.HandleMouse or gIFShellScreenTemplate_fnHandleMouse
	end

	NewIFShellScreen_common(temp,Template)

	temp.Input_GeneralUp = temp.Input_GeneralUp or gDefault_Input_GeneralUp
	temp.Input_GeneralRight = temp.Input_GeneralRight or gDefault_Input_GeneralRight
	temp.Input_GeneralDown = temp.Input_GeneralDown or gDefault_Input_GeneralDown
	temp.Input_GeneralLeft = temp.Input_GeneralLeft or gDefault_Input_GeneralLeft

	temp.fnPostMissingController = temp.fnPostMissingController or ifelem_shellscreen_fnPostControllerError

	return temp
end


gIFScreenTemplate2 = {
	-- For button presses, follow link if applicable, activate as necessary

}

-- Makes a second ifscreen for the bottom
function NewIFShellScreen2(Template)
	local temp = Template

	temp.Enter = temp.Enter or gIFShellScreenTemplate2_fnEnter
	temp.Reactivate = temp.Reactivate or gIFShellScreenTemplate2_fnReactivate
	temp.Leave = temp.Leave or gIFShellScreenTemplate2_fnLeave
	temp.Update = temp.Update or gIFShellScreenTemplate2_fnUpdate
	temp.fnPostError = temp.fnPostError or ifelem_shellscreen_fnPostError
	temp.Input_Back = temp.Input_Back or gIFShellScreenTemplate_fnInput_Back
	if(gPlatformStr == "PC") then
		temp.HandleMouse = temp.HandleMouse or gIFShellScreenTemplate_fnHandleMouse
	end
	temp.type = "screen"

	NewIFShellScreen_common(temp,Template)

	temp.Input_GeneralUp = temp.Input_GeneralUp or gDefault_Input_GeneralUp2
	temp.Input_GeneralRight = temp.Input_GeneralRight or gDefault_Input_GeneralRight2
	temp.Input_GeneralDown = temp.Input_GeneralDown or gDefault_Input_GeneralDown2
	temp.Input_GeneralLeft = temp.Input_GeneralLeft or gDefault_Input_GeneralLeft2
	temp.fnPostMissingController = temp.fnPostMissingController or ifelem_shellscreen_fnPostControllerError

	return temp
end



gScrnW,gScrnH = ScriptCB_GetScreenInfo()
gSafeW,gSafeH = ScriptCB_GetSafeScreenInfo()

