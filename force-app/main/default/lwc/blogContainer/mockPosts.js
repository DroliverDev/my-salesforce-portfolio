const POSTS = [
    {
        id: 'p-001',
        title: 'Shipping Faster With Salesforce DX',
        description: 'Practical habits that help teams reduce friction in daily Salesforce development.',
        imageUrl: '',
        content:
            'Modern Salesforce teams move faster when they standardize local setup, source tracking, and deployment automation.\n\nIn this post, we break down a lightweight workflow: scratch org templates, package boundaries, and CI checks that keep merge confidence high.',
        category: 'Salesforce',
        tags: ['DX', 'DevOps', 'CI/CD']
    },
    {
        id: 'p-002',
        title: 'Component Composition in LWC',
        description: 'How small, focused components improve readability and long-term maintainability.',
        imageUrl: '',
        content:
            'Composability is the core superpower of Lightning Web Components.\n\nDesign your parent components as orchestrators and your children as pure presenters whenever possible. This keeps testing easy and side effects isolated.',
        category: 'Tech',
        tags: ['LWC', 'Architecture', 'Frontend']
    },
    {
        id: 'p-003',
        title: 'Career Lessons From My First Architect Review',
        description: 'Mistakes I made and what changed after receiving direct design feedback.',
        imageUrl: '',
        content:
            'Architecture reviews are less about perfect diagrams and more about decision quality.\n\nThe biggest shift for me was documenting tradeoffs explicitly so reviewers could reason about constraints instead of guessing intent.',
        category: 'Career',
        tags: ['Growth', 'Architecture', 'Leadership']
    },
    {
        id: 'p-004',
        title: 'Apex Service Layer: Keep Controllers Thin',
        description: 'A practical approach to keeping business logic out of controllers and triggers.',
        imageUrl: '',
        content:
            'When controllers orchestrate and services execute business rules, your system becomes predictable.\n\nThis article shows naming conventions, dependency boundaries, and testing shortcuts that prevent brittle monolith classes.',
        category: 'Salesforce',
        tags: ['Apex', 'Architecture', 'Testing']
    },
    {
        id: 'p-005',
        title: 'Designing Better Empty States',
        description: 'Turn blank screens into moments of guidance with clear UX copy and calls to action.',
        imageUrl: '',
        content:
            'Empty states are instructional moments.\n\nA strong empty state explains why no content appears, suggests a next action, and reassures users they are not blocked by an error.',
        category: 'Tech',
        tags: ['UX', 'Frontend', 'Design']
    },
    {
        id: 'p-006',
        title: 'How I Plan Learning Sprints',
        description: 'A lightweight framework for learning new platform features every month.',
        imageUrl: '',
        content:
            'Learning plans fail when they are too broad.\n\nI now scope monthly sprints to one skill area, one project output, and one review ritual. The loop is small enough to sustain and measurable enough to improve.',
        category: 'Career',
        tags: ['Growth', 'Planning', 'Habits']
    },
    {
        id: 'p-007',
        title: 'Platform Events for Decoupled Integrations',
        description: 'When to use event-driven patterns in Salesforce and how to avoid common pitfalls.',
        imageUrl: '',
        content:
            'Platform Events shine when producer and consumer lifecycles differ.\n\nYou still need idempotency keys, retries, and observability. This guide walks through practical implementation choices for resilient processing.',
        category: 'Salesforce',
        tags: ['Integration', 'Events', 'Apex']
    },
    {
        id: 'p-008',
        title: 'Building Reliable UI States',
        description: 'Managing loading, empty, and error states without turning templates into spaghetti.',
        imageUrl: '',
        content:
            'Reliable UI is mostly state design.\n\nDefine finite view states in JavaScript and keep templates declarative. The result is easier to reason about and far less fragile during feature growth.',
        category: 'Tech',
        tags: ['State', 'LWC', 'Frontend']
    },
    {
        id: 'p-009',
        title: 'Mentoring Juniors Through Code Reviews',
        description: 'Techniques for giving feedback that teaches architecture, not just style.',
        imageUrl: '',
        content:
            'Great code reviews optimize for future decisions.\n\nI focus feedback on constraints, tradeoffs, and maintainability. Juniors then learn how to reason, not only how to format.',
        category: 'Career',
        tags: ['Mentoring', 'Leadership', 'Quality']
    }
];

export default POSTS;