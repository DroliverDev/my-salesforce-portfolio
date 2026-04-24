public without sharing class ProjectService {
    public static List<ProjectDTO> getAll() {
        List<Portfolio_Project__c> projects = Database.query(
            'SELECT ' + ProjectMapper.QUERY_FIELDS +
            ' FROM Portfolio_Project__c' +
            ' ORDER BY CreatedDate DESC'
        );

        return toDTOs(projects);
    }

    public static ProjectDTO getById(Id id) {
        List<Portfolio_Project__c> projects = Database.query(
            'SELECT ' + ProjectMapper.QUERY_FIELDS +
            ' FROM Portfolio_Project__c' +
            ' WHERE Id = :id' +
            ' LIMIT 1'
        );

        if (projects.isEmpty()) {
            return null;
        }

        Map<Id, List<String>> techStackByProjectId = fetchTechStack(new Set<Id>{ projects[0].Id });
        return ProjectMapper.toDTO(projects[0], techStackByProjectId.get(projects[0].Id));
    }

    public static ProjectDTO create(ProjectDTO dto) {
        validateForCreate(dto);

        Portfolio_Project__c record = ProjectMapper.toSObject(dto);
        insert record;

        syncTechStack(record.Id, dto.techStack, record.Portfolio_Profile__c);
        return getById(record.Id);
    }

    public static ProjectDTO updateById(Id id, ProjectDTO dto) {
        if (dto == null) {
            throw new PortfolioService.ValidationException('Request body is required.');
        }

        List<Portfolio_Project__c> records = Database.query(
            'SELECT ' + ProjectMapper.QUERY_FIELDS +
            ' FROM Portfolio_Project__c' +
            ' WHERE Id = :id' +
            ' LIMIT 1'
        );

        if (records.isEmpty()) {
            throw new PortfolioService.NotFoundException('Project not found.');
        }

        Portfolio_Project__c existing = records[0];
        ProjectMapper.applyPartial(existing, dto);
        update existing;

        syncTechStack(existing.Id, dto.techStack, existing.Portfolio_Profile__c);
        return getById(existing.Id);
    }

    public static void deleteById(Id id) {
        List<Portfolio_Project__c> records = [SELECT Id FROM Portfolio_Project__c WHERE Id = :id LIMIT 1];
        if (records.isEmpty()) {
            throw new PortfolioService.NotFoundException('Project not found.');
        }

        delete records[0];
    }

    private static List<ProjectDTO> toDTOs(List<Portfolio_Project__c> projects) {
        List<ProjectDTO> dtos = new List<ProjectDTO>();
        if (projects.isEmpty()) {
            return dtos;
        }

        Set<Id> projectIds = new Set<Id>();
        for (Portfolio_Project__c project : projects) {
            projectIds.add(project.Id);
        }

        Map<Id, List<String>> techStackByProjectId = fetchTechStack(projectIds);

        for (Portfolio_Project__c project : projects) {
            dtos.add(ProjectMapper.toDTO(project, techStackByProjectId.get(project.Id)));
        }

        return dtos;
    }

    private static Map<Id, List<String>> fetchTechStack(Set<Id> projectIds) {
        Map<Id, List<String>> techStackByProjectId = new Map<Id, List<String>>();
        if (projectIds == null || projectIds.isEmpty()) {
            return techStackByProjectId;
        }

        for (Project_Skill__c link : [
            SELECT Portfolio_Project__c, Portfolio_Skill__r.Name
            FROM Project_Skill__c
            WHERE Portfolio_Project__c IN :projectIds
            ORDER BY CreatedDate ASC
        ]) {
            if (link.Portfolio_Project__c == null || link.Portfolio_Skill__r == null) {
                continue;
            }
            if (!techStackByProjectId.containsKey(link.Portfolio_Project__c)) {
                techStackByProjectId.put(link.Portfolio_Project__c, new List<String>());
            }
            techStackByProjectId.get(link.Portfolio_Project__c).add(link.Portfolio_Skill__r.Name);
        }

        return techStackByProjectId;
    }

    private static void syncTechStack(Id projectId, List<String> techStack, Id profileId) {
        if (techStack == null) {
            return;
        }

        List<Project_Skill__c> existingLinks = [SELECT Id FROM Project_Skill__c WHERE Portfolio_Project__c = :projectId];
        if (!existingLinks.isEmpty()) {
            delete existingLinks;
        }

        Set<String> normalizedNames = new Set<String>();
        for (String rawName : techStack) {
            String cleaned = rawName == null ? null : rawName.trim();
            if (!String.isBlank(cleaned)) {
                normalizedNames.add(cleaned);
            }
        }

        if (normalizedNames.isEmpty()) {
            return;
        }

        List<Portfolio_Skill__c> matchedSkills;
        if (profileId == null) {
            matchedSkills = [
                SELECT Id, Name
                FROM Portfolio_Skill__c
                WHERE Name IN :normalizedNames
            ];
        } else {
            matchedSkills = [
                SELECT Id, Name
                FROM Portfolio_Skill__c
                WHERE Name IN :normalizedNames
                AND Portfolio_Profile__c = :profileId
            ];
        }

        Map<String, Id> skillIdByName = new Map<String, Id>();
        for (Portfolio_Skill__c skill : matchedSkills) {
            if (!skillIdByName.containsKey(skill.Name)) {
                skillIdByName.put(skill.Name, skill.Id);
            }
        }

        List<Portfolio_Skill__c> newSkills = new List<Portfolio_Skill__c>();
        for (String skillName : normalizedNames) {
            if (!skillIdByName.containsKey(skillName)) {
                Portfolio_Skill__c skill = new Portfolio_Skill__c(Name = skillName);
                if (profileId != null) {
                    skill.Portfolio_Profile__c = profileId;
                }
                newSkills.add(skill);
            }
        }

        if (!newSkills.isEmpty()) {
            insert newSkills;
            for (Portfolio_Skill__c skill : newSkills) {
                skillIdByName.put(skill.Name, skill.Id);
            }
        }

        List<Project_Skill__c> linksToInsert = new List<Project_Skill__c>();
        for (String skillName : normalizedNames) {
            Id skillId = skillIdByName.get(skillName);
            if (skillId == null) {
                continue;
            }

            linksToInsert.add(new Project_Skill__c(
                Portfolio_Project__c = projectId,
                Portfolio_Skill__c = skillId
            ));
        }

        if (!linksToInsert.isEmpty()) {
            insert linksToInsert;
        }
    }

    private static void validateForCreate(ProjectDTO dto) {
        if (dto == null) {
            throw new PortfolioService.ValidationException('Request body is required.');
        }

        PortfolioService.validateRequired(dto.name, 'name');
    }
}
