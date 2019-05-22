using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Model {
    public class Week : ModelPropertyChange {
        public Week() {
            Days = new ObservableCollection<Model.ExtendedAttendance>();
            for(int i = 0; i < 7; i++) {
                Days.Add(new ExtendedAttendance() { Attendance = new Attendance { RegularHoursWorked = 8, OverTimeHoursWorked = 0}, RegularHoursFlag = System.Windows.Visibility.Collapsed, OverTimeHoursFlag = System.Windows.Visibility.Collapsed, DeductionsFlag = System.Windows.Visibility.Collapsed  });
            }
        }
        public Week(List<Attendance> attendances) {
        }
        private ObservableCollection<Model.ExtendedAttendance> days;

        public ObservableCollection<Model.ExtendedAttendance> Days {
            get { return days; }
            set {
                if (days != value) {
                    days = value;
                    RaisePropertyChanged("Days");
                }
            }
        }

    }
}
