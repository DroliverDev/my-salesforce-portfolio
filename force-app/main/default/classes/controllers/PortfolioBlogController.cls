public without sharing class PortfolioBlogController {
    @AuraEnabled(cacheable=true)
    public static List<Portfolio_Blog_Post__c> getBlogs() {
        return [
            SELECT Id, Name, Slug__c, Status__c, CreatedDate
            FROM Portfolio_Blog_Post__c
            ORDER BY CreatedDate DESC
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Portfolio_Blog_Tag__c> getTags() {
        return [
            SELECT Id, Name
            FROM Portfolio_Blog_Tag__c
            ORDER BY Name ASC
        ];
    }

    @AuraEnabled
    public static Id createBlogWithTags(Portfolio_Blog_Post__c post, List<Id> tagIds, List<String> newTagNames) {
        try {
            if (post == null) {
                throw new AuraHandledException('Blog data is required.');
            }

            insert post;

            Set<Id> allTagIds = new Set<Id>();
            if (tagIds != null) {
                allTagIds.addAll(tagIds);
            }

            if (newTagNames != null && !newTagNames.isEmpty()) {
                Set<String> normalizedNames = new Set<String>();
                for (String rawName : newTagNames) {
                    if (String.isBlank(rawName)) {
                        continue;
                    }

                    normalizedNames.add(rawName.trim());
                }

                if (!normalizedNames.isEmpty()) {
                    Map<String, Id> existingTagNameToId = new Map<String, Id>();
                    for (Portfolio_Blog_Tag__c tag : [
                        SELECT Id, Name
                        FROM Portfolio_Blog_Tag__c
                        WHERE Name IN :normalizedNames
                    ]) {
                        existingTagNameToId.put(tag.Name, tag.Id);
                    }

                    List<Portfolio_Blog_Tag__c> tagsToInsert = new List<Portfolio_Blog_Tag__c>();
                    for (String tagName : normalizedNames) {
                        if (!existingTagNameToId.containsKey(tagName)) {
                            tagsToInsert.add(new Portfolio_Blog_Tag__c(Name = tagName));
                        }
                    }

                    if (!tagsToInsert.isEmpty()) {
                        insert tagsToInsert;
                        for (Portfolio_Blog_Tag__c createdTag : tagsToInsert) {
                            existingTagNameToId.put(createdTag.Name, createdTag.Id);
                        }
                    }

                    allTagIds.addAll(existingTagNameToId.values());
                }
            }

            if (!allTagIds.isEmpty()) {
                List<Portfolio_Post_Tag__c> junctionRecords = new List<Portfolio_Post_Tag__c>();
                for (Id tagId : allTagIds) {
                    if (tagId == null) {
                        continue;
                    }

                    junctionRecords.add(
                        new Portfolio_Post_Tag__c(
                            Portfolio_Blog_Post__c = post.Id,
                            Portfolio_Blog_Tag__c = tagId
                        )
                    );
                }

                if (!junctionRecords.isEmpty()) {
                    insert junctionRecords;
                }
            }

            return post.Id;
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw new AuraHandledException('We could not create the blog post right now. Please try again.');
        }
    }
}
