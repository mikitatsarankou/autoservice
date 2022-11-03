public class ContactManager {

    private static final Set<String> GENERAL_FIELDS_TO_QUERY = new Set<String>{
            'Id',
            'FirstName',
            'LastName',
            'Phone',
            'Email'
    };

    private static final String FROM_CONTACT = ' FROM Contact';
    private static final String WHERE_STATEMENT = ' WHERE ';
    private static final String OR_STATEMENT = ' OR ';
    private static final String AND_STATEMENT = ' AND ';

    public static Contact updateContactInfo(Contact contact) {
        Contact contactToUpdate = new Contact(
                Id = contact.Id,
                FirstName = contact.FirstName,
                LastName = contact.LastName,
                Email = contact.Email,
                Phone = contact.Phone
        );
        update contactToUpdate;

        return contactToUpdate;
    }

    public static Contact getContactByEmailOrPhone(String email, String phone) {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_CONTACT +
                WHERE_STATEMENT + 'Email = :email' +
                OR_STATEMENT + 'Phone =: phone';

        return Database.query(query);
    }

    public static List<Contact> getContactsById(List<Id> contactsIds) {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_CONTACT +
                WHERE_STATEMENT + ' Id IN :contactsIds';

        return Database.query(query);
    }

    public static List<Contact> getContactsById(Set<Id> contactsIds) {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_CONTACT +
                WHERE_STATEMENT + ' Id IN :contactsIds';

        return Database.query(query);
    }
}