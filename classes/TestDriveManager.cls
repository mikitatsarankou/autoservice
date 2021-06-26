public class TestDriveManager {

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
        List<Test_Drive__c> testDrives = [
                SELECT Id, Event_Date_Time_Start__c, Event_Date_Time_End__c FROM Test_Drive__c
                WHERE Product__c =: selectedProductId
        ];
        if (!testDrives.isEmpty()) {
            return testDrives;
        }
        return new List<Test_Drive__c>();
    }

}