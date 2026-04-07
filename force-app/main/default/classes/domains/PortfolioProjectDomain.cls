public class PortfolioProjectDomain {

    public static List<PortfolioProjectDTO> toDTO(List<Portfolio_Project__c> records) {
        List<PortfolioProjectDTO> dtos = new List<PortfolioProjectDTO>();

        for (Portfolio_Project__c rec : records) {
            List<PortfolioProjectDTO.ProjectSkillDTO> skillDTOList =
                new List<PortfolioProjectDTO.ProjectSkillDTO>();

            if (rec.Project_Skills__r != null) {
                for (Project_Skill__c skill : rec.Project_Skills__r) {
                    if (skill.Portfolio_Skill__r == null) {
                        continue;
                    }

                    PortfolioProjectDTO.ProjectSkillDTO dto =
                        new PortfolioProjectDTO.ProjectSkillDTO(
                            skill.Portfolio_Skill__r.Name,
                            skill.Portfolio_Skill__r.Category__c,
                            skill.Portfolio_Skill__r.Level__c
                        );
                    skillDTOList.add(dto);
                }
            }

            dtos.add(new PortfolioProjectDTO(
                rec.Name,
                rec.Architecture_Notes__c,
                rec.Description__c,
                rec.GitHub_URL__c,
                rec.Is_Featured__c,
                rec.Live_Demo_Url__c,
                rec.Short_Description__c,
                rec.Slug__c,
                rec.Thumbnail_Url__c,
                skillDTOList
            ));
        }

        return dtos;
    }
}