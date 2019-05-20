using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Model {
    public class Month: ModelPropertyChange { 
        private List<Week> weeks;

    public List<Week> Weeks {
        get { return weeks; }
        set {
                if (weeks != value) {
                    weeks = value;
                    RaisePropertyChanged("Weeks");
                }
            }
    }

}
}
