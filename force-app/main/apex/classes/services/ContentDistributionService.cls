public class ContentDistributionService {

    public static List<ContentDistribution> getContentDistributionsByIds(Set<Id> contentDistributionsIds) {
        return ContentDistributionManager.getContentDistributionsByIds(contentDistributionsIds);
    }
}