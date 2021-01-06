--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Handles 2-way XBox splitscreen picking (out of 4 controllers),
-- and XLive signin.

-- Internal mode definitions for this screen, stored in this.Mode[i]
-- 
-- -1: "loading profile list" - everything hidden
-- 0: 'Press Start' mode
-- 1: In login account list (BF2's list of accounts)
-- 2: On XLive account list
-- 3: XLive entering passcode
-- 4: Ready (login done), 
-- 5: Popup (load profiles or XLive signin) is active, so hide everything

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_split2_profile_listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, 
		y = layout.y - 10,
	}

	local UseFont = ifs_split2_profile_listbox_layout[1].font

	Temp.NameStr = NewIFText{
		x = 10, y = 2,
		halign = "left", font = UseFont, 
		textw = layout.width - 20, nocreatebackground=1,
		startdelay=math.random()*0.5, 
	}
	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_split2_profile_listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	if(Data) then
		-- Blank the data
		if(not Data.showstr2) then
--			print("Uhoh. No showstr2 from ", Data.showstr)
		else
			IFText_fnSetUString(Dest.NameStr,Data.showstr2)
		end
		if(Data.bDim) then
			IFObj_fnSetColor(Dest.NameStr,128,128,128)
		elseif (Data.bGuest) then
			IFObj_fnSetColor(Dest.NameStr,251,241,173)
		else
			IFObj_fnSetColor(Dest.NameStr, iColorR, iColorG, iColorB)
			IFObj_fnSetAlpha(Dest.NameStr, fAlpha)
		end
	else
		-- Blank the data
		IFText_fnSetString(Dest.NameStr,"")
	end
	IFObj_fnSetVis(Dest, Data)
end

ifs_split2_profile_listbox_contents = {
}

-- Duplicated layout items, as the selected item in each listbox will
-- be placed in it.
ifs_split2_profile_listbox_layout = {
	{
		font = "gamefont_medium",
		showcount = 4,
		yHeight = 26, -- per item
		ySpacing = 0,
--		width = ifs_login_listbox_layout.width, -- set in fnBuildScreen
		slider = 1,
		CreateFn = ifs_split2_profile_listbox_CreateItem,
		PopulateFn = ifs_split2_profile_listbox_PopulateItem,
	},
	{
		showcount = 4,
		yHeight = 26, -- per item
		ySpacing = 0,
--		width = ifs_login_listbox_layout.width, -- set in fnBuildScreen
		slider = 1,
		bInstance2 = 1, -- Use alternate cursor hilight object
		CreateFn = ifs_split2_profile_listbox_CreateItem,
		PopulateFn = ifs_split2_profile_listbox_PopulateItem,
	},
} -- ifs_split2_profile_listbox_layout

-- Helper function: gets xlive login string for specified viewport,
-- including "guest of", etc. Returns a *Unicode* string.
function ifs_split2_profile_fnGetXLiveLoginName(this, iViewport)
	local iJoystick

--	print("In fnGetXLiveLoginName(",this, iViewport)

	if(iViewport == this.iPrimaryIdx) then
		iJoystick = this.iPrimaryPort
--		print("Path1, iPrimary = ", iJoystick)
	else
		iJoystick = this.iSecondaryPort
--		print("Path2, iSecondary = ", iJoystick)
		if(not iJoystick) then
			ifs_split2_profile_fnTranslateJoystick(this, -10)
			iJoystick = this.iSecondaryPort
--			print("Path2A, iSecondary = ", iJoystick)
		end
	end

	local LoginStr = ScriptCB_XL_GetLoginName(iJoystick)
	return ScriptCB_tounicode(LoginStr)
-- 	local LoginNoGuestStr = ScriptCB_XL_GetLoginName(iJoystick, 1) -- returns nil if guest
-- 	if(LoginNoGuestStr) then
-- 		-- Logged in as a full user.
-- 		return ScriptCB_tounicode(LoginNoGuestStr)
-- 	else
-- 		return ScriptCB_usprintf("xlive.guestof", LoginStr)
-- 	end
end

-- Helper function: turns pieces on/off, updates text, etc.
function ifs_split2_profile_fnUpdateScreen(this, bPopupOpen)
	local i,j

	-- Initial pass: if a popup is open, then turn off everything and
	-- bail.
	if(bPopupOpen) then
		for i=1,this.iMaxControllers do
			IFObj_fnSetVis(this.Message[i], nil)
			IFObj_fnSetVis(this.ProfileName[i], nil)
			IFObj_fnSetVis(this.pwd_title[i], nil)
			IFObj_fnSetVis(this.pwd_string[i], nil)
			IFObj_fnSetVis(this.pressstart[i], nil)
			IFObj_fnSetVis(this.Profile[i], nil)

			IFObj_fnSetVis(this.CreateGroup[i], nil)
			IFObj_fnSetVis(this.GuestGroup[i], nil)
		end
		-- Hide top player's help icons
		IFObj_fnSetVis(this.AcceptGroup[1], nil)
		IFObj_fnSetVis(this.BackGroup[1], nil)
		IFObj_fnSetVis(this.horizline, nil)
		return
	end

	-- Always re-enable horizline
	IFObj_fnSetVis(this.horizline, 1)
--	print("In fnUpdateScreen. Modes = ", this.Mode[1], this.Mode[2])

	local bAllReady = 1
	for i=1,this.iMaxControllers do
		bAllReady = bAllReady and (this.Mode[i] == 2) -- keep track of this

		-- 'Back' button is always hidden if loading things.
		if(this.Mode[1] == -1 or this.Mode[1] == 5) then
			IFObj_fnSetVis(this.BackGroup[i],nil)
		else
			IFObj_fnSetVis(this.BackGroup[i],this.Mode[i] >= 1)
		end

		IFObj_fnSetVis(this.ProfileName[i],this.Mode[i] == 4)
		if (this.Mode[i] == 4) then
			
			IFText_fnSetUString(this.ProfileName[i], ifs_split2_profile_fnGetXLiveLoginName(this,i))
		end

		IFObj_fnSetVis(this.AcceptGroup[i], (this.Mode[i] == 1) or (this.Mode[i] == 2) or (this.Mode[i] == 3))
		-- Turn 'Accept' text for primary player when all players are ready
		if((this.Mode[i] >= 4) and (i == this.iPrimaryIdx) and ifs_split2_profile_fnOkToLaunch(this)) then
			IFObj_fnSetVis(this.AcceptGroup[i],1)
		end

		IFObj_fnSetVis(this.CreateGroup[i],(this.Mode[i] == 2) or (this.Mode[i] == 4))
		-- Primary can never log in as guest - BF2 bug 3602
		IFObj_fnSetVis(this.GuestGroup[i],(this.Mode[i] == 2) and (this.Mode[3-i] == 4) and (i ~= this.iPrimaryIdx))

		-- Message text shows in modes 0(Press Start), 2(Ready). Change text as needed.
		IFObj_fnSetVis(this.Message[i],(this.Mode[i] == 0) or (this.Mode[i] == 4))
		if (this.Mode[i] == 0) then
			IFText_fnSetString(this.Message[i],"ifs.split.starttojoin")
		else
			IFText_fnSetString(this.Message[i],"ifs.split.ready")
		end

		-- But, if # of controllers is too low, override the message.
		if((i ~= this.iPrimaryIdx) and (not this.iSecondaryPort)) then
--			print("Secondary. # controllers = ", ScriptCB_GetNumControllers())
			if(ScriptCB_GetNumControllers() < 2) then
				IFText_fnSetString(this.Message[i],"ifs.split.needs2controllers")
			end
		end

		-- Profile box shows when in mode 1(login Listbox) or mode 2(xlive listbox)
		IFObj_fnSetVis(this.Profile[i], (this.Mode[i] == 1) or (this.Mode[i] == 2))

		-- Fill in listboxes as well
		if(this.Mode[i] == 1) then
			ifs_split2_profile_listbox_layout[i].SelectedIdx = ifs_split2_profile_listbox_layout[i].LoginSelectedIdx
			ifs_split2_profile_fnCalcDim(this, i)
			ifs_split2_profile_listbox_layout[i].CursorIdx = ifs_split2_profile_listbox_layout[i].SelectedIdx

			ListManager_fnFillContents(this.Profile[i].listbox,ifs_split2_profile_listbox_contents,ifs_split2_profile_listbox_layout[i]) -- sets selected listbox item
			ifs_split2_profile_listbox_layout[i].LoginSelectedIdx = ifs_split2_profile_listbox_layout[i].SelectedIdx

		elseif (this.Mode[i] == 2) then

			if(table.getn(ifs_mpxl_login_listbox_contents) > 0) then
				ifs_split2_profile_listbox_layout[i].XLiveSelectedIdx = ifs_split2_profile_listbox_layout[i].XLiveSelectedIdx or 1
			else
				ifs_split2_profile_listbox_layout[i].XLiveSelectedIdx = nil
			end

			ifs_split2_profile_fnCalcGuest(this, i)
			ifs_split2_profile_listbox_layout[i].SelectedIdx = ifs_split2_profile_listbox_layout[i].XLiveSelectedIdx
			ifs_split2_profile_listbox_layout[i].CursorIdx = ifs_split2_profile_listbox_layout[i].SelectedIdx
--			print("Mode 2. Listbox has ", table.getn(ifs_mpxl_login_listbox_contents), " items")
			ListManager_fnFillContents(this.Profile[i].listbox, ifs_mpxl_login_listbox_contents,
																 ifs_split2_profile_listbox_layout[i]) -- sets selected listbox item
			ifs_split2_profile_listbox_layout[i].XLiveSelectedIdx = ifs_split2_profile_listbox_layout[i].SelectedIdx

			ifs_split2_profile_listbox_layout[i].XLiveName = nil -- clear this
			if(table.getn(ifs_mpxl_login_listbox_contents) > 0) then
				local Selection = ifs_mpxl_login_listbox_contents[ifs_split2_profile_listbox_layout[i].SelectedIdx]
				if(Selection) then
					ifs_split2_profile_listbox_layout[i].XLiveName = Selection.showstr
				end
			end

--			gCurHiliteListbox[i] = nil
		end

		if(i == this.iPrimaryIdx) then
			IFObj_fnSetVis(this.pressstart[i], ifs_split2_profile_fnOkToLaunch(this))
		else
			IFObj_fnSetVis(this.pressstart[i], nil) -- everyone else hides this
		end

		IFObj_fnSetVis(this.pwd_title[i], (this.Mode[i] == 3))
		IFObj_fnSetVis(this.pwd_string[i], (this.Mode[i] == 3))
		if(this.Mode[i] == 3) then
			local ShowUStr = ScriptCB_usprintf("ifs.pickacct.enterpass",ifs_split2_profile_listbox_layout[i].XLiveName)
			IFText_fnSetUString(this.pwd_title[i],ShowUStr)
			-- Update passcode string
			local ShowStr = string.rep("#", string.len(ifs_split2_profile_listbox_layout[i].CurPassword))	
			IFText_fnSetString(this.pwd_string[i],ShowStr)
		end
	end

	-- And, set some other parameters
	ScriptCB_SetNoticeNoCable((this.Mode[1] > 3) or (this.Mode[2] > 3))
	ScriptCB_TrackLoginErrors((this.Mode[1] > 3) or (this.Mode[2] > 3))
end

-- Callbacks from the "Reboot to create an account" popup. If bResult
-- is true, they selected 'yes'
function ifs_split2_profile_fnRebootPopupDone(bResult)
	local this = ifs_split2_profile
	if(bResult) then
		ScriptCB_XB_Reboot("XLD_LAUNCH_DASHBOARD_NEW_ACCOUNT_SIGNUP");
	end

	-- Close off popup no matter what choice they made
	ifs_split2_profile_fnUpdateScreen(this)
end

-- Returns -1, 0, or 1, depending on error, busy, or success
function ifs_split2_profile_fnLogoutCheckDone()
	local this = ifs_split2_profile
	return ScriptCB_IsLoginDone(this.iPrimaryPort)
end

function ifs_split2_profile_fnLogoutOnSuccess()
--	print("ifs_split2_profile_fnXLOnSuccess()")
	local this = ifs_split2_profile
	Popup_Busy:fnActivate(nil)
	ifs_split2_profile_fnUpdateScreen(this)
end

function ifs_split2_profile_fnLogoutOnFail()
--	print("ifs_split2_profile_fnXLOnFail()")
	local this = ifs_split2_profile
	Popup_Busy:fnActivate(nil)
	ifs_split2_profile_fnUpdateScreen(this)
end

-- User hit cancel. Do what they want.
function ifs_split2_profile_fnLogoutOnCancel()
--	print("ifs_split2_profile_fnXLOnCancel()")
	local this = ifs_split2_profile
	Popup_Busy:fnActivate(nil)
	ifs_split2_profile_fnUpdateScreen(this)
end

-- Callbacks from the "Really signout?" popup. If bResult is true,
-- they selected 'yes'
function ifs_split2_profile_fnLogoutPopupDone(bResult)
	local this = ifs_split2_profile

	local bPopupOpen = nil

--	print("fnLogoutPopupDone, line 222")
	if(bResult) then
		-- Refresh who's logged into what
--		print("popupdone line 224")
		ifs_split2_profile_fnGetLoginNames(this)

--		print("popupdone line 227")

		-- They really want to kill the login
		this.Mode[this.iSignoutPort] = 2 -- back to picking XLive account
		if(this.iSignoutPort == this.iPrimaryIdx) then
			ScriptCB_CancelLogin() -- cancel all logins
		else
--			print("Popupdone L309")
			ScriptCB_CancelLogin(this.iSecondaryPort) -- cancel just the secondary player

			Popup_Busy.fnCheckDone = ifs_split2_profile_fnLogoutCheckDone
			Popup_Busy.fnOnSuccess =  ifs_split2_profile_fnLogoutOnSuccess
			Popup_Busy.fnOnFail =  ifs_split2_profile_fnLogoutOnFail
			Popup_Busy.fnOnCancel =  ifs_split2_profile_fnLogoutOnCancel
			Popup_Busy.bNoCancel = 1 -- HIDE cancel button
			Popup_Busy.fTimeout = 15 -- seconds
--			print("Popupdone L318")
			IFText_fnSetString(Popup_Busy.title,"ifs.subHardDrive.busy")
--			print("Popupdone L320")
			Popup_Busy:fnActivate(1)
--			print("Popupdone L322")
			bPopupOpen = 1
		end

--		print("popupdone line 233")

	else
		-- bResult is false, therefore staying here
		this.iSignoutPopAtEnd = nil -- clear this
		this.iSignoutPort = nil
	end

--	print("fnLogoutPopupDone, line 250")

	ifs_split2_profile_fnGetLoginNames(this)
	ifs_split2_profile_fnUpdateScreen(this, bPopupOpen)

--	print("fnLogoutPopupDone, line 254")

	if(this.iSignoutPopAtEnd) then
		this.iSignoutPopAtEnd = nil
		ScriptCB_PopScreen()
	end

end

-- Helper function. For the given player idx, turns on/off the bDim
-- attribute in the ifs_split2_profile_listbox_contents[] array.
function ifs_split2_profile_fnCalcDim(this, aIdx)
	local j

	-- First, undim all.
	for j=1,table.getn(ifs_split2_profile_listbox_contents) do
		ifs_split2_profile_listbox_contents[j].bDim = nil
		-- And, dupe name. XLive guests stuff replaces this.
		ifs_split2_profile_listbox_contents[j].showstr2 = ifs_split2_profile_listbox_contents[j].showstr
	end

	-- Now, dim out everything that's locked out
	for j=1,this.iMaxControllers do
		local selIdx = ifs_split2_profile_listbox_layout[j].LoginSelectedIdx
		if((j ~= aIdx) and (this.Mode[j] >= 2) and selIdx) then
--			print("For ",aIdx, "Dimming idx ", selIdx)
			ifs_split2_profile_listbox_contents[selIdx].bDim = 1
		end
	end
end

-- Helper function. For the given player idx, turns on/off the bDim
-- attribute in the ifs_split2_profile_listbox_contents[] array.
function ifs_split2_profile_fnCalcGuest(this, aIdx)
	local j

	if(this.bNeedRegetXLNames) then
		this.bNeedRegetXLNames = nil
		ifs_split2_profile_fnGetLoginNames(this)
	end

	-- First, clear guest flag on all items
	for j=1,table.getn(ifs_mpxl_login_listbox_contents) do

		if((ifs_mpxl_login_listbox_contents[j].showstr == ifs_split2_profile_listbox_layout[1].XLiveLogin) or
			 (ifs_mpxl_login_listbox_contents[j].showstr == ifs_split2_profile_listbox_layout[2].XLiveLogin)) then
			-- Primary can never log in as guest - BF2 bug 3602
			if(aIdx == this.iPrimaryIdx) then
				ifs_mpxl_login_listbox_contents[j].showstr2 = ifs_mpxl_login_listbox_contents[j].showstr
				ifs_mpxl_login_listbox_contents[j].bDim = 1
			else
				ifs_mpxl_login_listbox_contents[j].showstr2 = ScriptCB_usprintf("xlive.guestof", ifs_mpxl_login_listbox_contents[j].showstr)
				ifs_mpxl_login_listbox_contents[j].bGuest = 1
				ifs_mpxl_login_listbox_contents[j].bDim = nil
			end
		else
			-- This account isn't already logged in. 
			ifs_mpxl_login_listbox_contents[j].bGuest = nil
			ifs_mpxl_login_listbox_contents[j].showstr2 = ifs_mpxl_login_listbox_contents[j].showstr
			ifs_mpxl_login_listbox_contents[j].bDim = nil
		end
	end

end

-- Helper function: calculates if we could launch with the current setup.
-- Returns a bool.
function ifs_split2_profile_fnOkToLaunch(this)
	local i
	local bAllReady = 1
	local iNumReady = 0
	for i=1,this.iMaxControllers do
		if(this.Mode[i] == 4) then
			iNumReady = iNumReady + 1
		end
		
		bAllReady = bAllReady and ((this.Mode[i] == 0) or (this.Mode[i] == 4))
	end
	
	if (ifs_main.CurButton == "mp") then
		-- multi player game
		-- it's ok if only one player
		bAllReady = bAllReady and (iNumReady >= 1)
	else
		-- single player game
		bAllReady = bAllReady and (iNumReady > 1) -- must have multiple ready to launch
	end
	
	return bAllReady, iNumReady
end

-- Returns -1, 0, or 1, depending on error, busy, or success
function ifs_split2_profile_fnXLCheckDone()
	local this = ifs_split2_profile
	return ScriptCB_IsLoginDone(this.iLoginJoystick)
end

function ifs_split2_profile_fnXLOnSuccess()
--	print("ifs_split2_profile_fnXLOnSuccess()")
	local this = ifs_split2_profile
	Popup_Busy:fnActivate(nil)

	this.Mode[this.iLoginPort] = 4 -- ready

	-- Reacquire XLive login names
	ifs_split2_profile_fnGetLoginNames(this)

	-- Restore screen
	ifs_split2_profile_fnUpdateScreen(this)

	if (this.iSignoutPopAtEnd) then
		this.iSignoutPopAtEnd = nil
		ScriptCB_PopScreen()
	elseif (this.bForwardOnSignin) then
		this.bForwardOnSignin = nil
		ifs_split2_profile_fnAccept(this, this.iPrimaryIdx)
	else
		-- Stay here, wait for user to manually advance
	end
end

function ifs_split2_profile_fnXLOnFail()
--	print("ifs_split2_profile_fnXLOnFail()")
	local this = ifs_split2_profile

	this.Mode[this.iLoginPort] = 2 -- back to XLive login list

	-- Reacquire XLive login names
	ifs_split2_profile_fnGetLoginNames(this)

	Popup_Busy:fnActivate(nil)
	-- Restore screen
	ifs_split2_profile_fnGetLoginNames(this)
	ifs_split2_profile_fnUpdateScreen(this)

	if(this.iSignoutPopAtEnd) then
		this.iSignoutPopAtEnd = nil
		ScriptCB_PopScreen()
	end
end

-- User hit cancel. Do what they want.
function ifs_split2_profile_fnXLOnCancel()
--	print("ifs_split2_profile_fnXLOnCancel()")
	local this = ifs_split2_profile

	-- Stop logging in.
	ScriptCB_CancelLogin(this.iLoginJoystick)

	-- Reacquire XLive login names
	ifs_split2_profile_fnGetLoginNames(this)

	this.Mode[this.iLoginPort] = 2 -- back to login list

	-- Get rid of popup, turn this screen back on
	Popup_Busy:fnActivate(nil)
	-- Restore screen
	ifs_split2_profile_fnGetLoginNames(this)
	ifs_split2_profile_fnUpdateScreen(this)

	if(this.iSignoutPopAtEnd) then
		this.iSignoutPopAtEnd = nil
		ScriptCB_PopScreen()
	end
end

function ifs_split2_profile_fnStartXLLogin(this, iJoystick)
	ScriptCB_XL_SelectProfileList(ifs_split2_profile_listbox_layout[iJoystick].XLiveName)

	ifs_split2_profile_fnUpdateScreen(this, 1)
	this.iLoginPort = iJoystick
	this.iLoginJoystick = ifs_split2_profile_fnIdxToJoystick(this, iJoystick)
	Popup_Busy.iOnlyJoystick = this.iLoginJoystick
	
	Popup_Busy.fnCheckDone = ifs_split2_profile_fnXLCheckDone
	Popup_Busy.fnOnSuccess =  ifs_split2_profile_fnXLOnSuccess
	Popup_Busy.fnOnFail =  ifs_split2_profile_fnXLOnFail
	Popup_Busy.fnOnCancel =  ifs_split2_profile_fnXLOnCancel
	Popup_Busy.bNoCancel = nil -- allow cancel button
	Popup_Busy.fTimeout = 60 -- seconds
	IFText_fnSetString(Popup_Busy.title,"common.mp.loggingin")
	Popup_Busy:fnActivate(1)

	-- Whine like crazy on login errors now
	ScriptCB_TrackLoginErrors(1)
	ScriptCB_IsNetCableIn() -- fix for BF2 bug 4520 -- enable XBox sockets if cable just got inserted
	ScriptCB_StartLogin(this.iLoginJoystick)
	this.bStartedLogin = 1
end


-- Callback from "Bad passcode" dialog. Gets that dialog off screen
-- updates flow
function ifs_split2_profile_fnBadPassDone()
	local this = ifs_split2_profile

	ifs_split2_profile_listbox_layout[this.iPasscodeJoystick].CurPassword = ""
	this.Mode[this.iPasscodeJoystick] = 2 -- back to account list
	ifs_split2_profile_fnUpdateScreen(this)
end

-- Adds one char to the passcode
function ifs_split2_profile_fnAddToPasscode(this, iJoystick, iChar)
	local i = iJoystick
	if((this.Mode[iJoystick] == 3) and (string.len(ifs_split2_profile_listbox_layout[i].CurPassword) < 4)) then
		ifs_split2_profile_listbox_layout[i].CurPassword = ifs_split2_profile_listbox_layout[i].CurPassword .. string.char(iChar)

		ifs_split2_profile_fnUpdateScreen(this)

		-- Recommended by QA, XBox Best Practices - when the passcode hits
		-- 4 buttons, auto-accept it
		if(string.len(ifs_split2_profile_listbox_layout[i].CurPassword) == 4) then
			ifs_split2_profile_fnAccept(this, iJoystick)
		end
	else
--		print("Not adding to passcode ", (this.Mode[iJoystick] == 3) , (string.len(ifs_split2_profile_listbox_layout[i].CurPassword) < 4))
	end -- len is sane, in mode to add
end


-- called when we're done loading the file list form the SaveDevice
function ifs_split2_profile_fnLoadFileListDone(this)
	this.EverLoaded = 1
	--Popup_LoadSave:fnActivate(nil)
	ifs_split2_profile_fnUpdateScreen(this, 1)
	-- reenter this screen
	this.Enter(this,1)
end

function ifs_split2_profile_fnEnsureUniqueSelections(this)
	-- Reset listbox, show it. [Remember, Lua starts at 1!]
	local MaxCount = ScriptCB_GetLoginList("ifs_split2_profile_listbox_contents", 1)
	local ListCount = table.getn(ifs_split2_profile_listbox_contents)
	
	if(not ListCount) then
--		print("ERROR: not ListCount")
		assert(false)
	end
	
	-- Ensure everyone has a unique set of selected indices
	local i,j,bDone
	for i=1,this.iMaxControllers do
		ifs_split2_profile_listbox_layout[i].FirstShownIdx = 1 -- top
		if(this.Mode[i] < 2) then
			ifs_split2_profile_listbox_layout[i].LoginSelectedIdx = math.max(1,ifs_split2_profile_listbox_layout[i].LoginSelectedIdx or 1)
		end
	end

 	if(ListCount < this.iMaxControllers) then
-- 		print("ERROR: ScriptCB_GetLoginList returned not enough profiles in splitscreen")
-- 		assert(false)
		ifs_split2_profile_fnUpdateScreen(this)
		return
 	end


	repeat
		bDone = 1 -- assume so

		for i=1,this.iMaxControllers do
			for j=i+1,this.iMaxControllers do
				if(ifs_split2_profile_listbox_layout[i].LoginSelectedIdx == ifs_split2_profile_listbox_layout[j].LoginSelectedIdx) then

					local ChangeIdx = j
					-- If j is locked, but i isn't, then move i instead
					if(this.Mode[j] >= 2) then
						if(this.Mode[i] < 2) then
							ChangeIdx = i
						end
					end

					ifs_split2_profile_listbox_layout[ChangeIdx].LoginSelectedIdx = ifs_split2_profile_listbox_layout[ChangeIdx].LoginSelectedIdx + 1
					if(ifs_split2_profile_listbox_layout[ChangeIdx].LoginSelectedIdx > ListCount) then
						ifs_split2_profile_listbox_layout[ChangeIdx].LoginSelectedIdx = 1 -- wrap around
					end
					bDone = nil
				end
			end -- j loop
		end -- i loop

	until bDone

--	print(" Selected =", ifs_split2_profile_listbox_layout[1].LoginSelectedIdx,
--				ifs_split2_profile_listbox_layout[2].LoginSelectedIdx) 

	ifs_split2_profile_fnUpdateScreen(this)
end

----------------------------------------------------------------------------------------
-- load the profile list.  this is just the preop, since that refreshes the file list.
----------------------------------------------------------------------------------------

function ifs_split2_profile_StartLoadFileList()
	ifs_saveop.doOp = "LoadFileList"
	ifs_saveop.OnSuccess = ifs_split2_profile_LoadFileListSuccess
	ifs_saveop.OnCancel = ifs_split2_profile_LoadFileListCancel
	ifs_movietrans_PushScreen(ifs_saveop)
end

function ifs_split2_profile_LoadFileListSuccess()
	-- good, continue
--	print("ifs_split2_profile_LoadFileListSuccess")
	
	-- don't reload when we get back to ifs_split_load.Enter	
	ifs_split2_profile.bFromLoadFileList = 1
	-- pop ifs_saveop, reenter ifs_split2_profile	
	ScriptCB_PopScreen()	
end

function ifs_split2_profile_LoadFileListCancel()
	-- ok, continue
--	print("ifs_split2_profile_LoadFileListCancel")
	
	-- skip forward to the file list screen anyway	
	-- don't reload when we get back to ifs_split_load.Enter	
	ifs_split2_profile.bFromLoadFileList = 1
	-- pop ifs_saveop, reenter ifs_split2_profile	
	ScriptCB_PopScreen()	
	
end

----------------------------------------------------------------------------------------
-- load two profiles
----------------------------------------------------------------------------------------

function ifs_split2_profile_StartLoadProfile(profile1,profile2,profile3,profile4)
--	print("ifs_split2_profile_StartLoadProfile")
	
	-- if both profiles are nil, skip it
	if((not profile1) and (not profile2) and (not profile3) and (not profile4)) then
		ifs_split2_profile_LoadProfileSuccess()
		return
	end
	
--	print("ifs_split2_profile_StartLoadProfile SaveDevice")
	ifs_saveop.doOp = "LoadProfile"
	ifs_saveop.OnSuccess = ifs_split2_profile_LoadProfileSuccess
	ifs_saveop.OnCancel = ifs_split2_profile_LoadProfileCancel
	ifs_saveop.profile1 = profile1
	ifs_saveop.profile2 = profile2
	ifs_saveop.profile3 = profile3
	ifs_saveop.profile4 = profile4
	ifs_movietrans_PushScreen(ifs_saveop)
	
end

function ifs_split2_profile_LoadProfileSuccess()
--	print("ifs_split2_profile_LoadProfileSuccess")
	local this = ifs_split2_profile
	-- ok
	
	if(gDemoBuild) then
		gPickedMapList = {} -- zap maplist
		local Idx = 1
		gPickedMapList[Idx] = {
			Map = "tan1g_ctf",
			dnldable = nil,
			mapluafile = "tan1g_c",
			Side = 1,
			SideChar = "g",
		}
		
		ScriptCB_SetCanSwitchSides(1)
		ScriptCB_SetMissionNames(gPickedMapList,this.bRandomOrder)
		ScriptCB_EnterMission()
	else
		ifs_missionselect.bForMP = nil
		-- don't want movie transitions to the single player screen
		-- keep the splitscreen background active
		gMovieDisabled = 1
		if( ifs_main.CurButton == "mp" ) then
			-- multi player game
			if(gPlatformStr == "PS2") then
				ScriptCB_PushScreen("ifs_mp")
			elseif( gOnlineServiceStr == "XLive" ) then
				ifs_movietrans_PushScreen(ifs_mp_main)
			else			
				ScriptCB_PushScreen("ifs_mp_main")
			end
		else
			-- single player game
			ScriptCB_PushScreen("ifs_sp")
		end
	end
end

function ifs_split2_profile_LoadProfileCancel()
--	print("ifs_split2_profile_LoadProfileCancel")
	local this = ifs_split2_profile
	-- error, should go back to the LoadFileList state	
	
	-- bail from ifs_saveop
	ScriptCB_PopScreen()
	
	ifs_split2_profile_fnUpdateScreen(this, 1)
	--ifs_split2_profile_fnEnsureUniqueSelections(this)
	
end

----------------------------------------------------------------------------------------
-- the ok from when you enter without enough profiles.
----------------------------------------------------------------------------------------
--function ifs_split2_profile_NotEnoughProfilesOk()
--	-- pop it
--	ScriptCB_PopScreen()
--end


-- The login profile list has changed. Must update things
function ifs_split2_profile_fnProfileListChanged(this)
--	print(" ** Top of MPXL ProfileListChanged")

	local this = ifs_split2_profile
	local i,j
	local NumEntries = table.getn(ifs_mpxl_login_listbox_contents)

	for i=1,this.iMaxControllers do
		-- If there's an XLiveName we're tracking for this player, we need
		-- to update things
		if(ifs_split2_profile_listbox_layout[i].XLiveName) then
			local bNeedsSafeMode

			if(NumEntries > 0) then
				local NewIdx
				-- Locate player name in new list
				for j=1,NumEntries do
					if(ifs_split2_profile_listbox_layout[i].XLiveName == ifs_mpxl_login_listbox_contents[j].showstr) then
						NewIdx = j
					end -- match on 
				end
				
				if(NewIdx) then
					ifs_split2_profile_listbox_layout[i].XLiveSelectedIdx = NewIdx
				else
					-- Account we were tracking went missing. Move back to safe mode
					bNeedsSafeMode = 1
				end
				
			else
				-- No entries in login list. If we had a selected profile, move
				-- back to a safe mode
				bNeedsSafeMode = 1
			end -- NumEntries == 0

			if((bNeedsSafeMode) and (this.Mode[i] == 3)) then
				this.Mode[i] = 2 -- back to xlive account list, NOW
			end

		end -- Player has a XLiveName we're tracking
	end -- i loop over iMaxControllers
		
	ifs_split2_profile_fnUpdateScreen(ifs_split2_profile)
	this.EverLoaded = 1

--	print(" ** Bot of MPXL ProfileListChanged")		
end

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

-- Helper function, swaps info on the entries. Used whenever the ordering of
-- the profiles changes
function ifs_split2_profile_fnSwapEntries(this)
	this.Mode[1], this.Mode[2] = this.Mode[2], this.Mode[1] -- swap!
	ifs_split2_profile_listbox_layout[1].LoginSelectedIdx, ifs_split2_profile_listbox_layout[2].LoginSelectedIdx = ifs_split2_profile_listbox_layout[2].LoginSelectedIdx, ifs_split2_profile_listbox_layout[1].LoginSelectedIdx
	ifs_split2_profile_listbox_layout[1].CursorIdx, ifs_split2_profile_listbox_layout[2].CursorIdx = ifs_split2_profile_listbox_layout[2].CursorIdx, ifs_split2_profile_listbox_layout[1].CursorIdx

	-- swap XLive entries also
	ifs_split2_profile_listbox_layout[1].XLiveSelectedIdx, ifs_split2_profile_listbox_layout[2].XLiveSelectedIdx = ifs_split2_profile_listbox_layout[2].XLiveSelectedIdx, ifs_split2_profile_listbox_layout[1].XLiveSelectedIdx
	ifs_split2_profile_listbox_layout[1].XLiveName, ifs_split2_profile_listbox_layout[2].XLiveName = ifs_split2_profile_listbox_layout[2].XLiveName, ifs_split2_profile_listbox_layout[1].XLiveName

	ifs_split2_profile_listbox_layout[1].CurPassword, ifs_split2_profile_listbox_layout[2].CurPassword = ifs_split2_profile_listbox_layout[2].CurPassword, ifs_split2_profile_listbox_layout[1].CurPassword

	ifs_split2_profile_fnGetLoginNames(this)
end

-- Helper function: updates login names. To be called on entry, and
-- whenever logins change
function ifs_split2_profile_fnGetLoginNames(this)
	local Name
	ifs_split2_profile_fnTranslateJoystick(this, -10) -- force a re-update

	if(not this.iSecondaryPort) then
		ifs_split2_profile_listbox_layout[1].XLiveLogin = ScriptCB_XL_GetLoginName(this.iPrimaryPort, 1)
		ifs_split2_profile_listbox_layout[2].XLiveLogin = nil
	else
		if(this.iSecondaryPort < this.iPrimaryPort) then
			ifs_split2_profile_listbox_layout[1].XLiveLogin = ScriptCB_XL_GetLoginName(this.iSecondaryPort, 1)
			ifs_split2_profile_listbox_layout[2].XLiveLogin = ScriptCB_XL_GetLoginName(this.iPrimaryPort, 1)
		else
			ifs_split2_profile_listbox_layout[1].XLiveLogin = ScriptCB_XL_GetLoginName(this.iPrimaryPort, 1)
			ifs_split2_profile_listbox_layout[2].XLiveLogin = ScriptCB_XL_GetLoginName(this.iSecondaryPort, 1)
		end
	end

	if(ifs_split2_profile_listbox_layout[1].XLiveLogin) then
		ifs_split2_profile_listbox_layout[1].XLiveLogin = ScriptCB_tounicode(ifs_split2_profile_listbox_layout[1].XLiveLogin)
	end

	if(ifs_split2_profile_listbox_layout[2].XLiveLogin) then
		ifs_split2_profile_listbox_layout[2].XLiveLogin = ScriptCB_tounicode(ifs_split2_profile_listbox_layout[2].XLiveLogin)
	end

	-- Go over list of found accounts. If we're logged in to an account, and that
	-- account is currently present, then ensure the selection stays on that.
	-- As the XLive entries listbox is hidden while logged in, this should be
	-- transparent to the user
	local i,j
	local NumEntries = table.getn(ifs_mpxl_login_listbox_contents)
	for i=1,2 do
		if(ifs_split2_profile_listbox_layout[i].XLiveLogin) then
			for j=1,NumEntries do
				if(ifs_split2_profile_listbox_layout[i].XLiveLogin == ifs_mpxl_login_listbox_contents[j].showstr) then
					ifs_split2_profile_listbox_layout[i].XLiveName = ifs_split2_profile_listbox_layout[i].XLiveLogin 
				end
			end
		end
	end
end

-- Remaps a joystick from a C-based HW port # (0..3 on XBox) into 1/2
-- based on primary, secondary, etc. Returns nil if the entry value is
-- out of range, etc.
--
-- Note: the primary index may be 1 or 2, and possibly change in the
-- course of this screen, depending on whether the primary controller
-- is above or below the secondary controller's index.
function ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
	-- Re-query secondary port if it's unknown
	if(not this.iSecondaryPort) then
		this.iSecondaryPort = ScriptCB_GetSecondaryController()
		if(this.iSecondaryPort) then
			this.iSecondaryPort = this.iSecondaryPort + 1 -- convert from C's 0-base to Lua's 1-base
			-- Secondary port just got bound. If it's before the primary port,
			-- then swap things.
			if(this.iSecondaryPort < this.iPrimaryPort) then
				ifs_split2_profile_fnSwapEntries(this)
				this.iPrimaryIdx = 2
			else
				this.iPrimaryIdx = 1
			end
		else
			-- Secondary port is currently unbound. Ensure primary is in slot 1
			if(this.Mode[1] < 1) then
				ifs_split2_profile_fnSwapEntries(this)
			end
			this.iPrimaryIdx = 1
		end
	end

	-- If secondary port is still unknown, compare against primary only
	if (not this.iSecondaryPort) then
		if ((iJoystick+1) == this.iPrimaryPort) then
			return 1 -- primary
		else
			return nil -- neither primary nor secondary
		end
	else
		-- secondary is known
		if ((iJoystick+1) == this.iPrimaryPort) then
			-- Matched primary. Put primary in port 1 if it's before the secondary port
			if (this.iPrimaryPort < this.iSecondaryPort) then
				return 1
			else
				return 2
			end

		elseif ((iJoystick+1) == this.iSecondaryPort) then
			-- Matched secondary. Put secondary in port 1 if it's before the primary port
			if (this.iSecondaryPort < this.iPrimaryPort) then
				return 1
			else
				return 2
			end
		else
			return nil -- neither primary nor secondary
		end
	end

	-- Final fallback
	return iJoystick
end

-- Does the reverse of the above. Turns an idx (1,2) into a joystick
function ifs_split2_profile_fnIdxToJoystick(this, iIdx)
	if (not this.iSecondaryPort) then
		assert(iIdx == 1)
		return this.iPrimaryPort
	else
		if (this.iSecondaryPort < this.iPrimaryPort) then
			if(iIdx == 1) then
				return this.iSecondaryPort
			else
				return this.iPrimaryPort
			end
		else
			if(iIdx == 1) then
				return this.iPrimaryPort
			else
				return this.iSecondaryPort
			end
		end
	end
		
end

-- Takes a translated joystick index, does work
function ifs_split2_profile_fnAccept(this, iJoystick)
--	print("ifs_split2_profile.Input_Accept(",iJoystick,")")

	if(this.Mode[iJoystick] == 1) then
		-- See if this selection is dimmed. Reject if dimmed, accept if possible
		ifs_split2_profile_fnCalcDim(this, iJoystick)
		local SelIdx = ifs_split2_profile_listbox_layout[iJoystick].LoginSelectedIdx
		if(ifs_split2_profile_listbox_contents[SelIdx].bDim) then
			ifelm_shellscreen_fnPlaySound(this.errorSound)
		else
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			this.bPrimaryIsLoggedIn = ScriptCB_XL_IsLoggedIn(1) -- refresh state
			if((iJoystick == this.iPrimaryIdx) and (this.bPrimaryIsLoggedIn)) then
				this.Mode[iJoystick] = 4
			else
				this.Mode[iJoystick] = 2
			end
			ifs_split2_profile_fnUpdateScreen(this)
		end
	elseif (this.Mode[iJoystick] == 2) then
		-- Selected an XLive account. Need to either prompt or jump to logging it in
		if(table.getn(ifs_mpxl_login_listbox_contents) < 1) then
			-- No accounts. Prompt to create one
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			Popup_YesNo.CurButton = "no" -- default
			Popup_YesNo.fnDone = ifs_split2_profile_fnRebootPopupDone
			Popup_YesNo.iOnlyJoystick = ifs_split2_profile_fnIdxToJoystick(this, iJoystick)
			Popup_YesNo:fnActivate(1)
			gPopup_fnSetTitleStr(Popup_YesNo, "ifs.pickacct.promptcreate")
			ifs_split2_profile_fnUpdateScreen(this,1) -- hide most of screen
		else
			assert(ifs_split2_profile_listbox_layout[iJoystick].XLiveName)
			local Selection = ifs_mpxl_login_listbox_contents[ifs_split2_profile_listbox_layout[iJoystick].XLiveSelectedIdx]
			-- Primary can never log in as guest - BF2 bug 3602
			if(Selection.bDim) then
				ifelm_shellscreen_fnPlaySound(this.errorSound)
			elseif ((not Selection.bGuest) and 
				 ScriptCB_IsProfilePassworded(ifs_split2_profile_listbox_layout[iJoystick].XLiveName)) then
				ifelm_shellscreen_fnPlaySound(this.acceptSound)
--				print("Passcoded...")
				this.Mode[iJoystick] = 3 -- just change state
				ifs_split2_profile_listbox_layout[iJoystick].CurPassword = ""
				ifs_split2_profile_fnUpdateScreen(this)
			else
--				print("Not Passcoded...")
				ifelm_shellscreen_fnPlaySound(this.acceptSound)
				this.Mode[iJoystick] = 4 -- just change state
				ifs_split2_profile_fnStartXLLogin(this, iJoystick)
			end
		end -- ifs_mpxl_login_listbox_contents has entries
	elseif (this.Mode[iJoystick] == 3) then
		-- Entered password. Check it!
		this.iPasscodeJoystick = iJoystick
--		print("Time to check passcode")
		if(ScriptCB_CheckProfilePassword(ifs_split2_profile_listbox_layout[iJoystick].XLiveName, ifs_split2_profile_listbox_layout[iJoystick].CurPassword)) then
			ifs_split2_profile_fnStartXLLogin(this, iJoystick)
		else
			-- Password error
			ifs_split2_profile_fnUpdateScreen(this, 1)
			Popup_Ok.fnDone = ifs_split2_profile_fnBadPassDone
			Popup_Ok.iOnlyJoystick = ifs_split2_profile_fnIdxToJoystick(this, iJoystick)
			Popup_Ok:fnActivate(1)
			gPopup_fnSetTitleStr(Popup_Ok, "ifs.pickacct.badpasscode")
		end
	elseif (this.Mode[iJoystick] == 4) then
		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		ifs_split2_profile_fnStart(this, iJoystick)
	end
end

function ifs_split2_profile_fnStart(this, iJoystick)
--	print("ifs_split2_profile.Input_Start(",iJoystick,")")

	-- If on listbox, all the logic to advance state is in
	-- Input_Accept instead.
	if((this.Mode[iJoystick] >= 1) and (this.Mode[iJoystick] < 4)) then
		return ifs_split2_profile_fnAccept(this, iJoystick)
	elseif (this.Mode[iJoystick] == 0) then
		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		this.Mode[iJoystick] = this.Mode[iJoystick] + 1
	end

	-- Check if everyone is ready
	local i

	local bAllReady, iNumReady = ifs_split2_profile_fnOkToLaunch(this)

	if((bAllReady) and (iJoystick == this.iPrimaryIdx)) then
		ScriptCB_SetSplitscreen(iNumReady)
--		print("load the two profiles")

		local i
		local Selections = {}
		local LoadNames = { nil, nil, nil, nil, } -- Names that exist on memcard
		local FakeNames = { nil, nil, nil, nil, } -- Names that aren't on memcard

		for i=1,this.iMaxControllers do
			Selections[i] = ifs_split2_profile_listbox_contents[ifs_split2_profile_listbox_layout[i].LoginSelectedIdx]
			if(Selections[i].memslot) then
--				print("Player "..i.." wants the profile in Active ",Selections[i].memslot,": ",ScriptCB_ununicode(Selections[i].showstr))
			else
--				print("Player "..i.." wants the profile on Memcard: ",ScriptCB_ununicode(Selections[i].showstr))
			end

			if(this.Mode[i] == 2) then
				if (Selections[i].memslot) then
					FakeNames[i] = Selections[i].showstr
				else
					LoadNames[i] = Selections[i].showstr
				end
			end
		end

		if(gPlatformStr == "PS2") then
			--only first two players for PS2
			ScriptCB_MakeFakeProfiles(FakeNames[1], FakeNames[2])
		else			
			ScriptCB_MakeFakeProfiles(FakeNames[1], FakeNames[2], FakeNames[3], FakeNames[4])
		end
		ifs_split2_profile_StartLoadProfile(LoadNames[1], LoadNames[2], LoadNames[3], LoadNames[4])
		
		-- hide everything on this screen
		for i=1,this.iMaxControllers do
			this.Mode[i] = 5
		end
	end -- all are ready

	ifs_split2_profile_fnUpdateScreen(this)			

end

ifs_split2_profile = NewIFShellScreen {
	nologo = 1,
	bNohelptext = 1, -- We do our own on this screen.
	movieIntro      = nil, -- WAS "ifs_split2_profile_intro",
	movieBackground = "shell_sub_left", -- WAS "ifs_split2_profile",

	fnLoadFileListDone = ifs_split2_profile_fnLoadFileListDone,

	title = NewIFText {
		string = "", --ifs.profile.title",
		font = "gamefont_large",
		textw = 460,
		y = -5,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0, -- top
		inert = 1,
		nocreatebackground=1,		
	},

	Message = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	ProfileName = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	pwd_title = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	pwd_string = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	pressstart = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	BackGroup = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	CreateGroup = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	AcceptGroup = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	GuestGroup = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	Profile = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	Enter = function(this, bFwd)
--		print("ifs_split2_profile.Enter(",bFwd,")")		
						
		gIFShellScreenTemplate_fnEnter(this, bFwd)
		this.iSignoutPopAtEnd = nil -- always clear this if not 

		-- Hide things by default on entry
		if(bFwd) then
			ifs_split2_profile_fnUpdateScreen(this, 1)
		end

		this.Mode = this.Mode or {} -- create if not present.
		local i

		this.bNeedRegetXLNames = 1

		this.iPrimaryPort = ScriptCB_GetPrimaryController() + 1
		this.iSecondaryPort = nil -- force it to be requested from game
		if(bFwd) then
			this.iPrimaryIdx = 1
		end

		-- Rearrange icon positions, as necessary
		for i=1,this.iMaxControllers do
			this.Mode[i] = this.Mode[i] or 0
			gHelptext_fnMoveIcon(this.AcceptGroup[i])
			gHelptext_fnMoveIcon(this.GuestGroup[i])
			-- Also, ensure password is cleared
			ifs_split2_profile_listbox_layout[i].CurPassword = ""
		end
		
		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if(ErrorLevel >= 6) then -- session or login error, must keep going further
				ScriptCB_PopScreen()
			end
		end

		-- if we've just loaded the file list, finish the enter
		if(this.bFromLoadFileList) then
--			print("ifs_split2_profile.bFromLoadFileList")
			this.bFromLoadFileList = nil			

			-- Set state so that first person has hit start. Rest are waiting to do that.
			for i=1,this.iMaxControllers do
				this.Mode[i] = 0
			end
			this.bPrimaryIsLoggedIn = ScriptCB_XL_IsLoggedIn(1)
--			print("bPrimaryIsLoggedIn = ", this.bPrimaryIsLoggedIn)
			if(this.bPrimaryIsLoggedIn) then
				this.Mode[this.iPrimaryIdx] = 4
			else
				this.Mode[this.iPrimaryIdx] = 2
			end

			local MaxCount = ScriptCB_GetLoginList("ifs_split2_profile_listbox_contents", 1)
			
			-- Primary player inherits currently logged in profile
--			print("line 502, this.iPrimaryPort = ", this.iPrimaryPort)
			ifs_split2_profile_listbox_layout[this.iPrimaryIdx].LoginSelectedIdx = 1
			ifs_split2_profile_listbox_layout[this.iPrimaryIdx].CursorIdx = 1

			local LoginUStr = ScriptCB_GetCurrentProfileName()
			local NumProfiles = table.getn(ifs_split2_profile_listbox_contents)
			for i=1,NumProfiles do
				if(ifs_split2_profile_listbox_contents[i].showstr == LoginUStr) then
--					print("Profile match on ",i)
					ifs_split2_profile_listbox_layout[this.iPrimaryIdx].LoginSelectedIdx = i
					ifs_split2_profile_listbox_layout[this.iPrimaryIdx].CursorIdx = i
				end
			end

			-- fill in the listbox
			ifs_split2_profile_fnEnsureUniqueSelections(this)
			
			-- Start enumerating XLive profiles only after we've set up our modes
			ScriptCB_XL_StartProfileList()
			this.bStartedList = 1
			ifs_split2_profile_fnGetLoginNames(this)

			local bPrimaryIsLoggedIn = ScriptCB_XL_IsLoggedIn(0) -- refresh state
			if ((ScriptCB_InMultiplayer() and bPrimaryIsLoggedIn) or
					(bPrimaryIsLoggedIn and ScriptCB_IsSpecialJoinPending())) then
--				print("Jumping forward, as InMultiplayer()") 
				ifs_movietrans_PushScreen(ifs_mp_main)
			end

			if(ifs_main.bJumpToMPMain) then
				ifs_split2_profile_fnTranslateJoystick(this, -10)

				if((not this.iPrimaryPort) or (not this.iSecondaryPort)) then
--					print("Missing controller! Bailing!")
					ifs_main.bJumpToMPMain = nil
					ScriptCB_PopScreen()
				else
					this.Mode[3 - this.iPrimaryIdx] = 4 -- also ready to login
--					print("Jumping forward to mpmain") 
					ifs_movietrans_PushScreen(ifs_mp_main)
				end
			end

			-- otherwise start it
		elseif (bFwd) then
--			print("bFwd")
			ifs_split2_profile_StartLoadFileList()
			return
		else
			-- Backing into this screen. If the secondary controller is bound,
			-- then assume both players are bound into mode2. If not, only
			-- the primary idx is bound

			this.bPrimaryIsLoggedIn = ScriptCB_XL_IsLoggedIn(1)
--			print("bPrimaryIsLoggedIn = ", this.bPrimaryIsLoggedIn)


			for i=1,this.iMaxControllers do
				if(this.bPrimaryIsLoggedIn) then
					this.Mode[i] = 4
				else
					this.Mode[i] = 2
				end
			end
			
			if(not ScriptCB_GetSecondaryController()) then
				this.Mode[2] = 0
			end
		end

		this.bNeedRegetXLNames = 1
		ifs_split2_profile_fnUpdateScreen(this)
		ScriptCB_ReadAllControllers(1) -- note we need this mode on this screen
	end,

	Exit = function(this, bFwd)
		ScriptCB_ReadAllControllers(nil) -- turn off once we're done with this screen
		gMovieDisabled = nil
		if(not bFwd) then
			-- Going to main menu. Restore default profile. 
			ScriptCB_RestoreDefaultProfile()
		end

 		if(bFwd) then 			-- Going to a subscreen
			-- No longer need to monitor changes to this
			if (this.bStartedList) then
				ScriptCB_XL_EndProfileList()
			end
			-- Ensure these are on.
			ScriptCB_SetNoticeNoCable(1)
			ScriptCB_TrackLoginErrors(1)
		else

			-- Fix for 11957 - if backing out, make sure secondary controller is
			-- unbound
			if (this.iSecondaryPort) then
				ScriptCB_UnbindController(this.iSecondaryPort)
				this.iSecondaryPort = nil
			end

			ScriptCB_XL_CancelProfileList()
			ScriptCB_TrackLoginErrors(nil)

			-- Always reset NetLoginName to what was in profile, as we might
			-- have changed it to the selected user's gamertag as part of a
			-- login
			--local Selection = ifs_login_listbox_contents[ifs_login_listbox_layout.SelectedIdx]
			--ScriptCB_SetNetLoginName(Selection.showstr)
			ScriptCB_SetNetLoginName(ScriptCB_GetCurrentProfileName())
		end
		this.bStartedList = nil
	end,

	-- Always force update first time thru
	fControllerCheckTimer = 0,
	fNumControllers = -1,
	fRecheckTimer = 0.5,
	Update = function(this, fDt)
		-- Call base class functionality
		gIFShellScreenTemplate_fnUpdate(this, fDt)

		this.fControllerCheckTimer = this.fControllerCheckTimer - fDt
		if(this.fControllerCheckTimer < 0) then
			this.fControllerCheckTimer = 0.3 -- reset timer
			local LastNumControllers = this.fNumControllers
			this.fNumControllers = ScriptCB_GetNumControllers()

			if(LastNumControllers ~= this.fNumControllers) then
				ifs_split2_profile_fnUpdateScreen(this)
			end
		end

		-- XBox TCRs require rechecking this at least once a second. So,
		-- [re]check every 1/2 of a second.
		this.fRecheckTimer = this.fRecheckTimer - fDt
		if(this.fRecheckTimer < 0.0) then
			this.fRecheckTimer = 0.5

			ScriptCB_XL_UpdateProfileList()
		end
	end,

	Input_GeneralUp = function(this, iJoystick)
		-- Translate joystick, early-exit if it's out of range
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			return
		end

		if (this.Mode[iJoystick] == 1) then
			ListManager_fnNavUp(this.Profile[iJoystick].listbox,ifs_split2_profile_listbox_contents,ifs_split2_profile_listbox_layout[iJoystick])
			ifs_split2_profile_listbox_layout[iJoystick].LoginSelectedIdx = ifs_split2_profile_listbox_layout[iJoystick].SelectedIdx
		elseif (this.Mode[iJoystick] == 2) then
			ListManager_fnNavUp(this.Profile[iJoystick].listbox,ifs_mpxl_login_listbox_contents,ifs_split2_profile_listbox_layout[iJoystick])
			ifs_split2_profile_listbox_layout[iJoystick].XLiveSelectedIdx = ifs_split2_profile_listbox_layout[iJoystick].SelectedIdx

			-- Repaint screen, update which profile(s) are selected
			ifs_split2_profile_fnUpdateScreen(this)
		end
	end,

	Input_GeneralDown = function(this, iJoystick)
		-- Translate joystick, early-exit if it's out of range
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			return
		end

		if (this.Mode[iJoystick] == 1) then
			ListManager_fnNavDown(this.Profile[iJoystick].listbox,ifs_split2_profile_listbox_contents,ifs_split2_profile_listbox_layout[iJoystick])
			ifs_split2_profile_listbox_layout[iJoystick].LoginSelectedIdx = ifs_split2_profile_listbox_layout[iJoystick].SelectedIdx
		elseif (this.Mode[iJoystick] == 2) then
			ListManager_fnNavDown(this.Profile[iJoystick].listbox,ifs_mpxl_login_listbox_contents,ifs_split2_profile_listbox_layout[iJoystick])
			ifs_split2_profile_listbox_layout[iJoystick].XLiveSelectedIdx = ifs_split2_profile_listbox_layout[iJoystick].SelectedIdx

			-- Repaint screen, update which profile(s) are selected
			ifs_split2_profile_fnUpdateScreen(this)
		end
	end,

	-- Left/Right do nothing on this screen
	Input_GeneralLeft = function(this, iJoystick)
											end,
	Input_GeneralRight = function(this, iJoystick)
											 end,

	Input_Accept = function(this,iJoystick)
		-- Translate joystick, early-exit if it's out of range
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			return
		end
		ifs_split2_profile_fnAccept(this, iJoystick)
	end,

	Input_Back = function(this, iEntryJoystick)
		-- Translate joystick, early-exit if it's out of range
		local iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iEntryJoystick)
		if(not iJoystick) then
			return
		end

		-- Do special handling if going back from mode 1
--		print(" ifs_split, Input_Back has iJoystick ", iJoystick)
		local iUnbindJoystick = nil

		-- Primary port never goes to mode 1 (profile picking)
		if((iJoystick == this.iPrimaryIdx) and 
			 ((this.Mode[iJoystick] <= 2) or (this.Mode[iJoystick] == 4))) then
			-- Is secondary player signed in? Gotta kick them 
			if(this.Mode[3-iJoystick] == 4) then
				this.iSignoutPort = iJoystick
				this.iSignoutPopAtEnd = 1
				Popup_YesNo.CurButton = "no" -- default
				Popup_YesNo.fnDone = ifs_split2_profile_fnLogoutPopupDone
				Popup_YesNo.iOnlyJoystick = ifs_split2_profile_fnIdxToJoystick(this, iJoystick)
				ifs_split2_profile_fnUpdateScreen(this,1) -- hide most of screen
				Popup_YesNo:fnActivate(1)
				gPopup_fnSetTitleStr(Popup_YesNo, "ifs.pickacct.asksignout")
			else
				ScriptCB_UnbindController(-2) -- unbind all but primary
				ScriptCB_ReadAllControllers(nil) -- turn off once we're done with this screen
				ScriptCB_PopScreen()
			end
			return
		end

		-- For not primary ports, unbind if on state 1
		if((iJoystick ~= this.iPrimaryIdx) and (this.Mode[iJoystick] == 1)) then
				iUnbindJoystick = iEntryJoystick + 1
		end -- special handling for current one in mode 1

		-- Always do this code
		if(this.Mode[iJoystick] > 1) then
			ifelm_shellscreen_fnPlaySound(this.exitSound)
		end

		-- Mode 4 (ready) needs to be treated differently. If primary and primary
		-- is logged in, then jump back to account selection. Otherwise, prompt
		-- before logging out
		if(this.Mode[iJoystick] == 4) then
			this.bPrimaryIsLoggedIn = ScriptCB_XL_IsLoggedIn(1) -- refresh state
			if((iJoystick == this.iPrimaryIdx) and (this.bPrimaryIsLoggedIn)) then
				this.Mode[iJoystick] = 1 -- back to account list
			else
				this.iSignoutPort = iJoystick
				Popup_YesNo.CurButton = "no" -- default
				Popup_YesNo.fnDone = ifs_split2_profile_fnLogoutPopupDone
				Popup_YesNo.iOnlyJoystick = ifs_split2_profile_fnIdxToJoystick(this, iJoystick)
				ifs_split2_profile_fnUpdateScreen(this,1) -- hide most of screen
				Popup_YesNo:fnActivate(1)
				gPopup_fnSetTitleStr(Popup_YesNo,"ifs.pickacct.asksignout")
				return
			end
		else
			-- mode isn't 4. Easy case.
			this.Mode[iJoystick] = math.max(this.Mode[iJoystick] - 1,0)
		end

		if(iUnbindJoystick) then
			ScriptCB_UnbindController(iUnbindJoystick) -- don't care about this controller anymore
			this.iSecondaryPort = nil -- force it to be re-requested from game
			ifs_split2_profile_fnTranslateJoystick(this, -10) -- force a ordering update
		end
		ifs_split2_profile_fnUpdateScreen(this)
	end,

	Input_Start = function(this, iJoystick)
		-- Translate joystick, early-exit if it's out of range
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			-- Immediately unbind 'extra' controllers if this wasn't in range
			-- [e.g. third or fourth controller to hit start]
			local i
			for i = 1,4 do
				if((i == this.iPrimaryPort) or (this.iSecondaryPort and (i == this.iSecondaryPort))) then
					-- Supposed to be bound. Do nothing.
				else
--					print("Dumping extra controller on port ", i)
					ScriptCB_UnbindController(i)
				end
			end
			-- And, provide some immediate audio feedback that this was denied.
			ifelm_shellscreen_fnPlaySound(this.errorSound)
			return
		end

		-- Call helper function once we have a valid translated joystick
		ifs_split2_profile_fnStart(this, iJoystick)
	end, -- function Input_Start

	Input_DPadUp = function(this, iJoystick)
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
--			print("DPadUp bailing due to bad joystick")
			return
		end
		ifs_split2_profile_fnAddToPasscode(this, iJoystick, 1)
	end,
	Input_DPadDown = function(this, iJoystick)
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			return
		end
		ifs_split2_profile_fnAddToPasscode(this, iJoystick, 2)
	end,
	Input_DPadLeft = function(this, iJoystick)
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			return
		end
		ifs_split2_profile_fnAddToPasscode(this, iJoystick, 3)
	end,
	Input_DPadRight = function(this, iJoystick)
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			return
		end
		ifs_split2_profile_fnAddToPasscode(this, iJoystick, 4)
	end,

	Input_Misc = function(this, iJoystick)
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			return
		end

		if((this.Mode[iJoystick] == 2) or (this.Mode[iJoystick] == 4)) then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			-- Prompt to create new account
			Popup_YesNo.CurButton = "no" -- default
			Popup_YesNo.fnDone = ifs_split2_profile_fnRebootPopupDone
			Popup_YesNo.iOnlyJoystick = ifs_split2_profile_fnIdxToJoystick(this, iJoystick)
			Popup_YesNo:fnActivate(1)
			gPopup_fnSetTitleStr(Popup_YesNo, "ifs.pickacct.promptcreate")
			ifs_split2_profile_fnUpdateScreen(this,1)
		else
			ifs_split2_profile_fnAddToPasscode(this, iJoystick, 5)
		end

		-- Debug ability
--		print("Primary, Secondary Port = ", this.iPrimaryPort, this.iSecondaryPort, " Primary Idx = ", this.iPrimaryIdx)
--		print(" Modes = ", this.Mode[1], this.Mode[2])
--		print(" Ok to launch: ", ifs_split2_profile_fnOkToLaunch(this))
	end,

	Input_Misc2 = function(this, iJoystick)
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			return
		end

		-- Primary can never log in as guest - BF2 bug 3602
		if((this.Mode[iJoystick] == 2) and (this.Mode[3-iJoystick] == 4) and (iJoystick ~= this.iPrimaryIdx)) then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)

			-- Do a 'guest' account by just picking same name as what's already logged in
			ifs_split2_profile_listbox_layout[iJoystick].XLiveName = ifs_split2_profile_listbox_layout[3-iJoystick].XLiveLogin 
				return ifs_split2_profile_fnStartXLLogin(this, iJoystick)
		else
			ifs_split2_profile_fnAddToPasscode(this, iJoystick, 6)
		end

	end,

	Input_LTrigger = function(this, iJoystick)
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			return
		end
		ifs_split2_profile_fnAddToPasscode(this, iJoystick, 9)
	end,
	Input_RTrigger = function(this, iJoystick)
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			return
		end
		ifs_split2_profile_fnAddToPasscode(this, iJoystick, 10)
	end,

	-- Callback from C. Sets XLiveName for the primary controller to
	-- what's referenced by the SelectedIdx.
	fnUpdateSelected = function(this, iSelected)
--											 print("In fnUpdateSelected(", this, iSelected)
--											 print("   iPrimaryIdx =", this.iPrimaryIdx)

		if(this.iPrimaryIdx) then
			ifs_split2_profile_listbox_layout[this.iPrimaryIdx].SelectedIdx = iSelected
			local Selection = ifs_mpxl_login_listbox_contents[iSelected]
			if(Selection) then
				ifs_split2_profile_listbox_layout[this.iPrimaryIdx].XLiveName = Selection.showstr
			end
			this.bForwardOnSignin = 1
		end
	end,

	-- Override default handler.
 	fnPostError = function(this, bUserHitYes, ErrorLevel, ErrorMessage)
-- 		print("MPXL Login fnPostError(..,", bUserHitYes, ErrorLevel)
		if(ErrorLevel > 5) then
			ScriptCB_ClearError()
			if(ErrorLevel ~= 7) then
				ScriptCB_CancelLogin() -- cancel all logins
			else
				ScriptCB_CancelLogin(this.iSecondaryPort) -- cancel just the secondary player
			end
			this.bStartedLogin = nil
		end

		-- Reacquire login names
--		print("Post Error, L1540")
		ifs_split2_profile_fnGetLoginNames(this)
--		print("Post Error, L1542")
		local j
		for j=1,this.iMaxControllers do
			if((this.Mode[j] == 4) and (not ifs_split2_profile_listbox_layout[j].XLiveLogin)) then
--				print("Mode[",j," resetting back to state 2")
				this.Mode[j] = 2
			else
--				print("Not resetting",j," due to ", this.Mode[j], ifs_split2_profile_listbox_layout[j].XLiveLogin)
			end
		end
--		print("Post Error, L1549")
		ifs_split2_profile_fnUpdateScreen(this)
--		print("Post Error, L1551")


		--  		if(ErrorLevel >= 6) then
		--  			ScriptCB_PopScreen()
		--  		end
		if((ErrorLevel == 5) and (bUserHitYes) and (gPlatformStr == "XBox")) then
			ScriptCB_XB_Reboot("XLD_LAUNCH_DASHBOARD_ACCOUNT_MANAGEMENT")
		end
 	end,

	-- Fix for 12086 - if after we get here, and modes are really broken, then
	-- BAIL
	fnPostMissingController = function(this)
		local i
		local bStayHere = nil
															print("ifs_split2_profile fnPostMissingController")
		for i=1,this.iMaxControllers do
			bStayHere = bStayHere or (this.Mode[i] and (this.Mode[i] > 0))
			print(" .. bStayHere = ", bStayHere," from ", this.Mode[i])
		end

		if(not bStayHere) then
			ScriptCB_PopScreen()
		end	
	end,


	fnLoadProfilesDone = ifs_split2_profile_fnLoadProfilesDone,
	fnUpdateProfileList = ifs_split2_profile_fnProfileListChanged,
}

-- Helper function: makes most of the screen, based on # of entries. 
function ifs_split2_profile_fnBuildScreen(this)
	local iMaxControllers = 2

	this.iMaxControllers = iMaxControllers

	-- Ask game for screen size, use for values
	local r
	local b
	local v
	r,b,v=ScriptCB_GetSafeScreenInfo()

	local i
	for i=1,iMaxControllers do
		local PaneTL_X,PaneTL_Y -- Top-left X,Y of this pane, relative to WHOLE SCREEN
		local PaneW,PaneH -- Width, height of this pane
		local InsetL = 0
		local InsetR = 0

		-- Determine TL positions of everything
		PaneW = r
		PaneH = b * 0.5
		PaneTL_X = 0
		PaneTL_Y = (i-1) * PaneH

		-- All the internal groups are centered onscreen. Move TL position
		-- to be pinned to the right place
		PaneTL_X = PaneTL_X + r * -0.5
		PaneTL_Y = PaneTL_Y + b * -0.5

		this.ProfileName[i] = NewIFText {
			x = PaneTL_X + (PaneW * 0.5) + ((PaneW - 16) * -0.5), -- center within pane
			y = PaneTL_Y + (PaneH * 0.5) - 40 - 25, -- Above the message.
			string = "ifs.split.starttojoin",
			font = "gamefont_medium",
			halign = "hcenter",
			valign = "top",
			textw = PaneW - 16,
			texth = 120,
			--		y = -8,
			nocreatebackground=1,
		} -- this.Message[i]

		this.Message[i] = NewIFText {
			x = PaneTL_X + (PaneW * 0.5) + ((PaneW - 16) * -0.5), -- center within pane
			y = PaneTL_Y + (PaneH * 0.5) - 40, -- center within pane (must subtract half of texth)
			string = "ifs.split.starttojoin",
			font = "gamefont_medium",
			halign = "hcenter",
			valign = "top",
			textw = PaneW - 16,
			texth = 120,
			--		y = -8,
			nocreatebackground=1,
		} -- this.Message[i]

		this.pressstart[i] = NewIFText {
			x = PaneTL_X + (PaneW * 0.5) + ((PaneW - 16) * -0.5), -- center within pane
			y = PaneTL_Y + (PaneH * 0.5) - 40 + 25, -- bottom side of pane (must subtract half of texth)
			string = "ifs.split.starttolaunch",
			font = "gamefont_medium",
			textw = PaneW - 16,
			texth = 120,
			nocreatebackground=1,
		}

		this.BackGroup[i] = NewHelptext {
			x = PaneTL_X + InsetL, -- inset slightly
			y = PaneTL_Y + PaneH - 20, -- just off the bottom
			buttonicon = "btnb",
			string = "common.back",
		} -- this.BackGroup[i]

		this.CreateGroup[i] = NewHelptext {
			x = PaneTL_X + InsetL, -- inset slightly
			y = PaneTL_Y + PaneH - 45, -- just off the bottom
			buttonicon = "btnmisc",
			string = "ifs.pickacct.createnew",
		} -- this.CreateGroup[i]

		this.AcceptGroup[i] = NewHelptext {
			x = PaneTL_X + PaneW - InsetR, -- inset slightly
			y = PaneTL_Y + PaneH - 20, -- just off the bottom
			buttonicon = "btna",
			string = "common.select",
			bRightJustify = 1,
		} -- this.AcceptGroup[i]

		this.GuestGroup[i] = NewHelptext {
			x = PaneTL_X + PaneW - InsetR, -- inset slightly
			y = PaneTL_Y + PaneH - 45, -- just off the bottom
			buttonicon = "btnmisc2",
			string = "ifs.pickacct.guest",
			bRightJustify = 1,
		} -- this.AcceptGroup[i]

		this.pwd_title[i] = NewIFText {
			string = "ifs.pickacct.enterpass",
--			x = PaneTL_X + (PaneW * 0.5) + ((PaneW - 16) * -0.5), -- center within pane
			y = PaneTL_Y + (PaneH * 0.15), -- top portion
			font = "gamefont_large",
			textw = PaneW - 16,
			texth = 70,
			nocreatebackground = 1,
			valign = "vcenter",
		} -- this.pwd_title[i]

		this.pwd_string[i] = NewIFText {
			--		string = "ifs.pickacct.enterpass",
			x = PaneTL_X + (PaneW * 0.5) + ((PaneW - 16) * -0.5), -- center within pane
			y = PaneTL_Y + (PaneH * 0.5), -- near top
			font = "gamefont_large",
			textw = PaneW - 16,
			texth = 30,
			nocreatebackground = 1,
			valign = "vcenter",
		} -- this.pwd_string[i]

		local ListItemHeight = ScriptCB_GetFontHeight(ifs_split2_profile_listbox_layout[1].font) + 4

		ifs_split2_profile_listbox_layout[i].yHeight = ListItemHeight
		ifs_split2_profile_listbox_layout[i].width = PaneW * 0.65

		local ListHeightPer = (ifs_split2_profile_listbox_layout[i].yHeight + ifs_split2_profile_listbox_layout[i].ySpacing)
		local ListboxHeight = ifs_split2_profile_listbox_layout[i].showcount * ListHeightPer + 30
		this.Profile[i] = NewIFContainer {
			listbox = NewButtonWindow { 
				ZPos = 200, 
				x = PaneTL_X + PaneW * 0.5,
				y = PaneTL_Y + PaneH * 0.5 - 25,

				width = ifs_split2_profile_listbox_layout[i].width + 35,
				height = ListboxHeight,
			},
		} -- this.Profile[i]

		ListManager_fnInitList(this.Profile[i].listbox,ifs_split2_profile_listbox_layout[i])
	end

	this.horizline = NewIFImage {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
		texture = "gray_rect", 
		alpha = 0.8,
		localpos_l = -(r * 0.5 + 200), localpos_t = -2, 
		localpos_r =  (r * 0.5 + 200), localpos_b =  2,
		inert = 1,
		ColorR = 192, ColorG = 192, ColorB = 255,		
	}

end

-- Call function to create/resize/reposition items
ifs_split2_profile_fnBuildScreen(ifs_split2_profile)
ifs_split2_profile_fnBuildScreen = nil -- clear that out of memory

AddIFScreen(ifs_split2_profile,"ifs_split2_profile")