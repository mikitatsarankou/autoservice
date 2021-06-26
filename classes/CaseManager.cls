public class CaseManager {

    public static Case newCaseForExistingLead(Lead lead, String email, String subject, String message, Id selectedDealershipId) {
        Case leadCase  = new Case();
        leadCase.Lead__c = lead.Id;
        leadCase.SuppliedEmail = email;
        leadCase.Subject = subject;
        leadCase.Description = message;
        leadCase.Car_Center__c = selectedDealershipId;

        insert leadCase;
        return leadCase;
    }

    public static Case newCaseForExistingContact(Contact contact, String email, String subject, String message, Id selectedDealershipId) {
        Case contactCase  = new Case();
        contactCase.ContactId = contact.Id;
        contactCase.SuppliedEmail = email;
        contactCase.Subject = subject;
        contactCase.Description = message;
        contactCase.Car_Center__c = selectedDealershipId;

        insert contactCase;
        return contactCase;
    }
}