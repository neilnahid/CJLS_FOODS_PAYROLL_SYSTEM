using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Collections.ObjectModel;
using System.Windows;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class EmployeeTypeViewModel: INotifyPropertyChanged
    {
        public ObservableCollection<EmployeeType> EmployeeTypes { get; set; }
        public EmployeeType EmployeeType { get; set; }
        public event PropertyChangedEventHandler PropertyChanged;
        public void Instantiate()
        {
            Helper.db = new DatabaseDataContext();
            EmployeeType = new EmployeeType();
            EmployeeTypes = new ObservableCollection<EmployeeType>();
            EmployeeTypes = FetchEmployeeTypes();
        }
        public ObservableCollection<EmployeeType> FetchEmployeeTypes()
        {
            return new ObservableCollection<EmployeeType>((from et in Helper.db.EmployeeTypes select et).ToList());
        }
        public void CreateNewEmployeeType()
        {
            try
            {
                Helper.db.EmployeeTypes.InsertOnSubmit(EmployeeType);
                Helper.db.SubmitChanges();
                EmployeeType = new EmployeeType();
            } catch (InvalidOperationException ex)
            {
                MessageBox.Show("Employee Type Already Exist");
            }
           
        }
        public void UpdateEmployeeType()
        {
            Helper.db.SubmitChanges();
        }
        public void DeleteEmployeeType(EmployeeType emp)
        {
            Helper.db.EmployeeTypes.DeleteOnSubmit(emp);
            EmployeeTypes.Remove(emp);
            EmployeeType = new EmployeeType();
            Helper.db.SubmitChanges();
            MessageBox.Show("Successfully Deleted Job Position!");
        }
    }
}
