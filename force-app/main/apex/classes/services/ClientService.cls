public without sharing class ClientService {
    public static Boolean processTestDriveForClient(TestDriveFormWrapper testDriveFormWrapper) {
        try {
            Datetime testDriveDate = Utils.formDatetimeFromStringGTM(testDriveFormWrapper.selectedDate);
            if (planTestDriveForExistingContact(testDriveFormWrapper, testDriveDate)) {
                return true;
            }
            if (planTestDriveForExistingLead(testDriveFormWrapper, testDriveDate)) {
                return true;
            }
            return planTestDriveForNewLead(testDriveFormWrapper, testDriveDate);
        } catch (Exception ex) {
            return false;
        }
    }

    public static Boolean processCaseForClient(CaseFormWrapper caseFormWrapper) {
        try {
            if (createCaseForExistingContact(caseFormWrapper)) {
                return true;
            }
            if (createCaseForExistingLead(caseFormWrapper)) {
                return true;
            }
            return createCaseForNotExistingLead(caseFormWrapper);
        } catch (Exception ex) {
            return false;
        }
    }

    private static Boolean planTestDriveForNewLead(TestDriveFormWrapper testDriveFormWrapper, Datetime testDriveDate) {
        Lead newLead = LeadService.newLead(
                testDriveFormWrapper.name,
                testDriveFormWrapper.surname,
                testDriveFormWrapper.email,
                testDriveFormWrapper.phone
        );

        TestDriveService.createAndLinkTestDriveToExistingLead(
                newLead,
                testDriveFormWrapper.selectedDealershipId,
                testDriveFormWrapper.selectedProductId,
                testDriveDate
        );

        OpportunityService.createAndLinkOpportunityToExistingLead(
                newLead,
                testDriveFormWrapper.selectedDealershipId,
                testDriveFormWrapper.selectedProductId,
                testDriveDate
        );

        return true;
    }
    private static Boolean planTestDriveForExistingLead(TestDriveFormWrapper testDriveFormWrapper, Datetime testDriveDate) {
        List<Lead> leads = LeadService.getLeadByEmailOrPhone(testDriveFormWrapper.email, testDriveFormWrapper.phone);

        if (leads.isEmpty()) {
            return false;
        }

        Lead leadToUpdate = leads.get(0);
        Lead updatedLead = LeadManager.updateLeadInfo(leadToUpdate);
        TestDriveService.createAndLinkTestDriveToExistingLead(
                updatedLead,
                testDriveFormWrapper.selectedDealershipId,
                testDriveFormWrapper.selectedProductId,
                testDriveDate
        );

        OpportunityService.createAndLinkOpportunityToExistingLead(
                updatedLead,
                testDriveFormWrapper.selectedDealershipId,
                testDriveFormWrapper.selectedProductId,
                testDriveDate
        );

        return true;
    }
    private static Boolean planTestDriveForExistingContact(TestDriveFormWrapper testDriveFormWrapper, Datetime testDriveDate) {
        List<Contact> contacts = ContactService.getContactByEmailOrPhone(testDriveFormWrapper.email, testDriveFormWrapper.phone);

        if (contacts.isEmpty()) {
            return false;
        }

        Contact contactToUpdate = contacts.get(0);
        Contact updatedContact = ContactManager.updateContactInfo(contactToUpdate);
        TestDriveService.createAndLinkTestDriveToExistingContact(
                updatedContact,
                testDriveFormWrapper.selectedDealershipId,
                testDriveFormWrapper.selectedProductId,
                testDriveDate
        );

        OpportunityService.createAndLinkOpportunityToExistingContact(
                updatedContact,
                testDriveFormWrapper.selectedDealershipId,
                testDriveFormWrapper.selectedProductId,
                testDriveDate
        );

        return true;
    }

    private static Boolean createCaseForExistingContact(CaseFormWrapper caseFormWrapper) {
        List<Contact> contacts = ContactService.getContactByEmailOrPhone(
                caseFormWrapper.email,
                caseFormWrapper.phone
        );

        if (contacts.isEmpty()) {
            return false;
        }

        Contact contactToUpdate = contacts.get(0);
        Contact updatedContact = ContactManager.updateContactInfo(contactToUpdate);
        CaseManager.newCaseForExistingContact(
                updatedContact,
                caseFormWrapper.email,
                caseFormWrapper.subject,
                caseFormWrapper.message,
                caseFormWrapper.selectedDealershipId
        );

        return true;
    }

    private static Boolean createCaseForExistingLead(CaseFormWrapper caseFormWrapper) {
        List<Lead> leads = LeadService.getLeadByEmailOrPhone(
                caseFormWrapper.email,
                caseFormWrapper.phone
        );

        if (leads.isEmpty()) {
            return false;
        }
        Lead leadToUpdate = leads.get(0);
        Lead updatedLead = LeadManager.updateLeadInfo(leadToUpdate);
        CaseManager.newCaseForExistingLead(
                updatedLead,
                caseFormWrapper.email,
                caseFormWrapper.subject,
                caseFormWrapper.message,
                caseFormWrapper.selectedDealershipId
        );
        return true;
    }

    private static Boolean createCaseForNotExistingLead(CaseFormWrapper caseFormWrapper) {
        Lead newLead = LeadService.newLead(
                caseFormWrapper.name,
                caseFormWrapper.surname,
                caseFormWrapper.email,
                caseFormWrapper.phone
        );
        CaseManager.newCaseForExistingLead(
                newLead,
                caseFormWrapper.email,
                caseFormWrapper.subject,
                caseFormWrapper.message,
                caseFormWrapper.selectedDealershipId
        );
        return true;
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

    public class TestDriveFormWrapper {
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
        public String selectedProductId { get; set; }
        @AuraEnabled
        public String selectedDate { get; set; }
    }

}