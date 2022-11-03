public class OpportunityManager {

    private static final String TEST_DRIVE_LEAD_STAGE_NAME = 'Test-drive-lead';
    private static final String TEST_DRIVE_CONTACT_STAGE_NAME = 'Test-drive-contact';
    private static final String DEFAULT_CURRENCY_IS_CODE = 'USD';
    private static final Integer DURATION_OF_OPPORTUNITY_IN_DAYS = 7;

    public static Opportunity createAndLinkOpportunityToExistingLead(Lead lead, Product2 product, Id selectedDealershipId, Datetime selectedDate) {
        String formName = lead.FirstName + ' ' + lead.LastName + ' ' + product.Id + ' ' + selectedDate;
        Opportunity opportunity = new Opportunity(
                Name = formName,
                Lead__c = lead.Id,
                Car_Center__c = selectedDealershipId,
                Product__c = product.Id,
                Amount = product.Price__c,
                StageName = TEST_DRIVE_LEAD_STAGE_NAME,
                CurrencyIsoCode = DEFAULT_CURRENCY_IS_CODE,
                Open_Date__c = selectedDate.addHours(-3),
                CloseDate = selectedDate.addDays(DURATION_OF_OPPORTUNITY_IN_DAYS).date()
        );
        insert opportunity;
        
        return opportunity;
    }

    public static Opportunity createAndLinkOpportunityToExistingContact(Contact contact, Product2 product, Id selectedDealershipId, Datetime selectedDate) {
        String formName = contact.FirstName + ' ' + contact.LastName + ' ' + product.Id + ' ' + selectedDate;
        Opportunity opportunity = new Opportunity(
                Name = formName,
                Contact__c = contact.Id,
                Car_Center__c = selectedDealershipId,
                Product__c = product.Id,
                Amount = product.Price__c,
                StageName = TEST_DRIVE_CONTACT_STAGE_NAME,
                CurrencyIsoCode = DEFAULT_CURRENCY_IS_CODE,
                Open_Date__c = selectedDate.addHours(-3),
                CloseDate = selectedDate.addDays(DURATION_OF_OPPORTUNITY_IN_DAYS).date()
        );
        insert opportunity;

        return opportunity;
    }
}