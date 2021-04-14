import {LightningElement, track} from 'lwc';

import getProducts from '@salesforce/apex/ProductsController.getProducts'
export default class ProductsViewer extends LightningElement {

    @track error;
    @track displayProducts = false;
    @track recordsList = [];

    connectedCallback() {
        getProducts({})
            .then(result => {
                console.log(result);
                for (let key in result) {
                    this.recordsList.push({
                        Model: result[key].Car_Model__c.replace('_', ' '),
                        BuildDate: result[key].Build_Date__c,
                        Color: result[key].Color__c,
                        CarType: result[key].Car_Type__c,
                        Price: result[key].Price__c,
                        Horsepower: result[key].Horsepower__c,
                        FuelType: result[key].Fuel_Type__c,
                        EngineCapacity: result[key].Engine_Capacity__c
                    })
                }
            })
    }

    getImageForProduct() {
        
    }
}