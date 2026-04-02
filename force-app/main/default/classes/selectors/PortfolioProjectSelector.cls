public with sharing class PortfolioProjectSelector {

    public static List<Portfolio_Project__c> getPublishedProjects(String profileId) {
        return [
            SELECT Name, Architecture_Notes__c, Description__c, Github_Url__c, Is_Featured__c, Live_Demo_Url__c, Short_Description__c, Slug__c, Thumbnail_Url__c,
            (SELECT Id,
                           Name,
                           Category__c,
                           Level__c
                    FROM Project_Skills__r)
            FROM Portfolio_Project__c
            WHERE Portfolio_Profile__c = :profileId
            ORDER BY CreatedDate Desc
        ];
    }
}