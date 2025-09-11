// Project Shield Extension: popup.js
// Handles popup UI and credential search/fill

let credentialsCache = [];

function addAutofillButtons(credentials) {
  const list = document.getElementById('credentials-list');
  const results = document.getElementById('results');
  if (!list) return;
  list.innerHTML = '';
  if (!credentials || credentials.length === 0) {
    list.innerHTML = '<li>No credentials found.</li>';
    if (results) results.textContent = '';
    return;
  }
  credentials.forEach(cred => {
    const item = document.createElement('li');
    item.textContent = `${cred.username} / ${cred.url}`;
    const btn = document.createElement('button');
    btn.textContent = 'Autofill';
    btn.onclick = () => {
      chrome.runtime.sendMessage({ type: 'autofillRequest', credentials: [cred] }, (response) => {
        if (response?.status === 'autofilled') {
          btn.textContent = 'Filled!';
          setTimeout(() => { btn.textContent = 'Autofill'; }, 1500);
        }
      });
    };
    item.appendChild(btn);
    list.appendChild(item);
  });
  if (results) results.textContent = `${credentials.length} credential(s) shown.`;
}

document.addEventListener('DOMContentLoaded', () => {
  // Request credentials from background
  chrome.runtime.sendMessage({ type: 'requestCredentials' }, (response) => {
    credentialsCache = response?.credentials || [];
    addAutofillButtons(credentialsCache);
  });

  document.getElementById('search').addEventListener('input', function(e) {
    const query = e.target.value.trim().toLowerCase();
    const filtered = credentialsCache.filter(cred =>
      cred.username?.toLowerCase().includes(query) ||
      cred.url?.toLowerCase().includes(query)
    );
    addAutofillButtons(filtered);
  });
});
