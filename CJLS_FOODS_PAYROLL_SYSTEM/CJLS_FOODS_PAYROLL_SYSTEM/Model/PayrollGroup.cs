using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM
{
    public partial class PayrollGroup : IDataErrorInfo
    {
        public bool IsValidationPassed { get; set; }
        public string Error { get { return null; } }


        public Dictionary<string, string> ErrorCollection { get; set; } = new Dictionary<string, string>();
        public string this[string name] {
            get {
                string result = null;
                switch (name)
                {
                    case "Name":
                        if (String.IsNullOrEmpty(Name))
                            result = "Field must not be empty";
                        else if (PayrollGroupID == 0)
                        {
                            if ((from b in Helper.db.PayrollGroups where b.Name == Name select b).Count() > 0)
                                result = "branch name already exists in database";
                        }
                        else if ((from b in Helper.db.PayrollGroups where b.Name == Name && b.PayrollGroupID != PayrollGroupID select b).Count() > 0)
                            result = "branch name already exists in database";
                        break;
                    case "NumberOfDays":
                        if (NumberOfDays <= 0)
                            result = "Payroll Days must not be less than 0";
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
    }
}
