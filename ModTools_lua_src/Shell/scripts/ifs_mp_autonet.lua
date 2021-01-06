--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_mp_autonet = NewIFShellScreen {
    
    state = 1,
    
    Enter = function(this, bFwd)
        -- Always call base class functionality
        gIFShellScreenTemplate_fnEnter(this, bFwd)
	ifelem_shellscreen_fnStopMovie()
        
        print("ifs_autonet", ScriptCB_GetAutoNetMode())
        this.state = 1
        if (bFwd) then
            this.state = 1
            this.timer = 1
            
--          ifs_saveop.doOp = "LoadProfile"
--          ifs_saveop.OnSuccess = ifs_mp_autonet_LoadProfileSuccess
--          ifs_saveop.OnCancel = ifs_mp_autonet_LoadProfileCancel
--          ifs_saveop.profile1 = ScriptCB_tounicode("AUTONET")
--          ifs_saveop.profile2 = nil
--          ifs_movietrans_PushScreen(ifs_saveop)
        end
    end,
    
    Update = function(this, fDt)
        this.timer = this.timer - fDt
        if (this.timer < 0) then
            this.timer = 1
            if (this.state == 1) then --Do what ifs_main does
            
                print("AutoNet Main")
                ifs_login_listbox_layout.SelectedIdx = 1
                ifs_login_listbox_contents = {
                    { showstr = ScriptCB_tounicode("AUTONET") },
                }
                ifs_sp.bForSplitScreen = nil
                ScriptCB_SetSplitscreen( nil )
                --
                this.state = 2
            elseif (this.state == 2) then --Do what the multiplayer screen does
                --
                print("AutoNet Multi")
                
            
                this.state = 3
            elseif (this.state == 3) then  --gamespy login
                --skipping gamespy login 
                print("AutoNet Gamespy")
                
                -- do the gs availability check
                ScriptCB_StartLoginDedicatedServer();
                
                if( ScriptCB_SetupAutoNetIsLan() ) then
                    gOnlineServiceStr = "LAN"
                    ScriptCB_SetConnectType("lan")
                else
                    gOnlineServiceStr = "GameSpy"
                end
                this.state = 4
            elseif (this.state == 4) then --ifs_mp_main.lua
                print("AutoNet multi main")
                --gPickedMapList = {
                 -- { Map = "HOT1", Side = 1, SideChar = "i" },
                --  { Map = "nab1c", Side = 1, SideChar = "r" },
                -- }
                
                
                

--              ScriptCB_SetNetLoginName(ScriptCB_GetCurrentProfileNetName()) --only cuz it did it on enter
                ScriptCB_SetNetLoginName(ScriptCB_tounicode("AUTONET"));
                ScriptCB_OpenNetShell(1)
		if(gPlatformStr == "PS2") then
			ScriptCB_UpdateNetConfigs()
			local config = ps2netconfig_listbox_contents[1]
			ScriptCB_ConnectUsingEntry(1,config.combostr)
			if(gOnlineServiceStr ~= "LAN") then
				ScriptCB_StartDNAS()
			end
			ScriptCB_GetConnectSocketsStatus()
		end
                if(     ScriptCB_GetAutoNetScript() ~= "client" ) then
                    print("AutoNet Server")
                    ScriptCB_SetupAutoNetMissions()
                    ScriptCB_SetAmHost(1)
                    ScriptCB_SetGameName( ScriptCB_GetAutoNetGameName() )
										ScriptCB_SetGameRules("mp")
                    this.state = 5
                else
                    print("AutoNet Client")
                    ScriptCB_SetAmHost(nil)
                    this.state = 7 --i dunno, some bizarro state for the client             
                end

                
            elseif (this.state == 5) then --ifs_mp_gameopts.lua
                print("AutoNet Game Options")
                
                local dedicated =  ScriptCB_GetAutoNetScript() == "dedicated"
                local iPrefs = ScriptCB_GetNetGameDefaults()
                ScriptCB_SetNetGameDefaults(iPrefs)
                ScriptCB_SetDedicated(dedicated)
                ScriptCB_BeginLobby()
                this.state = 6
            elseif (this.state == 6) then
                print("Updating Lobby and attempting to Launch")
                ScriptCB_UpdateLobby(nil)
                ScriptCB_LaunchLobby()
            elseif (this.state == 7) then --Client Lobby State
                ScriptCB_BeginSessionList() --init lobby 
                this.state = 8
            elseif (this.state == 8) then --Client Lobby update loop
                print("AutoNet Client: Searching for game:", ScriptCB_GetAutoNetGameName())
                if( ScriptCB_AutoNetJoin() ) then
                    print("Found Game, going to Lobby")
                    this.state = 6
                end
                    
            else
                --ifs_login_listbox_layout.SelectedIdx = 1
                --ifs_login_listbox_contents = {
                --  { showstr = ScriptCB_tounicode("AUTONET") },
                --}
                
                --ScriptCB_PushScreen("ifs_main")
                print("UNKNOWN STATE")
            end
        end
    end,
    
}

function ifs_mp_autonet_LoadProfileSuccess()
    print("ifs_mp_autonet_LoadProfileSuccess")
    local this = ifs_mp_autonet
    Popup_LoadSave2:fnActivate(nil)
    ScriptCB_PopScreen()
end

function ifs_mp_autonet_LoadProfileCancel()
    print("ifs_autonet_LoadProfileCancel")
    local this = ifs_mp_autonet
    Popup_LoadSave2:fnActivate(nil)
    ScriptCB_PopScreen()
end

AddIFScreen(ifs_mp_autonet, "ifs_mp_autonet")
