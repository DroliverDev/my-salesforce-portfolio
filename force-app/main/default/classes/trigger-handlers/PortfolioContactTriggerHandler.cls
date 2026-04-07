public with sharing class PortfolioContactTriggerHandler extends CoreTriggerHandler {
    private final List<Portfolio_Contact__c> newContacts = (List<Portfolio_Contact__c>) Trigger.new;

    public override void afterInsert() {
        PortfolioContactService.sendNotificationEmails(newContacts);
    }
}