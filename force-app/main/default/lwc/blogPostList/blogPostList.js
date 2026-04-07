import { LightningElement, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { MessageContext, subscribe, publish, APPLICATION_SCOPE } from 'lightning/messageService';
import BlogPostChannel from '@salesforce/messageChannel/BlogPostChannel__c';
import getBlogs from '@salesforce/apex/PortfolioBlogController.getBlogs';

export default class BlogPostList extends LightningElement {
    wiredBlogsResult;
    posts = [];
    isLoading = true;
    errorMessage = '';
    subscription = null;

    @wire(MessageContext)
    messageContext;

    @wire(getBlogs)
    wiredBlogs(result) {
        this.wiredBlogsResult = result;
        this.isLoading = false;

        if (result.data) {
            this.posts = result.data.map((post) => ({
                ...post,
                badgeClass: this.badgeClassForStatus(post.Status__c),
                statusLabel: post.Status__c || 'Draft'
            }));
            this.errorMessage = '';
        } else if (result.error) {
            this.errorMessage = this.reduceError(result.error);
            this.posts = [];
        }
    }

    get hasPosts() {
        return !this.isLoading && this.posts.length > 0;
    }

    get isEmpty() {
        return !this.isLoading && this.posts.length === 0 && !this.errorMessage;
    }

    get hasError() {
        return Boolean(this.errorMessage);
    }

    connectedCallback() {
        this.subscribeToChannel();
    }

    subscribeToChannel() {
        if (this.subscription) {
            return;
        }

        this.subscription = subscribe(
            this.messageContext,
            BlogPostChannel,
            (message) => this.handleChannelMessage(message),
            { scope: APPLICATION_SCOPE }
        );
    }

    handleChannelMessage(message) {
        if (message?.action === 'blogCreated' || message?.action === 'blogUpdated') {
            refreshApex(this.wiredBlogsResult);
        }
    }

    handleEdit(event) {
        const recordId = event.currentTarget.dataset.id;
        publish(this.messageContext, BlogPostChannel, {
            recordId,
            action: 'edit'
        });
    }

    badgeClassForStatus(status) {
        if (status === 'Published') return 'slds-badge slds-badge_success';
        if (status === 'Archived') return 'slds-badge slds-badge_inverse';
        return 'slds-badge';
    }

    reduceError(error) {
        if (Array.isArray(error?.body)) {
            return error.body.map((item) => item.message).join(', ');
        }

        return error?.body?.message || error?.message || 'An unexpected error occurred.';
    }
}
