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
namespace CJLS_FOODS_PAYROLL_SYSTEM.Views.PayrollView
{
    /// <summary>
    /// Interaction logic for Payroll.xaml
    /// </summary>
    public partial class PayrollList : Page
    {
        View_Models.PayrollViewModel VM;
        public PayrollList()
        {
            InitializeComponent();
            VM = (View_Models.PayrollViewModel)DataContext;
            VM.Instantiate();
        }

        private void Btn_OpenDialogCreate_Click(object sender, RoutedEventArgs e)
        {
            if (VM.Payroll != null)
                VM.Payroll = new CJLS_FOODS_PAYROLL_SYSTEM.Payroll() { StartDate = VM.Payroll.LatestEndDate, EndDate = VM.Payroll.LatestEndDate };
            else
                VM.Payroll = new CJLS_FOODS_PAYROLL_SYSTEM.Payroll();
            DialogHeader.Text = "Create New Payroll";
            btn_dialogConfirm.Content = "CREATE";
        }

        private void btn_DialogConfirm_Click(object sender, RoutedEventArgs e)
        {
            VM.CreateEmployeePayrollDetails();
            VM.Payroll.DateCreated = DateTime.Now.Date;
            Helper.db.Payrolls.InsertOnSubmit(VM.Payroll);
            Helper.db.SubmitChanges();
            Helper.db.Refresh(System.Data.Linq.RefreshMode.OverwriteCurrentValues, VM.Payroll);
            Helper.Title.Text = "Payroll Details";
            NavigationService.Navigate(new Views.PayrollView.PayrollDetails(VM.Payroll));
            VM.Payroll = new CJLS_FOODS_PAYROLL_SYSTEM.Payroll() { StartDate = DateTime.Now, EndDate = DateTime.Now };
        }

        private void Btn_viewPayroll_Click(object sender, RoutedEventArgs e)
        {
            Helper.Title.Text = "Payroll Details";
            NavigationService.Navigate(new Views.PayrollView.PayrollDetails(VM.Payroll));
            VM.Payroll = new CJLS_FOODS_PAYROLL_SYSTEM.Payroll() { StartDate = DateTime.Now, EndDate = DateTime.Now };
        }

        private void btn_deletePayroll_Click(object sender, RoutedEventArgs e)
        {
            var res = MessageBox.Show("Are you sure you want to delete it?", "Delete Payroll", MessageBoxButton.YesNo);
            if (res == MessageBoxResult.Yes)
                VM.deletePayroll(VM.Payroll);
        }

        private void Page_Loaded(object sender, RoutedEventArgs e)
        {
            VM = (View_Models.PayrollViewModel)DataContext;
            VM.Instantiate();
        }
        private void ComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (VM.Payroll.PayrollGroup != null)
            {
                VM.Payroll.LatestEndDate = (from p in Helper.db.Payrolls where p.PayrollGroup.PayrollGroupID == VM.Payroll.PayrollGroupID select p.EndDate).FirstOrDefault().AddDays(1);
                if (VM.Payroll.LatestEndDate.Date == new DateTime(0001, 01, 02))
                    VM.Payroll.StartDate = DateTime.Now;
                else
                    VM.Payroll.StartDate = VM.Payroll.LatestEndDate;
                VM.Payroll.EndDate = VM.Payroll.StartDate.AddDays(VM.Payroll.PayrollGroup.NumberOfDays-1);
            }
        }
        private void btn_previousPage_Click(object sender, RoutedEventArgs e)
        {
            VM.Page--;
            VM.Payrolls = VM.GetPagedResult();
        }

        private void btn_nextPage_Click(object sender, RoutedEventArgs e)
        {
            VM.Page++;
            VM.Payrolls = VM.GetPagedResult();
        }
        private void TextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            VM.Page = 0;
            string search = VM.Search.ToLower();
            if (!String.IsNullOrEmpty(search))
                VM.FilteredResult = new ObservableCollection<CJLS_FOODS_PAYROLL_SYSTEM.Payroll>((from b in Helper.db.Payrolls where String.Format("MM/dd/yyyy", b.StartDate).Contains(search) || String.Format("MM/dd/yyyy", b.EndDate).Contains(search) || b.PayrollGroup.Name.Contains(search) || b.PayrollID.ToString().Contains(search) select b).ToList().Skip(VM.Page * 5).Take(5));
            else
                VM.FilteredResult = VM.FetchPayrollList();
            VM.Payrolls = new ObservableCollection<CJLS_FOODS_PAYROLL_SYSTEM.Payroll>(VM.FilteredResult.Skip(VM.Page * 5).Take(5));
        }

        private void ComboBox_SelectionChanged_1(object sender, SelectionChangedEventArgs e)
        {

        }
    }
}
