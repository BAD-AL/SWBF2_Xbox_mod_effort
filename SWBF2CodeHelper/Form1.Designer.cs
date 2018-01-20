namespace SWBF2CodeHelper
{
    partial class Form1
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
            this.mLuacTextBox = new System.Windows.Forms.RichTextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.mLuaTextBox = new System.Windows.Forms.RichTextBox();
            this.mGoButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // mLuacTextBox
            // 
            this.mLuacTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)));
            this.mLuacTextBox.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mLuacTextBox.Location = new System.Drawing.Point(12, 28);
            this.mLuacTextBox.Name = "mLuacTextBox";
            this.mLuacTextBox.Size = new System.Drawing.Size(417, 470);
            this.mLuacTextBox.TabIndex = 0;
            this.mLuacTextBox.Text = "";
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
            // mLuaTextBox
            // 
            this.mLuaTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.mLuaTextBox.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mLuaTextBox.Location = new System.Drawing.Point(483, 28);
            this.mLuaTextBox.Name = "mLuaTextBox";
            this.mLuaTextBox.Size = new System.Drawing.Size(476, 470);
            this.mLuaTextBox.TabIndex = 2;
            this.mLuaTextBox.Text = "";
            // 
            // mGoButton
            // 
            this.mGoButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.mGoButton.Location = new System.Drawing.Point(15, 504);
            this.mGoButton.Name = "mGoButton";
            this.mGoButton.Size = new System.Drawing.Size(75, 23);
            this.mGoButton.TabIndex = 3;
            this.mGoButton.Text = "Go";
            this.mGoButton.UseVisualStyleBackColor = true;
            this.mGoButton.Click += new System.EventHandler(this.mGoButton_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(975, 532);
            this.Controls.Add(this.mGoButton);
            this.Controls.Add(this.mLuaTextBox);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.mLuacTextBox);
            this.Name = "Form1";
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.RichTextBox mLuacTextBox;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.RichTextBox mLuaTextBox;
        private System.Windows.Forms.Button mGoButton;
    }
}

