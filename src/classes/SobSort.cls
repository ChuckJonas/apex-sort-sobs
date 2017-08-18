// Currently most the overhead is in casting
//   Benchmark (2000 records):
//    - built in .sort method 0.017s
//    - custom comparable wrapper
//    - Regular Quicksort: 0.435s
//    - Dynamic Quicksort: 0.692s
//    - Dynamic Quicksort w/ pivot passed as index: .592s
public class SobSort{

    public static void ascending(List<SObject> sobs, String relationshipObj, SObjectField sortField){
        BaseSOBQuickSort quickSort;

        //infer sort type
        Schema.SoapType sType = sortField.getDescribe().getSoapType();
        if(sType == Schema.SoapType.Integer || sType == Schema.SoapType.Double || sType == Schema.SoapType.Time){
            Decimal[] values = new Decimal[]{};
            for(SObject sob : sobs){
                values.add((Decimal)sob.getSObject(relationshipObj).get(sortField));
            }
            quickSort = new DecimalSOBQuicksort(values, sobs);
        }
        else if(sType == Schema.SoapType.String || sType == Schema.SoapType.Id || sType == Schema.SoapType.Base64binary){
            String[] values = new String[]{};
            for(SObject sob : sobs){
                values.add((String)sob.getSObject(relationshipObj).get(sortField));
            }
            quickSort = new StringSOBQuicksort(values, sobs);
        }else if(sType == Schema.SoapType.Date || sType == Schema.SoapType.DateTime){
            DateTime[] values = new DateTime[]{};
            for(SObject sob : sobs){
                values.add((DateTime)sob.getSObject(relationshipObj).get(sortField));
            }
            quickSort = new DatetimeSOBQuicksort(values, sobs);
        }else if(sType == Schema.SoapType.Boolean){
            Boolean[] values = new Boolean[]{};
            for(SObject sob : sobs){
                values.add((Boolean)sob.getSObject(relationshipObj).get(sortField));
            }
            quickSort = new BooleanSOBQuicksort(values, sobs);
        }
        quickSort.sort();
    }

    public static void ascending(List<SObject> sobs, SObjectField sortField){
        BaseSOBQuickSort quickSort;
        //infer sort type
        Schema.SoapType sType = sortField.getDescribe().getSoapType();
        if(sType == Schema.SoapType.Integer || sType == Schema.SoapType.Double || sType == Schema.SoapType.Time){
            Decimal[] values = new Decimal[]{};
            for(SObject sob : sobs){
                values.add((Decimal)sob.get(sortField));
            }
            quickSort = new DecimalSOBQuicksort(values, sobs);
        }
        else if(sType == Schema.SoapType.String || sType == Schema.SoapType.Id || sType == Schema.SoapType.Base64binary){
            String[] values = new String[]{};
            for(SObject sob : sobs){
                values.add((String)sob.get(sortField));
            }
            quickSort = new StringSOBQuicksort(values, sobs);
        }else if(sType == Schema.SoapType.Date || sType == Schema.SoapType.DateTime){
            DateTime[] values = new DateTime[]{};
            for(SObject sob : sobs){
                values.add((DateTime)sob.get(sortField));
            }
            quickSort = new DatetimeSOBQuicksort(values, sobs);
        }else if(sType == Schema.SoapType.Boolean){
            Boolean[] values = new Boolean[]{};
            for(SObject sob : sobs){
                values.add((Boolean)sob.get(sortField));
            }
            quickSort = new BooleanSOBQuicksort(values, sobs);
        }
        quickSort.sort();
    }

    public class DecimalSOBQuicksort extends BaseSOBQuickSort{

        //allows us to prevent casting multiple times
        Decimal[] typedValues;

        public DecimalSOBQuicksort(Object[] values, SObject[] sobs){
            super(values, sobs);
            this.typedValues = (Decimal[]) values;
        }

        public override Integer compareToPivot(Integer valueIndex, Integer pivotIndex){
            Decimal val = typedValues[valueIndex];
            Decimal piv = typedValues[pivotIndex];
            if(val == piv){ return 0; }
            if(val > piv){ return 1; }
            return -1;
        }
    }

    public class StringSOBQuicksort extends BaseSOBQuickSort{
        String[] typedValues;

        public StringSOBQuicksort(Object[] values, SObject[] sobs){
            super(values, sobs);
            this.typedValues = (String[]) values;
        }

        public override Integer compareToPivot(Integer valueIndex, Integer pivotIndex){
            String val = typedValues[valueIndex];
            String piv = typedValues[pivotIndex];
            if(val == piv){ return 0; }
            if(val > piv){ return 1; }
            return -1;
        }
    }

    public class DatetimeSOBQuicksort extends BaseSOBQuickSort{
        DateTime[] typedValues;

        public DateTimeSOBQuicksort(Object[] values, SObject[] sobs){
            super(values, sobs);
            this.typedValues = (DateTime[]) values;
        }

        public override Integer compareToPivot(Integer valueIndex, Integer pivotIndex){
            DateTime val = typedValues[valueIndex];
            DateTime piv = typedValues[pivotIndex];
            if(val == piv){ return 0; }
            if(val > piv){ return 1; }
            return -1;
        }
    }

    public class BooleanSOBQuicksort extends BaseSOBQuickSort{
        Boolean[] typedValues;

        public BooleanSOBQuicksort(Object[] values, SObject[] sobs){
            super(values, sobs);
            this.typedValues = (Boolean[]) values;
        }

        public override Integer compareToPivot(Integer valueIndex, Integer pivotIndex){
            Boolean val = typedValues[valueIndex];
            Boolean piv = typedValues[pivotIndex];
            if(val && piv || !val && !piv){ return 0; }
            if(val){ return 1; }
            return -1;
        }
    }

    public abstract class BaseSOBQuickSort{
        private SObject[] sobs;
        private Integer length;

        private Object[] values;

        public BaseSOBQuickSort(Object[] inputValues, SObject[] sobs){
            this.sobs = sobs;
            values = inputValues;
        }

        public void sort() {
            // check for empty or null array
            if (values == null || values.size()==0){
                return;
            }

            length = values.size();
            quicksort(0, length - 1);
        }

        // returns 1 if greater, -1 if less than, 0 if equals
        public abstract Integer compareToPivot(Integer valueIndex, Integer pivotIndex);

        private void quicksort(Integer low, Integer high) {
            Integer i = low, j = high;

            // Get the pivot element from the middle of the list
            // Trading off array accessor time to reduce casting
            Integer pivot = low + (high-low)/2;

            // Divide into two lists
            while (i <= j) {
                // If the current value from the left list is smaller than the pivot
                // element then get the next element from the left list
                while (compareToPivot(i,pivot) == -1){
                    i++;
                }
                // If the current value from the right list is larger than the pivot
                // element then get the next element from the right list
                while (compareToPivot(j,pivot) == 1) {
                    j--;
                }

                // If we have found a value in the left list which is larger than
                // the pivot element and if we have found a value in the right list
                // which is smaller than the pivot element then we exchange the
                // values.
                // As we are done we can increase i and j
                if (i <= j) {
                    exchangeObject(i, j);
                    i++;
                    j--;
                }
            }
            // Recursion
            if (low < j)
                quicksort(low, j);
            if (i < high)
                quicksort(i, high);
        }

        private void exchangeObject(Integer i, Integer j) {
            Object temp = values[i];
            values[i] = values[j];
            values[j] = temp;

            exchangeSob(i, j);
        }

        private void exchangeSob(Integer i, Integer j){
            SObject temp = sobs[i];
            sobs[i] = sobs[j];
            sobs[j] = temp;
        }
    }
}