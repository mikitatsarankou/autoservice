import {LightningElement, track, api} from 'lwc';

import getProductsByCity from '@salesforce/apex/ProductsController.getProductsByCity'
import getProducts from '@salesforce/apex/ProductsController.getProducts'
import getProductsWithNewCurrencyPrice from '@salesforce/apex/ProductsController.getProductsWithNewCurrencyPrice'

import {jsonCopy, isEmpty, delay} from 'c/helper';

export default class ProductsViewer extends LightningElement {

    CONSTANT = {
        DOMAIN_NAME_FILES: 'https://tsarankou-dev-ed--c.documentforce.com/servlet/servlet.FileDownload?file=',
        DEFAULT_CURRENCY: 'USD',
        MAX_PRODUCTS_TO_SHOW: 3,
        CARD_PX_WIDTH_SIZE: 550,
        BUTTONS_DEFAULT_PX_WIDTH_SIZE: 1650
    }

    @track currentCurrency = this.CONSTANT.DEFAULT_CURRENCY;
    @track error;
    @track displayProducts = false;
    @track displayPrices = false;

    @track recordsList = [];
    @track currentProducts = [];
    @track productsByCity = [];
    @track productsWithNewCurrencyPrice = [];

    @track defaultProducts = [];

    @track currentProductsCount;

    @track currentRightPosition = 0;
    @track currentLeftPosition = 0;
    @track currentButtonsWidth = 0;

    isRendered = false;

    renderedCallback() {
        console.log('renderedCallback');

        if (!this.isRendered) {
            this.handleResizeLeftPosition(this.currentProducts.length);
            this.loadDefault();
        }
        this.isRendered = true;
    }

    setProducts(products, isDefaultToLoad) {
        console.log('setProducts');
        console.log('products: ', jsonCopy(products));
        this.disableProductsView();

        if (isDefaultToLoad) {
            this.setDefaultCurrency();
        }

        try {
            for (let key in products) {
                let imageNotEmpty = products[key].imageNotEmpty;
                let attachmentLink = imageNotEmpty ? this.CONSTANT.DOMAIN_NAME_FILES + products[key].attachmentId : 'null';
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

                this.handleResizeButtons(this.recordsList.length);

            }
        } catch (error) {
            this.error = error;
            console.log(error);
        }

        this.handleResizeButtons(this.recordsList.length);
        this.enableProductsView();

        console.log('this.recordsList.length: ', this.recordsList.length);
        console.log('this.displayProducts: ', this.displayProducts);
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
        console.log('this.defaultProducts.length', this.defaultProducts.length);
        if (this.defaultProducts.length === 0) {
            this.getDefaultProducts();
            await delay(1500);
        }
        console.log('this.defaultProducts.length', this.defaultProducts.length);
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
        let buttonsDiv = this.template.querySelector(".buttons-area-space");
        let widthToSet = 0;
        if (currentProductsLength < this.CONSTANT.MAX_PRODUCTS_TO_SHOW) {
            widthToSet = this.CONSTANT.BUTTONS_DEFAULT_PX_WIDTH_SIZE - this.CONSTANT.CARD_PX_WIDTH_SIZE;
        } else if (this.currentButtonsWidth === this.CONSTANT.BUTTONS_DEFAULT_PX_WIDTH_SIZE) {
            return;
        } else if (this.currentButtonsWidth !== this.CONSTANT.BUTTONS_DEFAULT_PX_WIDTH_SIZE && currentProductsLength > this.CONSTANT.MAX_PRODUCTS_TO_SHOW) {
            widthToSet = this.CONSTANT.BUTTONS_DEFAULT_PX_WIDTH_SIZE;
        }
        this.currentButtonsWidth = widthToSet;
        //buttonsDiv.style.width = widthToSet + 'px';
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