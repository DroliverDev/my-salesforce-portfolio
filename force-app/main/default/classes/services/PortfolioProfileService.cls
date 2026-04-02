public with sharing class PortfolioProfileService {
    public static PortfolioProfileDTO getProfile(String Id) {
        Portfolio_Profile__c record = PortfolioProfileSelector.getPortfolioProfile(Id);
        return PortfolioProfileDomain.toDTO(record);
    }
}