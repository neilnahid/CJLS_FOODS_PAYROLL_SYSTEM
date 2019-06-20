using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.ComponentModel;
namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models {

    public class AttendanceViewModel : INotifyPropertyChanged {
        public void InstantiateViewModel(Payroll payroll, PayrollDetail selectedPayrollDetail) {
            Attendances = new List<Attendance>();
            Payroll = payroll;
            PayrollDetail = selectedPayrollDetail;
            PayrollRange = GetPayrollRange();
            SelectedWeek = new Model.Week();
            DeductionsTypes = GetDeductionTypes();
            Deduction = new Deduction();
            UpdateFlagsOfEveryAttendance();
        }
        public float TotalOverTimeHours { get; set; }

        public float TotalRegularHours { get; set; }

        public Payroll Payroll { get; set; }

        public PayrollDetail PayrollDetail { get; set; }
        public Model.PayrollRange PayrollRange { get; set; }

        public List<Attendance> Attendances { get; set; }
        public Model.ExtendedAttendance Attendance { get; set; }

        public Deduction Deduction { get; set; }
        public Model.Week SelectedWeek { get; set; }
        public List<DeductionsType> DeductionsTypes { get; set; }
        public ObservableCollection<Deduction> Deductions { get; set; }

        public event PropertyChangedEventHandler PropertyChanged;


        #region Methods/Functions
        public Model.PayrollRange GetPayrollRange() {
            if (PayrollDetail.Attendances.Count > 0) {
                return new Model.PayrollRange(PayrollDetail);
            }
            else
                return new Model.PayrollRange(Payroll.StartDate, Payroll.EndDate);
        }
        public void SaveAttendance() {
            AddToAttendances(PayrollRange);
            PayrollDetail.Attendances.AddRange(Attendances);
            Helper.db.SubmitChanges();
        }
        public void AddDeduction(Attendance a, Deduction d) {
            a.Deductions.Add(d);
        }
        private List<DeductionsType> GetDeductionTypes() {
            return (from i in Helper.db.DeductionsTypes select i).ToList();
        }
        public void UpdateFlagsOf(Model.ExtendedAttendance attendance) {
            if (attendance != null && attendance.Attendance.AttendanceDate != null) {
                UpdateRegularHoursFlag(attendance);
                UpdateOverTimeHoursFlag(attendance);
                UpdateDeductionsFlag(attendance);
            }
        }
        public void UpdateFlagsOfEveryAttendance() {
            foreach (var w in PayrollRange.Weeks) {
                foreach (var d in w.Days) {
                    UpdateFlagsOf(d);
                }
            }
        }
        public void AddToAttendances(Model.PayrollRange pr) {
            foreach (var w in pr.Weeks) {
                foreach (var d in w.Days) {
                    if (d.Attendance.AttendanceDate != null) {
                        Attendances.Add(d.Attendance);
                    }
                }
            }
        }
        #region UpdateFlags Functions
        private void UpdateRegularHoursFlag(Model.ExtendedAttendance a) {
            if (a.Attendance.RegularHoursWorked >= 8) {
                a.RegularHoursFlag = Visibility.Visible;
                a.UnderTimeFlag = Visibility.Collapsed;
            }
            else {
                a.RegularHoursFlag = Visibility.Collapsed;
                a.UnderTimeFlag = Visibility.Visible;
            }
        }
        private void UpdateOverTimeHoursFlag(Model.ExtendedAttendance a) {
            if (a.Attendance.OverTimeHoursWorked > 0)
                a.OverTimeHoursFlag = Visibility.Visible;
            else
                a.OverTimeHoursFlag = Visibility.Collapsed;
        }
        private void UpdateDeductionsFlag(Model.ExtendedAttendance a) {
            if (a.Attendance.Deductions.Count > 0)
                a.DeductionsFlag = Visibility.Visible;
            else
                a.DeductionsFlag = Visibility.Collapsed;
        }
        #endregion
        #endregion
    }
}
