using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM
{
    public partial class Employee : IDataErrorInfo
    {
        public Dictionary<string, string> ErrorCollection { get; private set; } = new Dictionary<string, string>();
        public string this[string name] {
            get {
                string result = null;
                switch (name)
                {
                    case "FirstName":
                        if (String.IsNullOrEmpty(FirstName))
                            goto case "stringEmpty";
                        break;
                    case "MiddleName":
                        if (String.IsNullOrEmpty(MiddleName))
                            goto case "stringEmpty";
                        break;
                    case "LastName":
                        if (String.IsNullOrEmpty(LastName))
                            goto case "stringEmpty";
                        break;
                    case "Gender":
                        if (String.IsNullOrEmpty(Gender))
                            goto case "stringEmpty";
                        break;
                    case "Address":
                        if (String.IsNullOrEmpty(Address))
                            goto case "stringEmpty";
                        break;
                    case "EmployeeType":
                        if (EmployeeType == null)
                            result = "You must select a job position.";
                        break;
                    case "ContactNumber":
                        if (String.IsNullOrEmpty(ContactNumber))
                            goto case "stringEmpty";
                        break;
                    case "HourlyRate":
                        if (String.IsNullOrEmpty(HourlyRate.ToString()))
                            goto case "stringEmpty";
                        break;
                    case "Branch":
                        if (String.IsNullOrEmpty(Branch))
                            goto case "stringEmpty";
                        break;
                    case "PayrollGroup":
                        if (PayrollGroup == null)
                            result = "You must select a Payroll Group";
                        break;
                    case "Status":
                        if (String.IsNullOrEmpty(Status))
                            goto case "stringEmpty";
                        break;
                    case "RequiredDaysAWeek":
                        if (Double.IsNaN(RequiredDaysAWeek))
                            result = "you must specify number of days required per week.";
                        break;

                    case "stringEmpty": result = "Field must not be empty."; break;
                }
                if (ErrorCollection.ContainsKey(name))
                    ErrorCollection[name] = result;
                else if (result != null)
                    ErrorCollection.Add(name, result);
                SendPropertyChanged("ErrorCollection");
                SendPropertyChanged("IsUpdateValid");
                return result;
            }
        }

        public string Error { get { return null; } }
    }
}
