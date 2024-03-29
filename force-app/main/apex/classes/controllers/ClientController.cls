public without sharing class ClientController {

    @AuraEnabled
    public static Boolean processTestDriveForClient(TestDriveService.TestDriveFormWrapper testDriveFormWrapper) {
        Boolean result = false;
        try {
            ClientService.ProcessResultWrapper processResultWrapper = ClientService.processTestDriveForClient(testDriveFormWrapper);
            if (processResultWrapper.result) {
                result = true;
            }
        } catch (Exception caughtException) {
            insert new InternalMessageService(
                    'ClientController.processTestDriveForClient',
                    'failed to processTestDriveForClient',
                    caughtException
            ).createNewInternalMessage();
        }
        return result;
    }

    @AuraEnabled
    public static Boolean processCaseForClient(CaseService.CaseFormWrapper caseFormWrapper) {
        Boolean result = false;
        try {
            ClientService.ProcessResultWrapper processResultWrapper = ClientService.processCaseForClient(caseFormWrapper);
            if (processResultWrapper.result) {
                result = true;
            }
        } catch (Exception caughtException) {
            insert new InternalMessageService(
                    'ClientController.processCaseForClient',
                    'failed to processCaseForClient',
                    caughtException
            ).createNewInternalMessage();
        }
        return result;
    }
}