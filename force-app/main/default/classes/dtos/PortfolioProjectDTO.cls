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
    @AuraEnabled public List<ProjectSkillDTO> skills;

    public class ProjectSkillDTO {
        @AuraEnabled public String name;
        @AuraEnabled public String category;
        @AuraEnabled public String level;

        public ProjectSkillDTO(String name, String category, String level) {
            this.name = name;
            this.category = category;
            this.level = level;
        }
    }


    public PortfolioProjectDTO(String name, String archNotes, String description, 
     String githubUrl, Boolean isFeatured, String liveDemoUrl, String shortDescription, String slug, String thumbnailUrl, List<ProjectSkillDTO> skills) {
        this.name = name;
        this.archNotes = archNotes;
        this.description = description;
        this.githubUrl = githubUrl;
        this.isFeatured = isFeatured;
        this.liveDemoUrl = liveDemoUrl;
        this.shortDescription = shortDescription;
        this.slug = slug;
        this.thumbnailUrl = thumbnailUrl;
        this.skills = skills;
    }
}