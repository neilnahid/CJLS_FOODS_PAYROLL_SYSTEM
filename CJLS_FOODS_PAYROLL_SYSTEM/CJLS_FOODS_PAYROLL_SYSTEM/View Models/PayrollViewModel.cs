using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models {
    public class PayrollViewModel : Model.ModelPropertyChange {
        private ObservableCollection<Payroll> payrolls;
        private Payroll payroll;

        public ObservableCollection<Payroll> Payrolls {
            get { return payrolls; }
            set {
                if (payrolls != value) {
                    payrolls = value;
                    RaisePropertyChanged("Payrolls");
                }
            }
        }

        public Payroll Payroll {
            get { return payroll; }
            set {
                if (payroll != value) {
                    payroll = value;
                    RaisePropertyChanged("Payroll");
                }
            }
        }
        public List<Payroll> GetPayrollList() {
            return (from p in Helper.db.Payrolls select p).ToList();
        }
    }
}
