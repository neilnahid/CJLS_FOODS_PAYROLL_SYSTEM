using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace CJLS_FOODS_PAYROLL_SYSTEM.Model {
    public class Dialog {
        public string ConfirmDialogHeader { get; set; } = "Are you sure?";
        public string PromptDialogHeader { get; set; } = "Successfully Added!";
        public string ConfirmDialogButtonText { get; set; }
        public string PromptDialogConfirmButtonText { get; set; } = "OK";
        public Visibility ConfirmDialogVisibility { get; set; } = Visibility.Visible;
        public Visibility PromptDialogVisibility { get; set; } = Visibility.Collapsed;
        public bool IsOpen { get; set; }
    }
}
