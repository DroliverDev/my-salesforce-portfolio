import { LightningElement, api } from 'lwc';

export default class BlogSidebar extends LightningElement {
    @api tags = [];
    isCollapsed = false;
    _selectedTags = [];
    _searchTerm = '';

    @api
    get selectedTags() {
        return this._selectedTags;
    }

    set selectedTags(value) {
        this._selectedTags = Array.isArray(value) ? [...value] : [];
    }

    @api
    get searchTerm() {
        return this._searchTerm;
    }

    set searchTerm(value) {
        this._searchTerm = value || '';
    }

    get selectedTagValues() {
        return this._selectedTags;
    }

    get searchValue() {
        return this._searchTerm;
    }

    get tagOptions() {
        return this.tags.map((tag) => ({ label: tag, value: tag }));
    }

    get sidebarClass() {
        return this.isCollapsed ? 'sidebar sidebar-collapsed' : 'sidebar';
    }

    get toggleIcon() {
        return this.isCollapsed ? 'utility:chevronright' : 'utility:chevrondown';
    }

    handleToggle() {
        this.isCollapsed = !this.isCollapsed;
    }

    handleTagSelection(event) {
        this._selectedTags = event.detail.value;
        this.dispatchEvent(
            new CustomEvent('tagchange', {
                detail: { tags: this._selectedTags }
            })
        );
    }

    handleSearchChange(event) {
        this._searchTerm = event.target.value;
        this.dispatchEvent(
            new CustomEvent('searchchange', {
                detail: { term: this._searchTerm }
            })
        );
    }
}