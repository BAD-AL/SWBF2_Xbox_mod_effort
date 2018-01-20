namespace MissionMerge
{
    partial class MissionMergeForm
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
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MissionMergeForm));
            this.mBaseMissionTextBox = new System.Windows.Forms.TextBox();
            this.mBaseMissionListBox = new System.Windows.Forms.ListBox();
            this.mStatusControl = new System.Windows.Forms.Label();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.helpToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.showHelpToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.mSaveButton = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.mRemoveAddonLevelButton = new System.Windows.Forms.Button();
            this.mMergeButton = new System.Windows.Forms.Button();
            this.mAddonMissionTextBox = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.mAddonMissionListBox = new System.Windows.Forms.ListBox();
            this.mCloseButton = new System.Windows.Forms.Button();
            this.contextMenuStrip1 = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.selectAllToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.unSelectAllToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.removeSelectedToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.mergeOverToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.menuStrip1.SuspendLayout();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            this.contextMenuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // mBaseMissionTextBox
            // 
            this.mBaseMissionTextBox.AllowDrop = true;
            this.mBaseMissionTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mBaseMissionTextBox.Location = new System.Drawing.Point(6, 32);
            this.mBaseMissionTextBox.Name = "mBaseMissionTextBox";
            this.mBaseMissionTextBox.Size = new System.Drawing.Size(235, 20);
            this.mBaseMissionTextBox.TabIndex = 12;
            this.mBaseMissionTextBox.DragDrop += new System.Windows.Forms.DragEventHandler(this.ctrl_DragDrop);
            this.mBaseMissionTextBox.DragOver += new System.Windows.Forms.DragEventHandler(this.ctrl_DragOver);
            // 
            // mBaseMissionListBox
            // 
            this.mBaseMissionListBox.AllowDrop = true;
            this.mBaseMissionListBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mBaseMissionListBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mBaseMissionListBox.FormattingEnabled = true;
            this.mBaseMissionListBox.ItemHeight = 16;
            this.mBaseMissionListBox.Location = new System.Drawing.Point(3, 58);
            this.mBaseMissionListBox.Name = "mBaseMissionListBox";
            this.mBaseMissionListBox.Size = new System.Drawing.Size(238, 164);
            this.mBaseMissionListBox.TabIndex = 15;
            this.mBaseMissionListBox.DragOver += new System.Windows.Forms.DragEventHandler(this.ctrl_DragOver);
            this.mBaseMissionListBox.DragDrop += new System.Windows.Forms.DragEventHandler(this.ctrl_DragDrop);
            // 
            // mStatusControl
            // 
            this.mStatusControl.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.mStatusControl.AutoSize = true;
            this.mStatusControl.Location = new System.Drawing.Point(15, 336);
            this.mStatusControl.Name = "mStatusControl";
            this.mStatusControl.Size = new System.Drawing.Size(0, 13);
            this.mStatusControl.TabIndex = 23;
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.helpToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(573, 24);
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
            this.splitContainer1.Location = new System.Drawing.Point(12, 27);
            this.splitContainer1.Name = "splitContainer1";
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.mSaveButton);
            this.splitContainer1.Panel1.Controls.Add(this.label1);
            this.splitContainer1.Panel1.Controls.Add(this.mBaseMissionListBox);
            this.splitContainer1.Panel1.Controls.Add(this.mBaseMissionTextBox);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.mRemoveAddonLevelButton);
            this.splitContainer1.Panel2.Controls.Add(this.mMergeButton);
            this.splitContainer1.Panel2.Controls.Add(this.mAddonMissionTextBox);
            this.splitContainer1.Panel2.Controls.Add(this.label2);
            this.splitContainer1.Panel2.Controls.Add(this.mAddonMissionListBox);
            this.splitContainer1.Size = new System.Drawing.Size(548, 261);
            this.splitContainer1.SplitterDistance = 253;
            this.splitContainer1.TabIndex = 26;
            // 
            // mSaveButton
            // 
            this.mSaveButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.mSaveButton.Location = new System.Drawing.Point(9, 228);
            this.mSaveButton.Name = "mSaveButton";
            this.mSaveButton.Size = new System.Drawing.Size(110, 23);
            this.mSaveButton.TabIndex = 22;
            this.mSaveButton.Text = "&Save as";
            this.mSaveButton.UseVisualStyleBackColor = true;
            this.mSaveButton.Click += new System.EventHandler(this.mSaveButton_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(6, 14);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(150, 13);
            this.label1.TabIndex = 16;
            this.label1.Text = "Drag base \'mission.lvl\' file here";
            // 
            // mRemoveAddonLevelButton
            // 
            this.mRemoveAddonLevelButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.mRemoveAddonLevelButton.Location = new System.Drawing.Point(164, 228);
            this.mRemoveAddonLevelButton.Name = "mRemoveAddonLevelButton";
            this.mRemoveAddonLevelButton.Size = new System.Drawing.Size(110, 23);
            this.mRemoveAddonLevelButton.TabIndex = 21;
            this.mRemoveAddonLevelButton.Text = "Remove Selected";
            this.mRemoveAddonLevelButton.UseVisualStyleBackColor = true;
            this.mRemoveAddonLevelButton.Click += new System.EventHandler(this.mRemoveAddonLevelButton_Click);
            // 
            // mMergeButton
            // 
            this.mMergeButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.mMergeButton.Location = new System.Drawing.Point(6, 228);
            this.mMergeButton.Name = "mMergeButton";
            this.mMergeButton.Size = new System.Drawing.Size(128, 23);
            this.mMergeButton.TabIndex = 27;
            this.mMergeButton.Text = "<== &Merge Selected";
            this.mMergeButton.UseVisualStyleBackColor = true;
            this.mMergeButton.Click += new System.EventHandler(this.mMergeButton_Click);
            // 
            // mAddonMissionTextBox
            // 
            this.mAddonMissionTextBox.AllowDrop = true;
            this.mAddonMissionTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mAddonMissionTextBox.Location = new System.Drawing.Point(6, 32);
            this.mAddonMissionTextBox.Name = "mAddonMissionTextBox";
            this.mAddonMissionTextBox.Size = new System.Drawing.Size(268, 20);
            this.mAddonMissionTextBox.TabIndex = 17;
            this.mAddonMissionTextBox.DragDrop += new System.Windows.Forms.DragEventHandler(this.ctrl_DragDrop);
            this.mAddonMissionTextBox.DragOver += new System.Windows.Forms.DragEventHandler(this.ctrl_DragOver);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(3, 14);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(131, 13);
            this.label2.TabIndex = 17;
            this.label2.Text = "Drag your \'mission.lvl\' here";
            // 
            // mAddonMissionListBox
            // 
            this.mAddonMissionListBox.AllowDrop = true;
            this.mAddonMissionListBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mAddonMissionListBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mAddonMissionListBox.FormattingEnabled = true;
            this.mAddonMissionListBox.ItemHeight = 16;
            this.mAddonMissionListBox.Location = new System.Drawing.Point(6, 58);
            this.mAddonMissionListBox.Name = "mAddonMissionListBox";
            this.mAddonMissionListBox.SelectionMode = System.Windows.Forms.SelectionMode.MultiSimple;
            this.mAddonMissionListBox.Size = new System.Drawing.Size(268, 164);
            this.mAddonMissionListBox.TabIndex = 20;
            this.mAddonMissionListBox.DragOver += new System.Windows.Forms.DragEventHandler(this.ctrl_DragOver);
            this.mAddonMissionListBox.DragDrop += new System.Windows.Forms.DragEventHandler(this.ctrl_DragDrop);
            this.mAddonMissionListBox.MouseDown += new System.Windows.Forms.MouseEventHandler(this.mAddonMissionListBox_MouseDown);
            this.mAddonMissionListBox.KeyDown += new System.Windows.Forms.KeyEventHandler(this.mAddonMissionListBox_KeyDown);
            // 
            // mCloseButton
            // 
            this.mCloseButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.mCloseButton.Location = new System.Drawing.Point(485, 326);
            this.mCloseButton.Name = "mCloseButton";
            this.mCloseButton.Size = new System.Drawing.Size(75, 23);
            this.mCloseButton.TabIndex = 28;
            this.mCloseButton.Text = "&Close";
            this.mCloseButton.UseVisualStyleBackColor = true;
            this.mCloseButton.Click += new System.EventHandler(this.mCloseButton_Click);
            // 
            // contextMenuStrip1
            // 
            this.contextMenuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.selectAllToolStripMenuItem,
            this.unSelectAllToolStripMenuItem,
            this.removeSelectedToolStripMenuItem,
            this.mergeOverToolStripMenuItem});
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            this.contextMenuStrip1.Size = new System.Drawing.Size(183, 114);
            // 
            // selectAllToolStripMenuItem
            // 
            this.selectAllToolStripMenuItem.Name = "selectAllToolStripMenuItem";
            this.selectAllToolStripMenuItem.Size = new System.Drawing.Size(164, 22);
            this.selectAllToolStripMenuItem.Text = "Select All";
            this.selectAllToolStripMenuItem.Click += new System.EventHandler(this.selectAllToolStripMenuItem_Click);
            // 
            // unSelectAllToolStripMenuItem
            // 
            this.unSelectAllToolStripMenuItem.Name = "unSelectAllToolStripMenuItem";
            this.unSelectAllToolStripMenuItem.Size = new System.Drawing.Size(164, 22);
            this.unSelectAllToolStripMenuItem.Text = "Un-Select All";
            this.unSelectAllToolStripMenuItem.Click += new System.EventHandler(this.unSelectAllToolStripMenuItem_Click);
            // 
            // removeSelectedToolStripMenuItem
            // 
            this.removeSelectedToolStripMenuItem.Name = "removeSelectedToolStripMenuItem";
            this.removeSelectedToolStripMenuItem.Size = new System.Drawing.Size(164, 22);
            this.removeSelectedToolStripMenuItem.Text = "Remove Selected";
            this.removeSelectedToolStripMenuItem.Click += new System.EventHandler(this.removeSelectedToolStripMenuItem_Click);
            // 
            // mergeOverToolStripMenuItem
            // 
            this.mergeOverToolStripMenuItem.Name = "mergeOverToolStripMenuItem";
            this.mergeOverToolStripMenuItem.Size = new System.Drawing.Size(182, 22);
            this.mergeOverToolStripMenuItem.Text = "<== Merge Selected";
            this.mergeOverToolStripMenuItem.Click += new System.EventHandler(this.mergeOverToolStripMenuItem_Click);
            // 
            // MissionMergeForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(573, 361);
            this.Controls.Add(this.mCloseButton);
            this.Controls.Add(this.splitContainer1);
            this.Controls.Add(this.mStatusControl);
            this.Controls.Add(this.menuStrip1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MainMenuStrip = this.menuStrip1;
            this.MinimumSize = new System.Drawing.Size(400, 400);
            this.Name = "MissionMergeForm";
            this.Text = "Mission Merge!";
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel1.PerformLayout();
            this.splitContainer1.Panel2.ResumeLayout(false);
            this.splitContainer1.Panel2.PerformLayout();
            this.splitContainer1.ResumeLayout(false);
            this.contextMenuStrip1.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox mBaseMissionTextBox;
        private System.Windows.Forms.ListBox mBaseMissionListBox;
        private System.Windows.Forms.Label mStatusControl;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem helpToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem showHelpToolStripMenuItem;
        private System.Windows.Forms.SplitContainer splitContainer1;
        private System.Windows.Forms.ListBox mAddonMissionListBox;
        private System.Windows.Forms.Button mMergeButton;
        private System.Windows.Forms.Button mCloseButton;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox mAddonMissionTextBox;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button mRemoveAddonLevelButton;
        private System.Windows.Forms.Button mSaveButton;
        private System.Windows.Forms.ContextMenuStrip contextMenuStrip1;
        private System.Windows.Forms.ToolStripMenuItem selectAllToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem unSelectAllToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem removeSelectedToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem mergeOverToolStripMenuItem;
    }
}