import { LightningElement, api } from 'lwc';

export default class PortfolioHeader extends LightningElement {
    @api profileImageUrl = '/resource/default_profile.png';
    @api bio = 'Desenvolvedora Salesforce e full-stack, especializada em LWC e soluções modernas.';
    @api twitterUrl = 'https://twitter.com/';
    @api linkedinUrl = 'https://www.linkedin.com/';
    @api githubUrl = 'https://github.com/';
    @api salesforceUrl = 'https://trailblazer.me/';

    handleContactClick() {
        // emit custom event so parent can handle navigation, or fallback to mailto
        this.dispatchEvent(new CustomEvent('contact'));
        window.location.href = 'mailto:hello@example.com';
    }
}