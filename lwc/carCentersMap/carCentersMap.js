import {LightningElement, track} from 'lwc';

import getResultList from '@salesforce/apex/CarCentersController.getResultList'
export default class CarCentersMap extends LightningElement {

    @track error;
    @track displayMap = false;
    @track mapMarkers = [];
    @track recordsList = [];
    @track center = {
        location: {
            Latitude:'53.9006',
            Longitude:'27.5590'
        }
    }
    connectedCallback() {
        getResultList({})
            .then(result => {
                this.recordsList = result;
                for (let key in result) {
                    this.mapMarkers.push({
                        location: {
                            City: result[key].locationWrapper.city,
                            Country: result[key].locationWrapper.country,
                            Street: result[key].locationWrapper.street
                        },
                        value: result[key].value,
                        icon: 'standard:account',
                        title: result[key].title,
                        description: result[key].description
                    });
                }
                this.displayMap = true;

            })
            .catch(error => {
                this.error = error;
                alert(error);
            });
    }

    handleMarkerSelect(event) {
        this.selectedMarkerValue = event.target.selectedMarkerValue;

    }
}