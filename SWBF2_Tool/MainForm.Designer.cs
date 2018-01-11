namespace SWBF2_Tool
{
    partial class MainForm
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.mCopyFilesButton = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.mCopyToFolderTextBox = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.mTgaFileNameTextBox = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.mMshFileNameTextBox = new System.Windows.Forms.TextBox();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.mClearButton = new System.Windows.Forms.Button();
            this.mTypeComboBox = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            this.mBrowseBig = new System.Windows.Forms.Button();
            this.mBrowseGivenButton = new System.Windows.Forms.Button();
            this.mSearchButton = new System.Windows.Forms.Button();
            this.mBigFileTextBox = new System.Windows.Forms.TextBox();
            this.mGivenFileTextBox = new System.Windows.Forms.TextBox();
            this.mScriptSearchButton = new System.Windows.Forms.Button();
            this.mFileLocationTextBox = new SWBF2_Tool.SearchTextBox();
            this.mStatusControl = new System.Windows.Forms.Label();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox1
            // 
            this.groupBox1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox1.Controls.Add(this.mCopyFilesButton);
            this.groupBox1.Controls.Add(this.label4);
            this.groupBox1.Controls.Add(this.mCopyToFolderTextBox);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.mTgaFileNameTextBox);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Controls.Add(this.mMshFileNameTextBox);
            this.groupBox1.Location = new System.Drawing.Point(1, 246);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(414, 126);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "MSH helper";
            // 
            // mCopyFilesButton
            // 
            this.mCopyFilesButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.mCopyFilesButton.Location = new System.Drawing.Point(364, 98);
            this.mCopyFilesButton.Name = "mCopyFilesButton";
            this.mCopyFilesButton.Size = new System.Drawing.Size(44, 23);
            this.mCopyFilesButton.TabIndex = 10;
            this.mCopyFilesButton.Text = "Copy";
            this.mCopyFilesButton.UseVisualStyleBackColor = true;
            this.mCopyFilesButton.Click += new System.EventHandler(this.mCopyFilesButton_Click);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(80, 82);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(135, 13);
            this.label4.TabIndex = 5;
            this.label4.Text = "Copy to Folder (Paste here)";
            // 
            // mCopyToFolderTextBox
            // 
            this.mCopyToFolderTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mCopyToFolderTextBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mCopyToFolderTextBox.Location = new System.Drawing.Point(0, 98);
            this.mCopyToFolderTextBox.Name = "mCopyToFolderTextBox";
            this.mCopyToFolderTextBox.Size = new System.Drawing.Size(358, 22);
            this.mCopyToFolderTextBox.TabIndex = 4;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(6, 57);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(49, 13);
            this.label2.TabIndex = 3;
            this.label2.Text = "tga file(s)";
            // 
            // mTgaFileNameTextBox
            // 
            this.mTgaFileNameTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mTgaFileNameTextBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mTgaFileNameTextBox.Location = new System.Drawing.Point(83, 54);
            this.mTgaFileNameTextBox.Name = "mTgaFileNameTextBox";
            this.mTgaFileNameTextBox.Size = new System.Drawing.Size(325, 22);
            this.mTgaFileNameTextBox.TabIndex = 2;
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(6, 16);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(71, 30);
            this.label1.TabIndex = 1;
            this.label1.Text = "msh file name (drag here)";
            // 
            // mMshFileNameTextBox
            // 
            this.mMshFileNameTextBox.AllowDrop = true;
            this.mMshFileNameTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mMshFileNameTextBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mMshFileNameTextBox.Location = new System.Drawing.Point(83, 19);
            this.mMshFileNameTextBox.Name = "mMshFileNameTextBox";
            this.mMshFileNameTextBox.Size = new System.Drawing.Size(325, 22);
            this.mMshFileNameTextBox.TabIndex = 0;
            this.mMshFileNameTextBox.DragDrop += new System.Windows.Forms.DragEventHandler(this.mMshFileNameTextBox_DragDrop);
            this.mMshFileNameTextBox.DragOver += new System.Windows.Forms.DragEventHandler(this.textBox_DragOver);
            // 
            // groupBox2
            // 
            this.groupBox2.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox2.Controls.Add(this.mClearButton);
            this.groupBox2.Controls.Add(this.mFileLocationTextBox);
            this.groupBox2.Controls.Add(this.mTypeComboBox);
            this.groupBox2.Controls.Add(this.label3);
            this.groupBox2.Controls.Add(this.mBrowseBig);
            this.groupBox2.Controls.Add(this.mBrowseGivenButton);
            this.groupBox2.Controls.Add(this.mSearchButton);
            this.groupBox2.Controls.Add(this.mBigFileTextBox);
            this.groupBox2.Controls.Add(this.mGivenFileTextBox);
            this.groupBox2.Location = new System.Drawing.Point(12, 23);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(403, 187);
            this.groupBox2.TabIndex = 1;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Find ";
            // 
            // mClearButton
            // 
            this.mClearButton.Location = new System.Drawing.Point(277, 83);
            this.mClearButton.Name = "mClearButton";
            this.mClearButton.Size = new System.Drawing.Size(75, 23);
            this.mClearButton.TabIndex = 9;
            this.mClearButton.Text = "&Clear";
            this.mClearButton.UseVisualStyleBackColor = true;
            this.mClearButton.Click += new System.EventHandler(this.mClearButton_Click);
            // 
            // mTypeComboBox
            // 
            this.mTypeComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.mTypeComboBox.FormattingEnabled = true;
            this.mTypeComboBox.Items.AddRange(new object[] {
            "Bytes",
            "ASCII String",
            "Unicode String"});
            this.mTypeComboBox.Location = new System.Drawing.Point(101, 86);
            this.mTypeComboBox.Name = "mTypeComboBox";
            this.mTypeComboBox.Size = new System.Drawing.Size(122, 21);
            this.mTypeComboBox.TabIndex = 7;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(6, 39);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(18, 13);
            this.label3.TabIndex = 6;
            this.label3.Text = "in:";
            // 
            // mBrowseBig
            // 
            this.mBrowseBig.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.mBrowseBig.Location = new System.Drawing.Point(378, 55);
            this.mBrowseBig.Name = "mBrowseBig";
            this.mBrowseBig.Size = new System.Drawing.Size(25, 23);
            this.mBrowseBig.TabIndex = 5;
            this.mBrowseBig.Text = "...";
            this.mBrowseBig.UseVisualStyleBackColor = true;
            this.mBrowseBig.Click += new System.EventHandler(this.mBrowseBig_Click);
            // 
            // mBrowseGivenButton
            // 
            this.mBrowseGivenButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.mBrowseGivenButton.Location = new System.Drawing.Point(378, 15);
            this.mBrowseGivenButton.Name = "mBrowseGivenButton";
            this.mBrowseGivenButton.Size = new System.Drawing.Size(25, 23);
            this.mBrowseGivenButton.TabIndex = 4;
            this.mBrowseGivenButton.Text = "...";
            this.mBrowseGivenButton.UseVisualStyleBackColor = true;
            this.mBrowseGivenButton.Click += new System.EventHandler(this.mBrowseGivenButton_Click);
            // 
            // mSearchButton
            // 
            this.mSearchButton.Location = new System.Drawing.Point(7, 84);
            this.mSearchButton.Name = "mSearchButton";
            this.mSearchButton.Size = new System.Drawing.Size(75, 23);
            this.mSearchButton.TabIndex = 2;
            this.mSearchButton.Text = "Search";
            this.mSearchButton.UseVisualStyleBackColor = true;
            this.mSearchButton.Click += new System.EventHandler(this.mSearchButton_Click);
            // 
            // mBigFileTextBox
            // 
            this.mBigFileTextBox.AllowDrop = true;
            this.mBigFileTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mBigFileTextBox.Location = new System.Drawing.Point(6, 57);
            this.mBigFileTextBox.Name = "mBigFileTextBox";
            this.mBigFileTextBox.Size = new System.Drawing.Size(366, 20);
            this.mBigFileTextBox.TabIndex = 1;
            this.mBigFileTextBox.DragDrop += new System.Windows.Forms.DragEventHandler(this.textBox_DragDrop);
            this.mBigFileTextBox.DragOver += new System.Windows.Forms.DragEventHandler(this.textBox_DragOver);
            // 
            // mGivenFileTextBox
            // 
            this.mGivenFileTextBox.AllowDrop = true;
            this.mGivenFileTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mGivenFileTextBox.Location = new System.Drawing.Point(6, 16);
            this.mGivenFileTextBox.Name = "mGivenFileTextBox";
            this.mGivenFileTextBox.Size = new System.Drawing.Size(366, 20);
            this.mGivenFileTextBox.TabIndex = 0;
            this.mGivenFileTextBox.DragDrop += new System.Windows.Forms.DragEventHandler(this.textBox_DragDrop);
            this.mGivenFileTextBox.DragOver += new System.Windows.Forms.DragEventHandler(this.textBox_DragOver);
            // 
            // mScriptSearchButton
            // 
            this.mScriptSearchButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.mScriptSearchButton.Location = new System.Drawing.Point(12, 216);
            this.mScriptSearchButton.Name = "mScriptSearchButton";
            this.mScriptSearchButton.Size = new System.Drawing.Size(93, 23);
            this.mScriptSearchButton.TabIndex = 2;
            this.mScriptSearchButton.Text = "Asset Search";
            this.mScriptSearchButton.UseVisualStyleBackColor = true;
            this.mScriptSearchButton.Click += new System.EventHandler(this.mScriptSearchButton_Click);
            // 
            // mFileLocationTextBox
            // 
            this.mFileLocationTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mFileLocationTextBox.Location = new System.Drawing.Point(9, 114);
            this.mFileLocationTextBox.Name = "mFileLocationTextBox";
            this.mFileLocationTextBox.ScrollBars = System.Windows.Forms.RichTextBoxScrollBars.Vertical;
            this.mFileLocationTextBox.SearchString = null;
            this.mFileLocationTextBox.Size = new System.Drawing.Size(363, 67);
            this.mFileLocationTextBox.StatusControl = null;
            this.mFileLocationTextBox.TabIndex = 8;
            this.mFileLocationTextBox.Text = "";
            // 
            // mStatusControl
            // 
            this.mStatusControl.AutoSize = true;
            this.mStatusControl.Location = new System.Drawing.Point(-2, 381);
            this.mStatusControl.Name = "mStatusControl";
            this.mStatusControl.Size = new System.Drawing.Size(35, 13);
            this.mStatusControl.TabIndex = 11;
            this.mStatusControl.Text = "status";
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(447, 396);
            this.Controls.Add(this.mStatusControl);
            this.Controls.Add(this.mScriptSearchButton);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "MainForm";
            this.Text = "Form1";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox mTgaFileNameTextBox;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox mMshFileNameTextBox;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.Button mSearchButton;
        private System.Windows.Forms.TextBox mBigFileTextBox;
        private System.Windows.Forms.TextBox mGivenFileTextBox;
        private System.Windows.Forms.Button mBrowseBig;
        private System.Windows.Forms.Button mBrowseGivenButton;
        private System.Windows.Forms.ComboBox mTypeComboBox;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button mScriptSearchButton;
        private SearchTextBox mFileLocationTextBox;
        private System.Windows.Forms.Button mClearButton;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox mCopyToFolderTextBox;
        private System.Windows.Forms.Button mCopyFilesButton;
        private System.Windows.Forms.Label mStatusControl;
    }
}

