using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class LeaveViewModel : Paginator<Leave>, INotifyPropertyChanged
    {
        public void Instantiate()
        {
            Helper.db = new DatabaseDataContext();
            Leave = new Leave();
            Leaves = new ObservableCollection<Leave>();
            Employees = new List<Employee>();
            Leaves = GetLeaves();
            GetEmployees();
            PageCount = 10;
        }
        public Leave Leave { get; set; }

        public ObservableCollection<Leave> Leaves { get; set; }
        public List<Employee> Employees { get; set; }
        public Employee Employee { get; set; }

        public event PropertyChangedEventHandler PropertyChanged;

        public void CreateNewLeave()
        {
            try
            {
                Helper.db.Leaves.InsertOnSubmit(Leave);
                Leaves.Add(Leave);
                Helper.db.SubmitChanges();
                Helper.db = new DatabaseDataContext();
                Leaves = GetLeaves();
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        public void UpdateLeave()
        {
            Helper.db.SubmitChanges();
        }
        private ObservableCollection<Leave> GetLeaves()
        {
           var leaves = new ObservableCollection<Leave>((from l in Helper.db.Leaves select l).ToList());
            assignCollection(leaves);
            return leaves;
        }
        public void DeleteLeave(Leave Leave)
        {
            Helper.db.Leaves.DeleteOnSubmit(Leave);
            Leaves.Remove(Leave);
            Leave = new Leave();
            Helper.db.SubmitChanges();
            MessageBox.Show("Successfully Deleted Employee Group!");
        }

        public void GetEmployees()
        {
            Employees = (from e in Helper.db.Employees select e).ToList();
        }
    }
}
