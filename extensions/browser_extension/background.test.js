// background.test.js
// Unit tests for Project Shield Extension background.js
// Uses Jest (best practice for JS extensions)

const fetchMock = require('jest-fetch-mock');
fetchMock.enableMocks();

// Mock chrome.runtime.onInstalled.addListener before importing background.js
global.chrome = {
  storage: {
    local: {
      get: (keys, cb) => cb({ authToken: 'test-token' })
    }
  },
  runtime: {
    lastError: null,
    onInstalled: {
      addListener: jest.fn()
    },
    onMessage: {
      addListener: jest.fn()
    }
  },
  tabs: {
    sendMessage: jest.fn()
  }
};

describe('background.js', () => {
  beforeEach(() => {
    fetchMock.resetMocks();
  });

  it('fetchCredentials returns credentials on success', async () => {
    fetchMock.mockResponseOnce(JSON.stringify({ credentials: [{ username: 'user', url: 'https://site.com' }] }));
    const fetchCredentials = require('./background.js').fetchCredentials;
    const creds = await fetchCredentials();
    expect(creds).toEqual([{ username: 'user', url: 'https://site.com' }]);
  });

  it('fetchCredentials returns empty array on error', async () => {
    fetchMock.mockRejectOnce(new Error('Network error'));
    const fetchCredentials = require('./background.js').fetchCredentials;
    const creds = await fetchCredentials();
    expect(creds).toEqual([]);
  });
});
