--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- XBox Live leader board

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.


function ifs_mp_leaderboard_Listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local text_width = 120
	local Temp = NewIFContainer { x = layout.x - 0.5 * layout.width, y=layout.y}
	local y_offset = -5
	Temp.rankfield = NewIFText{ clip = "character", x = 10, y = y_offset, textw = text_width, halign = "left", font = "gamefont_tiny", nocreatebackground = 1,}
--	Temp.levelfield = NewIFText{ clip = "character", x = Temp.rankfield.textw, y = 0, textw = 60, halign = "left", font = "gamefont_small", nocreatebackground = 1,}
--	Temp.titlefield = NewIFText{ clip = "character", x = Temp.levelfield.textw, y = 0, textw = 60, halign = "left", font = "gamefont_small", nocreatebackground = 1,}
	Temp.namefield = NewIFText{ clip = "character", x = layout.width * 0.5 - 200, y = y_offset, textw = 400, halign = "hcenter", font = "gamefont_tiny", nocreatebackground = 1,}
	Temp.ratingfield = NewIFText{ clip = "character", x = layout.width - text_width - 10, y = y_offset, textw = text_width, halign = "right", font = "gamefont_tiny", nocreatebackground = 1,}
	return Temp
end



-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_mp_leaderboard_Listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	if(Data) then
		-- Contents to show. Do so.
--		IFText_fnSetUString(Dest.rankfield,Data.rankfield)
--		IFText_fnSetUString(Dest.namefield,Data.namefield)
--		IFText_fnSetUString(Dest.ratingfield,Data.ratingfield)

		IFText_fnSetString(Dest.rankfield,Data.rankfield)
		IFText_fnSetString(Dest.namefield,Data.namefield)
		IFText_fnSetString(Dest.ratingfield,Data.ratingfield)

		IFObj_fnSetColor(Dest.rankfield, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.rankfield, fAlpha)
		IFObj_fnSetColor(Dest.namefield, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.namefield, fAlpha)
		IFObj_fnSetColor(Dest.ratingfield, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.ratingfield, fAlpha)
	end

	IFObj_fnSetVis(Dest,Data) -- Show if there are contents
end

leaderboard_listbox_layout = {
	showcount = 18,
	yTop = -130 + 23,
	yHeight = 12,
	ySpacing  = 2,
	width = 430,
	x = 0,
	slider = 1,
	CreateFn = ifs_mp_leaderboard_Listbox_CreateItem,
	PopulateFn = ifs_mp_leaderboard_Listbox_PopulateItem,
}

leaderboard_listbox_contents = {
	-- Filled in from C++
	-- Stubbed to show the string.format it wants.
--	{ labelustr = "Player 1", contentsstr = "5"},
-- **OR**
--	{ labelustr = " Favorite Vehicle", contentsustr = "AT-ST"}, 

	{ rankfield = "", levelfield = "", titlefield = "", namefield = "", ratingfield = "" },
	{ rankfield = "2", levelfield = "1", titlefield = "", namefield = "ABCDEFGHIJKLMNOPQRSTUVWXYZ", ratingfield = "12345" },
	{ rankfield = "3", levelfield = "1", titlefield = "", namefield = "sammy davis", ratingfield = "12345" },
	{ rankfield = "4", levelfield = "1", titlefield = "", namefield = "sammy davis", ratingfield = "12345" },
	{ rankfield = "5", levelfield = "1", titlefield = "", namefield = "sammy davis", ratingfield = "12345" },
	{ rankfield = "6", levelfield = "1", titlefield = "", namefield = "sammy davis", ratingfield = "12345" },
	{ rankfield = "7", levelfield = "1", titlefield = "", namefield = "sammy davis", ratingfield = "12345" },
	{ rankfield = "8", levelfield = "1", titlefield = "", namefield = "sammy davis", ratingfield = "12345" },
	{ rankfield = "9", levelfield = "1", titlefield = "", namefield = "sammy davis", ratingfield = "12345" },
	{ rankfield = "10", levelfield = "1", titlefield = "", namefield = "sammy davis", ratingfield = "12345" },
	{ rankfield = "11", levelfield = "1", titlefield = "", namefield = "sammy davis", ratingfield = "12345" },
	{ rankfield = "12", levelfield = "1", titlefield = "", namefield = "sammy davis", ratingfield = "12345" },
	{ rankfield = "13", levelfield = "1", titlefield = "", namefield = "sammy davis", ratingfield = "12345" },
	{ rankfield = "14", levelfield = "1", titlefield = "", namefield = "sammy davis", ratingfield = "12345" },
}

LeaderBoard_GameMode_List = {
		{ string = "ifs.mp.leaderboard.conquest", },
		{ string = "ifs.mp.leaderboard.CTF1", },
		{ string = "ifs.mp.leaderboard.CTF2", },
		{ string = "ifs.mp.leaderboard.objective", },
		{ string = "ifs.mp.leaderboard.teamdm", },		
}

LeaderBoard_PlayerFilter_List = {
		{ string = "ifs.mp.leaderboard.me", },
		{ string = "ifs.mp.leaderboard.friends", },
		{ string = "ifs.mp.leaderboard.top", },
}

LeaderBoard_TimeFilter_List = {
		{ string = "ifs.mp.leaderboard.weekly", },
		{ string = "ifs.mp.leaderboard.monthly", },
		{ string = "ifs.mp.leaderboard.overall", },
}

function ifs_mp_leaderboard_fnUpdateText( this )
	if(gPlatformStr ~= "PC") then
		-- set game mode
		local TempString = ScriptCB_usprintf( "ifs.mp.vote.display", ScriptCB_getlocalizestr( LeaderBoard_GameMode_List[this.iGameMode].string ) )
		IFText_fnSetUString( this.GameMode_Text, TempString )

		-- time filter
		IFText_fnSetUString( this.TimeFilter_Text, ScriptCB_getlocalizestr( LeaderBoard_TimeFilter_List[this.iTimeFilter].string ) )
		IFText_fnSetUString( this.Helptext_TimeFilter.helpstr, ScriptCB_getlocalizestr( LeaderBoard_TimeFilter_List[this.iTimeFilter].string ) )

		-- player filter
		local filter_index = this.iPlayerFilter + 1
		if( filter_index > this.iPlayerFilterMax ) then
			filter_index = this.iPlayerFilterMin
		end
		if(gPlatformStr == "PS2") then
			-- no friends mode for PS2
			if( filter_index == 2 ) then
				filter_index = filter_index + 1
			end
		end
		--print( "filter_index = ", filter_index)
		IFText_fnSetUString( this.PlayerFilter_Text, ScriptCB_getlocalizestr( LeaderBoard_PlayerFilter_List[this.iPlayerFilter].string ) )
		IFText_fnSetUString( this.Helptext_PlayerFilter.helpstr, ScriptCB_getlocalizestr( LeaderBoard_PlayerFilter_List[filter_index].string ) )
		gHelptext_fnMoveIcon(this.Helptext_PlayerFilter)
	else
		-- set game mode		
		RoundIFButtonLabel_fnSetUString( this.filter_buttons.mode, ScriptCB_getlocalizestr( LeaderBoard_GameMode_List[this.iGameMode].string ) )
		RoundIFButtonLabel_fnSetString( this.mode_button, LeaderBoard_GameMode_List[this.iGameMode].string )

		-- time filter
		RoundIFButtonLabel_fnSetUString(  this.filter_buttons.time, ScriptCB_getlocalizestr( LeaderBoard_TimeFilter_List[this.iTimeFilter].string ) )

		-- player filter
		--RoundIFButtonLabel_fnSetUString(  this.filter_buttons.player, ScriptCB_getlocalizestr( LeaderBoard_PlayerFilter_List[this.iPlayerFilter].string ) )	
	end		
end

function ifs_leaderboard_fnFindItem( rankid, gamertag )
	for k,v in leaderboard_listbox_contents do
		if( rankid ) then
			if( rankid == tonumber( v.rankfield ) ) then
				return k
			end
		elseif( gamertag ) then
			if( gamertag == v.namefield ) then
				return k
			end		
		end
	end
	return nil
end

-- resort the list after enumerate data
function ifs_leaderboard_fnChangeSelect( this )
	if( ( this.iPlayerFilterEnable == 1 ) and 
		( (this.iPlayerFilter == 1) or (this.iPlayerFilter == 2) ) ) then
		-- set the selected item if player filter enabled and set to "me"
		local login_name = ScriptCB_ununicode( ScriptCB_GetCurrentProfileNetName() )
--		print( "ScriptCB_GetCurrentProfileNetName()= ", login_name )		
		local newSelectedIdx = ifs_leaderboard_fnFindItem( nil, login_name )
		--print( " newSelectedIdx = ", newSelectedIdx )
		if( newSelectedIdx ) then
			leaderboard_listbox_layout.SelectedIdx = newSelectedIdx
			this.RepaintListbox( this )
		end
	elseif( this.nextRankID ) then
		-- set the selected item if nextRankID is set
		local newSelectedIdx = ifs_leaderboard_fnFindItem( this.nextRankID, nil )
		--print( " newSelectedIdx = ", newSelectedIdx )
		if( newSelectedIdx ) then
			leaderboard_listbox_layout.SelectedIdx = newSelectedIdx
			this.RepaintListbox( this )
		end				
		this.nextRankID = nil
	end
	this.iPlayerFilterEnable = nil
end

function ifs_leaderboard_fnBasicSearch()
	local this = ifs_mp_leaderboard

	this.iPlayerFilter = 3			-- Top
	this.iPlayerFilterEnable = 1	-- enable refresh
	this.iTimeFilter = 1			-- Weekly
	this.iGameMode = 1				-- Conquest

	ifs_mp_leaderboard_fnStartEnumerate( this, 1, 0 )
end

function ifs_leaderboard_fnOnSuccess( )
	local this = ifs_mp_leaderboard
	
	-- get leaderboard data
	ifs_mp_leaderboard.iBoardSize, ifs_mp_leaderboard.iBoardID = ScriptCB_GetEnumerateLeaderBoardData( leaderboard_listbox_contents )
	IFText_fnSetString( ifs_mp_leaderboard.BoardSize_Num, string.format("%d",ifs_mp_leaderboard.iBoardSize) )
	local ShowUStr = ScriptCB_usprintf("ifs.mp.leaderboard.id", ScriptCB_tounicode(string.format("%d",ifs_mp_leaderboard.iBoardID)))
	IFText_fnSetUString( ifs_mp_leaderboard.Download_Text, ShowUStr )

	-- change selected idx
	ifs_leaderboard_fnChangeSelect( ifs_mp_leaderboard )
	
	Popup_Busy:fnActivate(nil)
	
	-- Reset listbox, show it. [Remember, Lua starts at 1!]
	--leaderboarddetails_listbox_layout.FirstShownIdx = 1
	--leaderboarddetails_listbox_layout.SelectedIdx = 1
	--this.RepaintListbox(this)
end

function ifs_leaderboard_fnOnFail()
	-- clear the leaderboard list if fail
	local empty_table = {}
	ListManager_fnFillContents( ifs_mp_leaderboard.listbox, empty_table, leaderboard_listbox_layout )

	ListManager_fnFillContents( ifs_mp_leaderboard.detail_listbox, empty_table, ifs_mp_leaderboard_details_listbox_layout )
	
	Popup_Busy:fnActivate(nil)
	Popup_Ok.fnDone = ifs_leaderboard_fnBasicSearch
	Popup_Ok:fnActivate(1)
	gPopup_fnSetTitleStr(Popup_Ok, "ifs.stats.error.notavailable")
end

function ifs_mp_leaderboard_fnExitScreen()
	local this = ifs_mp_leaderboard
	
	Popup_Busy:fnActivate(nil)
	Popup_Ok:fnActivate(nil)
	
	if(gPlatformStr == "PC") then
--		ScriptCB_PopScreen("ifs_main")
	else
		ScriptCB_PopScreen()
	end
end

function ifs_mp_leaderboard_fnStartEnumerate( this, iPageCurrent, iPageDir )
	
	-- start the leader board player download
	local player_filter = 0
	if( this.iPlayerFilterEnable ) then
		player_filter = this.iPlayerFilter
		this.nextRankID = 1
	end
--	print( "ScriptCB_EnumerateLeaderBoard( nil, ", iPageCurrent, iPageDir, this.iTimeFilter, player_filter, this.iGameMode )
	if( ScriptCB_EnumerateLeaderBoard( nil, iPageCurrent, iPageDir, this.iTimeFilter, player_filter, this.iGameMode ) == -1 ) then
		Popup_Ok.fnDone = ifs_mp_leaderboard_fnExitScreen
		Popup_Ok:fnActivate(1)
		gPopup_fnSetTitleStr(Popup_Ok, "ifs.stats.error.usernotfound")
	
	else
		Popup_Busy.fnCheckDone = ifs_leaderboarddetails_fnCheckDone
		Popup_Busy.fnOnSuccess = ifs_leaderboard_fnOnSuccess
		Popup_Busy.fnOnFail = ifs_leaderboard_fnOnFail
		Popup_Busy.fnOnCancel = ifs_leaderboarddetails_fnOnCancel
		Popup_Busy.bNoCancel = nil
		Popup_Busy.fTimeout = 10 -- seconds
		IFText_fnSetString(Popup_Busy.title,"ifs.stats.downloading")
		Popup_Busy:fnActivate(1)	
	end
end

-- process when user scroll the list
function ifs_mp_leaderboard_fnListScroll( this, direction )
	if(gPlatformStr == "PC") then
		if( table.getn( leaderboard_listbox_contents ) == 0 ) then
			return
		end
	end
	--print(" --ifs_mp_leaderboard_fnListScroll( this, ", direction, " ) " )
	--print(" table.getn( leaderboard_listbox_contents ) = ", table.getn( leaderboard_listbox_contents ) )	
	--print(" board size = ", this.iBoardSize )	
	--print( "leaderboard_listbox_layout.SelectedIdx = ", leaderboard_listbox_layout.SelectedIdx )
	--print( "leaderboard_listbox_contents[leaderboard_listbox_layout.SelectedIdx].rankfield = ", leaderboard_listbox_contents[leaderboard_listbox_layout.SelectedIdx].rankfield )	
	if( ( leaderboard_listbox_layout.SelectedIdx == nil ) or 
		( leaderboard_listbox_contents[leaderboard_listbox_layout.SelectedIdx] == nil ) ) then
		return
	end
	local current_rank_id = tonumber( leaderboard_listbox_contents[leaderboard_listbox_layout.SelectedIdx].rankfield )
	--print( "current_rank_id = ", current_rank_id )
	
	local get_new_data = nil
	-- is it need to get new data?
	if( direction == 1 ) then
		-- scroll down the list
		if( ( leaderboard_listbox_layout.SelectedIdx == table.getn( leaderboard_listbox_contents ) ) and
			( current_rank_id < this.iBoardSize ) ) then
			-- get new data
			get_new_data = 1
			this.nextRankID = current_rank_id + 1
		end
	elseif( direction == -1 ) then
		-- scroll up the list
		if( ( leaderboard_listbox_layout.SelectedIdx == 1 ) and
			( current_rank_id > 1 ) ) then
			-- get new data
			get_new_data = 1
			this.nextRankID = current_rank_id - 1
		end		
	end
	--print( "1 get_new_data = ", get_new_data )
	--print( "1 this.nextRankID = ", this.nextRankID )

	-- Xbox friends only
	if(gPlatformStr == "XBox") then			
		-- get friends at one time, so do not get new data when in friends filter
		if( this.iPlayerFilter == 2 ) then
			get_new_data = nil
		end
	end
	
	--print( "2 get_new_data = ", get_new_data )
	if( get_new_data ) then
		ifs_mp_leaderboard_fnStartEnumerate( this, current_rank_id, direction )
	end		
end

ifs_mp_leaderboard = NewIFShellScreen {
	nologo = 1,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bg_texture = "iface_bg_1",
	bNohelptext_backPC = 1,

--	bCursorOnLeft = 1,

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function

		if(gPlatformStr ~= "PC") then
			gHelptext_fnMoveIcon(this.Helptext_PlayerFilter)
			gHelptext_fnMoveIcon(this.Helptext_Detail)
		else
			-- set pc profile & title version text
			UpdatePCTitleText(this)
			IFObj_fnSetVis( this.title, nil )
			IFObj_fnSetVis( this.filter_buttons.time, nil )
			
			-- set gamespy login name
			if( ScriptCB_IsLoggedIn() ) then
				IFText_fnSetString( this.LoginAsText1, "ifs.mp.join.login_as" )
				local NickStr, EmailStr, PasswordStr, iSaveType, iPromptType = ScriptCB_GetGSProfileInfo()
			if(ScriptCB_GetLoginName) then
				NickStr = ScriptCB_GetLoginName()
			else
				NickStr = "Get latest executable!"
			end
				IFText_fnSetString( this.LoginAsText2, NickStr )
				IFObj_fnSetVis( this.LoginAsText2, 1 )
			else
				IFText_fnSetString( this.LoginAsText1, "ifs.mp.join.notlogin" )
				IFObj_fnSetVis( this.LoginAsText2, nil )
			end					
			
			-- fill in gamemode listbox
			ListManager_fnFillContents(this.mode_listbox,LeaderBoard_GameMode_List,ifs_mp_leaderboard_mode_listbox_layout)
			ifs_mp_leaderboard_fnShowModeDropbox( this, nil )
			-- set filter button not visable
			IFObj_fnSetVis( this.filter_buttons.mode, nil )
		end

		--set to none input repeat
		ScriptCB_SetInputRepeat( false )
		
		if( bFwd ) then
			-- tabs	
			if(gPlatformStr == "PC") then
				ifelem_tabmanager_SetSelected(this, gPCMainTabsLayout, "_tab_multi")			
				ifelem_tabmanager_SetSelected(this, gPCMultiPlayerTabsLayout, "_tab_leaderboard", 1)
				if( ScriptCB_IsLoggedIn() ) then
					ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_friends", nil, 1 )
					--ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_leaderboard", nil )
				else
					ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_friends", 1, 1 )
					--ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_leaderboard", 1, 1 )
				end
			end
		
			-- Reset listbox, show it. [Remember, Lua starts at 1!]
			leaderboard_listbox_layout.FirstShownIdx = 1
			leaderboard_listbox_layout.SelectedIdx = 1
			leaderboard_listbox_layout.CursorIdx = 1

			this.iCurStatsPage = 1 -- Default to first page of stats
	--		ScriptCB_GetStats(this.iCurStatsPage)
			
			--ListManager_fnFillContents(this.listbox,leaderboard_listbox_contents,leaderboard_listbox_layout)
			this.iPlayerFilter = 1
			this.iPlayerFilterEnable = 1
			local empty_table = {}
			ListManager_fnFillContents( this.listbox, empty_table, leaderboard_listbox_layout )
			ListManager_fnFillContents( this.detail_listbox, empty_table, ifs_mp_leaderboard_details_listbox_layout )
			ifs_mp_leaderboard_fnStartEnumerate( this, 1, 0 )

			if(gPlatformStr == "PC") then
				IFObj_fnSetVis( this.Download_Text,nil )
			end
		end
	end,

	Exit = function(this, bFwd)
		--set to input repeat
		ScriptCB_SetInputRepeat( true )
	end,

	-- Accept button bumps the page
	Input_Accept = function(this)
		-- If the tab manager handled this event, then we're done
		if((gPlatformStr == "PC") and
		   ( ifelem_tabmanager_HandleInputAccept(this, gPCMainTabsLayout) or
		     ifelem_tabmanager_HandleInputAccept(this, gPCMultiPlayerTabsLayout, 1) ) ) then
			return
		end

		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then		
			if(gPlatformStr == "PC") then
				--print( "gMouseListBox = ", gMouseListBox )
				--print( "leaderboard_listbox_layout.SelectedIdx = ", leaderboard_listbox_layout.SelectedIdx )
				--print( "leaderboard_listbox_layout.CursorIdx = ", leaderboard_listbox_layout.CursorIdx )
				if( gMouseListBox and ( leaderboard_listbox_layout.SelectedIdx == leaderboard_listbox_layout.CursorIdx ) ) then
				end
			else
				return
			end
		end

--		if(this.bCursorOnLeft) then
--			ifs_personalstats.fTeam = 1
--			ifs_personalstats.fIdx = teamstats_listbox_layoutL.SelectedIdx
--		else
--			ifs_personalstats.fTeam = 2
--			ifs_personalstats.fIdx = teamstats_listbox_layoutR.SelectedIdx
--		end
--      ifs_movietrans_PushScreen(ifs_personalstats)
--		ScriptCB_SndPlaySound("shell_menu_enter");
--		this.fCurIdleTime = this.fMAX_IDLE_TIME 

		-- filter button for PC
		if(gPlatformStr == "PC") then
		
			-- gamemode dropdown box
			ifs_mp_leaderboard_fnClickDropDownButtons( this )
			
			--print( "press ", gCurHiliteButton.tag )
			if( gCurHiliteButton ) then
				this.CurButton = gCurHiliteButton.tag
			end
		
			if(this.CurButton == "_btn_player") then
				this.iPlayerFilterEnable = 1
				this.iPlayerFilter = 1
				ifs_mp_leaderboard_fnStartEnumerate( this, 1, 0 )
			elseif(this.CurButton == "_btn_top") then
				this.iPlayerFilterEnable = 1
				this.iPlayerFilter = 3
				ifs_mp_leaderboard_fnStartEnumerate( this, 1, 0 )
			elseif(this.CurButton == "_btn_time") then
				this:Input_Misc()
			elseif(this.CurButton == "_btn_mode") then
				--this:Input_GeneralRight()
			end
			
			if( gMouseListBox and ( leaderboard_listbox_layout.SelectedIdx == leaderboard_listbox_layout.CursorIdx ) ) then
			else
				return
			end
					
			-- not go to detail screen for PC
			return
		end

		--print( "leaderboard_listbox_layout.SelectedIdx =", leaderboard_listbox_layout.SelectedIdx )
		--print(" table.getn( leaderboard_listbox_contents ) = ", table.getn( leaderboard_listbox_contents ) )
		if( leaderboard_listbox_layout.SelectedIdx <= table.getn( leaderboard_listbox_contents ) ) then
			-- init gamertag info
			ifs_mp_leaderboarddetails.gamertag = leaderboard_listbox_contents[leaderboard_listbox_layout.SelectedIdx].namefield
			ifs_mp_leaderboarddetails.playerrank = leaderboard_listbox_contents[leaderboard_listbox_layout.SelectedIdx].rankfield
			ifs_mp_leaderboarddetails.playerrating = leaderboard_listbox_contents[leaderboard_listbox_layout.SelectedIdx].ratingfield
			ifs_mp_leaderboarddetails.playerindex = leaderboard_listbox_layout.SelectedIdx
			
			ifs_movietrans_PushScreen(ifs_mp_leaderboarddetails)
			ScriptCB_SndPlaySound("shell_menu_enter");
		end
	end,

	--Back button quits stats
--	Input_Back = function(this)
--	end,

	-- No U/D/L/R functionality possible on this screen (gotta have stubs
	-- here, or the base class will override)

	Input_GeneralUp = function(this)
		local old_idx = leaderboard_listbox_layout.SelectedIdx;
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputUp(this)) then
			--return
		end
		
		local current_idx = leaderboard_listbox_layout.SelectedIdx;
		
		if(gPlatformStr ~= "PC") then
			ListManager_fnNavUp(this.listbox,leaderboard_listbox_contents,leaderboard_listbox_layout)
		end

		-- if already at the top of the list, check if there are more data
		if( (current_idx == 1) and (old_idx == 1) ) then
			--print( " general up " )
			ifs_mp_leaderboard_fnListScroll( this, -1 )	
		end		
	end,

	Input_GeneralDown = function(this)
		local old_idx = leaderboard_listbox_layout.SelectedIdx;
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputDown(this)) then
			--return
		end
		
		local current_idx = leaderboard_listbox_layout.SelectedIdx;
		
		if(gPlatformStr ~= "PC") then
			ListManager_fnNavDown(this.listbox,leaderboard_listbox_contents,leaderboard_listbox_layout)
		end

		-- if already at the bottom of the list, check if there are more data
		--print( "old_idx = ", old_idx )
		--print( "current_idx = ", current_idx )
		--print( "table.getn( leaderboard_listbox_contents ) = ", table.getn( leaderboard_listbox_contents ) )
		if( current_idx and ( current_idx == table.getn( leaderboard_listbox_contents ) ) 
			and ( old_idx == table.getn( leaderboard_listbox_contents ) ) ) then
			--print( " general down " )
			ifs_mp_leaderboard_fnListScroll( this, 1 )		
		end
		
		--validate the cursor position (make sure we're not on a null entry)
--		ifs_teamstats_fnValidateCursor(this)
	end,

	Input_LTrigger = function(this)
		ListManager_fnPageUp(this.listbox,leaderboard_listbox_contents,leaderboard_listbox_layout)
		--print( " page up " )
		ifs_mp_leaderboard_fnListScroll( this, -1 )			
	end,
	Input_RTrigger = function(this)
		ListManager_fnPageDown(this.listbox,leaderboard_listbox_contents,leaderboard_listbox_layout)
		--print( " page down " )
		ifs_mp_leaderboard_fnListScroll( this, 1 )					
		--validate the cursor position (make sure we're not on a null entry)
--		ifs_teamstats_fnValidateCursor(this)
	end,

	Input_GeneralLeft = function(this)
--		ifs_teamstats_fnFlipLeftRight(this)
		ScriptCB_SndPlaySound("shell_select_change");
		
		-- change game mode
		this.iGameMode = this.iGameMode - 1		
		if( this.iGameMode < this.iGameModeMin ) then
			this.iGameMode = this.iGameModeMax
		end

		this.iPlayerFilterEnable = 1
		ifs_mp_leaderboard_fnStartEnumerate( this, 1, 0 )			
	end,
	
	Input_GeneralRight = function(this)
--		ifs_teamstats_fnFlipLeftRight(this)
		ScriptCB_SndPlaySound("shell_select_change");

		-- change game mode
		this.iGameMode = this.iGameMode + 1
		if( this.iGameMode > this.iGameModeMax ) then
			this.iGameMode = this.iGameModeMin
		end

		this.iPlayerFilterEnable = 1
		ifs_mp_leaderboard_fnStartEnumerate( this, 1, 0 )			
	end,

	Input_Misc = function(this)
		-- update time filter
		this.iTimeFilterEnable = 1
		this.iTimeFilter = this.iTimeFilter + 1
		if( this.iTimeFilter > this.iTimeFilterMax ) then
			this.iTimeFilter = this.iTimeFilterMin
		end	

		this.iPlayerFilterEnable = 1
		ifs_mp_leaderboard_fnStartEnumerate( this, 1, 0 )			
	end,
	
	Input_Misc2 = function(this)
		-- update player filter
		this.iPlayerFilterEnable = 1
		this.iPlayerFilter = this.iPlayerFilter + 1
		
		-- no friends list for gamespy
		if(gPlatformStr ~= "XBox") then
			if( this.iPlayerFilter == 2 ) then
				this.iPlayerFilter = this.iPlayerFilter + 1
			end
		end
		
		if( this.iPlayerFilter > this.iPlayerFilterMax ) then
			this.iPlayerFilter = this.iPlayerFilterMin
		end
		ifs_mp_leaderboard_fnStartEnumerate( this, 1, 0 )			
	end,

	Update = function(this, fDt)
 		-- Call default base class's update function (make button bounce)
 		gIFShellScreenTemplate_fnUpdate(this,fDt)

		-- update text
		ifs_mp_leaderboard_fnUpdateText( this )
		
		if(gPlatformStr == "PC") then
			if( gMouseListBox ) then
				if( gMouseListBox == this.LeftList ) then
					this.bCursorOnLeft = 1
				else
					this.bCursorOnLeft = nil
				end
				this.RepaintListbox( this, this.bCursorOnLeft )
			end		
		end
		
		-- update detail
		ifs_mp_leaderboard_fnUpdateDetailListbox( this )
 	end,


	-- Callback (from C++) to repaint the listbox with the current contents
	-- in the global leaderboard_listbox_layout
 	RepaintListbox = function(this)
 		ListManager_fnFillContents( this.listbox, leaderboard_listbox_contents, leaderboard_listbox_layout )
	end,


}

function ifs_mp_leaderboard_fnHelptext(this)

	-- do not need the buttons for PC
	if(gPlatformStr == "PC") then
		return		
	end

	-- button "Monthly"
	this.Helptext_TimeFilter = NewHelptext {
		ScreenRelativeX = 0.0, -- left
		ScreenRelativeY = 1.0, -- bottom
		y = -25, -- just above bottom
		x = 0,
		buttonicon = "btnmisc",
		string = "ifs.mp.leaderboard.monthly",
	}

	-- button "Back"
	this.Helptext_MyBack = NewHelptext {
		ScreenRelativeX = 0.0, -- left
		ScreenRelativeY = 1.0, -- bottom
		y = -4, -- just above bottom
		x = 0,
		buttonicon = "btnb",
		string = "common.back",
	}

	-- button "Friends"
	this.Helptext_PlayerFilter = NewHelptext {
		ScreenRelativeX = 1.0, -- right
		ScreenRelativeY = 1.0, -- bottom
		y = -25, -- just above bottom of screen
		x = 0,
		buttonicon = "btnmisc2",
		string = "ifs.mp.leaderboard.friends",
		bRightJustify = 1,
	}

	-- button "Detail"
	this.Helptext_Detail = NewHelptext {
		ScreenRelativeX = 1.0, -- right
		ScreenRelativeY = 1.0, -- bottom
		y = -4, -- just above bottom of screen
		x = 0,
		buttonicon = "btna", 
		string = "ifs.stats.details",
		bRightJustify = 1,
	}
end

function ifs_mp_leaderboard_mode_listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { x = layout.x - 0.5 * layout.width, y=layout.y}
	Temp.NameStr = NewIFText{ x = 10, y = -7, halign = "left", font = "gamefont_tiny", textw = 250, nocreatebackground = 1, startdelay=math.random()*0.5, }
	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_mp_leaderboard_mode_listbox_PopulateItem(Dest,Data)
	if(Data) then
		-- Show this entry
		IFText_fnSetString(Dest.NameStr,Data.string)
		IFObj_fnSetVis(Dest.NameStr,1)
	else
		-- Blank this entry
		IFText_fnSetString(Dest.NameStr,"")
		IFObj_fnSetVis(Dest.NameStr,nil)
	end
end

ifs_mp_leaderboard_mode_listbox_layout = {	
	showcount = 4,
	yHeight = 20,
	ySpacing  = 0,
	width = 260,
	x = 0,
	hilight_offset_y = -3,
--	slider = 1,
	CreateFn = ifs_mp_leaderboard_mode_listbox_CreateItem,
	PopulateFn = ifs_mp_leaderboard_mode_listbox_PopulateItem,
}

function ifs_mp_leaderboard_fnAddPCButtons(this)
	local mode_width = ifs_mp_leaderboard_mode_listbox_layout.width
	local mode_y = 40
	
	this.mode_button = NewPCDropDownButton {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.0 ,
		y = mode_y,
		x = 3,
		btnw = mode_width,
		btnh = ScriptCB_GetFontHeight("gamefont_medium"),
		font = "gamefont_medium",
		tag = "_btn_mode",
		string = "",
	}

	this.mode_listbox = NewButtonWindow 
	{	ZPos = 100, x=0, y = mode_y + 58,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.0, 
		bg_texture = "border_dropdown",
		width = mode_width,
		height = ifs_mp_leaderboard_mode_listbox_layout.showcount * (ifs_mp_leaderboard_mode_listbox_layout.yHeight + ifs_mp_leaderboard_mode_listbox_layout.ySpacing) + 20,
	}
	
	ListManager_fnInitList(this.mode_listbox,ifs_mp_leaderboard_mode_listbox_layout)
	IFObj_fnSetVis(this.mode_listbox,nil)
end

function ifs_mp_leaderboard_fnShowModeDropbox( this, enable )	
	IFObj_fnSetVis(this.mode_listbox, enable)
	this.bModeDropBoxesOpen = enable
end

function ifs_mp_leaderboard_fnClickDropDownButtons( this )
	if( this.bModeDropBoxesOpen ) then
		if( gMouseListBox == this.mode_listbox ) then
			if( ifs_mp_leaderboard_mode_listbox_layout.CursorIdx ) then
				ifs_mp_leaderboard_mode_listbox_layout.SelectedIdx = ifs_mp_leaderboard_mode_listbox_layout.CursorIdx
			end
--			print( "ifs_login_diff_listbox_layout.SelectedIdx = ", ifs_login_diff_listbox_layout.SelectedIdx )
		end
		ifs_mp_leaderboard_fnShowModeDropbox( this, nil )
		if( ( ifs_mp_leaderboard_mode_listbox_layout.SelectedIdx ) and 
			( this.iGameMode ~= ifs_mp_leaderboard_mode_listbox_layout.SelectedIdx ) )then
						
			this.iGameMode = ifs_mp_leaderboard_mode_listbox_layout.SelectedIdx
			RoundIFButtonLabel_fnSetString( this.mode_button, LeaderBoard_GameMode_List[this.iGameMode].string )
			
			-- start new filter
			ScriptCB_SndPlaySound("shell_select_change");
			this.iPlayerFilterEnable = 1
			ifs_mp_leaderboard_fnStartEnumerate( this, 1, 0 )			
		end	
	else
		-- open the drop box
		if( this.CurButton == "_btn_mode" ) then
			ifs_mp_leaderboard_fnShowModeDropbox( this, 1 )
		end
	end
end

leaderboard_detail_listbox_contents_onecolumn = {
	{ name = "ifs.stats.points", value = "points" }, 
	{ name = "ifs.stats.hero_points", value = "hero_points" }, 
	{ name = "ifs.stats.game_start", value = "game_start" }, 
	{ name = "ifs.stats.game_finish", value = "game_finish" },
	{ name = "ifs.stats.kills", value = "kills" }, 
	{ name = "ifs.stats.deaths", value = "deaths" },
	{ name = "ifs.stats.totalTimePlayed", value = "totalTimePlayed" }, 
	{ name = "ifs.stats.lastgameplayed", value = "lastGamePlayed" },
	{ name = "ifs.stats.livingstreak", value = "livingStreak" },
}

function ifs_mp_leaderboard_OneColumn_Listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { x = layout.x - 0.5 * layout.width, y=layout.y }

	local listBoxWidth = layout.width
	local sidePadding = 10 --0.1*listBoxWidth
	local y_offset = -5

	Temp.name1 = NewIFText{ nocreatebackground=1, clip = "character", x = sidePadding, y = y_offset, textw = 0.5*listBoxWidth - sidePadding, halign = "left", font = "gamefont_tiny",}
	Temp.value1 = NewIFText{ nocreatebackground=1, clip = "character", x = listBoxWidth - 0.5*listBoxWidth, y = y_offset, textw = 0.5*listBoxWidth - sidePadding, halign = "right", font = "gamefont_tiny",ColorR= 255, ColorG = 255, ColorB = 255,}
	
	return Temp
end


function ifs_mp_leaderboard_OneColumn_Listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	if(Data) then		

		IFObj_fnSetColor(Dest.name1, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.name1, fAlpha)
		IFObj_fnSetColor(Dest.value1, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.value1, fAlpha)

		IFText_fnSetString(Dest["name1"],Data.name)
		IFObj_fnSetVis(Dest["name1"], 1)
		IFObj_fnSetVis(Dest["value1"], 1)
		--IFText_fnSetUString(Dest["value1"], value)
		IFText_fnSetString(Dest["value1"], Data.value or "")
	end
	IFObj_fnSetVis(Dest,Data) -- Show if there are contents
end

ifs_mp_leaderboard_details_listbox_layout = {
	showcount = 6,
--	yTop = -100,
	yHeight = 12,
	ySpacing = 2,
	width = 430,
	x = 0,
	slider = 1,
--	scrollby = 1,
	CreateFn = ifs_mp_leaderboard_OneColumn_Listbox_CreateItem,
	PopulateFn = ifs_mp_leaderboard_OneColumn_Listbox_PopulateItem,
}

function ifs_mp_leaderboard_fnUpdateDetailListbox(this)
	-- set detail data
	--print("leaderboard_listbox_layout.SelectedIdx = ", leaderboard_listbox_layout.SelectedIdx )
	--print("leaderboard_listbox_layout.CursorIdx = ", leaderboard_listbox_layout.CursorIdx )
	local index = leaderboard_listbox_layout.SelectedIdx
	--if( index and ( this.detail_index ~= index ) and leaderboard_listbox_contents[index].ratingfield ) then
	--	this.detail_index = index
		leaderboard_detail_listbox_contents_onecolumn[1].value = leaderboard_listbox_contents[index].ratingfield
		leaderboard_detail_listbox_contents_onecolumn[2].value = leaderboard_listbox_contents[index].HeroPoints
		leaderboard_detail_listbox_contents_onecolumn[3].value = leaderboard_listbox_contents[index].Starts
		leaderboard_detail_listbox_contents_onecolumn[4].value = leaderboard_listbox_contents[index].Finishes
		leaderboard_detail_listbox_contents_onecolumn[5].value = leaderboard_listbox_contents[index].Kills
		leaderboard_detail_listbox_contents_onecolumn[6].value = leaderboard_listbox_contents[index].Deaths
		leaderboard_detail_listbox_contents_onecolumn[7].value = leaderboard_listbox_contents[index].TotalTimePlayed
		leaderboard_detail_listbox_contents_onecolumn[8].value = leaderboard_listbox_contents[index].LastGamePlayed
		leaderboard_detail_listbox_contents_onecolumn[9].value = leaderboard_listbox_contents[index].LongestLiving

		ListManager_fnFillContents( this.detail_listbox, leaderboard_detail_listbox_contents_onecolumn, ifs_mp_leaderboard_details_listbox_layout )
	--end
end

-- Helper function, sets up parts of this screen that need any
-- programmatic work (i.e. scaling to screensize)
function ifs_mp_leaderboard_fnInitScreen(this)
	-- Inset slightly from fulls screen size
	local screenWidth,screenHeight,widescreen = ScriptCB_GetSafeScreenInfo()
	screenWidth = screenWidth * widescreen

	local ScreenTitleY = 0
	local ColumnTitleY = ScreenTitleY + 72
	local ColumnTitleY1 = ScreenTitleY + 17			-- for boardsize text
	local ColumnTitleY2 = ScreenTitleY + 42			-- for boardsize number
	local ListBoxY = ScreenTitleY + 70
	local BottomBarY = screenHeight - 40
	ifs_mp_leaderboard.ColumnRankingWidth = 0.25*screenWidth;
	ifs_mp_leaderboard.ColumnNameWidth = 0.48*screenWidth;
	ifs_mp_leaderboard.ColumnRatingWidth = 0.25*screenWidth;
	
	-- add pc profile & title version text
	if(gPlatformStr == "PC") then
		AddPCTitleText( this )
	end
	
	-- top row contains the title
	this.title = NewIFText {
		string = "ifs.Main.leaderboard",
		font = "gamefont_medium",
		y = ScreenTitleY,
		textw = 460, -- center on screen. Fixme: do real centering!
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0, -- top
		ColorR= 255, ColorG = 255, ColorB = 255, -- Something that's readable!
		nocreatebackground = 1,
	}

	-- game mode 
	this.iGameMode = 1
	this.iGameModeMin = 1
	this.iGameModeMax = 4
	
	-- filters
	this.iTimeFilter = 1
	this.iTimeFilterEnable = 1
	this.iTimeFilterMin = 1
	this.iTimeFilterMax = 3
	this.iPlayerFilter = 1
	this.iPlayerFilterEnable = 1
	this.iPlayerFilterMin = 1
	this.iPlayerFilterMax = 3
	
	-- board size
	this.iBoardSize = 0
	this.nextRankID = nil
	this.iBoardID = 1
	
	if(gPlatformStr ~= "PC") then
		-- gamemode selection
		this.GameMode_Text = NewIFText {
			ZPos = 200,
			string = "ifs.Main.leaderboard",
			font = "gamefont_medium",
			textw = 500, -- center on screen. Fixme: do real centering!
			ScreenRelativeX = 0.5, -- center
			ScreenRelativeY = 0.08, -- top
			ColorR= 255, ColorG = 255, ColorB = 255, -- Something that's readable!
			nocreatebackground = 1,
		}
	end

	-- board size text
	this.BoardSize_Text = NewIFText {
		ZPos = 200,
		string = "ifs.mp.leaderboard.boardsize",
		font = "gamefont_small",
		textw = screenWidth * 0.3, texth = 50, valign = "bottom", -- Fix for 11359 - wrap long strings - NM 8/25/05
		ScreenRelativeX = 0.12, -- left side
		ScreenRelativeY = 0.0, -- top
		y = ColumnTitleY1 - 25, -- move up, since it's bottom-aligned
		ColorR= 255, ColorG = 255, ColorB = 255, -- Something that's readable!
		nocreatebackground = 1,
	}

	-- board size number
	this.BoardSize_Num = NewIFText {
		ZPos = 200,
		string = "",
		font = "gamefont_small",
		textw = 200, -- center on screen. Fixme: do real centering!
		ScreenRelativeX = 0.12, -- center
		ScreenRelativeY = 0.0, -- top
		y = ColumnTitleY2 - 5,
		ColorR= 255, ColorG = 255, ColorB = 255, -- Something that's readable!
		nocreatebackground = 1,
	}

	-- Fix for BF2 bug # 10568 - 'board size' is one HUGE word in German. Give it
	-- a little more space - NM 8/25/05
	if(gLangStr == "german") then
		this.BoardSize_Text.font = "gamefont_tiny"
		this.BoardSize_Text.textw = screenWidth * 0.33
		this.BoardSize_Text.ScreenRelativeX = 0.13 -- left side
		this.BoardSize_Num.font = "gamefont_tiny"
		this.BoardSize_Num.textw = screenWidth * 0.33
		this.BoardSize_Num.ScreenRelativeX = 0.13 -- left side
	end


	if(gPlatformStr ~= "PC") then
		-- player filter text
		this.PlayerFilter_Text = NewIFText {
			ZPos = 200,
			string = "ifs.mp.leaderboard.me",
			font = "gamefont_medium",
			textw = 200, -- center on screen. Fixme: do real centering!
			ScreenRelativeX = 0.9, -- center
			ScreenRelativeY = 0.0, -- top
			y = ColumnTitleY1,
			ColorR= 255, ColorG = 255, ColorB = 255, -- Something that's readable!
			nocreatebackground = 1,
		}

		-- board size number
		this.TimeFilter_Text = NewIFText {
			ZPos = 200,
			string = "ifs.mp.leaderboard.weekly",
			font = "gamefont_medium",
			textw = 200, -- center on screen. Fixme: do real centering!
			ScreenRelativeX = 0.9, -- center
			ScreenRelativeY = 0.0, -- top
			y = ColumnTitleY2,
			ColorR= 255, ColorG = 255, ColorB = 255, -- Something that's readable!
			nocreatebackground = 1,
		}
	end
	
	if(gPlatformStr == "PC") then
		local x_offset = 80
		this.filter_buttons = NewIFContainer
		{		
			ScreenRelativeX = 0.5,
			ScreenRelativeY = 0,
			y = 500,
			halign = "hcenter",
							
			player = NewPCIFButton -- NewRoundIFButton
			{
				x = x_offset,
				y = 40,
				btnw = 150, -- made wider to fix 9173 - NM 8/25/04
				btnh = 10,
				font = "gamefont_small",
				--halign = "hcenter",
				--bg_width = BackButtonW,
				--bg_xflipped = 1,
				tag = "_btn_player",
				--nocreatebackground=1,
				string = "ifs.mp.leaderboard.me",
				
			}, -- end of btn

			top = NewPCIFButton -- NewRoundIFButton
			{
				x = 200 + x_offset,
				y = 40,
				btnw = 150, -- made wider to fix 9173 - NM 8/25/04
				btnh = 10,
				font = "gamefont_small",
				--halign = "hcenter",
				--bg_width = BackButtonW,
				--bg_xflipped = 1,
				tag = "_btn_top",
				--nocreatebackground=1,
				string = "ifs.mp.leaderboard.top",
			}, -- end of btn

			time = NewClickableIFButton -- NewRoundIFButton
			{
				x = 300,
				y = 25,
				btnw = 250, -- made wider to fix 9173 - NM 8/25/04
				btnh = 10,
				font = "gamefont_medium",
				halign = "hcenter",
				--bg_width = BackButtonW,
				--bg_xflipped = 1,
				tag = "_btn_time",
				nocreatebackground=1,
				
			}, -- end of btn
			
			mode = NewClickableIFButton -- NewRoundIFButton
			{
				x = 0,
				y = 25,
				btnw = 250, -- made wider to fix 9173 - NM 8/25/04
				btnh = 10,
				font = "gamefont_medium",
				halign = "hcenter",
				--bg_width = BackButtonW,
				--bg_xflipped = 1,
				tag = "_btn_mode",
				nocreatebackground=1,
				
			}, -- end of btn			
		}		
		this.filter_buttons.player.label.halign = "hcenter"
		this.filter_buttons.time.label.halign = "hcenter"
		this.filter_buttons.mode.label.halign = "hcenter"
		RoundIFButtonLabel_fnSetString( this.filter_buttons.player, "ifs.mp.leaderboard.me" )
		RoundIFButtonLabel_fnSetString( this.filter_buttons.time, "ifs.mp.leaderboard.weekly" )
		RoundIFButtonLabel_fnSetString( this.filter_buttons.mode, "ifs.mp.leaderboard.conquest" )
	end
	
	-- downloading
	this.Download_Text = NewIFText {
		ZPos = 200,
		string = "ifs.mp.leaderboard.download",
		font = "gamefont_medium",
		textw = 500, -- center on screen. Fixme: do real centering!
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.92, -- top
		ColorR= 255, ColorG = 255, ColorB = 255, -- Something that's readable!
		nocreatebackground = 1,
	}

	local offset_y = -18
	this.rankTitle = NewIFText {
		ZPos = 100,
		string = "ifs.stats.rank",
		font = "gamefont_small",
		halign = "left",
		valign = "vcenter",
		x = 65,
		y = ColumnTitleY + offset_y,
		ScreenRelativeX = 0.0, -- center
		ScreenRelativeY = 0.0, -- top
		ColorR= 255, ColorG = 255, ColorB = 255, -- Something that's readable!
		nocreatebackground = 1,
	}

	this.nameTitle = NewIFText {
		ZPos = 100,
		string = "ifs.stats.playername",
		font = "gamefont_small",
		halign = "hcenter",
		valign = "vcenter",
		x = 0,
		y = ColumnTitleY + offset_y,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.0, -- top
		ColorR= 255, ColorG = 255, ColorB = 255, -- Something that's readable!
		nocreatebackground = 1,
		textw = 300,
	}

	this.ratingTitle = NewIFText {
		ZPos = 100,
		string = "ifs.stats.rating",
		font = "gamefont_small",
		halign = "right",
		valign = "vcenter",
		x = -80,
		y = ColumnTitleY + offset_y,
		ScreenRelativeX = 1.0, -- center
		ScreenRelativeY = 0.0, -- top
		ColorR= 255, ColorG = 255, ColorB = 255, -- Something that's readable!
		nocreatebackground = 1,
	}

	this.rankTitle.x = this.rankTitle.x - this.rankTitle.textw*0.5
	this.nameTitle.x = this.nameTitle.x - this.nameTitle.textw*0.5
	this.ratingTitle.x = this.ratingTitle.x - this.ratingTitle.textw*0.5

	-- helptext
	ifs_mp_leaderboard_fnHelptext( this )
	
	this.listbox = NewButtonWindow { 
		ZPos = 200,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.0, -- middle of screen
		width = screenWidth,
		height = BottomBarY - ListBoxY - 110,
		x = 0,
		y = (BottomBarY - ListBoxY)*0.5 + ListBoxY - 70,
	}

	leaderboard_listbox_layout.width = screenWidth - 35
	leaderboard_listbox_layout.showcount = 20 --math.floor((this.listbox.height) / (leaderboard_listbox_layout.yHeight + leaderboard_listbox_layout.ySpacing)) - 1

	if(gPlatformStr == "PC") then
		leaderboard_listbox_layout.yTop = -125
	end
	
	ListManager_fnInitList(ifs_mp_leaderboard.listbox,leaderboard_listbox_layout)

	this.detail_listbox = NewButtonWindow { 
		ZPos = 200,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.0, -- middle of screen
		width = screenWidth,
		height = 110,
		x = 0,
		y = 457,
		font = "gamefont_small",
		titleText = "ifs.Stats.details",
	}
	ifs_mp_leaderboard_details_listbox_layout.width = screenWidth - 35
	ListManager_fnInitList(this.detail_listbox,ifs_mp_leaderboard_details_listbox_layout)
	--ListManager_fnFillContents(this.detail_listbox,leaderboard_detail_listbox_contents_onecolumn,ifs_mp_leaderboard_details_listbox_layout)
	
	if(gPlatformStr == "PC") then
--		print(" +++add tabs")
		-- Add tabs to screen
		ifelem_tabmanager_Create(this, gPCMainTabsLayout, gPCMultiPlayerTabsLayout)
		
		-- add gamespy logo & login
		ifs_mp_sessionlist_fnAddGamespyLogin( this )
		
		-- add gamemode dropdown button
		ifs_mp_leaderboard_fnAddPCButtons( this )
	end
end

ifs_mp_leaderboard_fnInitScreen(ifs_mp_leaderboard)
ifs_mp_leaderboard_fnInitScreen = nil
AddIFScreen(ifs_mp_leaderboard,"ifs_mp_leaderboard")
