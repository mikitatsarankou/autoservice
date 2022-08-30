import {api, LightningElement, track} from 'lwc';

import getCurrencyOptions from '@salesforce/apex/CurrencyController.getCurrencies';
import {delay} from "c/helper";

export default class ProductsCustomizationSection extends LightningElement {

    @track error;
    @track isStandardCurrency = true;

    @track currencyOptions = [];
    @track currencyOptionsFromDB = [];
    @api currentCurrency = 'USD';
    @api newCurrency;

    @api searchTerm = '';

    isRendered = false;

    connectedCallback() {
        this.updateDisplayPrices(true);
    }

    renderedCallback() {
        if (!this.isRendered) {
            this.loadCurrencyOptions();
        }
        this.isRendered = true;
    }

    handleLoadDefault(event) {
        this.dispatchEvent(new CustomEvent("loaddefault"));
    }

    handleInput(event) {
        this.searchTerm = event.detail.value;
        try {
            this.dispatchEvent(new CustomEvent("cityinput", {
                detail: {
                    inputValue: this.searchTerm,
                }
            }));
        } catch (error) {
            this.error = error;
        }
    }

    handleCurrency(event) {
        this.newCurrency = event.detail.value;

        this.dispatchEvent(new CustomEvent("currencychange", {
            detail: {
                newIsoCode: this.newCurrency,
                oldIsoCode: this.currentCurrency
            }
        }));
    }

    updateDisplayPrices(value) {
        this.dispatchEvent(new CustomEvent("displaypriceschange", {
            detail: {
                value: value
            }
        }));
    }

    async loadCurrencyOptions() {
        this.getCurrencies();
        await delay(500);
        this.setCurrencyOptions(this.currencyOptionsFromDB);
    }

    getCurrencies() {
        getCurrencyOptions({})
            .then(result => {
                this.currencyOptionsFromDB = result;
            })
    }

    setCurrencyOptions(options) {
        this.currencyOptions = [];

        for (let key in options) {
            this.currencyOptions.push({
                label: options[key].code,
                value: options[key].code
            });
        }
    }
}