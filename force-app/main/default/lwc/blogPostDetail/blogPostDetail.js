import { LightningElement, api } from 'lwc';

const FALLBACK_IMAGE =
    "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='1200' height='675' viewBox='0 0 1200 675'%3E%3Cdefs%3E%3ClinearGradient id='g' x1='0' y1='0' x2='1' y2='1'%3E%3Cstop offset='0%25' stop-color='%230176d3'/%3E%3Cstop offset='100%25' stop-color='%23014a8c'/%3E%3C/linearGradient%3E%3C/defs%3E%3Crect width='1200' height='675' fill='url(%23g)'/%3E%3Ctext x='50%25' y='50%25' dominant-baseline='middle' text-anchor='middle' fill='white' font-family='Arial' font-size='64'%3EPortfolio Blog%3C/text%3E%3C/svg%3E";

export default class BlogPostDetail extends LightningElement {
    @api post;

    get hasPost() {
        return Boolean(this.post);
    }

    get contentParagraphs() {
        return (this.post?.content || '')
            .split('\n')
            .map((paragraph) => paragraph.trim())
            .filter((paragraph) => Boolean(paragraph));
    }

    get resolvedImageUrl() {
        return this.post?.imageUrl || FALLBACK_IMAGE;
    }

    handleBack() {
        this.dispatchEvent(new CustomEvent('back'));
    }
}
