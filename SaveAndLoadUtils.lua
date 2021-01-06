--
-- SaveAndLoadUtils.lua
-- March 29th, 2009
-- By [RDH]Zerted
-- version 1.0 (r12)
--
-- Terms:
-- * For non-profit use only, unless gained permission from [RDH]Zerted (just so I can brag about it)
--
-- Possible Future Additions:
-- * Store then reload the metagame before/after saving and loading
-- * Allowing to choose between metagame saves or campaign saves


--[[
Tutorial for SaveAndLoadUtils.lua v1 (r12)

To Enable the Script:
1) Find and download the latest SaveAndLoadUtils.lua file
2) Copy SaveAndLoadUtils.lua to the map's data_XXX\Common\scripts
3) Edit the data_XXX\Common\mission.req and add SaveAndLoadUtils to its scripts section
4) In the mission script (example: data_XXX\Common\scripts\XXX\XXXg_con.lua), add ScriptCB_DoFile("SaveAndLoadUtils") near the other ScriptCB_DoFiles at the top of the file
5) Thats it!



To Save Data:
1) Enable the script (see above) 
2) Pick a name for the file.  This tutorial will use the name 'tutorialSaveExample'.  It is important that one picks a longer, unique name.  
	 If someone picks 'sav' and someone else picks 'saving-xxx-data', then whenever 'sav' is saved, the 'saving-xxx-data' file will be deleted!  
	 Any file starting with name will be deleted before saving the new file.  Choose the file names wisely.  It is recommended not to end the name with a number.  
	 Code:

	  local filename = "tutorialSaveExample"

3) Create a function.  This function should take a string as an argument/parameter.  The function will be called when the save operation is finished.  
   If the string is nil, then the saved worked.  If the string is not nil, then the saved failed and the string is the error message.  It is extremely 
	important that the saving function isn't called twice before this 'callback' function is called.  If it is called twice, the game has a very high 
	chance of crashing.  This function is optional, but recommended.  
	This tutorial will use the following function:

local callback = function(message)
	--output the info to debug log
	print("Save result:", message)

	if message == nil then
		--show a 'Save Game Done' ingame message
		ShowMessageText("common.save")
		ShowMessageText("ifs.freeform.done")
	else
		--show a 'Save Game Skip' ingame message
		ShowMessageText("common.save")
		ShowMessageText("ifs.freeform.skip")
	end
end

5) Inorder to save data, one must have data to save.  The data must be contained in a single table.  Other then that, its up to the modder to decide the format of that table and what it contains.  This tutorial will use the following table:

local data = {
	team1Points = GetTeamPoints(1),
	team2Points = GetTeamPoints(2),
	gameTime = ScriptCB_GetMissionTime(),
	"Some other random data",
	{
		"This is a string inside a table, which is inside the 'data' table",
		6,
		"more random stuff"
	},
	"confused yet?",
	"boo!",
}

6) Now that one has the file name, the callback function, and the data, it's time to save.  
   Saving generaly has around a six second delay to complete.  However, the function will return instantly.  
   This is why it is important to use the callback function.  One can think of the callback function as being 
   similar to using the OnTimerElapse() after starting a timer with StartTimer().  A map should not end during this delay period.  
   There are two main side effects for saving (and loading).  First, a player's screen may flicker twice during the saving (and loading).  
   This is due to the game quickly entering and exiting two shell screens during the process.  Second, any stored metagame state is cleared.  
   If one does not know what that means, then it most likely won't be a problem.  Calling the saving function/method with the tutorial's variables looks like this:

util_saveDataToDisk( data, filename, callback )

If one didn't have a callback function, the code would look like:

util_saveDataToDisk( data, filename )

7) Thats it!


3) Create a function.  This function should take a string as its first argument/parameter and a table as its second parameter.  
	The function will be called when the save operation is finished.  If the string par

To Load Data:
1) Enable the script (see above) 
2) Have some data saved using the 'To Save Data' steps (see above)
3) Loading data is done in a similar fashion to saving data.  One must have the file name and should have the callback function.  
	All the conditions that apply to saving data also apply to loading data.  The main different is that the callback function takes 
	a table as a second parameter.  This table is the loaded data, if the load worked.  Instead of making everyone reread the same info, 
	I'll just show you the loading code:

local filename = "tutorialSaveExample"

local callback = function(message, data)
	--output the info to debug log
	print("Load result: msg, data:", message, data)

	if message == nil then
		--show a 'Load Game Done' ingame message
		ShowMessageText("common.load")
		ShowMessageText("ifs.freeform.done")
	else
		--show a 'Load Game Skip' ingame message
		ShowMessageText("common.load")
		ShowMessageText("ifs.freeform.skip")
	end
end

util_loadDataFromDisk( filename, callback )



To Delete Saved Data:
*) Note: This section is a quick addition to the tutorial.  It is not as polished as the rest of the tutorial.  Follow this section (an the other ones too) at your own risk.
1) The util_sendSavedMetagameFileList() function gets a list of the saved metagame files (where the data is stored), then forwards that list to a given function.  
2) The util_deleteRelatedMetagames() function takes a filename and the list of saved metagame files.  It then goes through and deletes all metagame files whose file names begin with the given filename.
3) The code to use util_sendSavedMetagameFileList() and util_deleteRelatedMetagames() together inorder to delete all 'tutorialSaveExample' saves:

util_sendSavedMetagameFileList( function(filelist, maxSaves)
	util_deleteRelatedMetagames("tutorialSaveExample", filelist)
end, false)



Other Info:
* There is a map (SAV) that goes along with this tutorial.  The tutorial map is a timed version of a modified Conquest.  When the timer is up, the teams' points are saved to a file.  When the map restarts, the teams' scores are reloaded.
* The code in this tutorial may be untested.  Assuming I made no typos when writing it, it should work.
--]]



---------------------------------------
--------- 'Public' Functions ----------
---------------------------------------

print("SaveAndLoadUtils v1 (r12) is being loaded")

--
-- Loads data from the disk
--
-- Note: The metagame state will be cleared
-- Note: Do not call this method twice in a row.  Make sure it has completed
--		through errorCall or loadedCall before calling it another time
--
-- Parameters:
--   name      - The start of a .gc file name who's data should be loaded.  This parameter is required
--   callback  - A function which takes a string and a data parameter.  This function will be called when the load finishes.  If the string parameter is not nil, then the load failed.  If the string parameters is nil, then the second data parameter contains the loaded data
--
function util_loadDataFromDisk( name, callback, state, list)
	--crash prevention hack
	--	Note: I haven't noticed util_loadDataFromDisk() needing this, but saving
	--		needs it, so I'll just toss it here too for safty
	if util_LastLoadStateVar == state then
		print("util_loadDataFromDisk(): Double call detected! Aborting crashing call with state: ", state)
		return
	else
		util_LastLoadStateVar = state
	end

	--check input
	if callback == nil then
		callback = function( msg, data )
			--check if the load failed
			if msg ~= nil then
				print("util_loadDataFromDisk(): callback(): Failed: ", msg)
				return
			end
			
			--the load didn't fail
			print("util_loadDataFromDisk(): callback(): Loaded: ", data)
		end
	end
	if (name == nil) or (name == "") then
		callback("The given name cannot be nil or empty")
		return
	end
	--print("util_loadDataFromDisk(): Entered: State: ", state)
	
	--grab the stored metagame file list
	if state == nil then
		local errorMsg = util_sendSavedMetagameFileList(function(list,maxSaves) util_loadDataFromDisk(name,callback,1,list) end, false)
		if errorMsg ~= nil then
			callback( errorMsg )
		end
		return
	end

	--loads the first metagmae starting with the given name
	if state == 1 then
		--for each saved metagame, 
		local i
		local filename
		local spot
		for i=1,table.getn(list) do
			
			--get this file's file name
			filename = ScriptCB_ununicode(list[i].filename)
			print("Checking filename aganist file with index: ", filename, name, i)
			
			--see if the file starts with the given name
			spot = string.find(filename, name)
			if spot == 1 then
				--continue on to the actually loading of the data
				util_delayFunCall( function()
					util_loadDataFromDisk( name, callback, 2, list[i] )
				end, 6, "loadingState2DelayTimer")
				
				--no need to keep searching
				return
			end
		end
		
		--couldn't find a saved metagame file related to the given name
		callback("Error: No related metagame file found: "..name)
		return
	end
	
	--load the metagame from the hard drive
	if state == 2 then
		local filename = ScriptCB_ununicode( list.filename )
		print("Loading saved metagame:", filename)

		ifs_saveop.NoPromptSave = 1
		ifs_saveop.doOp = "LoadMetagame"
		ifs_saveop.OnSuccess = function()
			ScriptCB_PopScreen()
			util_loadDataFromDisk( name, callback, 3, list)
		end
		ifs_saveop.OnCancel = function()
			ScriptCB_PopScreen()
			util_loadDataFromDisk( name, callback, 4, list)
		end
		ifs_saveop.filename1 = list.filename
		ScriptCB_PushScreen("ifs_saveop")
		return
	end

	--send off the loaded data to whoever wanted it
	if state == 3 then
		--grab the loaded metagame state
		local data = ScriptCB_LoadMetagameState()
	
		--clear the metagame state so we don't have problems when returning to the shell
		ScriptCB_ClearMetagameState()

		--enform whoever that the load completed
		callback( nil, data )
		return
	end
	
	--enform whoever that the load failed
	if state == 4 then
		--clear the metagame state so we don't have problems when returning to the shell
		ScriptCB_ClearMetagameState()

		--enform whoever that the load failed
		callback("Warning: Failed to load the data from the related file name: "..name or "<no name>")
		return
	end

	-- State Info:
	--   nil - Function called by the modder
	--   1   - Have gotten the saved metagame file list
	--   2   - Ready to load the data.  Note: the list var turns into the entry for the metagame to load
	--   3   - Loaded the data from the disk
	--   4   - Failed to load the data from the disk
	
	--we should never get here
	callback("Error: Invalid state: "..state)
	return
end

--
-- Saves data to the disk
--
-- Note: The metagame state will be cleared.
-- Note: Do not call this method twice in a row.  Make sure it has completed
--		through errorCall or savedCall before calling it another time
--
-- Parameters:
--   data     - The data to save to the disk.  This parameter is required.
--   name     - The start of the .gc file name were the data will be saved.  This parameter is required
--   callback - A function which takes a single string.  This function will be called when the save finishes.  If the string parameters is not nil, then the save failed.  The string will contain an error message.  If the string parameter is nil, then the save worked.
--
function util_saveDataToDisk( data, name, callback, state, list, maxSaves )
	--crash prevention hack
	--	I don't know why util_saveDataToDisk() gets called multiple times when the
	--	user is at the team or unit selection screen, but ifs_saveop gets messed
	--	up and the game crashes when it does.  This little hack prevents the
	--	multiple calls.  TODO: double check the pop/push screen calls
	if util_LastSaveStateVar == state then
		print("util_saveDataToDisk(): Double call detected! Aborting crashing call with state: ", state)
		return
	else
		util_LastSaveStateVar = state
	end

	--check input
	if callback == nil then
		callback = function( msg, data )
			--check if the save failed
			if msg ~= nil then
				print("util_saveDataToDisk(): callback(): Failed: ", msg)
				return
			end
			
			--the save didn't fail
			print("util_saveDataToDisk(): callback(): Loaded: ", data)
		end
	end
	if data == nil then
		callback("Error: The given data cannot be nil")
		return
	elseif (name == nil) or (name == "") then
		callback("The given name cannot be nil or empty")
		return
	end
	--print("util_saveDataToDisk(): Entered: State: ", state)
	
	--grab the file list if haven't already
	if state == nil then
		local errorMsg = util_sendSavedMetagameFileList(function(list,maxSaves) util_saveDataToDisk(data,name,callback,1,list, maxSaves) end, false)
		if errorMsg ~= nil then
			callback( errorMsg )
		end
		return
	end
	
	--remove existing metagames with similar names
	if state == 1 then
		--if there are too many saved metagames, bail out
		local amtSaved = table.getn(list)
		if amtSaved >= maxSaves then
			callback("Too many saved metagames: "..amtSaved)
			return
		end
		
		--delete any saved metagame with a similar name
		local errorMsg = util_deleteRelatedMetagames( name, list )
		if errorMsg ~= nil then
			callback( errorMsg )
			return
		end
			
		--ready to save the data to the hard drive
		--Note: saving won't work unless waits a few seconds.  What sure what changes in ifs_saveops that requires this...
		util_delayFunCall( function()
			util_saveDataToDisk( data, name, callback, 2, list, maxSaves )
		end, 6, "savingState2DelayTimer")
		return
	end

	--save the data to the disk
	if state == 2 then
		--can only save stored metagame states, so store the data
		ScriptCB_SaveMetagameState(data)

		--saves the metagame state to a .gc file
		ifs_saveop.doOp = "SaveMetagame"
		ifs_saveop.NoPromptSave = 1
		ifs_saveop.OnSuccess = function()
			ScriptCB_PopScreen()
			util_saveDataToDisk( data, name, callback, 3, list, maxSaves )
		end
		ifs_saveop.OnCancel = function()
			ScriptCB_PopScreen()
			util_saveDataToDisk( data, name, callback, 4, list, maxSaves )
		end
		ifs_saveop.filename1 = nil
		ifs_saveop.filename2 = ScriptCB_tounicode(name)
		ScriptCB_PushScreen("ifs_saveop")
		return
	end
	
	--finished saving the data
	if state == 3 then
		--clear the metagame state so we don't have problems when returning to the shell
		ScriptCB_ClearMetagameState()
		
		--enform whoever that the save completed
		callback(nil)
		return
	end

	--failed to save data
	if state == 4 then
		--clear the metagame state so we don't have problems when returning to the shell
		ScriptCB_ClearMetagameState()

		--enform whoever that the save failed
		callback("Warning: Failed to save the data to the related file name: "..name or "<no name>")
		return
	end
	
	-- State Info:
	--   nil - Function called by the modder
	--   1   - Have gotten the saved metagame file list
	--   2   - Ready to save data to disk
	--   3   - Saved the data to the disk
	--   4   - Failed to save the data to the disk
	
	--Note: should never get here
	callback("Error: Invalid state: "..state)
	return
end


---------------------------------------
--------- 'Private' Functions ---------
---------------------------------------


--used to prevent random, double function calls from messing up ifs_saveop
util_LastSaveStateVar = 0
util_LastLoadStateVar = 0

--
-- Deletes any saved metagames which start with the given name.  The given list is the metagame file list.
--
function util_deleteRelatedMetagames( name, list )
	--check input
	if (name == nil) or (name == "") then
		return "Error: No name given for related metagames"
	elseif list == nil then
		return "Error: No file list given for related metagames"
	end

	--for each saved metagame, 
	local i
	local filename
	local spot
	for i=1,table.getn(list) do
		
		--get this file's file name
		filename = ScriptCB_ununicode(list[i].filename)
		print("Checking filename aganist file with index: ", filename, name, i)
		
		--see if the file starts with the given name
		spot = string.find(filename, name)
		if spot == 1 then
			print("Deleting saved metagame:", filename)
			ScriptCB_StartDeleteMetagame(list[i].filename)
		else
		end
	end
	
	--no errors
	return nil
end

--
-- Sends the saved metagame file list and the max amount of saves to the given function
--
-- Parameters:
-- funCall - The function which will be called with the file list and max save amount.  This parameter is required
-- direct - Use 'true' to directly call the file list getters.  Use 'false' (preferred) to follow the game's ifs_saveop sequence.  This parameter is optional.
--
function util_sendSavedMetagameFileList( funCall, direct )
	--check input
	if funCall == nil then
		return "Error: the given function (parameter 1) cannot be null"
	end
	
	--msg for debugging
	if( direct == true ) then
		print("util_sendSavedMetagameFileList: Going direct route")
	end

	--fowards the SavedMetagameList and the max saves amount to the given function
	local fowardFileList = function( funCall )
		--print("util_sendSavedMetagameFileList(): fowardFileList(): Entered")
		contents, maxSaves = ScriptCB_GetSavedMetagameList(false)
		funCall( contents, maxSaves )
	end

	--directly grab the filelist.  This way bypasses much of ifs_saveop, but
	--	if the ScriptCB_StartPreOp's call back is slow, it will fail.  Also,
	--	the failed assertion triggered in ifs_saveop_DoOps can be ignored.
	if direct == true then
		ScriptCB_StartPreOp( true, "L", true, false, false, false, true)
		fowardFileList(funCall)
		return
	end

	--this is the indirect way.  It emulates how the game normally goes through ifs_saveop
	
	--called then the load metagame prompt is accepted
	local loadPromptAccept = function( value )
		--print("util_sendSavedMetagameFileList(): loadPromptAccept(): Entered")
		
		--deactivate the popup
		--Popup_LoadSave2.fnAccept = nil
		--Popup_LoadSave2:fnActivate(nil)
		
		--foward the file list
		fowardFileList( funCall )
	end
	
	--called to display the load metagame popup
	local startLoadPrompt = function()
		--print("util_sendSavedMetagameFileList(): startLoadPrompt(): Entered")

		-- set the button text
		--IFText_fnSetString(Popup_LoadSave2.buttons.A.label,ifs_saveop.PlatformBaseStr .. ".continue")
		--IFText_fnSetString(Popup_LoadSave2.buttons.B.label,ifs_saveop.PlatformBaseStr .. ".cancel")
		--IFText_fnSetString(Popup_LoadSave2.buttons.C.label," ")
		--Popup_LoadSave2:fnActivate(1)
		
		-- set the button visiblity
		--IFObj_fnSetVis(Popup_LoadSave2.buttons.A.label,1)	
		--IFObj_fnSetVis(Popup_LoadSave2.buttons.B.label,1)	
		--IFObj_fnSetVis(Popup_LoadSave2.buttons.C.label,nil)	
		
		-- set the load/save title text
		--gPopup_fnSetTitleStr(Popup_LoadSave2, "ifs.meta.load.confirm_load")	
		--Popup_LoadSave2_SelectButton(2)
		--IFObj_fnSetVis(Popup_LoadSave2, not ScriptCB_IsErrorBoxOpen())
		--Popup_LoadSave2_ResizeButtons()

		--Popup_LoadSave2.fnAccept = loadPromptAccept
		
		--we are skipping showing the popup
		--	the code is left in as it shows how the game normally does things
		ScriptCB_PopScreen()
		loadPromptAccept()
	end
	
	--called if the saveop fails
	local failed = function()
		--print("util_sendSavedMetagameFileList(): failed(): Entered")
		print("Warning: Failed to load the saved metagame list")
		fowardFileList( {}, 0 )
	end
	
	--do the ifs_saveop operation
	ifs_saveop.doOp = "LoadFileList"
	ifs_saveop.OnSuccess = startLoadPrompt
	ifs_saveop.OnCancel = failed
	ifs_saveop.ForceSaveFailedMessage = ("false"=="save")
	ScriptCB_PushScreen("ifs_saveop");
	
	return nil --no error msg
end

--
--Runs a given function after the given amount of seconds
--
function util_delayFunCall( fun, seconds, name )
	--check input
	if fun == nil then
		print("util_delayFunCall(): The given function cannot be nil")
		return
	elseif seconds <= 0 then
		print("util_delayFunCall(): The given delay time cannot be less than zero seconds")
		return
	elseif name == nil then
		print("util_delayFunCall(): The given name cannot be nil")
		return
	end
	
	--setup the timer
	CreateTimer( name )
	SetTimerValue( name, seconds )
	OnTimerElapse( function(timer)
		--ShowMessageText("")
		DestroyTimer( name )
		fun()
	end, name)
	
	--start the timer
	print("util_delayFunCall(): Starting delayed timer, delay time:", name, seconds)
	StartTimer( name )
end

-- Research Notes:
-- ifs_freeform_menu.lua
-- ifs_freeform_main.lua
-- ifs_freeform_load.lua
-- ifs_saveop.lua
-- ifs_meta_main_input.lua
-- popup_loadsave2.lua
