import {LightningElement, track, wire} from 'lwc';

import changeLanguage from '@salesforce/apex/LanguageService.changeLanguage'
import isForeignLanguage from '@salesforce/apex/LanguageService.isForeignLanguage'

export default class PageDisplayer extends LightningElement {

    @track useDefaultLanguage;

    constructor() {
        super();
        console.log('constructor');
    }

    connectedCallback() {
        console.log('connectedCallback');
        isForeignLanguage({})
            .then(isForeign => {
                this.useDefaultLanguage = !isForeign;
            });
    }

    renderedCallback() {
        console.log('renderedCallback');
    }

    @wire(changeLanguage, {})
    lang({data, error}) {
        console.log('wire');
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