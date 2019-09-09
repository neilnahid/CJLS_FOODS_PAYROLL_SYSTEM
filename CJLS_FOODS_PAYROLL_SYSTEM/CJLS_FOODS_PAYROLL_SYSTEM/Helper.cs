using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace CJLS_FOODS_PAYROLL_SYSTEM {
    public static class Helper {
        public static DatabaseDataContext db = createDB();
        private static DatabaseDataContext createDB()
        {
            var db = new DatabaseDataContext();
            db.ObjectTrackingEnabled = true;
            return db;
        }

        public static User User;
        public static TextBlock Title = null;
    }
}
