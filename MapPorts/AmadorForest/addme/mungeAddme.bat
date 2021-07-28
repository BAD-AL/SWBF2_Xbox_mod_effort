:: Origionally  Set up in YouTube video chapter:
::   https://youtu.be/LVhKMDW22AY?t=4428
::
:: This file has more edits than originally created in the video.
:: It has changed in order to support an Icon for the 'Flower Power' era.
:: Instead of a 1-file .lvl, it now has a texture and a script (see the .req file).
::
:: If you have no need to add textures to the menus/shell then you can 
:: do the simpler approach of:
:: -------------------------------------
::     md munged
::     del /Y munged\* 
::     copy addme.lua addon013.lua 
::     ..\..\ToolsFL\bin\scriptmunge -sourcedir . -platform xbox -inputfile *.lua -outputdir munged\ -checkdate -continue
::     copy munged\addme.script ..\_LVL_XBOX\
::     copy munged\addon013.script ..\_LVL_XBOX\addon013.lvl 
:: -------------------------------------

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
