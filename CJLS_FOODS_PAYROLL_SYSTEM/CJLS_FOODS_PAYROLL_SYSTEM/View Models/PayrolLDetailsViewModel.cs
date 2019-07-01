using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;
namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models {
    class PayrollDetailsViewModel : INotifyPropertyChanged {
        #region properties
        public PayrollDetailsViewModel() {
        }
        public Payroll Payroll { get; set; }
        public PayrollDetail PayrollDetail { get; set; }
        public ObservableCollection<PayrollDetail> PayrollDetails { get; set; }
        public double TotalGrossPay { get; set; }
        public double TotalDeductions { get; set; }
        public double TotalNetPay { get; set; }
        public double TotalContributions { get; set; }
        public event PropertyChangedEventHandler PropertyChanged;
        #endregion
        #region methods/functions
        public void InstantiatePayrollDetails() {
            PayrollDetails = new ObservableCollection<PayrollDetail>(GetPayrollDetailList());
            foreach (PayrollDetail p in PayrollDetails) {
                ComputePayrollDetails(p);
            }
            ComputeTotalPayrollSummary();
        }
        private List<PayrollDetail> GetPayrollDetailList() {
            if (Payroll.PayrollDetails.Count == 0) {
                var employees = (from e in Helper.db.Employees where e.PayrollGroup == Payroll.PayrollGroup && (e.Status != "Terminated" || e.Status != "Inactive") select e );
                foreach (var employee in employees) {
                    this.Payroll.PayrollDetails.Add(new PayrollDetail { Employee = employee, EmployeeID = employee.EmployeeID });
                }
            }
            return Payroll.PayrollDetails.ToList();
        }
        private void ComputeTotalDeductionsOf(PayrollDetail pd) {
            pd.TotalDeductions = 0;
            foreach (var a in pd.Attendances) {
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
        public void ComputeTotalPayrollSummary() {
            TotalGrossPay = 0;
            TotalContributions = 0;
            TotalNetPay = 0;
            TotalDeductions = 0;
            foreach (var pd in PayrollDetails) {
                TotalGrossPay += pd.GrossPay;
                TotalNetPay += pd.NetPay;
                TotalContributions += pd.TotalContributions;
                TotalDeductions += pd.TotalDeductions;
            }
        }
        #endregion
    }
}
