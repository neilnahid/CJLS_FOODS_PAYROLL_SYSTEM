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
    /// Interaction logic for Payroll.xaml
    /// </summary>
    public partial class PayrollList : Page {
        View_Models.PayrollViewModel VM = new View_Models.PayrollViewModel();
        public PayrollList() {
            InitializeComponent();
            VM = (View_Models.PayrollViewModel)DataContext;
        }

        private void Btn_OpenDialogCreate_Click(object sender, RoutedEventArgs e) {
            VM.Payroll = new Payroll() { StartDate = DateTime.Now, EndDate = DateTime.Now };
            NavigationService.Navigate(new Views.PayrollView.PayrollDetails(VM.Payroll));
        }

        private void DialogHost_DialogClosing(object sender, MaterialDesignThemes.Wpf.DialogClosingEventArgs eventArgs) {

        }

        private void btn_DialogConfirm_Click(object sender, RoutedEventArgs e) {
        }

        private void Btn_viewPayroll_Click(object sender, RoutedEventArgs e) {
            NavigationService.Navigate(new Views.PayrollView.PayrollDetails(VM.Payroll));
        }
    }
}
