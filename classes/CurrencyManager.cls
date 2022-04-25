public class CurrencyManager implements Queueable, Database.AllowsCallouts {     
    
	public final String code;
	public final String rate;

    public CurrencyManager(String code, String rate) {
        this.code = code;
		this.rate = rate;
    }
    
    public void execute(QueueableContext QC) {
		Http h = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v28.0/sobjects/CurrencyType/');
		request.setMethod('POST');       
		request.setBody('{ "IsoCode" : "' + code + '", "DecimalPlaces" : 2, "ConversionRate" : ' + rate + ', "IsActive" : "true" }');
		request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
		request.setHeader('Content-Type', 'application/json');
		HttpResponse response = h.send(request);
	}

	public static List<Bank_Api__c> getBanksApis() {
		return [SELECT Id, Name, isActive__c, URI__c from Bank_Api__c WHERE isActive__c = true];
	}

    public static List<CurrencyType> getCurrencies() {
        return [SELECT Id, IsoCode, IsActive, IsCorporate, ConversionRate FROM CurrencyType WHERE IsActive = true];
    }
	
    public static List<CurrencyType> getCurrenciesByIsoCodes(List<String> isoCodes) {
        return [SELECT Id, IsoCode, IsActive, ConversionRate FROM CurrencyType WHERE IsoCode IN:isoCodes AND IsActive = true];
    }
}