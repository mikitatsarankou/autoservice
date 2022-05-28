import {LightningElement, track, wire} from 'lwc';

import getTodaysDate from '@salesforce/apex/TestDriveController.getTodaysDateAsString'
import getMaxDate from '@salesforce/apex/TestDriveController.getMaxDateAsString'
import getMinDate from '@salesforce/apex/TestDriveController.getMinDateAsString'
import getDealershipsWithProducts from '@salesforce/apex/CarCentersController.getDealershipsWithProductsWrapper'
import checkSelectedDate from '@salesforce/apex/TestDriveController.isDateAlreadyBooked';
import createTestDrive from '@salesforce/apex/ClientController.processTestDriveForClient';

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

    @track displayTestDrive = true;
    @track displayDateBookedMessage = false;
    @track displayErrorMessage = false;
    @track displayWarningMessage = false;
    @track displaySuccessMessage = false;

    @track isFormHasError = true;
    @track today;
    @track minDate;
    @track maxDate;
    @track dealerships = [];
    @track dealershipsOptionsToPush = [];
    @track dealershipsOptions = [];
    @track carsOptionsToPush = [];
    @track carsOptions = [];

    @track selectedProductId;
    @track selectedDealershipId;
    @track selectedDate;
    @track name;
    @track surname;
    @track email;
    @track language;
    @track phone;

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
            console.log(this.selectedDate);
            checkSelectedDate({selectedProductId: this.selectedProductId, selectedDate: this.selectedDate})
                .then(isBooked => {
                    if (isBooked === false) {
                        createTestDrive({name: this.name, surname: this.surname, email: this.email, phone: this.phone, selectedProductId: this.selectedProductId,
                            selectedDealershipId: this.selectedDealershipId, selectedDate: this.selectedDate})
                            .then(result => {
                                if (result === false) {
                                    this.displayWarningMessage = true;
                                } else {
                                    this.displaySuccessMessage = true;
                                }
                            })
                            .catch(error => {
                                console.log(error);
                            })
                    } else {
                        this.displayDateBookedMessage = true;
                    }
                })
                .catch(error => {
                    console.log(error);
                })
        } else {
            this.displayErrorMessage = true;
        }
    }

    closeToast(event) {
        this.displayDateBookedMessage = false;
        this.displayErrorMessage = false;
        this.displayWarningMessage = false;
        this.displaySuccessMessage = false;
    }
}