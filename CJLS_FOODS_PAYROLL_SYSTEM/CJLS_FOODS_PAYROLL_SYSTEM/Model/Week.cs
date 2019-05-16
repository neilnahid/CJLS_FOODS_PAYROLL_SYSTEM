using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Model {
    public class Week : ModelPropertyChange {
        public Week() {
            Days = new List<Day>();
            for(int i = 0; i < 7; i++) {
                Days.Add(new Day());
            }
        }
        private List<Day> days;

        public List<Day> Days {
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
