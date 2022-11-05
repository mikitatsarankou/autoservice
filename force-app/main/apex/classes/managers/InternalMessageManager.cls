public without sharing class InternalMessageManager {

    public static void createNewInternalMessage(String classMethod, String specifiedMessage, Exception caughtException) {
        Internal_Message__c internalMessage = new Internal_Message__c(
                Class_Name__c = classMethod,
                Name = specifiedMessage,
                Error_message__c =
                        caughtException.getCause() + '\n' +
                        caughtException.getMessage() + '\n' +
                        caughtException.getStackTraceString()
        );

        insert internalMessage;
    }
}