public class ProductsController {

    private static final String PRESENTABLE_PHOTO_DESCRIPTION = 'presentable photo';
    private static final String NO_ATTACHMENT = 'no attachment';

    @AuraEnabled(Cacheable = true)
    public static List<ProductWrapper> getProducts() {
        List<Product2> products = ProductsService.getProducts();
        return formProductWrappers(products);
    }

    @AuraEnabled(Cacheable = true)
    public static List<ProductWrapper> getProductsByCity(String city) {
        List<Product2> products = ProductsService.getProductsByCity(city);
        return formProductWrappers(products);
    }

    @AuraEnabled(Cacheable = true)
    public static List<ProductWrapper> formProductWrappers(List<Product2> products) {
        List<ProductWrapper> productWrappers = new List<ProductWrapper>();
        List<Attachment> attachments = AttachmentsManager.getAttachmentsByParentIdsAndDescription(Utils.getFieldIds(products, 'Id'), PRESENTABLE_PHOTO_DESCRIPTION);
        Map<Id, SObject> attachmentsByParentId = Utils.mapByIdField(attachments, 'parentId');
        for (Product2 product : products) {
            ProductWrapper productWrapper = new ProductWrapper();
            productWrapper.product = product;
            if (attachmentsByParentId.containsKey(product.Id)) {
                productWrapper.attachmentId = (String) attachmentsByParentId.get(product.Id).get('Id');
                productWrapper.isAttachmentExists = true;
            }
            productWrappers.add(productWrapper);
        }
        return productWrappers;
    }

    public class ProductWrapper {
        @AuraEnabled
        public Product2 product;
        @AuraEnabled
        public Boolean isAttachmentExists;
        @AuraEnabled
        public String attachmentId;

        public ProductWrapper() {

        }
    }
}