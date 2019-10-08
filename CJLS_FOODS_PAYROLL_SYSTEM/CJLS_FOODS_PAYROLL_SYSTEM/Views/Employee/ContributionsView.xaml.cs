using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
    /// Interaction logic for ContributionsView.xaml
    /// </summary>
    public partial class ContributionsView : Page
    {
        View_Models.ContributionsViewModel VM;

        public ContributionsView()
        {
            InitializeComponent();
            VM = (View_Models.ContributionsViewModel)DataContext;
            VM.Instantiate();
        }

        private void TextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            VM.Page = 0;
            string search = VM.Search.ToLower();
            if (!String.IsNullOrEmpty(search))
                VM.FilteredEmployees = new ObservableCollection<CJLS_FOODS_PAYROLL_SYSTEM.Employee>((from b in Helper.db.Employees where b.FullName.Contains(search) select b).ToList().Skip(VM.Page * 10).Take(10));
            else
                VM.FilteredEmployees = VM.GetEmployees();
            VM.Employees = new ObservableCollection<CJLS_FOODS_PAYROLL_SYSTEM.Employee>(VM.FilteredEmployees.Skip(VM.Page * 10).Take(10));
        }

        private void btn_previousPage_Click(object sender, RoutedEventArgs e)
        {
            VM.GotoPrevious();
        }

        private void btn_nextPage_Click(object sender, RoutedEventArgs e)
        {
            VM.GotoNext();
        }

        private void DataGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

        }
    }
}
