public class EmailMessageService {

    public static Boolean sendMessages(Map<Id, SObject> clientByClientId, Id emailTemplateId) {
        return false;
    }

    public static Messaging.SingleEmailMessage creatEmailMessage(Id clientId, String email, Id emailTemplateId, Id orgWideEmailAddressId) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] {email};
        message.templateId = emailTemplateId;
        message.orgWideEmailAddressId = orgWideEmailAddressId != null ? orgWideEmailAddressId : null;
        message.targetObjectId = UserInfo.getUserId();
        message.whatId = clientId;
        message.saveAsActivity = false;
        message.setTreatTargetObjectAsRecipient(false);

        return message;
    }
}