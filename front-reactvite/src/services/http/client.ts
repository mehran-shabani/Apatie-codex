import axios, {
  AxiosError,
  type AxiosInstance,
  type InternalAxiosRequestConfig,
} from 'axios';

import { resolveLocale } from '@/shared/intl';

import {
  type AuthTokens,
  clearAuthTokens,
  getAuthTokens,
  isAccessTokenExpired,
  setAuthTokens,
} from './tokenManager';

interface RefreshResponse {
  access: string;
  refresh?: string;
  expires_in?: number;
}

interface RetryableConfig extends InternalAxiosRequestConfig {
  _retry?: boolean;
}

const defaultBaseURL = (() => {
  const raw: unknown = import.meta.env.VITE_API_BASE_URL;
  if (typeof raw === 'string' && raw.length > 0) {
    return raw;
  }
  return 'http://localhost:8000/api/v1';
})();

const ensureTrailingSlash = (value: string): string =>
  value.endsWith('/') ? value : `${value}/`;

const computeRefreshUrl = (apiBase: string): string => {
  const baseWithSlash = ensureTrailingSlash(apiBase);
  return new URL('../auth/jwt/refresh/', baseWithSlash).toString();
};

const isBrowser = () => typeof window !== 'undefined';

const getLanguageHeader = (): string => {
  if (isBrowser() && typeof navigator !== 'undefined' && navigator.language) {
    return resolveLocale(navigator.language);
  }
  return resolveLocale('fa-IR');
};

const normaliseError = (value: unknown): Error =>
  value instanceof Error ? value : new Error('Unexpected API error');

let refreshPromise: Promise<AuthTokens> | null = null;

const performRefresh = async (refreshUrl: string): Promise<AuthTokens> => {
  if (refreshPromise) {
    return refreshPromise;
  }

  const currentTokens = getAuthTokens();
  if (!currentTokens?.refreshToken) {
    throw new Error('Missing refresh token');
  }

  refreshPromise = axios
    .post<RefreshResponse>(refreshUrl, { refresh: currentTokens.refreshToken })
    .then((response) => {
      const data: RefreshResponse = response.data;
      const expiresAt =
        typeof data.expires_in === 'number'
          ? Date.now() + data.expires_in * 1000
          : currentTokens.expiresAt;

      const nextTokens: AuthTokens = {
        accessToken: data.access,
        refreshToken: data.refresh ?? currentTokens.refreshToken,
        expiresAt,
      };
      setAuthTokens(nextTokens);
      return nextTokens;
    })
    .catch((error: unknown) => {
      clearAuthTokens();
      throw normaliseError(error);
    })
    .finally(() => {
      refreshPromise = null;
    });

  return refreshPromise;
};

const shouldSkipAuth = (config: InternalAxiosRequestConfig): boolean => {
  const url = config.url ?? '';
  return url.includes('auth/jwt');
};

const attachAuthorizationHeader = (
  config: InternalAxiosRequestConfig,
  tokens: AuthTokens | null,
) => {
  if (!tokens?.accessToken) {
    return;
  }
  const headers = config.headers as Record<string, string | undefined>;
  headers.Authorization = `Bearer ${tokens.accessToken}`;
};

const handleRequest = async (
  config: InternalAxiosRequestConfig,
  refreshUrl: string,
): Promise<InternalAxiosRequestConfig> => {
  const headers = config.headers as Record<string, string | undefined>;
  headers.Accept = 'application/json';
  headers['Accept-Language'] = getLanguageHeader();
  headers['Content-Type'] ??= 'application/json';

  if (shouldSkipAuth(config)) {
    return config;
  }

  let tokens = getAuthTokens();
  if (tokens && isAccessTokenExpired(tokens)) {
    tokens = await performRefresh(refreshUrl);
  }

  attachAuthorizationHeader(config, tokens);
  return config;
};

const handleResponseError = async (
  error: AxiosError,
  client: AxiosInstance,
  refreshUrl: string,
) => {
  const { response } = error;
  const requestConfig = error.config as RetryableConfig | undefined;

  if (!response || !requestConfig || shouldSkipAuth(requestConfig)) {
    throw error;
  }

  if (response.status !== 401 || requestConfig._retry) {
    throw error;
  }

  const tokens = getAuthTokens();
  if (!tokens?.refreshToken) {
    clearAuthTokens();
    throw error;
  }

  try {
    const refreshed = await performRefresh(refreshUrl);
    requestConfig._retry = true;
    attachAuthorizationHeader(requestConfig, refreshed);
    return await client.request(requestConfig);
  } catch (refreshError) {
    clearAuthTokens();
    throw normaliseError(refreshError);
  }
};

export interface ApiClientOptions {
  baseURL?: string;
  timeout?: number;
}

export const createApiClient = (
  options: ApiClientOptions = {},
): AxiosInstance => {
  const baseURL = options.baseURL ?? defaultBaseURL;
  const timeout = options.timeout ?? 10_000;
  const refreshUrl = computeRefreshUrl(baseURL);

  const client: AxiosInstance = axios.create({
    baseURL,
    timeout,
    withCredentials: true,
  });

  client.interceptors.request.use((config) => handleRequest(config, refreshUrl));
  client.interceptors.response.use(
        (response) => response,
    (error: unknown) => {
      if (!axios.isAxiosError(error)) {
        throw normaliseError(error);
      }
      return handleResponseError(error, client, refreshUrl);
    },
  );

  return client;
};

export const apiClient = createApiClient();

export const useApiClient = (): AxiosInstance => apiClient;

export const updateAuthTokens = (tokens: AuthTokens, persist = true): AuthTokens =>
  setAuthTokens(tokens, persist);

export const clearAuthentication = (): void => {
  clearAuthTokens();
};

export const isAuthenticated = (): boolean =>
  Boolean(getAuthTokens()?.accessToken);
