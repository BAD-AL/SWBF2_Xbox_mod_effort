﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace SWBF2_Tool
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
            mTypeComboBox.SelectedIndex = 0;
        }

        private string mMshPath = "";

        private void mMshFileNameTextBox_DragDrop(object sender, DragEventArgs e)
        {
            string[] files = (string[])e.Data.GetData(DataFormats.FileDrop);
            if (files != null && files.Length == 1)
            {
                mMshFileNameTextBox.Text = files[0];
                if (mMshFileNameTextBox.Text.EndsWith(".msh"))
                    mTgaFileNameTextBox.Text = FindTgaFileNames(mMshFileNameTextBox.Text);
                else
                {
                    this.Text = "Incorrect file Type! not a '.msh' file.";
                    mTgaFileNameTextBox.Text = "";
                }
            }
        }

        private string FindTgaFileNames(string fileName)
        {
            String retVal = "";
            mMshPath = fileName.Substring(0, fileName.LastIndexOf('\\') +1);

            byte[] bytes = File.ReadAllBytes(fileName);
            byte[] search = Encoding.ASCII.GetBytes(".tga");
            List< long> locs = BinSearch.GetLocationsOfGivenBytes(0, search, bytes);
            for(int i=0; i < locs.Count; i++)
            {
                retVal = retVal + GetStringFromData(bytes, locs[i]) + ".tga";
                if( i != locs.Count-1)
                    retVal += "; ";
            }
            return retVal;
        }

        private string GetStringFromData(byte[] data, long loc)
        {
            string retVal = "";
            long start = loc;
            while (loc > 0 && data[start] != 0)
                start--;
            start++;
            retVal = ASCIIEncoding.ASCII.GetString(data, (int)start, (int)(loc - start));
            return retVal;
        }

        private void textBox_DragOver(object sender, DragEventArgs e)
        {
            if (e.Data.GetDataPresent(DataFormats.FileDrop))
                e.Effect = DragDropEffects.Copy;
            else
                e.Effect = DragDropEffects.None;
            mStatusControl.Text = "";
        }

        private void mSearchButton_Click(object sender, EventArgs e)
        {
            if ( File.Exists(mBigFileTextBox.Text))
            {
                byte[] bigFile = File.ReadAllBytes(mBigFileTextBox.Text);

                byte[] givenFileBytes = null;
                switch (mTypeComboBox.SelectedIndex)
                {
                    case 0: // search for a file in a bigger file.
                        if (File.Exists(mGivenFileTextBox.Text))
                            givenFileBytes = File.ReadAllBytes(mGivenFileTextBox.Text);
                        else
                        {
                            MessageBox.Show("File: " + mGivenFileTextBox.Text + " Not Found!");
                            return;
                        }
                        break;
                    case 1:  // ASCII string
                        givenFileBytes = ASCIIEncoding.ASCII.GetBytes(mGivenFileTextBox.Text);
                        break;
                    case 2: // unicode string
                        givenFileBytes = UnicodeEncoding.Unicode.GetBytes(mGivenFileTextBox.Text);
                        break;
                }
                List<long> locations = BinSearch.GetLocationsOfGivenBytes(0L, givenFileBytes, bigFile);

                if (locations.Count > 0)
                {
                    StringBuilder builder = new StringBuilder();
                    foreach (long loc in locations)
                    {
                        builder.Append(String.Format("0x{0:X2}\n", loc));
                    }
                    mFileLocationTextBox.Text = "Locations:\n " + builder.ToString();
                }
                else
                    mFileLocationTextBox.Text = mGivenFileTextBox.Text+ ": Not Found.";
            }
        }

        private void mBrowseGivenButton_Click(object sender, EventArgs e)
        {
            OpenFileDialog dlg = new OpenFileDialog();
            if (dlg.ShowDialog() == DialogResult.OK)
            {
                mGivenFileTextBox.Text = dlg.FileName;
            }
            dlg.Dispose();
        }

        private void mBrowseBig_Click(object sender, EventArgs e)
        {
            OpenFileDialog dlg = new OpenFileDialog();
            if (dlg.ShowDialog() == DialogResult.OK)
            {
                mBigFileTextBox.Text = dlg.FileName;
            }
            dlg.Dispose();
        }

        private void mScriptSearchButton_Click(object sender, EventArgs e)
        {
            ScriptSearchForm f = new ScriptSearchForm();
            f.ShowDialog();
            f.Dispose();
        }

        private void textBox_DragDrop(object sender, DragEventArgs e)
        {
            Control tb = sender as Control;
            string[] files = (string[])e.Data.GetData(DataFormats.FileDrop);

            if (tb == mMshFileNameTextBox)
            {
                if (files != null && files.Length == 1 && tb != null)
                {
                    tb.Text = files[0];
                }
            }
            mStatusControl.Text = "File dropped";
        }

        private void mClearButton_Click(object sender, EventArgs e)
        {
            mFileLocationTextBox.Clear();
        }

        static Form form = null;
        /// <summary>
        /// Get an image.
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        public static Image GetImage(string file)
        {
            Image ret = null;
            try
            {
                if (form == null)
                    form = new ImageViewer();
                if (!file.StartsWith("SWBF2_Tool"))
                    file = "SWBF2_Tool." + file;
                System.IO.Stream s =
                    form.GetType().Assembly.GetManifestResourceStream(file);
                if (s != null)
                    ret = Image.FromStream(s);
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message);
            }
            return ret;
        }

        private string[] GetTgaFileNames()
        {
            string[] files = null;
            if( mMshPath.Length > 5 && mTgaFileNameTextBox.Text.Length > 6)
                files = ((mMshPath + mTgaFileNameTextBox.Text).Replace("; ", ";" + mMshPath)).Split(new char[] { ';' });
            return files;
        }

        private void mCopyFilesButton_Click(object sender, EventArgs e)
        {
            if (Directory.Exists(mCopyToFolderTextBox.Text))
            {
                string[] files = GetTgaFileNames();
                string targetDir = mCopyToFolderTextBox.Text;
                if (!targetDir.EndsWith("\\"))
                    targetDir += '\\';
                if (files != null && files.Length > 0)
                {
                    mFileLocationTextBox.Text = "";
                    // copy over .msh file first
                    string destFile = "";
                    int filesCopied = 0;

                    destFile = targetDir + mMshFileNameTextBox.Text.Substring(mMshFileNameTextBox.Text.LastIndexOf('\\') + 1);
                    if (!File.Exists(destFile))
                    {
                        File.Copy(mMshFileNameTextBox.Text, destFile);
                        mFileLocationTextBox.AppendText("Copied " + destFile + "\n");
                    }

                    for (int i = 0; i < files.Length; i++)
                    {
                        destFile = targetDir + files[i].Substring(files[i].LastIndexOf('\\') + 1);
                        if (!File.Exists(files[i]) && File.Exists(files[i].Replace("PC\\", "")))
                            files[i] = files[i].Replace("PC\\", "");
                        if (!File.Exists(files[i]))
                            mFileLocationTextBox.AppendText("Could not locate file: "+ files[i].Substring(files[i].LastIndexOf('\\')+1) +"\n");
                        else if (!File.Exists(destFile))
                        {
                            File.Copy(files[i], destFile);
                            filesCopied++;
                            mFileLocationTextBox.AppendText("Copied " + destFile + "\n");
                            if (File.Exists(files[i] + ".option"))
                            {
                                File.Copy(files[i] + ".option", destFile + ".option");
                                mFileLocationTextBox.AppendText("Copied "+destFile + ".option\n");
                            }
                        }
                    }
                }
                else
                {
                    MessageBox.Show("No files to copy");
                }
            }
            else
            {
                MessageBox.Show("Folder does not exist!", mCopyToFolderTextBox.Text);
            }
        }

    }
}
