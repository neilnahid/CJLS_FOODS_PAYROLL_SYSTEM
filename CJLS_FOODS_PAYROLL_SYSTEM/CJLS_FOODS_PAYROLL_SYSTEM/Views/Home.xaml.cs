﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Views
{
    /// <summary>
    /// Interaction logic for Home.xaml
    /// </summary>
    public partial class Home : Page
    {
        View_Models.HomeViewModel VM;
        public Home()
        {
            InitializeComponent();
            VM = (View_Models.HomeViewModel)DataContext;
            VM.Instantiate();
            if (VM.User.UserType == "Owner")
                txt_welcome_name.Text = "Owner";
        }
    }
}
