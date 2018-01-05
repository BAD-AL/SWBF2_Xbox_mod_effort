using System;
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
    public partial class LVLSearchForm : Form
    {
        public LVLSearchForm()
        {
            InitializeComponent();
        }

        private void mBrowseDir_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog dlg = new FolderBrowserDialog();
            dlg.RootFolder = Environment.SpecialFolder.Recent;
            if (dlg.ShowDialog() == DialogResult.OK)
            {
                mDirectoryTextBox.Text = dlg.SelectedPath;
            }
            dlg.Dispose();
        }

        private void mSearchButton_Click(object sender, EventArgs e)
        {
            SearchForGivenText();
        }

        private void SearchForGivenText()
        {
            mListBox.Items.Clear();
            string searchString = mSearchTextBox.Text;
            string[] lvlFiles = Directory.GetFiles(mDirectoryTextBox.Text, "*.lvl", SearchOption.AllDirectories);
            List<AssetListItem> items = null;
            foreach (string file in lvlFiles)
            {
                // find items whose name contains the given text.
                items = ScriptSearchForm.GetItems(File.ReadAllBytes(file), ASCIIEncoding.ASCII.GetBytes("LuaP"));
                foreach (AssetListItem item in items)
                {
                    if (item.GetName().IndexOf(searchString) > -1)
                    {
                        mListBox.Items.Add(item);
                    }
                }
            }
            mStatusLabel.Text = mListBox.Items.Count +" Items found.";
        }

        private void mSearchTextBox_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
                SearchForGivenText();
        }
    }
}
