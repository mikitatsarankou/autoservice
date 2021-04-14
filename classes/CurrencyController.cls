global class CurrencyController implements Schedulable {
    
    public void execute(SchedulableContext ctx) {
        getCurRate();              
    }
    
    @future(callout = true)
    public static void getCurRate() {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
/*        Bank_convert__c bank = Bank_convert__c.getValues('USD to BYN');
        String bankUrl = bank.USDBYN__C;*/
        
/*        request.setEndpoint(bankUrl);	*/
        
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