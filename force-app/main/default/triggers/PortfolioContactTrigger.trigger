trigger PortfolioContactTrigger on Portfolio_Contact__c (before insert, before update, after insert, after update, before delete, after delete, after undelete) {
    new PortfolioContactTriggerHandler().run();

}