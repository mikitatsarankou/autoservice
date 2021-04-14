public class ProductsManager {
    private static final String LADA = 'LADA';

    public static List<Product2> getProducts() {
        return [
                SELECT Id, Car_Model__c, Build_Date__c,
                        Price__c, Car_Type__c, Color__c, Horsepower__c,
                        Engine_Capacity__c, Fuel_Type__c
                FROM Product2
                WHERE Name =: LADA
        ];
    }

    @AuraEnabled
    public static List<Product2> getProductsByCity(String city) {
        return [
                SELECT Id, Car_Model__c, Build_Date__c,
                        Price__c, Car_Type__c, Color__c, Horsepower__c,
                        Engine_Capacity__c, Fuel_Type__c, Car_Center__r.City__c
                FROM Product2
                WHERE Name =: LADA
                AND Car_Center__r.City__c =: city
        ];
    }
}