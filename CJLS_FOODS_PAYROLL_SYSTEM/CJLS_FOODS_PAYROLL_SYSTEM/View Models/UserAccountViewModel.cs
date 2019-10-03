using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class UserAccountViewModel : INotifyPropertyChanged
    {
        public User User { get; set; }

        public event PropertyChangedEventHandler PropertyChanged;

        public void Instantiate()
        {
            Helper.db = new DatabaseDataContext();
            Helper.User = (from u in Helper.db.Users where Helper.User.UserId == u.UserId select u).First();
            User = Helper.User;
        }

        public void UpdateUser()
        {
            Helper.db.SubmitChanges();
            Helper.db = new DatabaseDataContext();
            User = (from u in Helper.db.Users where u.UserId == Helper.User.UserId select u).First();
            Helper.User = User;
            MessageBox.Show("Successfully updated user account.");
        }

    }
}
