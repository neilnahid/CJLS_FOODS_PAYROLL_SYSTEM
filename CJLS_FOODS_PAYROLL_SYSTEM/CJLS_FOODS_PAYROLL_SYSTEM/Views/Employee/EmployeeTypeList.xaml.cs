using System.Windows;
using System.Windows.Controls;
using System;
using System.Linq;
using System.Collections.ObjectModel;
using System.Windows.Input;

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
            VM.Page = 0;
            VM.FilteredResult = VM.FetchEmployeeTypes();
            VM.EmployeeTypes = VM.GetPagedEmployeeTypes();
        }

        private void btn_cancel_Click(object sender, RoutedEventArgs e)
        {
            VM.Page = 0;
            Helper.db = new DatabaseDataContext();
           VM.FilteredResult = VM.FetchEmployeeTypes();
            VM.EmployeeTypes = VM.GetPagedEmployeeTypes();
        }
        private void btn_previousPage_Click(object sender, RoutedEventArgs e)
        {
            VM.Page--;
            VM.EmployeeTypes = VM.GetPagedEmployeeTypes();
        }

        private void btn_nextPage_Click(object sender, RoutedEventArgs e)
        {
            VM.Page++;
            VM.EmployeeTypes = VM.GetPagedEmployeeTypes();
        }
        private void TextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            VM.Page = 0;
            string search = VM.Search.ToLower();
            if (!String.IsNullOrEmpty(search))
                VM.FilteredResult = new ObservableCollection<EmployeeType>((from b in Helper.db.EmployeeTypes where b.Name.Contains(search) select b).ToList().Skip(VM.Page * 10).Take(10));
            else
                VM.FilteredResult = VM.FetchEmployeeTypes();
            VM.EmployeeTypes = new ObservableCollection<EmployeeType>(VM.FilteredResult.Skip(VM.Page * 10).Take(10));
        }
        public void LetterValidation(object sender, TextCompositionEventArgs e)
        {
            if (e.Text.All(c => char.IsWhiteSpace(c) || char.IsLetter(c)))
                e.Handled = false;
            else
                e.Handled = true;
        }
    }
}
