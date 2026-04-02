public with sharing class PortfolioProfileController {
    @AuraEnabled(cacheable=true)
    public static PortfolioProfileDTO getProfile(String Id) {
        return PortfolioProfileService.getProfile(Id);
    }
}