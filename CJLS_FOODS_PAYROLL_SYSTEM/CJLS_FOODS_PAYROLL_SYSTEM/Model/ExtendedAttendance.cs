using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
namespace CJLS_FOODS_PAYROLL_SYSTEM.Model {
    public class ExtendedAttendance : INotifyPropertyChanged {

        public Attendance Attendance { get; set; }

        public Visibility UnderTimeFlag { get; set; }


        public Visibility RegularHoursFlag { get; set; }

        public Visibility OverTimeHoursFlag { get; set; }


        public Visibility DeductionsFlag { get; set; }

        public string MinutesLateWidth { get; set; }
        public string HoursWorkedWidth { get; set; }
        public string OverTimeHoursWorkedWidth { get; set; }
        public event PropertyChangedEventHandler PropertyChanged;
    }
}
