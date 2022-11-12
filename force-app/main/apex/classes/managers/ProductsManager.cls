public without sharing class ProductsManager {
    private static final String audiSearchKey = '%' + String.escapeSingleQuotes('Audi') + '%';

    private static final Set<String> GENERAL_FIELDS_TO_QUERY = new Set<String>{
            'Id',
            'Car_Model__c',
            'Build_Date__c',
            'Price__c',
            'Color__c',
            'Horsepower__c',
            'Engine_Capacity__c',
            'Fuel_Type__c',
            'Car_Center__C',
            'Content_Download_Url__c'
    };

    private static final String FROM_PRODUCT2 = ' FROM Product2';
    private static final String WHERE_STATEMENT = ' WHERE ';
    private static final String OR_STATEMENT = ' OR ';
    private static final String AND_STATEMENT = ' AND ';
    private static final String LIKE_STATEMENT = ' LIKE ';

    public static List<Product2> getProducts() {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_PRODUCT2 +
                WHERE_STATEMENT + 'Name' + LIKE_STATEMENT + ':audiSearchKey';

        return Database.query(query);
    }

    public static List<Product2> getProductsByCity(String city) {
        String citySearchKey = '%' + String.escapeSingleQuotes(city) + '%';
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_PRODUCT2 +
                WHERE_STATEMENT + 'Name' + LIKE_STATEMENT + ':audiSearchKey' +
                AND_STATEMENT + 'Car_Center__r.City__c' + LIKE_STATEMENT + ':citySearchKey';
        return Database.query(query);
    }

    public static List<Product2> getProductsByCarCenterId(Id carCenterId) {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_PRODUCT2 +
                WHERE_STATEMENT + 'Name' + LIKE_STATEMENT + ':audiSearchKey' +
                AND_STATEMENT + 'Car_Center__c = :carCenterId';

        return Database.query(query);
    }

    public static Product2 getProductById(List<Id> productsIds) {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_PRODUCT2 +
                WHERE_STATEMENT + 'Id IN :productsIds';

        List<Product2> products = Database.query(query);

        if (products.isEmpty()) {
            return new Product2();
        }
        return products.get(0);
    }

    public static List<Product2> getProductsByIds(List<Id> productsIds) {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_PRODUCT2 +
                WHERE_STATEMENT + 'Id IN :productsIds';

        return Database.query(query);
    }

    public static List<Product2> getProductsByIds(Set<Id> productsIds) {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_PRODUCT2 +
                WHERE_STATEMENT + 'Id IN :productsIds';

        return Database.query(query);
    }
}