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

    public static Portfolio_Profile__c getPortfolioProfilesWithSkills(String id) {
        Portfolio_Profile__c profile = [
                 SELECT Id, Name, Title__c, Bio__c, Profile_Image_Url__c, LinkedIn_Url__c, Github_Url__c, Trailhead_URL__c, Email__c, 
                   Phone__c, Whatsapp_Phone__c, Years_Experience__c,
                   (SELECT Id, Name, Category__c, Level__c, Display_Order__c FROM Portfolio_Skills__r)
            FROM Portfolio_Profile__c
            WHERE Id = :id
        ];

        return profile;
    }
}