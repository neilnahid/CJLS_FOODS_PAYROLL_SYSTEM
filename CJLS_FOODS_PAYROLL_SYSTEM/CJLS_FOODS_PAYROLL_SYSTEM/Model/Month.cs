using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Model {
    public class PayrollRange : ModelPropertyChange {
        public PayrollRange(List<Attendance> attendances) {
            Weeks = new List<Week>();
            Weeks.Add(new Week());
            int weekCounter = 0;
            //assign each attendance to their corresponding dayofweek
            foreach(var a in attendances) {
                var currentDay = Weeks[weekCounter].Days[(int)a.AttendanceDate.Value.DayOfWeek];
                currentDay.Attendance = a;
                if(a.AttendanceDate.Value.DayOfWeek == DayOfWeek.Saturday) {
                    weekCounter++;
                    Weeks.Add(new Week());
                }
            }
            //sort attendance per week according to their
        }
        public PayrollRange() {
        }
        public PayrollRange(DateTime StartDate, DateTime EndDate) {
            Weeks = new List<Model.Week>();
            Weeks.Add(new Model.Week());
            int weekCounter = 0;
            for (int i = 0; i < (EndDate-StartDate).TotalDays; i++) {
                var currentDay = Weeks[weekCounter].Days[(int)StartDate.AddDays(i).DayOfWeek];
                currentDay.Attendance.AttendanceDate = StartDate.AddDays(i);
                if (StartDate.AddDays(i).DayOfWeek == DayOfWeek.Saturday) {
                    weekCounter++;
                    Weeks.Add(new Week());
                }
            }
        }
        private List<Week> weeks;

        public List<Week> Weeks {
            get { return weeks; }
            set {
                if (weeks != value) {
                    weeks = value;
                    RaisePropertyChanged("Weeks");
                }
            }
        }
    }
}
