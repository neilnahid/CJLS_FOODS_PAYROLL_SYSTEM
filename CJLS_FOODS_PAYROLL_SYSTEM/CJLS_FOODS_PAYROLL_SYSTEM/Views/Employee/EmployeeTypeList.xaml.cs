using System.Windows;
using System.Windows.Controls;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Views.Employee
{
    /// <summary>
    /// Interaction logic for EmployeeTypeList.xaml
    /// </summary>
    public partial class EmployeeTypeList : Page
    {
        View_Models.EmployeeTypeViewModel VM;
        public EmployeeTypeList()
        {
            InitializeComponent();
            VM = (View_Models.EmployeeTypeViewModel)DataContext;
            VM.Instantiate();
        }

        private void Btn_createNewEmployeeType_Click(object sender, RoutedEventArgs e)
        {
            VM.EmployeeType = new EmployeeType();
            DialogHeader.Text = "Create New Employee Type";
            btn_dialogConfirm.Content = "CREATE";
        }

        private void Btn_deleteEmployeeType_Click(object sender, RoutedEventArgs e)
        {
            DialogHeader.Text = "Delete Employee Type";
            btn_dialogConfirm.Content = "DELETE";
            VM.DeleteEmployeeType(VM.EmployeeType);
        }

        private void Btn_Edit_Click(object sender, RoutedEventArgs e)
        {
            DialogHeader.Text = "Update Employee Type";
            btn_dialogConfirm.Content = "UPDATE";
        }

        private void btn_dialogConfirm_Click(object sender, RoutedEventArgs e)
        {
            switch (btn_dialogConfirm.Content.ToString())
            {
                case "UPDATE": Helper.db.SubmitChanges(); MessageBox.Show("Successfully Updated Employee Type"); break;
                case "CREATE": VM.CreateNewEmployeeType(); break;
                default: MessageBox.Show("command invalid"); break;
            }
            VM.FetchEmployeeTypes();
        }

        private void btn_cancel_Click(object sender, RoutedEventArgs e)
        {
            Helper.db = new DatabaseDataContext();
           VM.EmployeeTypes = VM.FetchEmployeeTypes();
        }
    }
}
