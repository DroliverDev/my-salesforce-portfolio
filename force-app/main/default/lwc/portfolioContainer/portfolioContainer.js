import { LightningElement, api} from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import FA from '@salesforce/resourceUrl/FontAwesome';
import PORTFOLIO_IMAGES from '@salesforce/resourceUrl/PortfolioImages';
import { getSiteContent } from 'c/siteContentUtil';

export default class PortfolioContainer extends LightningElement {
     @api recordId;

     profileImageUrl = `${PORTFOLIO_IMAGES}/perfil/profile.webp`;
     projectsBaseUrl = `${PORTFOLIO_IMAGES}/projetos/`;

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

     handleNavScroll(event) {
          const section = event.detail?.section;

          if (section === 'home') {
               window.scrollTo({ top: 0, behavior: 'smooth' });
               return;
          }

          const targetSelectorBySection = {
               about: 'c-portfolio-about',
               projects: 'c-portfolio-projects',
               contact: 'c-portfolio-contact'
          };

          const selector = targetSelectorBySection[section];
          if (!selector) {
               return;
          }

          const targetEl = this.template.querySelector(selector);
          if (targetEl) {
               targetEl.scrollIntoView({ behavior: 'smooth', block: 'start' });
          }
     }

     get content() {
          return getSiteContent(this.currentLanguage);
     }

     get headerLabels() {
          return this.content.header || {
               nav: {
                    home: '',
                    about: '',
                    projects: '',
                    contact: '',
                    blog: ''
               }
          };
     }

     get aboutLabels() {
          return this.content.about || {
               title: '',
               description: ''
          };
     }

     get projectLabels() {
          return this.content.projects || {
               title: ''
          };
     }

     get contactLabels() {
          return this.content.contact || {
               title: '',
               description: '',
               emailButton: '',
               emailSubject: ''
          };
     }
}