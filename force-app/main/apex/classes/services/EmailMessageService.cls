public without sharing class EmailMessageService {

    private static final String DEFAULT_EMAIL_ADDRESS = 'tsarenkovn@gmail.com';

    private static Set<String> newCaseEmailFieldsToReplace = new Set<String>{
            'FirstName',
            'LastName',
            'CaseNumber'
    };

    private static Set<String> newTestDriveEmailFieldsToReplace = new Set<String>{
            'FirstName',
            'LastName',
            'ProductName',
            'ProductId',
            'CarCenterName',
            'CarCenterCountry',
            'CarCenterCity',
            'CarCenterStreet',
            'StartDate',
            'EndDate'
    };

    private static String newCaseText
            = 'Dear FirstName LastName, we are happy to say that your case with number CaseNumber being taking it to queue.';

    private static String newTestDriveText
            = 'Dear FirstName LastName, we are happy to say that your test drive was registered in owr system.' + '\n' +
                    'details:' + '\n' +
                    'product - ProductName' + '\n' +
                    'product Id - ProductId' + '\n' +
                    'dealership - CarCenterName, CarCenterCountry, CarCenterCity, CarCenterStreet' + '\n' +
                    'start date StartDate' + '\n' +
                    'end date EndDate';

    public static void sendEmailsForJustCreatedCases(List<NewCaseEmailFieldsWrapper> emailFieldsWrappers) {
        system.debug('sendEmailsForJustCreatedCases');
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();

        for (NewCaseEmailFieldsWrapper emailFieldsWrapper : emailFieldsWrappers) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('default');

            String body = newCaseText;
            for (String fieldToReplace : newCaseEmailFieldsToReplace) {
                body = body.replace(fieldToReplace, emailFieldsWrapper.fieldsMap.get(fieldToReplace));
            }
            mail.setPlainTextBody(body);
            mail.setToAddresses(new List<String>{
                    emailFieldsWrapper.emailAddress, DEFAULT_EMAIL_ADDRESS
            });
            mailList.add(mail);
        }


        if (!mailList.isEmpty()) {
            sendEmails(mailList);
        }
    }

    public static void sendEmailsForJustCreatedTestDrives(List<NewTestDriveEmailFieldsWrapper> emailFieldsWrappers) {
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();

        for (NewTestDriveEmailFieldsWrapper emailFieldsWrapper : emailFieldsWrappers) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('default');

            String body = newTestDriveText;
            for (String fieldToReplace : newTestDriveEmailFieldsToReplace) {
                body = body.replace(fieldToReplace, emailFieldsWrapper.fieldsMap.get(fieldToReplace));
            }
            mail.setPlainTextBody(body);
            mail.setToAddresses(new List<String>{
                    emailFieldsWrapper.emailAddress, DEFAULT_EMAIL_ADDRESS
            });
            mailList.add(mail);
        }


        if (!mailList.isEmpty()) {
            sendEmails(mailList);
        }
    }

    public static void sendEmails(List<Messaging.SingleEmailMessage> mailList) {
        system.debug(mailList);
        if (!mailList.isEmpty()) {
            Messaging.SendEmailResult[] results;
            try {
                results = Messaging.sendEmail(mailList);
            } catch (Exception caughtException) {
                new InternalMessageService(
                        'EmailMessageService.sendEmails',
                        'failed to send email',
                        caughtException
                ).createNewInternalMessageForFailedEmail();
            }

            system.debug(results);

            List<Internal_Message__c> internalMessages = new List<Internal_Message__c>();
            for (Messaging.SendEmailResult result : results) {
                if (!result.isSuccess() && !result.errors.isEmpty()) {
                    internalMessages.add(
                            new InternalMessageService(
                                    'EmailMessageService.sendEmails',
                                    'failed to send new test drive email',
                                    result.errors[0].message
                            ).createNewInternalMessageForFailedEmail());
                }
            }

            if (!internalMessages.isEmpty()) {
                insert internalMessages;
            }
        }
    }

    public class NewCaseEmailFieldsWrapper {
        public Map<String, String> fieldsMap = new Map<String, String>();
        public String emailAddress;

        public NewCaseEmailFieldsWrapper() {

        }

        public void setFirstName(String firstName) {
            fieldsMap.put('FirstName', firstName);
        }

        public void setLastName(String lastName) {
            fieldsMap.put('LastName', lastName);
        }

        public void setCaseNumber(String caseNumber) {
            fieldsMap.put('CaseNumber', caseNumber);
        }
    }

    public class NewTestDriveEmailFieldsWrapper {
        public Map<String, String> fieldsMap = new Map<String, String>();
        public String emailAddress;

        public void setFirstName(String firstName) {
            fieldsMap.put('FirstName', firstName);
        }
        public void setLastName(String lastName) {
            fieldsMap.put('LastName', lastName);
        }
        public void setProductName(String productName) {
            fieldsMap.put('ProductName', productName);
        }
        public void setProductId(String productId) {
            fieldsMap.put('ProductId', productId);
        }
        public void setCarCenterName(String carCenterName) {
            fieldsMap.put('CarCenterName', carCenterName);
        }
        public void setCarCenterCountry(String carCenterCountry) {
            fieldsMap.put('CarCenterCountry', carCenterCountry);
        }
        public void setCarCenterCity(String carCenterCity) {
            fieldsMap.put('CarCenterCity', carCenterCity);
        }
        public void setCarCenterStreet(String carCenterStreet) {
            fieldsMap.put('CarCenterStreet', carCenterStreet);
        }
        public void setStartDate(String startDate) {
            fieldsMap.put('StartDate', startDate);
        }
        public void setEndDate(String endDate) {
            fieldsMap.put('EndDate', endDate);
        }
    }
}