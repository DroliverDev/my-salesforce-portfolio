import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import PROFILE_IMAGE_FIELD from '@salesforce/schema/Portfolio_Profile__c.Profile_Image_URL__c';
import NAME_FIELD from '@salesforce/schema/Portfolio_Profile__c.Name';
import EMAIL_FIELD from '@salesforce/schema/Portfolio_Profile__c.Email__c';
import BIO_FIELD from '@salesforce/schema/Portfolio_Profile__c.Bio__c';
import LINKEDIN_FIELD from '@salesforce/schema/Portfolio_Profile__c.LinkedIn_URL__c';
import GITHUB_FIELD from '@salesforce/schema/Portfolio_Profile__c.GitHub_URL__c';
import SALESFORCE_FIELD from '@salesforce/schema/Portfolio_Profile__c.Trailhead_URL__c';
import WHATSAPP_FIELD from '@salesforce/schema/Portfolio_Profile__c.WhatsApp_Phone__c';
import MyProfileImage from '@salesforce/resourceUrl/MyProfileImage';
import flags from '@salesforce/resourceUrl/flags';

export default class PortfolioHeader extends LightningElement {
    @api recordId;
    @api bio;
    @api name;
    @api linkedinUrl;
    @api githubUrl;
    @api salesforceUrl;
    @api imageUrl = MyProfileImage;
    @api email;
    @api whatsappPhone;
    @api language = 'pt';
    @api labels;

    get englishFlagUrl() {
        return `${flags}/flags/flag-us.svg`;
    }

    get portugueseFlagUrl() {
        return `${flags}/flags/flag-br.svg`;
    }

    get currentLanguageFlagUrl() {
        return this.language === 'pt' ? this.portugueseFlagUrl : this.englishFlagUrl;
    }

    get currentLanguageAlt() {
        return this.language === 'pt' ? 'Português' : 'English';
    }

    get navLabels() {
        return this.labels?.nav || {
            about: 'Sobre',
            services: 'Serviços',
            projects: 'Portfólio',
            contact: 'Contato'
        };
    }

    get languageToggleLabel() {
        return this.language === 'pt' ? 'PT / EN' : 'EN / PT';
    }

    @wire(getRecord, {
        recordId: '$recordId',
        fields: [PROFILE_IMAGE_FIELD, NAME_FIELD, EMAIL_FIELD, BIO_FIELD, LINKEDIN_FIELD, GITHUB_FIELD, SALESFORCE_FIELD, WHATSAPP_FIELD]
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
            this.whatsappPhone = data?.fields?.WhatsApp_Phone__c?.value;
        } else if (error) {
            console.error(error);
        }
    }

    handleContactClick() {
        // emit custom event so parent can handle navigation, or fallback to mailto
        this.dispatchEvent(new CustomEvent('contact'));
        window.location.href = 'mailto:hello@example.com';
    }

    handleLanguageToggle() {
        const nextLanguage = this.language === 'pt' ? 'en' : 'pt';
        this.dispatchEvent(
            new CustomEvent('languagechange', {
                detail: { language: nextLanguage }
            })
        );
    }
}