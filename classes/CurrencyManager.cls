public class CurrencyManager implements Queueable, Database.AllowsCallouts {     
    
    public Object curRate;
    
    public CurrencyManager(Object curRate) {        
        this.curRate = curRate;
    }
    
    public void execute(QueueableContext cxt) {
		 
		Http http = new Http();
		HttpRequest request = new HttpRequest();
        
		request.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v28.0/sobjects/CurrencyType/');
		request.setMethod('POST');
		request.setBody('{ "IsoCode" : "BYN", "DecimalPlaces" : 2, "ConversionRate" : ' + curRate + ', "IsActive" : "true" }');
		request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
		request.setHeader('Content-Type', 'application/json');
        
		HttpResponse res = http.send(request);
	}
}