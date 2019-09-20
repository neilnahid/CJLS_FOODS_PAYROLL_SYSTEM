using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class HomeViewModel : INotifyPropertyChanged
    {
        public User User { get; set; }

        public void Instantiate()
        {
            User = Helper.User;
        }

        public event PropertyChangedEventHandler PropertyChanged;
    }
}
