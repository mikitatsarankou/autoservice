public class CurrencyManager implements Queueable, Database.AllowsCallouts {

    public final String code;
    public final String rate;

    public CurrencyManager(String code, String rate) {
        this.code = code;
        this.rate = rate;
    }

    public void execute(QueueableContext QC) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(Url.getSalesforceBaseUrl().toExternalForm() + '/services/data/v28.0/sobjects/CurrencyType/');
        request.setMethod('POST');
        request.setBody('{ "IsoCode" : "' + code + '", "DecimalPlaces" : 2, "ConversionRate" : ' + rate + ', "IsActive" : "true" }');
        request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        request.setHeader('Content-Type', 'application/json');
        HttpResponse response = http.send(request);

        System.enqueueJob(new CustomCurrencyManager());
    }

    public static List<Bank_Api__c> getBanksApis() {
        return [
                SELECT Id, Name, isActive__c, URI__c
                FROM Bank_Api__c
                WHERE isActive__c = TRUE
        ];
    }

    public static List<CurrencyType> getCurrencies() {
        return [
                SELECT Id, IsoCode, IsActive, IsCorporate, ConversionRate
                FROM CurrencyType
                WHERE IsActive = TRUE
        ];
    }

    public static List<CurrencyType> getCurrenciesByIsoCodes(List<String> isoCodes) {
        return [
                SELECT Id, IsoCode, IsActive, ConversionRate
                FROM CurrencyType
                WHERE IsActive = TRUE AND IsoCode IN :isoCodes
        ];
    }

    public static List<Currency__c> getCustomCurrencies() {
        return [
                SELECT Id, Conversion_Rate__c, Name, isAcitve__c, IsCorporate__c, Iso_Code__c, CurrencyIsoCode
                FROM Currency__c
                WHERE isAcitve__c = TRUE
        ];
    }

    public static List<Currency__c> getCustomCurrenciesByIsoCodes(List<String> isoCodes) {
        return [
                SELECT Id, Conversion_Rate__c, Name, isAcitve__c, IsCorporate__c, Iso_Code__c, CurrencyIsoCode
                FROM Currency__c
                WHERE isAcitve__c = TRUE AND Iso_Code__c IN :isoCodes
        ];
    }
}