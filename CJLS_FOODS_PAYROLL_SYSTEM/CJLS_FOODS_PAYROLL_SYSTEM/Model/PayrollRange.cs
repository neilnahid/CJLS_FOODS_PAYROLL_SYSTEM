using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Model {
    public class PayrollRange : ModelPropertyChange {
        public PayrollRange(PayrollDetail payrollDetails) {
            Weeks = new List<Week>();
            Weeks.Add(new Week());
            int weekCounter = 0;
            //assign each attendance to their corresponding dayofweek
            foreach(var a in payrollDetails.Attendances) {
                if (a.AttendanceDate.HasValue)
                {
                    var currentDay = Weeks[weekCounter].Days[(int)a.AttendanceDate.Value.DayOfWeek];
                    currentDay.Attendance = a;
                    if (a.AttendanceDate.Value.DayOfWeek == DayOfWeek.Saturday)
                    {
                        weekCounter++;
                        Weeks.Add(new Week());
                    }
                }
            }
        }
        public PayrollRange()
        {

        }
        public PayrollRange(DateTime StartDate, DateTime EndDate, PayrollDetail pd) {
            Weeks = new List<Model.Week>();
            Weeks.Add(new Model.Week(pd));
            int weekCounter = 0;
            //assign each attendance to their corresponding dayofweek
            for (int i = 0; i < (EndDate-StartDate).TotalDays; i++) {
                var currentDay = Weeks[weekCounter].Days[(int)StartDate.AddDays(i).DayOfWeek];
                currentDay.Attendance.AttendanceDate = StartDate.AddDays(i);
                if (StartDate.AddDays(i).DayOfWeek == DayOfWeek.Saturday) {
                    weekCounter++;
                    Weeks.Add(new Week(pd));
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
