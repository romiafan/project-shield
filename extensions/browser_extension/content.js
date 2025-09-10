// Project Shield Extension: content.js
// Injected into web pages to handle autofill
// Best practice: keep content script minimal, secure, and modular

console.log('Project Shield content script loaded.');

// Autofill login forms with credentials
function autofillCredentials(credentials) {
  // TODO: Find login fields and fill with credentials
  // Example: document.querySelector('input[type="password"]')
  // For deployment, use robust selectors and handle edge cases
  if (!credentials || credentials.length === 0) return;
  // Demo: Fill first found login form
  const usernameField = document.querySelector('input[type="text"], input[type="email"]');
  const passwordField = document.querySelector('input[type="password"]');
  if (usernameField && passwordField) {
    usernameField.value = credentials[0].username || '';
    passwordField.value = credentials[0].password || '';
  }
}

// Listen for autofill messages from background
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === 'autofill') {
    autofillCredentials(message.credentials);
    sendResponse({ status: 'autofilled' });
  }
});
