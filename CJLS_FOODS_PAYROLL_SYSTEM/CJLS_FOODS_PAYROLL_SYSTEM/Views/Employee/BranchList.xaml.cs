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
    /// Interaction logic for BranchList.xaml
    /// </summary>
    public partial class BranchList : Page
    {
        View_Models.BranchViewModel VM;

        public BranchList()
        {
            InitializeComponent();
            VM = (View_Models.BranchViewModel)DataContext;
            VM.Instantiate();
        }

        private void btn_cancel_Click(object sender, RoutedEventArgs e)
        {
            Helper.db = new DatabaseDataContext();
            VM.Branches = VM.GetBranches();
        }

        private void btn_createNewBranch_Click(object sender, RoutedEventArgs e)
        {
            VM.Branch = new Branch() { IsActive = true };
            DialogHeader.Text = "Create New Branch";
            btn_dialogConfirm.Content = "CREATE";
        }

        private void btn_dialogConfirm_Click(object sender, RoutedEventArgs e)
        {
            switch (btn_dialogConfirm.Content.ToString())
            {
                case "UPDATE": Helper.db.SubmitChanges(); MessageBox.Show("Successfully Updated Branch"); break;
                case "CREATE":
                    var result = VM.AddBranch(VM.Branch);
                    if (String.IsNullOrEmpty(result))
                        MessageBox.Show("Successfully Added Branch");
                    else
                    {
                        MessageBox.Show(result);
                        return;
                    }
                    break;
                default: MessageBox.Show("command invalid"); break;
            }
            VM.Branches = VM.GetBranches();
            dialogHost.IsOpen = false;
        }

        private void Btn_Edit_Click(object sender, RoutedEventArgs e)
        {
            DialogHeader.Text = "Update Branch";
            btn_dialogConfirm.Content = "UPDATE";
        }

        private void btn_deleteBranch_Click(object sender, RoutedEventArgs e)
        {
            DialogHeader.Text = "Delete Employee Type";
            btn_dialogConfirm.Content = "DELETE";
            VM.DeleteBranch(VM.Branch);
        }
        private void btn_previousPage_Click(object sender, RoutedEventArgs e)
        {
            VM.Page--;
            VM.Branches = VM.GetPagedBranches();
        }

        private void btn_nextPage_Click(object sender, RoutedEventArgs e)
        {
            VM.Page++;
            VM.Branches = VM.GetPagedBranches();
        }
        private void TextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            VM.Page = 0;
            string search = VM.Search.ToLower();
            if (!String.IsNullOrEmpty(search))
                VM.FilteredBranches = new ObservableCollection<Branch>((from b in Helper.db.Branches where b.Name.Contains(search) select b).ToList().Skip(VM.Page * 10).Take(10));
            else
                VM.FilteredBranches = VM.GetBranches();
            VM.Branches = new ObservableCollection<Branch>(VM.FilteredBranches.Skip(VM.Page * 10).Take(10));
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
