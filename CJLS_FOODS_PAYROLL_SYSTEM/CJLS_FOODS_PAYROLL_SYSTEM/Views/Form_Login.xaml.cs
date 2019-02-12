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
using System.Windows.Media.Animation;
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
            DoubleAnimation da = new DoubleAnimation(0, 1, new Duration(TimeSpan.FromSeconds(1)));
            BeginAnimation(Window.OpacityProperty, da);
        }

        private void PressedEnterKey(object sender, KeyEventArgs e) {
            if (e.Key == Key.Enter)
                btn_login_Click(sender, e);
        }

        private void textBox_GotFocus(object sender, RoutedEventArgs e) {
            var txtbox = (TextBox)sender;
            txtbox.Foreground = new SolidColorBrush((Color)ColorConverter.ConvertFromString("#171A21"));
            if (txtbox.Text == "Enter username" || txtbox.Text == "Enter password") {
                txtbox.Text = "";
            }
            else {
                txtbox.SelectAll();
            }
        }
        private void textBox_LeaveFocus(object sender, RoutedEventArgs e) {
            var txtbox = (TextBox)sender;
            if (txtbox.Name == "txtbox_username" && txtbox.Text == "") {
                txtbox.Foreground = new SolidColorBrush(Colors.Gray);
                txtbox.Text = "Enter username";
            }
            else if (txtbox.Name == "txtbox_password" && txtbox.Text == "") {
                txtbox.Foreground = new SolidColorBrush(Colors.Gray);
                txtbox.Text = "Enter password";
            }
        }
        private void btn_login_Click(object sender, RoutedEventArgs e) {
            if (txtbox_password.Text == "" && txtbox_username.Text == "") {
                MessageBox.Show("You must provide username and password.");
            }
            else if (txtbox_username.Text == "") {
                MessageBox.Show("You must provide a username.");
            }
            else if (txtbox_password.Text == "") {
                MessageBox.Show("You must provide a password");
            }
            else {
                var result = db.sp_checkLogin(txtbox_username.Text, txtbox_password.Text).ToList();
                if (result.Count > 0) {
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
                    txtbox_password.Text = "Enter password";
                    txtbox_username.Text = "Enter username";
                }
            }
        }

    }
}
