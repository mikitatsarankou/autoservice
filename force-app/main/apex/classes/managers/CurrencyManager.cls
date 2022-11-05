public class CurrencyManager implements Queueable, Database.AllowsCallouts {

    private static final Set<String> GENERAL_FIELDS_TO_QUERY_CURRENCY_TYPE = new Set<String>{
            'Id',
            'IsoCode',
            'IsActive',
            'IsCorporate',
            'ConversionRate'
    };

    private static final Set<String> GENERAL_FIELDS_TO_QUERY_CUSTOM_CURRENCY = new Set<String>{
            'Id',
            'Name',
            'isAcitve__c',
            'Iso_Code__c',
            'IsCorporate__c',
            'CurrencyIsoCode',
            'Conversion_Rate__c'
    };

    private static final Set<String> GENERAL_FIELDS_TO_QUERY_BANK_API = new Set<String>{
            'Id',
            'Name',
            'isActive__c',
            'URI__c'
    };

    private static final String FROM_CURRENCY_TYPE = ' FROM CurrencyType';
    private static final String FROM_CUSTOM_CURRENCY = ' FROM Currency__c';
    private static final String FROM_BANK_API = ' FROM Bank_Api__c';
    private static final String WHERE_STATEMENT = ' WHERE ';
    private static final String OR_STATEMENT = ' OR ';
    private static final String AND_STATEMENT = ' AND ';

    private final String code;
    private final String rate;

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
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY_BANK_API), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_BANK_API +
                WHERE_STATEMENT + 'isActive__c = true';

        return Database.query(query);
    }

    public static List<CurrencyType> getCurrencies() {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY_CURRENCY_TYPE), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_CURRENCY_TYPE +
                WHERE_STATEMENT + 'IsActive = true';

        return Database.query(query);
    }

    public static List<CurrencyType> getCurrenciesByIsoCodes(List<String> isoCodes) {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY_CURRENCY_TYPE), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_CURRENCY_TYPE +
                WHERE_STATEMENT + 'IsActive = true' +
                AND_STATEMENT + 'IsoCode IN :isoCodes';

        return Database.query(query);
    }

    public static List<Currency__c> getCustomCurrencies() {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY_CUSTOM_CURRENCY), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_CUSTOM_CURRENCY +
                WHERE_STATEMENT + 'isAcitve__c = true';

        return Database.query(query);
    }

    public static List<Currency__c> getCustomCurrenciesByIsoCodes(List<String> isoCodes) {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY_CUSTOM_CURRENCY), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_CUSTOM_CURRENCY +
                WHERE_STATEMENT + 'isAcitve__c = true' +
                AND_STATEMENT + 'Iso_Code__c IN :isoCodes';

        return Database.query(query);
    }
}