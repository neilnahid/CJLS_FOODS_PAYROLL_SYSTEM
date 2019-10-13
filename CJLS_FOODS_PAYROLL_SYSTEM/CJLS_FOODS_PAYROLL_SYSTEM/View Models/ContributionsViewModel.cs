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
        public class YearlyContribution : INotifyPropertyChanged
        {
            public string Name { get; set; }
            public double RequiredYearlyContribution { get; set; }
            public double CurrentTotalPaid { get; set; }
            public double RunningBalance { get; set; }

            public event PropertyChangedEventHandler PropertyChanged;

        }
        public ObservableCollection<YearlyContribution> YearlyContributions { get { return GetYearlyContributions(); } }
        public ObservableCollection<YearlyContribution> GetYearlyContributions()
        {
            if(Employee != null)
            {

            ObservableCollection<YearlyContribution > yc = new ObservableCollection<YearlyContribution>();
            if(Employee.IsPagibigActive)
            yc.Add(new YearlyContribution { Name = "Pagibig", CurrentTotalPaid = TotalPagibig.Value, RequiredYearlyContribution = getAnnualPagibig(), RunningBalance = (getAnnualPagibig() - TotalPagibig.Value) });
            if(Employee.IsPhilhealthActive)
            yc.Add(new YearlyContribution { Name = "Philhealth", CurrentTotalPaid = TotalPhilHealth.Value, RequiredYearlyContribution = getAnnualPhilhealth(), RunningBalance = (getAnnualPhilhealth() - TotalPhilHealth.Value) });
            if(Employee.IsSSSActive)
            yc.Add(new YearlyContribution { Name = "SSS", CurrentTotalPaid = TotalSSS.Value, RequiredYearlyContribution = getAnnualSSS(), RunningBalance = (getAnnualSSS() - TotalSSS.Value) });
            return yc;
            }
            return null;
        }
        public ObservableCollection<Employee> Employees { get; set; }
        public ObservableCollection<Employee> FilteredEmployees { get; set; }
        //public double? TotalIncomeTax {
        //    get {
        //        if (Employee != null)
        //        {
        //            var total = Employee.PayrollDetails.Where(pd => pd.Payroll.StartDate.Year == DateTime.Now.Year).Sum(pd => pd.TaxTotal);
        //            return total.HasValue ? total : 0;
        //        }
        //        return 0;
        //    }
        //}
        private double? TotalPagibig
        {
            get
            {
                if (Employee != null)
                {
                    var total = Employee.PayrollDetails.Where(pd => pd.Payroll.StartDate.Year == DateTime.Now.Year).Sum(pd => pd.PagibigTotal);
                    return total.HasValue ? total : 0;
                }
                return 0;
            }
        }
        public double? TotalSSS
        {
            get
            {
                if (Employee != null)
                {
                    var total = Employee.PayrollDetails.Where(pd => pd.Payroll.StartDate.Year == DateTime.Now.Year).Sum(pd => pd.SSSTotal);
                    return total.HasValue ? total : 0;
                }
                return 0;
            }
        }
        public double? TotalPhilHealth
        {
            get
            {
                if (Employee != null)
                {
                    var total = Employee.PayrollDetails.Where(pd => pd.Payroll.StartDate.Year == DateTime.Now.Year).Sum(pd => pd.PhilhealthTotal);
                    return total.HasValue ? total : 0;
                }
                return 0;
            }
        }
        public double? TotalCurrentContributions
        {
            get
            {
                if (Employee != null)
                {
                    var total = TotalPhilHealth + TotalSSS + TotalPagibig;
                    return total.HasValue ? total : 0;
                }
                return 0;
            }
        }
        private double getAnnualSSS()
        {
            double msc = 0.0;
            if (Employee.MonthlySalary < 2250)
                msc = 2000;
            else if (Employee.MonthlySalary >= 19750)
                msc = 20000;
            else
                msc = Math.Round(Employee.MonthlySalary.Value / 500, 0) * 500;

            return Math.Round(msc * .04, 2) * 12;
        }
        private double getAnnualPagibig()
        {
            return (Employee.MonthlySalary.Value < 1500 ? 1500 * 0.01 : Employee.MonthlySalary.Value > 5000 ? 5000 * 0.02 : Employee.MonthlySalary.Value * 0.02) * 12;
        }
        private double getAnnualPhilhealth()
        {
            return ((Employee.MonthlySalary.Value < 10000 ? 10000 : Employee.MonthlySalary.Value > 40000 ? 40000 : Employee.MonthlySalary.Value) * .01375) * 12;
        }
        private double getAnnualTax()
        {
            double rate = 0;
            double clAmount = 0;
            double total = 0;
            if (Employee.MonthlySalary <= 20833)
                rate = 0;
            else if (Employee.MonthlySalary > 20833 && Employee.MonthlySalary < 33333)
            {
                rate = 0.2;
                clAmount = 20833;
            }
            else if (Employee.MonthlySalary >= 33333 && Employee.MonthlySalary < 66667)
            {
                total = 2500;
                rate = 0.25;
                clAmount = 33333;

            }
            else if (Employee.MonthlySalary > 66667 && Employee.MonthlySalary < 166667)
            {
                total = 10833.33;
                rate = 0.30;
                clAmount = 66667;

            }
            else if (Employee.MonthlySalary > 166667 && Employee.MonthlySalary < 666667)
            {
                total = 40833.33;
                rate = 0.32;
                clAmount = 166667;

            }
            else if (Employee.MonthlySalary >= 666667)
            {
                total = 200833.33;
                rate = 0.35;
                clAmount = 20833;

            }
            return ((Employee.MonthlySalary.Value - clAmount) * rate + total) * 12;
        }
        [PropertyChanged.AlsoNotifyFor("TotalPagibig", "TotalSSS", "TotalPhilHealth","YearlyContributions")]
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
