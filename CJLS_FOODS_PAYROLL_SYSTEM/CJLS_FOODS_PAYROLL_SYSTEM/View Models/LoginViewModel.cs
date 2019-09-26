using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class LoginViewModel : INotifyPropertyChanged
    {

        public event PropertyChangedEventHandler PropertyChanged;

        public string Username { get; set; }
        public string Password { get; set; }

        public bool CheckLogin()
        {
            var user = (from u in Helper.db.Users where u.Username == Username && u.Password == Password select u).FirstOrDefault();
            if (user != null)
            {
                Helper.User = user;
                return true;
            }
            else
            {
                MessageBox.Show("Invalid Credentials, please try again.");
                return false;
            }
        }
    }
}
