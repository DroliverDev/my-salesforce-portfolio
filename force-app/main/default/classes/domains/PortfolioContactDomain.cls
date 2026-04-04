public without sharing  class PortfolioContactDomain {
    public static Portfolio_Contact__c createContact(PortfolioContactDTO contactDTO) {
        Portfolio_Contact__c contactRecord = new Portfolio_Contact__c();
        contactRecord.Contact_Name__c = contactDTO.name;
        contactRecord.Email__c = contactDTO.email;
        contactRecord.Message__c = contactDTO.message;
        contactRecord.Status__c = 'New';
        contactRecord.Portfolio_Profile__c = contactDTO.profileId;
        return contactRecord;
    }
}