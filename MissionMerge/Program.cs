using System;
using System.Collections.Generic;
using System.Windows.Forms;
using System.IO;

namespace MissionMerge
{
    static class Program
    {
        private static string sBaseFile = "";
        private static string sAddonFile = "";
        public static string sOutputFile = "merged.mission.lvl";

        /// <summary>
        /// The main entry point for the application.
        /// 
        /// </summary>
        [STAThread]
        static int Main(string[] args)
        {
            if (args.Length == 0)
            {
                Application.EnableVisualStyles();
                Application.SetCompatibleTextRenderingDefault(false);
                Application.Run(new MissionMergeForm());
                return 0;
            }
            #region process args...
            string arg ="";
            for (int i = 0; i < args.Length; i+=2)
            {
                arg = args[i].ToLower();
                if ("-h /h /? --help".IndexOf(arg) > -1)
                {
                    Console.WriteLine(sHelpMsg);
                    return 0;
                }
                else if (arg == "-base_mission" && args.Length > i + 1)
                    sBaseFile = args[i + 1];
                else if (arg == "-addon_missions" && args.Length > i + 1)
                    sAddonFile = args[i + 1];
                else if (arg == "-output" && args.Length > i + 1)
                    sOutputFile = args[i + 1];
            }
            #endregion

            if (!File.Exists(sBaseFile) || !File.Exists(sAddonFile))
            {
                Console.Error.WriteLine("Both 'base_mission' and 'addon_missions' files must be specified!\n");
                Console.Error.WriteLine(sHelpMsg);
                return 1;
            }
            //Use the MissionMergeForm to do our bidding
            MissionMergeForm form = new MissionMergeForm();
            form.ConsoleMode = true;
            Console.WriteLine("Reading files...");
            form.DefaultOutputFileName = sOutputFile;
            form.BaseFileName = sBaseFile;
            form.AddonMissionFileName = sAddonFile;
            Console.WriteLine("Merging...");
            form.MergeLevels();
            Console.WriteLine("Saving...");
            form.SaveMissionFile();
            form.Dispose();
            
            return 0;
        }


        private static string sHelpMsg =
@" MissionMerge.exe
 This program merges SWBF2 missions from 2 files and saves the result for you.
 When merging from command line, '-base_mission' and -addon_missions' are required.
 The default output file is 'merged.mission.lvl' (so you don't accidentally overwrite 
  a 'mission.lvl' that you wanted [NOTE: You would need to rename it to 'mission.lvl'
 for the game to use it ])

 Examples:
  C:\> MissionMerge.exe -base_mission mission.lvl -addon_missions .\my_mission\mission.lvl 

  C:\> MissionMerge.exe -base_mission mission.lvl -addon_missions .\my_mission\mission.lvl -output .\done_mission\mission.lvl

 Usage:
 Double click (no arguments) for GUI mode.
 Options:
   -base_mission   <file>  The mission.lvl file to merge into.
   -addon_missions <file>  The mission.lvl file to take missions from.
   -output         <file>  The name of the output file (default is 'merged.mission.lvl')
   -h, /h, /? & --help     Print help message.";
    }
}
