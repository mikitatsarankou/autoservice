public class ProductsController {

    @AuraEnabled(Cacheable = true)
    public static List<Product2> getProducts() {
        return ProductsService.getProducts();
    }

    @AuraEnabled(Cacheable = true)
    public static List<Product2> getProductsByCity(String city) {
        return ProductsService.getProductsByCity(city);
    }

}