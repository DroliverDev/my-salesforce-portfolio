import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import EMAIL_FIELD from '@salesforce/schema/Portfolio_Profile__c.Email__c';

export default class PortfolioContact extends LightningElement {
    @api recordId;
    @api email;
    @api title = 'Contact Me';
    @api description = 'If you prefer, click the button below to open your email client.';
    @api buttonLabel = 'Send Email';
    @api emailSubject = 'Portfolio Contact';

    @wire(getRecord, { recordId: '$recordId', fields: [EMAIL_FIELD] })
    wiredProfile({ error, data }) {
        if (data) {
            this.email = data?.fields?.Email__c?.value;
        } else if (error) {
            console.error(error);
        }
    }

    get mailtoLink() {
        return `mailto:${this.email}?subject=${encodeURIComponent(this.emailSubject)}`;
    }
}