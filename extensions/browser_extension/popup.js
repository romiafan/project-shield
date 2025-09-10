// Project Shield Extension: popup.js
// Handles popup UI and credential search/fill

function addAutofillButtons(credentials) {
  const list = document.getElementById('credentials-list');
  if (!list) return;
  list.innerHTML = '';
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
}

document.addEventListener('DOMContentLoaded', () => {
  // Request credentials from background
  chrome.runtime.sendMessage({ type: 'requestCredentials' }, (response) => {
    const credentials = response?.credentials || [];
    addAutofillButtons(credentials);
  });
});

document.getElementById('search').addEventListener('input', function(e) {
  const query = e.target.value;
  // TODO: Search credentials (fetch from background/app)
  document.getElementById('results').textContent = 'Searching for: ' + query;
});

// TODO: Display credential results and autofill options
