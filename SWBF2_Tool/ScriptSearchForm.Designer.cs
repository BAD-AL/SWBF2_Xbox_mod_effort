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
            this.mScriptTextBox = new SWBF2_Tool.SearchTextBox();
            this.mSearchButton = new System.Windows.Forms.Button();
            this.mSearchTypeComboBox = new System.Windows.Forms.ComboBox();
            this.mLuacCodeSizeButton = new System.Windows.Forms.Button();
            this.mLuacCodeSizeTextBox = new System.Windows.Forms.TextBox();
            this.mExtractAssetButton = new System.Windows.Forms.Button();
            this.mStatusControl = new System.Windows.Forms.Label();
            this.mSaveScriptChangesButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // mBrowseLVL
            // 
            this.mBrowseLVL.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.mBrowseLVL.Location = new System.Drawing.Point(632, 25);
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
            this.mLVLFileTextBox.Location = new System.Drawing.Point(12, 28);
            this.mLVLFileTextBox.Name = "mLVLFileTextBox";
            this.mLVLFileTextBox.Size = new System.Drawing.Size(614, 20);
            this.mLVLFileTextBox.TabIndex = 12;
            this.mLVLFileTextBox.DragDrop += new System.Windows.Forms.DragEventHandler(this.textBox_DragDrop);
            this.mLVLFileTextBox.DragOver += new System.Windows.Forms.DragEventHandler(this.textBox_DragOver);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(12, 12);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(35, 13);
            this.label4.TabIndex = 14;
            this.label4.Text = "In file:";
            // 
            // mAssetListBox
            // 
            this.mAssetListBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mAssetListBox.FormattingEnabled = true;
            this.mAssetListBox.ItemHeight = 16;
            this.mAssetListBox.Location = new System.Drawing.Point(15, 84);
            this.mAssetListBox.Name = "mAssetListBox";
            this.mAssetListBox.Size = new System.Drawing.Size(200, 164);
            this.mAssetListBox.TabIndex = 15;
            this.mAssetListBox.SelectedIndexChanged += new System.EventHandler(this.mScriptListBox_SelectedIndexChanged);
            // 
            // mScriptTextBox
            // 
            this.mScriptTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mScriptTextBox.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mScriptTextBox.Location = new System.Drawing.Point(221, 63);
            this.mScriptTextBox.Name = "mScriptTextBox";
            this.mScriptTextBox.ScrollBars = System.Windows.Forms.RichTextBoxScrollBars.Vertical;
            this.mScriptTextBox.SearchString = null;
            this.mScriptTextBox.Size = new System.Drawing.Size(405, 367);
            this.mScriptTextBox.StatusControl = null;
            this.mScriptTextBox.TabIndex = 16;
            this.mScriptTextBox.Text = "";
            // 
            // mSearchButton
            // 
            this.mSearchButton.Location = new System.Drawing.Point(15, 55);
            this.mSearchButton.Name = "mSearchButton";
            this.mSearchButton.Size = new System.Drawing.Size(72, 23);
            this.mSearchButton.TabIndex = 18;
            this.mSearchButton.Text = "Search For:";
            this.mSearchButton.UseVisualStyleBackColor = true;
            this.mSearchButton.Click += new System.EventHandler(this.mSearchButton_Click);
            // 
            // mSearchTypeComboBox
            // 
            this.mSearchTypeComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.mSearchTypeComboBox.FormattingEnabled = true;
            this.mSearchTypeComboBox.Items.AddRange(new object[] {
            "Lua",
            "textures (not impl)",
            "All Assets"});
            this.mSearchTypeComboBox.Location = new System.Drawing.Point(94, 57);
            this.mSearchTypeComboBox.Name = "mSearchTypeComboBox";
            this.mSearchTypeComboBox.Size = new System.Drawing.Size(121, 21);
            this.mSearchTypeComboBox.TabIndex = 19;
            // 
            // mLuacCodeSizeButton
            // 
            this.mLuacCodeSizeButton.Location = new System.Drawing.Point(15, 265);
            this.mLuacCodeSizeButton.Name = "mLuacCodeSizeButton";
            this.mLuacCodeSizeButton.Size = new System.Drawing.Size(200, 23);
            this.mLuacCodeSizeButton.TabIndex = 20;
            this.mLuacCodeSizeButton.Text = "Luac Code Size >";
            this.mLuacCodeSizeButton.UseVisualStyleBackColor = true;
            this.mLuacCodeSizeButton.Click += new System.EventHandler(this.mLuacCodeSizeButton_Click);
            // 
            // mLuacCodeSizeTextBox
            // 
            this.mLuacCodeSizeTextBox.Location = new System.Drawing.Point(15, 294);
            this.mLuacCodeSizeTextBox.Name = "mLuacCodeSizeTextBox";
            this.mLuacCodeSizeTextBox.Size = new System.Drawing.Size(200, 20);
            this.mLuacCodeSizeTextBox.TabIndex = 21;
            // 
            // mExtractAssetButton
            // 
            this.mExtractAssetButton.Location = new System.Drawing.Point(15, 331);
            this.mExtractAssetButton.Name = "mExtractAssetButton";
            this.mExtractAssetButton.Size = new System.Drawing.Size(200, 23);
            this.mExtractAssetButton.TabIndex = 22;
            this.mExtractAssetButton.Text = "Extract Asset To...";
            this.mExtractAssetButton.UseVisualStyleBackColor = true;
            this.mExtractAssetButton.Click += new System.EventHandler(this.mExtractAssetButton_Click);
            // 
            // mStatusControl
            // 
            this.mStatusControl.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.mStatusControl.AutoSize = true;
            this.mStatusControl.Location = new System.Drawing.Point(218, 433);
            this.mStatusControl.Name = "mStatusControl";
            this.mStatusControl.Size = new System.Drawing.Size(0, 13);
            this.mStatusControl.TabIndex = 23;
            // 
            // mSaveScriptChangesButton
            // 
            this.mSaveScriptChangesButton.Location = new System.Drawing.Point(15, 384);
            this.mSaveScriptChangesButton.Name = "mSaveScriptChangesButton";
            this.mSaveScriptChangesButton.Size = new System.Drawing.Size(200, 23);
            this.mSaveScriptChangesButton.TabIndex = 24;
            this.mSaveScriptChangesButton.Text = "Save Script Changes";
            this.mSaveScriptChangesButton.UseVisualStyleBackColor = true;
            this.mSaveScriptChangesButton.Click += new System.EventHandler(this.mSaveScriptChangesButton_Click);
            // 
            // ScriptSearchForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(669, 483);
            this.Controls.Add(this.mSaveScriptChangesButton);
            this.Controls.Add(this.mStatusControl);
            this.Controls.Add(this.mExtractAssetButton);
            this.Controls.Add(this.mLuacCodeSizeTextBox);
            this.Controls.Add(this.mLuacCodeSizeButton);
            this.Controls.Add(this.mSearchTypeComboBox);
            this.Controls.Add(this.mSearchButton);
            this.Controls.Add(this.mScriptTextBox);
            this.Controls.Add(this.mAssetListBox);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.mBrowseLVL);
            this.Controls.Add(this.mLVLFileTextBox);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "ScriptSearchForm";
            this.Text = "ScriptSearchForm";
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
    }
}