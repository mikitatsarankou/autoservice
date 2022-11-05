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
    public static Boolean isDateAlreadyBooked(String selectedProductId, String selectedDate) {
        Boolean result = false;
        try {
            result = TestDriveService.isDateAlreadyBooked(selectedProductId, selectedDate);
        } catch (Exception caughtException) {
            new InternalMessageService(
                    'TestDriveController.isDateAlreadyBooked',
                    'failed to get bookings',
                    caughtException
            ).createNewInternalMessage();
        }
        return result;
    }
}