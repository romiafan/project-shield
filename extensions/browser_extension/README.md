# Project Shield Browser Extension

This extension will provide autofill and credential sync features for Project Shield users.

## Features (Planned)

- Autofill login forms
- Sync credentials with Project Shield app
- Popup UI for credential search and fill
- Secure communication with app/server

## Getting Started

1. Clone the repo and navigate to `/extensions/browser_extension`
2. Load the extension in your browser (Chrome: Extensions > Load unpacked)
3. Start development with `background.js`, `content.js`, and `popup.html`

## Architecture

- Manifest V3 (Chrome, Edge)
- WebExtension API (Firefox, planned)
- Communication: REST/WebSocket/Native Messaging (TBD)

## Security Recommendations

- Restrict content script matches in `manifest.json` to login pages only (avoid `<all_urls>` if possible).
- Store authentication tokens only in extension background scripts, never expose to content scripts or popup.
- Use HTTPS for all communication with the Project Shield app/server.
- Minimize permissions in `manifest.json` (remove unused permissions).
- Review and audit extension code for credential leaks and secure handling.

See main roadmap.md for integration status and next steps.
