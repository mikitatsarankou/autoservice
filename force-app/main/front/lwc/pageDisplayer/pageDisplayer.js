import {LightningElement, track} from 'lwc';

import changeLanguage from '@salesforce/apex/LanguageService.changeLanguage'
import isForeignLanguage from '@salesforce/apex/LanguageService.isForeignLanguage'

export default class PageDisplayer extends LightningElement {

    @track useDefaultLanguage;

    constructor() {
        super();
    }

    connectedCallback() {
        isForeignLanguage({})
            .then(isForeign => {
                this.useDefaultLanguage = !isForeign;
            });
    }


    handleChangeLanguage(event) {
        changeLanguage({})
            .then(flag => {
                this.refreshPage(flag);
            });
    }

    refreshPage(flag) {
        if (flag === true) {
            window.location.reload();
        } else { }
    }
}