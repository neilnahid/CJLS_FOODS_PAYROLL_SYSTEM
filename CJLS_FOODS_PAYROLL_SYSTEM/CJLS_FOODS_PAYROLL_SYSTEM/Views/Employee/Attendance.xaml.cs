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
using System.Data;
namespace CJLS_FOODS_PAYROLL_SYSTEM.Views.Employee
{
    /// <summary>
    /// Interaction logic for Attendance.xaml
    /// </summary>
    public partial class Attendance : Page
    {
        View_Models.AttendanceViewModel VM = new View_Models.AttendanceViewModel();
        public Attendance(Payroll payroll, PayrollDetail selectedPayrolLDetail)
        {
            Helper.CurrentPayrollDetail = selectedPayrolLDetail;
            InitializeComponent();
            Helper.db = new DatabaseDataContext();
            VM = (View_Models.AttendanceViewModel)DataContext;
            VM.InstantiateViewModel(payroll, selectedPayrolLDetail);
        }

        private void DataGridCalendar_SelectedCellsChanged(object sender, SelectedCellsChangedEventArgs e)
        {
            if (DataGridCalendar.CurrentCell.Column != null)
            {
                var colIndex = DataGridCalendar.CurrentCell.Column.DisplayIndex;
                VM.Attendance = VM.SelectedWeek.Days[colIndex];
            }
            grpbox_attendanceDetails.IsEnabled = VM.Attendance.AttendanceDate.HasValue ? true : false;
    
        }

        private void DataGridCalendar_CurrentCellChanged(object sender, EventArgs e)
        {
            if (DataGridCalendar.CurrentColumn != null)
            {
                var colIndex = DataGridCalendar.CurrentCell.Column.DisplayIndex;
                VM.Attendance = VM.SelectedWeek.Days[colIndex];
            }
            grpbox_attendanceDetails.IsEnabled = VM.Attendance.AttendanceDate.HasValue ? true : false;

        }
        private void Txtbox_regularHours_TextChanged(object sender, TextChangedEventArgs e)
        {
            VM.UpdateFlagsOf(VM.Attendance);
            VM.GetSummaryNumbers();
        }

        private void Txtbox_overtimeHours_TextChanged(object sender, TextChangedEventArgs e)
        {
            VM.UpdateFlagsOf(VM.Attendance);
            VM.GetSummaryNumbers();
        }

        private void Btn_dialogConfirm_Click(object sender, RoutedEventArgs e)
        {
            VM.Attendance.Deductions.Add(VM.Deduction);
            VM.UpdateFlagsOf(VM.Attendance);
            VM.GetSummaryNumbers();
            VM.populateBreakdownItems();
        }

        private void Btn_saveAttendance_Click(object sender, RoutedEventArgs e)
        {
            VM.SaveAttendance();
            MessageBox.Show("Successfully Saved Attendance");
            grpbox_attendanceDetails.IsEnabled = false;
        }

        private void Btn_openAddDeductionDialog_Click(object sender, RoutedEventArgs e)
        {
            VM.Deduction = new Deduction();
            VM.IsParentDialogOpen = true;
            VM.AddDeductionPanel = Visibility.Visible;
            VM.BreakdownPanel = Visibility.Collapsed;
            VM.ConfirmButtonVisibility = Visibility.Visible;
        }

        private void btn_viewItemBreakdown(object sender, RoutedEventArgs e)
        {
            var btn = (Button)sender;
            VM.getAllDeducions();
            VM.BPContributionsPanel = Visibility.Collapsed;
            VM.BPLoanCashAdvancePanel = Visibility.Collapsed;
            VM.BPTDaytoDayPanel = Visibility.Collapsed;
            switch (btn.Tag)
            {
                case "DaytoDay": VM.BPTDaytoDayPanel = Visibility.Visible; break;
                case "Loans/Cash Advance": VM.BPLoanCashAdvancePanel = Visibility.Visible; break;
                case "Contributions": VM.BPContributionsPanel = Visibility.Visible; break;
            }
        }

        private void Btn_viewBreakdownDialog_Click(object sender, RoutedEventArgs e)
        {
            VM.IsParentDialogOpen = true;
            VM.BreakdownPanel = Visibility.Visible;
            VM.AddDeductionPanel = Visibility.Collapsed;
            VM.ConfirmButtonVisibility = Visibility.Collapsed;
        }

        private void Btn_deleteDeduction_Click(object sender, RoutedEventArgs e)
        {
            VM.Attendance.Deductions.Remove(VM.Deduction);
            VM.UpdateFlagsOf(VM.Attendance);
        }

        private void DataGridCalendar_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (DataGridCalendar.CurrentColumn != null)
            {
                var colIndex = DataGridCalendar.CurrentCell.Column.DisplayIndex;
                VM.Attendance = VM.SelectedWeek.Days[colIndex];
            }
            grpbox_attendanceDetails.IsEnabled = VM.Attendance.AttendanceDate.HasValue ? true : false;
        }

        private void Page_Loaded(object sender, RoutedEventArgs e)
        {
            Helper.db = new DatabaseDataContext();
            VM = (View_Models.AttendanceViewModel)DataContext;
            VM.InstantiateViewModel(Helper.CurrentPayroll, Helper.CurrentPayrollDetail);
        }
    }
}
