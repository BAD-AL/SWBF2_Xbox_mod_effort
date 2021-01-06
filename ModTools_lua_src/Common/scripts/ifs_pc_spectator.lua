-- Empty screen for PC spectator
function ifs_pc_Spectator_fnBuildScreen( this, mode )
	
	local BackButtonW = 300 -- made 130 to fix 6198 on PC - NM 8/18/04
	local BackButtonH = 25
	local OffsetY = -15
	
	-- back button
	this.join_game = NewPCIFButton {
		ScreenRelativeX = 0.0, -- left
		ScreenRelativeY = 1.0, -- bottom
		y = OffsetY, -- just above bottom
		x = 120,

		btnw = BackButtonW, 
		btnh = BackButtonH,
		font = "gamefont_medium", 
		bg_tail = 20,
		--nocreatebackground = 1,
		tag = "_back",
	} -- end of Helptext_Back
	
	RoundIFButtonLabel_fnSetString(this.join_game,"common.mp.spectator.join_game")
	
--	-- accept button
--	this.change_view = NewClickableIFButton {
--		ScreenRelativeX = 1.0, -- left
--		ScreenRelativeY = 1.0, -- bottom
--		y = OffsetY, -- just above bottom
--		x = -80,
--		
--		btnw = BackButtonW, 
--		btnh = BackButtonH,
--		font = "gamefont_medium", 
--		bg_tail = 20,
--		nocreatebackground = 1,
--		tag = "_accept",
--	} -- end of Helptext_Accept
--	
--	RoundIFButtonLabel_fnSetString(this.change_view,"common.mp.spectator.change_view")
end

ifs_pc_Spectator = NewIFShellScreen 
{
	nologo = 1,
	bNohelptext_accept = 1, -- we have our own
	bNohelptext_backPC = 1,
	
	Enter = function(this)
		if(this.join_game) then
			IFButton_fnSelect(this.join_game,false, false) -- Deactivate button
		end
	end,

	Input_Back = function(this)
	end,
	Input_Accept = function(this)
	end,	
	Input_GeneralLeft = function(this,bFromAI)
	end,
	Input_GeneralRight = function(this,bFromAI)
	end,
	Input_GeneralUp = function(this,bFromAI)
	end,
	Input_GeneralDown = function(this,bFromAI)
	end,	
}

ifs_pc_Spectator_fnBuildScreen(ifs_pc_Spectator, 0)
AddIFScreen(ifs_pc_Spectator,"ifs_pc_Spectator")
ifs_pc_Spectator_fnBuildScreen = nil
