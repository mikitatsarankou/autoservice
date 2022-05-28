public class LeadManager {

    public static Lead getLeadByEmailOrPhone(String email, String phone) {
        List<Lead> leads = [SELECT Id, FirstName, LastName, Phone, Email FROM Lead WHERE Email =: email OR Phone =: phone];
        if (!leads.isEmpty()) {
            return leads[0];
        }
        return null;
    }

    public static Lead updateLeadInfo(Lead lead) {
        Lead leadToUpdate = new Lead (
                Id = lead.Id,
                FirstName = lead.FirstName,
                LastName = lead.LastName,
                Email = lead.Email,
                Phone = lead.Phone);
        update leadToUpdate;
        return leadToUpdate;
    }

    public static Lead newLead(String name, String surname, String email, String phone) {
        Lead lead = new Lead();
        lead.FirstName = name;
        lead.LastName = surname;
        lead.Email = email;
        lead.Phone = phone;
        lead.Company = phone;

        insert lead;
        return lead;
    }

    public static List<Lead> getLeadsById(List<Id> ids) {
        List<Lead> leads = [
                SELECT Id, FirstName, LastName, Email, Phone
                FROM Lead
                WHERE Id IN:ids
        ];
        if (!leads.isEmpty()) {
            return leads;
        }
        return new List<Lead>();
    }

    public static List<Lead> getLeadsById(Set<Id> ids) {
        List<Lead> leads = [
                SELECT Id, FirstName, LastName, Email, Phone
                FROM Lead
                WHERE Id IN:ids
        ];
        if (!leads.isEmpty()) {
            return leads;
        }
        return new List<Lead>();
    }
}