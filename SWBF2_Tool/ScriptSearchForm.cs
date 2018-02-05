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

namespace SWBF2_Tool
{
    public partial class ScriptSearchForm : Form
    {

        public static byte[] NameBytes = { 0x00, 0x00, 0x4e, 0x41, 0x4d, 0x45 }; // 00 00 NAME

        public static byte[] BodyBytes = { 0x42, 0x4f, 0x44, 0x59 }; 

        private byte[] mData = null;

        public ScriptSearchForm()
        {
            InitializeComponent();
            mSearchTypeComboBox.SelectedIndex = 0;
            mExtractTypeComboBox.SelectedIndex = 0;
            mScriptTextBox.StatusControl = mStatusControl;
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
            if (mScriptTextBox.Text.Contains(word))
            {
                int index = -1;
                int selectStart = mScriptTextBox.SelectionStart;

                while ((index = mScriptTextBox.Text.IndexOf(word, (index + 1))) != -1)
                {
                    if (index == 0 || Char.IsWhiteSpace(mScriptTextBox.Text[index - 1]))
                    {
                        mScriptTextBox.Select((index + startIndex), word.Length);
                        mScriptTextBox.SelectionColor = color;
                        mScriptTextBox.Select(selectStart, 0);
                        mScriptTextBox.SelectionColor = Color.Black;
                    }
                }
            }
        }

        public static bool ShowPcLuaCode = true;
        public static bool ShowDecompiledLuaCode = false;

        private void mBrowseLVL_Click(object sender, EventArgs e)
        {
            OpenFileDialog dlg = new OpenFileDialog();
            if (dlg.ShowDialog() == DialogResult.OK)
            {
                mLVLFileTextBox.Text = dlg.FileName;
            }
            dlg.Dispose();
        }

        private void mSearchButton_Click(object sender, EventArgs e)
        {
            string fileName = mLVLFileTextBox.Text;
            PopulateListBox(fileName);
        }

        private void PopulateListBox(string fileName)
        {
            if (!File.Exists(fileName))
            {
                MessageBox.Show(this, "Ensure there is a valid .lvl file in the LVL Text box.", "Error!", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            mData  = File.ReadAllBytes(fileName);
            byte[] searchBytes = NameBytes;
            switch (mSearchTypeComboBox.SelectedIndex)
            {
                case 0: // scripts
                    //searchBytes = ASCIIEncoding.ASCII.GetBytes("LuaP"); 
                    searchBytes = ASCIIEncoding.ASCII.GetBytes("scr_");
                    break;
                case 1: // textures
                    searchBytes = ASCIIEncoding.ASCII.GetBytes("tex_"); 
                    break;
                case 2: // _LVL_
                    searchBytes = ASCIIEncoding.ASCII.GetBytes("lvl_");
                    break;
                case 3: // all assets
                    // Already set to NameBytes
                    // mcfg?,
                    break;
            }
            List<AssetListItem> assetItems = mUseMethod2CheckBox.Checked ? GetItems2(mData, searchBytes) : GetItems(mData, searchBytes);
            mAssetListBox.Items.Clear();
            mAssetListBox.Items.AddRange(assetItems.ToArray());
            mStatusControl.Text = fileName + ": Items Found> " + mAssetListBox.Items.Count;
            mOperationPanel.Enabled = (mAssetListBox.Items.Count > 0);
        }

        /// <summary>
        /// Returns AssetList items matching the search criteria
        /// </summary>
        /// <param name="data">The file bytes; something like 'File.ReadAllBytes(fileName);'</param>
        /// <param name="searchBytes">asset type; should be something like 'src_', 'tex_' or 'fx__'; but "LuaP" also works;
        ///  I use  'ASCIIEncoding.ASCII.GetBytes("LuaP")' often.
        ///  1-line usage:
        ///    'GetItems(File.ReadAllBytes(fileName),ASCIIEncoding.ASCII.GetBytes("LuaP"));'
        /// </param>
        /// <returns></returns>
        public static List<AssetListItem> GetItems(byte[] data, byte[] searchBytes)
        {
            List<long> locations = BinSearch.GetLocationsOfGivenBytes(0L, searchBytes, data);
            List<AssetListItem> retVal = new List<AssetListItem>();
            AssetListItem item = null;
            foreach (long loc in locations)
            {
                item = new AssetListItem(loc, data, searchBytes);
                if (BinSearch.GetLocationOfGivenBytes(loc, BodyBytes, data, 80L) > 0)
                {
                    retVal.Add(item);
                }
                else
                {
                    // NEED TO FIND OUT WHAT SOME OF THESE ARE!!!
                    // System.Diagnostics.Debugger.Log(1, "INFO", "Not adding item:" + item.ToString());
                    Console.Error.WriteLine("I don't know how to classify this item: " + item.ToString());
                    retVal.Add(item);
                }
            }
            return retVal;
        }

        private void textBox_DragOver(object sender, DragEventArgs e)
        {
            if (e.Data.GetDataPresent(DataFormats.FileDrop))
                e.Effect = DragDropEffects.Copy;
            else
                e.Effect = DragDropEffects.None;
        }

        private void textBox_DragDrop(object sender, DragEventArgs e)
        {
            Control tb = sender as Control;
            string[] files = (string[])e.Data.GetData(DataFormats.FileDrop);
            if (files != null && files.Length == 1 && tb != null)
            {
                tb.Text = files[0];
            }
        }

        private void mScriptListBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateLuaDetails();
        }

        private void UpdateLuaDetails()
        {
            if (mAssetListBox.SelectedIndex > -1)
            {
                AssetListItem item = mAssetListBox.Items[mAssetListBox.SelectedIndex] as AssetListItem;
                mScriptTextBox.Text = item.GetDisplayData();
                if (item.IsLuaCode)
                    ShowCodeSize();
                else
                    mLuacCodeSizeTextBox.Text = "";
                mScriptTextBox.SelectionStart = 0;
                mScriptTextBox.ScrollToCaret();
                if (ShowDecompiledLuaCode || ShowPcLuaCode )
                {
                    ColorizeText();
                }
            }
        }

        public static string RunCommand(string programName, string args, bool includeStdErr)
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
            process.WaitForExit();
            if (includeStdErr)
                output = output + "\r\n" + err;
            return output;
        }

        public static int LuacCodeSize(string luaSourceFile)
        {
            int retVal = -1;
            string result = ScriptSearchForm.RunCommand(Program.Luac, " -s -o tmp.luac " + luaSourceFile, true);
            if (result.Length < 10)
            {
                FileInfo info = new FileInfo(".\\tmp.luac");
                retVal = (int)info.Length;
            }
            return retVal;
        }

        private void mLuacCodeSizeButton_Click(object sender, EventArgs e)
        {
            ShowCodeSize();
        }

        private void ShowCodeSize()
        {
            string tmpFileName = ".\\tmp.lua";
            File.WriteAllText(tmpFileName, mScriptTextBox.Text);
            int sz = LuacCodeSize(tmpFileName);
            mLuacCodeSizeTextBox.Text = String.Format("{0} Bytes", sz);
        }

        private void mExtractAssetButton_Click(object sender, EventArgs e)
        {
            string fileName = StringInputDlg.GetString("Extract to File", "File name");
            if (fileName != null)
            {
                try
                {
                    AssetListItem item = mAssetListBox.SelectedItem as AssetListItem;
                    File.WriteAllBytes(fileName, item.GetAssetData());
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error saving file!", ex.Message);
                }
            }
        }

        private void mSaveScriptChangesButton_Click(object sender, EventArgs e)
        {
            string newFileName = null;
            AssetListItem item = mAssetListBox.SelectedItem as AssetListItem;
            if (item != null)
            {
                newFileName = item.SpliceInNewCode(mScriptTextBox.Text);
            }
            if (newFileName != null)
            {
                int index = mAssetListBox.SelectedIndex;
                PopulateListBox(newFileName);
                mAssetListBox.TopIndex = index;
            }
        }

        private void showHelpToolStripMenuItem_Click(object sender, EventArgs e)
        {
            ImageViewer iv = new ImageViewer();
            iv.DisplayImage = MainForm.GetImage("Help.png");
            iv.Icon = SystemIcons.Question;
            iv.Text = "Help";
            iv.Show();
        }

        private string GetListtemsText()
        {
            StringBuilder b = new StringBuilder();
            foreach (AssetListItem item in mAssetListBox.Items)
            {
                b.Append(item.ToString());
                b.Append("\n");
            }
            return b.ToString();
        }

        private void displayListItemTextInTextboxToolStripMenuItem_Click(object sender, EventArgs e)
        {
            mScriptTextBox.Text = GetListtemsText();
        }

        private void mExtractScriptsButton_Click(object sender, EventArgs e)
        {
            int count = 0;
            string dirName = "Extracted";
            if (!Directory.Exists(dirName))
                Directory.CreateDirectory(dirName);
            string fileName = "";
            foreach(AssetListItem item in mAssetListBox.Items)
            {
                if (item.IsLuaCode)
                {
                    count++;
                    if (mExtractTypeComboBox.SelectedIndex == 1) // munged
                    {
                        WriteMungedScript(item.GetName(), dirName + "\\" + item.GetName()+".script", item.GetAssetData());
                    }
                    else
                    {
                        fileName = dirName + "\\" + item.GetName() + ".luac";
                        File.WriteAllBytes(fileName, item.GetAssetData());
                    }
                }
            }
            mStatusControl.Text = "Extracted " + count + " files to:" + Directory.GetCurrentDirectory() + "\\"+ dirName;
        }

        private static byte[] StripDC(byte[] data)
        {
            byte b = 0;
            byte[] stripMe = ASCIIEncoding.ASCII.GetBytes("dc:");
            List<long> locations = BinSearch.GetLocationsOfGivenBytes(0, stripMe, data);
            if (locations.Count == 0)
                return data;

            List<byte> byteList = new List<byte>(data);
            for (int i = locations.Count - 1; i > -1; i--)
            {
                byteList.RemoveRange((int)locations[i], 3);
                // now, fix up the length of the string.
                b = byteList[(int)locations[i]-4];
                b -= 3;
                byteList[(int)locations[i]-4] = b;
            }
            return byteList.ToArray();
        }

        public static void WriteMungedScript(string name, string fileName, byte[] data)
        {
            /* uscb format for luac code seems to be:
             * 'uscb',(12*4+1)+data.Length + name.Length+padding,'src_',(length of rest of chunk), 
             * 'NAME', (length of name +1), name (+null terminator), 'INFO',1 (4 bytes),1 (4 bytes),
             * 'BODY', (body length +padding), data, padding
             * Must have 1-4 bytes of padding.
             */
            int namePadding = 4 - (name.Length % 4);
            int headerSize = name.Length + namePadding + (4 * 9) + data.Length; // 9 fields, each of 4 bytes
            int fileLengthNoPadding = 48 + namePadding + name.Length + data.Length;
            int endPadding = 4 - (fileLengthNoPadding % 4);
            
            headerSize += endPadding;
            int srcSz = headerSize - 8;

            if (File.Exists(fileName))
                File.Delete(fileName);

            using (FileStream fs = new FileStream(fileName, FileMode.OpenOrCreate))
            {
                BinaryWriter writer = new BinaryWriter(fs);
                writer.Write(ASCIIEncoding.ASCII.GetBytes("ucfb"));
                writer.Write(headerSize);
                writer.Write(ASCIIEncoding.ASCII.GetBytes("scr_"));
                writer.Write(srcSz);
                writer.Write(ASCIIEncoding.ASCII.GetBytes("NAME"));
                writer.Write(name.Length + 1);
                writer.Write(ASCIIEncoding.ASCII.GetBytes(name));
                for (int i = 0; i < namePadding; i++)
                    writer.Write((byte)0);
                writer.Write(ASCIIEncoding.ASCII.GetBytes("INFO"));
                writer.Write(1);
                writer.Write(1);
                writer.Write(ASCIIEncoding.ASCII.GetBytes("BODY"));
                writer.Write((data.Length+1));
                writer.Write(data);
                for (int i = 0; i < endPadding; i++)
                    writer.Write((byte)0);
                writer.Close();
                fs.Close();
            }
        }

        private void mPcLuaCodeRadioButton_CheckedChanged(object sender, EventArgs e)
        {
            RadioButton btn = sender as RadioButton;
            ShowPcLuaCode = mPcLuaCodeRadioButton.Checked;
            ShowDecompiledLuaCode = luaRadioButton.Checked;
            mSaveScriptChangesButton.Enabled = mPcLuaCodeRadioButton.Checked || luaRadioButton.Checked;
            if( btn.Checked)
                UpdateLuaDetails();
        }

        private void mLVLFileTextBox_TextChanged(object sender, EventArgs e)
        {
            if (File.Exists(mLVLFileTextBox.Text))
            {
                splitContainer1.Panel1.Enabled = true;
                PopulateListBox(mLVLFileTextBox.Text);
            }
            else
                splitContainer1.Panel1.Enabled = false;
        }

        #region population method #2

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

        private List<AssetListItem> GetItems2(byte[] data, byte[] searchBytes)
        {
            int chunks = 0;
            List<AssetListItem> items = new List<AssetListItem>();
            long current = 0;
            while (current > -1)
            {
                current = NextItem(current, data);
                if (current > 0 && IsCorrectType(current, data, searchBytes))
                {
                    items.Add(new AssetListItem(current, data, searchBytes));
                }
                chunks++;
            }
            return items;
        }

        private bool IsCorrectType(long current, byte[] data, byte[] searchBytes)
        {
            bool retVal = false;
            long loc = BinSearch.GetLocationOfGivenBytes(current, searchBytes, data, 10);

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
        #endregion
    }

    public class AssetListItem
    {
        long mLocation = -1L;
        private byte[] mData = null;
        private string mType;

        public AssetListItem(long location, byte[] data, byte[] type)
        {
            mData = data;
            mType = new String(ASCIIEncoding.ASCII.GetChars(type));
            mLocation = location;
            mToString = GetName();
        }

        public string FileName { get; set; }

        private string mToString = "";
        public override string ToString()
        {
            string retVal = mToString;

            if (!String.IsNullOrEmpty(FileName))
            {
                retVal = string.Concat(FileName, ":", mToString);
            }
            return retVal;
        }

        public string GetDisplayData()
        {
            string retVal = GetBody() + "\n" + GetInfo();
            return retVal;
        }

        public bool IsLuaCode
        {
            get
            {
                bool retVal = (BinSearch.GetLocationOfGivenBytes(mLocation, ASCIIEncoding.ASCII.GetBytes("LuaP"), mData) > -1);
                return retVal;
            }
        }

        private static Regex sValidNamePattern = new Regex("^[ a-zA-Z0-9_@^\\-\\.]+$", RegexOptions.Compiled);

        public byte[] GetAssetData()
        {
            byte[] assetData = null;
            if (BinSearch.GetLocationOfGivenBytes(mLocation, ASCIIEncoding.ASCII.GetBytes("lvl_"), mData) == mLocation)
            {
                int bodyLen = GetLengthAtLocation(mLocation + 4);
                assetData = BinSearch.GetArrayChunk(mData, mLocation, bodyLen + 8);
            }
            else
            {
                long loc = BinSearch.GetLocationOfGivenBytes(mLocation, ScriptSearchForm.BodyBytes, mData);
                int bodyLen = GetLengthAtLocation(loc + 4);
                long bodyStart = loc + 8;
                long bodyEnd = loc + 8 + bodyLen;

                assetData = BinSearch.GetArrayChunk(mData, bodyStart, bodyLen);
            }
            return assetData;
        }

        public string GetBinaryRepresentationString()
        {
            string ret = "";
            try
            {
                ret = BinSearch.GetBinaryRepresentationString(GetAssetData());
            }
            catch (Exception e)
            {
                MessageBox.Show("Error! " + e.Message + "\n" + e.StackTrace);
            }
            return ret;
        }

        /*public string GetName()
        {
            long loc = BinSearch.GetLocationOfGivenBytes(mLocation, ASCIIEncoding.ASCII.GetBytes("NAME"), mData, 80);
            if (loc > -1) return GetName(loc, mData);
            return "";
        }*/
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
                    headChunkLength = ScriptSearchForm.GetLengthAtLocation(loc1 + 4, mData);
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

        public long BodyStart
        {
            get
            {
                long loc = BinSearch.GetLocationOfGivenBytes(mLocation, ScriptSearchForm.BodyBytes, mData, 80);
                return loc + 8;
            }
        }

        public long BodyLength
        {
            get
            {
                long loc = BinSearch.GetLocationOfGivenBytes(mLocation, ScriptSearchForm.BodyBytes, mData);
                int bodyLen = GetLengthAtLocation(loc + 4);
                return bodyLen;
            }
        }

        public long BodyEnd
        {
            get { return BodyStart + BodyLength; }
        }

        private string GetBody()
        {
            long loc = BinSearch.GetLocationOfGivenBytes(mLocation, ScriptSearchForm.BodyBytes, mData); 
            int bodyLen = GetLengthAtLocation(loc + 4);
            string name = GetName();
            
            string retVal = String.Format("-- NAME: {0} mLocation: 0x{1:x}; Body Length: {2}, Body Start: 0x{3:x}, Body End: 0x{4:x}", 
                name, mLocation, bodyLen, loc + 8, loc + 8 + bodyLen);
            if (IsLuaCode)
            {
                if (ScriptSearchForm.ShowPcLuaCode)
                {
                    string sourceFileName = FindSourceFile(name);
                    string code = LookupPCcode(sourceFileName);
                    int sz = ScriptSearchForm.LuacCodeSize(sourceFileName);
                    if (bodyLen == sz)
                    {
                        retVal += "\n-- ********* LUAC Code Size MATCH!!! ***********";
                        byte[] b = File.ReadAllBytes(".\\tmp.luac");
                        byte[] c = this.GetAssetData();
                        int i= 0;
                        for (i = 0; i < c.Length; i++)
                            if (b[i] != c[i])
                                break;
                        if( i == c.Length)
                            retVal += "\n-- ********* Binary Equal !!! ***********";
                    }
                    retVal = retVal + string.Format("\n-- {0}\n-- PC luac code size = {1}; PC code:\n{2}", sourceFileName, sz, code);
                }
                else if (ScriptSearchForm.ShowDecompiledLuaCode)
                {
                    string listing = ShowLuaListing(this.GetAssetData());
                    string luaCode = "";
                    try
                    {
                        luaCode = DecompileLuacListing(listing);
                    }
                    catch (Exception ex)
                    {
                        luaCode = ex.Message + "\n" + ex.StackTrace;
                    }
                    retVal = string.Format("\n-- {0}\n-- luac -l listing \n{1}", GetName(), luaCode);
                }
                else
                {
                    string listing = ShowLuaListing(this.GetAssetData());
                    retVal = string.Format("\n-- {0}\n-- luac -l listing \n{1}", GetName(), listing);
                }
            }
            else
                retVal = retVal + String.Format("\n-- 50 bytes, including the previous 30 bytes {0}", BinSearch.GetByteString(mLocation-30,mData,  50));
            return retVal;
        }

        private string GetInfo()
        {
            string retVal = "";
            long loc = BinSearch.GetLocationOfGivenBytes(mLocation, ScriptSearchForm.BodyBytes, mData);
            long infoLoc = BinSearch.GetLocationOfGivenBytesBackup(loc, ASCIIEncoding.ASCII.GetBytes("INFO"), mData, 20);
            if (infoLoc > -1)
            {
                retVal = String.Format("-- INFO 0x{0:x} 0x{1:x} 0x{2:x} 0x{3:x} 0x{4:x} 0x{5:x} 0x{6:x} 0x{7:x} ",
                    mData[infoLoc+4],mData[infoLoc+5],mData[infoLoc+6],mData[infoLoc+7],mData[infoLoc+8],mData[infoLoc+9],mData[infoLoc+10],mData[infoLoc+11] );
            }
            return retVal;
        }

        // add 4 bytes to get the length
        private int GetLengthAtLocation(long loc)
        {
            byte b0, b1, b2, b3;
            b0 = mData[loc];
            b1 = mData[loc + 1];
            b2 = mData[loc + 2];
            b3 = mData[loc + 3];

            int retVal = b0 + (b1 << 8) + (b2 << 16) + (b3 << 24);
            retVal--; // -1 because it works (for scripts anyway...)
            return retVal;
        }

        public static string LookupPCcode(string fileName)
        {
            string retVal = "";
            string sourceFile = FindSourceFile(fileName);
            if (!String.IsNullOrEmpty(sourceFile))
            {
                retVal = File.ReadAllText(sourceFile);
            }
            return retVal;
        }

        private static List<string> sAllLuaFiles = null;

        private static string FindSourceFile(string fileName)
        {
            string sourceFile = null;
            if (fileName != null)
            {
                if (sAllLuaFiles == null)
                {
                    while (!Directory.Exists(Program.BF2_Tools_BaseDir))
                    {
                        Program.BF2_Tools_BaseDir = StringInputDlg.GetString("Please enter SWBF2 mod tools base directory", "Could not find " + Program.BF2_Tools_BaseDir + ". Please enter base SWBF2 mod tools directory", Program.BF2_Tools_BaseDir);
                        if ( String.IsNullOrEmpty( Program.BF2_Tools_BaseDir ))
                            return null;
                        if (!Program.BF2_Tools_BaseDir.EndsWith("\\")) Program.BF2_Tools_BaseDir += "\\";
                    }
                    sAllLuaFiles = new List<string>();
                    sAllLuaFiles.AddRange(Directory.GetFiles(Program.BF2_Tools_BaseDir + "assets\\", "*.lua", SearchOption.AllDirectories));
                    sAllLuaFiles.AddRange(Directory.GetFiles(Program.BF2_Tools_BaseDir + "TEMPLATE\\Common\\scripts\\", "*.lua", SearchOption.AllDirectories));
                    sAllLuaFiles.AddRange(Directory.GetFiles(Program.BF2_Tools_BaseDir + "space_template\\", "*.lua", SearchOption.AllDirectories));
                    sAllLuaFiles.AddRange(Directory.GetFiles(Program.BF2_Tools_BaseDir + "data\\Common\\scripts\\", "*.lua", SearchOption.AllDirectories));
                }

                string searchFor = fileName.EndsWith(".lua") ? fileName : fileName + ".lua";
                foreach (string file in sAllLuaFiles)
                {
                    if (file.EndsWith(searchFor, StringComparison.InvariantCultureIgnoreCase))
                    {
                        sourceFile = file;
                        break;
                    }
                }
            }
            return sourceFile;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="fileName">the base .lvl file to splice the code into</param>
        /// <param name="newCode"></param>
        /// <returns>The file the data was saved to; null on error</returns>
        public string SpliceInNewCode(string newCode)
        {
            string tmpLuaFileName = ".\\_spliceTmp.lua";
            File.WriteAllText(tmpLuaFileName, newCode);

            string result = ScriptSearchForm.RunCommand(Program.Luac, " -s -o tmp.luac " + tmpLuaFileName, true);
            if (result.Trim() != "")
            {
                MessageBox.Show("Error compiling code", result);
                return null;
            }
            byte[] newLuacCode = File.ReadAllBytes("tmp.luac");

            string newLvlFile = StringInputDlg.GetString("new lvl file name", "Save the file as what?>");
            if (newLvlFile != null)
            {
                try
                {
                    using (FileStream fs = File.OpenWrite(newLvlFile))
                    {
                        BinaryWriter bw = new BinaryWriter(fs);
                        bw.BaseStream.Write(mData, 0, (int)(this.BodyStart - 4));
                        bw.Write(newLuacCode.Length+1);
                        bw.BaseStream.Write(newLuacCode, 0, newLuacCode.Length);
                        bw.BaseStream.Write(mData, (int)this.BodyEnd, (int)(mData.Length - this.BodyEnd));
                        bw.Close();
                        return newLvlFile;
                    }
                }
                catch (Exception )
                {
                    MessageBox.Show("Error splicing in new code");
                }
            }
            return null;
        }

        private static string ShowLuaListing(byte[] luacCode)
        {
            string fileName = ".\\decompile.luac";
            File.WriteAllBytes(fileName, luacCode);
            
            string output = ScriptSearchForm.RunCommand(Program.Luac, " -l " + fileName, true);
            return output;
        }

        private string DecompileLuacListing(string listing)
        {
            string retVal = "";
            SWBF2CodeHelper.LuaCodeHelper3 helper = new SWBF2CodeHelper.LuaCodeHelper3();
            retVal = helper.DecompileLuacListing(listing);
            return retVal;
        }
    }
}
