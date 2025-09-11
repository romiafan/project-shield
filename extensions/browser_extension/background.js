// Project Shield Extension: background.js
// Handles extension events, credential sync, and messaging
// Best practice: keep background logic modular and secure

// Message types
const MESSAGE_TYPES = {
  REQUEST_CREDENTIALS: 'request_credentials',
  SYNC_CREDENTIALS: 'sync_credentials',
  AUTOFILL: 'autofill',
};

// Credentials cache (for demo, replace with secure storage/fetch)
let credentialsCache = [];

// On install/update
chrome.runtime.onInstalled.addListener(() => {
  console.log('Project Shield Extension installed.');
  // TODO: Initial credential sync from app/server
});

// Credential sync logic
async function fetchCredentials() {
  // Secure fetch from Project Shield app/server
  // NOTE: Always use HTTPS in production and never hardcode tokens
  try {
    // Retrieve token securely (e.g., from extension storage)
    const token = await new Promise((resolve, reject) => {
      chrome.storage.local.get(['authToken'], (result) => {
        if (chrome.runtime.lastError) reject(chrome.runtime.lastError);
        else resolve(result.authToken);
      });
    });
    if (!token) throw new Error('No auth token found');
    const response = await fetch('https://localhost:8080/api/credentials', {
      credentials: 'include',
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    if (!response.ok) throw new Error('Failed to fetch credentials');
    const data = await response.json();
    return data.credentials || [];
  } catch (err) {
    console.error('Credential fetch error:', err);
    // Optionally notify popup/content script of error
    return [];
  }
}

// Export for unit testing
if (typeof module !== 'undefined') {
  module.exports = { fetchCredentials };
}

// Listen for messages from popup or content scripts
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  switch (message.type) {
    case MESSAGE_TYPES.REQUEST_CREDENTIALS:
      fetchCredentials().then(credentials => {
        sendResponse({ credentials });
      });
      // Indicate async response
      return true;
    case MESSAGE_TYPES.SYNC_CREDENTIALS:
      // TODO: Sync credentials from app/server
      credentialsCache = message.credentials || [];
      sendResponse({ status: 'synced' });
      break;
    case MESSAGE_TYPES.AUTOFILL:
      // TODO: Forward autofill request to content script
      chrome.tabs.sendMessage(sender.tab.id, message, sendResponse);
      break;
    default:
      sendResponse({ status: 'unknown message type' });
  }
  // Return true for async sendResponse
  return true;
});

// Relay autofill request from popup to content script
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === 'autofillRequest') {
    // Send autofill message to active tab
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
      if (tabs.length > 0) {
        chrome.tabs.sendMessage(tabs[0].id, {
          type: 'autofill',
          credentials: message.credentials
        }, (response) => {
          sendResponse(response);
        });
      } else {
        sendResponse({ status: 'no-active-tab' });
      }
    });
    return true;
  }
});

// TODO: Add secure communication with Project Shield app (REST/WebSocket)
