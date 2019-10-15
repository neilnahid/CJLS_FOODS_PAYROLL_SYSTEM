using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class GovernContributionRatesViewModel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        public ObservableCollection<ContributionType> ContributionTypes { get; set; }
        public ObservableCollection<TaxRate> TaxRates { get; set; }
        public void Instantiate()
        {
            Helper.db = new DatabaseDataContext();
            ContributionTypes = new ObservableCollection<ContributionType>((from ct in Helper.db.ContributionTypes select ct).ToList());
            TaxRates = new ObservableCollection<TaxRate>((from ct in Helper.db.TaxRates select ct).ToList());
        }
        public void Update()
        {
            Helper.db.SubmitChanges();
        }
    }
}
