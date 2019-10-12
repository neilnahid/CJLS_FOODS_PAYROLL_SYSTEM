using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace CJLS_FOODS_PAYROLL_SYSTEM
{
    public static class Validations
    {
        public static void NumberValidation(object sender, TextCompositionEventArgs e)
        {
            int num;
            e.Handled = !int.TryParse(e.Text, out num);
        }
       
    }
}
