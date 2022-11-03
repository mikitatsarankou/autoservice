public class ContentDistributionManager {

    public static List<ContentDistribution> getContentDistributionsByIds(Set<Id> contentDistributionsIds) {
        return [
                SELECT Id, ContentDocumentId, ContentDownloadUrl
                FROM ContentDistribution
                WHERE Id IN :contentDistributionsIds
        ];
    }

}