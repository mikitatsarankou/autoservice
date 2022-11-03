public class TestDriveManager {

    private static final Set<String> GENERAL_FIELDS_TO_QUERY_TEST_DRIVE = new Set<String>{
            'Id',
            'Event_Date_Time_Start__c',
            'Event_Date_Time_End__c'
    };

    private static final String FROM_TEST_DRIVE = ' FROM Test_Drive__c';
    private static final String WHERE_STATEMENT = ' WHERE ';
    private static final String OR_STATEMENT = ' OR ';
    private static final String AND_STATEMENT = ' AND ';

    public static final Integer DURATION_OF_TEST_DRIVE_IN_HOURS = 1;

    public static Test_Drive__c createAndLinkTestDriveToExistingContact(Contact contact,  Id selectedDealershipId, Id selectedProductId, Datetime selectedDate) {
        String formName = contact.FirstName + ' ' + contact.LastName  + ' ' + selectedProductId + ' ' + selectedDate;
        selectedDate = selectedDate.addHours(-3);

        Test_Drive__c testDrive = new Test_Drive__c(
                Name = formName,
                Product__c = selectedProductId,
                Car_Center__c = selectedDealershipId,
                Contact__c = contact.Id,
                Event_Date_Time_Start__c = selectedDate.addHours(-3),
                Event_Date_Time_End__c = selectedDate.addHours(DURATION_OF_TEST_DRIVE_IN_HOURS)
        );
        insert testDrive;

        return testDrive;
    }

    public static Test_Drive__c createAndLinkTestDriveToExistingLead(Lead lead,  Id selectedDealershipId, Id selectedProductId, Datetime selectedDate) {
        String formName = lead.FirstName + ' ' + lead.LastName  + ' ' + selectedProductId + ' ' + selectedDate;
        selectedDate = selectedDate.addHours(-3);

        Test_Drive__c testDrive = new Test_Drive__c(
                Name = formName,
                Product__c = selectedProductId,
                Car_Center__c = selectedDealershipId,
                Lead__c = lead.Id,
                Event_Date_Time_Start__c = selectedDate,
                Event_Date_Time_End__c = selectedDate.addHours(DURATION_OF_TEST_DRIVE_IN_HOURS)
        );
        insert testDrive;

        return testDrive;
    }

    public static List<Test_Drive__c> getTestDrivesByProductId(Id selectedProductId) {
        String fieldsToQuery = String.join(new List<String>(GENERAL_FIELDS_TO_QUERY_TEST_DRIVE), ',');
        String query = 'SELECT ' + fieldsToQuery +
                FROM_TEST_DRIVE +
                WHERE_STATEMENT + 'Product__c = :selectedProductId';

        return Database.query(query);
    }

}