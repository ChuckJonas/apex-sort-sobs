# apex-sort-sobs
Library for short hand sorting of Salesforce SObjects by any field

# usage

Sort on Field:

    Account[] accs = [SELECT My_Custom_Field__c FROM Account LIMIT 2000];
    SobSort.ascending(accs, Account.My_Custom_Field__c);
    
Sort on referenced object field:

    List<Contact> entries = [SELECT Name, Account.Name FROM Contact limit 2000];
    SobSort.ascending(entries, 'Account', Account.Name);

# benchmarking

- built in `List.sort()` method 0.017s
- w/ custom comparable wrapper: 0.377s
- Hardcoded Quicksort: 0.435s
- Dynamic Field Quicksort: 0.692s
- Dynamic Quicksort w/ reduced casting: .592s (implemented solution)


Benchmark code for custom comparable wrapper

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
