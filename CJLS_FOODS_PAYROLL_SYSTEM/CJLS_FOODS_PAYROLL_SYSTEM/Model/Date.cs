using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Model {
    public class Date : Model.ModelPropertyChange {
        private List<DateTime> weeks;

        public DateTime Weeks {
            get { return weeks; }
            set { weeks = value; }
        }
    }
}
