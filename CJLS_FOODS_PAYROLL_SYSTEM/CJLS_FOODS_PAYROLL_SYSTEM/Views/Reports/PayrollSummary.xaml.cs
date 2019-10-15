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

namespace CJLS_FOODS_PAYROLL_SYSTEM.Views.Reports
{
    /// <summary>
    /// Interaction logic for PayrollSummary.xaml
    /// </summary>
    public partial class PayrollSummary : Window
    {
        View_Models.PayrollSummaryViewModel VM;
        public PayrollSummary(CJLS_FOODS_PAYROLL_SYSTEM.Payroll payroll)
        {
            InitializeComponent();
            VM = (View_Models.PayrollSummaryViewModel)DataContext;
            VM.Initialize(payroll.PayrollID);
        }

        private void btn_print_Click(object sender, RoutedEventArgs e)
        {
            VM.Print(fd_payrollSummary);
        }

        private void DataGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

        }
    }
}
