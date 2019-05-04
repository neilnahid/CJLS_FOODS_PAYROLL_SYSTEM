using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class EmployeeViewModel : Model.ModelPropertyChange
    {
        private ObservableCollection<Employee> employees;

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

        public Employee Employee { get; set; }
        public EmployeeViewModel()
        {
            Employees = new ObservableCollection<Employee>(GetEmployeeList());
        }
        public List<Employee> GetEmployeeList()
        {
            return (from employee in DatabaseHelper.db.Employees select employee).ToList();
        }
    }
}
