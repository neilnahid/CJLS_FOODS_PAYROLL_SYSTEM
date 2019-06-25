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

namespace CJLS_FOODS_PAYROLL_SYSTEM.Views.Employee {
    /// <summary>
    /// Interaction logic for PayrollGroup.xaml
    /// </summary>
    public partial class PayrollGroup : Page {
        View_Models.PayrollGroupViewModel VM;
        public PayrollGroup() {
            InitializeComponent();
            VM = (View_Models.PayrollGroupViewModel)DataContext;
        }

        private void btn_dialogConfirm_Click(object sender, RoutedEventArgs e) {
            switch (btn_dialogConfirm.Content.ToString()) {
                case "UPDATE": Helper.db.SubmitChanges(); MessageBox.Show("Successfully Updated Payroll Group"); break;
                case "CREATE": VM.CreateNewPayrollGroup(); break;
                default: MessageBox.Show("command invalid"); break;
            }
        }

        private void Btn_Edit_Click(object sender, RoutedEventArgs e) {
            DialogHeader.Text = "Update Employee";
            btn_dialogConfirm.Content = "UPDATE";
            VM.UpdatePayrollGroup();
        }

        private void Btn_deletePayrollGroup_Click(object sender, RoutedEventArgs e) {
            DialogHeader.Text = "Delete Employee";
            btn_dialogConfirm.Content = "DELETE";
            VM.DeletePayrollGroup(VM.PayrollGroup);
        }

        private void Btn_CreateNewPayrollGroup_Click(object sender, RoutedEventArgs e) {
            DialogHeader.Text = "Create New Payroll Group";
            btn_dialogConfirm.Content = "CREATE";
        }
    }
}
