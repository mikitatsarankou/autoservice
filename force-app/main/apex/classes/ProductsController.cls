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

    @AuraEnabled(Cacheable = true)
    public static List<ProductWrapper> getProductsWithNewCurrencyPrice(String currentProcutsToChangeJSON, String newIsoCode, String oldIsoCode) {
        System.debug(currentProcutsToChangeJSON);
        List<ProductWrapper> currentProcutsToChange = JSON2ProductWrapperList(currentProcutsToChangeJSON);
        System.debug(currentProcutsToChange);
        return ProductsService.getProductsWithNewCurrencyPrice(currentProcutsToChange, newIsoCode, oldIsoCode);
    }

    public static List<ProductWrapper> JSON2ProductWrapperList(String json) {
        return (List<ProductWrapper>) System.JSON.deserialize(json, List<ProductWrapper>.class);
    }

    public static ProductWrapper JSON2ProductWrapper(String json) {
        return (ProductWrapper) System.JSON.deserialize(json, ProductWrapper.class);
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