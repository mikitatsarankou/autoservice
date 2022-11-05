public without sharing class ClientController {

    @AuraEnabled
    public static Boolean processTestDriveForClient(ClientService.TestDriveFormWrapper testDriveFormWrapper) {
        Boolean result = false;
        try {
            result = ClientService.processTestDriveForClient(testDriveFormWrapper);
        } catch (Exception caughtException) {
            new InternalMessageService(
                    'ClientController.processTestDriveForClient',
                    'failed to processTestDriveForClient',
                    caughtException
            ).createNewInternalMessage();
        }
        return result;
    }

    @AuraEnabled
    public static Boolean processCaseForClient(ClientService.CaseFormWrapper caseFormWrapper) {
        Boolean result = false;
        try {
            result = ClientService.processCaseForClient(caseFormWrapper);
        } catch (Exception caughtException) {
            new InternalMessageService(
                    'ClientController.processCaseForClient',
                    'failed to processCaseForClient',
                    caughtException
            ).createNewInternalMessage();
        }
        return result;
    }
}