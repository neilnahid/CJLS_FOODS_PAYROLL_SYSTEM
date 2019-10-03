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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Views.Accounts
{
    /// <summary>
    /// Interaction logic for AccountSettings.xaml
    /// </summary>
    public partial class AccountSettings : Page
    {
        View_Models.UserAccountViewModel VM;
        public AccountSettings()
        {
            InitializeComponent();
            VM = (View_Models.UserAccountViewModel)DataContext;
            VM.Instantiate();
            passwordBox.Password = VM.User.Password;
        }

        private void PasswordBox_PasswordChanged(object sender, RoutedEventArgs e)
        {
            VM.User.Password = passwordBox.Password.ToString();
            string result = null;
            if (!Regex.IsMatch(VM.User.Password == null ? "" : VM.User.Password, "(?=.{8,})^.*$"))
                result = "must contain at least 8 characters";
            if (!Regex.IsMatch(VM.User.Password == null ? "" : VM.User.Password, "(?=.*[0-9])^.*$"))
                result = "must contain atleast 1 number";
            if (!Regex.IsMatch(VM.User.Password == null ? "" : VM.User.Password, "(?=.*[A-Z])^.*$"))
                result = "must contain atleast 1 upper case letter";
            if (!Regex.IsMatch(VM.User.Password == null ? "" : VM.User.Password, "(?=.*[!@#$%^&*()\\-_=+{};:,<.>])^.*$"))
                result = "must contain atleast 1 special character";
            if (result == null)
            {
                txtblock_errors.Text = "";
                if (VM.User.ErrorCollection.ContainsKey("Password"))
                    VM.User.ErrorCollection.Remove("Password");
                VM.User.IsValidationPassed = VM.User.ErrorCollection.Count > 0 ? false : true;
                VM.User.PSendPropertyChanged("ErrorCollection");
                VM.User.PSendPropertyChanged("IsValidationPassed");
                return;
            }
            else
            {
                txtblock_errors.Text = result;
                VM.User.ErrorCollection["Password"] = result;
                VM.User.IsValidationPassed = VM.User.ErrorCollection.Count > 0 ? false : true;
                VM.User.PSendPropertyChanged("ErrorCollection");
                VM.User.PSendPropertyChanged("IsValidationPassed");
            }
        }

        private void btn_DialogConfirm_Click(object sender, RoutedEventArgs e)
        {
            VM.UpdateUser();
        }

        private void Page_Loaded(object sender, RoutedEventArgs e)
        {
            VM.User = Helper.User;
        }

        private void btn_cancel_Click(object sender, RoutedEventArgs e)
        {
            VM.Instantiate();
        }
    }
}
