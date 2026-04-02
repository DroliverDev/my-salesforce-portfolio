public with sharing class PortfolioProjectService {
    public static List<PortfolioProjectDTO> getProjects(String profileId) {
        List<Portfolio_Project__c> records =
            PortfolioProjectSelector.getPublishedProjects(profileId);

        return PortfolioProjectDomain.toDTO(records);
    }
}