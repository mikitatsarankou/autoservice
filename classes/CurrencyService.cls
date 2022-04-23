public class CurrencyService {
    
    @future(callout = true)
    public static void getCurRate() {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        List<NBRB_Api__c> rates = CurrencyManager.getActiveNBRBApis();

        for (NBRB_Api__c rate : rates) {
            request.setEndpoint(rate.Exchange_Rate_Uri__c);

            request.setMethod('GET');
            HttpResponse response = http.send(request);

            Object byrToForeignCurrency;
            Object foreignCurrencyAbbreviation;
            Boolean isDataCorrect = false;

            if (response.getStatusCode() == 200) {
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

                if (results.get('Cur_OfficialRate') != null && results.get('Cur_Abbreviation') != null) isDataCorrect = true;
                if (isDataCorrect) {
                    byrToForeignCurrency = results.get('Cur_OfficialRate');
                    Object foreignCurrencyRate = 1 / (Decimal) byrToForeignCurrency;

                    foreignCurrencyAbbreviation = results.get('Cur_Abbreviation');
                    System.enqueueJob(new CurrencyManager(foreignCurrencyRate, foreignCurrencyAbbreviation));
                } else {
                    Internal_Message__c internalMessage = new Internal_Message__c(
                            Name = 'currency update error',
                            Error_message__c = 'failed to update currency'
                    );
                    insert internalMessage;
                    return;
                }
            }
        }
    }

    public static List<CurrencyController.CurrencyWrapper> formCurrencyWrapper(List<CurrencyType> currencies) {
        List<CurrencyController.CurrencyWrapper> currencyWrappers = new List<CurrencyController.CurrencyWrapper>();
        for (CurrencyType currencyType : currencies) {
            CurrencyController.CurrencyWrapper currencyWrapper = new CurrencyController.CurrencyWrapper();
            currencyWrapper.isoCode = currencyType.IsoCode;   
            currencyWrappers.add(currencyWrapper);
        }
        return currencyWrappers;
    }

    public static List<CurrencyType> getCurrencies() {
        return CurrencyManager.getCurrencies();
    }

    public static List<CurrencyType> getCurrenciesByIsoCodes(List<String> isoCodes) {
        return CurrencyManager.getCurrenciesByIsoCodes(isoCodes);
    }
}