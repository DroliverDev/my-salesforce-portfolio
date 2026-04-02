public with sharing class PortfolioProfileSelector {
    public static Portfolio_Profile__c getPortfolioProfile(String Id) {
        Portfolio_Profile__c profile = [
            SELECT Name, Title__c, Bio__c, Profile_Image_Url__c, LinkedIn_Url__c, Github_Url__c, Email__c, Phone__c, Whatsapp_Phone__c, Years_Experience__c
            FROM Portfolio_Profile__c
            WHERE Id = :Id
            LIMIT 1
        ];
        return profile;
    }
}