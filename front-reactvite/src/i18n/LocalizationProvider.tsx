import { type ReactElement, type ReactNode, useEffect } from 'react';
import { I18nextProvider, useTranslation } from 'react-i18next';

import { dayjs, resolveLocale } from '@/shared/intl';

import i18n from './index';

const LanguageEffects = ({ children }: { children: ReactNode }): ReactElement => {
  const { i18n: instance } = useTranslation();

  useEffect(() => {
    const locale = resolveLocale(instance.language);
    const direction = locale.startsWith('fa') ? 'rtl' : 'ltr';
    const doc = document.documentElement;
    doc.lang = locale;
    doc.dir = direction;
    doc.dataset.locale = locale;
    dayjs.locale(locale.startsWith('fa') ? 'fa' : 'en');
  }, [instance.language]);

  return <>{children}</>;
};

export const LocalizationProvider = ({ children }: { children: ReactNode }): ReactElement => {
  return (
    <I18nextProvider i18n={i18n} defaultNS="common">
      <LanguageEffects>{children}</LanguageEffects>
    </I18nextProvider>
  );
};
