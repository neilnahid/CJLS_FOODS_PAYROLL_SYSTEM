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
    /// Interaction logic for UsersLIst.xaml
    /// </summary>

    public partial class UserList : Page
    {
        View_Models.UserAdminViewModel VM = new View_Models.UserAdminViewModel();
        public UserList()
        {
            InitializeComponent();
            VM = (View_Models.UserAdminViewModel)DataContext;
            VM.Instantiate();
        }

        //private void PasswordBox_PasswordChanged(object sender, RoutedEventArgs e)
        //{
        //    VM.User.Password = passwordBox.Password.ToString();
        //    string result = null;
        //    if (!Regex.IsMatch(VM.User.Password == null ? "" : VM.User.Password, "(?=.{8,})^.*$"))
        //        result = "must contain at least 8 characters";
        //    if (!Regex.IsMatch(VM.User.Password == null ? "" : VM.User.Password, "(?=.*[0-9])^.*$"))
        //        result = "must contain atleast 1 number";
        //    if (!Regex.IsMatch(VM.User.Password == null ? "" : VM.User.Password, "(?=.*[A-Z])^.*$"))
        //        result = "must contain atleast 1 upper case letter";
        //    if (!Regex.IsMatch(VM.User.Password == null ? "" : VM.User.Password, "(?=.*[!@#$%^&*()\\-_=+{};:,<.>])^.*$"))
        //        result = "must contain atleast 1 special character";
        //    if (result == null)
        //    {
        //        txtblock_errors.Text = "";
        //        if (VM.User.ErrorCollection.ContainsKey("Password"))
        //            VM.User.ErrorCollection.Remove("Password");
        //        VM.User.IsValidationPassed = VM.User.ErrorCollection.Count > 0 ? false : true;
        //        VM.User.PSendPropertyChanged("ErrorCollection");
        //        VM.User.PSendPropertyChanged("IsValidationPassed");
        //        return;
        //    }
        //    else
        //    {
        //        txtblock_errors.Text = result;
        //        VM.User.ErrorCollection["Password"] = result;
        //        VM.User.IsValidationPassed = VM.User.ErrorCollection.Count > 0 ? false : true;
        //        VM.User.PSendPropertyChanged("ErrorCollection");
        //        VM.User.PSendPropertyChanged("IsValidationPassed");
        //    }
        //}
        private void Btn_Edit_Click(object sender, RoutedEventArgs e)
        {
            cb_employee.IsEnabled = false;
            DialogHeader.Text = "Update User";
            btn_dialogConfirm.Content = "UPDATE";
        }

        private void btn_DialogConfirm_Click(object sender, RoutedEventArgs e)
        {
            if (btn_dialogConfirm.Content.ToString() == "UPDATE")
            {
                VM.UpdateUser();
                MessageBox.Show("Successfully Updated User");
            }
            else if (btn_dialogConfirm.Content.ToString() == "CREATE")
            {
                VM.AddNewUser();
                MessageBox.Show("Successfully Created User, default password is 'cjlsfoods' ");
            }
            else if (btn_dialogConfirm.Content.ToString() == "DELETE")
            {
                VM.DeleteUser();
            }
            VM.Instantiate();

        }

        private void Btn_OpenDialogCreate_Click(object sender, RoutedEventArgs e)
        {
            cb_employee.IsEnabled = true;

            VM.User = new User() { Status = "Active", UserType = "Payroll Officer", Password = "cjlsfoods" };
            DialogHeader.Text = "Create New User";
            btn_dialogConfirm.Content = "CREATE";
        }

        private void DialogHost_DialogClosing(object sender, MaterialDesignThemes.Wpf.DialogClosingEventArgs eventArgs)
        {
            VM.Users = new System.Collections.ObjectModel.ObservableCollection<User>(VM.GetAllUsers());
        }
        public void LetterValidation(object sender, TextCompositionEventArgs e)
        {
            if (e.Text.All(c => char.IsWhiteSpace(c) || char.IsLetter(c)))
                e.Handled = false;
            else
                e.Handled = true;
        }

        private void ComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if(VM.User.Employee != null)
            VM.User.Username = VM.User.Employee.FullName.ToLower().Replace(' ','_'); 
        }
    }
}
