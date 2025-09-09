# 🛡️ Project Shield: Development Guide & Roadmap

Welcome to the Project Shield command center! This document provides a complete guide for setting up your development environment, understanding the project's architecture, and following the development roadmap from our initial MVP to future releases.

---

## 🚀 Release History

### v0.0.1 (September 9, 2025)

- MVP features complete and released to main
- See README.md for details

---

## 🏁 1. Getting Started

Follow these instructions to get the project running on your local machine.

### Prerequisites

- **Flutter SDK**: Version 3.10 or higher.
- **IDE**: Visual Studio Code (with Dart/Flutter extensions) or Cursor IDE.
- **Melos**: Activate it globally: `dart pub global activate melos`.
- **Docker**: (Optional) For running a local sync server/database.

### Installation & Setup

1.  **Clone the Repository (using SSH):**
    As you use SSH for Git, use the following command.

    ```bash
    git clone git@github.com:your-username/password-manager-app.git
    cd password-manager-app
    ```

2.  **Verify Flutter Setup:**
    Before proceeding, run `flutter doctor` to ensure your environment is configured correctly.

3.  **Set Up Environment Variables:**
    This file contains sensitive values like the encryption salt.

    ```bash
    cp .env.template .env.development
    ```

    After copying, open `.env.development` and fill in the required values.

4.  **Bootstrap the Monorepo:**
    This command links all local packages and installs their dependencies.

    ```bash
    melos bootstrap
    ```

### Running the Application

To run the app, you must point to the development environment file using the `--dart-define-from-file` flag.

```bash
# Run on Web (using Firefox Developer Edition)
# Note: Ensure 'firefox' is available in the output of `flutter devices`.
flutter run -d firefox --dart-define-from-file=.env.development

macOS Desktop App (via Xcode)
iOS App (via Xcode, on the simulator or a connected iPhone)
Android App (via Android Studio, on the emulator or a connected Android phone)
Web App (in Firefox, as we configured)
Windows App (if you were to develop on a Windows machine)
To make your roadmap.md even more of an "ultimate guide," I'll update it to include the specific commands for running the app on the native platforms you're now equipped to build for.
Here is the updated and final version of your personalized roadmap.md.


🏛️ 2. Technology & Architecture


Technology Stack

Framework: Flutter
Language: Dart
State Management: Riverpod
Monorepo Management: Melos
Encryption: encrypt package

📂 Project Structure

This project is a monorepo that separates concerns into distinct packages.
/apps/app: The main Flutter application, containing all UI-related code.
/packages/core: Shared, pure Dart business logic.
/packages/ui: A shared library of custom Flutter widgets.
/packages/api_client: Handles all communication with the backend sync server.

workflow 3. Development Workflow

Branching Strategy: We use a GitFlow-lite model (main, develop, feature/*).
Commits: Follow the Conventional Commits specification.

🗺️ 4. MVP Roadmap: The First Stable Release

The goal of this phase is to build the core, essential features of the password manager.

Milestone 1: Foundational UI & Navigation

- [x] Task: Create the main Shell widget with a BottomNavigationBar.
- [x] Task: Create the initial placeholder screens for "Vault", "Generator", and "Settings".
- [x] Task: Manage the navigation state using Riverpod.

Milestone 2: Credential Management Feature

- [x] Task: Set up the "Credentials" feature folder according to the project architecture.
- [x] Task: Design and build the UI for credentials_screen.dart.
- [x] Task: Implement the Riverpod providers to handle credential state.
- [x] Task: Build the "Add/Edit Credential" form screen.

Milestone 3: Strong Password Generator

- [x] Task: Set up the "Generator" feature folder.
- [x] Task: Build the UI for generator_screen.dart.
- [x] Task: Implement the business logic in the core package.
- [x] Task: Connect the UI to the generation logic using a Riverpod provider.

🚀 5. Beyond the MVP: Future Milestones


Milestone 4: Quality of Life & Onboarding

- [x] Data Import/Export
- [x] Trash Can
- [x] Expanded Credential Types

Milestone 5: Proactive Security & Integration

[ ] Browser Extensions
[ ] Password Health Dashboard

Future Vision

[ ] Passkey Support
[ ] 2FA Authenticator (TOTP)
```
