const SITE_CONTENT = {
    pt: {
        site: {
            language: 'Português',
            locale: 'pt-BR'
        },
        header: {
            nav: {
                home: 'Início',
                about: 'Sobre',
                projects: 'Portfólio',
                contact: 'Contato'
            },
            contactButton: 'Fale Comigo'
        },
        about: {
            title: 'Visão Geral de Habilidades',
            description: 'Uma visão geral das principais habilidades técnicas e práticas.'
        },
        projects: {
            title: 'Projetos',
            description: 'Confira alguns dos meus trabalhos mais recentes.'
        },
        contact: {
            title: 'Contato',
            description: 'Vamos conversar sobre seu projeto.'
        },
        footer: {
            copyright: '© 2026 | Daniele Oliveira'
        }
    },
    en: {
        site: {
            language: 'English',
            locale: 'en-US'
        },
        header: {
            nav: {
                home: 'Home',
                about: 'About',
                projects: 'Portfolio',
                contact: 'Contact'
            },
            contactButton: 'Contact Me'
        },
        about: {
            title: 'Skills Overview',
            description: 'An overview of key technical skills and practical experience.'
        },
        projects: {
            title: 'Projects',
            description: 'Check out some of my latest work.'
        },
        contact: {
            title: 'Contact',
            description: 'Let’s talk about your project.'
        },
        footer: {
            copyright: '© 2026 | Daniele Oliveira'
        }
    }
};

export function getSiteContent(language) {
    return SITE_CONTENT[language] || SITE_CONTENT.pt || {};
}

export default SITE_CONTENT;
