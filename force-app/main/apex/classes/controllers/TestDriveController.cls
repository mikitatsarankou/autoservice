public with sharing class TestDriveController {

    @AuraEnabled(Cacheable = true)
    public static String getTodaysDateAsString() {
        return TestDriveService.getTodaysDateAsString();
    }

    @AuraEnabled(Cacheable = true)
    public static String getMaxDateAsString() {
        return TestDriveService.getMaxDateAsString();
    }

    @AuraEnabled(Cacheable = true)
    public static String getMinDateAsString() {
        return TestDriveService.getMinDateAsString();
    }

    @AuraEnabled(Cacheable = true)
    public static Boolean isDateAlreadyBooked(TestDriveReservationWrapper testDriveReservationWrapper) {
        Boolean result = false;
        try {
            result = TestDriveService.isDateAlreadyBooked(testDriveReservationWrapper);
        } catch (Exception caughtException) {
            new InternalMessageService(
                    'TestDriveController.isDateAlreadyBooked',
                    'failed to get bookings',
                    caughtException
            ).createNewInternalMessage();
        }
        return result;
    }

    public class TestDriveReservationWrapper {
        @AuraEnabled
        public String selectedProductId;
        @AuraEnabled
        public String selectedDate;

        public TestDriveReservationWrapper() {

        }
    }
}