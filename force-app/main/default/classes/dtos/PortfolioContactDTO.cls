public without sharing  class PortfolioContactDTO {
    @AuraEnabled public String name;
    @AuraEnabled public String email;
    @AuraEnabled public String message;
    @AuraEnabled public String status;
    @AuraEnabled public String profileId;

    public PortfolioContactDTO() {
    }

    public PortfolioContactDTO(String name, String email, String message, String status, String profileId) {
        this.name = name;
        this.email = email;
        this.message = message;
        this.status = status;
        this.profileId = profileId;
    }
}