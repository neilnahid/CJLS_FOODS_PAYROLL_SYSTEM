using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CJLS_FOODS_PAYROLL_SYSTEM
{
    public class Paginator<T> : INotifyPropertyChanged
    {
        public int PageCount { get; set; }
        public int Page { get; set; }
        [PropertyChanged.DependsOn("Page")]
        public bool CanGoToNext { get { return (Collection != null && (Collection.Count) > ((Page + 1) * 10)) ? true : false; } }
        [PropertyChanged.DependsOn("Page")]
        public bool CanGoToPrevious { get { return Page > 0 ? true : false; } }
        public ObservableCollection<T> Collection { get; set; }

        public event PropertyChangedEventHandler PropertyChanged;

        public ObservableCollection<T> moveToNextPage()
        {
            Page++;
            return new ObservableCollection<T>(Collection.Skip(Page * PageCount).Take(PageCount));
        }
        public ObservableCollection<T> moveToPreviousPage()
        {
            Page--;
            return new ObservableCollection<T>(Collection.Skip(Page * PageCount).Take(PageCount));
        }
        public ObservableCollection<T> getCurrentPageObjects()
        {
            return new ObservableCollection<T>(Collection.Skip(Page * PageCount).Take(PageCount));

        }
        public void assignCollection(ObservableCollection<T> collection)
        {
            Page = 0;
            Collection = collection;
        }
    }
}
