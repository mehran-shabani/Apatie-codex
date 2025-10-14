import { describe, expect, it } from 'vitest';

import { themeTokens, touchTargetMin } from './index';

describe('design tokens', () => {
  it('sets minimum touch target to at least 48px', () => {
    expect(touchTargetMin).toBeGreaterThanOrEqual(48);
  });

  it('keeps spacing values aligned to the 4px grid', () => {
    Object.values(themeTokens).forEach(({ spacing }) => {
      const values = Object.values(spacing) as string[];
      values.forEach((value) => {
        const numeric = Number.parseInt(value, 10);
        expect(Number.isNaN(numeric)).toBe(false);
        expect(numeric % 4).toBe(0);
      });
    });
  });

  it('declares typography levels for headline, body and caption', () => {
    Object.values(themeTokens).forEach(({ typography }) => {
      expect(typography.headline.size).toMatch(/rem$/);
      expect(typography.body.size).toMatch(/rem$/);
      expect(typography.caption.size).toMatch(/rem$/);
    });
  });
});
