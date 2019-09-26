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

namespace CJLS_FOODS_PAYROLL_SYSTEM.Views.Employee
{
    /// <summary>
    /// Interaction logic for LoanCashAdvance.xaml
    /// </summary>
    public partial class LoanCashAdvance : Page
    {
        View_Models.LoanCashAdvanceViewModel VM;
        public LoanCashAdvance()
        {
            InitializeComponent();
            VM = (View_Models.LoanCashAdvanceViewModel)DataContext;
            VM.Instantiate();
        }

        private void Btn_createNewLoan_Click(object sender, RoutedEventArgs e)
        {
            DialogHeader.Text = "Create New Loan";
            btn_dialogConfirm.Content = "CREATE";
            VM.Loan = new Loan();
        }

        private void Btn_dialogConfirm_Click(object sender, RoutedEventArgs e)
        {
            switch (btn_dialogConfirm.Content.ToString())
            {
                case "UPDATE": Helper.db.SubmitChanges(); MessageBox.Show("Successfully Updated Payroll Group"); break;
                case "CREATE": VM.CreatNewLoan(); break;
                default: MessageBox.Show("command invalid"); break;
            }
        }

        private void Btn_Edit_Click(object sender, RoutedEventArgs e)
        {
            DialogHeader.Text = "Update Loan";
            btn_dialogConfirm.Content = "UPDATE";
        }

        private void Btn_deleteLoan_Click(object sender, RoutedEventArgs e)
        {
            DialogHeader.Text = "Delete Loan";
            btn_dialogConfirm.Content = "DELETE";
            VM.DeleteLoan(VM.Loan);
        }

        private void NumberValidation(object sender, TextCompositionEventArgs e)
        {
            int num;
            e.Handled = !int.TryParse(e.Text, out num);
        }
        private void FloatValidation(object sender, TextCompositionEventArgs e)
        {
            bool approvedDecimalPoint = false;

            if (e.Text == ".")
            {
                if (!((TextBox)sender).Text.Contains("."))
                    approvedDecimalPoint = true;
            }

            if (!(char.IsDigit(e.Text, e.Text.Length - 1) || approvedDecimalPoint))
                e.Handled = true;
        }
    }
}
