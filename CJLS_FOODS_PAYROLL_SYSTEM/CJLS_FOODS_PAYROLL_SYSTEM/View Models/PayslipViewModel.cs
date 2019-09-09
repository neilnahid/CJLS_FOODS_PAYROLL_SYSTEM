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
        public class PayrollDeduction : INotifyPropertyChanged
        {
            public event PropertyChangedEventHandler PropertyChanged;
            public string Name { get; set; }
            public double Amount { get; set; }

        }
        public class Payslip
        {
            public PayrollDetail PayrollDetail { get; set; }
            public List<PayrollDeduction> PayrollDeductions{ get; set; }
        }
        public List<Payslip> Payslips { get; set; }
        public void Instantiate(List<PayrollDetail> payrollDetails)
        {
            Payslips = new List<Payslip>();
            foreach(var pd in payrollDetails)
            {
                Payslips.Add(new Payslip { PayrollDetail = pd, PayrollDeductions = getPayrollDeductions(pd) });
            }
        }
        public List<PayrollDeduction> getPayrollDeductions(PayrollDetail payrollDetail)
        {
            var PayDeductions = new List<PayrollDeduction>();
            //get daytodaydeductions
            PayDeductions.AddRange(getDayToDayDeductions(payrollDetail));
            //get CA/loans deductions
            PayDeductions.AddRange(getCALoansDeductions(payrollDetail));
            //get contributions deductions
            PayDeductions.AddRange(getContributionDeductions(payrollDetail));
            PayDeductions.Add(new PayrollDeduction { Name = "Total Deductions", Amount = PayDeductions.Sum(pd => pd.Amount) });
            return PayDeductions;
        }



        /**
         * 
         * 1. retrieves all deductions from each attendance in payroll detail
         * 2. orders all the retrieved deductions by groups according to their name
         * 3. return the payrolldeductions list
         */
        private List<PayrollDeduction> getDayToDayDeductions(PayrollDetail payrollDetail)
        {

            List<PayrollDeduction> pd = new List<PayrollDeduction>();
            foreach (var attendance in payrollDetail.Attendances)
            {
                foreach (var deduction in attendance.Deductions)
                {
                    pd.Add(new PayrollDeduction
                    {
                        Name = deduction.DeductionsType.Name,
                        Amount = deduction.Amount
                    });
                }
            }
            pd = (from _pd in pd group _pd by _pd.Name into g select new PayrollDeduction { Name = g.Key, Amount = g.Sum(x => x.Amount) }).ToList();
            return pd;
        }
        private List<PayrollDeduction> getCALoansDeductions(PayrollDetail payrollDetail)
        {
            var pd = new List<PayrollDeduction>();
            foreach (var loanPayment in payrollDetail.LoanPayments)
            {
                pd.Add(new PayrollDeduction
                {
                    Name = loanPayment.Loan.LoanType,
                    Amount = loanPayment.AmountPaid.Value
                });
            }
            return pd;
        }
        private List<PayrollDeduction> getContributionDeductions(PayrollDetail payrollDetail)
        {
            var pd = new List<PayrollDeduction>();
            foreach (var contribution in payrollDetail.Contributions)
            {
                pd.Add(new PayrollDeduction
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
