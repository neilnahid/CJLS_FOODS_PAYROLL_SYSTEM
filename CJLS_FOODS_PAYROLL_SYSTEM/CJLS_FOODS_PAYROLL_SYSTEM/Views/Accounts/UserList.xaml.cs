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


        private void btn_CreateNewUser_Click(object sender, RoutedEventArgs e) {

        }

        private void PasswordBox_PasswordChanged(object sender, RoutedEventArgs e) {
            VM.User.Password = passwordBox.Password.ToString();
        }

        private void Btn_deleteUser_Click(object sender, RoutedEventArgs e) {

        }

        private void Btn_Edit_Click(object sender, RoutedEventArgs e) {
            VM.UpdateUser();
            MessageBox.Show("Successfully Updated User");
        }
    }
}
