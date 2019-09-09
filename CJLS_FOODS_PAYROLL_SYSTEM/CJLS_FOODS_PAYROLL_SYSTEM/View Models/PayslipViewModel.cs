using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Documents;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class PayslipViewModel : INotifyPropertyChanged
    {
        public class PayrollDeductions : INotifyPropertyChanged
        {
            public event PropertyChangedEventHandler PropertyChanged;
            public string Name { get; set; }
            public double Amount { get; set; }

        }
        
        public PayrollDetail PayrollDetail { get; set; }
        public List<PayrollDeductions> PayDeductions { get; set; }

        public void Instantiate(PayrollDetail pd)
        {
            PayrollDetail = pd;
            getPayrollDeductions();
        }
        public void getPayrollDeductions()
        {
            PayDeductions = new List<PayrollDeductions>();
            //get daytodaydeductions
            PayDeductions.AddRange(getDayToDayDeductions());
            //get CA/loans deductions
            PayDeductions.AddRange(getCALoansDeductions());
            //get contributions deductions
            PayDeductions.AddRange(getContributionDeductions());
            PayDeductions.Add(new PayrollDeductions { Name = "Total Deductions", Amount = PayDeductions.Sum(pd => pd.Amount) });
        }



        /**
         * 
         * 1. retrieves all deductions from each attendance in payroll detail
         * 2. orders all the retrieved deductions by groups according to their name
         * 3. return the payrolldeductions list
         */
        private List<PayrollDeductions> getDayToDayDeductions()
        {

            List<PayrollDeductions> pd = new List<PayrollDeductions>();
            foreach (var attendance in PayrollDetail.Attendances)
            {
                foreach (var deduction in attendance.Deductions)
                {
                    pd.Add(new PayrollDeductions
                    {
                        Name = deduction.DeductionsType.Name,
                        Amount = deduction.Amount
                    });
                }
            }
            pd = (from _pd in pd group _pd by _pd.Name into g select new PayrollDeductions { Name = g.Key, Amount = g.Sum(x => x.Amount) }).ToList();
            return pd;
        }
        private List<PayrollDeductions> getCALoansDeductions()
        {
            var pd = new List<PayrollDeductions>();
            foreach (var loanPayment in PayrollDetail.LoanPayments)
            {
                pd.Add(new PayrollDeductions
                {
                    Name = loanPayment.Loan.LoanType,
                    Amount = loanPayment.AmountPaid.Value
                });
            }
            return pd;
        }
        private List<PayrollDeductions> getContributionDeductions()
        {
            var pd = new List<PayrollDeductions>();
            foreach (var contribution in PayrollDetail.Contributions)
            {
                pd.Add(new PayrollDeductions
                {
                    Name = contribution.ContributionType.Name,
                    Amount = contribution.Amount.Value
                });
            }
            return pd;
        }
        public void PrintPaySlip(FlowDocument fd)
        {
            var pd = new PrintDialog();
            if (pd.ShowDialog().Value)
            {
                IDocumentPaginatorSource idocument = fd as IDocumentPaginatorSource;
                try
                {
                    pd.PrintDocument(idocument.DocumentPaginator, "Printing FlowDocument");
                }
                catch (System.Runtime.CompilerServices.RuntimeWrappedException)
                {
                }
            }
        }
        public event PropertyChangedEventHandler PropertyChanged;
    }
}
