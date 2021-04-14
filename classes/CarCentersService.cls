public with sharing class CarCentersService {

    public static List<Car_Center__c> getCarCentersLocations() {
        return CarCentersManager.getCarCentersLocations();
    }

    public static List<CarCentersController.CarCenterLocationsWrapper> getCarCenterLocationsToDisplayWrappers(List<Car_Center__c> carCenters) {
        List<CarCentersController.CarCenterLocationsWrapper> carCenterLocationsToDisplayWrappers = new List<CarCentersController.CarCenterLocationsWrapper>();
        for (Integer i = 0; i < carCenters.size() ; i++) {
            CarCentersController.CarCenterLocationsWrapper carCenterLocationsWrapper = new CarCentersController.CarCenterLocationsWrapper();
            CarCentersController.LocationWrapper locationWrapper = new CarCentersController.LocationWrapper(
                    carCenters[i].Street__c, carCenters[i].City__c, carCenters[i].Country__c
            );
            carCenterLocationsWrapper.locationWrapper = locationWrapper;
            carCenterLocationsWrapper.icon = 'custom:custom26';
            carCenterLocationsWrapper.title = locationWrapper.country;
            carCenterLocationsWrapper.description = carCenters[i].Description__c;
            carCenterLocationsWrapper.value = 'car center ' + i;
            carCenterLocationsToDisplayWrappers.add(carCenterLocationsWrapper);
        }
        return carCenterLocationsToDisplayWrappers;
    }
}