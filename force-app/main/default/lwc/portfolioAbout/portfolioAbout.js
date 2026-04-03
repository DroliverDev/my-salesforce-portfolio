import { LightningElement, api, wire, track } from 'lwc';
import getSkillCategories from '@salesforce/apex/PortfolioProfileController.getSkillCategories';
import getProfile from '@salesforce/apex/PortfolioProfileController.getProfile';

export default class PortfolioAbout extends LightningElement {
    @api recordId;
    @api title = 'Visão Geral de Habilidades';
    @api description = 'Uma visão geral das principais habilidades técnicas e práticas.';

    @track skillCategories = [];
    @track categorizedSkills = [];
    @track isLoading = true;

    @wire(getSkillCategories)
    wiredSkillCategories({ error, data }) {
        if (data) {
            this.skillCategories = data;
            this.updateCategorizedSkills();
        } else if (error) {
            console.error('Error loading skill categories:', error);
        }
    }

    @wire(getProfile, { Id: '$recordId' })
    wiredProfile({ error, data }) {
        this.isLoading = true;
        if (data && data.skills) {
            this.skills = data.skills;
            console.log('Loaded skills:', this.skills);
            this.updateCategorizedSkills();
            this.isLoading = false;
        } else if (error) {
            console.error('Error loading profile:', error);
            this.isLoading = false;
        }
    }

    updateCategorizedSkills() {
        if (!this.skills || this.skillCategories.length === 0) {
            return;
        }

        const skillMap = {};

        // Group skills by category
        this.skills.forEach(skill => {
            const category = skill.category || 'Other';
            if (!skillMap[category]) {
                skillMap[category] = [];
            }
            skillMap[category].push(skill);
        });

        // Sort skills within each category by order
        Object.keys(skillMap).forEach(category => {
            skillMap[category].sort((a, b) => (a.order || 0) - (b.order || 0));
        });

        // Create array with category name and skills for template iteration
        this.categorizedSkills = this.skillCategories.map(category => ({
            name: category,
            skills: skillMap[category] || []
        }));
    }
}