public with sharing class PortfolioContactController {
    @AuraEnabled
    public static void saveContact(PortfolioContactDTO contactDTO) {
        PortfolioContactService.saveContact(contactDTO);
    }
}