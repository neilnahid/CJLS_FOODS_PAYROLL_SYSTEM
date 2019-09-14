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

        public void Instantiate()
        {
            Helper.db = new DatabaseDataContext();
            Loan = new Loan();
            GetLoans();
            GetEmployees();
        }
        public Loan Loan { get; set; }
        public ObservableCollection<Loan> Loans { get; set; }
        public List<Employee> Employees { get; set; }
        public void CreatNewLoan()
        {
            try
            {
                Helper.db.Loans.InsertOnSubmit(Loan);
                Loans.Add(Loan);
                Helper.db.SubmitChanges();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        public void UpdateLoan()
        {
            Helper.db.SubmitChanges();
        }
        private void GetLoans()
        {
            Loans = new ObservableCollection<Loan>((from l in Helper.db.Loans select l).ToList());
        }
        public void DeleteLoan(Loan loan)
        {
            Helper.db.Loans.DeleteOnSubmit(loan);
            Loans.Remove(loan);
            Loan = new Loan();
            Helper.db.SubmitChanges();
            MessageBox.Show("Successfully Deleted Loan!");
        }
        public void GetEmployees()
        {
            Employees = (from e in Helper.db.Employees where e.Status == "Active" select e).ToList();
        }
    }
}
