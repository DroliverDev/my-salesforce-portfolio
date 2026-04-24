public class ProjectMapper {
    public static final String QUERY_FIELDS =
        'Id, Name, Name_EN__c, Description__c, Description_EN__c, Short_Description__c, Short_Description_EN__c, Slug__c, Architecture_Notes__c, Thumbnail_URL__c, GitHub_URL__c, Live_Demo_URL__c, Is_Featured__c, Portfolio_Profile__c';

    public static ProjectDTO toDTO(Portfolio_Project__c record, List<String> techStack) {
        if (record == null) {
            return null;
        }

        ProjectDTO dto = new ProjectDTO();
        dto.id = (String) record.Id;
        dto.name = record.Name;
        dto.nameEn = record.Name_EN__c;
        dto.description = record.Description__c;
        dto.descriptionEn = record.Description_EN__c;
        dto.shortDescription = record.Short_Description__c;
        dto.shortDescriptionEn = record.Short_Description_EN__c;
        dto.slug = record.Slug__c;
        dto.architectureNotes = record.Architecture_Notes__c;
        dto.imageUrl = record.Thumbnail_URL__c;
        dto.githubUrl = record.GitHub_URL__c;
        dto.projectUrl = record.Live_Demo_URL__c;
        dto.isFeatured = record.Is_Featured__c;
        dto.profileId = (String) record.Portfolio_Profile__c;
        dto.techStack = techStack == null ? new List<String>() : techStack;
        return dto;
    }

    public static Portfolio_Project__c toSObject(ProjectDTO dto) {
        return applyPartial(new Portfolio_Project__c(), dto);
    }

    public static Portfolio_Project__c applyPartial(Portfolio_Project__c target, ProjectDTO dto) {
        if (target == null) {
            target = new Portfolio_Project__c();
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
        if (dto.description != null) {
            target.Description__c = dto.description;
        }
        if (dto.descriptionEn != null) {
            target.Description_EN__c = dto.descriptionEn;
        }
        if (dto.shortDescription != null) {
            target.Short_Description__c = dto.shortDescription;
        }
        if (dto.shortDescriptionEn != null) {
            target.Short_Description_EN__c = dto.shortDescriptionEn;
        }
        if (dto.slug != null) {
            target.Slug__c = dto.slug;
        }
        if (dto.architectureNotes != null) {
            target.Architecture_Notes__c = dto.architectureNotes;
        }
        if (dto.imageUrl != null) {
            target.Thumbnail_URL__c = dto.imageUrl;
        }
        if (dto.githubUrl != null) {
            target.GitHub_URL__c = dto.githubUrl;
        }
        if (dto.projectUrl != null) {
            target.Live_Demo_URL__c = dto.projectUrl;
        }
        if (dto.isFeatured != null) {
            target.Is_Featured__c = dto.isFeatured;
        }
        if (dto.profileId != null) {
            target.Portfolio_Profile__c = (Id) dto.profileId;
        }

        return target;
    }
}
