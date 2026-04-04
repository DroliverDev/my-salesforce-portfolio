public without sharing  class PortfolioContactService {
    public static void saveContact(PortfolioContactDTO contactDTO) {
        Portfolio_Contact__c contactRecord = PortfolioContactDomain.createContact(contactDTO);
        insert contactRecord;
    }
}