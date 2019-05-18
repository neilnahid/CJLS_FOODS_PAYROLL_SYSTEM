using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models {
    public class AttendanceViewModel : Model.ModelPropertyChange {
        public AttendanceViewModel() {
            startDate = new DateTime(2019, 5, 1);
            endDate = startDate.AddMonths(1);
            Month = GetMonthRange();
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
        private DeductionLog deduction;

        public DeductionLog Deduction {
            get { return deduction; }
            set {
                if (deduction != value) {
                    deduction = value;
                    RaisePropertyChanged("Deduction");
                }
            }
        }
        private List<DeductionLog> deductions;

        public List<DeductionLog> Deductions {
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
                    currentDay.DateTime = startDate.AddDays(j);
                    currentDay.MonthNumber = startDate.AddDays(j).Day;
                    month.Weeks.Add(new Model.Week());
                    weekCounter++;
                }
                else {
                    var currentDay = month.Weeks[weekCounter].Days[(int)startDate.AddDays(j).DayOfWeek];
                    currentDay.DateTime = startDate.AddDays(j);
                    currentDay.MonthNumber = startDate.AddDays(j).Day;
                }
            }
            return month;
        }
        public void SaveAttendance() {
            Helper.db.Attendances.InsertAllOnSubmit(Attendances);
            Helper.db.SubmitChanges();
        }
        public void AddAttendance(Attendance attendance) {
            Attendances.Add(attendance);
        }
        public void RemoveAttendance(Attendance attendance) {
            Attendances.Remove(attendance);
        }
        public void AddDeduction(DeductionLog deduction) {
            Deductions.Add(deduction);
        }
        public void RemoveDeduction(DeductionLog deduction) {
            deductions.Remove(deduction);
        }
    }
}
