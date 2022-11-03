public class ContentDistributionTriggerHandler extends TriggerHandler {

    public ContentDistributionTriggerHandler() {
        ObjectName = 'ContentDistribution';
    }

    protected override void afterInsert() {
        populateProductsContentDownloadUrlField(getNewContentDistributionsMap());
    }

    private static void populateProductsContentDownloadUrlField(Map<Id, ContentDistribution> newContentDistributionsByIdMap) {
        Map<Id, ContentDistribution> contentDistributionsById = new Map<Id, ContentDistribution>(
                ContentDistributionService.getContentDistributionsByIds(newContentDistributionsByIdMap.keySet())
        );

        if (contentDistributionsById.isEmpty()) {
            return;
        }

        Map<Id, String> contentDownloadUrlByContentDocumentId = new Map<Id, String>();
        for (ContentDistribution contentDistribution : contentDistributionsById.values()) {
            contentDownloadUrlByContentDocumentId.put(contentDistribution.ContentDocumentId, contentDistribution.ContentDownloadUrl);
        }

        List<ContentDocumentLink> contentDocumentLinks = ContentDocumentLinkService.getContentDocumentLinksByContentDocumentIds(
                contentDownloadUrlByContentDocumentId.keySet()
        );

        Map<Id, Id> contentDocumentIdByLinkedEntityId = new Map<Id, Id>();
        for(ContentDocumentLink contentDocumentLink : contentDocumentLinks) {
            contentDocumentIdByLinkedEntityId.put(contentDocumentLink.LinkedEntityId ,contentDocumentLink.ContentDocumentId);
        }

        List<Product2> products = ProductsService.getProductsByIds(contentDocumentIdByLinkedEntityId.keySet());
        List<Product2> productsToUpdate = new List<Product2>();

        for (Product2 product : products) {
            if (product.Content_Download_Url__c == null && contentDocumentIdByLinkedEntityId.containsKey(product.Id)) {
                product.Content_Download_Url__c = contentDownloadUrlByContentDocumentId.get(contentDocumentIdByLinkedEntityId.get(product.Id));
                productsToUpdate.add(product);
            }
        }

        update productsToUpdate;
    }

    public Map<Id, ContentDistribution> getNewContentDistributionsMap() {
        return (Map<Id, ContentDistribution>) Trigger.newMap;
    }
}