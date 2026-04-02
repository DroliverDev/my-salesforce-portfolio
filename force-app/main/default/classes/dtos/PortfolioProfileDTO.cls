public with sharing class PortfolioProfileDTO {
    @AuraEnabled public String name;
    @AuraEnabled public String title;
    @AuraEnabled public String bio;
    @AuraEnabled public String profileImageUrl;
    @AuraEnabled public String linkedInUrl;
    @AuraEnabled public String githubUrl;
    @AuraEnabled public String email;
    @AuraEnabled public String phone;
    @AuraEnabled public String wppPhone;
    @AuraEnabled public Double YearOfExperience;

    public PortfolioProfileDTO(String name, String title, String bio, String profileImageUrl, String linkedInUrl, String githubUrl, String email, String phone, String wppPhone, Double YearOfExperience) {
        this.name = name;
        this.title = title;
        this.bio = bio;
        this.profileImageUrl = profileImageUrl;
        this.linkedInUrl = linkedInUrl;
        this.githubUrl = githubUrl;
        this.email = email;
        this.phone = phone;
        this.wppPhone = wppPhone;
        this.YearOfExperience = YearOfExperience;
    }
}