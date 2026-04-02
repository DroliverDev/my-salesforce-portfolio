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
         // Create a test contact
        // Build DTO using required constructor (name, email, message, status)
        PortfolioContactDTO contactDTO = new PortfolioContactDTO(
            'John Doe',
            'test@example.com',
            'Hello, this is a test message.',
            'New',
            profile.Id
        );
        // Call the method to save the contact
        Test.startTest();
        PortfolioContactController.saveContact(contactDTO);
        Test.stopTest();
        // Verify that the contact was saved correctly
        List<Portfolio_Contact__c> contacts = [SELECT Id, Contact_Name__c, Email__c, Message__c FROM Portfolio_Contact__c WHERE Email__c = 'test@example.com'];
        System.assertEquals(1, contacts.size());
        System.assertEquals('John Doe', contacts[0].Contact_Name__c);
        System.assertEquals('test@example.com', contacts[0].Email__c);
        System.assertEquals('Hello, this is a test message.', contacts[0].Message__c);
    }
}