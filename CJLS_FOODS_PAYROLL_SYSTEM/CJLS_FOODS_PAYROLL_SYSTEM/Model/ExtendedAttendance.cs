using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
namespace CJLS_FOODS_PAYROLL_SYSTEM.Model {
    public class ExtendedAttendance : Model.ModelPropertyChange {
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
        private Visibility regularHoursFlag;

        public Visibility RegularHoursFlag {
            get { return regularHoursFlag; }
            set {
                if (regularHoursFlag != value) {
                    regularHoursFlag = value;
                    RaisePropertyChanged("RegularHoursFlag");
                }
            }
        }
        private Visibility overtimeHoursFlag;

        public Visibility OverTimeHoursFlag {
            get { return overtimeHoursFlag; }
            set {
                if (overtimeHoursFlag != value) {
                    overtimeHoursFlag = value;
                    RaisePropertyChanged("OverTimeHoursFlag");
                }
            }
        }
        private Visibility deductionsFlag;

        public Visibility DeductionsFlag {
            get { return deductionsFlag; }
            set {
                if (deductionsFlag != value) {
                    deductionsFlag = value;
                    RaisePropertyChanged("DeductionsFlag");
                }
            }
        }


    }
}
