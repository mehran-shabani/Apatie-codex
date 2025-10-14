import { type PropsWithChildren, type ReactElement } from 'react';

import { ThemeProvider } from '@/design/theme';
import { LocalizationProvider } from '@/i18n';

export function AppProviders({ children }: PropsWithChildren): ReactElement {
  return (
    <LocalizationProvider>
      <ThemeProvider>{children}</ThemeProvider>
    </LocalizationProvider>
  );
}
