public with sharing class PortfolioContactController {
    @AuraEnabled
    public static void saveContact(Map<String, Object> payload) {
        try {
            PortfolioContactDTO contactDTO = new PortfolioContactDTO();
            contactDTO.name = (String) payload.get('name');
            contactDTO.email = (String) payload.get('email');
            contactDTO.message = (String) payload.get('message');
            contactDTO.status = (String) payload.get('status');
            contactDTO.profileId = (String) payload.get('profileId');

            PortfolioContactService.saveContact(contactDTO);
        } catch (Exception e) {
            throw new AuraHandledException('We could not send your message right now. Please try again in a moment.');
        }
    }
}