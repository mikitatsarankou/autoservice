public class ProductsManager {
    private static final String AUDI = 'Audi';

    public static List<Product2> getProducts() {
        return [
                SELECT Id, Car_Model__c, Build_Date__c,
                        Price__c, Car_Type__c, Color__c, Horsepower__c,
                        Engine_Capacity__c, Fuel_Type__c
                FROM Product2
                WHERE Name LIKE: AUDI + '%'
        ];
    }

    public static List<Product2> getProductsByCity(String city) {
        return [
                SELECT Id, Car_Model__c, Build_Date__c,
                        Price__c, Car_Type__c, Color__c, Horsepower__c,
                        Engine_Capacity__c, Fuel_Type__c, Car_Center__r.City__c
                FROM Product2
                WHERE Name LIKE: AUDI + '%'
                AND Car_Center__r.City__c LIKE: city + '%'
        ];
    }

    public static List<Product2> getProductsByCarCenterId(Id carCenterId) {
        return [
                SELECT Id, Car_Model__c, Build_Date__c,
                        Price__c, Car_Type__c, Color__c, Horsepower__c,
                        Engine_Capacity__c, Fuel_Type__c, Car_Center__c
                FROM Product2
                WHERE Name LIKE: AUDI + '%'
                AND Car_Center__c =: carCenterId
        ];
    }

    public static Product2 getProductById(List<Id> ids) {
        List<Product2> product2 = [
                SELECT Id, Car_Model__c, Build_Date__c,
                        Price__c, Car_Type__c, Color__c, Horsepower__c,
                        Engine_Capacity__c, Fuel_Type__c, Car_Center__c
                FROM Product2
                WHERE Id IN: ids
        ];
        if (!product2.isEmpty()) {
            return product2[0];
        }
        return null;
    }

    public static List<Product2> getProductsByIds(List<Id> ids) {
        List<Product2> product2 = [
                SELECT Id, Car_Model__c, Build_Date__c,
                        Price__c, Car_Type__c, Color__c, Horsepower__c,
                        Engine_Capacity__c, Fuel_Type__c, Car_Center__c
                FROM Product2
                WHERE Id IN: ids
        ];
        if (!product2.isEmpty()) {
            return product2;
        }
        return null;
    }
}