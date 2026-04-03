import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import PROFILE_IMAGE_FIELD from '@salesforce/schema/Portfolio_Profile__c.Profile_Image_URL__c';
import NAME_FIELD from '@salesforce/schema/Portfolio_Profile__c.Name';
import EMAIL_FIELD from '@salesforce/schema/Portfolio_Profile__c.Email__c';
import BIO_FIELD from '@salesforce/schema/Portfolio_Profile__c.Bio__c';
import LINKEDIN_FIELD from '@salesforce/schema/Portfolio_Profile__c.LinkedIn_URL__c';
import GITHUB_FIELD from '@salesforce/schema/Portfolio_Profile__c.GitHub_URL__c';
import SALESFORCE_FIELD from '@salesforce/schema/Portfolio_Profile__c.Trailhead_URL__c';
import MyProfileImage from '@salesforce/resourceUrl/MyProfileImage';

export default class PortfolioHeader extends LightningElement {
    @api recordId;
    @api bio;
    @api name;
    @api linkedinUrl;
    @api githubUrl;
    @api salesforceUrl;
    @api imageUrl = MyProfileImage;
    @api email;

    @wire(getRecord, {
        recordId: '$recordId',
        fields: [PROFILE_IMAGE_FIELD, NAME_FIELD, EMAIL_FIELD, BIO_FIELD, LINKEDIN_FIELD, GITHUB_FIELD, SALESFORCE_FIELD]
    })

    wiredProfile({ error, data }) {
        if (data) {
            //this.imageUrl = data?.fields?.Profile_Image_URL__c?.value;
            this.name = data?.fields?.Name?.value;
            this.email = data?.fields?.Email__c?.value;
            this.bio = data?.fields?.Bio__c?.value;
            this.linkedinUrl = data?.fields?.LinkedIn_URL__c?.value;
            this.githubUrl = data?.fields?.GitHub_URL__c?.value;
            this.salesforceUrl = data?.fields?.Trailhead_URL__c?.value;
        } else if (error) {
            console.error(error);
        }
    }

    handleContactClick() {
        // emit custom event so parent can handle navigation, or fallback to mailto
        this.dispatchEvent(new CustomEvent('contact'));
        window.location.href = 'mailto:hello@example.com';
    }
}