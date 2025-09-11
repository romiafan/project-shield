// Project Shield Extension: content.js
// Injected into web pages to handle autofill
// Best practice: keep content script minimal, secure, and modular

console.log('Project Shield content script loaded.');

// Autofill login forms with credentials
function autofillCredentials(credentials) {
  // Enhanced autofill: robust selectors, multiple forms, error handling
  if (!credentials || credentials.length === 0) {
    console.warn('No credentials provided for autofill.');
    return;
  }
  // Try to autofill all login forms on the page
  const forms = document.querySelectorAll('form');
  let autofilled = false;
  forms.forEach(form => {
    const usernameField = form.querySelector('input[type="text"], input[type="email"]');
    const passwordField = form.querySelector('input[type="password"]');
    if (usernameField && passwordField) {
      usernameField.value = credentials[0].username || '';
      passwordField.value = credentials[0].password || '';
      autofilled = true;
      console.log('Autofilled credentials in form:', form);
    }
  });
  if (!autofilled) {
    console.warn('No suitable login form found for autofill.');
  }
}

// Listen for autofill messages from background
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === 'autofill') {
    autofillCredentials(message.credentials);
    sendResponse({ status: 'autofilled' });
  }
});
