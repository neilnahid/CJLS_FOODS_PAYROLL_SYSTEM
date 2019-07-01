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
        public PayrollViewModel() {
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
        #endregion
    }
}
