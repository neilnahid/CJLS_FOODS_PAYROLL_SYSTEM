using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models {
    public class AttendanceViewModel : Model.ModelPropertyChange {
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
        private Payroll payroll;

        public Payroll Payroll {
            get { return payroll; }
            set {
                if (payroll != value) {
                    payroll = value;
                    RaisePropertyChanged("Payroll");
                }
            }
        }
        private PayrollDetail payrollDetail;

        public PayrollDetail PayrollDetail {
            get { return payrollDetail; }
            set {
                if (payrollDetail != value) {
                    payrollDetail = value;
                    RaisePropertyChanged("PayrollDetail");
                }
            }
        }

        private Model.PayrollRange payrollRange;

        public Model.PayrollRange PayrollRange {
            get { return payrollRange; }
            set {
                if (payrollRange != value) {
                    payrollRange = value;
                    RaisePropertyChanged("PayrollRange");
                }
            }
        }
        private List<Attendance> attendances;

        public List<Attendance> Attendances {
            get { return attendances; }
            set {
                if (attendances != value) {
                    attendances = value;
                    RaisePropertyChanged("Attendances");
                }
            }
        }
        private Model.ExtendedAttendance attendance;

        public Model.ExtendedAttendance Attendance {
            get { return attendance; }
            set {
                if (attendance != value) {
                    attendance = value;
                    RaisePropertyChanged("Attendance");
                }
            }
        }
        private Deduction deduction;

        public Deduction Deduction {
            get { return deduction; }
            set {
                if (deduction != value) {
                    deduction = value;
                    RaisePropertyChanged("Deduction");
                }
            }
        }
        private Model.Week selectedWeek;

        public Model.Week SelectedWeek {
            get { return selectedWeek; }
            set {
                if (selectedWeek != value) {
                    selectedWeek = value;
                    RaisePropertyChanged("SelectedWeek");
                }
            }
        }
        private List<DeductionsType> deductionsTypes;

        public List<DeductionsType> DeductionsTypes {
            get { return deductionsTypes; }
            set {
                if (deductionsTypes != value) {
                    deductionsTypes = value;
                    RaisePropertyChanged("DeductionsTypes");
                }
            }
        }
        private ObservableCollection<Deduction> deductions;

        public ObservableCollection<Deduction> Deductions {
            get { return deductions; }
            set {
                if (deductions != value) {
                    deductions = value;
                    RaisePropertyChanged("Deductions");
                }
            }
        }

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
    }
}
