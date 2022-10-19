public class CarCentersController {

    @AuraEnabled(Cacheable = true)
    public static List<DealershipsWithProductsWrapper> getDealershipsWithProductsWrapper() {
        List<Car_Center__c> carCenters = getCarCentersLocations();
        return CarCentersService.getDealershipsWithProductsWrappers(carCenters);
    }

    @AuraEnabled(Cacheable = true)
    public static List<CarCenterLocationsWrapper> getResultList() {
        List<Car_Center__c> carCenters = getCarCentersLocations();
        return getCarCenterLocationsToDisplayWrappers(carCenters);
    }

	@AuraEnabled
    public static List<Car_Center__c> getCarCentersLocations() {
        return CarCentersService.getCarCentersLocations();
    }

    @AuraEnabled
    public static List<CarCenterLocationsWrapper> getCarCenterLocationsToDisplayWrappers(List<Car_Center__c> carCenters) {
        return CarCentersService.getCarCenterLocationsToDisplayWrappers(carCenters);
    }


    public class DealershipsWithProductsWrapper {
        @AuraEnabled
        public LocationWrapper locationWrapper;
        @AuraEnabled
        public List<ProductsController.ProductWrapper> products;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String icon;
        @AuraEnabled
        public String title;

        public DealershipsWithProductsWrapper() {

        }
    }

    public class CarCenterLocationsWrapper {
        @AuraEnabled
        public LocationWrapper locationWrapper;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String icon;
        @AuraEnabled
        public String title;

        public CarCenterLocationsWrapper() {

        }
    }

    public class LocationWrapper {
        @AuraEnabled
        public String street;
        @AuraEnabled
        public String city;
        @AuraEnabled
        public String country;

        public LocationWrapper(String street, String city, String country) {
            this.street = street;
            this.city = city;
            this.country = country;
        }
    }
}