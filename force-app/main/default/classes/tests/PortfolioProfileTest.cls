@IsTest
private class PortfolioProfileTest {

    @TestSetup
    static void setupData() {
        Portfolio_Profile__c profile = new Portfolio_Profile__c();
        profile.Name = 'Test Profile';
        profile.Title__c = 'Senior Developer';
        profile.Bio__c = 'Passionate about Salesforce.';
        profile.Profile_Image_Url__c = 'https://example.com/profile.jpg';
        profile.LinkedIn_Url__c = 'https://www.linkedin.com/in/test';
        profile.Github_Url__c = 'https://github.com/test';
        profile.Email__c = 'test@example.com';
        profile.Phone__c = '11999998888';
        profile.Whatsapp_Phone__c = '11999997777';
        profile.Career_Start_Date__c = Date.newInstance(2018, 1, 1);
        insert profile;

        Portfolio_Skill__c skill1 = new Portfolio_Skill__c();
        skill1.Portfolio_Profile__c = profile.Id;
        skill1.category__c = 'Backend';
        skill1.Name = 'Apex';
        skill1.Level__c = 'Advanced';
        insert skill1;
    }

    @IsTest
    static void testSetupDataExists() {
        // Verify that the TestSetup inserted exactly one profile
        List<Portfolio_Profile__c> profiles = [
            SELECT Id, Name, Title__c, Years_Experience__c
            FROM Portfolio_Profile__c
        ];
        System.assertEquals(1, profiles.size(), 'Expected one Portfolio_Profile__c from @TestSetup');
        System.assertEquals('Test Profile', profiles[0].Name, 'Unexpected Name from setup');
        System.assertEquals('Senior Developer', profiles[0].Title__c, 'Unexpected Title from setup');
        
    }
    @isTest
    static void getPortfolioProfileTest() {
        // Call the method to get the portfolio profile
        Id profileId = [SELECT Id FROM Portfolio_Profile__c LIMIT 1].Id;
        PortfolioProfileDTO profile = PortfolioProfileController.getProfile(profileId);

        // Verify that the returned profile is not null and has expected values
        System.assertNotEquals(null, profile, 'Expected a Portfolio_Profile__c record to be returned');
        System.assertEquals('Test Profile', profile.Name, 'Unexpected Name from getPortfolioProfile');
        System.assertEquals('Senior Developer', profile.title, 'Unexpected Title from getPortfolioProfile');
        System.assertEquals('Backend', profile.skills[0].category, 'Unexpected Skill Category from getPortfolioProfile');
        System.assertEquals('Apex', profile.skills[0].name, 'Unexpected Skill Name from getPortfolioProfile');
        System.assertEquals('Advanced', profile.skills[0].level, 'Unexpected Skill Level from getPortfolioProfile');
    }
}