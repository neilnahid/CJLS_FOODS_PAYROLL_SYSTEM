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
using CJLS_FOODS_PAYROLL_SYSTEM.Models;
using CJLS_FOODS_PAYROLL_SYSTEM.Views;
namespace CJLS_FOODS_PAYROLL_SYSTEM {
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window {

        DatabaseDataContext db = new DatabaseDataContext();
        public MainWindow() {
            InitializeComponent();
        }

        private void Lbl_forgetPassword_MouseEnter(object sender, MouseEventArgs e) {
            lbl_forgetPassword.Foreground = new SolidColorBrush(Colors.Violet);
        }
        private void Lbl_forgetPassword_MouseLeave(object sender, MouseEventArgs e) {
            lbl_forgetPassword.Foreground = new SolidColorBrush(Colors.Black);
        }

        private void Btn_login_Click(object sender, RoutedEventArgs e) {
            if(txtbox_password.Text == "" && txtbox_userName.Text == "") {
                MessageBox.Show("You must provide username and password.");
            }
            else if(txtbox_userName.Text == "") {
                MessageBox.Show("You must provide a username.");
            }
            else if(txtbox_password.Text == "") {
                MessageBox.Show("You must provide a password");
            }
            else {
                var result = db.sp_checkLogin(txtbox_userName.Text, txtbox_password.Text).ToList();
                if(result.Count > 0) {
                    //successful login
                    MessageBox.Show("Successfully logged in!");
                    Form_Dashboard form_Dashboard = new Form_Dashboard();
                    MessageBox.Show(result[0].Username);
                    Controls.Session.userID = result[0].UserID;
                    Controls.Session.employeeID = (int)result[0].EmployeeID;
                    Controls.Session.userName = result[0].Username;
                    form_Dashboard.Show();
                    this.Hide();
                }
                else {
                    //incorrect credentials
                    MessageBox.Show("Incorrect Credentials, try again.");
                    txtbox_password.Text = "";
                    txtbox_userName.Text = "";
                }
            }
        }

        private void Window_RequestBringIntoView(object sender, RequestBringIntoViewEventArgs e) {

        }
    }
}
