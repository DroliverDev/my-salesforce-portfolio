import { LightningElement, api } from 'lwc';

export default class BlogHeader extends LightningElement {
    @api categories = [];
    @api selectedCategory;
    isMobileMenuOpen = false;

    get categoryItems() {
        return this.categories.map((name) => ({
            name,
            desktopClass:
                name === this.selectedCategory ? 'nav-link-button is-active' : 'nav-link-button',
            mobileClass:
                name === this.selectedCategory ? 'mobile-link-button is-active' : 'mobile-link-button'
        }));
    }

    handleCategoryClick(event) {
        this.isMobileMenuOpen = false;
        this.dispatchEvent(
            new CustomEvent('categorychange', {
                detail: { category: event.currentTarget.dataset.category }
            })
        );
    }

    toggleMobileMenu() {
        this.isMobileMenuOpen = !this.isMobileMenuOpen;
    }
}