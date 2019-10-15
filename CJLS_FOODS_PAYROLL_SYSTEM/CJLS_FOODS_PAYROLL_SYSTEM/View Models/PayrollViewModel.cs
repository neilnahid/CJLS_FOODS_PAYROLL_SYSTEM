﻿using System;
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
            Page = 0;
            Helper.db = new DatabaseDataContext();
            Payroll = new Payroll() { StartDate = DateTime.Now, EndDate = DateTime.Now };
            FilteredResult = FetchPayrollList();
            Payrolls = GetPagedResult();
            FetchPayrollGroups();
        }
        #endregion
        #region properties
        public Payroll Payroll { get; set; }
        public ObservableCollection<Payroll> Payrolls { get; set; }
        public event PropertyChangedEventHandler PropertyChanged;
        public List<PayrollGroup> PayrollGroups { get; set; }
        public ObservableCollection<Payroll> FilteredResult { get; set; }

        public int Page { get; set; }

        [PropertyChanged.DependsOn("Page")]
        public bool CanGoToNext { get { return (FilteredResult != null && (FilteredResult.Count) > ((Page + 1) * 5)) ? true : false; } }
        [PropertyChanged.DependsOn("Page")]
        public bool CanGoToPrevious { get { return Page > 0 ? true : false; } }
        public string Search { get; set; }
        #endregion


        #region methods/functions
        public ObservableCollection<Payroll> GetPagedResult()
        {
            return new ObservableCollection<Payroll>(FilteredResult.Skip(Page * 5).Take(5));
        }
        public ObservableCollection<Payroll> FetchPayrollList() {
            return new ObservableCollection<Payroll>(((from p in Helper.db.Payrolls select p).ToList().OrderByDescending(pr=>pr.DateCreated)));
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
        public void UpdatePayroll()
        {
            Helper.db.SubmitChanges();
            Page = 0;
            FilteredResult = GetPagedResult();
        }
        public void deletePayroll(Payroll payroll)
        {
            Helper.db.Payrolls.DeleteOnSubmit(payroll);
            Helper.db.SubmitChanges();
            Helper.db = new DatabaseDataContext();
            Page = 0;
            FilteredResult = FetchPayrollList();
            Payrolls = GetPagedResult();
        }
        #endregion
    }
}
