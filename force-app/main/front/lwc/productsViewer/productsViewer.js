import {LightningElement, track, api} from 'lwc';

import getProductsByCity from '@salesforce/apex/ProductsController.getProductsByCity'
import getProducts from '@salesforce/apex/ProductsController.getProducts'
import getProductsWithNewCurrencyPrice from '@salesforce/apex/ProductsController.getProductsWithNewCurrencyPrice'

import {jsonCopy, isEmpty, delay} from 'c/helper';

export default class ProductsViewer extends LightningElement {

    CONSTANT = {
        DEFAULT_AUDI_LOGO: 'https://tsarankou-dev-ed.my.salesforce.com/sfc/dist/version/download/?oid=00D2w00000BKw6b&ids=0682w00000M1zDpAAJ&d=/a/2w000000QAhf/KH1DI0I_W4KGqhAxFRfhJZAPMQZHKvTzXcm1T_3SiAs&operationContext=DELIVERY&viewId=05H2w000002DpJmEAK&dpt=',
        DEFAULT_CURRENCY: 'USD',
        MAX_PRODUCTS_TO_SHOW: 3,
        CARD_PX_WIDTH_SIZE: 320,
        BUTTONS_DEFAULT_PX_WIDTH_SIZE: 1580
    }

    screenWidthIsLessThan1024;
    screenWidth;

    currentCurrency = this.CONSTANT.DEFAULT_CURRENCY;
    error;
    displayProducts = false;
    displayPrices = false;

    recordsList = [];
    currentProducts = [];
    productsByCity = [];
    productsWithNewCurrencyPrice = [];

    defaultProducts = [];

    currentLeftPosition = 0;

    isRendered = false;

    connectedCallback() {
        if (!this.isRendered) {
            this.screenWidthIsLessThan1024 = window.screen.width <= 1024;
            this.screenWidth = window.screen.width;
        }
    }

    renderedCallback() {

        if (!this.isRendered) {
            this.handleResizeLeftPosition(this.currentProducts.length);
            this.loadDefault();
        }
        this.isRendered = true;
    }

    setProducts(products, isDefaultToLoad) {
        this.disableProductsView();

        if (isDefaultToLoad) {
            this.setDefaultCurrency();
        }

        try {
            for (let key in products) {
                let imageNotEmpty = products[key].imageNotEmpty;
                let attachmentLink = imageNotEmpty ? products[key].contentDownloadUrl : this.CONSTANT.DEFAULT_AUDI_LOGO;
                let product = products[key].product;

                this.recordsList.push({
                    Key: product.Id,
                    Model: product.Car_Model__c.replace('_', ' '),
                    BuildDate: product.Build_Date__c,
                    Color: product.Color__c,
                    CarType: product.Car_Type__c,
                    Price: product.Price__c,
                    Horsepower: product.Horsepower__c,
                    FuelType: product.Fuel_Type__c,
                    EngineCapacity: product.Engine_Capacity__c,
                    isAttachmentsExists: imageNotEmpty,
                    Attachment: attachmentLink
                });
            }
        } catch (error) {
            this.error = error;
            console.log(error);
        }

        this.handleResizeButtons(this.recordsList.length);
        this.enableProductsView();
    }

    disableProductsView() {
        this.displayProducts = false;
        this.recordsList = [];
    }

    enableProductsView() {
        this.displayProducts = true;
        this.currentProducts = this.recordsList;
    }

    setDefaultCurrency() {
        this.currentCurrency = this.CONSTANT.DEFAULT_CURRENCY;
    }

    async handleCurrencyChange(event) {
        this.displayPrices = false;

        const {
            detail: {
                newIsoCode,
                oldIsoCode
            }
        } = event;

        this.getProductsWithCurrency(newIsoCode, oldIsoCode);
        await delay(500);
        this.processProducts(this.productsWithNewCurrencyPrice);

        this.currentCurrency = newIsoCode;
        this.displayPrices = true;
    }

    async handleCityInput(event) {
        const {
            detail: {
                inputValue
            }
        } = event;

        this.getProductsByCity(inputValue);
        await delay(500);
        this.processProducts(this.productsByCity);
    }

    processProducts(products) {
        isEmpty(products) ?
            this.loadDefault() :
            this.setProducts(products, false);
    }

    getProductsByCity(searchTerm) {
        this.productsByCity = [];

        getProductsByCity({city: searchTerm})
            .then((results) => {
                this.productsByCity = results;
            })
            .catch(error => {
                this.error = error;
            });
    }

    handleDisplayPricesChange(event) {
        const {
            detail: {
                value
            }
        } = event;

        this.displayPrices = value;
    }

    getProductsWithCurrency(newIsoCode, oldIsoCode) {
        this.productsWithNewCurrencyPrice = [];
        let productsIds = this.getIdsList(this.currentProducts);

        getProductsWithNewCurrencyPrice({
            idsJSON: jsonCopy(productsIds),
            newIsoCode: newIsoCode,
            oldIsoCode: oldIsoCode}
        )
            .then(result => {
                this.productsWithNewCurrencyPrice = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    getDefaultProducts() {
        getProducts({})
            .then(result => {
                this.defaultProducts = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    getIdsList(products) {
        let productsIds = [];

        products.forEach(product => {
            productsIds.push(product.Key)
        })

        return productsIds;
    }

    async loadDefault(event) {
        if (this.defaultProducts.length === 0) {
            this.getDefaultProducts();
            await delay(1500);
        }
        this.setProducts(this.defaultProducts, true);
    }

    handleMoveLeft(event) {
        if (this.currentLeftPosition !== 0 || this.currentLeftPosition > 0 || this.currentLeftPosition === 0) {
            this.applyLeftStyle(false);
        } 
    }

    handleMoveRight(event) {
        if (this.currentLeftPosition !== 0 || this.currentLeftPosition > 0 || this.currentLeftPosition === 0) {
            this.applyLeftStyle(true);
        }
    }

    applyLeftStyle(toSubtract) {
        let sliderContentDiv = this.template.querySelector(".slider-content");
        let positionToSet = 0;
        if (toSubtract) {
            positionToSet = this.currentLeftPosition - this.CONSTANT.CARD_PX_WIDTH_SIZE;
        } else {
            positionToSet = this.currentLeftPosition + this.CONSTANT.CARD_PX_WIDTH_SIZE;
        }
        this.currentLeftPosition = positionToSet;
        //sliderContentDiv.style.left = positionToSet + 'px';
    }

    handleResizeButtons(currentProductsLength) {

    }

    get sliderVisibleDiv() {
        return this.screenWidthIsLessThan1024 ? "slider-visible-mobile" : "slider-visible";
    }

    get sliderContentDiv() {
        return this.screenWidthIsLessThan1024 ? "slider-content-mobile" : "slider-content";
    }

    handleResizeLeftPosition(currentProductsLength) {
        if (currentProductsLength > 3 && currentProductsLength % 2 === 0) {
            let sliderContentDiv = this.template.querySelector(".slider-content");
            let positionToSet = 0;
            positionToSet = this.currentLeftPosition + (this.CONSTANT.CARD_PX_WIDTH_SIZE / 2);
            this.currentLeftPosition = positionToSet;
            //sliderContentDiv.style.left = this.currentLeftPosition + 'px';
        }
    }
}