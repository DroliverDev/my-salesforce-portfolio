import { LightningElement, api } from 'lwc';

export default class PortfolioAbout extends LightningElement {
    // expose optional overrides
    @api title = 'Visão Geral de Habilidades';
    @api description = 'Uma visão geral das principais habilidades técnicas e práticas.';
}