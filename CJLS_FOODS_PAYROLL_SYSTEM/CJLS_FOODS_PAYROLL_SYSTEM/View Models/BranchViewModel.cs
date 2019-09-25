using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class BranchViewModel : INotifyPropertyChanged
    {
        public Branch Branch { get; set; }
        public ObservableCollection<Branch> Branches { get; set; }

        public void Instantiate()
        {
            Branch = new Branch();
            Branches = GetBranches();
        }

        public ObservableCollection<Branch> GetBranches()
        {
            return new ObservableCollection<Branch>((from b in Helper.db.Branches where b.IsActive select b).ToList());
        }
        public string AddBranch(Branch branch)
        {
            Helper.db.Branches.InsertOnSubmit(branch);
            try
            {
                Helper.db.SubmitChanges();
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            return null;
        }
        public void UpdateBranch(Branch branch)
        {
            Helper.db.SubmitChanges();
        }
        public void SetBranchInactive(Branch branch)
        {
            Helper.db.SubmitChanges();
        }
        public void DeleteBranch(Branch branch)
        {
            Helper.db.Branches.DeleteOnSubmit(branch);
            Helper.db.SubmitChanges();
        }
        public event PropertyChangedEventHandler PropertyChanged;
    }
}
