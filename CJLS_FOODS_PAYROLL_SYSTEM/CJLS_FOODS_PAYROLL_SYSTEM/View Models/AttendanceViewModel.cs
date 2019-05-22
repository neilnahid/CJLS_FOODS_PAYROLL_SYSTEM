using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models {
    public class AttendanceViewModel : Model.ModelPropertyChange {
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

        private Model.Month month;

        public Model.Month Month {
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
        private Attendance attendance;

        public Attendance Attendance {
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
        private StackPanel currentStackPanel;

        public StackPanel CurrentStackPanel {
            get { return currentStackPanel; }
            set {
                if (currentStackPanel != value) {
                    currentStackPanel = value;
                    RaisePropertyChanged("CurrentStackPanel");
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

        public Model.Month GetMonthRange() {
            var month = new Model.Month();
            month.Weeks = new List<Model.Week>();
            month.Weeks.Add(new Model.Week());
            int weekCounter = 0;
            for (int j = 0; j < (Payroll.EndDate - Payroll.StartDate).TotalDays; j++) {
                if (Payroll.StartDate.AddDays(j).DayOfWeek == DayOfWeek.Saturday) {
                    var currentDay = month.Weeks[weekCounter].Days[(int)Payroll.StartDate.AddDays(j).DayOfWeek];
                    currentDay.AttendanceDate = Payroll.StartDate.AddDays(j);
                    currentDay.PayrollDetail = PayrollDetail;
                    currentDay.PayrollDetailsID = PayrollDetail.PayrollDetailID;
                    Attendances.Add(currentDay);
                    month.Weeks.Add(new Model.Week());
                    weekCounter++;
                }
                else {
                    var currentDay = month.Weeks[weekCounter].Days[(int)Payroll.StartDate.AddDays(j).DayOfWeek];
                    currentDay.AttendanceDate = Payroll.StartDate.AddDays(j);
                    currentDay.PayrollDetail = PayrollDetail;
                    currentDay.PayrollDetailsID = PayrollDetail.PayrollDetailID;
                    Attendances.Add(currentDay);
                }
            }
            return month;
        }
        public void SaveAttendance() {
            Helper.db.Attendances.InsertAllOnSubmit(Attendances);
            Helper.db.SubmitChanges();
        }
        public void AddDeduction(Attendance a, Deduction d) {
            a.Deductions.Add(d);
        }
        private List<DeductionsType> GetDeductionTypes() {
            return (from i in Helper.db.DeductionsTypes select i).ToList();
        }
        public void InstantiateViewModel(Payroll payroll, PayrollDetail selectedPayrollDetail) {
            Attendances = new List<Attendance>();
            Payroll = payroll;
            PayrollDetail = selectedPayrollDetail;
            Month = GetMonthRange();
            SelectedWeek = new Model.Week();
            DeductionsTypes = GetDeductionTypes();
            Deduction = new Deduction();
        }
    }
}
