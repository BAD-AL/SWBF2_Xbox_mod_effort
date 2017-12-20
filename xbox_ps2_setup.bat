@echo off
REM  Batch file to setup the BF2_ModTools to work for PS2 and Xbox.
REM  Place and run from 'data_<MyWorld>/_BUILD/' directory
REM  Would need to be done for each World you wanted to port to Xbox.
REM  'ModTools VisualMunge.exe' Doesn't seem to support the Xbox & PS2 version, 
REM  so for thiose you'll need to run the batch files from the command 
REM  line (munge_all.bat, ps2_munge.bat or xbox_munge.bat).

REM  
if NOT EXIST xbox_munge.bat (
	echo @call munge.bat /platform xbox %* > xbox_munge.bat
	echo cd ..\addme >> xbox_munge.bat
	echo @call mungeAddme.bat >> xbox_munge.bat
	echo cd ..\_BUILD >> xbox_munge.bat
	REM More effort still needed to get the 'addme' to work for xbox.
) else (
    echo Sweet! 'xbox_munge.bat' already exists.
)

if NOT EXIST ps2_munge.bat (
	echo @call munge.bat /platform ps2 %*  > ps2_munge.bat
) else (
    echo Sweet! 'ps2_munge.bat' already exists.
)

if NOT EXIST xbox_clean.bat (
	echo @call clean.bat /platform xbox %* > xbox_clean.bat
) else (
    echo Sweet! 'xbox_clean.bat' already exists.
)

if NOT EXIST ps2_clean.bat (
	echo @call clean.bat /platform ps2 %*  > ps2_clean.bat
) else (
    echo Sweet! 'ps2_clean.exe' already exists.
)

REM  if 'XBOX_texturemunge.exe' does not exist, copy and rename 'PC_TextureMunge.exe'
if NOT EXIST ..\..\ToolsFL\bin\XBOX_TextureMunge.exe (
    copy ..\..\ToolsFL\bin\PC_TextureMunge.exe ..\..\ToolsFL\bin\XBOX_TextureMunge.exe
) else (
    echo Sweet! 'XBOX_TextureMunge.exe' already exists.
)

REM  if 'XBOX_modelmunge.exe'   does not exist, copy and rename 'PC_ModelMunge.exe'
if NOT EXIST ..\..\ToolsFL\bin\XBOX_modelmunge.exe (
    copy ..\..\ToolsFL\bin\PC_ModelMunge.exe ..\..\ToolsFL\bin\XBOX_ModelMunge.exe
) else (
    echo Sweet! 'XBOX_modelmunge.exe' already exists.
)

REM  if 'XBOX_shadermunge.exe'  does not exist, copy and rename 'PC_ShaderMunge.exe'
if NOT EXIST ..\..\ToolsFL\bin\XBOX_ShaderMunge.exe (
    copy ..\..\ToolsFL\bin\PC_ShaderMunge.exe ..\..\ToolsFL\bin\XBOX_ShaderMunge.exe
) else (
    echo Sweet! 'XBOX_ShaderMunge.exe' already exists.
)
