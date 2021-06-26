public class ProductsService {

    private static final String PRESENTABLE_PHOTO_DESCRIPTION = 'presentable photo';

    public static Product2 getProductById(List<Id> productsIds) {
        return ProductsManager.getProductById(productsIds);
    }
    public static List<Product2> getProducts() {
        return ProductsManager.getProducts();
    }

    public static List<Product2> getProductsByCity(String city) {
        return ProductsManager.getProductsByCity(city);
    }

    public static List<Product2> getProductsByCarCenterId(Id carCenterId) {
        return ProductsManager.getProductsByCarCenterId(carCenterId);
    }

    public static List<ProductsController.ProductWrapper> formProductWrappers(List<Product2> products) {
        List<ProductsController.ProductWrapper> productWrappers = new List<ProductsController.ProductWrapper>();
        List<Attachment> attachments = AttachmentsManager.getAttachmentsByParentIdsAndDescription(Utils.getFieldIds(products, 'Id'), PRESENTABLE_PHOTO_DESCRIPTION);
        Map<Id, SObject> attachmentsByParentId = Utils.mapByIdField(attachments, 'parentId');
        for (Product2 product : products) {
            ProductsController.ProductWrapper productWrapper = new ProductsController.ProductWrapper();
            productWrapper.product = product;
            if (attachmentsByParentId.containsKey(product.Id)) {
                productWrapper.attachmentId = (String) attachmentsByParentId.get(product.Id).get('Id');
                productWrapper.isAttachmentExists = true;
                productWrapper.usdPrice = CurrencyManager.getUsdPrice(product.Price__c);
            }
            productWrappers.add(productWrapper);
        }
        return productWrappers;
    }
}