public class CurrencyController {

    @AuraEnabled(Cacheable = true)
    public static List<CurrencyWrapper> getCurrencies() {
        List<CurrencyType> currencies = CurrencyService.getCurrencies();
        return CurrencyService.formCurrencyWrapper(currencies);
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

    public CurrencyController() {

    }
}
