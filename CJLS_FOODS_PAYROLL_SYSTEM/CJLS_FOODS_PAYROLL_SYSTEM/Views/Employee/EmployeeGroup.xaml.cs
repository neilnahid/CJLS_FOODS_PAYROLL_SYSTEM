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
    /// Interaction logic for EmployeeGroup.xaml
    /// </summary>
    public partial class EmployeeGroup : Page {
        View_Models.EmployeeGroupViewModel VM;
        public EmployeeGroup() {
            InitializeComponent();
            VM = (View_Models.EmployeeGroupViewModel)DataContext;
        }
        private void btn_dialogConfirm_Click(object sender, RoutedEventArgs e) {
            switch (btn_dialogConfirm.Content.ToString()) {
                case "UPDATE": Helper.db.SubmitChanges(); MessageBox.Show("Successfully Updated Employee"); break;
                case "CREATE": VM.CreateNewEmployeeGroup(); break;
                default: MessageBox.Show("command invalid"); break;
            }
        }

        private void Btn_Edit_Click(object sender, RoutedEventArgs e) {
            DialogHeader.Text = "Update Employe Group";
            btn_dialogConfirm.Content = "UPDATE";
            VM.UpdateEmployeeGroup();
        }

        private void Btn_deleteEmployeeGroup_Click(object sender, RoutedEventArgs e) {
            DialogHeader.Text = "Delete Employee Group";
            btn_dialogConfirm.Content = "DELETE";
            VM.DeleteEmployeeGroup(VM.EmployeeGroup);
        }

        private void Btn_CreateNewEmployeeGroup_Click(object sender, RoutedEventArgs e) {
            DialogHeader.Text = "Create Employee Group";
            btn_dialogConfirm.Content = "CREATE";
        }
    }
}
