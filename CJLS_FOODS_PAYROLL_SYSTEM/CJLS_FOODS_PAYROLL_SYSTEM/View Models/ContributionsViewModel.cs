using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class ContributionsViewModel : INotifyPropertyChanged
    {

        public ObservableCollection<Employee> Employees { get; set; }
        public ObservableCollection<Employee> FilteredEmployees { get; set; }
        public double? TotalIncomeTax {
            get {
                if (Employee != null)
                {
                    var total = Employee.PayrollDetails.Where(pd=>pd.Payroll.StartDate.Year == DateTime.Now.Year).Sum(pd => pd.TaxTotal);
                    return total.HasValue ? total : 0;
                }
                return 0;
            }
        }

        public double? TotalPagibig {
            get {
                if (Employee != null)
                {
                    var total = Employee.PayrollDetails.Where(pd => pd.Payroll.StartDate.Year == DateTime.Now.Year).Sum(pd => pd.PagibigTotal);
                    return total.HasValue ? total : 0;
                }
                return 0;
            }
        }
        public double? TotalSSS {
            get {
                if (Employee != null)
                {
                    var total = Employee.PayrollDetails.Where(pd => pd.Payroll.StartDate.Year == DateTime.Now.Year).Sum(pd => pd.SSSTotal);
                    return total.HasValue ? total : 0;
                }
                return 0;
            }
        }
        public double? TotalPhilHealth {
            get {
                if (Employee != null)
                {
                    var total = Employee.PayrollDetails.Where(pd => pd.Payroll.StartDate.Year == DateTime.Now.Year).Sum(pd => pd.PhilhealthTotal);
                    return total.HasValue ? total : 0;
                }
                return 0;
            }
        }
        [PropertyChanged.AlsoNotifyFor("TotalIncomeTax", "TotalPagibig", "TotalSSS", "TotalPhilHealth")]
        public Employee Employee { get; set; }
        public event PropertyChangedEventHandler PropertyChanged;
        public int Page { get; set; }

        [PropertyChanged.DependsOn("Page")]
        public bool CanGoToNext { get { return (FilteredEmployees != null && (FilteredEmployees.Count) > ((Page + 1) * 10)) ? true : false; } set { } }
        [PropertyChanged.DependsOn("Page")]
        public bool CanGoToPrevious { get { return Page > 0 ? true : false; } }
        public string Search { get; set; }
        public void Instantiate()
        {
            Employees = GetEmployees();

        }
        public void GotoPrevious()
        {
            Page--;
            Employees = GetPagedCollection();
        }
        public void GotoNext()
        {
            Page++;
            Employees = GetPagedCollection();
        }
        public ObservableCollection<Employee> GetPagedCollection()
        {
            return new ObservableCollection<Employee>(FilteredEmployees.Skip(Page * 10).Take(10));
        }
        public ObservableCollection<Employee> GetEmployees()
        {
            return new ObservableCollection<Employee>((from e in Helper.db.Employees select e).ToList());
        }
    }
}
