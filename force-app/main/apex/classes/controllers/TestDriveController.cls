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
        return TestDriveService.isDateAlreadyBooked(selectedProductId, selectedDate);
    }
}