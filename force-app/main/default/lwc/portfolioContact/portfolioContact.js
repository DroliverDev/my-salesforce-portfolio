import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import EMAIL_FIELD from '@salesforce/schema/Portfolio_Profile__c.Email__c';

export default class PortfolioContact extends LightningElement {
    @api recordId;
    @api email;

    @wire(getRecord, { recordId: '$recordId', fields: [EMAIL_FIELD] })
    wiredProfile({ error, data }) {
        if (data) {
            this.email = data?.fields?.Email__c?.value;
        } else if (error) {
            console.error(error);
        }
    }

    get mailtoLink() {
        return `mailto:${this.email}?subject=${encodeURIComponent('Contato via Portfolio')}`;
    }
}