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

    public static List<Test_Drive__c> getTestDrivesById(Set<Id> testDrivesIds) {
        return TestDriveService.getTestDrivesById(testDrivesIds);
    }

    public static Boolean isDateAlreadyBooked(TestDriveController.TestDriveReservationWrapper testDriveReservationWrapper) {
        List<Test_Drive__c> testDrives = TestDriveManager.getTestDrivesByProductId(testDriveReservationWrapper.selectedProductId);
        if (testDrives.isEmpty()) {
            return false;
        }

        Datetime eventDateTimeStart = Utils.formDatetimeFromStringGTM(testDriveReservationWrapper.selectedDate);

        
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

    public static ClientService.ProcessResultWrapper planTestDriveForNewLead(TestDriveFormWrapper testDriveFormWrapper, Datetime testDriveDate) {
        Lead newLead = LeadService.newLead(
                testDriveFormWrapper.name,
                testDriveFormWrapper.surname,
                testDriveFormWrapper.email,
                testDriveFormWrapper.phone
        );

        Test_Drive__c testDrive = createAndLinkTestDriveToExistingLead(
                newLead,
                testDriveFormWrapper.selectedDealershipId,
                testDriveFormWrapper.selectedProductId,
                testDriveDate
        );

        OpportunityService.createAndLinkOpportunityToExistingLead(
                newLead,
                testDriveFormWrapper.selectedDealershipId,
                testDriveFormWrapper.selectedProductId,
                testDriveDate
        );

        return ClientService.getProcessResultWrapper(
                true,
                new Set<Id>{testDrive.Id}
        );
    }
    public static ClientService.ProcessResultWrapper planTestDriveForExistingLead(TestDriveFormWrapper testDriveFormWrapper, Datetime testDriveDate) {
        List<Lead> leads = LeadService.getLeadByEmailOrPhone(testDriveFormWrapper.email, testDriveFormWrapper.phone);

        if (leads.isEmpty()) {
            return ClientService.getNegativeProcessResultWrapper();
        }

        Lead leadToUpdate = leads.get(0);
        Lead updatedLead = LeadManager.updateLeadInfo(leadToUpdate);
        Test_Drive__c testDrive = createAndLinkTestDriveToExistingLead(
                updatedLead,
                testDriveFormWrapper.selectedDealershipId,
                testDriveFormWrapper.selectedProductId,
                testDriveDate
        );

        OpportunityService.createAndLinkOpportunityToExistingLead(
                updatedLead,
                testDriveFormWrapper.selectedDealershipId,
                testDriveFormWrapper.selectedProductId,
                testDriveDate
        );

        return ClientService.getProcessResultWrapper(
                true,
                new Set<Id>{testDrive.Id}
        );
    }
    public static ClientService.ProcessResultWrapper planTestDriveForExistingContact(TestDriveFormWrapper testDriveFormWrapper, Datetime testDriveDate) {
        List<Contact> contacts = ContactService.getContactByEmailOrPhone(testDriveFormWrapper.email, testDriveFormWrapper.phone);

        if (contacts.isEmpty()) {
            return ClientService.getNegativeProcessResultWrapper();
        }

        Contact contactToUpdate = contacts.get(0);
        Contact updatedContact = ContactManager.updateContactInfo(contactToUpdate);
        Test_Drive__c testDrive = createAndLinkTestDriveToExistingContact(
                updatedContact,
                testDriveFormWrapper.selectedDealershipId,
                testDriveFormWrapper.selectedProductId,
                testDriveDate
        );

        OpportunityService.createAndLinkOpportunityToExistingContact(
                updatedContact,
                testDriveFormWrapper.selectedDealershipId,
                testDriveFormWrapper.selectedProductId,
                testDriveDate
        );

        return ClientService.getProcessResultWrapper(
                true,
                new Set<Id>{testDrive.Id}
        );
    }

    //implemented by flow
    public static void sendEmailForNewTestDrives(List<Test_Drive__c> newTestDrives) {
        Set<Id> newTestDrivesIds = new Set<Id>();
        for (Test_Drive__c testDrive : newTestDrives) {
            newTestDrivesIds.add(testDrive.Id);
        }

        Map<Id, Test_Drive__c> newTestDrivesById = new Map<Id, Test_Drive__c>(
                TestDriveService.getTestDrivesById(newTestDrivesIds)
        );

        List<EmailMessageService.NewTestDriveEmailFieldsWrapper> newTestDriveEmailFieldsWrappers =
                new List<EmailMessageService.NewTestDriveEmailFieldsWrapper>();

        for (Test_Drive__c testDrive : newTestDrivesById.values()) {
            EmailMessageService.NewTestDriveEmailFieldsWrapper wrapper = new EmailMessageService.NewTestDriveEmailFieldsWrapper();

            wrapper.emailAddress = testDrive?.Lead__c != null ? testDrive.Lead__r.Email : testDrive.Contact__r.Email;
            wrapper.setFirstName(testDrive?.Lead__c != null ? testDrive.Lead__r.FirstName : testDrive.Contact__r.FirstName);
            wrapper.setLastName(testDrive?.Lead__c != null ? testDrive.Lead__r.LastName : testDrive.Contact__r.LastName);
            wrapper.setProductName(testDrive.Product__r.Car_Model__c);
            wrapper.setProductId(testDrive.Product__c);
            wrapper.setCarCenterName(testDrive.Car_Center__r.Name);
            wrapper.setCarCenterCountry(testDrive.Car_Center__r.Country__c);
            wrapper.setCarCenterCity(testDrive.Car_Center__r.City__c);
            wrapper.setCarCenterStreet(testDrive.Car_Center__r.Street__c);
            wrapper.setStartDate(String.valueOf(testDrive.Event_Date_Time_Start__c));
            wrapper.setStartDate(String.valueOf(testDrive.Event_Date_Time_End__c));

            newTestDriveEmailFieldsWrappers.add(wrapper);
        }

        EmailMessageService.sendEmailsForJustCreatedTestDrives(newTestDriveEmailFieldsWrappers);
    }

    public class TestDriveFormWrapper {
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String surname { get; set; }
        @AuraEnabled
        public String email { get; set; }
        @AuraEnabled
        public String phone { get; set; }
        @AuraEnabled
        public String selectedDealershipId { get; set; }
        @AuraEnabled
        public String selectedProductId { get; set; }
        @AuraEnabled
        public String selectedDate { get; set; }
    }
}