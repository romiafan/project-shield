# 🛡️ Project Shield

Flutter monorepo (Melos-ready) using Riverpod.

## 🚀 Release Notes

### v0.0.1 (September 9, 2025)

- Initial MVP release
- Modular credential management (Vault)
- Trash Can for deleted credentials
- Import/Export functionality
- Expanded credential types
- Feature toggling (modular UI)
- All compilation errors resolved
- Release branch and tag created

See [roadmap.md](./roadmap.md) for next milestones.

## Repository Layout

- apps/app: Main Flutter application
- packages/core: Shared business logic (Dart)
- packages/ui: Shared UI widgets (Flutter)
- packages/api_client: Backend API client (Dart)

## Prerequisites

- Flutter 3.10+ (stable)
- Dart SDK (bundled with Flutter)
- Melos (optional): dart pub global activate melos

## Environment

- Copy template and set values:

```bash
cp .env.template .env.development
# edit .env.development and set ENCRYPTION_SALT (base64 32 bytes)
```

## Install & Bootstrap

From repo root:

```bash
melos bootstrap  # optional; safe to run
```

## Dark Mode Toggle

Project Shield supports a dark mode toggle in the Settings screen. You can switch between light, dark, and system themes. The selected theme is persisted and restored automatically using Riverpod and shared_preferences.

## Import/Export Credentials

You can import and export your credentials as JSON files from the Settings screen:

- **Export**: Downloads all credentials as a JSON file (`credentials_export.json`).
- **Import**: Select a JSON file to replace all credentials in the app. Only valid Project Shield credential files are accepted.

### Supported Credential Types

Project Shield supports the following credential types:

- **Basic**: Standard username/password credentials
- **TOTP**: Time-based One-Time Password (2FA) secrets
- **Passkey**: WebAuthn passkey credentials (credential ID, public key)
- **Credit Card**: Card number, expiry, holder, CVC
- **Secure Note**: Encrypted note content
- **Identity/License**: Personal or license info (fields may expand)

All types and fields are fully supported in import/export. You can backup, restore, and migrate all credential types seamlessly.

Limitations:

- Import/export is currently supported for web. Other platforms may require additional integration.
- Import will overwrite all existing credentials.

## Run the App

From repo root:

```bash
flutter run -d chrome --dart-define-from-file=.env.development -t apps/app/lib/main.dart
```

Or from app directory:

```bash
cd apps/app
flutter run -d chrome --dart-define-from-file=../../.env.development
```

## Git Workflow

- Main branch: main
- Conventional commits recommended (e.g., feat:, fix:, chore:)
- Secrets policy:
  - Env files are ignored by Git (.env\*), except .env.template
  - If a secret is ever committed, rotate it and purge history (done once for .env.development)

## Scripts

```bash
flutter analyze
```

## Roadmap

See roadmap.md.

## Docker (build and run web)

Set an encryption salt and build:

```bash
export ENCRYPTION_SALT=$(openssl rand -base64 32)
docker build --build-arg ENCRYPTION_SALT="$ENCRYPTION_SALT" -t project-shield-web .
docker run -p 8080:80 project-shield-web
```

Or via compose:

```bash
export ENCRYPTION_SALT=$(openssl rand -base64 32)
docker compose up --build
```

Open http://localhost:8080

## Browser Extension (In Progress)

The Project Shield browser extension is under active development. It enables secure credential sync, autofill, and popup UI integration with the main app.

### Features

- Sync credentials from the Project Shield app/server
- Autofill login forms on supported websites
- Popup UI to view and autofill credentials

### Setup

1. Build or clone the extension in `extensions/browser_extension`.
2. Add icons to the `icons/` folder (see instructions above).
3. Load the extension in your browser (Chrome/Edge/Firefox) via the Extensions page.
4. Open a login page and use the popup to autofill credentials.

### Status

- Scaffolded and functional for credential sync and autofill
- UI and security improvements planned

See `extensions/browser_extension/README.md` for more details.
