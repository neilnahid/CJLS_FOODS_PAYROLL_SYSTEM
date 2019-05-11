using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class EmployeeViewModel : Model.ModelPropertyChange
    {
        private ObservableCollection<Employee> employees;
        private List<EmployeeType> employeeTypes;

        public List<EmployeeType> EmployeeTypes {
            get { return employeeTypes; }
            set {
                if (employeeTypes != value) {
                    employeeTypes = value;
                    RaisePropertyChanged("EmployeeTypes");
                }
            }
        }

        public ObservableCollection<Employee> Employees {
            get { return employees; }
            set {
                if (employees != value)
                {
                    employees = value;
                    RaisePropertyChanged("Employees");
                }
            }
        }
        private Employee employee;

        public Employee Employee {
            get { return employee; }
            set {
                if (employee != value) {
                    employee = value;
                    RaisePropertyChanged("Employee");
                }
            }
        }

        public EmployeeViewModel()
        {
            Employees = new ObservableCollection<Employee>(GetEmployeeList());
            Employee = new Employee();
            EmployeeTypes = GetEmployeeTypes();
        }   
        public List<Employee> GetEmployeeList()
        {
            var result = (from employee in Helper.db.Employees select employee).ToList();
            return result;
        }
        public void CreateNewEmployee()
        {
            Helper.db.Employees.InsertOnSubmit(Employee);
            Employees.Add(Employee);
            Helper.db.SubmitChanges();
            MessageBox.Show("Successfully created new employee");
        }
        public List<EmployeeType> GetEmployeeTypes() {
            return (from et in Helper.db.EmployeeTypes select et).ToList();
        }
        public void DeleteEmployee(Employee employee) {
            var result = (from emp in Helper.db.Employees where emp.EmployeeID == employee.EmployeeID select emp).FirstOrDefault();
            Helper.db.Employees.DeleteOnSubmit(result);
            Helper.db.SubmitChanges();
            Employees.Remove(Employee);
            Employee = new Employee();
            MessageBox.Show("Successfully deleted Employee");
        }
    }
}
