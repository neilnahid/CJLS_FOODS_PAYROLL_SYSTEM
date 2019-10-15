using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Printing;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Markup;
using System.Xml;

namespace CJLS_FOODS_PAYROLL_SYSTEM.View_Models
{
    public class PayrollSummaryViewModel : INotifyPropertyChanged
    {
        public Payroll Payroll { get; set; }
        public DateTime DateNow { get; set; } = DateTime.Now;
        public double? TotalGrossPay { get; set; }
        public User User { get; set; } = Helper.User;
        public event PropertyChangedEventHandler PropertyChanged;
        public void Initialize(int PayrollID)
        {
            Helper.db = new DatabaseDataContext();
            Payroll = (from p in Helper.db.Payrolls where p.PayrollID == PayrollID select p).First();
            TotalGrossPay = Payroll.PayrollDetails.Sum(pd => pd.GrossPay);
        }
        public void Print(FlowDocument fd)
        {
            var pd = new PrintDialog();
            pd.PrintTicket.PageOrientation = PageOrientation.Landscape;
            pd.PrintTicket.PageMediaSize = new PageMediaSize(PageMediaSizeName.NorthAmericaGermanLegalFanfold);
            if (pd.ShowDialog().Value) ;
            {
                IDocumentPaginatorSource idocument = fd as IDocumentPaginatorSource;
                try
                {
                    pd.PrintDocument(idocument.DocumentPaginator, "Printing FlowDocument");
                }
                catch (System.Runtime.CompilerServices.RuntimeWrappedException)
                {
                }
            }
        }
    }
}
