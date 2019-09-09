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
    /// Interaction logic for Payslip.xaml
    /// </summary>
    public partial class Payslip : Window
    {
        View_Models.PayslipViewModel VM;
        public Payslip(List<PayrollDetail> payrollDetails)
        {
            InitializeComponent();
            VM = (View_Models.PayslipViewModel)DataContext;
            VM.Instantiate(payrollDetails);
        }

        private void btn_printPayslip_Click(object sender, RoutedEventArgs e)
        {
            VM.PrintPaySlip(fd_Payslip);
        }
    }

}
