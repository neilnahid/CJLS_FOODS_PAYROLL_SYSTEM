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
    /// Interaction logic for Leave.xaml
    /// </summary>
    public partial class Leave : Page
    {
        View_Models.LeaveViewModel VM;
        public Leave()
        {
            InitializeComponent();
            VM = (View_Models.LeaveViewModel)DataContext;
        }

        private void btn_dialogConfirm_Click(object sender, RoutedEventArgs e)
        {
            switch (btn_dialogConfirm.Content.ToString())
            {
                case "UPDATE": Helper.db.SubmitChanges(); MessageBox.Show("Successfully Updated Leave"); break;
                case "CREATE": VM.CreateNewLeave(); break;
                default: MessageBox.Show("command invalid"); break;
            }
        }

        private void Btn_Edit_Click(object sender, RoutedEventArgs e)
        {
            DialogHeader.Text = "Update Leave";
            btn_dialogConfirm.Content = "UPDATE";
        }
        private void Btn_createNewLeave_Click(object sender, RoutedEventArgs e)
        {
            DialogHeader.Text = "Create New Leave";
            btn_dialogConfirm.Content = "CREATE";
        }

        private void Btn_deleteLeave_Click(object sender, RoutedEventArgs e)
        {
            DialogHeader.Text = "Delete Leave";
            btn_dialogConfirm.Content = "DELETE";
            VM.DeleteLeave(VM.Leave);
        }
    }
}
