import {LightningElement, track} from 'lwc';

import getDealershipLocations from '@salesforce/apex/CarCentersController.getResultList';
import createCase from '@salesforce/apex/ClientController.processCaseForClient';

import {jsonCopy, isEmpty, delay} from 'c/helper';

export default class CaseCreatorAndAboutUs extends LightningElement {

    maxLengthName = 20;
    maxLengthSurname = 20;
    maxLengthEmail = 50;
    maxLengthSubject = 50;
    maxLengthMessage = 255;

    dealershipsOptionsToPush = [];
    dealershipsOptions = [];
    languageOptions =
        [{
            label: 'English',
            value: 'en'
        },
         {
            label: 'Russian',
            value: 'ru'
         }];

    displayCaseCreator = true;
    displayErrorMessage = false;
    displayWarningMessage = false;
    displaySuccessMessage = false;

    name;
    surname;
    phone;
    email;
    language;
    selectedDealershipId;
    subject;
    message;

    _caseFormWrapper;

    connectedCallback() {
        getDealershipLocations({})
            .then(dealerships => {
                for (let key in dealerships) {
                    this.dealershipsOptionsToPush.push({
                        label: dealerships[key].locationWrapper.country + ', ' + dealerships[key].locationWrapper.city + ', ' + dealerships[key].locationWrapper.street,
                        value: dealerships[key].value
                    });
                }
            });
    }

    loadDealerships(event) {
        this.dealershipsOptions = this.dealershipsOptionsToPush;
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
            this.processData();
            this.sendData();
        } else {
            this.displayErrorMessage = true;
        }
    }

    processData() {
        this._caseFormWrapper = {
            name: this.name,
            surname: this.surname,
            email: this.email,
            phone: this.phone,
            selectedDealershipId: this.selectedDealershipId,
            subject: this.subject,
            message: this.message
        }
    }

    sendData() {
        console.log(jsonCopy(this._caseFormWrapper));
        createCase({
            caseFormWrapper: this._caseFormWrapper
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
        this.displayErrorMessage = false;
        this.displayWarningMessage = false;
        this.displaySuccessMessage = false;
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

    handleSubjectInput(event) {
        this.subject = event.detail.value;
    }

    handlePhoneInput(event) {
        this.phone = event.detail.value;
    }

    handleLanguageInput(event) {
        this.language = event.detail.value;
    }

    handleMessageInput(event) {
        this.message = event.detail.value;
    }

    handleDealershipInput(event) {
        this.selectedDealershipId = event.detail.value;
    }
}