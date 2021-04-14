public class ProductsService {
    public static List<Product2> getProducts() {
        return ProductsManager.getProducts();
    }

    public static List<Product2> getProductsByCity(String city) {
        return ProductsManager.getProductsByCity(city);
    }
}