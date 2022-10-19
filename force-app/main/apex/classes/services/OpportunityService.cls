public class OpportunityService {

    public static Opportunity createAndLinkOpportunityToExistingLead(Lead lead, Id selectedDealearshipId, Id selectedProductId, Datetime selectedDate) {
        Product2 product = ProductsService.getProductById(new List<Id>{selectedProductId});
        return OpportunityManager.createAndLinkOpportunityToExistingLead(lead, product, selectedDealearshipId, selectedDate);
    }

    public static Opportunity createAndLinkOpportunityToExistingContact(Contact contact, Id selectedDealearshipId, Id selectedProductId, Datetime selectedDate) {
        Product2 product = ProductsService.getProductById(new List<Id>{selectedProductId});
        return OpportunityManager.createAndLinkOpportunityToExistingContact(contact, product, selectedDealearshipId, selectedDate);
    }
}