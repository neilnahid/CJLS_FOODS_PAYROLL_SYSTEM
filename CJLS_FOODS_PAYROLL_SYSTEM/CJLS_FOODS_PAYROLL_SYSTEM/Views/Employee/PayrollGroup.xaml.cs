using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Views.Employee
{
    /// <summary>
    /// Interaction logic for PayrollGroup.xaml
    /// </summary>
    public partial class PayrollGroup : Page
    {
        View_Models.PayrollGroupViewModel VM;
        public PayrollGroup()
        {
            InitializeComponent();
            VM = (View_Models.PayrollGroupViewModel)DataContext;
            VM.Instantiate();
        }
        private void NumberValidation(object sender, TextCompositionEventArgs e)
        {
            int num;
            e.Handled = !int.TryParse(e.Text, out num);
        }
        private void Btn_CreateNewPayrollGroup_Click(object sender, RoutedEventArgs e)
        {
            VM.PayrollGroup = new CJLS_FOODS_PAYROLL_SYSTEM.PayrollGroup();
            DialogHeader.Text = "Create New Payroll Group";
            btn_dialogConfirm.Content = "CREATE";
        }

        private void Btn_Edit_Click(object sender, RoutedEventArgs e)
        {
            DialogHeader.Text = "Update Employee Group";
            btn_dialogConfirm.Content = "UPDATE";
        }

        private void Btn_deletePayrollGroup_Click(object sender, RoutedEventArgs e)
        {
            DialogHeader.Text = "Delete Employee Group";
            btn_dialogConfirm.Content = "DELETE";
            VM.DeletePayrollGroup(VM.PayrollGroup);
        }

        private void btn_dialogConfirm_Click(object sender, RoutedEventArgs e)
        {
            switch (btn_dialogConfirm.Content.ToString())
            {
                case "UPDATE": Helper.db.SubmitChanges(); MessageBox.Show("Successfully Updated Payroll Group"); break;
                case "CREATE": VM.CreateNewPayrollGroup(); break;
                default: MessageBox.Show("command invalid"); break;
            }
        }

        private void btn_cancel_Click(object sender, RoutedEventArgs e)
        {
            Helper.db = new DatabaseDataContext();
            VM.GetPayrollGroups();
        }
        public void LetterValidation(object sender, TextCompositionEventArgs e)
        {
            if (e.Text.All(c => char.IsWhiteSpace(c) || char.IsLetter(c)))
                e.Handled = false;
            else
                e.Handled = true;
        }
    }
}
