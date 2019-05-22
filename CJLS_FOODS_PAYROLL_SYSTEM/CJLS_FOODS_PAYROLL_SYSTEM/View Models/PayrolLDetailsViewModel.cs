using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models {
    class PayrollDetailsViewModel : Model.ModelPropertyChange{
        public PayrollDetailsViewModel() {
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
        private PayrollDetail payrollDetail;

        public PayrollDetail PayrollDetail {
            get { return payrollDetail; }
            set {
                if (payrollDetail != value) {
                    payrollDetail = value;
                    RaisePropertyChanged("PayrollDetail");
                }
            }
        }
        private ObservableCollection<PayrollDetail> payrollDetails;

        public ObservableCollection<PayrollDetail> PayrollDetails {
            get { return payrollDetails; }
            set {
                if (payrollDetails != value) {
                    payrollDetails = value;
                    RaisePropertyChanged("PayrollDetails");
                }
            }
        }

        public void InstantiatePayrollDetails() {
            var employees = (from e in Helper.db.Employees select e);
            foreach(var employee in employees) {
                this.Payroll.PayrollDetails.Add(new PayrollDetail { Employee = employee, EmployeeID = employee.EmployeeID });
            }
            PayrollDetails = new ObservableCollection<PayrollDetail>(Payroll.PayrollDetails);
        }
    }
}
