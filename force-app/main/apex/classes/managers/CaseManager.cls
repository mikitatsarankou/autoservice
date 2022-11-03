public class CaseManager {

    public static Case newCaseForExistingLead(Lead lead, String email, String subject, String message, Id selectedDealershipId) {
        Case leadCase = new Case(
                Lead__c = lead.Id,
                SuppliedEmail = email,
                Subject = subject,
                Description = message,
                Car_Center__c = selectedDealershipId
        );
        insert leadCase;

        return leadCase;
    }

    public static Case newCaseForExistingContact(Contact contact, String email, String subject, String message, Id selectedDealershipId) {
        Case contactCase = new Case(
                ContactId = contact.Id,
                SuppliedEmail = email,
                Subject = subject,
                Description = message,
                Car_Center__c = selectedDealershipId
        );
        insert contactCase;

        return contactCase;
    }
}