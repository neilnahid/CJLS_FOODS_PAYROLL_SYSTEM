using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models {
    public class EmployeeGroupViewModel : INotifyPropertyChanged {
        #region properties
        public event PropertyChangedEventHandler PropertyChanged;
        public EmployeeGroup EmployeeGroup { get; set; }
        public ObservableCollection<EmployeeGroup> EmployeeGroups { get; set; }
        #endregion
        public EmployeeGroupViewModel() {
            EmployeeGroup = new EmployeeGroup();
            EmployeeGroups = new ObservableCollection<EmployeeGroup>();
        }
     
        public void CreateNewEmployeeGroup() {
            Helper.db.EmployeeGroups.InsertOnSubmit(EmployeeGroup);
            EmployeeGroups.Add(EmployeeGroup);
            Helper.db.SubmitChanges();
        }
        public void UpdateEmployeeGroup() {
            Helper.db.SubmitChanges();
        }
        private void GetEmployeeGroups() {
            EmployeeGroups = new ObservableCollection<EmployeeGroup>((from eg in Helper.db.EmployeeGroups select eg).ToList());
        }
        public void DeleteEmployeeGroup(EmployeeGroup employeeGroup) {
            Helper.db.EmployeeGroups.DeleteOnSubmit(employeeGroup);
            EmployeeGroups.Remove(employeeGroup);
            EmployeeGroup = new EmployeeGroup();
            Helper.db.SubmitChanges();
            MessageBox.Show("Successfully Deleted Employee Group!");
        }
    }
}
