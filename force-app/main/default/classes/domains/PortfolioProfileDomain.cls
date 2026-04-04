public without sharing class PortfolioProfileDomain {
    public static PortfolioProfileDTO toDTO(Portfolio_Profile__c record) {
        if (record == null) return null;

        List<PortfolioProfileDTO.PortfolioSkillDTO> skillDTOList = new List<PortfolioProfileDTO.PortfolioSkillDTO>();

        if (record.Portfolio_Skills__r != null) {
            for (Portfolio_Skill__c skill : record.Portfolio_Skills__r) {
                skillDTOList.add(new PortfolioProfileDTO.PortfolioSkillDTO(
                    skill.Name,
                    skill.Category__c,
                    skill.Level__c,
                    (skill.Display_Order__c == null ? null : Integer.valueOf(skill.Display_Order__c))
                ));
            }
        }
        return new PortfolioProfileDTO(
            record.Name,
            record.Title__c,
            record.Bio__c,
            record.Profile_Image_Url__c,
            record.LinkedIn_Url__c,
            record.Github_Url__c,
            record.Trailhead_URL__c,
            record.Email__c,
            record.Phone__c,
            record.Whatsapp_Phone__c,
            (record.Years_Experience__c == null ? null : Double.valueOf(record.Years_Experience__c)),
            skillDTOList
        );
    }
}
