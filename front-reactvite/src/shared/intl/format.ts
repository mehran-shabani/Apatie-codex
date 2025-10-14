import { dayjs, localeCalendarMap } from './dayjs';

const MEASUREMENT_REGEX = /^(\d+)(.*)$/;

export const resolveLocale = (language: string): string => {
  if (!language) {
    return 'fa-IR';
  }
  const normalised = language.toLowerCase();
  if (normalised.startsWith('fa')) {
    return 'fa-IR';
  }
  if (normalised.startsWith('en')) {
    return 'en-US';
  }
  return language;
};

export const formatNumber = (value: number | string, language = 'fa-IR'): string => {
  const locale = resolveLocale(language);
  const numericValue = typeof value === 'number' ? value : Number(value);
  if (Number.isNaN(numericValue)) {
    return String(value);
  }
  return new Intl.NumberFormat(locale, { useGrouping: false }).format(numericValue);
};

export const localizeDigits = (input: string, language = 'fa-IR'): string => {
  const locale = resolveLocale(language);
  return input.replace(/\d+/g, (segment) => formatNumber(Number(segment), locale));
};

export const formatMeasurement = (value: string, language = 'fa-IR'): string => {
  const locale = resolveLocale(language);
  const match = MEASUREMENT_REGEX.exec(value);
  if (!match) {
    return localizeDigits(value, language);
  }
  const [, numericPart, unitPart] = match;
  const formatted = formatNumber(Number(numericPart), language);
  const trimmedUnit = unitPart.trim();
  if (!trimmedUnit) {
    return formatted;
  }
  const lowerUnit = trimmedUnit.toLowerCase();
  const localizedUnit = locale.startsWith('fa') && lowerUnit === 'px' ? 'پیکسل' : localizeDigits(trimmedUnit, language);
  return `${formatted} ${localizedUnit}`.trim();
};

export const formatDate = (
  value: string | number | Date,
  language = 'fa-IR',
  format = 'YYYY MMMM DD',
): string => {
  const locale = resolveLocale(language);
  const calendar = localeCalendarMap[locale] ?? 'jalali';
  const base = dayjs(value);
  if (!base.isValid()) {
    return '';
  }
  if (calendar === 'jalali') {
    const formatted = base.calendar('jalali').locale('fa').format(format);
    return localizeDigits(formatted, 'fa-IR');
  }
  return base.locale(locale).format(format);
};
