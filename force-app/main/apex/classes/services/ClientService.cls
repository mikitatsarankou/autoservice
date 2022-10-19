public class ClientService {
    private static final Integer GMT = 3;

    public static Boolean processTestDriveForClient(String name, String surname, String email,
            String phone, String selectedProductId, String selectedDealearshipId, String selectedDate) {
        try {
            Datetime testDriveDate = Utils.formDatetimeFromStringGTM3(selectedDate);
            Contact contact = ContactService.getContactByEmailOrPhone(email, phone);
            if (contact != null) {
                Contact updatedContact = ContactManager.updateContactInfo(contact);
                Test_Drive__c testDrive = TestDriveService.createAndLinkTestDriveToExistingContact(updatedContact, selectedDealearshipId, selectedProductId, testDriveDate);
                Opportunity opportunity = OpportunityService.createAndLinkOpportunityToExistingContact(updatedContact, selectedDealearshipId, selectedProductId, testDriveDate);
                return true;
            }
            Lead lead = LeadService.getLeadByEmailOrPhone(email, phone);
            if (lead != null) {
                Lead updatedLead = LeadManager.updateLeadInfo(lead);
                Test_Drive__c testDrive = TestDriveService.createAndLinkTestDriveToExistingLead(updatedLead, selectedDealearshipId, selectedProductId, testDriveDate);
                Opportunity opportunity = OpportunityService.createAndLinkOpportunityToExistingLead(updatedLead, selectedDealearshipId, selectedProductId, testDriveDate);
                return true;
            }
            Lead newLead = LeadService.newLead(name, surname, email, phone);
            Test_Drive__c testDrive = TestDriveService.createAndLinkTestDriveToExistingLead(newLead, selectedDealearshipId, selectedProductId, testDriveDate);
            Opportunity opportunity = OpportunityService.createAndLinkOpportunityToExistingLead(newLead, selectedDealearshipId, selectedProductId, testDriveDate);
            return true;
        } catch (Exception ex) {
            system.debug(ex.getStackTraceString());
            system.debug(ex.getMessage());
            return false;
        }
    }

    public static Boolean processCaseForClient(String name, String surname, String email,
            String phone, String selectedDealershipId, String subject, String message) {
        try {
            Contact contact = ContactService.getContactByEmailOrPhone(email, phone);
            if (contact != null) {
                Contact updatedContact = ContactManager.updateContactInfo(contact);
                Case casee = CaseManager.newCaseForExistingContact(updatedContact, email, subject, message, selectedDealershipId);
                return true;
            }
            Lead lead = LeadService.getLeadByEmailOrPhone(email, phone);
            if (lead != null) {
                Lead updatedLead = LeadManager.updateLeadInfo(lead);
                Case casee = CaseManager.newCaseForExistingLead(updatedLead, email, subject, message, selectedDealershipId);
                return true;
            }
            Lead newLead = LeadService.newLead(name, surname, email, phone);
            CaseManager.newCaseForExistingLead(newLead, email, subject, message, selectedDealershipId);
            return true;

        } catch (Exception ex) {
            system.debug(ex.getStackTraceString());
            system.debug(ex.getMessage());
            return false;
        }
    }

}