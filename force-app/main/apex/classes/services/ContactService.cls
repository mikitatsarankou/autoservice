public class ContactService {

    public static Contact getContactByEmailOrPhone(String email, String phone) {
        return ContactManager.getContactByEmailOrPhone(email, phone);
    }

    public static List<Contact> getContactsById(List<Id> ids) {
        return ContactManager.getContactsById(ids);
    }

    public static List<Contact> getContactsById(Set<Id> ids) {
        return ContactManager.getContactsById(ids);
    }
}