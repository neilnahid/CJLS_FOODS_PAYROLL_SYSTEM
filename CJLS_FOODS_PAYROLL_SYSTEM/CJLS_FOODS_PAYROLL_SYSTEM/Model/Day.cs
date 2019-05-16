using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Model {
    public class Day : ModelPropertyChange {
        public Day(int? monthNum, DateTime dateTime) {
            this.monthNumber = monthNum;
            this.dateTime = dateTime;
        }
        public Day() {

        }
        private int? monthNumber;

        public int? MonthNumber {
            get { return monthNumber; }
            set {
                if (monthNumber != value) {
                    monthNumber = value;
                    RaisePropertyChanged("MonthNumber");
                }
            }
        }
        private DateTime dateTime;
        public DateTime DateTime {
            get { return dateTime; }
            set {
                if (dateTime != value) {
                    dateTime = value;
                    RaisePropertyChanged("DateTime");
                }
            }
        }

    }
}
