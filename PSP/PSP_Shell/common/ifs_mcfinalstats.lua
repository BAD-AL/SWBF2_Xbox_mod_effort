-- Decompiled with SWBF2CodeHelper
function MCFinalStats_Listbox_CreateItem(layout)
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y = layout.y - 10
	}

	Temp.labelstr = NewIFText {
		x = -10, y = 0,
		textw = 0.5 * layout.width , halign = "left", 
		font = "gamefont_medium",
		ColorR= 255, ColorG = 255, ColorB = 255,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
	}
	Temp.contentsstr = NewIFText {
        x = (layout.width +10) - 0.80 * layout.width ,
        y = 0, 
        textw = 0.80 *layout.width  , 
        halign = "right", 
		font = "gamefont_medium",
		ColorR= 255, ColorG = 255, ColorB = 255,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
	}
	return Temp
end

function MCFinalStats_Listbox_PopulateItem(Dest, Data)
    if Data then
        IFText_fnSetUString(Dest.labelstr,Data.labelustr )
        IFText_fnSetScale(Dest, 1, 0.80000001192093)
        if Data.contentsustr then
            IFText_fnSetUString(Dest.contentsstr, Data.contentsustr)
        else
            IFText_fnSetString(Dest.contentsstr, Data.contentsstr)
        end
    end
    IFObj_fnSetVis(Dest, Data)
end


MCFinalStats_listbox_layout = {
    showcount = 20,
    yHeight = 18,
    ySpacing = 6,
    width = 430,
    x = 0,
    CreateFn = MCFinalStats_Listbox_CreateItem,
    PopulateFn = MCFinalStats_Listbox_PopulateItem
}
finalstats_listbox_contents = {}

function ifs_mcfinalstats_fnBlankContents(this)
    local i, Max

    local BlankUStr = ScriptCB_tounicode("")
    Max = table.getn(finalstats_listbox_contents)

    for i = 1, Max do
		finalstats_listbox_contents[i].labelustr = BlankUStr
		if(finalstats_listbox_contents[i].contentsustr) then
			finalstats_listbox_contents[i].contentsustr = BlankUStr
		else
			finalstats_listbox_contents[i].contentsstr = ""
		end
	end
    ListManager_fnFillContents(this.listbox, finalstats_listbox_contents, MCFinalStats_listbox_layout)
end

ifs_mcfinalstats = NewIFShellScreen{
    nologo = 1,
    fMAX_IDLE_TIME = 30,
    fCurIdleTime = 0,
    title = NewIFText({
        string = "ifs.stats.mc.congratulations",
        font = "gamefont_large",
        y = 0,
        textw = 460,
        ScreenRelativeX = 0.5,
        ScreenRelativeY = 0,
        ColorR = 255,
        ColorG = 255,
        ColorB = 255,
        style = "big_glow",
        nocreatebackground = 1
    }),
    bgTexture = NewIFImage({
        ZPos = 250,
        ScreenRelativeX = 0,
        ScreenRelativeY = 0,
        UseSafezone = 0,
        texture = "statsscreens_bg",
        localpos_l = 0,
        localpos_t = 0
    }),
    Enter = function(this, bFwd)
        gIFShellScreenTemplate_fnEnter(this, bFwd)
        
        MCFinalStats_listbox_layout.FirstShownIdx = 1
        MCFinalStats_listbox_layout.SelectedIdx = nil
        MCFinalStats_listbox_layout.CursorIdx = nil

        ScriptCB_GetMCFinalStats()
        ListManager_fnFillContents(this.listbox, finalstats_listbox_contents, MCFinalStats_listbox_layout)
        
        if (ScriptCB_InNetGame() and ScriptCB_GetGameRules() == "metagame" and
             ScriptCB_GetAmHost() ) then 
            this.fCurIdleTime = 0 
            gE3StatsTimeout = 0
        end 

    end,
    Exit = function(this, bFwd)
        ifs_mcfinalstats_fnBlankContents(this)
        finalstats_listbox_contents = nil
    end,
    Input_Accept = function(this)
        this.fCurIdleTime = this.fMAX_IDLE_TIME
        ScriptCB_SndPlaySound("shell_menu_exit")
        ScriptCB_QuitFromStatsToShell()
    end,
    Input_GeneralUp = function(this)
        this.fCurIdleTime = this.fMAX_IDLE_TIME
    end,
    Input_GeneralDown = function(this)
        this.fCurIdleTime = this.fMAX_IDLE_TIME
    end,
    Input_GeneralLeft = function(this)
        this.fCurIdleTime = this.fMAX_IDLE_TIME
    end,
    Input_GeneralRight = function(this)
        this.fCurIdleTime = this.fMAX_IDLE_TIME
    end,
    Update = function(this, fDt)
        gIFShellScreenTemplate_fnUpdate(this,fDt)
        -- If the host is busy, then wait on this screen
		if(fDt > 0.5) then
			fDt = 0.5 -- clamp this to sane values
        end
        
        if ScriptCB_CanClientLeaveStats() then
            gE3StatsTimeout = 0
        else
            gE3StatsTimeout = 1
        end
        if gE3StatsTimeout then
            gE3StatsTimeout = gE3StatsTimeout - fDt
        end
    end
}

function ifs_mcfinalstats_fnBuildScreen(this)
	-- Ask game for screen size, fill in values
	local r,b,v,widescreen=ScriptCB_GetScreenInfo()
	this.bgTexture.localpos_l = 0
	this.bgTexture.localpos_t = 0
	this.bgTexture.localpos_r = r*widescreen
	this.bgTexture.localpos_b = b
	this.bgTexture.uvs_b = v

	if(this.Helptext_Back) then
        IFObj_fnSetVis(this.Helptext_Back, nil)
        IFText_fnSetString(this.Helptext_Accept.helpstr, "ifs.stats.done")
	end

	-- Inset slightly from fulls screen size
	local w,h = ScriptCB_GetSafeScreenInfo()
    --	w = w * 0.95
	h = h * 0.82

	this.listbox = NewButtonWindow { 
        ZPos = 200,
        x = 0, y = 0,
        ScreenRelativeX = 0.5,
	    ScreenRelativeY=  0.5,
		width = w,
		height = h,
    }
    MCFinalStats_listbox_layout.width = w - 50
    MCFinalStats_listbox_layout.showcount = math.floor(h/(
            MCFinalStats_listbox_layout.yHeight + MCFinalStats_listbox_layout.ySpacing)  ) -1
    
    ListManager_fnInitList(ifs_mcfinalstats.listbox, MCFinalStats_listbox_layout)

    --local r7 =  NewButtonWindow 
    
    this.listbox = NewIFContainer {
        x = MCStats_listbox_layout.x - 0.5 * MCStats_listbox_layout.width,
        y = (MCStats_listbox_layout.yTop + 5 * (MCStats_listbox_layout.yHeight + MCStats_listbox_layout.ySpacing)) - 10,
        

    }
    --[[
	this.statBox.rightColumn = NewIFContainer {
		x = this.statBox.width * 0.25, y = 0,
		width = this.statBox.width * 0.45,
		height = this.statBox.height,
	}

	
	-- medals window
	this.medalBox = NewIFContainer {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.51,
		width = w,
		height = h * 0.39,
		zPos = 200,
	}
	this.medalBox.window = NewButtonWindow { ZPos = 200,
		x = 0, y = 0,
		width = this.medalBox.width,
		height = this.medalBox.height,
	}

	this.medalBox.label = NewIFText {
		x = this.medalBox.width * -0.5 + 10,
		y = this.medalBox.height * -0.5 + 20,
		textw = this.medalBox.width - 10, halign = "left", font = "gamefont_tiny",
		ColorR= 255, ColorG = 255, ColorB = 0,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
		string = "ifs.stats.CareerMedals",
	}
	this.medalBox.leftColumn = NewIFContainer {
		x = this.medalBox.width * -0.25, y = 18,
		width = this.medalBox.width * 0.45,
		height = this.medalBox.height,
	}
	this.medalBox.rightColumn = NewIFContainer {
		x = this.medalBox.width * 0.25, y = 7,	-- raise this because there are fewer elements in this container
		width = this.medalBox.width * 0.45,
		height = this.medalBox.height,
	}
	
	-- info window
	this.infoBox = NewIFContainer {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.81,
		width = w,
		height = h * 0.215,
	}
	
	this.infoBox.window = NewButtonWindow { ZPos = 200,
		x = 0, y = 0,
		width = this.infoBox.width,
		height = this.infoBox.height,
	}
	this.infoBox.text = NewIFText {
		x = -0.5 * this.infoBox.width + 10, y = -0.5 * this.infoBox.height + 10,
		textw = 0.95 * this.infoBox.width, texth = this.infoBox.height * 0.8,
		halign = "left", font = "gamefont_tiny",
		ColorR= 255, ColorG = 255, ColorB = 255,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
    }
    ]]

    --IFText_fnSetString("ifs.stats.done")
    --ListManager_fnInitList(ifs_mcfinalstats, MCFinalStats_listbox_layout)
end

ifs_mcfinalstats_fnBuildScreen(ifs_mcfinalstats)
ifs_mcfinalstats_fnBuildScreen = nil
AddIFScreen(ifs_mcfinalstats, "ifs_mcfinalstats")
ifs_mcfinalstats = DoPostDelete(ifs_mcfinalstats)
