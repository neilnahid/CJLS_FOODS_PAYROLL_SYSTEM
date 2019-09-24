using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace CJLS_FOODS_PAYROLL_SYSTEM
{
    public partial class Attendance
    {
        public Visibility UnderTimeFlag { get; set; }


        public Visibility RegularHoursFlag { get; set; }

        public Visibility OverTimeHoursFlag { get; set; }

        public Visibility DeductionsFlag { get; set; }
        public Visibility AbsentFlag { get; set; }
        //public bool IsValidationPassed { get; set; }
        //public string Error { get { return null; } }
        //public Dictionary<string, string> ErrorCollection { get; set; } = new Dictionary<string, string>();
        //public string this[string name] {
        //    get {
        //        string result = null;
        //        switch (name)
        //        {
        //            case "RegularHoursWorked":
        //                if (this.AttendanceDate != null)
        //                { }
        //                else if (!(RegularHoursWorked > PayrollDetail.Employee.DailyRequiredHours))
        //                    result = $"must exceed the daily required hours of {PayrollDetail.Employee.DailyRequiredHours}.";
        //                break;
        //        }
        //        SendPropertyChanging();
        //        if (result == null)
        //            ErrorCollection.Remove(name);
        //        if (ErrorCollection.ContainsKey(name))
        //            ErrorCollection[name] = result;
        //        else if (result != null)
        //            ErrorCollection.Add(name, result);
        //        IsValidationPassed = ErrorCollection.Count > 0 ? false : true;
        //        SendPropertyChanged("ErrorCollection");
        //        SendPropertyChanged("IsValidationPassed");
        //        return result;
        //    }
        //}
    }
}
