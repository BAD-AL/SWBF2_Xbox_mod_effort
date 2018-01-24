using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace SWBF2CodeHelper
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void mGoButton_Click(object sender, EventArgs e)
        {
            LuaCodeHelper3 helper = new LuaCodeHelper3();
            mLuaTextBox.Text = helper.DecompileLuacListing(mLuacTextBox.Text);
        }
    }
}
