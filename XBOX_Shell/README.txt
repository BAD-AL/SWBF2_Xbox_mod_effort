The BF2 mod tools do not come configured to properly munge the shell.
To properly Munge the XBOX Shell we need to do the following (after you create your mod folder with VisualMunge.exe):

	(Console munge setup)
0. [if needed] Run the 'https://github.com/BAD-AL/SWBF2_Xbox_mod_effort/blob/master/xbox_ps2_setup.bat' batch file in your 'data_<MOD>\_BUILD' folder 


	(Get source files in place)
1. Copy the 'BF2_ModTools\assets\Shell' folder to your mod folder (by default this folder is quite spase having only a shell.req and textures folder)


	(Gather Textures)
2. Use Sleepkiller's unmunge tool to extract the textures from the Xbox's shell.lvl file, place the textures in 'data_<MOD>\Shell\textures'
	https://github.com/SleepKiller/swbf-unmunge


	(setup movies file)
3. Copy the 'shell_movies.config' (in the same directory as this README file) to the following location in your mod folder:
     data_<MOD>\_BUILD\Shell\MUNGED\XBOX\


Now you are setup to build the Xbox shell!

To build the xbox shell.lvl file open a terminal inside your '_BUILD' folder and type:
 > munge.bat /PLATFORM XBOX /SHELL 


Remember....
If you 'clean' out your Build, you'll need to copy the shell_movies.config file again
