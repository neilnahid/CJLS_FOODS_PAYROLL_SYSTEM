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
namespace CJLS_FOODS_PAYROLL_SYSTEM.Views.Employee {
    /// <summary>
    /// Interaction logic for Attendance.xaml
    /// </summary>
    public partial class Attendance : Page {
        View_Models.AttendanceViewModel VM = new View_Models.AttendanceViewModel();
        public Attendance(Payroll payroll, PayrollDetail selectedPayrolLDetail) {
            InitializeComponent();
            VM = (View_Models.AttendanceViewModel)DataContext;
            VM.InstantiateViewModel(payroll, selectedPayrolLDetail);
        }

        private void DataGridCalendar_SelectedCellsChanged(object sender, SelectedCellsChangedEventArgs e) {
            if(DataGridCalendar.CurrentCell.Column != null) {
                var colIndex = DataGridCalendar.CurrentCell.Column.DisplayIndex;
                VM.Attendance = VM.SelectedWeek.Days[colIndex];
                VM.Deductions = new System.Collections.ObjectModel.ObservableCollection<Deduction>(VM.Attendance.Attendance.Deductions.ToList());
            }
        }

        private void DataGridCalendar_CurrentCellChanged(object sender, EventArgs e) {
            if(DataGridCalendar.CurrentColumn != null) {
                var colIndex = DataGridCalendar.CurrentCell.Column.DisplayIndex;
                VM.Attendance = VM.SelectedWeek.Days[colIndex];
                VM.Deductions = new System.Collections.ObjectModel.ObservableCollection<Deduction>(VM.Attendance.Attendance.Deductions.ToList());
            }
        }
        private void Txtbox_regularHours_TextChanged(object sender, TextChangedEventArgs e) {
            VM.UpdateFlagsOf(VM.Attendance);
        }

        private void Txtbox_overtimeHours_TextChanged(object sender, TextChangedEventArgs e) {
            VM.UpdateFlagsOf(VM.Attendance);
        }

        private void Btn_dialogConfirm_Click(object sender, RoutedEventArgs e) {
            VM.AddDeduction(VM.Attendance.Attendance, VM.Deduction);
            VM.Deduction = new Deduction();
            VM.Deductions = new System.Collections.ObjectModel.ObservableCollection<Deduction>(VM.Attendance.Attendance.Deductions.ToList());
            VM.UpdateFlagsOf(VM.Attendance);
        }

        private void Btn_saveAttendance_Click(object sender, RoutedEventArgs e) {
            VM.SaveAttendance();
            MessageBox.Show("Successfully Saved Attendance");
        }
    }
}
