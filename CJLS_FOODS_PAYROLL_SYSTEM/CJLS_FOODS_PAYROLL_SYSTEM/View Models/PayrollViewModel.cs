using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models {
    public class PayrollViewModel : INotifyPropertyChanged {
        #region Constructors
        public void Instantiate()
        {
            Payroll = new Payroll() { StartDate = DateTime.Now, EndDate = DateTime.Now };
            Payrolls = FetchPayrollList();
            FetchPayrollGroups();
        }
        #endregion
        #region properties
        public Payroll Payroll { get; set; }
        public ObservableCollection<Payroll> Payrolls { get; set; }
        public event PropertyChangedEventHandler PropertyChanged;
        public List<PayrollGroup> PayrollGroups { get; set; }
        #endregion


        #region methods/functions
        public ObservableCollection<Payroll> FetchPayrollList() {
            return new ObservableCollection<Payroll>(((from p in Helper.db.Payrolls select p).ToList()));
        }
        public void FetchPayrollGroups() {
            PayrollGroups = (from pg in Helper.db.PayrollGroups select pg).ToList();
        }

        public void CreateEmployeePayrollDetails()
        {
            var employees = (from e in Helper.db.Employees where e.PayrollGroup == Payroll.PayrollGroup && (e.Status != "Terminated" || e.Status != "Inactive") select e);
            foreach (var emp in employees)
            {
                var newPD = new PayrollDetail { Employee = emp };
                insertContributions(newPD);
                insertLoanPayments(newPD);
                this.Payroll.PayrollDetails.Add(newPD);
            }
        }
        private void insertLoanPayments(PayrollDetail pd)
        {
            //inserts loan payments for the specified pd based on active loans of employee
            (from l in Helper.db.Loans where l.Employee == pd.Employee && l.IsPaid == false select l).ToList().ForEach(loan =>
            {
                pd.LoanPayments.Add(new LoanPayment { Loan = loan });
            });
        }
        private void insertContributions(PayrollDetail pd)
        {
            if (pd.Employee.IsPhilhealthActive)
                pd.Contributions.Add(new Contribution { ContributionTypeID = 1, PayrollDetailID = pd.PayrollDetailID });
            if (pd.Employee.IsSSSActive)
                pd.Contributions.Add(new Contribution { ContributionTypeID = 2, PayrollDetailID = pd.PayrollDetailID });
            if (pd.Employee.IsPagibigActive)
                pd.Contributions.Add(new Contribution { ContributionTypeID = 3, PayrollDetailID = pd.PayrollDetailID });
            if (pd.Employee.IsIncomeTaxActive)
                pd.Contributions.Add(new Contribution { ContributionTypeID = 4, PayrollDetailID = pd.PayrollDetailID });
        }
        #endregion
    }
}
