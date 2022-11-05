public class CurrencyController {

    @AuraEnabled(Cacheable = true)
    public static List<CurrencyWrapper> getCurrencies() {
        List<CurrencyWrapper> currencyWrappers = new List<CurrencyWrapper>();
        try {
            List<Currency__c> currencies = CurrencyService.getCustomCurrencies();
            currencyWrappers = CurrencyService.formCurrencyWrapper(currencies);
        } catch (Exception caughtException) {
            new InternalMessageService(
                    'CurrencyController.getCurrencies',
                    'failed to get currency',
                    caughtException
            ).createNewInternalMessage();
        }

        return currencyWrappers;
    }

    public class CurrencyWrapper {        
        @AuraEnabled
        public String table;
        @AuraEnabled
        public String currencyName;
        @AuraEnabled
        public String code;
        @AuraEnabled
        public List<RatesWrapper> rates;

        public CurrencyWrapper() {

        }
    }

    public class RatesWrapper {
        @AuraEnabled
        public String no;
        @AuraEnabled
        public String effectiveDate;
        @AuraEnabled
        public String mid;

        public RatesWrapper() {

        }
    }

    // "table":"A",
    // "currency":"dolar amerykański",
    // "code":"USD",
    // "rates":[
    //   {
    //      "no":"078/A/NBP/2022",
    //      "effectiveDate":"2022-04-22",
    //      "mid":4.2935
    //   }
    // ]
}