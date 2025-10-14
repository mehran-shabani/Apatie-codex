import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactElement,
  type ReactNode,
} from 'react';

import {
  type DesignTokens,
  type ThemeName,
  defaultTheme,
  themeTokens,
} from '@/design/tokens';

interface ThemeContextValue {
  theme: ThemeName;
  tokens: DesignTokens;
  setTheme: (theme: ThemeName) => void;
}

const ThemeContext = createContext<ThemeContextValue | undefined>(undefined);

const cssVariablesFromTokens = (tokens: DesignTokens): Record<string, string> => {
  const { colors, typography, spacing, radius, shadows, interaction } = tokens;

  return {
    '--color-background': colors.background,
    '--color-background-muted': colors.backgroundMuted,
    '--color-surface': colors.surface,
    '--color-surface-hover': colors.surfaceHover,
    '--color-border': colors.border,
    '--color-divider': colors.divider,
    '--color-overlay': colors.overlay,
    '--color-text-primary': colors.textPrimary,
    '--color-text-secondary': colors.textSecondary,
    '--color-text-muted': colors.textMuted,
    '--color-text-inverted': colors.textOnAccent,
    '--color-text-on-inverted': colors.textOnInverted,
    '--color-primary': colors.primary,
    '--color-primary-hover': colors.primaryHover,
    '--color-accent': colors.accent,
    '--color-accent-hover': colors.accentHover,
    '--color-success': colors.success,
    '--color-success-surface': colors.successSurface,
    '--color-warning': colors.warning,
    '--color-warning-surface': colors.warningSurface,
    '--color-danger': colors.danger,
    '--color-danger-surface': colors.dangerSurface,
    '--color-info': colors.info,
    '--color-info-surface': colors.infoSurface,
    '--shadow-resting': shadows.resting,
    '--shadow-floating': shadows.floating,
    '--shadow-overlay': shadows.overlay,
    '--font-family-base': typography.fontFamily,
    '--font-headline-size': typography.headline.size,
    '--font-headline-weight': typography.headline.weight.toString(),
    '--font-headline-lineheight': typography.headline.lineHeight,
    '--font-body-size': typography.body.size,
    '--font-body-weight': typography.body.weight.toString(),
    '--font-body-lineheight': typography.body.lineHeight,
    '--font-caption-size': typography.caption.size,
    '--font-caption-weight': typography.caption.weight.toString(),
    '--font-caption-lineheight': typography.caption.lineHeight,
    '--space-none': spacing.none,
    '--space-2xs': spacing['2xs'],
    '--space-xs': spacing.xs,
    '--space-sm': spacing.sm,
    '--space-md': spacing.md,
    '--space-lg': spacing.lg,
    '--space-xl': spacing.xl,
    '--space-2xl': spacing['2xl'],
    '--space-3xl': spacing['3xl'],
    '--radius-xs': radius.xs,
    '--radius-sm': radius.sm,
    '--radius-md': radius.md,
    '--radius-lg': radius.lg,
    '--radius-xl': radius.xl,
    '--radius-pill': radius.pill,
    '--target-min': interaction.touchTargetMin,
  };
};

const applyTokensToDocument = (tokens: DesignTokens): void => {
  const root = document.documentElement;
  root.setAttribute('data-theme', tokens.theme);
  const variables = cssVariablesFromTokens(tokens);
  Object.entries(variables).forEach(([cssVar, value]) => {
    root.style.setProperty(cssVar, value);
  });
};

interface ThemeProviderProps {
  initialTheme?: ThemeName;
  children: ReactNode;
}

export function ThemeProvider({
  initialTheme = defaultTheme,
  children,
}: ThemeProviderProps): ReactElement {
  const [theme, setThemeState] = useState<ThemeName>(initialTheme);

  const tokens = useMemo(() => themeTokens[theme], [theme]);

  useEffect(() => {
    applyTokensToDocument(tokens);
  }, [tokens]);

  const setTheme = useCallback((nextTheme: ThemeName) => {
    setThemeState(nextTheme);
  }, []);

  const value = useMemo<ThemeContextValue>(
    () => ({
      theme,
      tokens,
      setTheme,
    }),
    [theme, tokens, setTheme],
  );

  return <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>;
}

export function useTheme(): ThemeContextValue {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  return context;
}
