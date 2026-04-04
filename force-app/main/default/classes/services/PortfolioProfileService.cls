public without sharing  class PortfolioProfileService {
    public static PortfolioProfileDTO getProfile(String Id) {
        Portfolio_Profile__c record = PortfolioProfileSelector.getPortfolioProfilesWithSkills(Id);
        return PortfolioProfileDomain.toDTO(record);
    }
}