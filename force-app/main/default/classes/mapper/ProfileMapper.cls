public class ProfileMapper {
    public static final String QUERY_FIELDS =
        'Id, Name, Title__c, Title_EN__c, Bio__c, Bio_EN__c, Profile_Image_URL__c, Linkedin_URL__c, Github_URL__c, Trailhead_URL__c, Email__c, Phone__c, Whatsapp_Phone__c, Location__c';

    public static ProfileDTO toDTO(Portfolio_Profile__c record) {
        if (record == null) {
            return null;
        }

        ProfileDTO dto = new ProfileDTO();
        dto.id = (String) record.Id;
        dto.name = record.Name;
        dto.title = record.Title__c;
        dto.titleEn = record.Title_EN__c;
        dto.bio = record.Bio__c;
        dto.bioEn = record.Bio_EN__c;
        dto.profileImageUrl = record.Profile_Image_URL__c;
        dto.linkedInUrl = record.Linkedin_URL__c;
        dto.githubUrl = record.Github_URL__c;
        dto.trailheadUrl = record.Trailhead_URL__c;
        dto.email = record.Email__c;
        dto.phone = record.Phone__c;
        dto.whatsappPhone = record.Whatsapp_Phone__c;
        dto.location = record.Location__c;
        return dto;
    }

    public static Portfolio_Profile__c toSObject(ProfileDTO dto) {
        return applyPartial(new Portfolio_Profile__c(), dto);
    }

    public static Portfolio_Profile__c applyPartial(Portfolio_Profile__c target, ProfileDTO dto) {
        if (target == null) {
            target = new Portfolio_Profile__c();
        }
        if (dto == null) {
            return target;
        }

        if (dto.name != null) {
            setIfUpdateable(target, 'Name', dto.name);
        }
        if (dto.title != null) {
            setIfUpdateable(target, 'Title__c', dto.title);
        }
        if (dto.titleEn != null) {
            setIfUpdateable(target, 'Title_EN__c', dto.titleEn);
        }
        if (dto.bio != null) {
            setIfUpdateable(target, 'Bio__c', dto.bio);
        }
        if (dto.bioEn != null) {
            setIfUpdateable(target, 'Bio_EN__c', dto.bioEn);
        }
        if (dto.profileImageUrl != null) {
            setIfUpdateable(target, 'Profile_Image_URL__c', dto.profileImageUrl);
        }
        if (dto.linkedInUrl != null) {
            setIfUpdateable(target, 'Linkedin_URL__c', dto.linkedInUrl);
        }
        if (dto.githubUrl != null) {
            setIfUpdateable(target, 'Github_URL__c', dto.githubUrl);
        }
        if (dto.trailheadUrl != null) {
            setIfUpdateable(target, 'Trailhead_URL__c', dto.trailheadUrl);
        }
        if (dto.email != null) {
            setIfUpdateable(target, 'Email__c', dto.email);
        }
        if (dto.phone != null) {
            setIfUpdateable(target, 'Phone__c', dto.phone);
        }
        if (dto.whatsappPhone != null) {
            setIfUpdateable(target, 'Whatsapp_Phone__c', dto.whatsappPhone);
        }
        if (dto.location != null) {
            setIfUpdateable(target, 'Location__c', dto.location);
        }

        return target;
    }

    private static void setIfUpdateable(Portfolio_Profile__c target, String fieldApiName, Object value) {
        Schema.DescribeFieldResult fieldDescribe =
            Portfolio_Profile__c.SObjectType.getDescribe().fields.getMap().get(fieldApiName).getDescribe();

        if (fieldDescribe != null && fieldDescribe.isUpdateable()) {
            target.put(fieldApiName, value);
        }
    }
}
