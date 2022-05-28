import {LightningElement, track, api} from 'lwc';

import getProductsByCity from '@salesforce/apex/ProductsController.getProductsByCity'
import getProducts from '@salesforce/apex/ProductsController.getProducts'
import getProductsWithNewCurrencyPrice from '@salesforce/apex/ProductsController.getProductsWithNewCurrencyPrice'
import getCurrencyOptions from '@salesforce/apex/CurrencyController.getCurrencies'
import RecurrenceStartDateOnly from '@salesforce/schema/Task.RecurrenceStartDateOnly';

export default class ProductsViewer extends LightningElement {

    CONSTANT = {
        DOMAIN_NAME_FILES: 'https://tsarankou-dev-ed--c.documentforce.com/servlet/servlet.FileDownload?file=',
        DEFAULT_CURRENCY: 'USD',
        MAX_PRODUCTS_TO_SHOW: 3,
        CARD_PX_WIDTH_SIZE: 550,
        BUTTONS_DEFAULT_PX_WIDTH_SIZE: 1650

    }

    @track error;
    @track displayProducts = false;
    @track displayPrices = true;
    @track isStandardCurrency = true;

    @track currencyOptions = [];
    @track currentCurrency = 'USD';
    @track newCurrency;

    @track recordsList = [];
    @track currentProducts = [];
    @track currentProductsCount;

    @track currentRightPosition = 0;
    @track currentLeftPosition = 0;
    @track currentButtonsWidth = 0;
    
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

    renderedCallback() {
        this.handleResizeLeftPosition(this.currentProducts.length);
    }

    setCurrencyOptions(options) {
        for (let key in options) {
            this.currencyOptions.push({
                label: options[key].code,
                value: options[key].code
            });
        }
    }

    setProducts(products, isDefaultToLoad) {
        if (isDefaultToLoad) {
            this.currentCurrency = 'USD';
        }
        this.displayProducts = false;
        this.recordsList = [];
        for (let key in products) {
            var attachmentLink = products[key].isAttachmentExists ? this.CONSTANT.DOMAIN_NAME_FILES + products[key].attachmentId : 'null';
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
            });
        }

        this.displayProducts = true;
        this.currentProducts = this.recordsList;
        this.handleResizeButtons(this.currentProducts.length);
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
            .catch(error => {
                this.error = error;
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
                this.error = error;
        });
    }

    loadDefault(event) {
        getProducts({})
            .then(result => {
                this.setProducts(result, true);
            });
    }

    handleMoveLeft(event) {
        if (this.currentLeftPosition != 0 || this.currentLeftPosition > 0 || this.currentLeftPosition == 0) {
            this.applyLeftStyle(false);
        } 
    }

    handleMoveRight(event) {
        if (this.currentLeftPosition != 0 || this.currentLeftPosition > 0 || this.currentLeftPosition == 0) {
            this.applyLeftStyle(true);
        }
    }

    applyLeftStyle(toSubtract) {
        let sliderContentDiv = this.template.querySelector(".slider-content");
        let positionToSet = 0;
        console.log('this.currentLeftPosition: ' + this.currentLeftPosition);
        if (toSubtract) {
            positionToSet = this.currentLeftPosition - this.CONSTANT.CARD_PX_WIDTH_SIZE;
        } else {
            positionToSet = this.currentLeftPosition + this.CONSTANT.CARD_PX_WIDTH_SIZE;
        }
        this.currentLeftPosition = positionToSet;
        // sliderContentDiv.style.left = positionToSet + 'px';
    }

    handleResizeButtons(currentProductsLength) {
        let buttonsDiv = this.template.querySelector(".buttons-area-space");
        let widthToSet = 0;
        if (currentProductsLength < this.CONSTANT.MAX_PRODUCTS_TO_SHOW) {
            widthToSet = this.CONSTANT.BUTTONS_DEFAULT_PX_WIDTH_SIZE - this.CONSTANT.CARD_PX_WIDTH_SIZE;
        } else if (this.currentButtonsWidth == this.CONSTANT.BUTTONS_DEFAULT_PX_WIDTH_SIZE) {
            return;
        } else if (this.currentButtonsWidth != this.CONSTANT.BUTTONS_DEFAULT_PX_WIDTH_SIZE && currentProductsLength > this.CONSTANT.MAX_PRODUCTS_TO_SHOW) {
            widthToSet = this.CONSTANT.BUTTONS_DEFAULT_PX_WIDTH_SIZE;
        }
        this.currentButtonsWidth = widthToSet;
        // buttonsDiv.style.width = widthToSet + 'px';
    }

    handleResizeLeftPosition(currentProductsLength) {
        if (currentProductsLength > 3 && currentProductsLength % 2 == 0) {
            let sliderContentDiv = this.template.querySelector(".slider-content");
            let positionToSet = 0;
            positionToSet = this.currentLeftPosition + (this.CONSTANT.CARD_PX_WIDTH_SIZE / 2);
            this.currentLeftPosition = positionToSet;
            // sliderContentDiv.style.left = this.currentLeftPosition + 'px';
        }
    }
}