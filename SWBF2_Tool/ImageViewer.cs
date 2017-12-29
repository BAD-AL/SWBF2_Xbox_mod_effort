using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace SWBF2_Tool
{
    public partial class ImageViewer : Form
    {
        public ImageViewer()
        {
            InitializeComponent();
        }

        public Image DisplayImage
        {
            set 
            {
                if (value != null)
                {
                    this.mPictureBox.Image = value;
                    this.Width = value.Width + 15;
                    this.Height = value.Height + 55;
                }
            }
        }

        private void mOkButton_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
