import { LightningElement, api} from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import FA from '@salesforce/resourceUrl/FontAwesome';

const SITE_CONTENT = {
     pt: {
          header: {
               nav: {
                    about: 'Sobre',
                    services: 'Serviços',
                    projects: 'Portfólio',
                    contact: 'Contato'
               },
               contactButton: 'Fale Comigo'
          },
          about: {
               title: 'Visão Geral de Habilidades',
               description: 'Uma visão geral das principais habilidades técnicas e práticas.'
          },
          projects: {
               title: 'Projetos em Destaque'
          },
          contact: {
               title: 'Contato',
               description: 'Se preferir, clique no botão abaixo para abrir seu cliente de e-mail.',
               emailButton: 'Enviar E-mail',
               emailSubject: 'Contato via Portfólio'
          }
     },
     en: {
          header: {
               nav: {
                    about: 'About',
                    services: 'Services',
                    projects: 'Portfolio',
                    contact: 'Contact'
               },
               contactButton: 'Contact Me'
          },
          about: {
               title: 'Skills Overview',
               description: 'An overview of key technical skills and practical experience.'
          },
          projects: {
               title: 'Featured Projects'
          },
          contact: {
               title: 'Contact Me',
               description: 'If you prefer, click the button below to open your email client.',
               emailButton: 'Send Email',
               emailSubject: 'Portfolio Contact'
          }
     }
};

export default class PortfolioContainer extends LightningElement {
     @api recordId;

     stylesLoaded = false;
     currentLanguage = 'pt';

     connectedCallback() {
          const candidatePaths = [
               `${FA}/fontawesome-free-7.2.0-web/css/all.min.css`,
               `${FA}/css/all.min.css`,
               `${FA}`
          ];

          this.loadFirstAvailableStyle(candidatePaths);
     }

     async loadFirstAvailableStyle(paths) {
          for (const path of paths) {
               try {
                    await loadStyle(this, path);
                    this.stylesLoaded = true;
                    return;
               } catch (e) {
                    // try next path
               }
          }

          // Don't block rendering if the style fails.
          this.stylesLoaded = true;
          // eslint-disable-next-line no-console
          console.error('Unable to load Font Awesome static resource.');
     }

     handleLanguageChange(event) {
          this.currentLanguage = event.detail?.language || 'pt';
     }

     get content() {
          return SITE_CONTENT[this.currentLanguage] || SITE_CONTENT.pt;
     }

     get headerLabels() {
          return this.content.header;
     }

     get aboutLabels() {
          return this.content.about;
     }

     get projectLabels() {
          return this.content.projects;
     }

     get contactLabels() {
          return this.content.contact;
     }
}