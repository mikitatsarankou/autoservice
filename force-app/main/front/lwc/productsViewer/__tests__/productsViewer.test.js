import {createElement} from 'lwc';
import productsViewer from 'c/productsViewer';

import getProducts from '@salesforce/apex/ProductsController.getProducts'
import getCurrencyOptions from '@salesforce/apex/CurrencyController.getCurrencies'
import getProductsByCity from '@salesforce/apex/ProductsController.getProductsByCity'

jest.mock('@salesforce/apex/ProductsController.getProducts', () => {
    return {default: jest.fn()};
}, {virtual: true})

jest.mock('@salesforce/apex/CurrencyController.getCurrencies', () => {
    return {default: jest.fn()};
}, {virtual: true})

jest.mock('@salesforce/apex/ProductsController.getProductsByCity', () => {
    return {default: jest.fn()};
}, {virtual: true})
let element;

const mockedProductsList = require('./data/productsFromBack.json');
const mockedProductsMinskList = require('./data/productsMinks.json');
const mockedCurrenciesList = require('./data/currenciesFromBack.json');

describe('c-products-viewer', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    beforeEach(() => {
        getProducts.mockResolvedValue(mockedProductsList);
        getCurrencyOptions.mockResolvedValue(mockedCurrenciesList);
        getProductsByCity.mockResolvedValue(mockedProductsMinskList);

        element = createElement('c-products-viewer', {
            is: productsViewer,
        });
    })

    it('should smth', function () {
        element.displayProducts = false;
        element.displayPrices = true;
        element.isStandardCurrency = true;

        element.currentCurrency = 'USD';

        element.currentRightPosition = 0;
        element.currentLeftPosition = 0;
        element.currentButtonsWidth = 0;

        document.body.appendChild(element);

        return Promise.resolve()
            .then(() => {
                const inputElement = element.shadowRoot.querySelector('.reset-button');
                inputElement.dispatchEvent(new CustomEvent('click'));
            })
            .then(() => {
                const cardsElement = element.shadowRoot.querySelectorAll('.card');
                expect(cardsElement.length).toBe(7);
            });
    });
});
