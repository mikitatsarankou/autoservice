public without sharing class ProductsController {

    @AuraEnabled
    public static List<ProductWrapper> getProducts() {
        List<ProductWrapper> productWrappers = new List<ProductWrapper>();
        try {
            List<Product2> products = ProductsService.getProducts();
            productWrappers = ProductsService.formProductWrappers(products);
        } catch (Exception caughtException) {
            insert new InternalMessageService(
                    'ProductsController.getProducts',
                    'failed to get products from db',
                    caughtException
            ).createNewInternalMessage();
        }
        return productWrappers;
    }

    @AuraEnabled
    public static List<ProductWrapper> getProductsByCarCenterId(Object carCenterId) {
        List<ProductWrapper> productWrappers = new List<ProductWrapper>();
        try {
            List<Product2> products = ProductsService.getProductsByCarCenterId((Id) carCenterId);
            productWrappers = ProductsService.formProductWrappers(products);
        } catch (Exception caughtException) {
            insert new InternalMessageService(
                    'ProductsController.getProductsByCarCenterId',
                    'failed to get products from db',
                    caughtException
            ).createNewInternalMessage();
        }
        return productWrappers;
    }

    @AuraEnabled
    public static List<ProductWrapper> getProductsByCity(Object city) {
        List<ProductWrapper> productWrappers = new List<ProductWrapper>();
        try {
            List<Product2> products = ProductsService.getProductsByCity((String) city);
            productWrappers = ProductsService.formProductWrappers(products);
        } catch (Exception caughtException) {
            insert new InternalMessageService(
                    'ProductsController.getProductsByCity',
                    'failed to get products from db',
                    caughtException
            ).createNewInternalMessage();
        }
        return productWrappers;
    }

    @AuraEnabled
    public static List<ProductWrapper> getProductsWithNewCurrencyPrice(String idsJSON, String newIsoCode, String oldIsoCode) {
        List<ProductWrapper> productWrappers = new List<ProductWrapper>();
        try {
            List<Id> productsIds = ProductsController.JSON2IdsList(idsJSON);
            List<Product2> products = ProductsService.getProductsByIds(productsIds);
            List<ProductWrapper> productWrappersToProcess = ProductsService.formProductWrappers(products);
            return ProductsService.getProductsWithNewCurrencyPrice(productWrappersToProcess, newIsoCode, oldIsoCode);
        } catch (Exception caughtException) {
            insert new InternalMessageService(
                    'ProductsController.getProductsWithNewCurrencyPrice',
                    'failed to get products from db',
                    caughtException
            ).createNewInternalMessage();
        }
        return productWrappers;
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
        public String contentDownloadUrl;

        public ProductWrapper() {

        }
    }
}