export interface AuthTokens {
  accessToken: string;
  refreshToken: string;
  expiresAt?: number;
}

const STORAGE_KEY = 'apatie.auth';

let inMemoryTokens: AuthTokens | null = null;

const hasStorage = (): boolean =>
  typeof window !== 'undefined' && typeof window.localStorage !== 'undefined';

const readFromStorage = (): AuthTokens | null => {
  if (!hasStorage()) {
    return null;
  }
  const raw = window.localStorage.getItem(STORAGE_KEY);
  if (!raw) {
    return null;
  }
  try {
    const parsed = JSON.parse(raw) as AuthTokens;
    return parsed;
  } catch (error) {
    console.warn('Unable to parse auth tokens from storage', error);
    window.localStorage.removeItem(STORAGE_KEY);
    return null;
  }
};

export const getAuthTokens = (): AuthTokens | null => {
  if (inMemoryTokens) {
    return inMemoryTokens;
  }
  const stored = readFromStorage();
  if (stored) {
    inMemoryTokens = stored;
  }
  return inMemoryTokens;
};

export const setAuthTokens = (tokens: AuthTokens, persist = true): AuthTokens => {
  inMemoryTokens = tokens;
  if (persist && hasStorage()) {
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(tokens));
  }
  return inMemoryTokens;
};

export const clearAuthTokens = (): void => {
  inMemoryTokens = null;
  if (hasStorage()) {
    window.localStorage.removeItem(STORAGE_KEY);
  }
};

export const isAccessTokenExpired = (tokens: AuthTokens | null): boolean => {
  if (!tokens?.expiresAt) {
    return false;
  }
  return Date.now() >= tokens.expiresAt;
};
