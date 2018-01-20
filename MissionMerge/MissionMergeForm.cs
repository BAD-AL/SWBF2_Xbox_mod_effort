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
using System.Text.RegularExpressions;

namespace MissionMerge
{
    public partial class MissionMergeForm : Form
    {
        public static byte[] BodyBytes = { 0x42, 0x4f, 0x44, 0x59 };

        public string DefaultOutputFileName = "merged.mission.lvl";

        /// <summary>
        /// If being used as a slave from the Main program function, 
        /// set this to true and the form will print errors and messages
        /// instead of showing message boxes.
        /// </summary>
        public bool ConsoleMode = false;

        public MissionMergeForm()
        {
            InitializeComponent();
            mBaseMissionListBox.Text = "Base Mission List";
            mAddonMissionListBox.Text = "Addon Mission List";
        }

        /// <summary>
        /// The File we will merge missions into.
        /// (but will save result as a differnt file)
        /// </summary>
        public string BaseFileName
        {
            get { return mBaseMissionTextBox.Text; }
            set
            {
                mBaseMissionTextBox.Text = value;
                if( File.Exists(mBaseMissionTextBox.Text))
                    PopulateListBox(mBaseMissionListBox, File.ReadAllBytes(mBaseMissionTextBox.Text));
            }
        }

        /// <summary>
        /// The mission file we will be taking missions from.
        /// </summary>
        public string AddonMissionFileName
        {
            get { return mAddonMissionTextBox.Text; }
            set
            {
                mAddonMissionTextBox.Text = value;
                if (File.Exists(mAddonMissionTextBox.Text))
                {
                    PopulateListBox(mAddonMissionListBox, File.ReadAllBytes(mAddonMissionTextBox.Text));
                    SelectAllAddonItems();
                    mMergeButton.Focus();
                }
            }
        }

        #region event handling
        private void showHelpToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string helpTxt =
@"This is a single purpose program. Its one and only purpose is to merge SWBF2 'mission.lvl' files.
(It can also be used from the command line; type 'MissionMerge /?' for usage)

Written because it was a pain to create the (SWBF2) 'mission.lvl' files for the Xbox mods(since the mods cannot be 
placed in the download content area like on the PC). If you find a bug, you can report it in the gametoast Xbox mod forum
Or possibly try fixing it yourself if you don't like waiting (source should be on github; you could also decompile 
it to a project using 'dotPeek').
";
            MessageBox.Show(this, helpTxt, "Help", MessageBoxButtons.OK, MessageBoxIcon.Question);
        }

        private void mSaveButton_Click(object sender, EventArgs e)
        {
            SaveMissionFile();
        }

        private void ctrl_DragOver(object sender, DragEventArgs e)
        {
            if (e.Data.GetDataPresent(DataFormats.FileDrop))
                e.Effect = DragDropEffects.Copy;
            else
                e.Effect = DragDropEffects.None;
        }

        private void ctrl_DragDrop(object sender, DragEventArgs e)
        {
            Control tb = sender as Control;
            string[] files = (string[])e.Data.GetData(DataFormats.FileDrop);

            if ((sender == mBaseMissionTextBox || sender == mBaseMissionListBox) && files != null && files.Length == 1 && tb != null)
                BaseFileName = files[0];
            else if ((sender == mAddonMissionListBox || sender == mAddonMissionTextBox) && files != null && files.Length == 1 && tb != null)
                AddonMissionFileName = files[0];
        }

        private void mAddonMissionListBox_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                DeleteSelectedLevels();
            }
            else if (e.KeyCode == Keys.A && e.Control)
            {
                mAddonMissionListBox.SelectedIndices.Clear();
                SelectAllAddonItems();
            }
        }

        private void SelectAllAddonItems()
        {
            for (int i = 0; i < mAddonMissionListBox.Items.Count; i++)
                mAddonMissionListBox.SelectedIndices.Add(i);
        }

        private void UnSelectAllAddonItems()
        {
            mAddonMissionListBox.SelectedIndices.Clear();
        }

        private void mCloseButton_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void mRemoveAddonLevelButton_Click(object sender, EventArgs e)
        {
            DeleteSelectedLevels();
        }

        private void mMergeButton_Click(object sender, EventArgs e)
        {
            MergeLevels();
        }


        private void mAddonMissionListBox_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                contextMenuStrip1.Show(Cursor.Position);
                contextMenuStrip1.Visible = true;
            }
        }

        private void selectAllToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SelectAllAddonItems();
        }

        private void unSelectAllToolStripMenuItem_Click(object sender, EventArgs e)
        {
            UnSelectAllAddonItems();
        }

        private void removeSelectedToolStripMenuItem_Click(object sender, EventArgs e)
        {
            DeleteSelectedLevels();
        }

        private void mergeOverToolStripMenuItem_Click(object sender, EventArgs e)
        {
            MergeLevels();
        }

        #endregion

        private void DeleteSelectedLevels()
        {
            if (mAddonMissionListBox.SelectedIndex > -1)
            {
                ListBox.SelectedIndexCollection indexes = mAddonMissionListBox.SelectedIndices;
                for (int i = indexes.Count - 1; i > -1; i--)
                    mAddonMissionListBox.Items.RemoveAt(indexes[i]);
            }
        }

        private void PopulateListBox(ListBox listBox, byte[] data)
        {
            //byte[] data  = File.ReadAllBytes(fileName);
            byte[] searchBytes = ASCIIEncoding.ASCII.GetBytes("lvl_");
            List<AssetListItem> assetItems = GetItems(data);
            listBox.Items.Clear();
            listBox.Items.AddRange(assetItems.ToArray());
            mStatusControl.Text = listBox.Text + " item count: " + listBox.Items.Count;
            listBox.Tag = data;// keep for later (Just in case)
        }

        private long NextItem(long location, byte[] data)
        {
            long retVal = -1;

            if (location < 8) return 8;

            if (location + (8 + 4) < data.Length)
                retVal = location + 8 + GetLengthAtLocation(location + 4, data);

            return retVal;
        }

        private long GetLastItemLoc(byte[] data)
        {
            long current = 0;
            long last = 0;
            while ((current = NextItem(current, data)) > -1L)
                last = current;
            return last;
        }

        private List<AssetListItem> GetItems(byte[] data)
        {
            int chunks = 0;
            List<AssetListItem> items = new List<AssetListItem>();
            long current = 0;
            while (current > -1)
            {
                current = NextItem(current, data);
                if (current > 0 && IsLVLScriptChunk(current, data))
                {
                    items.Add(new AssetListItem(current, data));
                }
                chunks++;
            }
            return items;
        }

        private bool IsLVLScriptChunk(long current, byte[] data)
        {
            bool retVal = false;
            long loc = BinSearch.GetLocationOfGivenBytes(current, ASCIIEncoding.ASCII.GetBytes("lvl_"), data, 10);

            if (loc == current)
                retVal = true;

            return retVal;
        }

        internal static int GetLengthAtLocation(long loc, byte[] data)
        {
            byte b0, b1, b2, b3;
            b0 = data[loc];
            b1 = data[loc + 1];
            b2 = data[loc + 2];
            b3 = data[loc + 3];

            int retVal = b0 + (b1 << 8) + (b2 << 16) + (b3 << 24);
            return retVal;
        }

        /// <summary>
        /// adds the addon levels into the 'main' list box
        /// </summary>
        public void MergeLevels()
        {
            byte[] data = mBaseMissionListBox.Tag as byte[];
            if (data == null)
            {
                ShowError("No base mission file specified.");
                return;
            }
            if (mAddonMissionListBox.SelectedItems.Count == 0)
            {
                ShowError("No addon mission files specified");
                return;
            }
            for (int i = 0; i < mAddonMissionListBox.SelectedItems.Count; i++)
            {
                data = AddMission(data, mAddonMissionListBox.SelectedItems[i] as AssetListItem);
            }
            int headerLength = data.Length - 8; // gotta put this at locs 4-7
            data[4] = (byte) (headerLength & 0x000000FF);
            data[5] = (byte) ((headerLength & 0x0000FF00) >> 8);
            data[6] = (byte) ((headerLength & 0x00FF0000) >> 16);
            data[7] = (byte) ((headerLength & 0xFF000000) >> 24);

            mBaseMissionListBox.Tag = data;
            mStatusControl.Text =  mAddonMissionListBox.Items.Count + " missions merged over";
            PopulateListBox(mBaseMissionListBox, data);
            mBaseMissionListBox.SelectedIndex = mBaseMissionListBox.Items.Count - 1;
        }

        private byte[] AddMission(byte[] data, AssetListItem assetListItem)
        {
            byte[] newData = assetListItem.GetAssetData();
            List<byte> bigMissionBytes = new List<byte>(data);
            

            long loc = GetLastItemLoc(data); // I'm thinking these (2) statements aren't necessary
            while (bigMissionBytes.Count < loc ) bigMissionBytes.Add((byte)0);    
            

            bigMissionBytes.AddRange(newData);
            return bigMissionBytes.ToArray();
        }

        /// <summary>
        /// Saves the merged data to a file.
        /// </summary>
        public void SaveMissionFile()
        {
            byte[] data = mBaseMissionListBox.Tag as byte[];
            if (data != null)
            {
                string fileName = GetOutputFileName();
                if (!String.IsNullOrEmpty(fileName))
                {
                    if (File.Exists(fileName))
                        File.Delete(fileName);
                    File.WriteAllBytes(fileName, data);
                    ShowMessage("Merged to " + Path.GetFullPath( fileName), "File Saved", MessageBoxIcon.Information);
                }
            }
            else
                ShowError("Main mission file not specified.");
        }

        private string GetOutputFileName()
        {
            if (ConsoleMode) return DefaultOutputFileName;

            string txt = mBaseMissionTextBox.Text;
            String retVal = txt.Substring(0, txt.LastIndexOf('\\') + 1) + DefaultOutputFileName;

            retVal = StringInputDlg.GetString("Enter file name","", retVal);
            return retVal;
        }

        private void ShowError( string err)
        {
            if (!ConsoleMode)
                MessageBox.Show(this, err, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            else
                Console.Error.WriteLine(err);
        }

        private void ShowMessage(string msg, string title,  MessageBoxIcon icon)
        {
            if (!ConsoleMode)
                MessageBox.Show(this, msg, title, MessageBoxButtons.OK, icon);
            else
                Console.WriteLine("{0}: {1}", title, msg);
        }


    }

    public class AssetListItem
    {
        long mLocation = -1L;
        private byte[] mData = null;

        public AssetListItem(long location, byte[] data)
        {
            mData = data;
            mLocation = location;
            mToString = GetName();
        }

        private string mToString = "";

        /// <summary> The text to display for this item </summary>
        public override string ToString()
        {
            string retVal = mToString;
            return retVal;
        }

        /// <summary> Returns the File chunk associated with this item </summary>
        public byte[] GetAssetData()
        {
            byte[] assetData = BinSearch.GetArrayChunk(mData, mLocation, BodyLength + 8);
            return assetData;
        }

        /// <summary> Gets the name of the source file that was munged into this data. </summary>
        public string GetName()
        {
            int headChunkLength = -1;
            string name = "";
            long loc1 = -1;
            long loc = BinSearch.GetLocationOfGivenBytes(mLocation, ASCIIEncoding.ASCII.GetBytes("scr_"), mData, 40);
            if (loc < 0)
            {
                loc1 = BinSearch.GetLocationOfGivenBytes(mLocation, ASCIIEncoding.ASCII.GetBytes("mcfg"), mData, 80);
                if (loc1 > 0)
                {
                    headChunkLength = MissionMergeForm.GetLengthAtLocation(loc1 + 4, mData);
                    loc1 = BinSearch.GetLocationOfGivenBytes(loc1 + headChunkLength - 8, ASCIIEncoding.ASCII.GetBytes("scr_"), mData, 80);
                }
            }
            else
                loc1 = loc;

            if (loc1 > 0)
                loc = BinSearch.GetLocationOfGivenBytes(loc1, ASCIIEncoding.ASCII.GetBytes("NAME"), mData, 80);
            if (loc > -1)
            {
                int nameLen = mData[(int)loc + 4] - 1; // -1 for null byte
                if (loc > 0)
                {
                    // NAME + 4 bytes later = 8
                    name = Encoding.ASCII.GetString(mData, (int)loc + 8, (int)nameLen);
                }
            }
            return name;
        }

        public long BodyLength
        {
            get
            {
                int bodyLen = MissionMergeForm.GetLengthAtLocation(mLocation + 4, mData);
                return bodyLen;
            }
        }
    }
}
