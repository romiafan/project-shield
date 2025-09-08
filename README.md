# 🛡️ Project Shield

Flutter monorepo (Melos-ready) using Riverpod.

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


## Install & Bootstrap
From repo root:


## Run the App
From repo root:

Or from app directory:


## Git Workflow
- Main branch: main
- Conventional commits recommended (e.g., feat:, fix:, chore:)
- Secrets policy:
  - Env files are ignored by Git (.env*), except .env.template
  - If a secret is ever committed, rotate it and purge history (done once for .env.development)

## Scripts


## Roadmap
See roadmap.md.
