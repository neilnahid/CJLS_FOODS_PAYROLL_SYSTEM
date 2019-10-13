using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM
{
    public partial class Employee : IDataErrorInfo
    {
      
        public Dictionary<string, string> ErrorCollection { get; private set; } = new Dictionary<string, string>();
        public bool IsValidationPassed { get; set; }
        public string DateOfBirthString { get; set; }
        public string this[string name] {
            get {
                string result = null;
                SendPropertyChanging();
                switch (name)
                {
                    case "FirstName":
                        if (String.IsNullOrEmpty(FirstName))
                            goto case "stringEmpty";
                        else if (!Regex.IsMatch(FirstName, "^[a-z A-Z]*$"))
                            goto case "onlychars";
                        break;
                    case "MiddleName":
                        if (String.IsNullOrEmpty(MiddleName))
                            goto case "stringEmpty";
                        else if (!Regex.IsMatch(FirstName, "^[a-z A-Z]*$"))
                            goto case "onlychars";
                        break;
                    case "LastName":
                        if (String.IsNullOrEmpty(LastName))
                            goto case "stringEmpty";
                        else if (!Regex.IsMatch(LastName, "^[a-z A-Z]*$"))
                            goto case "onlychars";
                        break;
                    case "Gender":
                        if (String.IsNullOrEmpty(Gender))
                            goto case "stringEmpty";
                        else if (!Regex.IsMatch(Gender, "^[a-z A-Z]*$"))
                            goto case "onlychars";
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
                        else if (!Regex.IsMatch(ContactNumber, "^[+][0-9]{12}$"))
                            result = "invalid format, accepted format: '+639123456789'";
                        break;
                    case "HourlyRate":
                        if (String.IsNullOrEmpty(HourlyRate.ToString()))
                            goto case "stringEmpty";
                        break;
                    case "Branch":
                        if(Branch == null)
                            result = "You must select a branch.";
                        break;
                    case "DateOfBirth":
                        if (DateOfBirth > DateTime.Now)
                            result = "must not exceed current date.";
                        break;
                    case "PayrollGroup":
                        if (PayrollGroup == null)
                            result = "You must select a Payroll Group";
                        break;
                    case "Status":
                        if (String.IsNullOrEmpty(Status))
                            goto case "stringEmpty";
                        break;
                    case "TINID":
                        if (!Regex.IsMatch(TINID == null ? "" : TINID, "^[0-9]{3}-[0-9]{3}-[0-9]{3}-[0-9]{3}$|^$"))
                            result = "format must be '000-000-000-000'";
                        if (IsIncomeTaxActive && String.IsNullOrEmpty(TINID))
                            result = "You must provide a TINID since it's active.";
                        break;
                    case "PhilhealthID":
                        if (!Regex.IsMatch(PhilhealthID == null ? "" : PhilhealthID, "^[0-9]{2}-[0-9]{9}-[0-9]$|^$"))
                            result = "format must be '00-123456789-0'";
                        if (IsPhilhealthActive && String.IsNullOrEmpty(PhilhealthID))
                            result = "You must provide a PhilhealthID since it's active.";
                        break;
                    case "PagIbigID":
                        if (!Regex.IsMatch(PagIbigID == null ? "" : PagIbigID, "^[0-9]{4}-[0-9]{4}-[0-9]{4}$|^$"))
                            result = "format must be 0000-0000-0000'";
                        if (IsPagibigActive && String.IsNullOrEmpty(PagIbigID))
                            result = "You must provide a PagIbigID since it's active.";
                        break;

                    case "SSSID":
                        if (!Regex.IsMatch(SSSID == null ? "" : SSSID, "^[0-9]{2}-[0-9]{7}-[0-9]$|^$"))
                            result = "fomat must be '00-1234567-0";
                        if (IsSSSActive && String.IsNullOrEmpty(SSSID))
                            result = "You must provide an SSS-ID since it's active.";
                        break;
                    case "IsSSSActive":
                            SendPropertyChanged("SSSID");
                        break;
                    case "IsPagibigActive":
                            SendPropertyChanged("PagIbigID");
                        break;
                    case "IsPhilhealthActive":
                            SendPropertyChanged("PhilhealthID");
                        break;
                    case "IsIncomeTaxActive":
                            SendPropertyChanged("TINID");
                        break;
                    case "RequiredDaysAWeek":
                        if (Double.IsNaN(RequiredDaysAWeek))
                            result = "you must specify number of days required per week.";
                        break;

                    case "onlychars": result = "Field must only contain characters."; break;

                    case "stringEmpty": result = "Field must not be empty."; break;
                }
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
