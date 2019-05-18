using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Model {
    public class Week : ModelPropertyChange {
        public Week() {
            Days = new ObservableCollection<Attendance>();
            for(int i = 0; i < 7; i++) {
                Days.Add(new Attendance() { NumOfHoursWorked = 8 });
            }
        }
        private ObservableCollection<Attendance> days;

        public ObservableCollection<Attendance> Days {
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
