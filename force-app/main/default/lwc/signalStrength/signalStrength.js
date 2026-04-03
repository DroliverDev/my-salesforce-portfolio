import { LightningElement, api, track } from 'lwc';

export default class SignalStrength extends LightningElement {
    @api maxBars = 4;
    @track bars = [];
    @track _level = 0;

    connectedCallback() {
        this.updateBars();
    }

    @api
    get level() {
        return this._level;
    }

    set level(value) {
        this._level = this.normalizeLevel(value);
        this.updateBars();
    }

    normalizeLevel(value) {
        if (typeof value === 'number') {
            return Math.min(Math.max(value, 0), this.maxBars);
        }

        const normalized = String(value || '').trim().toLowerCase();
        const levelByLabel = {
            beginner: 1,
            intermediate: 2,
            'upper intermediate': 3,
            'upper-intermediate': 3,
            advanced: 4
        };

        const mapped = levelByLabel[normalized];
        if (mapped) {
            return mapped;
        }

        const parsed = Number(value);
        if (Number.isNaN(parsed)) {
            return 0;
        }

        return Math.min(Math.max(parsed, 0), this.maxBars);
    }

    updateBars() {
        const levelColors = ['beginner', 'intermediate', 'upper-intermediate', 'advanced'];
        const levelColorClass = this._level > 0 ? levelColors[this._level - 1] : '';
        this.bars = [];

        for (let i = 0; i < this.maxBars; i++) {
            const isFilled = i < this._level;
            const heightClass = `h${i + 1}`;
            const className = isFilled ? `bar ${heightClass} filled ${levelColorClass}` : `bar ${heightClass}`;

            this.bars.push({
                index: i,
                className
            });
        }
    }

    get ariaLabel() {
        return `Skill level: ${this._level} out of ${this.maxBars}`;
    }
}
