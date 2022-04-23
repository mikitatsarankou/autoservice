import {LightningElement, track} from 'lwc';

import getProductsByCity from '@salesforce/apex/ProductsController.getProductsByCity'
import getProducts from '@salesforce/apex/ProductsController.getProducts'
import getProductsWithNewCurrencyPrice from '@salesforce/apex/ProductsController.getProductsWithNewCurrencyPrice'
import getCurrencyOptions from '@salesforce/apex/CurrencyController.getCurrencies'


export default class ProductsViewer extends LightningElement {

    domainName = 'https://tsarankou-dev-ed--c.documentforce.com/servlet/servlet.FileDownload?file=';
    @track error;
    @track displayProducts = false;
    @track displayPrices = true;
    @track isStandardCurrency = true;

    @track currencyOptions = [];
    @track currentCurrency = 'USD';
    @track newCurrency;
    
    @track recordsList = [];
    @track currentProducts = [];
    
    searchTerm = '';

    connectedCallback() {
        getProducts({})
            .then(result => {
                this.setProducts(result, false);
            });
        getCurrencyOptions({})
            .then(result => {
                this.setCurrencyOptions(result);
            })
    }

    setCurrencyOptions(options) {
        for (let key in options) {
            this.currencyOptions.push({
                label: options[key].isoCode,
                value: options[key].isoCode
            });
        }
        console.log(this.currencyOptions);
    }

    setProducts(products, isDefaultToLoad) {
        if (isDefaultToLoad) {
            this.currentCurrency = 'USD';
        }
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
        this.currentProducts = products;
    }

    handleChangeCurrency(event) {
        this.newCurrency = event.detail.value;
        this.displayPrices = false;
        getProductsWithNewCurrencyPrice({currentProcutsToChangeJSON: JSON.stringify(this.currentProducts), newIsoCode: this.newCurrency, oldIsoCode: this.currentCurrency})
            .then(result => {
                this.setProducts(result, false);
                this.currentCurrency = this.newCurrency;
                this.newCurrency = null;
                this.displayPrices = true;
            })
            .catch(err => {
                console.log(err);
            });        
    }

    handleInput(event) {
        this.searchTerm = event.detail.value;
        getProductsByCity({city: this.searchTerm})
            .then((results) => {
                if (results.length !== 0) {
                    this.setProducts(results, false);
                } 
            }).catch(error => {
                alert(error);
        });
    }

    loadDefault(event) {
        getProducts({})
            .then(result => {
                this.setProducts(result, true);
            });
    }
}