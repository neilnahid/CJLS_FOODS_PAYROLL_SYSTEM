using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;
namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    class PayrollDetailsViewModel : INotifyPropertyChanged
    {
        #region properties
        public Payroll Payroll { get; set; }
        public PayrollDetail PayrollDetail { get; set; }
        public ObservableCollection<PayrollDetail> PayrollDetails { get; set; }
        public double TotalGrossPay { get; set; }
        public double TotalDeductions { get; set; }
        public double TotalNetPay { get; set; }
        public double TotalContributions { get; set; }
        public event PropertyChangedEventHandler PropertyChanged;
        #endregion
        #region methods/functions
        public void InstantiatePayrollDetails()
        {
            Helper.db = new DatabaseDataContext();
            Payroll = Helper.SelectedPayroll;
            PayrollDetails = new ObservableCollection<PayrollDetail>(GetPayrollDetailList());
            try
            {
                Helper.db.Refresh(System.Data.Linq.RefreshMode.OverwriteCurrentValues, PayrollDetails);

            }
            catch(ArgumentException ex)
            {
                //catches if there's no payroll detail to refresh yet.
            }
            ComputeTotalPayrollSummary();
        }
        private List<PayrollDetail> GetPayrollDetailList()
        {
            return Payroll.PayrollDetails.ToList();
        }
        public void ComputeTotalPayrollSummary()
        {
            TotalGrossPay = 0;
            TotalContributions = 0;
            TotalNetPay = 0;
            TotalDeductions = 0;
            foreach (var pd in PayrollDetails)
            {
                TotalGrossPay += pd.GrossPay.HasValue?pd.GrossPay.Value:0;
                TotalNetPay += pd.NetPay.HasValue ? pd.NetPay.Value:0 ;
                TotalContributions += pd.TotalContributions.HasValue?pd.TotalContributions.Value:0;
                TotalDeductions += pd.TotalDeductions.HasValue?pd.TotalDeductions.Value:0;
            }
        }
        #endregion
    }
}
