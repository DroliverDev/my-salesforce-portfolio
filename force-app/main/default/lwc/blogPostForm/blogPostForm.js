import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { MessageContext, publish } from 'lightning/messageService';
import BlogPostChannel from '@salesforce/messageChannel/BlogPostChannel__c';
import getTags from '@salesforce/apex/PortfolioBlogController.getTags';
import createBlogWithTags from '@salesforce/apex/PortfolioBlogController.createBlogWithTags';

export default class BlogPostForm extends LightningElement {
    formData = {
        title: '',
        slug: '',
        content: '',
        status: 'Draft'
    };

    statusOptions = [
        { label: 'Draft', value: 'Draft' },
        { label: 'Published', value: 'Published' },
        { label: 'Archived', value: 'Archived' }
    ];

    selectedTagIds = [];
    tagOptions = [];
    newTagsInput = '';
    isSaving = false;
    isSlugManuallyEdited = false;

    @wire(MessageContext)
    messageContext;

    @wire(getTags)
    wiredTags({ data, error }) {
        if (data) {
            this.tagOptions = data.map((tag) => ({
                label: tag.Name,
                value: tag.Id
            }));
            return;
        }

        if (error) {
            this.showToast('Error', this.reduceError(error), 'error');
        }
    }

    handleTitleChange(event) {
        const title = event.target.value;
        this.formData = {
            ...this.formData,
            title
        };

        if (!this.isSlugManuallyEdited) {
            this.formData = {
                ...this.formData,
                slug: this.generateSlug(title)
            };
        }
    }

    handleSlugChange(event) {
        this.isSlugManuallyEdited = true;
        this.formData = {
            ...this.formData,
            slug: event.target.value
        };
    }

    handleContentChange(event) {
        this.formData = {
            ...this.formData,
            content: event.target.value
        };
    }

    handleStatusChange(event) {
        this.formData = {
            ...this.formData,
            status: event.detail.value
        };
    }

    handleTagsChange(event) {
        this.selectedTagIds = event.detail.value;
    }

    handleNewTagsChange(event) {
        this.newTagsInput = event.target.value;
    }

    async handleSubmit(event) {
        event.preventDefault();

        if (!this.validateRequiredFields()) {
            this.showToast('Validation Error', 'Please complete Title, Slug, and Content.', 'error');
            return;
        }

        const post = {
            Name: this.formData.title,
            Slug__c: this.formData.slug,
            Content__c: this.formData.content,
            Status__c: this.formData.status
        };

        const newTagNames = this.parseNewTagNames(this.newTagsInput);

        this.isSaving = true;
        try {
            const newPostId = await createBlogWithTags({
                post,
                tagIds: this.selectedTagIds,
                newTagNames
            });

            publish(this.messageContext, BlogPostChannel, {
                action: 'blogCreated',
                recordId: newPostId
            });
            this.showToast('Success', 'Blog post created successfully.', 'success');
            this.resetForm();
        } catch (error) {
            this.showToast('Error', this.reduceError(error), 'error');
        } finally {
            this.isSaving = false;
        }
    }

    validateRequiredFields() {
        return Boolean(
            this.formData.title &&
            this.formData.slug &&
            this.formData.content
        );
    }

    resetForm() {
        this.formData = {
            title: '',
            slug: '',
            content: '',
            published: false
        };
        this.selectedTagIds = [];
        this.newTagsInput = '';
        this.isSlugManuallyEdited = false;
        this.formData = { ...this.formData, status: 'Draft' };
    }

    parseNewTagNames(rawValue) {
        if (!rawValue) {
            return [];
        }

        const tags = rawValue
            .split(',')
            .map((item) => item.trim())
            .filter((item) => Boolean(item));

        return [...new Set(tags)];
    }

    generateSlug(title) {
        return (title || '')
            .toLowerCase()
            .trim()
            .replace(/[^a-z0-9\s-]/g, '')
            .replace(/\s+/g, '-')
            .replace(/-+/g, '-');
    }

    reduceError(error) {
        if (Array.isArray(error?.body)) {
            return error.body.map((item) => item.message).join(', ');
        }

        return error?.body?.message || error?.message || 'An unexpected error occurred.';
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }
}
