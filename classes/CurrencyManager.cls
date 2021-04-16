public class CurrencyManager implements Queueable, Database.AllowsCallouts {     
    
    public Object curRate;
    
    public CurrencyManager(Object curRate) {        
        this.curRate = curRate;
    }
    
    public void execute(QueueableContext cxt) {
		 
		Http h = new Http();
		HttpRequest req = new HttpRequest();
        
		req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v28.0/sobjects/CurrencyType/');
		req.setMethod('POST');       
		req.setBody('{ "IsoCode" : "BYN", "DecimalPlaces" : 2, "ConversionRate" : ' + curRate + ', "IsActive" : "true" }');
		req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
		req.setHeader('Content-Type', 'application/json');
        
		HttpResponse res = h.send(req);      	
        
	}
}