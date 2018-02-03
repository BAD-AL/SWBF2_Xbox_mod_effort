using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Diagnostics;

namespace SWBF2CodeHelper
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();

            mLuacTextBox.Text =
@"-- Paste luac listing in here (luac -l compiledLuaFile )
-- Or load compiled Lua File with the button below.
";
            mLuacTextBox.DragEnter += new DragEventHandler(mLuacTextBox_DragOver);
            mLuacTextBox.DragDrop += new DragEventHandler(mLuacTextBox_DragDrop);
        }

        void mLuacTextBox_DragOver(object sender, DragEventArgs e)
        {
            if (e.Data.GetDataPresent(DataFormats.FileDrop))
                e.Effect = DragDropEffects.All;
            else
                e.Effect = DragDropEffects.None;
        }

        void mLuacTextBox_DragDrop(object sender, DragEventArgs e)
        {
            Control tb = sender as Control;
            string[] files = (string[])e.Data.GetData(DataFormats.FileDrop);
            if (files != null && files.Length == 1 )
            {
                LoadListing( files[0]);
            }
        }

        private void mGoButton_Click(object sender, EventArgs e)
        {
            LuaCodeHelper3 helper = new LuaCodeHelper3();
            mLuaTextBox.Text = helper.DecompileLuacListing(mLuacTextBox.Text);
            ColorizeText();
            CompileResult();
        }

        private void CompileResult()
        {
            File.WriteAllText("tmp.lua", mLuaTextBox.Text);
            string compileOutput = Program.RunCommand(".\\luac.exe", " -s tmp.lua", true, true).Trim();
            if (compileOutput.Length > 10)
                MessageBox.Show("Results did not pass compile check.", compileOutput);
        }

        /// <summary>
        /// Just some simple stuff, don't go crazy
        /// </summary>
        private void ColorizeText()
        {
            //CheckKeyword("-- Decompiled with SWBF2CodeHelper", Color.Green, 0);
            CheckKeyword("function", Color.Blue, 0);
            CheckKeyword("end", Color.Blue, 0);
            CheckKeyword("if", Color.Blue, 0);
            CheckKeyword("then", Color.Blue, 0);
            CheckKeyword("else", Color.Blue, 0);
            CheckKeyword("return", Color.Blue, 0);
        }

        private void CheckKeyword(string word, Color color, int startIndex)
        {
            if (mLuaTextBox.Text.Contains(word))
            {
                int index = -1;
                int selectStart = mLuaTextBox.SelectionStart;

                while ((index = mLuaTextBox.Text.IndexOf(word, (index + 1))) != -1)
                {
                    if (index == 0 || Char.IsWhiteSpace(mLuaTextBox.Text[index - 1]))
                    {
                        mLuaTextBox.Select((index + startIndex), word.Length);
                        mLuaTextBox.SelectionColor = color;
                        mLuaTextBox.Select(selectStart, 0);
                        mLuaTextBox.SelectionColor = Color.Black;
                    }
                }
            }
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel1.LinkVisited = true;

            System.Diagnostics.Process.Start(linkLabel1.Text);  
        }

        private void mCompareButton_Click(object sender, EventArgs e)
        {
            CompareListings();
        }

        private string[] mCompareTools = {
            @"C:\Program Files\Beyond Compare 4\BCompare.exe",
            @"C:\Program Files (x86)\Beyond Compare 4\BCompare.exe",
            "USER_TOOL",
            };

        /// <summary>
        /// returns null with no valid comparetool known on the computer.
        /// </summary>
        /// <returns></returns>
        private string GetCompareTool()
        {
            string retVal = null;
            for (int i = 0; i < mCompareTools.Length; i++)
            {
                if (File.Exists(mCompareTools[i]))
                    return mCompareTools[i];
            }

            DialogResult result = MessageBox.Show(
                    "Could not find an installed text diff tool.\nPlease choose file diff program on your computer.\n" +
                    "If you do not have one installed, you can download \n"+
                    "ExamDiff from: http://www.prestosoft.com/edp_examdiff.asp\n" + 
                    "Navigate to a diff tool on your computer?",
                    "Diff tool not found", MessageBoxButtons.YesNo);
            if (result == DialogResult.Yes)
            {
                OpenFileDialog dlg = new OpenFileDialog();
                dlg.Title = "Navigate to an installed text diff tool";
                dlg.InitialDirectory = "C:\\";
                if (dlg.ShowDialog() == DialogResult.OK)
                {
                    retVal = mCompareTools[2] = dlg.FileName;
                    dlg.Dispose();
                }
                else
                {
                    dlg.Dispose();
                }
            }
            return retVal;
        }

        private void CompareListings()
        {
            string compareTool = GetCompareTool();
            if (compareTool == null)
                return;

            if( File.Exists(".\\luac.exe"))
            {
                File.WriteAllText(".\\listing1.list", mLuacTextBox.Text);
                File.WriteAllText(".\\listing2.lua", mLuaTextBox.Text);
                string result = Program.RunCommand(".\\luac.exe", " -s -o listing2.luac .\\listing2.lua " , true, true).Trim();
                if (result.Length > 10)
                {
                    MessageBox.Show(result, " Error! Code Did not compile.");
                    return;
                }
                string text = Program.RunCommand(".\\luac.exe", " -l listing2.luac ", true, true);
                File.WriteAllText(".\\listing2.list", text);
                Program.RunCommand(compareTool, " .\\listing1.list .\\listing2.list ", false, false);
            }
            else{
                MessageBox.Show("You need to place luac.exe in the same folder.");
            }
        }

        private void loadLuacButton_Click(object sender, EventArgs e)
        {
            string fileName = null;
            OpenFileDialog dlg = new OpenFileDialog();
            if (dlg.ShowDialog(this) == DialogResult.OK)
            {
                fileName = Program.RunCommand(".\\luac.exe", " -l " + dlg.FileName, true, true);
            }
            dlg.Dispose();

            if( fileName != null)
                LoadListing(fileName);
        }

        private void LoadListing(string fileName)
        {
            if (!File.Exists(".\\luac.exe"))
            {
                MessageBox.Show("Error! Luac.exe not found in current directory. Place luac.exe in this directory.");
                return;
            }
            if (fileName.EndsWith(".list"))
            {
                mLuacTextBox.Text = File.ReadAllText(fileName);
            }
            else
            {
                mLuacTextBox.Text = "-- luac -l listing for " + fileName + "\n" +
                    Program.RunCommand(".\\luac.exe", " -l " + fileName, true, true);
            }
        }

    }
}
