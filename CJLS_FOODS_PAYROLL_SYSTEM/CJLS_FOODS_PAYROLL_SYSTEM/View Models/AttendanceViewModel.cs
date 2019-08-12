using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.ComponentModel;
using System.Globalization;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{

    public class AttendanceViewModel : INotifyPropertyChanged
    {
        public void InstantiateViewModel(Payroll payroll, PayrollDetail selectedPayrollDetail)
        {
            Attendances = new List<Attendance>(); //instantiates attendances
            Payroll = payroll;
            PayrollDetail = selectedPayrollDetail;
            PayrollRange = new Model.PayrollRange();
            PayrollRange = GetPayrollRange(); // returns the weeks which contains days starting from payroll startdate to enddate
            AddToAttendances(PayrollRange); // references the attendance object attached to the Day object to the Attendances property
            GetSummaryNumbers();
            SelectedWeek = new Model.Week(); // instantiate
            DeductionsTypes = GetDeductionTypes(); // gets deduction types
            Deduction = new Deduction(); // instantiate
            Deductions = new ObservableCollection<Deduction>();
            Loans = new List<Loan>();
            GetLoans();
            UpdateFlagsOfEveryAttendance(); // instantiate the flags according to the extended attendance's valuep
            populateBreakdownItems();
            //gets the string month representation
            StartMonth = DateTimeFormatInfo.CurrentInfo.GetMonthName(Payroll.StartDate.Month);
            EndMonth = DateTimeFormatInfo.CurrentInfo.GetMonthName(Payroll.EndDate.Month);
        }
        #region properties
        public double TotalOverTimeHours { get; set; }

        public List<Deduction> AllDeductions { get; set; }
        public double TotalRegularHours { get; set; }
        public double TotalDeductions { get; set; }

        public Payroll Payroll { get; set; }
        public List<Loan> Loans { get; set; }
        public PayrollDetail PayrollDetail { get; set; }
        public Model.PayrollRange PayrollRange { get; set; }

        public List<Attendance> Attendances { get; set; }
        public Model.ExtendedAttendance Attendance { get; set; }
        public string StartMonth { get; set; }
        public string EndMonth { get; set; }
        public Deduction Deduction { get; set; }
        public Model.Week SelectedWeek { get; set; }
        public List<DeductionsType> DeductionsTypes { get; set; }
        public ObservableCollection<Deduction> Deductions { get; set; }
        public List<BreakdownItem> BreakdownItems { get; set; }


        #region UI Properties
        public bool IsParentDialogOpen { get; set; }
        public bool IsJrDialogOpen { get; set; }

        public Visibility AddDeductionPanel { get; set; }
        public Visibility BreakdownPanel { get; set; }
        public Visibility BPTDaytoDayPanel { get; set; }
        public Visibility BPLoanCashAdvancePanel { get; set; }
        public Visibility BPContributionsPanel { get; set; }
        #endregion

        public event PropertyChangedEventHandler PropertyChanged;
        #endregion

        #region Methods/Functions
        public Model.PayrollRange GetPayrollRange()
        {
            if (PayrollDetail.Attendances.Count > 0 && PayrollDetail.Attendances[0].AttendanceDate.HasValue)
            {
                return new Model.PayrollRange(PayrollDetail);
            }
            else
            {
                return new Model.PayrollRange(Payroll.StartDate, Payroll.EndDate, PayrollDetail);
            }
        }
        public void SaveAttendance()
        {
            Attendances = new List<Attendance>();
            AddToAttendances(PayrollRange);
            GetSummaryNumbers();
            PayrollDetail.Attendances = new System.Data.Linq.EntitySet<Attendance>();
            PayrollDetail.Attendances.AddRange(Attendances);
            Helper.db.SubmitChanges();
        }
        public void AddDeduction(Attendance a, Deduction d)
        {
            a.Deductions.Add(d);
        }
        private List<DeductionsType> GetDeductionTypes()
        {
            return (from i in Helper.db.DeductionsTypes select i).ToList();
        }
        public void UpdateFlagsOf(Model.ExtendedAttendance attendance)
        {
            if (attendance != null && attendance.Attendance.AttendanceDate != null)
            {
                UpdateRegularHoursFlag(attendance);
                UpdateOverTimeHoursFlag(attendance);
                UpdateDeductionsFlag(attendance);
            }
        }
        public void UpdateFlagsOfEveryAttendance()
        {
            foreach (var w in PayrollRange.Weeks)
            {
                foreach (var d in w.Days)
                {
                    UpdateFlagsOf(d);
                }
            }
        }
        public void AddToAttendances(Model.PayrollRange pr)
        {
            Attendances = new List<Attendance>();
            foreach (var w in pr.Weeks)
            {
                foreach (var d in w.Days)
                {
                    if (d.Attendance.AttendanceDate != null)
                    {
                        Attendances.Add(d.Attendance);
                    }
                }
            }
        }

        //this method must be placed AFTER the AddToAttendances
        public void GetSummaryNumbers()
        {
            TotalRegularHours = 0;
            TotalDeductions = 0;
            TotalOverTimeHours = 0;
            if (Attendances != null)
            {
                foreach (var a in Attendances)
                {
                    TotalRegularHours += a.RegularHoursWorked;
                    TotalDeductions += (from d in a.Deductions select d.Amount).Sum();
                    TotalOverTimeHours += a.OverTimeHoursWorked;
                }
            }
        }

        #region UpdateFlags Functions
        private void UpdateRegularHoursFlag(Model.ExtendedAttendance a)
        {
            if (a.Attendance.RegularHoursWorked >= a.Attendance.PayrollDetail.Employee.DailyRequiredHours)
            {
                a.RegularHoursFlag = Visibility.Visible;
                a.UnderTimeFlag = Visibility.Collapsed;
            }
            else
            {
                a.RegularHoursFlag = Visibility.Collapsed;
                a.UnderTimeFlag = Visibility.Visible;
            }
        }
        private void UpdateOverTimeHoursFlag(Model.ExtendedAttendance a)
        {
            if (a.Attendance.OverTimeHoursWorked > 0)
                a.OverTimeHoursFlag = Visibility.Visible;
            else
                a.OverTimeHoursFlag = Visibility.Collapsed;
        }
        private void UpdateDeductionsFlag(Model.ExtendedAttendance a)
        {
            if (a.Attendance.Deductions.Count > 0)
                a.DeductionsFlag = Visibility.Visible;
            else
                a.DeductionsFlag = Visibility.Collapsed;
        }
        #endregion

        public void GetLoans()
        {
            Loans = (from l in Helper.db.Loans where PayrollDetail.Employee == l.Employee && !l.IsPaid.Value select l).ToList();
        }
        public struct BreakdownItem
        {
            public string Name { get; set; }
            public double Amount { get; set; }
        }


        //Functions for getting the value of the breakdown panel
        private double getDaytoDayDeductionAmount()
        {
            var totalDeductions = 0.0;
            foreach (var a in Attendances)
            {
                totalDeductions += (from d in a.Deductions select d.Amount).Sum();
            }
            return totalDeductions;
        }
        private double getCashLoansAmount()
        {
            return (from l in Loans where l.IsPaid.Value == false select l.AmountToPayPerPayroll).Sum().Value;
        }
        private double getContributionsAmount()
        {
            return Helper.db.ComputeTotalContributions(PayrollDetail.Employee.EmployeeID, PayrollDetail.PayrollDetailID, Payroll.PayrollID).Value;
        }
        public void populateBreakdownItems()
        {
            BreakdownItems = new List<BreakdownItem>();
            BreakdownItems.Add(new BreakdownItem { Name = "DaytoDay", Amount = getDaytoDayDeductionAmount() });
            BreakdownItems.Add(new BreakdownItem { Name = "Loans/Cash Advance", Amount = getCashLoansAmount() });
            BreakdownItems.Add(new BreakdownItem { Name = "Contributions", Amount = getContributionsAmount() });
        }
        public void updateLoansAndCashAdvances()
        {
            foreach(var l in Loans)
            {
                l.TermsRemaining--;
            }
        }
        public void getAllDeducions()
        {
            AllDeductions = new List<Deduction>();
            foreach(var a in Attendances)
            {
                foreach(var d in a.Deductions)
                {
                    AllDeductions.Add(d);
                }
            }
        }
        #endregion
    }
}
