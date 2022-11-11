global class DailyCurrencyJob implements Schedulable {

    public DailyCurrencyJob() {
        
    }

    global void execute(SchedulableContext SC) {
        try {
            List<Bank_Api__c> banksApis = CurrencyService.getBanksApis();
            List<CurrencyType> currencies = CurrencyService.getCurrencies();
            List<String> requestsURIsToDo = new List<String>();

            if (!banksApis.isEmpty()) {
                Bank_Api__c NBP_Api = banksApis[0];
                String mainEndpoint = NBP_Api.URI__c;

                for (CurrencyType currencyType : currencies) {
                    if (!currencyType.IsCorporate) {
                        requestsURIsToDo.add(mainEndpoint + currencyType.isoCode + '?format=json');
                    }
                }

                for (String requestURI : requestsURIsToDo) {
                    System.enqueueJob(new DailyCurrencyJobQueue(requestURI));
                }
            }
        } catch (Exception caughtException) {
            insert new InternalMessageService(
                    'DailyCurrencyJob.execute',
                    'failed to get currency from API',
                    caughtException
            ).createNewInternalMessage();
        }
    }
}