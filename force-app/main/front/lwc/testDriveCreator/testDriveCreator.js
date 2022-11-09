import {LightningElement, track, wire} from 'lwc';

import getTodaysDate from '@salesforce/apex/TestDriveController.getTodaysDateAsString'
import getMaxDate from '@salesforce/apex/TestDriveController.getMaxDateAsString'
import getMinDate from '@salesforce/apex/TestDriveController.getMinDateAsString'
import getDealershipsWithProducts from '@salesforce/apex/CarCentersController.getDealershipsWithProductsWrapper'
import checkSelectedDate from '@salesforce/apex/TestDriveController.isDateAlreadyBooked';
import createTestDrive from '@salesforce/apex/ClientController.processTestDriveForClient';

import {jsonCopy, isEmpty, delay} from 'c/helper';

export default class TestDriveCreator extends LightningElement {

    maxLengthName = 20;
    maxLengthSurname = 20;
    maxLengthEmail = 50;

    @track languageOptions =
        [{
            label: 'English',
            value: 'en'
        },
            {
                label: 'Russian',
                value: 'ru'
            }];

    displayTestDrive = true;
    displayDateBookedMessage = false;
    displayErrorMessage = false;
    displayWarningMessage = false;
    displaySuccessMessage = false;

    isFormHasError = true;
    today;
    minDate;
    maxDate;
    dealerships = [];
    dealershipsOptionsToPush = [];
    dealershipsOptions = [];
    carsOptionsToPush = [];
    carsOptions = [];

    selectedProductId;
    selectedDealershipId;
    selectedDate;
    name;
    surname;
    email;
    language;
    phone;

    _testDriveFormWrapper;
    _testDriveReservationWrapper;

    connectedCallback() {
        getDealershipsWithProducts({})
            .then(dealerships => {
                this.dealerships = dealerships;
                for (let key in dealerships) {
                    this.dealershipsOptionsToPush.push({
                        label: dealerships[key].locationWrapper.country + ', ' + dealerships[key].locationWrapper.city + ', ' + dealerships[key].locationWrapper.street,
                        value: dealerships[key].value
                    });
                }
            });
        getTodaysDate({})
            .then(date => {
                this.today = date;
            });
        getMaxDate({})
            .then(maxDate => {
                this.maxDate = maxDate;
            });
        getMinDate({})
            .then(minDate => {
                this.minDate = minDate;
            });
    }

    handleDealershipsLoad(event) {
        this.dealershipsOptions = this.dealershipsOptionsToPush
    }


    handleDealershipInput(event) {
        this.selectedDealershipId = event.detail.value;
        this.carsOptions = [];
        this.carsOptionsToPush = [];
        for (let dealershipsKey in this.dealerships) {
            if (this.dealerships[dealershipsKey].value === this.selectedDealershipId) {
                for (let key in this.dealerships[dealershipsKey].products)
                    this.carsOptionsToPush.push({
                        label:
                            'VIN: ' + this.dealerships[dealershipsKey].products[key].product.Id + ', ' +
                            'Model: ' + this.dealerships[dealershipsKey].products[key].product.Car_Model__c.replace('_', ' ') + ', ' +
                            'Price: ' + this.dealerships[dealershipsKey].products[key].product.Price__c,
                        value: this.dealerships[dealershipsKey].products[key].product.Id
                    });
            }
        }
    }

    handleNameInput(event) {
        this.name = event.detail.value;
    }

    handleSurnameInput(event) {
        this.surname = event.detail.value;
    }

    handleEmailInput(event) {
        this.email = event.detail.value;
    }

    handleCarLoad(event) {
        this.carsOptions = this.carsOptionsToPush;
    }

    handleCarInput(event) {
        this.selectedProductId = event.detail.value;
    }

    handlePhoneInput(event) {
        this.phone = event.detail.value;
    }

    handleLanguageInput(event) {
        this.language = event.detail.value;
    }

    handleDateInput(event) {
        this.selectedDate = event.detail.value;
    }

    isInputsCorrect(event) {
        let isInputsCorrect = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
        return !!isInputsCorrect;
    }

    handleSendButton(event) {
        if (this.isInputsCorrect(event)) {
            this.processReservationData();
            checkSelectedDate({testDriveReservationWrapper: this._testDriveReservationWrapper})
                .then(isBooked => {
                    if (isBooked === false) {
                        this.processData();
                        this.sendData();
                    } else {
                        this.displayDateBookedMessage = true;
                        delay(5000);
                        this.displayDateBookedMessage = false;
                    }
                })
                .catch(error => {
                    console.log(error);
                })
        } else {
            this.displayErrorMessage = true;
        }
    }

    processReservationData() {
        this._testDriveReservationWrapper = {
            selectedProductId: this.selectedProductId,
            selectedDate: this.selectedDate
        }
    }

    processData() {
        this._testDriveFormWrapper = {
            name: this.name,
            surname: this.surname,
            email: this.email,
            phone: this.phone,
            selectedProductId: this.selectedProductId,
            selectedDealershipId: this.selectedDealershipId,
            selectedDate: this.selectedDate
        }
    }

    sendData() {
        console.log(jsonCopy(this._testDriveFormWrapper));
        createTestDrive({
            testDriveFormWrapper: this._testDriveFormWrapper
        }).then(savedSuccessfully => {
            if (savedSuccessfully === false) {
                this.displayWarningMessage = true;
            } else {
                this.displaySuccessMessage = true
            }
        }).catch(error => {
            this.displayWarningMessage = true;
            console.log(error)
        });
    }


    closeToast(event) {
        this.displayDateBookedMessage = false;
        this.displayErrorMessage = false;
        this.displayWarningMessage = false;
        this.displaySuccessMessage = false;
    }
}