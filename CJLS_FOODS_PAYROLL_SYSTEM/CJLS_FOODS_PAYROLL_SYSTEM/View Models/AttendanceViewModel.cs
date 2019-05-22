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
            Month = GetMonthRange();
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

        private Model.PayrollRange month;

        public Model.PayrollRange Month {
            get { return month; }
            set {
                if (month != value) {
                    month = value;
                    RaisePropertyChanged("Month");
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

        public Model.PayrollRange GetMonthRange() {
            if (PayrollDetail.Attendances.HasLoadedOrAssignedValues) {
                return new Model.PayrollRange(PayrollDetail.Attendances.ToList());
            }
            else
            return new Model.PayrollRange(Payroll.StartDate, Payroll.EndDate);
        }
        public void SaveAttendance() {
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
            if(attendance.Attendance.AttendanceDate != null) {
                if (attendance.Attendance.RegularHoursWorked == 8)
                    attendance.RegularHoursFlag = Visibility.Visible;
                else
                    attendance.RegularHoursFlag = Visibility.Collapsed;

                if (attendance.Attendance.OverTimeHoursWorked > 0)
                    attendance.OverTimeHoursFlag = Visibility.Visible;
                else
                    attendance.OverTimeHoursFlag = Visibility.Collapsed;

                if (attendance.Attendance.Deductions.Count > 0) {
                    attendance.DeductionsFlag = Visibility.Visible;
                }
                else
                    attendance.DeductionsFlag = Visibility.Collapsed;
            }
        }
        public void UpdateFlagsOfEveryAttendance() {
            foreach(var w in Month.Weeks) {
                foreach(var d in w.Days) {
                    UpdateFlagsOf(d);
                }
            }
        }
    }
}
