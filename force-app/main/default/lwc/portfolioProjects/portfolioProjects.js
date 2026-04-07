import { LightningElement, api, wire } from 'lwc';
import getProjects from '@salesforce/apex/PortfolioProjectController.getProjects';

export default class PortfolioProjects extends LightningElement {
    @api recordId;
    @api projectImages;
    @api title = 'Projetos em Destaque';

    projects = [];
    error;

    @wire(getProjects, { ProfileId: '$recordId' })
    wiredProjects({ data, error }) {
        if (data) {
            this.projects = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.projects = [];
        }
    }

    get projectsWithImages() {
        if (!this.projects || !this.projects.length) return [];
        return this.projects.map(project => ({
            id: project.slug || project.name,
            name: project.name,
            description: project.shortDescription || project.description || '',
            imageUrl: this.projectImages
                ? `${this.projectImages}${project.slug}.webp`
                : null,
            codeUrl: project.githubUrl || project.liveDemoUrl || '#'
        }));
    }
}