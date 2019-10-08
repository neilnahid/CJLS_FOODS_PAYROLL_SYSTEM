using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM
{
    public partial class PayrollDetail : INotifyPropertyChanged
    {
        public double? SSSTotal { get { return (from c in Contributions where c.ContributionType.Name == "SSS" select c.Amount).FirstOrDefault(); } }
        public double? PhilhealthTotal { get { return (from c in Contributions where c.ContributionType.Name == "PhilHealth" select c.Amount).FirstOrDefault(); } }
        public double? PagibigTotal { get { return (from c in Contributions where c.ContributionType.Name == "Pagibig" select c.Amount).FirstOrDefault(); } }
        public double? TaxTotal { get { return (from c in Contributions where c.ContributionType.Name == "Tax" select c.Amount).FirstOrDefault(); } }
    }
}
