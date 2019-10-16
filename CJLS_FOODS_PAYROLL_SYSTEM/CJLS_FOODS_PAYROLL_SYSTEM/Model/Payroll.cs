﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using PropertyChanged;
namespace CJLS_FOODS_PAYROLL_SYSTEM
{
    public partial class Payroll : IDataErrorInfo
    {
        public bool IsValidationPassed { get; set; }
        public string Error { get { return null; } }

        [PropertyChanged.AlsoNotifyFor("StartDate")]
        public string StartDateString { get; set; }
        [PropertyChanged.AlsoNotifyFor("EndDate")]
        public string EndDateString { get; set; }

        //the end date of the latest added payroll of given payroll group
        public DateTime LatestEndDate { get; set; }

        public DateTime EndDateRange { get; set; }

        public Dictionary<string, string> ErrorCollection { get; set; } = new Dictionary<string, string>();
        public string this[string name] {
            get {
                string result = null;
                switch (name)
                {
                    case "PayrollGroup":
                        if (PayrollGroup == null)
                            result = "You must select a Payroll Group";
                        if (StartDate < LatestEndDate)
                            result = $"start date must not be less than {LatestEndDate.ToString("MM/dd/yyyy")}";
                        break;
                    case "StartDateString":
                        if (!Regex.IsMatch(StartDateString == null ? "" : StartDateString, "^[0-10-9]{1,2}/[0-10-9]{1,2}/[0-9]{4}$"))
                            result = "Accepted format is mm/dd/yyyy";
                        break;
                    case "EndDateString":
                        if (!Regex.IsMatch(EndDateString == null ? "" : EndDateString, "^[0-10-9]{1,2}/[0-10-9]{1,2}/[0-9]{4}$"))
                            result = "Accepted format is mm/dd/yyyy";
                        break;

                    case "EndDate":
                        if (StartDate > EndDate)
                        {
                            result = "Startdate must not be greater than or equals to End Date.";
                        }
                        if (PayrollGroup != null)
                        {
                            if ((EndDate - StartDate).TotalDays+1 > PayrollGroup.NumberOfDays)
                                result = $"Payroll Range exceeds the payroll group's days coverage which is {PayrollGroup.NumberOfDays}";
                        }
                        break;

                    case "StartDate":
                        if (StartDate > EndDate)
                        {
                            result = "Startdate must not be greater than or equals to End Date.";
                        }
                        if (PayrollGroup != null)
                        {
                            if ((EndDate - StartDate).TotalDays+1 > PayrollGroup.NumberOfDays)
                                result = $"Payroll Range exceeds the payroll group's days coverage which is {PayrollGroup.NumberOfDays}";
                        }
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
                if (name == "EndDate")
                    SendPropertyChanged("StartDate");
                return result;
            }
        }
    }
}
