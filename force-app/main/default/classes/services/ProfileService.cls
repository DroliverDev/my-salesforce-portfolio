public without sharing class ProfileService {
    public static ProfileDTO getDefault() {
        List<Portfolio_Profile__c> records = Database.query(
            'SELECT ' + ProfileMapper.QUERY_FIELDS +
            ' FROM Portfolio_Profile__c' +
            ' ORDER BY CreatedDate DESC' +
            ' LIMIT 1'
        );

        return records.isEmpty() ? null : ProfileMapper.toDTO(records[0]);
    }

    public static ProfileDTO getById(Id id) {
        List<Portfolio_Profile__c> records = Database.query(
            'SELECT ' + ProfileMapper.QUERY_FIELDS +
            ' FROM Portfolio_Profile__c' +
            ' WHERE Id = :id' +
            ' LIMIT 1'
        );

        return records.isEmpty() ? null : ProfileMapper.toDTO(records[0]);
    }

    public static ProfileDTO create(ProfileDTO dto) {
        validateForCreate(dto);

        Portfolio_Profile__c record = ProfileMapper.toSObject(dto);
        insert record;

        return ProfileMapper.toDTO(record);
    }

    public static ProfileDTO updateById(Id id, ProfileDTO dto) {
        if (dto == null) {
            throw new PortfolioService.ValidationException('Request body is required.');
        }

        List<Portfolio_Profile__c> records = Database.query(
            'SELECT ' + ProfileMapper.QUERY_FIELDS +
            ' FROM Portfolio_Profile__c' +
            ' WHERE Id = :id' +
            ' LIMIT 1'
        );

        if (records.isEmpty()) {
            throw new PortfolioService.NotFoundException('Profile not found.');
        }

        Portfolio_Profile__c existing = records[0];
        ProfileMapper.applyPartial(existing, dto);
        update existing;

        return ProfileMapper.toDTO(existing);
    }

    public static void deleteById(Id id) {
        List<Portfolio_Profile__c> records = [SELECT Id FROM Portfolio_Profile__c WHERE Id = :id LIMIT 1];
        if (records.isEmpty()) {
            throw new PortfolioService.NotFoundException('Profile not found.');
        }

        delete records[0];
    }

    private static void validateForCreate(ProfileDTO dto) {
        if (dto == null) {
            throw new PortfolioService.ValidationException('Request body is required.');
        }

        PortfolioService.validateRequired(dto.name, 'name');
    }
}
