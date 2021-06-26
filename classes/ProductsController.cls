public class ProductsController {

    @AuraEnabled(Cacheable = true)
    public static List<ProductWrapper> getProducts() {
        List<Product2> products = ProductsService.getProducts();
        return ProductsService.formProductWrappers(products);
    }

    @AuraEnabled(Cacheable = true)
    public static List<ProductWrapper> getProductsByCarCenterId(Object carCenterId) {
        List<Product2> products = ProductsService.getProductsByCarCenterId((Id) carCenterId);
        return ProductsService.formProductWrappers(products);
    }

    @AuraEnabled(Cacheable = true)
    public static List<ProductWrapper> getProductsByCity(Object city) {
        List<Product2> products = ProductsService.getProductsByCity((String) city);
        return ProductsService.formProductWrappers(products);
    }

    public class ProductWrapper {
        @AuraEnabled
        public Product2 product;
        @AuraEnabled
        public Decimal usdPrice;
        @AuraEnabled
        public Boolean isAttachmentExists;
        @AuraEnabled
        public String attachmentId;

        public ProductWrapper() {

        }
    }
}