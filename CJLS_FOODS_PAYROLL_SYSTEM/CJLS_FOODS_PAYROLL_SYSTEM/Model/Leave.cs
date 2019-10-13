using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM
{
    public partial class Leave : IDataErrorInfo
    {
        public bool IsValidationPassed { get; set; }

        public Dictionary<string, string> ErrorCollection { get; set; } = new Dictionary<string, string>();
        public string this[string name] {
            get {
                string result = null;
                switch (name)
                {
                    case "LeaveDate":
                        if (LeaveDate == null)
                            result = "Field must not be empty";
                        else if (LeaveDate <= DateTime.Now)
                            result = "Leave date must not be earlier than current date";    
                        break;
                    case "Employee":
                        if (Employee == null)
                            result = "You must select an Employee";
                        break;
                }
                SendPropertyChanging();
                if (result == null)
                    ErrorCollection.Remove(name);
                if (ErrorCollection.ContainsKey(name))
                    ErrorCollection[name] = result;
                else if (result != null)
                    ErrorCollection.Add(name, result);
                IsValidationPassed = ErrorCollection.Count > 0 ? false : true;
                SendPropertyChanged("ErrorCollection");
                SendPropertyChanged("IsValidationPassed");
                return result;
            }
        }
        public string Error { get { return null; } }
    }
}
