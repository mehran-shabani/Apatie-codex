import { describe, expect, it } from 'vitest';

import { dayjs } from './dayjs';
import { formatDate, formatMeasurement, formatNumber, resolveLocale } from './format';

describe('intl format helpers', () => {
  it('formats numbers with Persian digits by default', () => {
    expect(formatNumber(48)).toBe('۴۸');
    expect(formatNumber('12', 'en')).toBe('12');
  });

  it('converts px units to Persian label when locale is fa', () => {
    expect(formatMeasurement('48px')).toBe('۴۸ پیکسل');
    expect(formatMeasurement('24px', 'en')).toBe('24 px');
  });

  it('formats dates using jalali calendar for fa locale', () => {
    const reference = dayjs('2024-03-19T00:00:00Z');
    const jalali = formatDate(reference.toDate(), 'fa');
    expect(jalali).toMatch(/۱۴۰۲|۱۴۰۳/);
    const gregorian = formatDate(reference.toDate(), 'en');
    expect(gregorian).toMatch(/2024/);
  });

  it('normalises locale codes', () => {
    expect(resolveLocale('FA')).toBe('fa-IR');
    expect(resolveLocale('en-GB')).toBe('en-US');
  });
});
