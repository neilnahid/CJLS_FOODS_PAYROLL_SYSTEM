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
            PayrollDetails = new ObservableCollection<PayrollDetail>(GetPayrollDetailList());
            foreach(PayrollDetail p in PayrollDetails) {
                ComputePayrollDetails(p);
            }
        }
        private List<PayrollDetail> GetPayrollDetailList() {
            if (Payroll.PayrollDetails.Count == 0) {
                var employees = (from e in Helper.db.Employees select e);
                foreach (var employee in employees) {
                    this.Payroll.PayrollDetails.Add(new PayrollDetail { Employee = employee, EmployeeID = employee.EmployeeID });
                }
            }
            return Payroll.PayrollDetails.ToList();
        }
        private void ComputeTotalDeductionsOf(PayrollDetail pd) {
            foreach(var a in pd.Attendances) {
                pd.TotalDeductions += (from d in a.Deductions select d.Amount).Sum();
            }
        }
        private void ComputeTotalRegularHours(PayrollDetail pd) {
            pd.TotalRegularHours = (from a in pd.Attendances select a.RegularHoursWorked).Sum();
        }
        private void ComputeTotalOverTimeHours(PayrollDetail pd) {
            pd.TotalOverTimeHours = (from a in pd.Attendances select a.OverTimeHoursWorked).Sum();
        }
        private void ComputePayrollDetails(PayrollDetail pd) {
                ComputeTotalDeductionsOf(pd);
                ComputeTotalOverTimeHours(pd);
                ComputeTotalRegularHours(pd);
                ComputeGrossPayOf(pd);
                ComputeNetPayOf(pd);
                pd.OvertimePay = ComputeOverTimePayOf(pd);
                Helper.db.SubmitChanges();
        }
        private void ComputeGrossPayOf(PayrollDetail pd) {
            pd.GrossPay = (pd.TotalRegularHours * (double)pd.Employee.HourlyRate) + ComputeOverTimePayOf(pd);
        }
        private void ComputeNetPayOf(PayrollDetail pd) {
            pd.NetPay = pd.GrossPay - pd.TotalDeductions;
        }
        private double ComputeOverTimePayOf(PayrollDetail pd) {
                pd.OvertimePay = (double)pd.Employee.HourlyRate * StaticValues.OVERTIME_RATE * pd.TotalOverTimeHours;
                return (double)pd.OvertimePay;
        }
    }
}
