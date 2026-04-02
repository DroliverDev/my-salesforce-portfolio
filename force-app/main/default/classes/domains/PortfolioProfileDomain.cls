public with sharing class PortfolioProfileDomain {
    public static PortfolioProfileDTO toDTO(Portfolio_Profile__c record) {
        if (record == null) return null;

        return new PortfolioProfileDTO(
            record.Name,
            record.Title__c,
            record.Bio__c,
            record.Profile_Image_Url__c,
            record.LinkedIn_Url__c,
            record.Github_Url__c,
            record.Email__c,
            record.Phone__c,
            record.Whatsapp_Phone__c,
            (record.Years_Experience__c == null ? null : Double.valueOf(record.Years_Experience__c))
        );
    }
}