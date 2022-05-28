public class AttachmentsManager {

    public static List<Attachment> getAttachmentsByParentIdsAndDescription(List<Id> parentIds, String description) {
        return [SELECT Id, Name, Description, ParentId FROM Attachment WHERE ParentId IN: parentIds AND Description =: description];
    }
}