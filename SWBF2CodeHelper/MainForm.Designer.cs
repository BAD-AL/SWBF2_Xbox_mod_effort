﻿namespace SWBF2CodeHelper
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
            this.label1 = new System.Windows.Forms.Label();
            this.mGoButton = new System.Windows.Forms.Button();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.linkLabel1 = new System.Windows.Forms.LinkLabel();
            this.label2 = new System.Windows.Forms.Label();
            this.mCompareButton = new System.Windows.Forms.Button();
            this.mLoadLuacButton = new System.Windows.Forms.Button();
            this.mLuacTextBox = new SWBF2CodeHelper.SearchTextBox();
            this.mLuaTextBox = new SWBF2CodeHelper.SearchTextBox();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(72, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "Luac -l Listing";
            // 
            // mGoButton
            // 
            this.mGoButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.mGoButton.Location = new System.Drawing.Point(192, 607);
            this.mGoButton.Name = "mGoButton";
            this.mGoButton.Size = new System.Drawing.Size(129, 23);
            this.mGoButton.TabIndex = 5;
            this.mGoButton.Text = "Decompile =>";
            this.mGoButton.UseVisualStyleBackColor = true;
            this.mGoButton.Click += new System.EventHandler(this.mGoButton_Click);
            // 
            // splitContainer1
            // 
            this.splitContainer1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.splitContainer1.Location = new System.Drawing.Point(15, 25);
            this.splitContainer1.Name = "splitContainer1";
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.mLuacTextBox);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.mLuaTextBox);
            this.splitContainer1.Size = new System.Drawing.Size(906, 576);
            this.splitContainer1.SplitterDistance = 424;
            this.splitContainer1.TabIndex = 4;
            // 
            // linkLabel1
            // 
            this.linkLabel1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.linkLabel1.AutoSize = true;
            this.linkLabel1.Location = new System.Drawing.Point(561, 9);
            this.linkLabel1.Name = "linkLabel1";
            this.linkLabel1.Size = new System.Drawing.Size(240, 13);
            this.linkLabel1.TabIndex = 5;
            this.linkLabel1.TabStop = true;
            this.linkLabel1.Text = "https://www.scootersoftware.com/download.php";
            this.linkLabel1.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLabel1_LinkClicked);
            // 
            // label2
            // 
            this.label2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(436, 9);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(122, 13);
            this.label2.TabIndex = 6;
            this.label2.Text = "The Best Compare Tool:";
            // 
            // mCompareButton
            // 
            this.mCompareButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.mCompareButton.Location = new System.Drawing.Point(786, 607);
            this.mCompareButton.Name = "mCompareButton";
            this.mCompareButton.Size = new System.Drawing.Size(135, 23);
            this.mCompareButton.TabIndex = 20;
            this.mCompareButton.Text = "Compare Listings";
            this.mCompareButton.UseVisualStyleBackColor = true;
            this.mCompareButton.Click += new System.EventHandler(this.mCompareButton_Click);
            // 
            // mLoadLuacButton
            // 
            this.mLoadLuacButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.mLoadLuacButton.Location = new System.Drawing.Point(15, 607);
            this.mLoadLuacButton.Name = "mLoadLuacButton";
            this.mLoadLuacButton.Size = new System.Drawing.Size(171, 23);
            this.mLoadLuacButton.TabIndex = 3;
            this.mLoadLuacButton.Text = "Load compiled lua file";
            this.mLoadLuacButton.UseVisualStyleBackColor = true;
            this.mLoadLuacButton.Click += new System.EventHandler(this.loadLuacButton_Click);
            // 
            // mLuacTextBox
            // 
            this.mLuacTextBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.mLuacTextBox.EnableAutoDragDrop = true;
            this.mLuacTextBox.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mLuacTextBox.Location = new System.Drawing.Point(0, 0);
            this.mLuacTextBox.Name = "mLuacTextBox";
            this.mLuacTextBox.ScrollBars = System.Windows.Forms.RichTextBoxScrollBars.Vertical;
            this.mLuacTextBox.SearchString = null;
            this.mLuacTextBox.Size = new System.Drawing.Size(424, 576);
            this.mLuacTextBox.StatusControl = null;
            this.mLuacTextBox.TabIndex = 0;
            this.mLuacTextBox.Text = "";
            // 
            // mLuaTextBox
            // 
            this.mLuaTextBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.mLuaTextBox.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mLuaTextBox.Location = new System.Drawing.Point(0, 0);
            this.mLuaTextBox.Name = "mLuaTextBox";
            this.mLuaTextBox.ScrollBars = System.Windows.Forms.RichTextBoxScrollBars.Vertical;
            this.mLuaTextBox.SearchString = null;
            this.mLuaTextBox.Size = new System.Drawing.Size(478, 576);
            this.mLuaTextBox.StatusControl = null;
            this.mLuaTextBox.TabIndex = 2;
            this.mLuaTextBox.Text = "";
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(933, 635);
            this.Controls.Add(this.mLoadLuacButton);
            this.Controls.Add(this.mCompareButton);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.linkLabel1);
            this.Controls.Add(this.splitContainer1);
            this.Controls.Add(this.mGoButton);
            this.Controls.Add(this.label1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "MainForm";
            this.Text = "SWBF2 CodeHelper";
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            this.splitContainer1.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private SearchTextBox mLuacTextBox;
        private System.Windows.Forms.Label label1;
        private SearchTextBox mLuaTextBox;
        private System.Windows.Forms.Button mGoButton;
        private System.Windows.Forms.SplitContainer splitContainer1;
        private System.Windows.Forms.LinkLabel linkLabel1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button mCompareButton;
        private System.Windows.Forms.Button mLoadLuacButton;
    }
}

