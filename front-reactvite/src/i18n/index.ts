import i18n from 'i18next';
import LanguageDetector from 'i18next-browser-languagedetector';
import { initReactI18next } from 'react-i18next';

import faCommon from './resources/fa/common';
import enCommon from './resources/en/common';

export const resources = {
  fa: {
    common: faCommon,
  },
  en: {
    common: enCommon,
  },
} as const;

export type SupportedLanguage = keyof typeof resources;
export const supportedLanguages = Object.keys(resources) as SupportedLanguage[];

if (!i18n.isInitialized) {
  i18n
    .use(LanguageDetector)
    .use(initReactI18next)
    .init({
      resources,
      defaultNS: 'common',
      fallbackLng: 'en',
      lng: 'fa',
      supportedLngs: supportedLanguages,
      interpolation: {
        escapeValue: false,
      },
      detection: {
        order: ['querystring', 'localStorage', 'navigator'],
        caches: ['localStorage'],
      },
      returnObjects: true,
      load: 'languageOnly',
    })
    .catch((error: unknown) => {
      console.error('i18n initialisation failed', error);
    });
}

export default i18n;

export { LocalizationProvider } from './LocalizationProvider';
