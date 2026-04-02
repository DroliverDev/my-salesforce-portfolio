import { LightningElement, api } from 'lwc';

export default class PortfolioAbout extends LightningElement {
    @api recordId;
    @api title = 'Visão Geral de Habilidades';
    @api description = 'Uma visão geral das principais habilidades técnicas e práticas.';
}