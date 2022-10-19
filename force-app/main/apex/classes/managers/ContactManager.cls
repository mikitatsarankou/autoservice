public class ContactManager {

    public static Contact getContactByEmailOrPhone(String email, String phone) {
        List<Contact> contacts = [SELECT Id, FirstName, LastName, Phone, Email FROM Contact WHERE Email = :email OR Phone = :phone];
        if (!contacts.isEmpty()) {
            return contacts[0];
        }
        return null;
    }

    public static Contact updateContactInfo(Contact contact) {
        Contact contactToUpdate = new Contact (
                Id = contact.Id,
                FirstName = contact.FirstName,
                LastName = contact.LastName,
                Email = contact.Email,
                Phone = contact.Phone);
        update contactToUpdate;
        return contactToUpdate;
    }

    public static List<Contact> getContactsById(List<Id> ids) {
        List<Contact> contacts = [
                SELECT Id, FirstName, LastName, Email, Phone
                FROM Contact
                WHERE Id IN:ids
        ];
        if (!contacts.isEmpty()) {
            return contacts;
        }
        return new List<Contact>();
    }

    public static List<Contact> getContactsById(Set<Id> ids) {
        List<Contact> contacts = [
                SELECT Id, FirstName, LastName, Email, Phone
                FROM Contact
                WHERE Id IN:ids
        ];
        if (!contacts.isEmpty()) {
            return contacts;
        }
        return new List<Contact>();
    }
}