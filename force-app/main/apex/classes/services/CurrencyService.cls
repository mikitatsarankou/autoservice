public class CurrencyService {

    public static List<CurrencyController.CurrencyWrapper> formCurrencyWrapper(List<Currency__c> currencies) {
        List<CurrencyController.CurrencyWrapper> currencyWrappers = new List<CurrencyController.CurrencyWrapper>();
        for (Currency__c customCurrency : currencies) {
            CurrencyController.CurrencyWrapper currencyWrapper = new CurrencyController.CurrencyWrapper();
            currencyWrapper.code = customCurrency.Iso_Code__c;
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

    public static List<Currency__c> getCustomCurrencies() {
        return CurrencyManager.getCustomCurrencies();
    }

    public static List<Currency__c> getCustomCurrenciesByIsoCodes(List<String> isoCodes) {
        return CurrencyManager.getCustomCurrenciesByIsoCodes(isoCodes);
    }
}