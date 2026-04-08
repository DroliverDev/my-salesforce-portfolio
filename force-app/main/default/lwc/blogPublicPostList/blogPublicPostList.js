import { LightningElement, api } from 'lwc';

const DEFAULT_PAGE_SIZE = 6;

export default class BlogPublicPostList extends LightningElement {
    _posts = [];
    visibleCount = DEFAULT_PAGE_SIZE;

    @api isLoading = false;
    @api pageSize = DEFAULT_PAGE_SIZE;

    @api
    get posts() {
        return this._posts;
    }

    set posts(value) {
        this._posts = Array.isArray(value) ? value : [];
        this.visibleCount = this.pageSize;
    }

    get visiblePosts() {
        return this._posts.slice(0, this.visibleCount);
    }

    get hasPosts() {
        return !this.isLoading && this._posts.length > 0;
    }

    get isEmpty() {
        return !this.isLoading && this._posts.length === 0;
    }

    get canLoadMore() {
        return this.visibleCount < this._posts.length;
    }

    handleCardClick(event) {
        this.dispatchEvent(
            new CustomEvent('postselect', {
                detail: { postId: event.detail.postId }
            })
        );
    }

    handleLoadMore() {
        this.visibleCount += this.pageSize;
    }
}
