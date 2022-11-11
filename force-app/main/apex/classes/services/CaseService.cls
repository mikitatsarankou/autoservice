public without sharing class CaseService {

    @InvocableMethod(Label = 'Send Email For New Case')
    public static void sendEmailForNewCases(List<Case> newCases) {
        Set<Id> newCasesIds = new Set<Id>();
        for (Case newCase : newCases) {
            newCasesIds.add(newCase.Id);
        }

        Map<Id, Case> newCasesByIdMap = new Map<Id, Case>(
                ClientService.getCasesById(newCasesIds)
        );

        List<EmailMessageService.NewCaseEmailFieldsWrapper> newCaseEmailFieldsWrappers =
                new List<EmailMessageService.NewCaseEmailFieldsWrapper>();

        for (Case newCase : newCasesByIdMap.values()) {
            EmailMessageService.NewCaseEmailFieldsWrapper wrapper = new EmailMessageService.NewCaseEmailFieldsWrapper();

            wrapper.emailAddress = newCase.Lead__r.Email;
            wrapper.setFirstName(newCase.Lead__r.FirstName);
            wrapper.setLastName(newCase.Lead__r.LastName);
            wrapper.setCaseNumber(newCase.CaseNumber);

            newCaseEmailFieldsWrappers.add(wrapper);
        }

        EmailMessageService.sendEmailsForJustCreatedCases(newCaseEmailFieldsWrappers);
    }

    public static ClientService.ProcessResultWrapper createCaseForExistingContact(CaseFormWrapper caseFormWrapper) {
        List<Contact> contacts = ContactService.getContactByEmailOrPhone(
                caseFormWrapper.email,
                caseFormWrapper.phone
        );

        if (contacts.isEmpty()) {
            return ClientService.getNegativeProcessResultWrapper();
        }

        Contact contactToUpdate = contacts.get(0);
        Contact updatedContact = ContactManager.updateContactInfo(contactToUpdate);
        Case newCase = CaseManager.newCaseForExistingContact(
                updatedContact,
                caseFormWrapper.email,
                caseFormWrapper.subject,
                caseFormWrapper.message,
                caseFormWrapper.selectedDealershipId
        );

        return ClientService.getProcessResultWrapper(
                true,
                new Set<Id>{newCase.Id}
        );
    }

    public static ClientService.ProcessResultWrapper createCaseForExistingLead(CaseFormWrapper caseFormWrapper) {
        List<Lead> leads = LeadService.getLeadByEmailOrPhone(
                caseFormWrapper.email,
                caseFormWrapper.phone
        );

        if (leads.isEmpty()) {
            return ClientService.getNegativeProcessResultWrapper();
        }

        Lead leadToUpdate = leads.get(0);
        Lead updatedLead = LeadManager.updateLeadInfo(leadToUpdate);
        Case newCase = CaseManager.newCaseForExistingLead(
                updatedLead,
                caseFormWrapper.email,
                caseFormWrapper.subject,
                caseFormWrapper.message,
                caseFormWrapper.selectedDealershipId
        );

        return ClientService.getProcessResultWrapper(
                true,
                new Set<Id>{newCase.Id}
        );
    }

    public static ClientService.ProcessResultWrapper createCaseForNotExistingLead(CaseFormWrapper caseFormWrapper) {
        Lead newLead = LeadService.newLead(
                caseFormWrapper.name,
                caseFormWrapper.surname,
                caseFormWrapper.email,
                caseFormWrapper.phone
        );
        Case newCase = CaseManager.newCaseForExistingLead(
                newLead,
                caseFormWrapper.email,
                caseFormWrapper.subject,
                caseFormWrapper.message,
                caseFormWrapper.selectedDealershipId
        );

        return ClientService.getProcessResultWrapper(
                true,
                new Set<Id>{newCase.Id}
        );
    }

    public static List<Case> getCasesById(Set<Id> casesIds) {
        return CaseManager.getCasesById(casesIds);
    }

    public class CaseFormWrapper {
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String surname { get; set; }
        @AuraEnabled
        public String email { get; set; }
        @AuraEnabled
        public String phone { get; set; }
        @AuraEnabled
        public String selectedDealershipId { get; set; }
        @AuraEnabled
        public String subject { get; set; }
        @AuraEnabled
        public String message { get; set; }
    }

}