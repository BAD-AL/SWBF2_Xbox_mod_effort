﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

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
            Application.Run(new MainForm());
            //Application.Run(new ScriptSearchForm());
        }
    }
}
