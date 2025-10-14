export type ThemeName = 'light' | 'dark';

export interface ColorTokens {
  background: string;
  backgroundMuted: string;
  surface: string;
  surfaceHover: string;
  border: string;
  divider: string;
  overlay: string;
  shadowColor: string;
  textPrimary: string;
  textSecondary: string;
  textMuted: string;
  textOnAccent: string;
  textOnInverted: string;
  primary: string;
  primaryHover: string;
  accent: string;
  accentHover: string;
  success: string;
  successSurface: string;
  warning: string;
  warningSurface: string;
  danger: string;
  dangerSurface: string;
  info: string;
  infoSurface: string;
}

export interface TypographyTokens {
  fontFamily: string;
  headline: {
    size: string;
    weight: number;
    lineHeight: string;
  };
  body: {
    size: string;
    weight: number;
    lineHeight: string;
  };
  caption: {
    size: string;
    weight: number;
    lineHeight: string;
  };
}

export interface SpacingTokens {
  none: string;
  '2xs': string;
  xs: string;
  sm: string;
  md: string;
  lg: string;
  xl: string;
  '2xl': string;
  '3xl': string;
}

export interface RadiusTokens {
  xs: string;
  sm: string;
  md: string;
  lg: string;
  xl: string;
  pill: string;
}

export interface ShadowTokens {
  resting: string;
  floating: string;
  overlay: string;
}

export interface InteractionTokens {
  touchTargetMin: string;
}

export interface DesignTokens {
  theme: ThemeName;
  colors: ColorTokens;
  typography: TypographyTokens;
  spacing: SpacingTokens;
  radius: RadiusTokens;
  shadows: ShadowTokens;
  interaction: InteractionTokens;
}

const typography: TypographyTokens = {
  fontFamily: '"Vazirmatn", "IRANSansX", "Tahoma", sans-serif',
  headline: {
    size: '1.875rem',
    weight: 700,
    lineHeight: '2.5rem',
  },
  body: {
    size: '1rem',
    weight: 500,
    lineHeight: '1.75rem',
  },
  caption: {
    size: '0.875rem',
    weight: 400,
    lineHeight: '1.5rem',
  },
};

const spacing: SpacingTokens = {
  none: '0px',
  '2xs': '4px',
  xs: '8px',
  sm: '12px',
  md: '16px',
  lg: '24px',
  xl: '32px',
  '2xl': '40px',
  '3xl': '48px',
};

const radius: RadiusTokens = {
  xs: '4px',
  sm: '8px',
  md: '12px',
  lg: '16px',
  xl: '24px',
  pill: '999px',
};

const interaction: InteractionTokens = {
  touchTargetMin: '48px',
};

const lightColors: ColorTokens = {
  background: '#f6f7fb',
  backgroundMuted: '#eef1f9',
  surface: '#ffffff',
  surfaceHover: '#f2f4fc',
  border: '#d0d5e6',
  divider: '#e2e7f1',
  overlay: 'rgba(17, 24, 39, 0.45)',
  shadowColor: 'rgba(15, 23, 42, 0.16)',
  textPrimary: '#111827',
  textSecondary: '#374151',
  textMuted: '#4b5563',
  textOnAccent: '#ffffff',
  textOnInverted: '#0f172a',
  primary: '#1f6feb',
  primaryHover: '#1858c2',
  accent: '#7c3aed',
  accentHover: '#6d28d9',
  success: '#0f7a43',
  successSurface: '#e6f5ec',
  warning: '#b45309',
  warningSurface: '#fff4e1',
  danger: '#b91c1c',
  dangerSurface: '#fee2e2',
  info: '#0369a1',
  infoSurface: '#e0f2fe',
};

const darkColors: ColorTokens = {
  background: '#0b1223',
  backgroundMuted: '#111c33',
  surface: '#14213f',
  surfaceHover: '#1b2a52',
  border: '#24385b',
  divider: '#1f2f4d',
  overlay: 'rgba(2, 6, 23, 0.6)',
  shadowColor: 'rgba(0, 0, 0, 0.42)',
  textPrimary: '#f8fafc',
  textSecondary: '#cbd5f5',
  textMuted: '#94a3c2',
  textOnAccent: '#081525',
  textOnInverted: '#f9fafc',
  primary: '#60a5fa',
  primaryHover: '#3b82f6',
  accent: '#a855f7',
  accentHover: '#9333ea',
  success: '#34d399',
  successSurface: '#0f2c22',
  warning: '#fbbf24',
  warningSurface: '#33250a',
  danger: '#f87171',
  dangerSurface: '#2f1518',
  info: '#38bdf8',
  infoSurface: '#0c1f33',
};

export const themeTokens: Record<ThemeName, DesignTokens> = {
  light: {
    theme: 'light',
    colors: lightColors,
    typography,
    spacing,
    radius,
    shadows: {
      resting: '0 1px 2px rgba(15, 23, 42, 0.12)',
      floating:
        '0 12px 32px rgba(15, 23, 42, 0.16), 0 6px 12px rgba(15, 23, 42, 0.08)',
      overlay: '0 24px 60px rgba(15, 23, 42, 0.28)',
    },
    interaction,
  },
  dark: {
    theme: 'dark',
    colors: darkColors,
    typography,
    spacing,
    radius,
    shadows: {
      resting: '0 1px 2px rgba(0, 0, 0, 0.4)',
      floating: '0 16px 40px rgba(0, 0, 0, 0.55), 0 6px 16px rgba(0, 0, 0, 0.35)',
      overlay: '0 30px 70px rgba(0, 0, 0, 0.65)',
    },
    interaction,
  },
};

export const defaultTheme: ThemeName = 'light';

export const touchTargetMin = Number.parseInt(interaction.touchTargetMin, 10);
