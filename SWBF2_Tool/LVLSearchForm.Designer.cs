namespace SWBF2_Tool
{
    partial class LVLSearchForm
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
            this.label4 = new System.Windows.Forms.Label();
            this.mBrowseDir = new System.Windows.Forms.Button();
            this.mDirectoryTextBox = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.mSearchTextBox = new System.Windows.Forms.TextBox();
            this.mListBox = new System.Windows.Forms.ListBox();
            this.mOkButton = new System.Windows.Forms.Button();
            this.mSearchButton = new System.Windows.Forms.Button();
            this.mStatusLabel = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(3, 7);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(51, 13);
            this.label4.TabIndex = 17;
            this.label4.Text = "In Folder:";
            // 
            // mBrowseDir
            // 
            this.mBrowseDir.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.mBrowseDir.Location = new System.Drawing.Point(448, 21);
            this.mBrowseDir.Name = "mBrowseDir";
            this.mBrowseDir.Size = new System.Drawing.Size(25, 23);
            this.mBrowseDir.TabIndex = 16;
            this.mBrowseDir.Text = "...";
            this.mBrowseDir.UseVisualStyleBackColor = true;
            this.mBrowseDir.Click += new System.EventHandler(this.mBrowseDir_Click);
            // 
            // mDirectoryTextBox
            // 
            this.mDirectoryTextBox.AllowDrop = true;
            this.mDirectoryTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mDirectoryTextBox.Location = new System.Drawing.Point(6, 23);
            this.mDirectoryTextBox.Name = "mDirectoryTextBox";
            this.mDirectoryTextBox.Size = new System.Drawing.Size(436, 20);
            this.mDirectoryTextBox.TabIndex = 15;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(3, 48);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(116, 13);
            this.label1.TabIndex = 19;
            this.label1.Text = "Find Resource Named:";
            // 
            // mSearchTextBox
            // 
            this.mSearchTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mSearchTextBox.Location = new System.Drawing.Point(6, 64);
            this.mSearchTextBox.Name = "mSearchTextBox";
            this.mSearchTextBox.Size = new System.Drawing.Size(355, 20);
            this.mSearchTextBox.TabIndex = 18;
            this.mSearchTextBox.KeyDown += new System.Windows.Forms.KeyEventHandler(this.mSearchTextBox_KeyDown);
            // 
            // mListBox
            // 
            this.mListBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mListBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F);
            this.mListBox.FormattingEnabled = true;
            this.mListBox.ItemHeight = 16;
            this.mListBox.Location = new System.Drawing.Point(6, 90);
            this.mListBox.Name = "mListBox";
            this.mListBox.Size = new System.Drawing.Size(436, 228);
            this.mListBox.TabIndex = 20;
            // 
            // mOkButton
            // 
            this.mOkButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.mOkButton.Location = new System.Drawing.Point(392, 339);
            this.mOkButton.Name = "mOkButton";
            this.mOkButton.Size = new System.Drawing.Size(75, 23);
            this.mOkButton.TabIndex = 21;
            this.mOkButton.Text = "OK";
            this.mOkButton.UseVisualStyleBackColor = true;
            // 
            // mSearchButton
            // 
            this.mSearchButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.mSearchButton.Location = new System.Drawing.Point(367, 62);
            this.mSearchButton.Name = "mSearchButton";
            this.mSearchButton.Size = new System.Drawing.Size(75, 23);
            this.mSearchButton.TabIndex = 22;
            this.mSearchButton.Text = "&Search";
            this.mSearchButton.UseVisualStyleBackColor = true;
            this.mSearchButton.Click += new System.EventHandler(this.mSearchButton_Click);
            // 
            // mStatusLabel
            // 
            this.mStatusLabel.AutoSize = true;
            this.mStatusLabel.Location = new System.Drawing.Point(3, 344);
            this.mStatusLabel.Name = "mStatusLabel";
            this.mStatusLabel.Size = new System.Drawing.Size(0, 13);
            this.mStatusLabel.TabIndex = 23;
            // 
            // LVLSearchForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(479, 370);
            this.Controls.Add(this.mStatusLabel);
            this.Controls.Add(this.mSearchButton);
            this.Controls.Add(this.mOkButton);
            this.Controls.Add(this.mListBox);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.mSearchTextBox);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.mBrowseDir);
            this.Controls.Add(this.mDirectoryTextBox);
            this.MinimumSize = new System.Drawing.Size(444, 399);
            this.Name = "LVLSearchForm";
            this.Text = "LVLSearchForm";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button mBrowseDir;
        private System.Windows.Forms.TextBox mDirectoryTextBox;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox mSearchTextBox;
        private System.Windows.Forms.ListBox mListBox;
        private System.Windows.Forms.Button mOkButton;
        private System.Windows.Forms.Button mSearchButton;
        private System.Windows.Forms.Label mStatusLabel;
    }
}