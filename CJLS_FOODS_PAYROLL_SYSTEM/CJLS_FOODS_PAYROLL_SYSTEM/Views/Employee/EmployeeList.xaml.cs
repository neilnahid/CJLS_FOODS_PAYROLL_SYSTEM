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

namespace CJLS_FOODS_PAYROLL_SYSTEM.Views.Employee
{
    /// <summary>
    /// Interaction logic for EmployeeCreateNewEmployee.xaml
    /// </summary>
    public partial class EmployeeList : Page
    {
        View_Models.EmployeeViewModel VM;
        public EmployeeList()
        {
            InitializeComponent();
            VM = (View_Models.EmployeeViewModel)DataContext;
            VM.Instantiate();
        }

        private void btn_dialogConfirm_Click(object sender, RoutedEventArgs e)
        {
            switch (btn_dialogConfirm.Content.ToString())
            {
                case "UPDATE": VM.UpdateEmployee(); MessageBox.Show("Successfully Updated Employee"); break;
                case "CREATE":
                    if (VM.CreateNewEmployee())
                    {
                        Helper.db = new DatabaseDataContext();
                        VM.Employees = VM.GetEmployeeList();
                    }
                    break;
                default: MessageBox.Show("command invalid"); break;
            }
            dialogHost.IsOpen = false;
        }
        private void Btn_deleteEmployee_Click(object sender, RoutedEventArgs e)
        {
            DialogHeader.Text = "Delete Employee";
            btn_dialogConfirm.Content = "DELETE";
            VM.DeleteEmployee(VM.Employee);
        }

        private void Btn_createNewEmployee_Click(object sender, RoutedEventArgs e)
        {
            VM.Employee = new CJLS_FOODS_PAYROLL_SYSTEM.Employee() { DateOfBirth = DateTime.Now };
            VM.Employee.Status = "Active";
            DialogHeader.Text = "Create New Employee";
            cmbbox_EmploymentStatus.IsEnabled = false;
            btn_dialogConfirm.Content = "CREATE";
        }

        private void TextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            string search = VM.Search.ToLower();
            VM.Employees = new System.Collections.ObjectModel.ObservableCollection<CJLS_FOODS_PAYROLL_SYSTEM.Employee>
                          ((from emp in VM.FilteredEmployees
                            where emp.FirstName.ToLower().Contains(search) || emp.LastName.ToLower().Contains(search) || emp.EmployeeType.Name.ToLower().Contains(search) || emp.Branch.Name.Contains(search)
                            select emp).ToList());
        }

        private void btn_cancelUpdate_Click(object sender, RoutedEventArgs e)
        {
            VM.Employees = VM.GetEmployeeList();
            VM.Employee = null;
        }

        private void btn_updateEmployee_Click(object sender, RoutedEventArgs e)
        {
            VM.UpdateEmployee();
            MessageBox.Show("Successfully updated Employees.");
            VM.Employees = VM.GetEmployeeList();
        }

        private void NumberValidation(object sender, TextCompositionEventArgs e)
        {
            int num;
            e.Handled = !int.TryParse(e.Text, out num);
        }

        private void btn_dialogCancel_Click(object sender, RoutedEventArgs e)
        {
            VM.Employee = VM.Employees.FirstOrDefault();
        }

        private void ComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            switch (VM.Filter)
            {
                case "All":
                    VM.FilteredEmployees = VM.GetEmployeeList();
                    break;
                case "Active":
                    VM.FilteredEmployees = new System.Collections.ObjectModel.ObservableCollection<CJLS_FOODS_PAYROLL_SYSTEM.Employee>((from emp in Helper.db.Employees where emp.Status == "Active" select emp).ToList());
                    break;
                case "Inactive":
                    VM.FilteredEmployees = new System.Collections.ObjectModel.ObservableCollection<CJLS_FOODS_PAYROLL_SYSTEM.Employee>((from emp in Helper.db.Employees where emp.Status == "Inactive" select emp).ToList());
                    break;
            }
            VM.Employees = VM.FilteredEmployees;
        }
    }
}
