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
    _profileLoaded = false;

    renderedCallback() {
        if (!this._profileLoaded && this.recordId) {
            this._profileLoaded = true;
            getProfile({ Id: this.recordId })
                .then(data => {
                    if (data && data.skills) {
                        this.skills = data.skills;
                        this.updateCategorizedSkills();
                        this.isLoading = false;
                    }
                })
                .catch(error => {
                    console.error('Error loading profile:', error);
                    this.isLoading = false;
                });
        }
    }

    @wire(getSkillCategories)
    wiredSkillCategories({ error, data }) {
        if (data) {
            this.skillCategories = data;
            this.updateCategorizedSkills();
        } else if (error) {
            console.error('Error loading skill categories:', error);
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

        // Sort skills within each category by level (greater to smaller)
        Object.keys(skillMap).forEach(category => {
            skillMap[category].sort((a, b) => {
                const levelDiff = this.getLevelRank(b.level) - this.getLevelRank(a.level);
                if (levelDiff !== 0) {
                    return levelDiff;
                }

                return (a.order || 0) - (b.order || 0);
            });
        });

        // Create array with category name and skills for template iteration
        this.categorizedSkills = this.skillCategories.map(category => ({
            name: category,
            skills: skillMap[category] || []
        }));
    }

    getLevelRank(level) {
        const byLabel = {
            beginner: 1,
            intermediate: 2,
            'upper intermediate': 3,
            'upper-intermediate': 3,
            advanced: 4
        };

        const normalized = String(level || '').trim().toLowerCase();
        if (byLabel[normalized]) {
            return byLabel[normalized];
        }

        const numeric = Number(level);
        return Number.isNaN(numeric) ? 0 : numeric;
    }
}