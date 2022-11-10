public without sharing class InternalMessageService {

    private final String classMethod;
    private final String specifiedMessage;
    private final Exception caughtException;
    private final String caughtExceptionEmail;

    public InternalMessageService(String classMethod, String specifiedMessage, Exception caughtException) {
        this.classMethod = classMethod;
        this.specifiedMessage = specifiedMessage;
        this.caughtException = caughtException;
    }

    public InternalMessageService(String classMethod, String specifiedMessage, String caughtExceptionEmail) {
        this.classMethod = classMethod;
        this.specifiedMessage = specifiedMessage;
        this.caughtExceptionEmail = caughtExceptionEmail;
    }

    public Internal_Message__c createNewInternalMessageForFailedEmail() {
        return InternalMessageManager.createNewInternalMessageForFailedEmail(
                classMethod,
                specifiedMessage,
                caughtExceptionEmail
        );
    }

    public Internal_Message__c createNewInternalMessage() {
        return InternalMessageManager.createNewInternalMessage(
                classMethod,
                specifiedMessage,
                caughtException
        );
    }
}