using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Views.Payroll
{
    /// <summary>
    /// Interaction logic for GovernmentContributionRates.xaml
    /// </summary>
    public partial class GovernmentContributionRates : Page
    {
        View_Models.GovernContributionRatesViewModel VM;
        public GovernmentContributionRates()
        {
            InitializeComponent();
            VM = (View_Models.GovernContributionRatesViewModel)DataContext;
            VM.Instantiate();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            VM.Update();
            MessageBox.Show("Successfully updated.");
        }
    }
}
