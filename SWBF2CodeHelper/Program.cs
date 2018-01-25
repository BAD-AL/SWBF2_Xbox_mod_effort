using System;
using System.Collections.Generic;
using System.IO;
using System.Windows.Forms;

namespace SWBF2CodeHelper
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                Application.EnableVisualStyles();
                Application.SetCompatibleTextRenderingDefault(false);
                Application.Run(new Form1());
            }
            else if (args.Length == 1 && File.Exists(args[0]))
            {
                string contents = File.ReadAllText(args[0]);
                LuaCodeHelper3 h3 = new LuaCodeHelper3();
                Console.WriteLine( h3.DecompileLuacListing(contents) );
            }
        }
    }
}
