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
    public static Portfolio_Blog_Post__c getBlogById(Id recordId) {
        List<Portfolio_Blog_Post__c> posts = [
            SELECT Id, Name, Slug__c, Content__c, Status__c, Image_URL__c
            FROM Portfolio_Blog_Post__c
            WHERE Id = :recordId
            LIMIT 1
        ];

        if (posts.isEmpty()) {
            throw new AuraHandledException('Blog post not found.');
        }

        return posts[0];
    }

    @AuraEnabled(cacheable=true)
    public static List<Id> getBlogTagIds(Id recordId) {
        List<Id> tagIds = new List<Id>();
        for (Portfolio_Post_Tag__c junction : [
            SELECT Portfolio_Blog_Tag__c
            FROM Portfolio_Post_Tag__c
            WHERE Portfolio_Blog_Post__c = :recordId
        ]) {
            tagIds.add(junction.Portfolio_Blog_Tag__c);
        }
        return tagIds;
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

    @AuraEnabled
    public static Id updateBlogWithTags(Portfolio_Blog_Post__c post, List<Id> tagIds, List<String> newTagNames) {
        try {
            if (post == null || post.Id == null) {
                throw new AuraHandledException('Blog post Id is required for update.');
            }

            update post;

            delete [
                SELECT Id
                FROM Portfolio_Post_Tag__c
                WHERE Portfolio_Blog_Post__c = :post.Id
            ];

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
            throw new AuraHandledException('We could not update the blog post right now. Please try again.');
        }
    }

    @AuraEnabled
    public static String uploadBlogImage(String base64Data, String fileName, Id blogId) {
        try {
            if (String.isBlank(base64Data) || String.isBlank(fileName)) {
                throw new AuraHandledException('Image data and file name are required.');
            }

            String cleanBase64 = base64Data.contains(',')
                ? base64Data.substringAfter(',')
                : base64Data;

            String uniqueFileName = String.valueOf(DateTime.now().getTime()) + '_' + fileName;

            ContentVersion cv = new ContentVersion(
                Title = uniqueFileName,
                PathOnClient = uniqueFileName,
                VersionData = EncodingUtil.base64Decode(cleanBase64),
                IsMajorVersion = true
            );
            insert cv;

            cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];

            if (blogId != null) {
                insert new ContentDocumentLink(
                    ContentDocumentId = cv.ContentDocumentId,
                    LinkedEntityId = blogId,
                    ShareType = 'V',
                    Visibility = 'AllUsers'
                );
            }

            ContentDistribution cd = new ContentDistribution(
                Name = uniqueFileName,
                ContentVersionId = cv.Id,
                PreferencesAllowViewInBrowser = true,
                PreferencesLinkLatestVersion = true,
                PreferencesNotifyOnVisit = false,
                PreferencesPasswordRequired = false,
                PreferencesAllowOriginalDownload = true
            );
            insert cd;

            cd = [SELECT DistributionPublicUrl FROM ContentDistribution WHERE Id = :cd.Id LIMIT 1];

            String publicUrl = cd.DistributionPublicUrl;

            if (blogId != null) {
                update new Portfolio_Blog_Post__c(
                    Id = blogId,
                    Image_URL__c = publicUrl
                );
            }

            return publicUrl;
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw new AuraHandledException('Image upload failed. Please try again.');
        }
    }
}
