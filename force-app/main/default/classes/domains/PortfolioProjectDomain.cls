public class PortfolioProjectDomain {

    public static List<PortfolioProjectDTO> toDTO(List<Portfolio_Project__c> records) {
        List<PortfolioProjectDTO> dtos = new List<PortfolioProjectDTO>();

        for (Portfolio_Project__c rec : records) {
            dtos.add(new PortfolioProjectDTO(
                rec.Name,
                rec.Architecture_Notes__c,
                rec.Description__c,
                rec.GitHub_URL__c,
                rec.Is_Featured__c,
                rec.Live_Demo_Url__c,
                rec.Short_Description__c,
                rec.Slug__c,
                rec.Thumbnail_Url__c
            ));
        }

        return dtos;
    }
}