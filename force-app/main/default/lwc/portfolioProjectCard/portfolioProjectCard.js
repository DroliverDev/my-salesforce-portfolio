import { LightningElement, api } from 'lwc';

export default class PortfolioProjectCard extends LightningElement {
    @api recordId;
    @api projectName = 'Projeto';
    @api description = 'Descrição curta do projeto';
    @api imageUrl;
    @api codeUrl = '#';
}