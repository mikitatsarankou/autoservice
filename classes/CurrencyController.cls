global class CurrencyController implements Schedulable {
    
    public void execute(SchedulableContext ctx) {
        List<String> listOfUriToRequest = getListOfUriForRequest();
        for (String uri : listOfUriToRequest) {
            getCurRate(uri);
        }
    }

    public static List<String> getListOfUriForRequest() {
        List<String> listOfUri = new List<String>();
        List<NBRB_Api__c> nbrbApis = [SELECT isActive__c, Exchange_Rate_Uri__c FROM NBRB_Api__c];
        for (NBRB_Api__c nbrbApi : nbrbApis) {
            if (nbrbApi.isActive__c && String.isNotBlank(nbrbApi.Exchange_Rate_Uri__c)) {
                listOfUri.add(nbrbApi.Exchange_Rate_Uri__c);
            }
        }
        return listOfUri;
    }
    
    @future(callout = true)
    public static void getCurRate(String uri) {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(uri);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        Object curOfficialRate;
        
        if (response.getStatusCode() == 200) {	
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            curOfficialRate = results.get('Cur_OfficialRate');    
            System.enqueueJob(new CurrencyManager(curOfficialRate));
        }
    }
}