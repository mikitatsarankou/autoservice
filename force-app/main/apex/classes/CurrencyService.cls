public class CurrencyService {

    public CurrencyService(String requestsURI) {

    }

    public static List<CurrencyController.CurrencyWrapper> formCurrencyWrapper(List<CurrencyType> currencies) {
        List<CurrencyController.CurrencyWrapper> currencyWrappers = new List<CurrencyController.CurrencyWrapper>();
        for (CurrencyType currencyType : currencies) {
            CurrencyController.CurrencyWrapper currencyWrapper = new CurrencyController.CurrencyWrapper();
            currencyWrapper.code = currencyType.IsoCode;   
            currencyWrappers.add(currencyWrapper);
        }
        return currencyWrappers;
    }

    public static List<Bank_Api__c> getBanksApis() {
		return CurrencyManager.getBanksApis();
	}

    public static List<CurrencyType> getCurrencies() {
        return CurrencyManager.getCurrencies();
    }

    public static List<CurrencyType> getCurrenciesByIsoCodes(List<String> isoCodes) {
        return CurrencyManager.getCurrenciesByIsoCodes(isoCodes);
    }
}