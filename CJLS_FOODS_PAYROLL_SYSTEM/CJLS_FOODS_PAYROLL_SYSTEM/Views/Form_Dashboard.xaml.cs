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
            StaticValues.Title = Title;
            Helper.db.ObjectTrackingEnabled = true;
        }

        private void Window_SizeChanged(object sender, SizeChangedEventArgs e) {
        }

        private void MenuToggleButton_Checked(object sender, RoutedEventArgs e) {

        }

        private void Btn_Payroll_Click(object sender, RoutedEventArgs e) {
            //Frame.Content = new Views.Employee.PayrollDetails();
            //Title.Text = "Payroll Details";
        }

        private void Btn_Employee_Click(object sender, RoutedEventArgs e) {

        }

        private void TreeView_SelectedItemChanged(object sender, RoutedPropertyChangedEventArgs<object> e) {
            TreeViewItem tvi = (TreeViewItem)((TreeView)sender).SelectedItem;
            if (tvi.Header.ToString() == "Employee List") {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.Employee.EmployeeList();
                Title.Text = "Employee List";
            }
            else if(tvi.Header.ToString() == "Employee Groups") {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.Employee.PayrollGroup();
                Title.Text = "Employee Groups";
            }
            else if (tvi.Header.ToString() == "Job Positions")
            {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.Employee.EmployeeTypeList();
                Title.Text = "Job Positions";
            }
            else if (tvi.Header.ToString() == "Users") {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.Accounts.UserList();
                Title.Text = "Users List";
            }
            else if (tvi.Header.ToString() == "Payroll") {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.PayrollView.PayrollList();
                Title.Text = "Payroll";
            }
            else if (tvi.Header.ToString() == "Leave")
            {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.Employee.Leave();
                Title.Text = "Leave";
            }
            else if (tvi.Header.ToString() == "Loans/Cash Advance")
            {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.Employee.LoanCashAdvance();
                Title.Text = "Loans/Cash Advance";
            }
        }
    }
}
