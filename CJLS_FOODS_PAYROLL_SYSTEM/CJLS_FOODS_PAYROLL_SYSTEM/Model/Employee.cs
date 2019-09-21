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
                        if (String.IsNullOrEmpty(LastName))
                            goto case "stringEmpty";
                        break;
                    case "stringEmpty": result = "Field must not be empty."; break;
                    default:
                        result = "invalid property error"; break;
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
