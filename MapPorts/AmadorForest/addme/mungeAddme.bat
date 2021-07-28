md munged
del /Y munged\* 

:: Use the same file for the addon013.lvl file 
copy addme.lua addon013.lua 

..\..\ToolsFL\bin\scriptmunge -sourcedir . -platform xbox -inputfile *.lua -outputdir munged\ -checkdate -continue
..\..\ToolsFL\bin\pc_TextureMunge.exe -inputfile $*.tga  -checkdate -continue -platform XBOX -sourcedir . -outputdir MUNGED 
..\..\ToolsFL\bin\levelpack.exe -inputfile addon013.req -writefiles MUNGED\addon013.files -continue -platform XBOX -sourcedir  . -inputdir MUNGED\ -outputdir . 


copy munged\addme.script ..\_LVL_XBOX\
::copy munged\addon013.script ..\_LVL_XBOX\addon013.lvl 
copy addon013.lvl ..\_LVL_XBOX\addon013.lvl 
