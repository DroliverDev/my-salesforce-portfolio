public without sharing  class PortfolioContactService {
    public static void saveContact(PortfolioContactDTO contactDTO) {
        Portfolio_Contact__c contactRecord = PortfolioContactDomain.createContact(contactDTO);
        insert contactRecord;
    }

    public static void sendNotificationEmails(List<Portfolio_Contact__c> newContacts) {
        if (newContacts == null || newContacts.isEmpty()) {
            return;
        }

        Set<Id> profileIds = new Set<Id>();
        for (Portfolio_Contact__c contactRecord : newContacts) {
            if (contactRecord.Portfolio_Profile__c != null) {
                profileIds.add(contactRecord.Portfolio_Profile__c);
            }
        }

        if (profileIds.isEmpty()) {
            return;
        }

        Map<Id, Portfolio_Profile__c> profilesById = new Map<Id, Portfolio_Profile__c>([
            SELECT Id, Name, Email__c
            FROM Portfolio_Profile__c
            WHERE Id IN :profileIds
        ]);

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for (Portfolio_Contact__c contactRecord : newContacts) {
            Portfolio_Profile__c profile = profilesById.get(contactRecord.Portfolio_Profile__c);
            if (profile == null || String.isBlank(profile.Email__c)) {
                continue;
            }

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{ profile.Email__c });
            email.setSubject('New portfolio contact from ' + String.valueOf(contactRecord.Contact_Name__c));
            email.setPlainTextBody(buildNotificationBody(contactRecord, profile));
            email.setSaveAsActivity(false);

            if (!String.isBlank(contactRecord.Email__c)) {
                email.setReplyTo(contactRecord.Email__c);
            }

            emails.add(email);
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }

    private static String buildNotificationBody(Portfolio_Contact__c contactRecord, Portfolio_Profile__c profile) {
        List<String> lines = new List<String>{
            'A new portfolio contact was created.',
            '',
            'Profile: ' + String.valueOf(profile.Name),
            'Contact Name: ' + String.valueOf(contactRecord.Contact_Name__c),
            'Email: ' + String.valueOf(contactRecord.Email__c),
            'Status: ' + String.valueOf(contactRecord.Status__c),
            'Record Id: ' + String.valueOf(contactRecord.Id),
            '',
            'Message:',
            String.valueOf(contactRecord.Message__c)
        };

        return String.join(lines, '\n');
    }
}