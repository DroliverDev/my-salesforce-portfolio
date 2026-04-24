public class SkillMapper {
    public static final String QUERY_FIELDS =
        'Id, Name, Name_EN__c, Category__c, Level__c, Display_Order__c, Portfolio_Profile__c';

    public static SkillDTO toDTO(Portfolio_Skill__c record) {
        if (record == null) {
            return null;
        }

        SkillDTO dto = new SkillDTO();
        dto.id = (String) record.Id;
        dto.name = record.Name;
        dto.nameEn = record.Name_EN__c;
        dto.level = record.Level__c;
        dto.category = record.Category__c;
        dto.profileId = (String) record.Portfolio_Profile__c;
        dto.displayOrder = record.Display_Order__c == null ? null : Integer.valueOf(record.Display_Order__c);
        return dto;
    }

    public static List<SkillDTO> toDTOList(List<Portfolio_Skill__c> records) {
        List<SkillDTO> dtos = new List<SkillDTO>();
        if (records == null) {
            return dtos;
        }

        for (Portfolio_Skill__c record : records) {
            dtos.add(toDTO(record));
        }
        return dtos;
    }

    public static Portfolio_Skill__c toSObject(SkillDTO dto) {
        return applyPartial(new Portfolio_Skill__c(), dto);
    }

    public static Portfolio_Skill__c applyPartial(Portfolio_Skill__c target, SkillDTO dto) {
        if (target == null) {
            target = new Portfolio_Skill__c();
        }
        if (dto == null) {
            return target;
        }

        if (dto.name != null) {
            target.Name = dto.name;
        }
        if (dto.nameEn != null) {
            target.Name_EN__c = dto.nameEn;
        }
        if (dto.category != null) {
            target.Category__c = dto.category;
        }
        if (dto.level != null) {
            target.Level__c = dto.level;
        }
        if (dto.profileId != null) {
            target.Portfolio_Profile__c = (Id) dto.profileId;
        }
        if (dto.displayOrder != null) {
            target.Display_Order__c = dto.displayOrder;
        }

        return target;
    }
}
