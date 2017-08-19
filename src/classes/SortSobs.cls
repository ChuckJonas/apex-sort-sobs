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
      * @description        Sort SOBS ascending using a relationship
      * @param sobs         SObjects to sort
      * @param sortFields   List of SObjectField to capture sorting field.
                                The last item will be the value sorted on.
                                All preceeding items must be relationship fields
      */
    public static void ascending(SObject[] sobs, SObjectField[] sortFields){
        sort(sobs, sortFields, false);
    }


    /**
      * @description        Sort SOBS descending using a relationship
      * @param sobs         SObjects to sort
      * @param sortFields   List of SObjectField to capture sorting field.
                                The last item will be the value sorted on.
                                All preceeding items must be relationship fields
    */
    public static void descending(SObject[] sobs, SObjectField[] sortFields){
        sort(sobs, sortFields, true);
    }

    /**
      * @description        Sort SOBS ascending using a field
      * @param sobs         SObjects to sort
      * @param sortField    Field to sort on
    */
    public static void ascending(SObject[] sobs, SObjectField sortField){
        sort(sobs, new SObjectField[]{ sortField }, false);
    }

    /**
      * @description        Sort SOBS descending using a field
      * @param sobs         SObjects to sort
      * @param sortField    Field to sort on
    */
    public static void descending(SObject[] sobs, SObjectField sortField){
        sort(sobs, new SObjectField[]{ sortField }, true);
    }

    /** HELPERS **/

    //extracts values, determines type, runs sort
    private static void sort(SObject[] sobs, SObjectField[] sortFields, Boolean reverse){
        SObjectField sortField = sortFields.remove(sortFields.size()-1);

        Object[] values = new Object[]{};
        for(SObject sob : sobs){
            values.add(getValueFromRelationship(sob, sortFields, sortField));
        }

        //infer sort type
        BaseSOBQuickSort quickSort;
        Schema.SoapType sType = sortField.getDescribe().getSoapType();
        if(sType == Schema.SoapType.Integer || sType == Schema.SoapType.Double || sType == Schema.SoapType.Time){
            quickSort = new DecimalSOBQuicksort();
        }else if(sType == Schema.SoapType.String || sType == Schema.SoapType.Id || sType == Schema.SoapType.Base64binary){
            quickSort = new StringSOBQuicksort();
        }else if(sType == Schema.SoapType.Date || sType == Schema.SoapType.DateTime){
            quickSort = new DatetimeSOBQuicksort();
        }else if(sType == Schema.SoapType.Boolean){
            quickSort = new BooleanSOBQuicksort();
        }
        quickSort.sort(values, sobs, reverse);

    }

    //extracts value from sob
    private static Object getValueFromRelationship(SObject sob, SObjectField[] relationships, SObjectField sortField){
        if(relationships.size() == 0){
            return sob.get(sortField);
        }

        SObject parentSob = sob;
        for(Integer i = 0; i < relationships.size(); i++){
            parentSob = parentSob.getSObject(relationships[i]);
            if(parentSob == null){
                return null;
            }
        }
        return parentSob.get(sortField);
    }

    /** QUICKSORT TYPE IMPLEMENTATIONS **/

    private class DecimalSOBQuicksort extends BaseSOBQuickSort{

        private override Integer compareToPivot(Object value, Object pivot){
            Decimal val = (Decimal) value;
            Decimal piv = (Decimal) pivot;
            if(val == piv){ return 0; }
            if(val > piv){ return 1; }
            return -1;
        }
    }

    private class StringSOBQuicksort extends BaseSOBQuickSort{

        private override Integer compareToPivot(Object value, Object pivot){


            String val = (String) value;
            String piv = (String) pivot;
            if(val == piv){ return 0; }
            if(val > piv){ return 1; }
            return -1;
        }
    }

    private class DatetimeSOBQuicksort extends BaseSOBQuickSort{

        private override Integer compareToPivot(Object value, Object pivot){
            DateTime val = (DateTime) value;
            DateTime piv = (DateTime) pivot;
            if(val == piv){ return 0; }
            if(val > piv){ return 1; }
            return -1;
        }
    }

    private class BooleanSOBQuicksort extends BaseSOBQuickSort{

        private override Integer compareToPivot(Object value, Object pivot){
            Boolean val = (Boolean) value;
            Boolean piv = (Boolean) pivot;
            if(val && piv || !val && !piv){ return 0; }
            if(val){ return 1; }
            return -1;
        }
    }

    /** QUICKSORT BASE CLASS **/
    private abstract class BaseSOBQuickSort{
        private SObject[] sobs;
        private Integer length;
        private Object[] values;
        private Boolean reverse;

        public void sort(Object[] inputValues, SObject[] sobs, Boolean reverse) {
            this.reverse = reverse;

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
        private abstract Integer compareToPivot(Object value, Object pivot);

        private void quicksort(Integer low, Integer high) {
            Integer i = low, j = high;

            Object pivot = values[low + (high-low)/2];

            Integer negator = reverse == true ? -1 : 1;

            // into two array
            while (i <= j) {

                // if current item from left array < pivot
                while (compareToPivot(values[i], pivot) * negator == -1){
                    //get the next item in left array
                    i++;
                }
                // if current item from right array > pivot
                while (compareToPivot(values[j], pivot) * negator == 1) {
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