using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Views
{
    /// <summary>
    /// Interaction logic for Form_Dashboard.xaml
    /// </summary>
    public partial class Form_Dashboard : Window
    {
        public User User { get; set; } = Helper.User;
        public Form_Dashboard()
        {
            InitializeComponent();
            Frame.Content = new Home();
            Helper.Title = Title;
            if (Helper.User != null & Helper.User.Password == "cjlsfoods")
            {
                if (Helper.User.SecretQuestion == null || Helper.User.SecretAnswer == null)
                    sp_securityPanel.Visibility = Visibility.Visible;
                else
                    sp_securityPanel.Visibility = Visibility.Collapsed;
                dg_changePassword.IsOpen = true;
            }
        }
        private void Window_SizeChanged(object sender, SizeChangedEventArgs e)
        {
        }

        private void MenuToggleButton_Checked(object sender, RoutedEventArgs e)
        {

        }

        private void Btn_Payroll_Click(object sender, RoutedEventArgs e)
        {
            //Frame.Content = new Views.Employee.PayrollDetails();
            //Title.Text = "Payroll Details";
        }

        private void Btn_Employee_Click(object sender, RoutedEventArgs e)
        {

        }

        private void TreeView_SelectedItemChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
        {
            TreeViewItem tvi = (TreeViewItem)((TreeView)sender).SelectedItem;
            if (tvi.Header.ToString() == "Employee List")
            {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.Employee.EmployeeList();
                Title.Text = "Employee List";
            }
            else if (tvi.Header.ToString() == "Payroll Groups")
            {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.Employee.PayrollGroup();
                Title.Text = "Payroll Groups";
            }
            else if (tvi.Header.ToString() == "Job Positions")
            {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.Employee.EmployeeTypeList();
                Title.Text = "Job Positions";
            }
            else if (tvi.Header.ToString() == "Branches")
            {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.Employee.BranchList();
                Title.Text = "Branches";
            }
            else if (tvi.Header.ToString() == "Users")
            {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.Accounts.UserList();
                Title.Text = "Users List";
            }
            else if (tvi.Header.ToString() == "Process Payroll")
            {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.PayrollView.PayrollList();
                Title.Text = "Process Payroll";
            }
            else if (tvi.Header.ToString() == "Process Leave")
            {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.Employee.Leave();
                Title.Text = "Process Leave";
            }
            else if (tvi.Header.ToString() == "Process Loans/Cash Advance")
            {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.Employee.LoanCashAdvance();
                Title.Text = "Process Loans/Cash Advance";
            }
            else if (tvi.Header.ToString() == "Account Settings")
            {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.Accounts.AccountSettings();
                Title.Text = "User Account Settings";
            }
            else if (tvi.Header.ToString() == "Contributions")
            {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.Employee.ContributionsView();
                Title.Text = "Contributions";
            }
            else if (tvi.Header.ToString() == "Government Contribution Rates")
            {
                draweHost.IsLeftDrawerOpen = false;
                Frame.Content = new Views.Payroll.GovernmentContributionRates();
                Title.Text = "Government Contribution Rates";
            }
            else if (tvi.Header.ToString() == "Logout")
            {
                new Views.Login_Form().Show();
                this.Close();
                Helper.User = null;
            }
        }

        private void btn_applyNewPassword_Click(object sender, RoutedEventArgs e)
        {
            if (pswrdbox_confirmPassword.Password == pswrdbox_newPassword.Password)
            {
                string result = null;
                if (!Regex.IsMatch(pswrdbox_newPassword.Password == null ? "" : pswrdbox_newPassword.Password, "(?=.{8,})^.*$"))
                    result = "must contain at least 8 characters";
                if (!Regex.IsMatch(pswrdbox_newPassword.Password == null ? "" : pswrdbox_newPassword.Password, "(?=.*[0-9])^.*$"))
                    result = "must contain atleast 1 number";
                if (!Regex.IsMatch(pswrdbox_newPassword.Password == null ? "" : pswrdbox_newPassword.Password, "(?=.*[A-Z])^.*$"))
                    result = "must contain atleast 1 upper case letter";
                if (!Regex.IsMatch(pswrdbox_newPassword.Password == null ? "" : pswrdbox_newPassword.Password, "(?=.*[!@#$%^&*()\\-_=+{};:,<.>])^.*$"))
                    result = "must contain atleast 1 special character";
                lbl_Error.Content = result;
                if (result == null)
                {
                    MessageBox.Show("Successfully changed password.");
                    dg_changePassword.IsOpen = false;
                    Helper.User.Password = pswrdbox_newPassword.Password;
                    Helper.db.SubmitChanges();
                }
            }
            else
                lbl_Error.Content = "confirm password does not match.";
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            if (Helper.User.UserType == "Owner")
                tvi_users.Visibility = Visibility.Visible;
        }
        private void PasswordBox_PasswordChanged(object sender, RoutedEventArgs e)
        {
            User.Password = pswrdbox_newPassword.Password.ToString();
            string result = null;
            if (!Regex.IsMatch(User.Password == null ? "" : User.Password, "(?=.{8,})^.*$"))
                result = "must contain at least 8 characters";
            if (!Regex.IsMatch(User.Password == null ? "" : User.Password, "(?=.*[0-9])^.*$"))
                result = "must contain atleast 1 number";
            if (!Regex.IsMatch(User.Password == null ? "" : User.Password, "(?=.*[A-Z])^.*$"))
                result = "must contain atleast 1 upper case letter";
            if (!Regex.IsMatch(User.Password == null ? "" : User.Password, "(?=.*[!@#$%^&*()\\-_=+{};:,<.>])^.*$"))
                result = "must contain atleast 1 special character";
            if (result == null)
            {
                lbl_Error.Content = "";
                if (User.ErrorCollection.ContainsKey("Password"))
                    User.ErrorCollection.Remove("Password");
                User.IsValidationPassed = User.ErrorCollection.Count > 0 ? false : true;
                User.PSendPropertyChanged("ErrorCollection");
                User.PSendPropertyChanged("IsValidationPassed");
                return;
            }
            else
            {
                lbl_Error.Content = result;
                User.ErrorCollection["Password"] = result;
                User.IsValidationPassed = User.ErrorCollection.Count > 0 ? false : true;
                User.PSendPropertyChanged("ErrorCollection");
                User.PSendPropertyChanged("IsValidationPassed");
            }
        }
    }
}
