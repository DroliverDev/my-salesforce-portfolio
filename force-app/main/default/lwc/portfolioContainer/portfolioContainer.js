import { LightningElement, api} from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import FA from '@salesforce/resourceUrl/FontAwesome';

export default class PortfolioContainer extends LightningElement {
     @api recordId;

     stylesLoaded = false;

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
}