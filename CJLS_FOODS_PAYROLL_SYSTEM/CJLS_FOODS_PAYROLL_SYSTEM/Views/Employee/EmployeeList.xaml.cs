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
            VM = new View_Models.EmployeeViewModel();
            DataContext = VM;
            InitializeComponent();
        }

        private void Btn_createNewEmployee_Click(object sender, RoutedEventArgs e)
        {
            VM.CreateNewEmployee();
            MessageBox.Show("Successfully created new employee");
        }

        private void RdButtonMale_Checked(object sender, RoutedEventArgs e)
        {
            rdButtonFemale.IsChecked = false;
            VM.Employee.Gender = "Male";
        }

        private void RdButtonFemale_Checked(object sender, RoutedEventArgs e)
        {
            rdButtonMale.IsChecked = false;
            VM.Employee.Gender = "Female";
        }
    }
}
