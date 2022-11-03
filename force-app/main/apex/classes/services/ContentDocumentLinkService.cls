public class ContentDocumentLinkService {

    public static List<ContentDocumentLink> getContentDocumentLinksByContentDocumentIds(Set<Id> contentDocumentIds) {
        return ContentDocumentLinkManager.getContentDocumentLinksByContentDocumentIds(contentDocumentIds);
    }
}