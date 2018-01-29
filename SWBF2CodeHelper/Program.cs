using System;
using System.Collections.Generic;
using System.IO;
using System.Windows.Forms;
using System.Diagnostics;

namespace SWBF2CodeHelper
{
    static class Program
    {
        private static bool InteractiveMode = false;

        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static int Main(string[] args)
        {
            LuaCodeHelper3 h3 = null;
            string outFileName = "";
            string compileOutput = "";
            string listingText = "";
            string output = "";

            if (args.Length == 0)
            {
                InteractiveMode = true;
                Application.EnableVisualStyles();
                Application.SetCompatibleTextRenderingDefault(false);
                Application.Run(new Form1());
            }
            else if ("/? -h /h --help ".Contains(args[0]))
            {
                Console.WriteLine(
                    "Decompiles Lua 5.0.2 .luac or luac -l listing files into .lua source code files.\n"+
                    "Requires luac 5.0.2 in the same directory.\n"+
                    "Use SWBF2_Tool to extract .luac files from .lvl files."+
                    "Usage: SWBF2CodeHelper.exe <file1> <file2> ...\n" +
                    "       SWBF2CodeHelper.exe *.luac "
                    );
            }
            else //if (args.Length == 1 && File.Exists(args[0]))
            {
                if (args[0] == "*.luac")
                    args = Directory.GetFiles(".", "*.luac");

                Console.WriteLine("Processing {0} Files", args.Length);
                for (int i = 0; i < args.Length; i++)
                {
                    if (args[i].EndsWith(".luac"))
                    {
                        try
                        {
                            if (!File.Exists(".\\luac.exe"))
                            {
                                Console.Error.WriteLine("Error! Luac.exe not found in current directory. Place luac.exe in this directory.");
                                return 1;
                            }
                            outFileName = args[i].Replace(".luac", ".lua");
                            if (outFileName.StartsWith(".\\"))
                                outFileName = outFileName.Substring(2);


                            //string result = Program.RunCommand(".\\luac.exe", " -s -o listing2.luac .\\listing2.lua ", true);
                            Console.WriteLine("Working on {0}...", outFileName);
                            listingText = Program.RunCommand(".\\luac.exe", " -l " + args[i], true, true);
                            h3 = new LuaCodeHelper3();
                            //Console.WriteLine("Luac results for {0}:\r\n{1}", args[i], text);
                            output = String.Format("--{0}\n{1}\n", outFileName, h3.DecompileLuacListing(listingText));
                            File.WriteAllText(outFileName, output);
                            compileOutput = Program.RunCommand(".\\luac.exe", " -s " + outFileName, true, true).Trim();
                            if (compileOutput.Length > 10)
                                Console.Error.WriteLine("Check file {0}. It did not compile correctly.\n{1}\n", outFileName, compileOutput);
                            Console.WriteLine("Done processing {0}.", outFileName);
                        }
                        catch (Exception e)
                        {
                            Console.Error.WriteLine("Error working on file {0}.\n{1}\n continuing...", outFileName, e.Message + e.StackTrace);
                        }
                    }
                    else
                    {
                        string contents = File.ReadAllText(args[i]);
                        h3 = new LuaCodeHelper3();
                        Console.WriteLine("--{0}\r\n", args[i]);
                        Console.WriteLine(h3.DecompileLuacListing(contents));
                    }
                }
            }
            return 0;
        }

        public static string RunCommand(string programName, string args, bool includeStdErr, bool waitForExit)
        {
            ProcessStartInfo processStartInfo = new ProcessStartInfo
            {
                FileName = programName,
                Arguments = args,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false
            };
            var process = Process.Start(processStartInfo);
            string output = process.StandardOutput.ReadToEnd();
            string err = process.StandardError.ReadToEnd();
            if( waitForExit)
                process.WaitForExit();
            if (includeStdErr)
                output = output + "\r\n" + err;
            return output;
        }

        public static void ReportError(string errorMsg, string errorDetails)
        {
            string error = String.Format("ERROR! {0} {1} ", errorMsg, errorDetails);
            Console.Error.WriteLine(error);
            if (InteractiveMode && MessageBox.Show(errorDetails + "\nContinue?", errorMsg, MessageBoxButtons.YesNo) == DialogResult.Yes)
                return;

            throw new Exception(error);
        }
    }
}
