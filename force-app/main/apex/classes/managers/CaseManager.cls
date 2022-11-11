public class CaseManager {

    private static final Set<String> GENERAL_FIELDS_TO_QUERY_CASE = new Set<String>{
            'Id',
            'Lead__c',
            'Lead__r.FirstName',
            'Lead__r.LastName',
            'Lead__r.Email',
            'CaseNumber'
    };

    private static final String FROM_CASE = ' FROM Case';
    private static final String WHERE_STATEMENT = ' WHERE ';
    private static final String OR_STATEMENT = ' OR ';
    private static final String AND_STATEMENT = ' AND ';

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

    public static List<Case> getCasesById(Set<Id> casesIds) {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY_CASE), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_CASE +
                WHERE_STATEMENT + 'Id IN :casesIds';

        return Database.query(query);
    }
}