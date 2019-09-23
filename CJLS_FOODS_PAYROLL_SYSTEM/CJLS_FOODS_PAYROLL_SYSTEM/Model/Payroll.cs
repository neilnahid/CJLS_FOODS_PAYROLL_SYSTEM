using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM
{
    public partial class Payroll : IDataErrorInfo
    {
        public bool IsValidationPassed { get; set; }
        public string Error { get { return null; } }

        public string StartDateString { get; set; }
        public string EndDateString { get; set; }

        public Dictionary<string, string> ErrorCollection { get; set; } = new Dictionary<string, string>();
        public string this[string name] {
            get {
                string result = null;
                switch (name)
                {
                    case "PayrollGroup":
                        if (PayrollGroup == null)
                            result = "You must select a Payroll Group";
                        break;
                    case "StartDateString":
                        DateTime date;
                        if(!Regex.IsMatch(StartDateString == null ? "" : StartDateString, "^[0-10-9]{1,2}/[0-10-9]{1,2}/[0-9]{4}$"))
                            result = "Accepted format is mm/dd/yyyy";
                        break;
                    case "EndDateString":
                        if (!Regex.IsMatch(EndDateString == null ? "" : EndDateString, "^[0-10-9]{1,2}/[0-10-9]{1,2}/[0-9]{4}$"))
                            result = "Accepted format is mm/dd/yyyy";
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
                SendPropertyChanged("IsValidationPassed");
                SendPropertyChanged("IsValidationPassed");
                return result;
            }
        }
    }
}
