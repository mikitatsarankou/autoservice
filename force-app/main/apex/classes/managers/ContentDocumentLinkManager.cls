public with sharing class ContentDocumentLinkManager {

    public static List<ContentDocumentLink> getContentDocumentLinksByContentDocumentIds(Set<Id> contentDocumentIds) {
        return [
                SELECT Id, LinkedEntityId, ContentDocumentId
                FROM ContentDocumentLink
                WHERE ContentDocumentId IN :contentDocumentIds
        ];
    }
}