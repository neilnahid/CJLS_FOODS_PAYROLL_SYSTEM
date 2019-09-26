using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
namespace CJLS_FOODS_PAYROLL_SYSTEM.Model {
    public class Week : INotifyPropertyChanged {
        public ObservableCollection<Attendance> Days { get; set; }

        public Week(PayrollDetail pd) {
            Days = new ObservableCollection<Attendance>();
            for (int i = 0; i < 7; i++) {
                Days.Add(new Attendance() { DayType = "Normal", PayrollDetail = pd, RegularHoursWorked = pd.Employee.DailyRequiredHours, OverTimeHoursWorked = 0, RegularHoursFlag = Visibility.Collapsed, OverTimeHoursFlag = Visibility.Collapsed, DeductionsFlag = Visibility.Collapsed, UnderTimeFlag = Visibility.Collapsed, AbsentFlag = Visibility.Collapsed });
            }
        }
        public Week()
        {
            Days = new ObservableCollection<Attendance>();
            for (int i = 0; i < 7; i++)
            {
                Days.Add(new Attendance() { DayType = "Normal", RegularHoursFlag = Visibility.Collapsed, OverTimeHoursFlag = Visibility.Collapsed, DeductionsFlag = Visibility.Collapsed, UnderTimeFlag = Visibility.Collapsed, AbsentFlag = Visibility.Collapsed });
            }
        }
        public Week(List<Attendance> attendances) {
        }

        public event PropertyChangedEventHandler PropertyChanged;
    }
}
