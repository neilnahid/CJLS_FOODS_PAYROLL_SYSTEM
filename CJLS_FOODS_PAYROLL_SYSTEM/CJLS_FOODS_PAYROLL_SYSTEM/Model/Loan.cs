using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM
{
    public partial class Loan : IDataErrorInfo
    {
        public bool IsValidationPassed { get; set; }
        public string Error { get { return null; } }
        public Dictionary<string, string> ErrorCollection { get; set; } = new Dictionary<string, string>();
        public string this[string name] {
            get {
                string result = null;
                switch (name)
                {
                    case "Terms":
                        if (!(Terms>0))
                            result = "Terms must be greater than 0.";
                        break;
                    case "Amount":
                        if(Employee != null)
                        {
                            if (Amount > Employee.MonthlySalary)
                                result = $"Amount cannot be greater than Employee's monthly salary({Employee.MonthlySalary}).";
                        }
                        if (!(Amount>0))
                            result = "Amount must be greater than zero,";
                        break;
                    case "Employee":
                        if (Employee == null)
                            result = "You must select an Employee,";
                        else if ((from l in Employee.Loans where !(l.IsPaid != null ? l.IsPaid.Value : false) && l.LoanID != 0 select l).Count() > 0)
                            result = $"{Employee.FullName} already has an existing loan that's unpaid.";
                        break;
                    case "LoanType":
                        if (LoanType == null)
                            result = "You must select a Loan Type.";
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
