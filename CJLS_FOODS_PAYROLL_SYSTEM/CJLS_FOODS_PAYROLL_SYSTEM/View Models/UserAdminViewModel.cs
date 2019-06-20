using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models {
    public class UserAdminViewModel : INotifyPropertyChanged {

        //properties
        public ObservableCollection<User> Users { get; set; }
        public User User { get; set; }
        public event PropertyChangedEventHandler PropertyChanged;



        //methods
        public UserAdminViewModel() {
            Users = new ObservableCollection<User>(GetAllUsers());
            User = new User();
        }
        public List<User> GetAllUsers() {
            return (from u in Helper.db.Users select u).ToList();
        }
        public void AddNewUser() {
            Helper.db.Users.InsertOnSubmit(User);
            Users.Add(User);
            Helper.db.SubmitChanges();
        }
        public void UpdateUser() {
            Helper.db.SubmitChanges();
        }
        public void DeleteUser() {
            Helper.db.Users.DeleteOnSubmit(User);
            Users.Remove(User);
            User = new User();
            Helper.db.SubmitChanges();
        }
    }
}
