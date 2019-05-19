using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models {
    class PayrollDetails : Model.ModelPropertyChange{
        public PayrollDetails() {
        }
        private Payroll payroll;

        public Payroll Payroll {
            get { return payroll; }
            set {
                if (payroll != value) {
                    payroll = value;
                    RaisePropertyChanged("Payroll");
                }
            }
        }
        public Payroll GetPayroll(int PayrollID) {
            return (from p in Helper.db.Payrolls where p.PayrollID == PayrollID select p).First();
        }
    }
}
