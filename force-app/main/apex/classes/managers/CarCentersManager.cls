public class CarCentersManager {

    private static final Set<String> GENERAL_FIELDS_TO_QUERY = new Set<String>{
            'Country__c',
            'City__c',
            'Street__c',
            'Description__c'
    };

    private static final String FROM_CAR_CENTER = ' FROM Car_Center__c';
    private static final String WHERE_STATEMENT = ' WHERE ';
    private static final String OR_STATEMENT = ' OR ';
    private static final String AND_STATEMENT = ' AND ';

    public static List<Car_Center__c> getCarCentersLocations() {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY), ',');
        String query = 'SELECT ' + fieldsToQuery + FROM_CAR_CENTER;

        return Database.query(query);
    }
}