public class CarCentersController {

    @AuraEnabled(Cacheable = true)
    public static List<DealershipsWithProductsWrapper> getDealershipsWithProductsWrapper() {
        List<DealershipsWithProductsWrapper> dealershipsWithProductsWrappers = new List<DealershipsWithProductsWrapper>();
        try {
            List<Car_Center__c> carCenters = getCarCentersLocations();
            dealershipsWithProductsWrappers = CarCentersService.getDealershipsWithProductsWrappers(carCenters);
        } catch (Exception caughtException) {
            new InternalMessageService(
                    'CarCentersController.getDealershipsWithProductsWrapper',
                    'failed to get dealerships',
                    caughtException
            ).createNewInternalMessage();
        }
        return dealershipsWithProductsWrappers;
    }

    @AuraEnabled(Cacheable = true)
    public static List<CarCenterLocationsWrapper> getResultList() {
        List<CarCenterLocationsWrapper> carCenterLocationsWrappers = new List<CarCenterLocationsWrapper>();
        try {
            List<Car_Center__c> carCenters = getCarCentersLocations();
            carCenterLocationsWrappers = getCarCenterLocationsToDisplayWrappers(carCenters);
        } catch (Exception caughtException) {
            new InternalMessageService(
                    'CarCentersController.getResultList',
                    'failed to get dealerships',
                    caughtException
            ).createNewInternalMessage();
        }
        return carCenterLocationsWrappers;
    }

	@AuraEnabled
    public static List<Car_Center__c> getCarCentersLocations() {
        List<Car_Center__c> carCenters = new List<Car_Center__c>();
        try {
            carCenters = CarCentersService.getCarCentersLocations();
        } catch (Exception caughtException) {
            new InternalMessageService(
                    'CarCentersController.getCarCentersLocations',
                    'failed to get dealerships',
                    caughtException
            ).createNewInternalMessage();
        }
        return carCenters;
    }

    @AuraEnabled
    public static List<CarCenterLocationsWrapper> getCarCenterLocationsToDisplayWrappers(List<Car_Center__c> carCenters) {
        List<CarCenterLocationsWrapper> carCenterLocationsWrappers = new List<CarCenterLocationsWrapper>();
        try {
            carCenterLocationsWrappers = CarCentersService.getCarCenterLocationsToDisplayWrappers(carCenters);
        } catch (Exception caughtException) {
            new InternalMessageService(
                    'CarCentersController.getCarCenterLocationsToDisplayWrappers',
                    'failed to get dealerships',
                    caughtException
            ).createNewInternalMessage();
        }
        return carCenterLocationsWrappers;
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