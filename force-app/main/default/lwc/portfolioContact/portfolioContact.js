import { LightningElement, api } from 'lwc';

export default class PortfolioContact extends LightningElement {
    @api email = 'hello@example.com';

    get mailtoLink() {
        return `mailto:${this.email}?subject=${encodeURIComponent('Contato via Portfolio')}`;
    }
}