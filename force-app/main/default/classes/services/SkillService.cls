public without sharing class SkillService {
    public static List<SkillDTO> getAll() {
        List<Portfolio_Skill__c> records = Database.query(
            'SELECT ' + SkillMapper.QUERY_FIELDS +
            ' FROM Portfolio_Skill__c' +
            ' ORDER BY Display_Order__c ASC, Name ASC'
        );

        return SkillMapper.toDTOList(records);
    }

    public static SkillDTO getById(Id id) {
        List<Portfolio_Skill__c> records = Database.query(
            'SELECT ' + SkillMapper.QUERY_FIELDS +
            ' FROM Portfolio_Skill__c' +
            ' WHERE Id = :id' +
            ' LIMIT 1'
        );

        return records.isEmpty() ? null : SkillMapper.toDTO(records[0]);
    }

    public static SkillDTO create(SkillDTO dto) {
        validateForCreate(dto);

        Portfolio_Skill__c record = SkillMapper.toSObject(dto);
        insert record;

        return SkillMapper.toDTO(record);
    }

    public static SkillDTO updateById(Id id, SkillDTO dto) {
        if (dto == null) {
            throw new PortfolioService.ValidationException('Request body is required.');
        }

        List<Portfolio_Skill__c> records = Database.query(
            'SELECT ' + SkillMapper.QUERY_FIELDS +
            ' FROM Portfolio_Skill__c' +
            ' WHERE Id = :id' +
            ' LIMIT 1'
        );

        if (records.isEmpty()) {
            throw new PortfolioService.NotFoundException('Skill not found.');
        }

        Portfolio_Skill__c existing = records[0];
        SkillMapper.applyPartial(existing, dto);
        update existing;

        return SkillMapper.toDTO(existing);
    }

    public static void deleteById(Id id) {
        List<Portfolio_Skill__c> records = [SELECT Id FROM Portfolio_Skill__c WHERE Id = :id LIMIT 1];
        if (records.isEmpty()) {
            throw new PortfolioService.NotFoundException('Skill not found.');
        }

        delete records[0];
    }

    private static void validateForCreate(SkillDTO dto) {
        if (dto == null) {
            throw new PortfolioService.ValidationException('Request body is required.');
        }

        PortfolioService.validateRequired(dto.name, 'name');
    }
}
