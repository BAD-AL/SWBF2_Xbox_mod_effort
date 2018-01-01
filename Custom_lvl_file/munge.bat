
MKDIR MUNGED

:: scriptmunge the lua code
C:\BF2_ModTools\ToolsFL\bin\scriptmunge -inputfile *.lua -checkdate -continue -platform XBOX -sourcedir  . -outputdir MUNGED  2>>"MungeLog.txt" 

:: levelpack makes the .lvl files
C:\BF2_ModTools\ToolsFL\bin\levelpack -inputfile custom.req -writefiles MUNGED\custom.files -checkdate -continue -platform XBOX -sourcedir  . -inputdir MUNGED -outputdir .  
