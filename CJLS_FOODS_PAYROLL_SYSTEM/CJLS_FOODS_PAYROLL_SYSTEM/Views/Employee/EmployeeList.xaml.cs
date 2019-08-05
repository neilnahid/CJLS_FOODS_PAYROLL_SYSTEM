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
    /// Interaction logic for EmployeeCreateNewEmployee.xaml
    /// </summary>
    public partial class EmployeeList : Page {
        View_Models.EmployeeViewModel VM;
        public EmployeeList() {
            InitializeComponent();
            VM = (View_Models.EmployeeViewModel)DataContext;
            VM.Instantiate();
        }

        private void btn_dialogConfirm_Click(object sender, RoutedEventArgs e) {
            switch (btn_dialogConfirm.Content.ToString()) {
                case "UPDATE": Helper.db.SubmitChanges(); MessageBox.Show("Successfully Updated Employee"); break;
                case "CREATE": VM.CreateNewEmployee(); break;
                default: MessageBox.Show("command invalid"); break;
            }
        }   
        private void Btn_Edit_Click(object sender, RoutedEventArgs e) {
            DialogHeader.Text = "Update Employee";
            btn_dialogConfirm.Content = "UPDATE";
            cmbbox_EmploymentStatus.IsEnabled = true;
            VM.UpdateEmployee();
        }

        private void Btn_deleteEmployee_Click(object sender, RoutedEventArgs e) {
            DialogHeader.Text = "Delete Employee";
            btn_dialogConfirm.Content = "DELETE";
            VM.DeleteEmployee(VM.Employee);
        }

        private void Btn_createNewEmployee_Click(object sender, RoutedEventArgs e) {
            VM.Employee = new CJLS_FOODS_PAYROLL_SYSTEM.Employee();
            VM.Employee.Status = "Active";
            DialogHeader.Text = "Create New Employee";
            cmbbox_EmploymentStatus.IsEnabled = false;
            btn_dialogConfirm.Content = "CREATE";
        }
    }
}
