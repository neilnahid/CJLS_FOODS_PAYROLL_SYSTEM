﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM
{
    public partial class User : IDataErrorInfo
    {
        public bool IsValidationPassed { get; set; }
        public Dictionary<string, string> ErrorCollection { get; set; } = new Dictionary<string, string>();
        public string this[string name] {
            get {
                string result = null;
                switch (name)
                {
                    case "Username":
                        if (String.IsNullOrEmpty(Username))
                            result = "Field must not be empty.";
                        break;
                    case "FullName":
                        if (String.IsNullOrEmpty(FullName))
                            result = "Field must not be empty.";
                        break;
                    case "SecretQuestion":
                        if (String.IsNullOrEmpty(SecretQuestion))
                            result = "You must select a security question";
                        break;
                    case "SecretAnswer":
                        if (String.IsNullOrEmpty(SecretAnswer))
                            result = "Field must not be empty.";
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
        public void PSendPropertyChanged(String propertyName)
        {
            SendPropertyChanged(propertyName);
        }
        public string Error { get { return null; } }
    }
}