import {LightningElement, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getProductsByCity from '@salesforce/apex/ProductsController.getProductsByCity'
import getProducts from '@salesforce/apex/ProductsController.getProducts'


export default class ProductsViewer extends LightningElement {

    domainName = 'https://tsarankou-dev-ed--c.documentforce.com/servlet/servlet.FileDownload?file=';
    @track error;
    @track displayProducts = false;
    @track recordsList = [];
    @track isLoading = false;
    searchTerm = '';

    connectedCallback() {
        getProducts({})
            .then(result => {
                this.setterFunction(result);
            });
    }

    handleInput(event) {
        this.isLoading = true;
        this.searchTerm = event.detail.value;
        console.log(this.searchTerm);
        getProductsByCity({city: this.searchTerm})
            .then((results) => {
                if (results.length !== 0) {
                    this.setterFunction(results);
                } else {
                    this.showNotification();
                }
            }).catch(error => {
                console.log(JSON.parse(JSON.stringify(error)));
                alert(error);
        });
        this.isLoading = false;
    }

    loadDefault(event) {
        getProducts({})
            .then(result => {
                this.setterFunction(result);
            });
    }

    setterFunction(products) {
        this.displayProducts = false;
        this.recordsList = [];
        for (let key in products) {
            var attachmentLink = products[key].isAttachmentExists ? this.domainName + products[key].attachmentId : 'null';
            this.recordsList.push({
                Key: products[key].product.Id,
                Model: products[key].product.Car_Model__c.replace('_', ' '),
                BuildDate: products[key].product.Build_Date__c,
                Color: products[key].product.Color__c,
                CarType: products[key].product.Car_Type__c,
                Price: products[key].product.Price__c,
                Horsepower: products[key].product.Horsepower__c,
                FuelType: products[key].product.Fuel_Type__c,
                EngineCapacity: products[key].product.Engine_Capacity__c,
                isAttachmentsExists: products[key].isAttachmentExists,
                Attachment: attachmentLink
            })
        }
        this.displayProducts = true;
    }

    showNotification() {
        const evt = new ShowToastEvent({
            title: 'sorry',
            message: 'nothing was found',
            variant: 'info',
        });
        this.dispatchEvent(evt);
    }
}