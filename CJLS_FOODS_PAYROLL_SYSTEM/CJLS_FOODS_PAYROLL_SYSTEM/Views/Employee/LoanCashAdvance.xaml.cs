using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
            DialogHeader.Text = "Create new Loan/Cash Advance";
            btn_dialogConfirm.Content = "CREATE";
            VM.Loan = new Loan();
        }

        private void Btn_dialogConfirm_Click(object sender, RoutedEventArgs e)
        {
            switch (btn_dialogConfirm.Content.ToString())
            {
                case "UPDATE": VM.UpdateLoan(); MessageBox.Show("Successfully Updated Payroll Group"); break;
                case "CREATE": VM.CreatNewLoan(); break;
                default: MessageBox.Show("command invalid"); break;
            }
        }

        private void Btn_Edit_Click(object sender, RoutedEventArgs e)
        {
            DialogHeader.Text = "Update Loan/Cash Advance";
            btn_dialogConfirm.Content = "UPDATE";
        }

        private void Btn_deleteLoan_Click(object sender, RoutedEventArgs e)
        {
            DialogHeader.Text = "Delete Loan/Cash Advance";
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
        private void btn_previousPage_Click(object sender, RoutedEventArgs e)
        {
            VM.Page--;
            VM.Loans = VM.GetPagedResult();
        }

        private void btn_nextPage_Click(object sender, RoutedEventArgs e)
        {
            VM.Page++;
            VM.Loans = VM.GetPagedResult();
        }
        private void TextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            VM.Page = 0;
            string search = VM.Search.ToLower();
            if (!String.IsNullOrEmpty(search))
                VM.FilteredResult = new ObservableCollection<Loan>((from b in Helper.db.Loans where b.Employee.FullName.Contains(search) || b.LoanType.Contains(search) select b).ToList().Skip(VM.Page * 10).Take(10));
            else
                VM.FilteredResult = VM.GetLoans();
            VM.Loans = new ObservableCollection<Loan>(VM.FilteredResult.Skip(VM.Page * 10).Take(10));
        }
    }
}
