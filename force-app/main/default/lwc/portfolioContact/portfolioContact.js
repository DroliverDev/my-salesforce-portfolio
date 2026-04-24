import { LightningElement, api } from 'lwc';
import saveContact from '@salesforce/apex/PortfolioContactController.saveContact';

export default class PortfolioContact extends LightningElement {
    @api recordId;
    @api email;
    @api title = 'Contact Me';
    @api description = 'If you prefer, click the button below to open your email client.';
    @api buttonLabel = 'Send Email';
    @api emailSubject = 'Portfolio Contact';
    isSubmitting = false;
    feedbackMessage = '';
    feedbackType = '';
    _revealInitialized = false;
    revealObserver;

    formData = {
        name: '',
        email: '',
        message: ''
    };

    get submitLabel() {
        return this.isSubmitting ? 'Sending...' : 'Send Message';
    }

    renderedCallback() {
        this.initializeRevealMotion();
    }

    disconnectedCallback() {
        if (this.revealObserver) {
            this.revealObserver.disconnect();
        }
    }

    get feedbackClass() {
        return this.feedbackType === 'success' ? 'feedback success' : 'feedback error';
    }

    handleInputChange(event) {
        const { name, value } = event.target;
        this.formData = {
            ...this.formData,
            [name]: value
        };
    }

    async handleSubmit(event) {
        event.preventDefault();
        this.feedbackMessage = '';

        const payload = {
            name: this.formData.name,
            email: this.formData.email,
            message: this.formData.message,
            status: 'New',
            profileId: this.recordId || null
        };

        this.isSubmitting = true;
        try {
            await saveContact({ payload });
            this.feedbackType = 'success';
            this.feedbackMessage = 'Thanks for your message! I will get back to you soon.';
            this.formData = { name: '', email: '', message: '' };
        } catch (error) {
            this.feedbackType = 'error';
            this.feedbackMessage =
                error?.body?.message ||
                'Sorry, we could not send your message right now. Please try again.';
            // eslint-disable-next-line no-console
            console.error(error);
        } finally {
            this.isSubmitting = false;
        }
    }

    get mailtoLink() {
        return `mailto:${this.email || ''}?subject=${encodeURIComponent(this.emailSubject)}`;
    }

    initializeRevealMotion() {
        if (this._revealInitialized) {
            return;
        }

        const section = this.template.querySelector('.reveal-section');
        if (!section) {
            return;
        }

        this._revealInitialized = true;

        if (typeof IntersectionObserver === 'undefined') {
            section.classList.add('is-visible');
            return;
        }

        this.revealObserver = new IntersectionObserver(
            entries => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('is-visible');
                        this.revealObserver.unobserve(entry.target);
                    }
                });
            },
            {
                threshold: 0.2
            }
        );

        this.revealObserver.observe(section);
    }
}