import { afterAll, afterEach, beforeAll, describe, expect, it, vi } from 'vitest';
import { HttpResponse, http } from 'msw';
import { setupServer } from 'msw/node';

const API_BASE = 'https://api.test.local/api/v1';
const REFRESH_URL = 'https://api.test.local/api/auth/jwt/refresh/';

const server = setupServer();

beforeAll(() => {
  server.listen({ onUnhandledRequest: 'error' });
});
afterEach(() => {
  server.resetHandlers();
  vi.resetModules();
  vi.unstubAllEnvs();
});
afterAll(() => {
  server.close();
});

const bootstrapClient = async (): Promise<typeof import('./index')> => {
  vi.stubEnv('VITE_API_BASE_URL', API_BASE);
  return import('./index');
};

describe('api client', () => {
  it('attaches bearer token to outgoing requests', async () => {
    let authorizationHeader: string | null = null;
    server.use(
      http.get(`${API_BASE}/users`, ({ request }) => {
        authorizationHeader = request.headers.get('authorization');
        return HttpResponse.json({ data: [] });
      }),
    );

    const clientModule = await bootstrapClient();
    const clientFactory = clientModule.createApiClient;

    clientModule.updateAuthTokens(
      {
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
        expiresAt: Date.now() + 60_000,
      },
      false,
    );

    const client = clientFactory({ baseURL: API_BASE });
    await client.get('/users');

    expect(authorizationHeader).toBe('Bearer access-token');
    clientModule.clearAuthentication();
  });

  it('refreshes token on 401 responses and retries the request', async () => {
    let attempt = 0;
    server.use(
      http.get(`${API_BASE}/services`, () => {
        attempt += 1;
        if (attempt === 1) {
          return new HttpResponse(null, { status: 401 });
        }
        return HttpResponse.json({ data: ['ok'] });
      }),
      http.post(REFRESH_URL, async ({ request }) => {
        const body = (await request.json()) as { refresh: string };
        expect(body).toMatchObject({ refresh: 'refresh-token' });
        return HttpResponse.json({
          access: 'next-access',
          refresh: 'refresh-token',
          expires_in: 120,
        });
      }),
    );

    const refreshModule = await bootstrapClient();
    const refreshClientFactory = refreshModule.createApiClient;

    refreshModule.updateAuthTokens(
      {
        accessToken: 'stale-token',
        refreshToken: 'refresh-token',
        expiresAt: Date.now() - 5_000,
      },
      false,
    );

    const client = refreshClientFactory({ baseURL: API_BASE });
    const response = await client.get('/services');

    expect(response.status).toBe(200);
    expect(attempt).toBe(2);
    expect(refreshModule.getAuthTokens()?.accessToken).toBe('next-access');
  });

  it('clears tokens when refresh fails', async () => {
    server.use(
      http.get(`${API_BASE}/appointments`, () => new HttpResponse(null, { status: 401 })),
      http.post(REFRESH_URL, () => new HttpResponse(null, { status: 401 })),
    );

    const failureModule = await bootstrapClient();
    const failureClientFactory = failureModule.createApiClient;

    failureModule.updateAuthTokens(
      {
        accessToken: 'expired',
        refreshToken: 'refresh-token',
        expiresAt: Date.now() - 5_000,
      },
      false,
    );

    const client = failureClientFactory({ baseURL: API_BASE });

    await expect(client.get('/appointments')).rejects.toThrow();
    expect(failureModule.getAuthTokens()).toBeNull();
    failureModule.clearAuthentication();
  });
});
