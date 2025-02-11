import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  tutorialSidebar: [
    {
      type: 'doc',
      id: 'intro',
      label: 'Introduction',
    },
    {
      type: 'doc',
      id: 'architecture',
      label: 'Processor Architecture',
    },
    {
      type: 'doc',
      id: 'source-organization',
      label: 'Source Code Organization',
    },
    {
      type: 'doc',
      id: 'simulation-guide',
      label: 'Simulation Guide',
    },
    {
      type: 'doc',
      id: 'adding-instructions',
      label: 'Adding RV32I Instructions',
    },
  ],
};

export default sidebars;
