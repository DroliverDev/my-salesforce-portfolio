import { LightningElement, api, wire, track } from 'lwc';
import getSkillCategories from '@salesforce/apex/PortfolioProfileController.getSkillCategories';

export default class PortfolioAbout extends LightningElement {
    @api recordId;
    @api title = 'Visão Geral de Habilidades';
    @api description = 'Uma visão geral das principais habilidades técnicas e práticas.';

    @track skillCategories = [];

    @wire(getSkillCategories)
    wiredSkillCategories({ error, data }) {
        if (data) {
            this.skillCategories = data;
        } else if (error) {
            console.error('Error loading skill categories:', error);
        }
    }
}