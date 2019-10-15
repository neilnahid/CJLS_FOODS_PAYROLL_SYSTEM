﻿using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class UserAdminViewModel : INotifyPropertyChanged
    {

        //properties
        public ObservableCollection<User> Users { get; set; }
        public List<Employee> Employees { get; set; }
        public User User { get; set; }
        public event PropertyChangedEventHandler PropertyChanged;

        public void Instantiate()
        {
            Helper.db = new DatabaseDataContext();
            Users = new ObservableCollection<User>(GetAllUsers());
            User = new User();
            Employees = GetEmployees();
        }

        public List<Employee> GetEmployees()
        {
            return (from e in Helper.db.Employees where e.EmployeeType.Name == "Payroll Officer" && e.Status == "Active" && e.Users.Count == 0 select e).ToList();
        }
        public List<User> GetAllUsers()
        {
            return (from u in Helper.db.Users where u.Status == "Active" && u.UserType != "Owner" select u).ToList();
        }
        public void AddNewUser()
        {
            Helper.db.Users.InsertOnSubmit(User);
            Users.Add(User);
            Helper.db.SubmitChanges();
        }
        public void UpdateUser()
        {
            Helper.db.SubmitChanges();
        }
        public void DeleteUser()
        {
            Helper.db.Users.DeleteOnSubmit(User);
            Users.Remove(User);
            User = new User();
            Helper.db.SubmitChanges();
        }
    }
}
