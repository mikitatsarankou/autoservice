import {createElement} from 'lwc';
import getCases from '@salesforce/apex/CaseController.getCases';

import casesViewer from 'c/casesViewer';

jest.mock('@salesforce/apex/CaseController.getCases', () => {
    return {default: jest.fn()};
}, {virtual: true})

let rootElement;

const mockedCasesList = require('./data/casesList.json');
const mockedEmptyCasesList = require('./data/emptyCasesList.json');

describe('c-cases-viewer', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    })

    beforeEach(() => {
        rootElement = createElement('c-cases-viewer', {
            is: casesViewer
        })
    })

    it('caseRecords should not be empty', async() => {
        getCases.mockResolvedValue(mockedCasesList);
        document.body.appendChild(rootElement);

        return Promise.resolve()
            .then(() => {
                const inputElement = rootElement.shadowRoot.querySelector('.remove-one-case-button');
                inputElement.dispatchEvent(new CustomEvent('click'));
            })
            .then(() => {
                expect(rootElement.shadowRoot.querySelectorAll('.caseRecord').length).toBe(4);
            });
    });

    it('casesRecords should be empty', async() => {
        getCases.mockResolvedValue(mockedEmptyCasesList);
        document.body.appendChild(rootElement);

        return Promise.resolve()
            .then(() => {
                const inputElement = rootElement.shadowRoot.querySelector('.remove-one-case-button');
                inputElement.dispatchEvent(new CustomEvent('click'));
            })
            .then(() => {
                expect(rootElement.shadowRoot.querySelectorAll('.caseRecord').length).toBe(0);
            });
    })
})



