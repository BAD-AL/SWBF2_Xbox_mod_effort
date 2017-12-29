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
            mScriptTextBox.StatusControl = mStatusControl;
        }

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
            mData  = File.ReadAllBytes(fileName);
            List<long> locations = null;
            switch (mSearchTypeComboBox.SelectedIndex)
            {
                case 0: // scripts
                    locations = BinSearch.GetLocationsOfGivenBytes(0L, ASCIIEncoding.ASCII.GetBytes("LuaP"), mData);
                    break;
                case 1: // images
                    break;
                case 2: // all assets
                    locations = BinSearch.GetLocationsOfGivenBytes(0L, NameBytes, mData);
                    break;
            }
            if (locations.Count > 0)
            {
                AssetListItem item = null;
                AssetListItem prev = null;
                mAssetListBox.Items.Clear();
                foreach (long loc in locations)
                {
                    item = new AssetListItem(loc, mData);
                    if (BinSearch.GetLocationOfGivenBytes(loc, BodyBytes, mData, 80L) > 0)
                    {
                        mAssetListBox.Items.Add(item);
                        prev = item;
                    }
                    else
                    {
                        // NEED TO FIND OUT WHAT SOME OF THESE ARE!!!
                        System.Diagnostics.Debugger.Log(1, "INFO", "Not adding item:" + item.ToString());
                        Console.Error.WriteLine("I don't know how to classify this item: "+ item.ToString());
                        mAssetListBox.Items.Add(item);
                    }
                }
                mStatusControl.Text = "Items Found: "+ mAssetListBox.Items.Count;
            }
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
            AssetListItem item = mAssetListBox.Items[mAssetListBox.SelectedIndex] as AssetListItem;
            mScriptTextBox.Text = item.GetDisplayData();
            if (item.IsLuaCode)
                ShowCodeSize();
            else
                mLuacCodeSizeTextBox.Text = "";
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
            string result = ScriptSearchForm.RunCommand(@"C:\BF2_ModTools\ToolsFL\bin\luac.exe", " -s -o tmp.luac " + luaSourceFile, true);
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
            AssetListItem item = mAssetListBox.SelectedItem as AssetListItem;
            if (item != null)
            {
                item.SpliceInNewCode(mLVLFileTextBox.Text, mScriptTextBox.Text);
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
    }

    public class AssetListItem
    {
        //private string mType = "";
        long mLocation = -1L;
        private byte[] mData = null;

        public AssetListItem(long location, byte[] data)
        {
            mData = data;
            if (data[location] == ScriptSearchForm.NameBytes[0] &&
                data[location + 1] == ScriptSearchForm.NameBytes[1] &&
                data[location + 2] == ScriptSearchForm.NameBytes[2] &&
                data[location + 3] == ScriptSearchForm.NameBytes[3] &&
                data[location + 4] == ScriptSearchForm.NameBytes[4] &&
                data[location + 5] == ScriptSearchForm.NameBytes[5])
            {
                mLocation = location;
            }
            else
                mLocation = BinSearch.GetLocationOfGivenBytesBackup(location, ScriptSearchForm.NameBytes, mData, 70);
            mToString = GetName();
        }

        private string mToString = "";
        public override string ToString()
        {
            return mToString;
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


        internal bool IsValidEntry( AssetListItem previous)
        {
            bool ret = true;
            string name = AssetListItem.GetName(mLocation, mData);

            long previousEnd = previous != null ? (previous.BodyStart + previous.BodyLength) : 0;
            if (this.mLocation < previousEnd)
                ret = false;
            else if ((this.BodyStart + this.BodyLength) > mData.Length)
                ret = false;
            else if (!sValidNamePattern.IsMatch(name))
                ret = false;

            return ret;
        }

        public byte[] GetAssetData()
        {
            long loc = BinSearch.GetLocationOfGivenBytes(mLocation, ScriptSearchForm.BodyBytes, mData);
            int bodyLen = GetLengthAtLocation(loc + 4);
            long bodyStart = loc + 8;
            long bodyEnd = loc + 8 + bodyLen;

            byte[] assetData = BinSearch.GetArrayChunk(mData, bodyStart, bodyLen);
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

        internal static string GetName(long loc, byte[] data)
        {
            string name = "";
            loc += 2;// for the 2 zero bytes at thr front
            int nameLen = data[(int)loc + 4] - 1; // -1 for null byte
            if (loc > 0)
            {
                // NAME + 4 bytes later = 8
                name = Encoding.ASCII.GetString(data, (int)loc + 8, (int)nameLen);
            }
            return name;
        }

        private string GetName()
        {
            return GetName(mLocation, mData);
        }

        public long BodyStart
        {
            get
            {
                long loc = BinSearch.GetLocationOfGivenBytes(mLocation, ScriptSearchForm.BodyBytes, mData);
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
                string sourceFileName = FindSourceFile(name);
                string code = LookupPCcode(sourceFileName);
                int sz = ScriptSearchForm.LuacCodeSize(sourceFileName);
                if (bodyLen == sz)
                    retVal += "\n-- ********* LUAC Code Size MATCH!!! ***********";
                retVal = retVal + string.Format("\n-- {0}\n-- PC luac code size = {1}; PC code:\n{2}", sourceFileName, sz, code);
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

            int retVal = b0 + (b1 << 8) + (b2 << 16) + (b3 << 24); // kinda sure about b0 & b1; not sure about b2 & b3
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
                    sAllLuaFiles = new List<string>();
                    sAllLuaFiles.AddRange(Directory.GetFiles(@"C:\BF2_ModTools\assets\", "*.lua", SearchOption.AllDirectories));
                    sAllLuaFiles.AddRange(Directory.GetFiles(@"C:\BF2_ModTools\TEMPLATE\Common\scripts\", "*.lua", SearchOption.AllDirectories));
                    sAllLuaFiles.AddRange(Directory.GetFiles(@"C:\BF2_ModTools\space_template\", "*.lua", SearchOption.AllDirectories));
                    sAllLuaFiles.AddRange(Directory.GetFiles(@"C:\BF2_ModTools\data\Common\scripts\", "*.lua", SearchOption.AllDirectories));
                }

                string searchFor = fileName.EndsWith(".lua") ? fileName : fileName + ".lua";
                foreach (string file in sAllLuaFiles)
                {
                    if (file.EndsWith(searchFor))
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
        public void SpliceInNewCode(string fileName, string newCode)
        {
            string tmpLuaFileName = ".\\_spliceTmp.lua";
            byte[] fileData = File.ReadAllBytes(fileName);
            File.WriteAllText(tmpLuaFileName, newCode);
            
            string result = ScriptSearchForm.RunCommand(@"C:\BF2_ModTools\ToolsFL\bin\luac.exe", " -s -o tmp.luac " + tmpLuaFileName, true);
            if (result.Trim() != "")
            {
                MessageBox.Show("Error compiling code", result);
                return;
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
                    }
                }
                catch (Exception e)
                {
                    MessageBox.Show("Error splicing in new code");
                }
            }
        }

        /*
        private static string DecompileLua(byte[] luaCode)
        {
            string fileName = ".\\decompile.luac";
            File.WriteAllBytes(fileName, luaCode);
            ProcessStartInfo processStartInfo = new ProcessStartInfo
            {
                //FileName = @".\luadec.exe",
                FileName = @"java",
                Arguments = "-jar unluac.jar " + fileName,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false
            };
            var process = Process.Start(processStartInfo);
            string output = process.StandardOutput.ReadToEnd();
            string err = process.StandardError.ReadToEnd();
            process.WaitForExit();
            return output + "\r\n" + err;
        }*/
    }
}
