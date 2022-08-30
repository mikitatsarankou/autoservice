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
    public static List<ProductWrapper> getProductsWithNewCurrencyPrice(String idsJSON, String newIsoCode, String oldIsoCode) {
        List<Id> productsIds = ProductsController.JSON2IdsList(idsJSON);
        List<Product2> products = ProductsService.getProductsByIds(productsIds);
        List<ProductWrapper> productWrappers = ProductsService.formProductWrappers(products);
        return ProductsService.getProductsWithNewCurrencyPrice(productWrappers, newIsoCode, oldIsoCode);
    }

    public static List<ProductWrapper> JSON2ProductWrapperList(String json) {
        return (List<ProductWrapper>) System.JSON.deserialize(json, List<ProductWrapper>.class);
    }

    public static ProductWrapper JSON2ProductWrapper(String json) {
        return (ProductWrapper) System.JSON.deserialize(json, ProductWrapper.class);
    }

    public static List<Id> JSON2IdsList(String json) {
        return (List<Id>) System.JSON.deserialize(json, List<Id>.class);
    }

    public class ProductWrapper {
        @AuraEnabled
        public Product2 product;
        @AuraEnabled
        public Boolean imageNotEmpty;
        @AuraEnabled
        public String attachmentId;

        public ProductWrapper() {

        }
    }
}