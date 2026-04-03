import { LightningElement, api } from 'lwc';

export default class PortfolioProjects extends LightningElement {
    @api recordId;
    @api projects;
    @api title = 'Projetos em Destaque';

    get internalProjects() {
        // fallback example projects if none provided
        if (this.projects && this.projects.length) return this.projects;
        return [
            { id: 'p1', name: 'Project Alpha', description: 'A demo project.', imageUrl: null, codeUrl: '#' },
            { id: 'p2', name: 'Project Beta', description: 'Another demo project.', imageUrl: null, codeUrl: '#' },
            { id: 'p3', name: 'Project Gamma', description: 'Sample project.', imageUrl: null, codeUrl: '#' }
        ];
    }
}