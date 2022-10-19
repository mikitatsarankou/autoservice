public class TestDriveTriggerHandler extends TriggerHandler {

    public TestDriveTriggerHandler() {
        ObjectName = 'TestDrive';
    }

    protected override void beforeInsert() {
        //sendEmail(trigger.new);
    }

    private void sendEmail(List<Test_Drive__c> testDrives) {
        Map<Id, SObject> generalMapClientByClientId = new Map<Id, SObject>();
        Map<Id, String> contactEmailByContactId = new Map<Id, String>();
        Map<Id, String> leadEmailByLeadId = new Map<Id, String>();
        for (Test_Drive__c testDrive : testDrives) {
            if (testDrive.Contact__c != null) {
                contactEmailByContactId.put(testDrive.Contact__c, null);
            }
            if (testDrive.Lead__c != null) {
                leadEmailByLeadId.put(testDrive.Lead__c, null);
            }
        }
        List<Contact> contacts = ContactService.getContactsById(contactEmailByContactId.keySet());
        List<Lead> leads = LeadService.getLeadsById(leadEmailByLeadId.keySet());

        generalMapClientByClientId.putAll(Utils.mapByIdField(contacts, 'Id'));
        generalMapClientByClientId.putAll(Utils.mapByIdField(leads, 'Id'));

        List<EmailTemplate> emailTemplates = EmailTemplateService.getEmailTemplatesByFolderNameId(new List<Id>{EmailTemplateManager.ladaCustomerSupportId}, 'caseCreated_EN');
        EmailMessageService.sendMessages(generalMapClientByClientId, emailTemplates[0].Id);
    }
}