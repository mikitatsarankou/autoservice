public without sharing class ClientController {

    @AuraEnabled
    public static Boolean processTestDriveForClient(ClientService.TestDriveFormWrapper testDriveFormWrapper) {
        return ClientService.processTestDriveForClient(testDriveFormWrapper);
    }

    @AuraEnabled
    public static Boolean processCaseForClient(ClientService.CaseFormWrapper caseFormWrapper) {
        return ClientService.processCaseForClient(caseFormWrapper);
    }
}