using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class ForgotPasswordViewModel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        public User User { get; set; }
        public string Username { get; set; }
        public string SecretAnswer { get; set; }
        public void Instantiate(string Username)
        {
            User = (from u in Helper.db.Users where u.Username == Username select u).First();
        }

        public User searchUser()
        {
            return (from u in Helper.db.Users where u.Username == Username select u).FirstOrDefault();
        }
        public bool IsAnswerCorrect()
        {
            return SecretAnswer == User.SecretAnswer ? true : false;
        }
        public void ResetUserDefaultPassword()
        {
            //default password is admin
            User.Password = "cjlsfoods";
            Helper.db.SubmitChanges();
        }
    }
}
