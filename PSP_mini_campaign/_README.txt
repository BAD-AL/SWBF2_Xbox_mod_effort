Thesea are the Single player mission scripts for the PSP.
They are referred to as 'mini campaign' missions and are in the file 'ifs_minicamp_campselect' in shell.lvl.

Basic rundown:
--------------------------------------
 Rebel Raider
gMCMode =  "smug"
{ {Map="Myg1c_scm", Side= 1},
  {Map="Nab2c_scm", Side= 1},
  {Map="Hot1g_scm", Side= 1},
  {Map="Spa1g_scm", Side= 1}
}
--------------------------------------
 Imperial Enforcer
gMCMode =  "dipl"
{ {Map= "Nab2g_dcm", Side= 1},
  {Map= "Tat2g_dcm", Side= 1},
  {Map= "End1g_dcm", Side= 1},
  {Map= "Kas2g_dcm", Side= 1}
}
--------------------------------------
 Rogue Assassin
gMCMode ="merc"
ScriptCB_GetPSPMCProgress(1)
{ {Map= "dag1g_mcm", Side= 1},
  {Map= "myg1c_mcm", Side= 1},
  {Map= "yav1g_mcm", Side= 1},
  {Map= "Pol1c_mcm", Side= 1}
}
--------------------------------------

Also in the PSP mission.lvl are 'cor1c_mcm' and 'tat3g_mcm'.
I don't believe these were playable in the PSP and I am wondering what they are like.
I'm also not yet sure what the '_mcp', '_dcp', '_mct', '_mcp', '_scp' mission files.
There's also an oddball called just 'gal1', not sure what it is either.