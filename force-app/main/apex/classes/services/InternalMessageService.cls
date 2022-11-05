public without sharing class InternalMessageService {

    private final String classMethod;
    private final String specifiedMessage;
    private final Exception caughtException;

    public InternalMessageService(String classMethod, String specifiedMessage, Exception caughtException) {
        this.classMethod = classMethod;
        this.specifiedMessage = specifiedMessage;
        this.caughtException = caughtException;
    }

    public void createNewInternalMessage() {
        InternalMessageManager.createNewInternalMessage(
                classMethod,
                specifiedMessage,
                caughtException
        );
    }
}