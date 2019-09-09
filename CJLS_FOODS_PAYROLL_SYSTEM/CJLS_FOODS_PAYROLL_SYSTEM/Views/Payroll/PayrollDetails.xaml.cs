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

namespace CJLS_FOODS_PAYROLL_SYSTEM.Views.PayrollView {
    /// <summary>
    /// Interaction logic for PayrollDetails.xaml
    /// </summary>
    public partial class PayrollDetails : Page {
        View_Models.PayrollDetailsViewModel VM;
        public PayrollDetails(CJLS_FOODS_PAYROLL_SYSTEM.Payroll payroll) {
            InitializeComponent();
            VM = (View_Models.PayrollDetailsViewModel)DataContext;
            VM.InstantiatePayrollDetails(payroll);
            dialogHost.IsOpen = false;
        }
        private void DialogHost_DialogClosing(object sender, MaterialDesignThemes.Wpf.DialogClosingEventArgs eventArgs) {

        }

        private void Btn_OpenDialogCreate_Click(object sender, RoutedEventArgs e) {

        }

        private void btn_DialogConfirm_Click(object sender, RoutedEventArgs e) {

        }

        private void Btn_Edit_Click(object sender, RoutedEventArgs e) {
            StaticValues.Title.Text = "Attendance";
            NavigationService.Navigate(new Views.Employee.Attendance(VM.Payroll, VM.PayrollDetail));
        }

        private void Btn_PrintPayrollSummary_Click(object sender, RoutedEventArgs e)
        {
            Views.Reports.PayrollSummary payrollSummary = new Reports.PayrollSummary(VM.Payroll);
            payrollSummary.ShowDialog();
        }

        private void btn_PrintPayAllPayslips_Click(object sender, RoutedEventArgs e)
        {
            new Views.Reports.Payslip(VM.PayrollDetails[1]).ShowDialog();
        }
    }
}
