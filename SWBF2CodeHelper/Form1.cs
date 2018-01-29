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
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void mGoButton_Click(object sender, EventArgs e)
        {
            LuaCodeHelper3 helper = new LuaCodeHelper3();
            mLuaTextBox.Text = helper.DecompileLuacListing(mLuacTextBox.Text);
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

    }
}
