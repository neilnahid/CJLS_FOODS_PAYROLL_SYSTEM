using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;

namespace CJLS_FOODS_PAYROLL_SYSTEM
{
    public partial class Branch : IDataErrorInfo
    {
        public bool IsValidationPassed { get; set; }

        public Dictionary<string, string> ErrorCollection { get; set; } = new Dictionary<string, string>();
        public string this[string name] {
            get {
                string result = null;
                switch (name)
                {
                    case "Name":
                        if (String.IsNullOrEmpty(Name))
                            result = "Field must not be empty";
                        else if (BranchID == 0)
                        {
                            if ((from b in Helper.db.Branches where b.Name == Name select b).Count() > 0)
                                result = "branch name already exists in database";
                        }
                        else if ((from b in Helper.db.Branches where b.Name == Name && b.BranchID != BranchID select b).Count() > 0)
                            result = "branch name already exists in database";
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
