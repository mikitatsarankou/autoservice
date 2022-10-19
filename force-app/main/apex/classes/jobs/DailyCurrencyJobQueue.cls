public class DailyCurrencyJobQueue implements Queueable, Database.AllowsCallouts {

    public final String requestURI;

    public DailyCurrencyJobQueue(String requestURI) {
        this.requestURI = requestURI;
    }

    public void execute(QueueableContext QC) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(requestURI);
        request.setMethod('GET');
        HttpResponse responseJSON;
        try {
            responseJSON = http.send(request);
        } catch (Exception ex) {
            Internal_Message__c internalMessage = new Internal_Message__c(
                    Name = 'currency update error',
                    Error_message__c = 'failed to get currency \n' + ex.getCause() + '\n' + ex.getStackTraceString()
            );
            insert internalMessage;
        }

        Boolean isDataCorrect = false;

        if (responseJSON != null && responseJSON.getStatusCode() == 200) {
            String response = responseJSON.getBody().replace('"currency":', '"currencyName":');
            CurrencyController.CurrencyWrapper currencyWrapper = (CurrencyController.CurrencyWrapper) System.JSON.deserialize(response, CurrencyController.CurrencyWrapper.class);
            
            if (currencyWrapper != null) isDataCorrect = true;
            if (isDataCorrect) {
                System.enqueueJob(new CurrencyManager(currencyWrapper.code, currencyWrapper.rates[0].mid));
            } else {
                Internal_Message__c internalMessage = new Internal_Message__c(
                    Name = 'currency update error',
                    Error_message__c = 'failed to update currency ' + currencyWrapper.code
                );
                insert internalMessage;
            }
        }
    }
}