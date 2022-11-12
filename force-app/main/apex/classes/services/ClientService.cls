public without sharing class ClientService {
    public static ClientService.ProcessResultWrapper processTestDriveForClient(TestDriveService.TestDriveFormWrapper testDriveFormWrapper) {
        try {
            Datetime testDriveDate = Utils.formDatetimeFromStringGTM(testDriveFormWrapper.selectedDate);
            ClientService.ProcessResultWrapper testDriveForExistingContact = TestDriveService.planTestDriveForExistingContact(testDriveFormWrapper, testDriveDate);
            if (testDriveForExistingContact.result) {
                return testDriveForExistingContact;
            }
            ClientService.ProcessResultWrapper testDriveForExistingLead = TestDriveService.planTestDriveForExistingLead(testDriveFormWrapper, testDriveDate);
            if (testDriveForExistingLead.result) {
                return testDriveForExistingLead;
            }
            return TestDriveService.planTestDriveForNewLead(testDriveFormWrapper, testDriveDate);
        } catch (Exception caughtException) {
            insert new InternalMessageService(
                    'ClientService.processTestDriveForClient',
                    'failed to processTestDriveForClient',
                    caughtException
            ).createNewInternalMessage();
            return ClientService.getNegativeProcessResultWrapper();
        }
    }

    public static ClientService.ProcessResultWrapper processCaseForClient(CaseService.CaseFormWrapper caseFormWrapper) {
        try {
            ClientService.ProcessResultWrapper caseForExistingContact = CaseService.createCaseForExistingContact(caseFormWrapper);
            if (caseForExistingContact.result) {
                return caseForExistingContact;
            }
            ClientService.ProcessResultWrapper caseForExistingLead = CaseService.createCaseForExistingLead(caseFormWrapper);
            if (caseForExistingLead.result) {
                return caseForExistingLead;
            }
            return CaseService.createCaseForNotExistingLead(caseFormWrapper);
        } catch (Exception caughtException) {
            insert new InternalMessageService(
                    'ClientService.processCaseForClient',
                    'failed to processCaseForClient',
                    caughtException
            ).createNewInternalMessage();
            return ClientService.getNegativeProcessResultWrapper();
        }
    }

    public static List<Case> getCasesById(Set<Id> casesIds) {
        return CaseService.getCasesById(casesIds);
    }

    public static ProcessResultWrapper getProcessResultWrapper(Boolean result, Set<Id> recordsIds) {
        return new ProcessResultWrapper(result, recordsIds);
    }

    public static ProcessResultWrapper getNegativeProcessResultWrapper() {
        return new ProcessResultWrapper(false, new Set<Id>());
    }

    public without sharing class ProcessResultWrapper {
        public Boolean result;
        public Set<Id> recordsIds;

        public ProcessResultWrapper(Boolean result, Set<Id> recordsIds) {
            this.result = result;
            this.recordsIds = recordsIds;
        }
    }
}