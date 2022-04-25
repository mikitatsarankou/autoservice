public class ProductsService {

    private static final String PRESENTABLE_PHOTO_DESCRIPTION = 'presentable photo';
    private static final String CORPORATE_CURRENCY = 'PLN';

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

    public static List<ProductsController.ProductWrapper> getProductsWithNewCurrencyPrice(List<ProductsController.ProductWrapper> currentProcutsToChange, String newIsoCode, String oldIsoCode) {
        if (String.isNotBlank(newIsoCode) && String.isNotBlank(oldIsoCode)) {
            if (newIsoCode == CORPORATE_CURRENCY) {
                List<String> isoCodes = new List<String>{oldIsoCode};
                List<CurrencyType> currencies = CurrencyService.getCurrenciesByIsoCodes(isoCodes);

                if (!currencies.isEmpty()) {
                    for (ProductsController.ProductWrapper productWrapper : currentProcutsToChange) {
                        Decimal priceToSet = productWrapper.product.Price__c * currencies[0].ConversionRate;
                        productWrapper.product.Price__c = priceToSet.setScale(0);
                    }
                }
            }

            if (oldIsoCode == CORPORATE_CURRENCY) {
                List<String> isoCodes = new List<String>{newIsoCode};
                List<CurrencyType> currencies = CurrencyService.getCurrenciesByIsoCodes(isoCodes);

                if (!currencies.isEmpty()) {
                    for (ProductsController.ProductWrapper productWrapper : currentProcutsToChange) {
                        Decimal priceToSet = productWrapper.product.Price__c / currencies[0].ConversionRate;
                        productWrapper.product.Price__c = priceToSet.setScale(0);
                    }
                }
            }

            if (oldIsoCode != CORPORATE_CURRENCY && newIsoCode != CORPORATE_CURRENCY) {
                List<String> isoCodes = new List<String>{newIsoCode, oldIsoCode};
                List<CurrencyType> currencies = CurrencyService.getCurrenciesByIsoCodes(isoCodes);

                CurrencyType oldCurrency;
                CurrencyType newCurrency;

                if (!currencies.isEmpty()) {
                    for (CurrencyType currencyType : currencies) {
                        if (currencyType.isoCode == newIsoCode) {
                            newCurrency = currencyType;
                        } else if (currencyType.isoCode == oldIsoCode) {
                            oldCurrency = currencyType;
                        }
                    }
                
                    for (ProductsController.ProductWrapper productWrapper : currentProcutsToChange) {
                        Decimal corporatePrice = productWrapper.product.Price__c * oldCurrency.ConversionRate;
                        Decimal priceToSet = corporatePrice / newCurrency.ConversionRate;
                        productWrapper.product.Price__c = priceToSet.setScale(0);
                    }
                }
            }        
        }
        return currentProcutsToChange;
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
            }
            productWrappers.add(productWrapper);
        }
        return productWrappers;
    }
}