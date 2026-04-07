import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { MessageContext, publish, subscribe, APPLICATION_SCOPE } from 'lightning/messageService';
import BlogPostChannel from '@salesforce/messageChannel/BlogPostChannel__c';
import getTags from '@salesforce/apex/PortfolioBlogController.getTags';
import getBlogById from '@salesforce/apex/PortfolioBlogController.getBlogById';
import getBlogTagIds from '@salesforce/apex/PortfolioBlogController.getBlogTagIds';
import createBlogWithTags from '@salesforce/apex/PortfolioBlogController.createBlogWithTags';
import updateBlogWithTags from '@salesforce/apex/PortfolioBlogController.updateBlogWithTags';
import uploadBlogImage from '@salesforce/apex/PortfolioBlogController.uploadBlogImage';

export default class BlogPostForm extends LightningElement {
    formData = {
        title: '',
        slug: '',
        content: '',
        status: 'Draft',
        imageUrl: ''
    };

    // 2 MB
    MAX_FILE_SIZE = 2 * 1024 * 1024;

    statusOptions = [
        { label: 'Draft', value: 'Draft' },
        { label: 'Published', value: 'Published' },
        { label: 'Archived', value: 'Archived' }
    ];

    selectedTagIds = [];
    tagOptions = [];
    newTagsInput = '';
    isSaving = false;
    isLoadingEdit = false;
    isUploadingImage = false;
    imagePreviewUrl = '';
    isSlugManuallyEdited = false;
    editMode = false;
    editRecordId = null;
    subscription = null;

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
        if (message?.action === 'edit' && message?.recordId) {
            this.loadBlogForEdit(message.recordId);
        }
    }

    async loadBlogForEdit(recordId) {
        this.isLoadingEdit = true;
        try {
            const [post, tagIds] = await Promise.all([
                getBlogById({ recordId }),
                getBlogTagIds({ recordId })
            ]);

            this.editMode = true;
            this.editRecordId = recordId;
            this.isSlugManuallyEdited = true;
            this.formData = {
                title: post.Name,
                slug: post.Slug__c || '',
                content: post.Content__c || '',
                status: post.Status__c || 'Draft',
                imageUrl: post.Image_URL__c || ''
            };
            this.selectedTagIds = tagIds || [];
            this.newTagsInput = '';
            this.imagePreviewUrl = post.Image_URL__c || '';
        } catch (error) {
            this.showToast('Error', this.reduceError(error), 'error');
        } finally {
            this.isLoadingEdit = false;
        }
    }

    get cardTitle() {
        return this.editMode ? 'Edit Blog Post' : 'New Blog Post';
    }

    get submitButtonLabel() {
        if (this.isSaving) {
            return this.editMode ? 'Saving...' : 'Creating...';
        }
        return this.editMode ? 'Update Blog Post' : 'Create Blog Post';
    }

    get isSubmitDisabled() {
        return this.isSaving || this.isLoadingEdit || this.isUploadingImage;
    }

    get hasImagePreview() {
        return Boolean(this.imagePreviewUrl);
    }

    get isUploadDisabled() {
        return this.isUploadingImage || this.isSaving || this.isLoadingEdit;
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

    handleFileChange(event) {
        const file = event.target.files[0];
        if (!file) {
            return;
        }

        if (!file.type.startsWith('image/')) {
            this.showToast('Validation Error', 'Only image files are allowed.', 'error');
            event.target.value = '';
            return;
        }

        if (file.size > this.MAX_FILE_SIZE) {
            this.showToast('Validation Error', 'Image must be smaller than 2 MB.', 'error');
            event.target.value = '';
            return;
        }

        this.uploadImage(file);
    }

    async uploadImage(file) {
        this.isUploadingImage = true;
        try {
            const base64Data = await this.readFileAsBase64(file);
            const publicUrl = await uploadBlogImage({
                base64Data,
                fileName: file.name,
                blogId: this.editRecordId || null
            });

            this.imagePreviewUrl = publicUrl;
            this.formData = { ...this.formData, imageUrl: publicUrl };
            this.showToast('Success', 'Image uploaded successfully.', 'success');
        } catch (error) {
            this.showToast('Error', this.reduceError(error), 'error');
        } finally {
            this.isUploadingImage = false;
        }
    }

    readFileAsBase64(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = () => resolve(reader.result);
            reader.onerror = () => reject(new Error('Failed to read file.'));
            reader.readAsDataURL(file);
        });
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
            Status__c: this.formData.status,
            Image_URL__c: this.formData.imageUrl || null
        };

        const newTagNames = this.parseNewTagNames(this.newTagsInput);

        this.isSaving = true;
        try {
            if (this.editMode) {
                post.Id = this.editRecordId;
                await updateBlogWithTags({
                    post,
                    tagIds: this.selectedTagIds,
                    newTagNames
                });
                publish(this.messageContext, BlogPostChannel, {
                    action: 'blogUpdated',
                    recordId: this.editRecordId
                });
                this.showToast('Success', 'Blog post updated successfully.', 'success');
            } else {
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
            }

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
            status: 'Draft'
        };
        this.selectedTagIds = [];
        this.newTagsInput = '';
        this.isSlugManuallyEdited = false;
        this.editMode = false;
        this.editRecordId = null;
        this.imagePreviewUrl = '';
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
