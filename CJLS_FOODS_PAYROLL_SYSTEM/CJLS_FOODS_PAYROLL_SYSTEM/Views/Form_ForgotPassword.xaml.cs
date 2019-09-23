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
namespace CJLS_FOODS_PAYROLL_SYSTEM.Views
{
    /// <summary>
    /// Interaction logic for Form_ForgotPassword.xaml
    /// </summary>
    public partial class Form_ForgotPassword : Window
    {
        View_Models.ForgotPasswordViewModel VM;
        public Form_ForgotPassword()
        {
            InitializeComponent();
            VM = (View_Models.ForgotPasswordViewModel)DataContext;
            VM.Instantiate();
        }

        private void TextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            VM.User = VM.searchUser();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            if (VM.IsAnswerCorrect())
            {
                VM.ResetUserDefaultPassword();
                MessageBox.Show("Successful. Password was reset to default 'admin'");
                this.Close();
            }
            else
                MessageBox.Show("Invalid Secret Answer");
        }

        private void btn_back_Click(object sender, RoutedEventArgs e)
        {
            new Views.Login_Form().Show();
            this.Close();
        }
    }
}
