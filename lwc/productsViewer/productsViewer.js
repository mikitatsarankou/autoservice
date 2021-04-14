import {LightningElement, track} from 'lwc';

import getProducts from '@salesforce/apex/ProductsController.getProducts'
export default class ProductsViewer extends LightningElement {

    domainName = 'https://tsarankou-dev-ed--c.documentforce.com/servlet/servlet.FileDownload?file=';
    @track error;
    @track displayProducts = false;
    @track recordsList = [];

    connectedCallback() {
        getProducts({})
            .then(result => {
                for (let key in result) {
                    var attachmentLink = result[key].isAttachmentExists ? this.domainName + result[key].attachmentId : 'null';
                    this.recordsList.push({
                        Key: result[key].product.Id,
                        Model: result[key].product.Car_Model__c.replace('_', ' '),
                        BuildDate: result[key].product.Build_Date__c,
                        Color: result[key].product.Color__c,
                        CarType: result[key].product.Car_Type__c,
                        Price: result[key].product.Price__c,
                        Horsepower: result[key].product.Horsepower__c,
                        FuelType: result[key].product.Fuel_Type__c,
                        EngineCapacity: result[key].product.Engine_Capacity__c,
                        isAttachmentsExists: result[key].isAttachmentExists,
                        Attachment: attachmentLink
                    })
                }
                this.displayProducts = true;
            })
    }
}