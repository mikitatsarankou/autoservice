import {LightningElement, track} from 'lwc';

import getResultList from '@salesforce/apex/CarCentersController.getResultList'
export default class CarCentersMap extends LightningElement {

    @track error;
    @track displayMap = false;
    @track mapMarkers = [];
    @track recordsList = [];
    center = {
        location: {
            Latitude:'53.9006',
            Longitude:'27.5590'
        }
    }
    zoomLevel = 6;

    connectedCallback() {
        getResultList({})
            .then(results => {
                this.recordsList = results;
                for (let key in results) {
                    this.mapMarkers.push({
                        location: {
                            City: results[key].locationWrapper.city,
                            Country: results[key].locationWrapper.country,
                            Street: results[key].locationWrapper.street
                        },
                        value: results[key].locationWrapper.city,
                        icon: 'standard:account',
                        title: results[key].title,
                        description: results[key].description
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