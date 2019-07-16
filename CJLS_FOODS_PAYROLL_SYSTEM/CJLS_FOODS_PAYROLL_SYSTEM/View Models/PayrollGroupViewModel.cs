using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models {
    public class PayrollGroupViewModel : INotifyPropertyChanged {
        #region properties
        public event PropertyChangedEventHandler PropertyChanged;
        public PayrollGroup PayrollGroup { get; set; }
        public ObservableCollection<PayrollGroup> PayrollGroups { get; set; }
        #endregion
        public PayrollGroupViewModel() {
            PayrollGroup = new PayrollGroup();
            PayrollGroups = new ObservableCollection<PayrollGroup>();
            GetPayrollGroups();
        }
     
        public void CreateNewPayrollGroup() {
            try {
                Helper.db.PayrollGroups.InsertOnSubmit(PayrollGroup);
                PayrollGroups.Add(PayrollGroup);
                Helper.db.SubmitChanges();
            }
            catch(InvalidOperationException ex) {
                MessageBox.Show("Payroll Group already exist");
            }
        }
        public void UpdatePayrollGroup() {
            Helper.db.SubmitChanges();
        }
        private void GetPayrollGroups() {
            PayrollGroups = new ObservableCollection<PayrollGroup>((from eg in Helper.db.PayrollGroups select eg).ToList());
        }
        public void DeletePayrollGroup(PayrollGroup PayrollGroup) {
            Helper.db.PayrollGroups.DeleteOnSubmit(PayrollGroup);
            PayrollGroups.Remove(PayrollGroup);
            PayrollGroup = new PayrollGroup();
            Helper.db.SubmitChanges();
            MessageBox.Show("Successfully Deleted Employee Group!");
        }
    }
}
