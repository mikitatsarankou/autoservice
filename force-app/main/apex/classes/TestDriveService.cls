public class TestDriveService {
    private static final String DATE_FORMAT = 'yyyy-MM-dd';
    private static final Integer MAX_DAYS = 14;
    private static final Integer MIN_DAYS = 1;

    public static String getTodaysDateAsString() {
        return Datetime.now().format(DATE_FORMAT);
    }

    public static String getMaxDateAsString() {
        return Datetime.now().addDays(MAX_DAYS).format(DATE_FORMAT);
    }

    public static String getMinDateAsString() {
        return Datetime.now().addDays(MIN_DAYS).format(DATE_FORMAT);
    }

    public static Test_Drive__c createAndLinkTestDriveToExistingContact(Contact contact,  Id selectedDealershipId, Id selectedProductId, Datetime selectedDate) {
        return TestDriveManager.createAndLinkTestDriveToExistingContact(contact, selectedDealershipId, selectedProductId, selectedDate);
    }

    public static Test_Drive__c createAndLinkTestDriveToExistingLead(Lead lead,  Id selectedDealershipId, Id selectedProductId, Datetime selectedDate) {
        return TestDriveManager.createAndLinkTestDriveToExistingLead(lead, selectedDealershipId, selectedProductId, selectedDate);
    }

    public static Boolean isDateAlreadyBooked(Id selectedProductId, String selectedDate) {
        List<Test_Drive__c> testDrives = TestDriveManager.getTestDrivesByProductId(selectedProductId);
        if (testDrives.isEmpty()) return false;
        Datetime eventDateTimeStart = Utils.formDatetimeFromStringGTM3(selectedDate).addHours(-3);
        
        for (Test_Drive__c testDrive : testDrives) {
            if (testDrive.Event_Date_Time_Start__c.isSameDay(eventDateTimeStart)) {
                if (testDrive.Event_Date_Time_Start__c == eventDateTimeStart) {
                    return true;
                }
                if (eventDateTimeStart < testDrive.Event_Date_Time_Start__c && eventDateTimeStart.addMinutes(15) == testDrive.Event_Date_Time_Start__c
                        || eventDateTimeStart < testDrive.Event_Date_Time_Start__c && eventDateTimeStart.addMinutes(30) == testDrive.Event_Date_Time_Start__c
                        || eventDateTimeStart < testDrive.Event_Date_Time_Start__c && eventDateTimeStart.addMinutes(45) == testDrive.Event_Date_Time_Start__c) {
                    return true;
                }
                if (eventDateTimeStart > testDrive.Event_Date_Time_Start__c && eventDateTimeStart.addMinutes(-15) == testDrive.Event_Date_Time_Start__c
                        || eventDateTimeStart > testDrive.Event_Date_Time_Start__c && eventDateTimeStart.addMinutes(-30) == testDrive.Event_Date_Time_Start__c
                        || eventDateTimeStart > testDrive.Event_Date_Time_Start__c && eventDateTimeStart.addMinutes(-45) == testDrive.Event_Date_Time_Start__c) {
                    return true;
                }
            }
        }
        return false;
    }
}