# apex-sort-sobs

Utility class that provides a short-hand method for sorting of Salesforce SObjects by any field.  Uses a Quicksort implementation with Dynamic Type Inference.

## usage

Sort on Field:

``` java
Account[] accs = [SELECT My_Custom_Field__c FROM Account LIMIT 2000];
SortSobs.ascending(accs, Account.My_Custom_Field__c);
```

Sort in reverse order (desc)

``` java
Account[] accs = [SELECT My_Custom_Field__c FROM Account LIMIT 2000];
SortSobs.descending(accs, Account.My_Custom_Field__c);
```

Sort on parent field:

``` java
List<Contact> entries = [SELECT Name, Account.Name FROM Contact LIMIT 2000];
SortSobs.ascending(entries, SObjectField[]{ Contact.Account, Account.Name });
```

When sorting on parent fields, the last item in the SObjectField array is always the field to sort on.  All previous items must be relationship fields!

## considerations

This implemenation is a little slower than a `Comparable`, mostly because of overhead in Type casting and we have to run an intial iteration to capture the values to sort.

## todo

- Optimization around casting/general overhead
- Provide more complete benchmarking

## benchmarking

n=2000

- built in `List.sort()` method 0.017s
- w/ custom comparable wrapper: 0.377s
- Hardcoded Quicksort: 0.435s
- Dynamic Field Quicksort: 0.692s
- Dynamic Field Quicksort on relationship (2 levels): 0.692s


Benchmark code for custom comparable wrapper for reference:

      public class ComparatorTest implements Comparable {
        public Account te;
        public ComparatorTest(Account te){
            this.te = te;
        }

        // Implement the compareTo() method
        public Integer compareTo(Object compareTo) {
            ComparatorTest compareToEmp = (ComparatorTest)compareTo;
            if (this.te.Name == compareToEmp.te.Name) return 0;
            if (this.te.Name > compareToEmp.te.Name) return 1;
            return -1;
        }
       }
