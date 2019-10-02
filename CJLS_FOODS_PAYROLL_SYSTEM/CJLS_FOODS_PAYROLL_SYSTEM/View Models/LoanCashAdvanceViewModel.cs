using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class LoanCashAdvanceViewModel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        public ObservableCollection<Loan> FilteredResult { get; set; }

        public int Page { get; set; }

        [PropertyChanged.DependsOn("Page")]
        public bool CanGoToNext { get { return (FilteredResult != null && (FilteredResult.Count) > ((Page + 1) * 10)) ? true : false; } }
        [PropertyChanged.DependsOn("Page")]
        public bool CanGoToPrevious { get { return Page > 0 ? true : false; } }
        public string Search { get; set; }


        public Loan Loan { get; set; }
        public ObservableCollection<Loan> Loans { get; set; }
        public List<Employee> Employees { get; set; }
        public void Instantiate()
        {
            Page = 0;
            Helper.db = new DatabaseDataContext();
            Loan = new Loan();
            FilteredResult = GetLoans();
            Loans = GetPagedResult();
            GetEmployees();
        }
        public ObservableCollection<Loan> GetPagedResult()
        {
            return new ObservableCollection<Loan>(FilteredResult.Skip(Page * 10).Take(10));
        }
        public void CreatNewLoan()
        {
            try
            {
                Page = 0;
                Helper.db.Loans.InsertOnSubmit(Loan);
                Loans.Add(Loan);
                Helper.db.SubmitChanges();
                FilteredResult = GetLoans();
                Loans = GetPagedResult();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        public void UpdateLoan()
        {
            Page = 0;
            Helper.db.SubmitChanges();
            FilteredResult = GetLoans();
        }
        public ObservableCollection<Loan> GetLoans()
        {
            return new ObservableCollection<Loan>((from l in Helper.db.Loans select l).ToList());
        }
        public void DeleteLoan(Loan loan)
        {
            Helper.db.Loans.DeleteOnSubmit(loan);
            Helper.db.SubmitChanges();
            MessageBox.Show("Successfully Deleted Loan!");
            Instantiate();
        }
        public void GetEmployees()
        {
            Employees = (from e in Helper.db.Employees where e.Status == "Active" select e).ToList();
        }
    }
}
