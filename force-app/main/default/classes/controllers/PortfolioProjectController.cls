public without sharing  class PortfolioProjectController {

    @AuraEnabled(cacheable=true)
    public static List<PortfolioProjectDTO> getProjects(String ProfileId) {
        return PortfolioProjectService.getProjects(ProfileId);
    }
}