public class CarCentersManager {

    public static List<Car_Center__c> getCarCentersLocations() {
        return [SELECT Country__c, City__c, Street__c, Description__c  FROM Car_Center__c];
    }
}