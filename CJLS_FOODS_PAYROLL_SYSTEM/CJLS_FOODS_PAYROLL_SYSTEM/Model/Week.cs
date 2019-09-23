﻿using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
namespace CJLS_FOODS_PAYROLL_SYSTEM.Model {
    public class Week : ModelPropertyChange {
        public Week(PayrollDetail pd) {
            Days = new ObservableCollection<Model.ExtendedAttendance>();
            for (int i = 0; i < 7; i++) {
                Days.Add(new ExtendedAttendance() { Attendance = new Attendance {PayrollDetail = pd, RegularHoursWorked = pd.Employee.DailyRequiredHours, OverTimeHoursWorked = 0 }, RegularHoursFlag = Visibility.Collapsed, OverTimeHoursFlag = Visibility.Collapsed, DeductionsFlag = Visibility.Collapsed, UnderTimeFlag = Visibility.Collapsed, AbsentFlag = Visibility.Collapsed });
            }
        }
        public Week()
        {
            Days = new ObservableCollection<Model.ExtendedAttendance>();
            for (int i = 0; i < 7; i++)
            {
                Days.Add(new ExtendedAttendance() { Attendance = new Attendance(), RegularHoursFlag = Visibility.Collapsed, OverTimeHoursFlag = Visibility.Collapsed, DeductionsFlag = Visibility.Collapsed, UnderTimeFlag = Visibility.Collapsed, AbsentFlag = Visibility.Collapsed });
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
