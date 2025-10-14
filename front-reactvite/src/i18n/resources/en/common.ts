const common = {
  app: {
    title: 'Apatie Design System',
    description:
      'Phase one establishes the design tokens, light/dark theming, and service foundations required for the next implementation stages.',
    activeTheme: 'Active mode: {{mode}}',
    switchTo: 'Switch to {{mode}} mode',
    today: 'Today: {{date}}',
  },
  tokens: {
    spacingTitle: 'Spacing tokens',
    spacingSubtitle: 'Spacing follows a 4px / 8px rhythm to ensure visual consistency.',
    typographyTitle: 'Typography tokens',
    typographySubtitle: 'Headline, body, and caption styles honour the Persian formal tone while keeping RTL alignment.',
    labels: {
      headline: 'Headline',
      body: 'Body',
      caption: 'Caption',
    },
    surfaceTitle: 'Radii & shadows',
    shadowResting: 'Resting elevation shadow',
    shadowFloating: 'Floating elevation shadow',
    touchTarget:
      'Minimum touch target is {{size}} and status badges map to success, warning, and error states.',
  },
  status: {
    success: 'Success',
    warning: 'Warning',
    danger: 'Error',
  },
  themeStates: {
    light: 'Light',
    dark: 'Dark',
  },
};

export default common;
