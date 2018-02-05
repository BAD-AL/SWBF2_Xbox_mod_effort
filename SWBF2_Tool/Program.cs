using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using System.IO;

namespace SWBF2_Tool
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            //Application.Run(new MainForm());
            Application.Run(new ScriptSearchForm());
        }

        internal static string BF2_Tools_BaseDir = @"C:\BF2_ModTools\";

        internal static string Luac
        {
            get
            {
                string luac = BF2_Tools_BaseDir+ "ToolsFL\\bin\\luac.exe";
                if (!File.Exists(luac) && File.Exists("luac.exe"))
                    luac = "luac.exe";
                if (!File.Exists(luac))
                {
                    MessageBox.Show(@"Place luac.exe (version 5.0.2; \BF2_ModTools\ToolsFL\bin\luac.exe) in the current directory (if you want this to work)");
                }
                return luac;
            }
        }

    }
}
