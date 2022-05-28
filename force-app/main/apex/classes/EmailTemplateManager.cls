public class EmailTemplateManager {

    public static final Id ladaCustomerSupportId = '00l2w000000j0taAAA';

    public static List<EmailTemplate> getEmailTemplatesByFolderNameId(List<Id> ids, String description) {
        return [
                SELECT Id, Name, FolderName, FolderId, Description
                FROM EmailTemplate
                WHERE FolderId IN: ids AND Description =: description
        ];
    }
}