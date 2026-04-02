public class PortfolioProjectDTO {
    @AuraEnabled public String name;
    @AuraEnabled public String archNotes;
    @AuraEnabled public String description;
    @AuraEnabled public String githubUrl;
    @AuraEnabled public Boolean isFeatured;
    @AuraEnabled public String liveDemoUrl;
    @AuraEnabled public String shortDescription;
    @AuraEnabled public String slug;
    @AuraEnabled public String thumbnailUrl;

    public PortfolioProjectDTO(String name, String archNotes, String description, 
     String githubUrl, Boolean isFeatured, String liveDemoUrl, String shortDescription, String slug, String thumbnailUrl) {
        this.name = name;
        this.archNotes = archNotes;
        this.description = description;
        this.githubUrl = githubUrl;
        this.isFeatured = isFeatured;
        this.liveDemoUrl = liveDemoUrl;
        this.shortDescription = shortDescription;
        this.slug = slug;
        this.thumbnailUrl = thumbnailUrl;
    }
}