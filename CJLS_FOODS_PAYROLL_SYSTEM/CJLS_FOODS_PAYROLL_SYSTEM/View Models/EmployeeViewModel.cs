using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Windows;
namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class EmployeeViewModel : INotifyPropertyChanged
    {
        #region properties
        public event PropertyChangedEventHandler PropertyChanged;
        public List<EmployeeType> EmployeeTypes { get; set; }
        public ObservableCollection<Employee> Employees { get; set; }

        public string Search { get; set; }
        public Employee Employee { get; set; }
        public PayrollGroup PayrollGroup { get; set; }
        public List<PayrollGroup> PayrollGroups { get; set; }
        #endregion
        #region constructor
        public void Instantiate()
        {
            Helper.db = new DatabaseDataContext();
            Employees = new ObservableCollection<Employee>(GetEmployeeList());
            PayrollGroups = GetPayrollGroups();
            Employee = new Employee();
            EmployeeTypes = GetEmployeeTypes();
        }
        #endregion


        #region methods/functions
        public List<Employee> GetEmployeeList()
        {
            var result = (from employee in Helper.db.Employees where employee.Status == "Active" select employee).ToList();
            return result;
        }
        public List<PayrollGroup> GetPayrollGroups()
        {
            return (from pg in Helper.db.PayrollGroups select pg).ToList();
        }
        public void CreateNewEmployee()
        {
            if (!((from e in Helper.db.Employees where e.FirstName.ToLower() == Employee.FirstName.ToLower() && e.LastName.ToLower() == Employee.LastName.ToLower() select e).Count() > 0))
            {
                Helper.db.Employees.InsertOnSubmit(Employee);
                Employee.Status = "Active";
                Employees.Add(Employee);
                Helper.db.SubmitChanges();
                MessageBox.Show("Successfully created new employee");
            }
            else
            {
                MessageBox.Show("Employee already exists");
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
        #endregion
    }
}
