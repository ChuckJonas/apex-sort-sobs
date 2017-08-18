/**
    Author: Charlie Jonas
        (github: @chuckjonas, charlie@callawaycloudconsulting.com)

    Description:
        Allows for dynamic sorting of SObject Lists without the need to impement Comparables.
        - Uses quicksort

    Documentation:  Please see https://github.com/ChuckJonas/apex-sort-sobs for useage information & updates
*/
public class SortSobs{

    /**
      * @description        Sort SOBS ascending using a relationship field
      * @param sobs         SObjects to sort
      * @param sortFields   List of SObjectField to capture sorting field.
                                The last item will be the value sorted on.
                                All preceeding items must be relationship fields
      */
    public static void ascending(List<SObject> sobs, SObjectField[] sortFields){
        BaseSOBQuickSort quickSort;

        //build Object list
        Object[] values = new Object[]{};

        for(SObject sob : sobs){
            values.add(getValueFromRelationship(sob, sortFields));
        }

        System.debug(values);

        //infer sort type
        Schema.SoapType sType = sortFields[sortFields.size()-1].getDescribe().getSoapType();
        if(sType == Schema.SoapType.Integer || sType == Schema.SoapType.Double || sType == Schema.SoapType.Time){
            quickSort = new DecimalSOBQuicksort();
        }else if(sType == Schema.SoapType.String || sType == Schema.SoapType.Id || sType == Schema.SoapType.Base64binary){
            quickSort = new StringSOBQuicksort();
        }else if(sType == Schema.SoapType.Date || sType == Schema.SoapType.DateTime){
            quickSort = new DatetimeSOBQuicksort();
        }else if(sType == Schema.SoapType.Boolean){
            quickSort = new BooleanSOBQuicksort();
        }
        quickSort.sort(values, sobs);

    }

    /**
      * @description        Sort SOBS ascending using a field
      * @param sobs         SObjects to sort
      * @param sortField    Field to sort on
      */
    public static void ascending(List<SObject> sobs, SObjectField sortField){
        ascending(sobs, new SObjectField[]{ sortField });
    }

    /** HELPERS **/
    private static Object getValueFromRelationship(SObject sob, SObjectField[] relationships){
        if(relationships.size() == 1){
            return sob.get(relationships[0]);
        }

        SObjectField sortField = relationships.remove(relationships.size()-1);
        SObject parentSob = sob;
        for(SObjectField s : relationships){
            parentSob = parentSob.getSObject(s);
            if(parentSob == null){
                return null;
            }
        }
        return parentSob.get(sortField);
    }

    /** QUICKSORT TYPE IMPLEMENTATIONS **/

    public class DecimalSOBQuicksort extends BaseSOBQuickSort{

        public override Integer compareToPivot(Object value, Object pivot){
            Decimal val = (Decimal) value;
            Decimal piv = (Decimal) pivot;
            if(val == piv){ return 0; }
            if(val > piv){ return 1; }
            return -1;
        }
    }

    public class StringSOBQuicksort extends BaseSOBQuickSort{

        public override Integer compareToPivot(Object value, Object pivot){


            String val = (String) value;
            String piv = (String) pivot;
            if(val == piv){ return 0; }
            if(val > piv){ return 1; }
            return -1;
        }
    }

    public class DatetimeSOBQuicksort extends BaseSOBQuickSort{

        public override Integer compareToPivot(Object value, Object pivot){
            DateTime val = (DateTime) value;
            DateTime piv = (DateTime) pivot;
            if(val == piv){ return 0; }
            if(val > piv){ return 1; }
            return -1;
        }
    }

    public class BooleanSOBQuicksort extends BaseSOBQuickSort{

        public override Integer compareToPivot(Object value, Object pivot){
            Boolean val = (Boolean) value;
            Boolean piv = (Boolean) pivot;
            if(val && piv || !val && !piv){ return 0; }
            if(val){ return 1; }
            return -1;
        }
    }

    /** QUICKSORT BASE CLASS **/
    public abstract class BaseSOBQuickSort{
        private SObject[] sobs;
        private Integer length;
        private Object[] values;

        public void sort(Object[] inputValues, SObject[] sobs) {
            // check for empty or null array
            if (inputValues == null || inputValues.size()==0){
                return;
            }

            this.sobs = sobs;
            values = inputValues;

            length = values.size();
            quicksort(0, length - 1);
        }

        // returns 1 if greater, -1 if less than, 0 if equals
        public abstract Integer compareToPivot(Object value, Object pivot);

        private void quicksort(Integer low, Integer high) {
            Integer i = low, j = high;

            Object pivot = values[low + (high-low)/2];

            // into two array
            while (i <= j) {

                // if current item from left array < pivot
                while (compareToPivot(values[i], pivot) == -1){
                    //get the next item in left array
                    i++;
                }
                // if current item from right array > pivot
                while (compareToPivot(values[j], pivot) == 1) {
                    //get the next item in right array
                    j--;
                }

                //if left is larger than pivot and right is smaller, exchange
                if (i <= j) {
                    exchangeObject(i, j);
                    i++;
                    j--;
                }
            }

            // recursion
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