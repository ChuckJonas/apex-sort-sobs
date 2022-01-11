/**
    Author: Charlie Jonas
        (github: @chuckjonas, charlie@callawaycloudconsulting.com)
    Description:
        Tests for SortSobs.cls
    Documentation:  Please see https://github.com/ChuckJonas/apex-sort-sobs for useage information & updates
*/
@isTest
private class SortSobsTest {

    @isTest static void test_string_field() {
        Account[] accs = new Account[]{};
        Integer c = 200;
        for(Integer i = 0; i < c; i++){
            accs.add(new Account(
                    Name = generateRandomString(30)
            ));
        }

        Test.startTest();
        SortSobs.ascending(accs, Account.Name);
        Test.stopTest();

        Account previousAccount = accs.remove(0);
        for(Account acc : accs){
            System.assert(previousAccount.Name <= acc.Name);
            previousAccount = acc;
        }

    }


    @isTest static void test_string_field_desc() {
        Account[] accs = new Account[]{};
        Integer c = 200;
        for(Integer i = 0; i < c; i++){
            accs.add(new Account(
                    Name = generateRandomString(30)
            ));
        }

        Test.startTest();
        SortSobs.descending(accs, Account.Name);
        Test.stopTest();

        Account previousAccount = accs.remove(0);
        for(Account acc : accs){
            System.assert(previousAccount.Name >= acc.Name);
            previousAccount = acc;
        }

    }

    @isTest static void test_number_field() {
        Account[] accs = new Account[]{};
        Integer c = 200;
        for(Integer i = 0; i < c; i++){
            accs.add(new Account(
                    AnnualRevenue = Math.random() * 1000
            ));
        }

        Test.startTest();
        SortSobs.ascending(accs, Account.AnnualRevenue);
        Test.stopTest();

        Account previousAccount = accs.remove(0);
        for(Account acc : accs){
            System.assert(previousAccount.AnnualRevenue <= acc.AnnualRevenue);
            previousAccount = acc;
        }

    }

    @isTest static void test_number_field_desc() {
        Account[] accs = new Account[]{};
        Integer c = 200;
        for(Integer i = 0; i < c; i++){
            accs.add(new Account(
                    AnnualRevenue = Math.random() * 1000
            ));
        }

        Test.startTest();
        SortSobs.descending(accs, Account.AnnualRevenue);
        Test.stopTest();

        Account previousAccount = accs.remove(0);
        for(Account acc : accs){
            System.assert(previousAccount.AnnualRevenue >= acc.AnnualRevenue);
            previousAccount = acc;
        }

    }

    @isTest static void test_date_field() {
        Opportunity[] opps = new Opportunity[]{};
        Integer c = 200;
        for(Integer i = 0; i < c; i++){
            opps.add(new Opportunity(
                    CloseDate = Date.today().addDays((Integer)Math.random() * 1000)
            ));
        }

        Test.startTest();
        SortSobs.ascending(opps, Opportunity.CloseDate);
        Test.stopTest();

        Opportunity previousOpportunity = opps.remove(0);
        for(Opportunity opp : opps){
            System.assert(previousOpportunity.CloseDate <= opp.CloseDate);
            previousOpportunity = opp;
        }

    }

    @isTest static void test_date_field_desc() {
        Opportunity[] opps = new Opportunity[]{};
        Integer c = 200;
        for(Integer i = 0; i < c; i++){
            opps.add(new Opportunity(
                    CloseDate = Date.today().addDays((Integer)Math.random() * 1000)
            ));
        }

        Test.startTest();
        SortSobs.descending(opps, Opportunity.CloseDate);
        Test.stopTest();

        Opportunity previousOpportunity = opps.remove(0);
        for(Opportunity opp : opps){
            System.assert(previousOpportunity.CloseDate >= opp.CloseDate);
            previousOpportunity = opp;
        }
    }

    @isTest static void test_datetime_field() {
        Task[] tasks = new Task[]{};
        Integer j = 200;
        for(Integer i = 0; i < j; i++){
            tasks.add(new Task(
                    ReminderDateTime = DateTime.now().addDays((Integer)Math.random() * 1000)
            ));
        }

        Test.startTest();
        SortSobs.ascending(tasks, Task.ReminderDateTime);
        Test.stopTest();

        Task previousTask = tasks.remove(0);
        for(Task t : tasks){
            System.assert(previousTask.ReminderDateTime <= t.ReminderDateTime);
            previousTask = t;
        }

    }

    @isTest static void test_time_field() {
        ContactPointAddress[] cpas = new ContactPointAddress[]{};
        Integer j = 200;
        for(Integer i = 0; i < j; i++){
            cpas.add(new ContactPointAddress(
                    BestTimeToContactStartTime = Time.newInstance(Integer.valueOf(Math.random() * 24), Integer.valueOf(Math.random() * 60), Integer.valueOf(Math.random() * 60), 0)
            ));
        }

        Test.startTest();
        SortSobs.ascending(cpas, ContactPointAddress.BestTimeToContactStartTime);
        Test.stopTest();

        ContactPointAddress previousCPA = cpas.remove(0);
        for(ContactPointAddress cpa : cpas){
            System.assert(previousCPA.BestTimeToContactStartTime <= cpa.BestTimeToContactStartTime);
            previousCPA = cpa;
        }
    }

    @isTest static void test_time_field_desc() {
        ContactPointAddress[] cpas = new ContactPointAddress[]{};
        Integer j = 200;
        for(Integer i = 0; i < j; i++){
            cpas.add(new ContactPointAddress(
                    BestTimeToContactStartTime = Time.newInstance(Integer.valueOf(Math.random() * 24), Integer.valueOf(Math.random() * 60), Integer.valueOf(Math.random() * 60), 0)
            ));
        }

        Test.startTest();
        SortSobs.descending(cpas, ContactPointAddress.BestTimeToContactStartTime);
        Test.stopTest();

        ContactPointAddress previousCPA = cpas.remove(0);
        for(ContactPointAddress cpa : cpas){
            System.assert(previousCPA.BestTimeToContactStartTime >= cpa.BestTimeToContactStartTime);
            previousCPA = cpa;
        }
    }

    @isTest static void test_datetime_field_desc() {
        Task[] tasks = new Task[]{};
        Integer j = 200;
        for(Integer i = 0; i < j; i++){
            tasks.add(new Task(
                    ReminderDateTime = DateTime.now().addDays((Integer)Math.random() * 1000)
            ));
        }

        Test.startTest();
        SortSobs.descending(tasks, Task.ReminderDateTime);
        Test.stopTest();

        Task previousTask = tasks.remove(0);
        for(Task t : tasks){
            System.assert(previousTask.ReminderDateTime >= t.ReminderDateTime);
            previousTask = t;
        }
    }

    @isTest static void test_boolean_field() {
        Case[] cases = new Case[]{};
        Integer j = 200;
        for(Integer i = 0; i < j; i++){
            cases.add(new Case(
                    IsEscalated = Math.random() < .5 ? true : false
            ));
        }

        Test.startTest();
        SortSobs.ascending(cases, Case.IsEscalated);
        Test.stopTest();

        Boolean switched = false;
        for(Case c : cases){
            //should only encounter falses from here on out
            if(c.IsEscalated == true){
                switched = true;
            }
            System.assert((!switched && !c.IsEscalated) || (switched && c.IsEscalated));
        }

    }

    @isTest static void test_boolean_field_desc() {
        Case[] cases = new Case[]{};
        Integer j = 200;
        for(Integer i = 0; i < j; i++){
            cases.add(new Case(
                    IsEscalated = Math.random() < .5 ? true : false
            ));
        }

        Test.startTest();
        SortSobs.descending(cases, Case.IsEscalated);
        Test.stopTest();

        Boolean switched = false;
        for(Case c : cases){
            //should only encounter falses from here on out
            if(c.IsEscalated == false){
                switched = true;
            }
            System.assert((!switched && c.IsEscalated) || (switched && !c.IsEscalated));
        }
    }

    @isTest static void test_relationship() {
        Account[] accs = new Account[]{};
        for(Integer i = 0; i < 100; i++){
            accs.add(new Account(
                    Name = generateRandomString(30)
            ));
        }

        Contact[] contacts = new Contact[]{};
        for(Account acc : accs){
            for(Integer i = 0; i < 10; i++){
                contacts.add(new Contact(
                        Account = acc
                ));
            }
        }

        Test.startTest();
        SortSobs.ascending(contacts, new SObjectField[]{ Contact.AccountId, Account.Name });
        Test.stopTest();

        Contact previousContact = contacts.remove(0);
        for(Contact c : contacts){
            System.assert(previousContact.Account.Name <= c.Account.Name);
            previousContact = c;
        }

    }

    @isTest static void test_relationship_desc() {
        Account[] accs = new Account[]{};
        for(Integer i = 0; i < 100; i++){
            accs.add(new Account(
                    Name = generateRandomString(30)
            ));
        }

        Contact[] contacts = new Contact[]{};
        for(Account acc : accs){
            for(Integer i = 0; i < 10; i++){
                contacts.add(new Contact(
                        Account = acc
                ));
            }
        }

        Test.startTest();
        SortSobs.descending(contacts, new SObjectField[]{ Contact.AccountId, Account.Name });
        Test.stopTest();

        Contact previousContact = contacts.remove(0);
        for(Contact c : contacts){
            System.assert(previousContact.Account.Name >= c.Account.Name);
            previousContact = c;
        }

    }

    private static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }
}
