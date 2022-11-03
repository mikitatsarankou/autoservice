public without sharing class ProductsService {

    private static final String CORPORATE_CURRENCY = 'PLN';

    public static Product2 getProductById(List<Id> productId) {
        return ProductsManager.getProductById(productId);
    }

    public static List<Product2> getProductsByIds(List<Id> productsIds) {
        return ProductsManager.getProductsByIds(productsIds);
    }

    public static List<Product2> getProductsByIds(Set<Id> productsIds) {
        return ProductsManager.getProductsByIds(productsIds);
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

    public static List<ProductsController.ProductWrapper> getProductsWithNewCurrencyPrice(List<ProductsController.ProductWrapper> currentProductsToChange, String newIsoCode, String oldIsoCode) {
        if (String.isNotBlank(newIsoCode) && String.isNotBlank(oldIsoCode)) {
            if (newIsoCode == CORPORATE_CURRENCY) {
                List<String> isoCodes = new List<String>{
                        oldIsoCode
                };
                List<Currency__c> customCurrencies = CurrencyService.getCustomCurrenciesByIsoCodes(isoCodes);

                if (!customCurrencies.isEmpty()) {
                    for (ProductsController.ProductWrapper productWrapper : currentProductsToChange) {
                        Decimal priceToSet = productWrapper.product.Price__c * customCurrencies[0].Conversion_Rate__c;
                        productWrapper.product.Price__c = priceToSet.setScale(0);
                    }
                }
            }

            if (oldIsoCode == CORPORATE_CURRENCY) {
                List<String> isoCodes = new List<String>{
                        newIsoCode
                };
                List<Currency__c> customCurrencies = CurrencyService.getCustomCurrenciesByIsoCodes(isoCodes);

                if (!customCurrencies.isEmpty()) {
                    for (ProductsController.ProductWrapper productWrapper : currentProductsToChange) {
                        Decimal priceToSet = productWrapper.product.Price__c / customCurrencies[0].Conversion_Rate__c;
                        productWrapper.product.Price__c = priceToSet.setScale(0);
                    }
                }
            }

            if (oldIsoCode != CORPORATE_CURRENCY && newIsoCode != CORPORATE_CURRENCY) {
                List<String> isoCodes = new List<String>{
                        newIsoCode, oldIsoCode
                };
                List<Currency__c> customCurrencies = CurrencyService.getCustomCurrenciesByIsoCodes(isoCodes);

                Currency__c oldCurrency;
                Currency__c newCurrency;

                if (!customCurrencies.isEmpty()) {
                    for (Currency__c currencyType : customCurrencies) {
                        if (currencyType.Iso_Code__c == newIsoCode) {
                            newCurrency = currencyType;
                        } else if (currencyType.Iso_Code__c == oldIsoCode) {
                            oldCurrency = currencyType;
                        }
                    }

                    for (ProductsController.ProductWrapper productWrapper : currentProductsToChange) {
                        Decimal corporatePrice = productWrapper.product.Price__c * oldCurrency.Conversion_Rate__c;
                        Decimal priceToSet = corporatePrice / newCurrency.Conversion_Rate__c;
                        productWrapper.product.Price__c = priceToSet.setScale(0);
                    }
                }
            }
        }
        return currentProductsToChange;
    }

    public static List<ProductsController.ProductWrapper> formProductWrappers(List<Product2> products) {
        List<ProductsController.ProductWrapper> productWrappers = new List<ProductsController.ProductWrapper>();

        for (Product2 product : products) {
            ProductsController.ProductWrapper productWrapper = new ProductsController.ProductWrapper();
            productWrapper.product = product;
            productWrapper.contentDownloadUrl = product.Content_Download_Url__c;
            productWrapper.imageNotEmpty = productWrapper.contentDownloadUrl != null ? true : false;
            productWrappers.add(productWrapper);
        }

        return productWrappers;
    }
}