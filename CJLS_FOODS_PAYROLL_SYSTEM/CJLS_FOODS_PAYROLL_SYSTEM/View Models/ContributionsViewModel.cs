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
