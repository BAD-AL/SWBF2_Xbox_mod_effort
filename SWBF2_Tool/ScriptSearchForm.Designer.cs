namespace SWBF2_Tool
{
    partial class ScriptSearchForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(ScriptSearchForm));
            this.mBrowseLVL = new System.Windows.Forms.Button();
            this.mLVLFileTextBox = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.mAssetListBox = new System.Windows.Forms.ListBox();
            this.mSearchButton = new System.Windows.Forms.Button();
            this.mSearchTypeComboBox = new System.Windows.Forms.ComboBox();
            this.mLuacCodeSizeButton = new System.Windows.Forms.Button();
            this.mLuacCodeSizeTextBox = new System.Windows.Forms.TextBox();
            this.mExtractAssetButton = new System.Windows.Forms.Button();
            this.mStatusControl = new System.Windows.Forms.Label();
            this.mSaveScriptChangesButton = new System.Windows.Forms.Button();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.helpToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.showHelpToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.mOperationPanel = new System.Windows.Forms.Panel();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.luaRadioButton = new System.Windows.Forms.RadioButton();
            this.mLuacListingRadioButton = new System.Windows.Forms.RadioButton();
            this.mPcLuaCodeRadioButton = new System.Windows.Forms.RadioButton();
            this.mExtractTypeComboBox = new System.Windows.Forms.ComboBox();
            this.mExtractScriptsButton = new System.Windows.Forms.Button();
            this.mScriptTextBox = new SWBF2_Tool.SearchTextBox();
            this.mUseMethod2CheckBox = new System.Windows.Forms.CheckBox();
            this.menuStrip1.SuspendLayout();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            this.mOperationPanel.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // mBrowseLVL
            // 
            this.mBrowseLVL.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.mBrowseLVL.Location = new System.Drawing.Point(806, 45);
            this.mBrowseLVL.Name = "mBrowseLVL";
            this.mBrowseLVL.Size = new System.Drawing.Size(25, 23);
            this.mBrowseLVL.TabIndex = 13;
            this.mBrowseLVL.Text = "...";
            this.mBrowseLVL.UseVisualStyleBackColor = true;
            this.mBrowseLVL.Click += new System.EventHandler(this.mBrowseLVL_Click);
            // 
            // mLVLFileTextBox
            // 
            this.mLVLFileTextBox.AllowDrop = true;
            this.mLVLFileTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mLVLFileTextBox.Location = new System.Drawing.Point(12, 48);
            this.mLVLFileTextBox.Name = "mLVLFileTextBox";
            this.mLVLFileTextBox.Size = new System.Drawing.Size(788, 20);
            this.mLVLFileTextBox.TabIndex = 12;
            this.mLVLFileTextBox.TextChanged += new System.EventHandler(this.mLVLFileTextBox_TextChanged);
            this.mLVLFileTextBox.DragDrop += new System.Windows.Forms.DragEventHandler(this.textBox_DragDrop);
            this.mLVLFileTextBox.DragOver += new System.Windows.Forms.DragEventHandler(this.textBox_DragOver);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(12, 32);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(48, 13);
            this.label4.TabIndex = 14;
            this.label4.Text = "LVL File:";
            // 
            // mAssetListBox
            // 
            this.mAssetListBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mAssetListBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mAssetListBox.FormattingEnabled = true;
            this.mAssetListBox.ItemHeight = 16;
            this.mAssetListBox.Location = new System.Drawing.Point(3, 34);
            this.mAssetListBox.Name = "mAssetListBox";
            this.mAssetListBox.Size = new System.Drawing.Size(262, 164);
            this.mAssetListBox.TabIndex = 15;
            this.mAssetListBox.SelectedIndexChanged += new System.EventHandler(this.mScriptListBox_SelectedIndexChanged);
            // 
            // mSearchButton
            // 
            this.mSearchButton.Enabled = false;
            this.mSearchButton.Location = new System.Drawing.Point(3, 5);
            this.mSearchButton.Name = "mSearchButton";
            this.mSearchButton.Size = new System.Drawing.Size(72, 23);
            this.mSearchButton.TabIndex = 18;
            this.mSearchButton.Text = "Search For:";
            this.mSearchButton.UseVisualStyleBackColor = true;
            this.mSearchButton.Click += new System.EventHandler(this.mSearchButton_Click);
            // 
            // mSearchTypeComboBox
            // 
            this.mSearchTypeComboBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mSearchTypeComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.mSearchTypeComboBox.Enabled = false;
            this.mSearchTypeComboBox.FormattingEnabled = true;
            this.mSearchTypeComboBox.Items.AddRange(new object[] {
            "Lua",
            "Textures",
            "_LVL_"});
            this.mSearchTypeComboBox.Location = new System.Drawing.Point(82, 7);
            this.mSearchTypeComboBox.Name = "mSearchTypeComboBox";
            this.mSearchTypeComboBox.Size = new System.Drawing.Size(183, 21);
            this.mSearchTypeComboBox.TabIndex = 19;
            // 
            // mLuacCodeSizeButton
            // 
            this.mLuacCodeSizeButton.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mLuacCodeSizeButton.Location = new System.Drawing.Point(0, 90);
            this.mLuacCodeSizeButton.Name = "mLuacCodeSizeButton";
            this.mLuacCodeSizeButton.Size = new System.Drawing.Size(249, 23);
            this.mLuacCodeSizeButton.TabIndex = 20;
            this.mLuacCodeSizeButton.Text = "Luac Code Size >";
            this.mLuacCodeSizeButton.UseVisualStyleBackColor = true;
            this.mLuacCodeSizeButton.Click += new System.EventHandler(this.mLuacCodeSizeButton_Click);
            // 
            // mLuacCodeSizeTextBox
            // 
            this.mLuacCodeSizeTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mLuacCodeSizeTextBox.Location = new System.Drawing.Point(0, 119);
            this.mLuacCodeSizeTextBox.Name = "mLuacCodeSizeTextBox";
            this.mLuacCodeSizeTextBox.Size = new System.Drawing.Size(249, 20);
            this.mLuacCodeSizeTextBox.TabIndex = 21;
            // 
            // mExtractAssetButton
            // 
            this.mExtractAssetButton.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mExtractAssetButton.Location = new System.Drawing.Point(0, 156);
            this.mExtractAssetButton.Name = "mExtractAssetButton";
            this.mExtractAssetButton.Size = new System.Drawing.Size(249, 23);
            this.mExtractAssetButton.TabIndex = 22;
            this.mExtractAssetButton.Text = "Extract Asset To...";
            this.mExtractAssetButton.UseVisualStyleBackColor = true;
            this.mExtractAssetButton.Click += new System.EventHandler(this.mExtractAssetButton_Click);
            // 
            // mStatusControl
            // 
            this.mStatusControl.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.mStatusControl.AutoSize = true;
            this.mStatusControl.Location = new System.Drawing.Point(15, 539);
            this.mStatusControl.Name = "mStatusControl";
            this.mStatusControl.Size = new System.Drawing.Size(0, 13);
            this.mStatusControl.TabIndex = 23;
            // 
            // mSaveScriptChangesButton
            // 
            this.mSaveScriptChangesButton.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mSaveScriptChangesButton.Location = new System.Drawing.Point(0, 209);
            this.mSaveScriptChangesButton.Name = "mSaveScriptChangesButton";
            this.mSaveScriptChangesButton.Size = new System.Drawing.Size(249, 23);
            this.mSaveScriptChangesButton.TabIndex = 24;
            this.mSaveScriptChangesButton.Text = "Save Script Changes";
            this.mSaveScriptChangesButton.UseVisualStyleBackColor = true;
            this.mSaveScriptChangesButton.Click += new System.EventHandler(this.mSaveScriptChangesButton_Click);
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.helpToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(844, 24);
            this.menuStrip1.TabIndex = 25;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // helpToolStripMenuItem
            // 
            this.helpToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.showHelpToolStripMenuItem});
            this.helpToolStripMenuItem.Name = "helpToolStripMenuItem";
            this.helpToolStripMenuItem.Size = new System.Drawing.Size(44, 20);
            this.helpToolStripMenuItem.Text = "Help";
            // 
            // showHelpToolStripMenuItem
            // 
            this.showHelpToolStripMenuItem.Name = "showHelpToolStripMenuItem";
            this.showHelpToolStripMenuItem.Size = new System.Drawing.Size(131, 22);
            this.showHelpToolStripMenuItem.Text = "Show &Help";
            this.showHelpToolStripMenuItem.Click += new System.EventHandler(this.showHelpToolStripMenuItem_Click);
            // 
            // splitContainer1
            // 
            this.splitContainer1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.splitContainer1.Location = new System.Drawing.Point(12, 75);
            this.splitContainer1.Name = "splitContainer1";
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.mOperationPanel);
            this.splitContainer1.Panel1.Controls.Add(this.mSearchButton);
            this.splitContainer1.Panel1.Controls.Add(this.mAssetListBox);
            this.splitContainer1.Panel1.Controls.Add(this.mSearchTypeComboBox);
            this.splitContainer1.Panel1.Enabled = false;
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.mScriptTextBox);
            this.splitContainer1.Size = new System.Drawing.Size(833, 461);
            this.splitContainer1.SplitterDistance = 277;
            this.splitContainer1.TabIndex = 26;
            // 
            // mOperationPanel
            // 
            this.mOperationPanel.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mOperationPanel.Controls.Add(this.groupBox1);
            this.mOperationPanel.Controls.Add(this.mExtractTypeComboBox);
            this.mOperationPanel.Controls.Add(this.mLuacCodeSizeTextBox);
            this.mOperationPanel.Controls.Add(this.mExtractScriptsButton);
            this.mOperationPanel.Controls.Add(this.mLuacCodeSizeButton);
            this.mOperationPanel.Controls.Add(this.mExtractAssetButton);
            this.mOperationPanel.Controls.Add(this.mSaveScriptChangesButton);
            this.mOperationPanel.Enabled = false;
            this.mOperationPanel.Location = new System.Drawing.Point(3, 204);
            this.mOperationPanel.Name = "mOperationPanel";
            this.mOperationPanel.Size = new System.Drawing.Size(262, 254);
            this.mOperationPanel.TabIndex = 17;
            // 
            // groupBox1
            // 
            this.groupBox1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox1.Controls.Add(this.luaRadioButton);
            this.groupBox1.Controls.Add(this.mLuacListingRadioButton);
            this.groupBox1.Controls.Add(this.mPcLuaCodeRadioButton);
            this.groupBox1.Location = new System.Drawing.Point(3, 49);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(246, 35);
            this.groupBox1.TabIndex = 29;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Lua code listing style";
            // 
            // luaRadioButton
            // 
            this.luaRadioButton.AutoSize = true;
            this.luaRadioButton.Location = new System.Drawing.Point(177, 13);
            this.luaRadioButton.Name = "luaRadioButton";
            this.luaRadioButton.Size = new System.Drawing.Size(63, 17);
            this.luaRadioButton.TabIndex = 2;
            this.luaRadioButton.Text = "Lua (try)";
            this.luaRadioButton.UseVisualStyleBackColor = true;
            this.luaRadioButton.CheckedChanged += new System.EventHandler(this.mPcLuaCodeRadioButton_CheckedChanged);
            // 
            // mLuacListingRadioButton
            // 
            this.mLuacListingRadioButton.AutoSize = true;
            this.mLuacListingRadioButton.Location = new System.Drawing.Point(89, 13);
            this.mLuacListingRadioButton.Name = "mLuacListingRadioButton";
            this.mLuacListingRadioButton.Size = new System.Drawing.Size(86, 17);
            this.mLuacListingRadioButton.TabIndex = 1;
            this.mLuacListingRadioButton.Text = "Luac -l listing";
            this.mLuacListingRadioButton.UseVisualStyleBackColor = true;
            this.mLuacListingRadioButton.CheckedChanged += new System.EventHandler(this.mPcLuaCodeRadioButton_CheckedChanged);
            // 
            // mPcLuaCodeRadioButton
            // 
            this.mPcLuaCodeRadioButton.AutoSize = true;
            this.mPcLuaCodeRadioButton.Checked = true;
            this.mPcLuaCodeRadioButton.Location = new System.Drawing.Point(3, 13);
            this.mPcLuaCodeRadioButton.Name = "mPcLuaCodeRadioButton";
            this.mPcLuaCodeRadioButton.Size = new System.Drawing.Size(88, 17);
            this.mPcLuaCodeRadioButton.TabIndex = 0;
            this.mPcLuaCodeRadioButton.TabStop = true;
            this.mPcLuaCodeRadioButton.Text = "PC Lua Code";
            this.mPcLuaCodeRadioButton.UseVisualStyleBackColor = true;
            this.mPcLuaCodeRadioButton.CheckedChanged += new System.EventHandler(this.mPcLuaCodeRadioButton_CheckedChanged);
            // 
            // mExtractTypeComboBox
            // 
            this.mExtractTypeComboBox.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.mExtractTypeComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.mExtractTypeComboBox.FormattingEnabled = true;
            this.mExtractTypeComboBox.Items.AddRange(new object[] {
            "Luac",
            "Munged (.script)"});
            this.mExtractTypeComboBox.Location = new System.Drawing.Point(126, 182);
            this.mExtractTypeComboBox.Name = "mExtractTypeComboBox";
            this.mExtractTypeComboBox.Size = new System.Drawing.Size(121, 21);
            this.mExtractTypeComboBox.TabIndex = 28;
            // 
            // mExtractScriptsButton
            // 
            this.mExtractScriptsButton.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mExtractScriptsButton.Location = new System.Drawing.Point(0, 180);
            this.mExtractScriptsButton.Name = "mExtractScriptsButton";
            this.mExtractScriptsButton.Size = new System.Drawing.Size(120, 23);
            this.mExtractScriptsButton.TabIndex = 27;
            this.mExtractScriptsButton.Text = "Extract scripts";
            this.mExtractScriptsButton.UseVisualStyleBackColor = true;
            this.mExtractScriptsButton.Click += new System.EventHandler(this.mExtractScriptsButton_Click);
            // 
            // mScriptTextBox
            // 
            this.mScriptTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mScriptTextBox.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mScriptTextBox.Location = new System.Drawing.Point(3, 5);
            this.mScriptTextBox.Name = "mScriptTextBox";
            this.mScriptTextBox.ScrollBars = System.Windows.Forms.RichTextBoxScrollBars.Vertical;
            this.mScriptTextBox.SearchString = null;
            this.mScriptTextBox.Size = new System.Drawing.Size(534, 453);
            this.mScriptTextBox.StatusControl = null;
            this.mScriptTextBox.TabIndex = 16;
            this.mScriptTextBox.Text = "";
            // 
            // mUseMethod2CheckBox
            // 
            this.mUseMethod2CheckBox.AutoSize = true;
            this.mUseMethod2CheckBox.Location = new System.Drawing.Point(273, 27);
            this.mUseMethod2CheckBox.Name = "mUseMethod2CheckBox";
            this.mUseMethod2CheckBox.Size = new System.Drawing.Size(93, 17);
            this.mUseMethod2CheckBox.TabIndex = 27;
            this.mUseMethod2CheckBox.Text = "Use Method 2";
            this.mUseMethod2CheckBox.UseVisualStyleBackColor = true;
            this.mUseMethod2CheckBox.Visible = false;
            // 
            // ScriptSearchForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(844, 553);
            this.Controls.Add(this.mUseMethod2CheckBox);
            this.Controls.Add(this.splitContainer1);
            this.Controls.Add(this.mStatusControl);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.mBrowseLVL);
            this.Controls.Add(this.mLVLFileTextBox);
            this.Controls.Add(this.menuStrip1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MainMenuStrip = this.menuStrip1;
            this.MinimumSize = new System.Drawing.Size(685, 480);
            this.Name = "ScriptSearchForm";
            this.Text = "ScriptSearchForm";
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            this.splitContainer1.ResumeLayout(false);
            this.mOperationPanel.ResumeLayout(false);
            this.mOperationPanel.PerformLayout();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button mBrowseLVL;
        private System.Windows.Forms.TextBox mLVLFileTextBox;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.ListBox mAssetListBox;
        private SearchTextBox mScriptTextBox;
        private System.Windows.Forms.Button mSearchButton;
        private System.Windows.Forms.ComboBox mSearchTypeComboBox;
        private System.Windows.Forms.Button mLuacCodeSizeButton;
        private System.Windows.Forms.TextBox mLuacCodeSizeTextBox;
        private System.Windows.Forms.Button mExtractAssetButton;
        private System.Windows.Forms.Label mStatusControl;
        private System.Windows.Forms.Button mSaveScriptChangesButton;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem helpToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem showHelpToolStripMenuItem;
        private System.Windows.Forms.SplitContainer splitContainer1;
        private System.Windows.Forms.Button mExtractScriptsButton;
        private System.Windows.Forms.ComboBox mExtractTypeComboBox;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.RadioButton mLuacListingRadioButton;
        private System.Windows.Forms.RadioButton mPcLuaCodeRadioButton;
        private System.Windows.Forms.Panel mOperationPanel;
        private System.Windows.Forms.CheckBox mUseMethod2CheckBox;
        private System.Windows.Forms.RadioButton luaRadioButton;
    }
}