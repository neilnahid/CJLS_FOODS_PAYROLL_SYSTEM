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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Views.Accounts {
    /// <summary>
    /// Interaction logic for UsersLIst.xaml
    /// </summary>

    public partial class UserList : Page {
        View_Models.UserAdminViewModel VM = new View_Models.UserAdminViewModel();
        public UserList() {
            InitializeComponent();
            VM = (View_Models.UserAdminViewModel)DataContext;
        }

        private void PasswordBox_PasswordChanged(object sender, RoutedEventArgs e) {
            VM.User.Password = passwordBox.Password.ToString();
        }

        private void Btn_deleteUser_Click(object sender, RoutedEventArgs e) {
            DialogHeader.Text = "Are you sure you want to delete user?";
            sp_dialogFields.Visibility = Visibility.Collapsed;
            btn_dialogConfirm.Content = "DELETE";
        }

        private void Btn_Edit_Click(object sender, RoutedEventArgs e) {
            passwordBox.Password = VM.User.Password;
            DialogHeader.Text = "Update User";
            btn_dialogConfirm.Content = "UPDATE";
        }

        private void btn_DialogConfirm_Click(object sender, RoutedEventArgs e) {
            if (btn_dialogConfirm.Content.ToString() == "UPDATE") {
                VM.UpdateUser();
                MessageBox.Show("Successfully Updated User");
            }
            else if (btn_dialogConfirm.Content.ToString() == "CREATE") {
                VM.AddNewUser();
                MessageBox.Show("Successfully Created User");
            }
            else if (btn_dialogConfirm.Content.ToString() == "DELETE") {
                VM.DeleteUser();
            }

        }

        private void Btn_OpenDialogCreate_Click(object sender, RoutedEventArgs e) {
            DialogHeader.Text = "Create New User";
            btn_dialogConfirm.Content = "CREATE";
        }

        private void DialogHost_DialogClosing(object sender, MaterialDesignThemes.Wpf.DialogClosingEventArgs eventArgs) {
            VM.Users = new System.Collections.ObjectModel.ObservableCollection<User>(VM.GetAllUsers());
        }
    }
}
