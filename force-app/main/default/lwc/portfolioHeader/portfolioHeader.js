import { LightningElement, api, wire } from 'lwc';
import MyProfileImage from '@salesforce/resourceUrl/MyProfileImage';
import flags from '@salesforce/resourceUrl/flags';
import getProfile from '@salesforce/apex/PortfolioProfileController.getProfile';

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
    isLoading = false;

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

    get whatsappUrl() {
        const digitsOnly = String(this.whatsappPhone || '').replace(/\D/g, '');
        return digitsOnly ? `https://wa.me/${digitsOnly}` : null;
    }

    @wire(getProfile, { Id: '$recordId' })
    wiredProfile({ error, data }) {
        this.isLoading = true;
        if (data) {
            console.log('Data:', data);
            this.name = data.name;
            this.bio = data.bio;
            this.imageUrl = MyProfileImage;
            this.linkedinUrl = data.linkedInUrl;
            this.githubUrl = data.githubUrl;
            this.salesforceUrl = data.trailheadUrl;
            this.email = data.email;
            this.whatsappPhone = data.wppPhone;
            console.log('wpp: ', data.wppPhone);
            this.isLoading = false;
        } else if (error) {
            console.error('Error loading profile:', error);
            this.isLoading = false;
        }
    }

    stop(event) {
        event.stopPropagation();
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

    handleNavClick(event) {
        event.preventDefault();
        const section = event.currentTarget?.dataset?.section;
        this.dispatchEvent(
            new CustomEvent('navscroll', {
                detail: { section }
            })
        );
    }
}