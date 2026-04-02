@isTest
public class PortfolioProjectTest {
    @TestSetup
    static void setupData() {
        // Create a Portfolio Profile to link with the project
        Portfolio_Profile__c profile = new Portfolio_Profile__c();
        profile.Name = 'Test Profile for Project';
        profile.Title__c = 'Project Manager';
        profile.Bio__c = 'Experienced in managing Salesforce projects.';
        profile.Profile_Image_Url__c = 'https://example.com/profile_project.jpg';
        profile.LinkedIn_Url__c = 'https://www.linkedin.com/in/testproject';
        profile.Github_Url__c = 'https://github.com/testproject';
        insert profile;

        Portfolio_Project__c project = new Portfolio_Project__c(
            Portfolio_Profile__c = profile.Id,    
            Name = 'Test Project',
            Description__c = 'A test project for Apex unit testing.',
            Short_Description__c = 'Test project',
            Slug__c = 'test-project',
            Architecture_Notes__c = 'MVC',
            GitHub_URL__c = 'https://github.com/testproject',
            Is_Featured__c = true,
            Live_Demo_URL__c = 'https://example.com/demo',
            Thumbnail_URL__c = 'https://example.com/project.jpg'
        );
        insert project;

        Project_Skill__c skill = new Project_Skill__c(
            Portfolio_Project__c = project.Id,
            Portfolio_profile__c = profile.Id,
            Name = 'Apex',
            category__c = 'Backend',
            level__c = 'Advanced'
        );
        insert skill;
    }

    @isTest
    static void testGetPortfolioProjects() {
        Portfolio_Profile__c profile = [SELECT Id FROM Portfolio_Profile__c WHERE Name = 'Test Profile for Project' LIMIT 1];
        // Call the method to get portfolio projects by Profile Id
        List<PortfolioProjectDTO> projects = PortfolioProjectController.getProjects(profile.Id);
        // Verify that the returned list is not null and contains the expected project
        System.assertNotEquals(null, projects, 'Expected a list of Portfolio_Project__c records to be returned');
        System.assertEquals(1, projects.size(), 'Expected exactly one Portfolio_Project__c record to be returned');
        System.assertEquals('Test Project', projects[0].Name, 'Unexpected Name from getPortfolioProjects');
        System.assertEquals('A test project for Apex unit testing.', projects[0].description, 'Unexpected Description from getPortfolioProjects');
        System.assertEquals('test-project', projects[0].slug, 'Unexpected Slug from getPortfolioProjects');
        System.assertEquals(true, projects[0].isFeatured, 'Unexpected isFeatured from getPortfolioProjects');
        System.assertEquals('https://example.com/demo', projects[0].liveDemoUrl, 'Unexpected liveDemoUrl from getPortfolioProjects');
        System.assertEquals('https://example.com/project.jpg', projects[0].thumbnailUrl, 'Unexpected thumbnailUrl from getPortfolioProjects');
        System.assertEquals(1, projects[0].skills.size(), 'Expected exactly one skill for the project');
        System.assertEquals('Apex', projects[0].skills[0].name, 'Unexpected skill name from getPortfolioProjects');
        System.assertEquals('Backend', projects[0].skills[0].category, 'Unexpected skill category from getPortfolioProjects');
        System.assertEquals('Advanced', projects[0].skills[0].level, 'Unexpected skill level from getPortfolioProjects');
    }
}