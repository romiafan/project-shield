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
