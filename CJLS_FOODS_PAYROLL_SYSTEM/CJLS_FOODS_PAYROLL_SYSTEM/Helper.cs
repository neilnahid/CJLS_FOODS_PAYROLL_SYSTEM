using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace CJLS_FOODS_PAYROLL_SYSTEM
{
    public static class Helper
    {
        public static DatabaseDataContext db = createDB();
        private static DatabaseDataContext createDB()
        {
            var db = new DatabaseDataContext();
            db.ObjectTrackingEnabled = true;
            return db;
        }

        public static User User { get; set; }
        public static TextBlock Title = null;



        //properties involving navigation
        public static Page PreviousPage { get; set; }
        private static PayrollDetail selectedPayrollDetail;
        public static PayrollDetail SelectedPayrollDetail {
            get {
                if (selectedPayrollDetail != null)
                    return (from p in Helper.db.PayrollDetails where p.PayrollDetailID == selectedPayrollDetail.PayrollDetailID select p).First();
                else
                    return null;
            }
            set { selectedPayrollDetail = value; }
        }
        private static Payroll selectedPayroll;
        public static Payroll SelectedPayroll {
            get {
                if (selectedPayroll != null)
                    return (from p in Helper.db.Payrolls where p.PayrollID == selectedPayroll.PayrollID select p).First();
                else
                    return null;
            }
            set { selectedPayroll = value; }
        }
    }
}