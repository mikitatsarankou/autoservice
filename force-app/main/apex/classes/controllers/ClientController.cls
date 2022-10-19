public class ClientController {

    @AuraEnabled
    public static Boolean processTestDriveForClient(String name, String surname, String email,
            String phone, String selectedProductId, String selectedDealershipId, String selectedDate) {
        return ClientService.processTestDriveForClient(name, surname, email, phone, selectedProductId, selectedDealershipId, selectedDate);
    }

    @AuraEnabled
    public static Boolean processCaseForClient(String name, String surname, String email,
            String phone, String selectedDealershipId, String subject, String message) {
        return ClientService.processCaseForClient(name, surname, email, phone, selectedDealershipId, subject, message);
    }
}