public class LeadService {

    public static Lead getLeadByEmailOrPhone(String email, String phone) {
        return LeadManager.getLeadByEmailOrPhone(email, phone);
    }

    public static Lead newLead(String name, String surname, String email, String phone) {
        return LeadManager.newLead(name, surname, email, phone);
    }

    public static List<Lead> getLeadsById(List<Id> ids) {
        return LeadManager.getLeadsById(ids);
    }

    public static List<Lead> getLeadsById(Set<Id> ids) {
        return LeadManager.getLeadsById(ids);
    }

}