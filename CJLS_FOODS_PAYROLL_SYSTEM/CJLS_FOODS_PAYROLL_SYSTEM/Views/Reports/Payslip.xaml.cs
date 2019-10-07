using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Xml;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Views.Reports
{
    /// <summary>
    /// Interaction logic for Payslip.xaml
    /// </summary>
    public partial class Payslip : Window
    {
        View_Models.PayslipViewModel VM;
        List<PayrollDetail> PayrollDetails;
        public Payslip(List<PayrollDetail> payrollDetails)
        {
            InitializeComponent();
            PayrollDetails = payrollDetails;
        }

        private void btn_printPayslip_Click(object sender, RoutedEventArgs e)
        {
            VM.PrintPaySlip(fd_Payslip);
            this.Close();
        }
        private void populateFlowDocuments()
        {
            foreach (var payslip in VM.Payslips)
            {
                var clonedPayslipUI = ClonePayslip(blockUI_playslip);
                clonedPayslipUI.DataContext = payslip;
                AssignPayslipValues(clonedPayslipUI, payslip);
                fd_Payslip.Blocks.Add(clonedPayslipUI);
            }
        }
        private BlockUIContainer ClonePayslip(BlockUIContainer block)
        {
            var sb = new StringBuilder();
            var writer = XmlWriter.Create(sb, new XmlWriterSettings
            {
                Indent = true,
                ConformanceLevel = ConformanceLevel.Fragment,
                OmitXmlDeclaration = true,
                NamespaceHandling = NamespaceHandling.OmitDuplicates,
            });
            var mgr = new XamlDesignerSerializationManager(writer);

            // HERE BE MAGIC!!!
            mgr.XamlWriterMode = XamlWriterMode.Expression;
            // THERE WERE MAGIC!!!

            XamlWriter.Save(block, mgr);

            StringReader stringReader = new StringReader(sb.ToString());
            XmlReader xmlReader = XmlReader.Create(stringReader);
            BlockUIContainer newBlock = (BlockUIContainer)XamlReader.Load(xmlReader);
            return newBlock;
        }
        private void AssignPayslipValues(BlockUIContainer payslipContainer, View_Models.PayslipViewModel.Payslip payslip)
        {
            ((Run)payslipContainer.FindName("FullName")).Text = payslip.PayrollDetail.Employee.FullName;
            ((Run)payslipContainer.FindName("StartDate")).Text = payslip.PayrollDetail.Payroll.StartDate.ToString("MM/dd/yyyy");
            ((Run)payslipContainer.FindName("EndDate")).Text = payslip.PayrollDetail.Payroll.EndDate.ToString("MM/dd/yyyy");
            ((Run)payslipContainer.FindName("DailyRate")).Text = payslip.PayrollDetail.Employee.DailyRate.ToString();
            ((Label)payslipContainer.FindName("GrossPay")).Content = payslip.PayrollDetail.GrossPay.ToString();
            ((Label)payslipContainer.FindName("RegularPay")).Content = payslip.PayrollDetail.RegularPay.ToString();
            ((Label)payslipContainer.FindName("OvertimePay")).Content = payslip.PayrollDetail.OvertimePay.ToString();
            ((Run)payslipContainer.FindName("NetPay")).Text = payslip.PayrollDetail.NetPay.ToString();
            ((DataGrid)payslipContainer.FindName("DataGrid")).ItemsSource = payslip.PayrollDeductions;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            VM = (View_Models.PayslipViewModel)DataContext;
            VM.Instantiate(PayrollDetails);
            populateFlowDocuments();
        }
    }

}
