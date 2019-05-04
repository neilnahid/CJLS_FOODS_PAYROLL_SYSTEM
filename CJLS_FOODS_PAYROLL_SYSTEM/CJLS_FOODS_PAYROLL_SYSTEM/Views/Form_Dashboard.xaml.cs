using System;
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
using System.Windows.Shapes;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Views {
    /// <summary>
    /// Interaction logic for Form_Dashboard.xaml
    /// </summary>
    public partial class Form_Dashboard : Window {
        public Form_Dashboard() {
            InitializeComponent();
        }

        private void Window_SizeChanged(object sender, SizeChangedEventArgs e) {
        }

        private void MenuToggleButton_Checked(object sender, RoutedEventArgs e)
        {
            
        }

        private void Btn_Payroll_Click(object sender, RoutedEventArgs e)
        {
            Frame.Content = new Views.Employee.PayrollDetails();
            Title.Text = "Payroll Details";
        }

        private void Btn_Employee_Click(object sender, RoutedEventArgs e)
        {
            Frame.Content = new Views.Employee.EmployeeList();
            Title.Text = "Employee List";
        }
    }
}
