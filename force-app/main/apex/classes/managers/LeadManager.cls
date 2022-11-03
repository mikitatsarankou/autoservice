public class LeadManager {

    private static final Set<String> GENERAL_FIELDS_TO_QUERY = new Set<String>{
            'Id',
            'FirstName',
            'LastName',
            'Phone',
            'Email'
    };

    private static final String FROM_LEAD = ' FROM Lead';
    private static final String WHERE_STATEMENT = ' WHERE ';
    private static final String OR_STATEMENT = ' OR ';
    private static final String AND_STATEMENT = ' AND ';

    public static Lead updateLeadInfo(Lead lead) {
        Lead leadToUpdate = new Lead (
                Id = lead.Id,
                FirstName = lead.FirstName,
                LastName = lead.LastName,
                Email = lead.Email,
                Phone = lead.Phone
        );
        update leadToUpdate;

        return leadToUpdate;
    }

    public static Lead newLead(String name, String surname, String email, String phone) {
        Lead lead = new Lead(
                FirstName = name,
                LastName = surname,
                Email = email,
                Phone = phone,
                Company = phone
        );
        insert lead;

        return lead;
    }

    public static Lead getLeadByEmailOrPhone(String email, String phone) {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_LEAD +
                WHERE_STATEMENT + 'Email = :email' +
                OR_STATEMENT + 'Phone =: phone';

        return Database.query(query);
    }

    public static List<Lead> getLeadsById(List<Id> leadIds) {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_LEAD +
                WHERE_STATEMENT + ' Id IN :leadIds';

        return Database.query(query);
    }

    public static List<Lead> getLeadsById(Set<Id> leadIds) {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_LEAD +
                WHERE_STATEMENT + ' Id IN :leadIds';

        return Database.query(query);
    }
}