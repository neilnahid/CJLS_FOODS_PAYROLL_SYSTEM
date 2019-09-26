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
        public ObservableCollection<Branch> FilteredBranches { get; set; }

        public int Page { get; set; }

        [PropertyChanged.DependsOn("Page")]
        public bool CanGoToNext { get { return (FilteredBranches != null && (FilteredBranches.Count) > ((Page + 1) * 10)) ? true : false; } set { } }
        [PropertyChanged.DependsOn("Page")]
        public bool CanGoToPrevious { get { return Page > 0 ? true : false; } }

        public string Search { get; set; }
        public void Instantiate()
        {
            Branch = new Branch();
            FilteredBranches = GetBranches();
            Branches = GetPagedBranches();
        }

        public ObservableCollection<Branch> GetBranches()
        {
            return new ObservableCollection<Branch>((from b in Helper.db.Branches select b).ToList());
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
        public ObservableCollection<Branch> GetPagedBranches()
        {
            return new ObservableCollection<Branch>(FilteredBranches.Skip(Page * 10).Take(10));
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
