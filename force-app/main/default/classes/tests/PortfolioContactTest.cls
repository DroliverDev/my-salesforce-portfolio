@isTest
public with sharing class PortfolioContactTest {
    @TestSetup
    static void makeData(){
        Portfolio_Profile__c profile = new Portfolio_Profile__c(Name = 'Test Profile');
        insert profile;
    }

   @isTest
    static void testPortfolioContact() {
        Portfolio_Profile__c profile = [SELECT Id FROM Portfolio_Profile__c LIMIT 1];
        Map<String, Object> payload = new Map<String, Object>{
            'name' => 'John Doe',
            'email' => 'test@example.com',
            'message' => 'Hello, this is a test message.',
            'status' => 'New',
            'profileId' => profile.Id
        };

        // Call the method to save the contact
        Test.startTest();
        PortfolioContactController.saveContact(payload);
        Test.stopTest();
        // Verify that the contact was saved correctly
        List<Portfolio_Contact__c> contacts = [SELECT Id, Contact_Name__c, Email__c, Message__c FROM Portfolio_Contact__c WHERE Email__c = 'test@example.com'];
        System.assertEquals(1, contacts.size());
        System.assertEquals('John Doe', contacts[0].Contact_Name__c);
        System.assertEquals('test@example.com', contacts[0].Email__c);
        System.assertEquals('Hello, this is a test message.', contacts[0].Message__c);
    }
}