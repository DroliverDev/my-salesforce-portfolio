public with sharing class PortfolioProfileController {
    @AuraEnabled(cacheable=true)
    public static PortfolioProfileDTO getProfile(String Id) {
        return PortfolioProfileService.getProfile(Id);
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getSkillCategories() {
        List<String> categories = new List<String>();
        
        // Get picklist values from Portfolio_Skill__c.Category__c field
        SObjectType skillObject = Schema.getGlobalDescribe().get('Portfolio_Skill__c');
        
        if (skillObject == null) {
            return categories;
        }

        DescribeSObjectResult skillDescribe = skillObject.getDescribe();
        DescribeFieldResult categoryField = skillDescribe.fields.getMap().get('Category__c').getDescribe();

        if (categoryField.getType() == DisplayType.PICKLIST) {
            for (PicklistEntry entry : categoryField.getPicklistValues()) {
                String label = entry.getLabel();
                // Exclude 'Language' category
                //if (!label.equals('Language')) {
                    categories.add(label);
                //}
            }
        }

        return categories;
    }
}