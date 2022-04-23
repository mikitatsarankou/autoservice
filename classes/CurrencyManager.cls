public class CurrencyManager implements Queueable, Database.AllowsCallouts {     
    
    private Object curRate;
	private Object curCode;
	private final static Integer DECIMAL_SCALE = 2;

    public CurrencyManager(Object curRate, Object curCode) {
        this.curRate = curRate;
		this.curCode = curCode;
    }
    
    public void execute(QueueableContext QC) {
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v28.0/sobjects/CurrencyType/');
		req.setMethod('POST');       
		req.setBody('{ "IsoCode" : "' + curCode + '", "DecimalPlaces" : 2, "ConversionRate" : ' + curRate + ', "IsActive" : "true" }');
		req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
		req.setHeader('Content-Type', 'application/json');
		HttpResponse res = h.send(req);
	}

    public static List<CurrencyType> getCurrencies() {
        return [SELECT Id, IsoCode, IsActive, ConversionRate FROM CurrencyType WHERE IsActive = true];
    }
	
    public static List<CurrencyType> getCurrenciesByIsoCodes(List<String> isoCodes) {
        return [SELECT Id, IsoCode, IsActive, ConversionRate FROM CurrencyType WHERE IsoCode IN:isoCodes AND IsActive = true];
    }

	public static List<NBRB_Api__c> getActiveNBRBApis() {
		return [SELECT Exchange_Rate_Uri__c, Currency_Name__c, isActive__c FROM NBRB_Api__c WHERE isActive__c = true];
	}
}