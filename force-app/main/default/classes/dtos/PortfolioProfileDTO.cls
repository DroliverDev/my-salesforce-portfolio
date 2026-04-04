public with sharing class PortfolioProfileDTO {
    @AuraEnabled public String name;
    @AuraEnabled public String title;
    @AuraEnabled public String bio;
    @AuraEnabled public String profileImageUrl;
    @AuraEnabled public String linkedInUrl;
    @AuraEnabled public String githubUrl;
    @AuraEnabled public String trailheadUrl;
    @AuraEnabled public String email;
    @AuraEnabled public String phone;
    @AuraEnabled public String wppPhone;
    @AuraEnabled public Double YearOfExperience;
    @AuraEnabled public List<PortfolioSkillDTO> skills;

    public class PortfolioSkillDTO {
        @AuraEnabled public String name;
        @AuraEnabled public String category;
        @AuraEnabled public String level;
        @AuraEnabled public Integer order;

        public PortfolioSkillDTO(String name, String category, String level, Integer order) {
            this.name = name;
            this.category = category;
            this.level = level;
            this.order = order;
        }
    }

    public PortfolioProfileDTO(String name, String title, String bio, String profileImageUrl, String linkedInUrl, String githubUrl, String trailheadUrl, String email, String phone, String wppPhone, Double YearOfExperience, List<PortfolioSkillDTO> skills) {
        this.name = name;
        this.title = title;
        this.bio = bio;
        this.profileImageUrl = profileImageUrl;
        this.linkedInUrl = linkedInUrl;
        this.githubUrl = githubUrl;
        this.trailheadUrl = trailheadUrl;
        this.email = email;
        this.phone = phone;
        this.wppPhone = wppPhone;
        this.YearOfExperience = YearOfExperience;
        this.skills = skills;
    }
}