public class EmailTemplateService {
    public static List<EmailTemplate> getEmailTemplatesByFolderNameId(List<Id> ids, String description) {
        return EmailTemplateManager.getEmailTemplatesByFolderNameId(ids, description);
    }
}