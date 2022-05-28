import {LightningElement, track} from 'lwc';
import getCases from '@salesforce/apex/CaseController.getCases';
export default class CasesViewer extends LightningElement {

    @track caseRecords = [];

    connectedCallback() {
        getCases({})
            .then(cases => {
                this.caseRecords = cases;
            })
    }

    handleRemove(event) {
        this.caseRecords = this.caseRecords.slice(1);
    }
}