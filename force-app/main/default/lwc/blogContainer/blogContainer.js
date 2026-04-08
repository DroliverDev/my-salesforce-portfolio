import { LightningElement } from 'lwc';
import POSTS from './mockPosts';

const ALL_CATEGORY = 'All';

export default class BlogContainer extends LightningElement {
    posts = [];
    isLoading = true;
    selectedCategory = ALL_CATEGORY;
    selectedTags = [];
    searchTerm = '';
    selectedPostId;

    connectedCallback() {
        // Mimics an API call and allows the loading state to be visible.
        window.clearTimeout(this.loadTimer);
        this.loadTimer = window.setTimeout(() => {
            this.posts = POSTS;
            this.isLoading = false;
        }, 300);
    }

    disconnectedCallback() {
        window.clearTimeout(this.loadTimer);
    }

    get categories() {
        const values = new Set(this.posts.map((post) => post.category));
        return [ALL_CATEGORY, ...values];
    }

    get allTags() {
        const tags = new Set();
        this.posts.forEach((post) => {
            post.tags.forEach((tag) => tags.add(tag));
        });
        return [...tags].sort((a, b) => a.localeCompare(b));
    }

    get filteredPosts() {
        const normalizedSearchTerm = this.searchTerm.trim().toLowerCase();

        return this.posts.filter((post) => {
            const matchesCategory =
                this.selectedCategory === ALL_CATEGORY || post.category === this.selectedCategory;

            const matchesTags =
                this.selectedTags.length === 0 ||
                this.selectedTags.some((selectedTag) => post.tags.includes(selectedTag));

            const matchesSearch =
                !normalizedSearchTerm ||
                `${post.title} ${post.description}`.toLowerCase().includes(normalizedSearchTerm);

            return matchesCategory && matchesTags && matchesSearch;
        });
    }

    get selectedPost() {
        return this.posts.find((post) => post.id === this.selectedPostId);
    }

    get showDetail() {
        return Boolean(this.selectedPostId);
    }

    handleCategoryChange(event) {
        this.selectedCategory = event.detail.category;
        this.selectedPostId = undefined;
    }

    handleTagChange(event) {
        this.selectedTags = event.detail.tags;
        this.selectedPostId = undefined;
    }

    handleSearchChange(event) {
        this.searchTerm = event.detail.term;
        this.selectedPostId = undefined;
    }

    handlePostSelect(event) {
        this.selectedPostId = event.detail.postId;
    }

    handleBackToList() {
        this.selectedPostId = undefined;
    }
}