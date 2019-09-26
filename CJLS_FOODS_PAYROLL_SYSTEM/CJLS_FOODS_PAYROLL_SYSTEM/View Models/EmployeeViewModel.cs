using GalaSoft.MvvmLight.Command;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Windows;
using System.Windows.Input;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class EmployeeViewModel : INotifyPropertyChanged
    {
        #region properties
        public event PropertyChangedEventHandler PropertyChanged;
        public List<EmployeeType> EmployeeTypes { get; set; }
        public List<Branch> Branches { get; set; } = (from b in Helper.db.Branches where b.IsActive select b).ToList();
        public ObservableCollection<Employee> Employees { get; set; }

        public string Search { get; set; }
        public DateTime DateTimeNow { get;} = DateTime.Now;
        public ObservableCollection<Employee> FilteredEmployees{ get; set; }
        public Employee Employee { get; set; }
        public PayrollGroup PayrollGroup { get; set; }
        public List<PayrollGroup> PayrollGroups { get; set; }

        public string Filter { get; set; }

        public bool IsUpdateValid { get; set; }
        #endregion
        #region constructor
        public void Instantiate()
        {
            Helper.db = new DatabaseDataContext();
            Employees = new ObservableCollection<Employee>(GetEmployeeList());
            PayrollGroups = GetPayrollGroups();
            Branches = GetBranches();
            EmployeeTypes = GetEmployeeTypes();
            Employee = Employees[0];
            FilteredEmployees = new ObservableCollection<Employee>((from e in Helper.db.Employees select e).ToList());
        }
        #endregion
        #region methods/functions
        public List<Branch> GetBranches()
        {
            return (from b in Helper.db.Branches select b).ToList();
        }
        public ObservableCollection<Employee> GetEmployeeList()
        {
            var result = new ObservableCollection<Employee>((from employee in Helper.db.Employees select employee).ToList());
            return result;
        }

        public List<PayrollGroup> GetPayrollGroups()
        {
            return (from pg in Helper.db.PayrollGroups select pg).ToList();
        }
        public bool CreateNewEmployee()
        {
            if (!((from e in Helper.db.Employees where e.FirstName.ToLower() == Employee.FirstName.ToLower() && e.LastName.ToLower() == Employee.LastName.ToLower() select e).Count() > 0))
            {
                Helper.db.Employees.InsertOnSubmit(Employee);
                Employee.Status = "Active";
                Employees.Add(Employee);
                Helper.db.SubmitChanges();
                MessageBox.Show("Successfully created new employee");
                return true;
                Helper.db = new DatabaseDataContext();
            }
            else
            {
                MessageBox.Show("Employee already exists");
                return false;
            }

        }
        public List<EmployeeType> GetEmployeeTypes()
        {
            return (from et in Helper.db.EmployeeTypes select et).ToList();
        }
        public void DeleteEmployee(Employee employee)
        {
            Helper.db.Employees.DeleteOnSubmit(Employee);
            Employees.Remove(Employee);
            Employee = new Employee();
            Helper.db.SubmitChanges();
            MessageBox.Show("Successfully Deleted Employee");
        }
        public void UpdateEmployee()
        {
            Helper.db.SubmitChanges();
            Employees = new ObservableCollection<Employee>(GetEmployeeList());
        }
        public void SearchEmployees()
        {
            if (!string.IsNullOrEmpty(Search))
            {
                Employees = new ObservableCollection<Employee>((from e in Helper.db.Employees
                                                                where e.FirstName.Contains(Search) ||
                                                                e.LastName.Contains(Search) ||
                                                                e.Emp_ID.Contains(Search) ||
                                                                e.EmployeeType.Name.Contains(Search) ||
                                                                e.PayrollGroup.Name.Contains(Search) ||
                                                                e.MiddleName.Contains(Search)
                                                                select e).ToList());
            }
            else
                Employees = new ObservableCollection<Employee>(GetEmployeeList());
        }
        protected void OnPropertyChanged(PropertyChangedEventArgs eventArgs)
        {
            PropertyChanged?.Invoke(this, eventArgs);
        }
        protected void OnPropertyChanged(string propertyName)
        {
            var propertyChanged = PropertyChanged;
            if (propertyChanged != null)
            {
                propertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }
        #endregion
    }
}
