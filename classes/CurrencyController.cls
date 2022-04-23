public class CurrencyController {

    @AuraEnabled(Cacheable = true)
    public static List<CurrencyWrapper> getCurrencies() {
        List<CurrencyType> currencies = CurrencyService.getCurrencies();
        return CurrencyService.formCurrencyWrapper(currencies);
    }

    public class CurrencyWrapper {
        @AuraEnabled
        public String isoCode;

        public CurrencyWrapper() {

        }
    }

    public CurrencyController() {

    }
}
