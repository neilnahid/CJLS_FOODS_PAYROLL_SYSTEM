using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models {
    public class AttendanceViewModel : Model.ModelPropertyChange {
        public AttendanceViewModel() {
            Attendances = new List<Attendance>();

            startDate = new DateTime(2019, 6, 1);
            endDate = StartDate.AddDays(7);
            Month = GetMonthRange();
            SelectedWeek = new Model.Week();
            DeductionsTypes = GetDeductionTypes();
            Deduction = new Deduction();
        }
        private DateTime startDate;

        public DateTime StartDate {
            get { return startDate; }
            set {
                if (startDate != value) {
                    startDate = value;
                    RaisePropertyChanged("StartDate");
                }
            }
        }
        private DateTime endDate;

        public DateTime EndDate {
            get { return endDate; }
            set {
                if (endDate != value) {
                    endDate = value;
                    RaisePropertyChanged("EndDate");
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
            for (int j = 0; j < (EndDate - StartDate).TotalDays; j++) {
                if (startDate.AddDays(j).DayOfWeek == DayOfWeek.Saturday) {
                    var currentDay = month.Weeks[weekCounter].Days[(int)startDate.AddDays(j).DayOfWeek];
                    currentDay.AttendanceDate = startDate.AddDays(j);
                    Attendances.Add(currentDay);
                    month.Weeks.Add(new Model.Week());
                    weekCounter++;
                }
                else {
                    var currentDay = month.Weeks[weekCounter].Days[(int)startDate.AddDays(j).DayOfWeek];
                    currentDay.AttendanceDate = startDate.AddDays(j);
                    Attendances.Add(currentDay);
                }
            }
            return month;
        }
        public void SaveAttendance() {
            Helper.db.Attendances.InsertAllOnSubmit(Attendances);
            Helper.db.SubmitChanges();
        }
        //public void AddAttendance(Attendance attendance) {
        //    Attendances.Add(attendance);
        //}
        //public void RemoveAttendance(Attendance attendance) {
        //    Attendances.Remove(attendance);
        //}
        public void AddDeduction(Attendance a, Deduction d) {
            a.Deductions.Add(d);
        }
        //public void RemoveDeduction(Attendance attendance) {
        //    attendance.Deductions.Remove(deduction);
        //}
        private List<DeductionsType> GetDeductionTypes() {
            return (from i in Helper.db.DeductionsTypes select i).ToList();
        }
    }
}
