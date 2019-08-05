﻿using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.ComponentModel;
namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models {
    public class EmployeeViewModel : INotifyPropertyChanged {
        #region properties
        public event PropertyChangedEventHandler PropertyChanged;
        public List<EmployeeType> EmployeeTypes { get; set; }
        public ObservableCollection<Employee> Employees { get; set; }
        public Employee Employee { get; set; }
        public PayrollGroup PayrollGroup { get; set; }
        public List<PayrollGroup> PayrollGroups { get; set; }
        #endregion
        #region constructor
        public EmployeeViewModel() {
            Employees = new ObservableCollection<Employee>(GetEmployeeList());
            PayrollGroups = GetPayrollGroups();
            Employee = new Employee();
            EmployeeTypes = GetEmployeeTypes();
        }
        public void Instantiate() {
            PayrollGroups = GetPayrollGroups();
            EmployeeTypes = GetEmployeeTypes();
        }
        #endregion


        #region methods/functions
        public List<Employee> GetEmployeeList() {
            var result = (from employee in Helper.db.Employees select employee).ToList();
            return result;
        }
        public List<PayrollGroup> GetPayrollGroups() {
            return (from pg in Helper.db.PayrollGroups select pg).ToList();
        }
        public void CreateNewEmployee() {
            Helper.db.Employees.InsertOnSubmit(Employee);
            Employee.Status = "Active";
            Employees.Add(Employee);
            Helper.db.SubmitChanges();
            MessageBox.Show("Successfully created new employee");
        }
        public List<EmployeeType> GetEmployeeTypes() {
            return (from et in Helper.db.EmployeeTypes select et).ToList();
        }
        public void DeleteEmployee(Employee employee) {
            Helper.db.Employees.DeleteOnSubmit(Employee);
            Employees.Remove(Employee);
            Employee = new Employee();
            Helper.db.SubmitChanges();
            MessageBox.Show("Successfully Deleted Employee");
        }
        public void UpdateEmployee() {
            Helper.db.SubmitChanges();
        }
        #endregion
    }
}
