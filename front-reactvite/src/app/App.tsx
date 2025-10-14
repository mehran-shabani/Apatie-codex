import { type ReactElement } from 'react';
import { useTranslation } from 'react-i18next';

import { AppProviders } from './providers';
import { useTheme } from '@/design/theme';
import { formatDate, formatMeasurement, localizeDigits, resolveLocale } from '@/shared/intl';

function RootView(): ReactElement {
  const { theme, setTheme, tokens } = useTheme();
  const { t, i18n } = useTranslation();
  const locale = resolveLocale(i18n.language);
  const nextTheme = theme === 'light' ? 'dark' : 'light';

  const spacingEntries = Object.entries(tokens.spacing) as [keyof typeof tokens.spacing, string][];
  const spacingTokens = spacingEntries.map(([key, value]) => ({
    key,
    value: formatMeasurement(value, locale),
  }));

  const radiusEntries = Object.entries(tokens.radius) as [keyof typeof tokens.radius, string][];
  const radiusTokens = radiusEntries.map(([key, value]) => ({
    key,
    value: formatMeasurement(value, locale),
  }));

  return (
    <main>
      <header className="app-card app-card__section">
        <div className="app-card__section">
          <h1>{t('app.title')}</h1>
          <p>{t('app.description')}</p>
          <p>{t('app.today', { date: formatDate(new Date(), locale) })}</p>
        </div>
        <div className="app-card__section" style={{ gap: 'var(--space-xs)' }}>
          <span className="badge badge--info">
            {t('app.activeTheme', { mode: t(`themeStates.${theme}` as const) })}
          </span>
          <button
            type="button"
            className="app-button"
            onClick={() => {
              setTheme(nextTheme);
            }}
          >
            {t('app.switchTo', { mode: t(`themeStates.${nextTheme}` as const) })}
          </button>
        </div>
      </header>

      <section className="app-card">
        <div className="app-card__section">
          <h2>{t('tokens.spacingTitle')}</h2>
          <p>{t('tokens.spacingSubtitle')}</p>
          <div className="token-grid">
            {spacingTokens.map(({ key, value }) => (
              <div key={key} className="token-grid__item">
                <span className="token-grid__label">{key}</span>
                <span className="token-grid__value">{value}</span>
              </div>
            ))}
          </div>
        </div>

        <div className="app-card__section">
          <h2>{t('tokens.typographyTitle')}</h2>
          <p>{t('tokens.typographySubtitle')}</p>
          <ul className="token-list">
            <li>
              <strong>{t('tokens.labels.headline')}:</strong>{' '}
              {localizeDigits(tokens.typography.headline.size, locale)} /{' '}
              {localizeDigits(tokens.typography.headline.lineHeight, locale)}
            </li>
            <li>
              <strong>{t('tokens.labels.body')}:</strong>{' '}
              {localizeDigits(tokens.typography.body.size, locale)} /{' '}
              {localizeDigits(tokens.typography.body.lineHeight, locale)}
            </li>
            <li>
              <strong>{t('tokens.labels.caption')}:</strong>{' '}
              {localizeDigits(tokens.typography.caption.size, locale)} /{' '}
              {localizeDigits(tokens.typography.caption.lineHeight, locale)}
            </li>
          </ul>
        </div>

        <div className="app-card__section">
          <h2>{t('tokens.surfaceTitle')}</h2>
          <div className="token-grid token-grid--small">
            {radiusTokens.map(({ key, value }) => (
              <div key={key} className="token-grid__item">
                <span className="token-grid__label">{key}</span>
                <span className="token-grid__value">{value}</span>
              </div>
            ))}
          </div>
          <div className="shadow-preview">
            <div className="shadow-preview__item" data-shadow="resting">
              {t('tokens.shadowResting')}
            </div>
            <div className="shadow-preview__item" data-shadow="floating">
              {t('tokens.shadowFloating')}
            </div>
          </div>
        </div>
      </section>

      <footer className="app-card app-card__section">
        <p>
          {t('tokens.touchTarget', {
            size: formatMeasurement(tokens.interaction.touchTargetMin, locale),
          })}
        </p>
        <div className="badge-group">
          <span className="badge badge--success">{t('status.success')}</span>
          <span className="badge badge--warning">{t('status.warning')}</span>
          <span className="badge badge--danger">{t('status.danger')}</span>
        </div>
      </footer>
    </main>
  );
}

export function App(): ReactElement {
  return (
    <AppProviders>
      <RootView />
    </AppProviders>
  );
}
