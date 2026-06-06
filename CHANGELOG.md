# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2026-06-06

### Changed
- Moved package logo from `.github/assets/` to `doc/assets/`.
- Improved `pubspec.yaml`: refined description, added `topics`, `homepage`, `issue_tracker`, and `screenshots` fields; loosened SDK constraint to `>=3.0.0 <4.0.0`.
- Added GitHub community standards: `CONTRIBUTING.md`, issue templates, PR template, `CODE_OF_CONDUCT.md`, `SECURITY.md`.
- Updated README logo URL to reflect new asset path.
- Bumped `process_run` to `^1.3.4`, `test` to `^1.31.1`, `dart_husky` to `^1.2.2`.

## [1.0.0] - 2026-05-30

### Added
- **Interactive CLI Wizard**: Built an arrow-key-driven terminal wizard using `dart_console` that lets developers visually browse, select, and configure all `flutter create` flags instead of memorising them.
- **Interactive Option Prompts**:
  - **Single-select Prompts**: Implemented arrow-key navigation with active item highlighting for template selection (`app`, `module`, `package`, `plugin`, `plugin_ffi`, `skeleton`) and platform-specific languages (`kotlin`/`java` for Android, `swift`/`objc` for iOS).
  - **Multi-select Prompts**: Created responsive checkboxes allowing users to toggle options (e.g. target platforms: `android`, `ios`, `web`, `linux`, `macos`, `windows` and project options like `--empty`, `--overwrite`, `--offline`, `--no-pub`) with the `space` bar and confirm with `enter`.
- **Environment Auto-Detection (FVM Aware)**: Added automatic path/runtime resolution. The tool auto-detects whether `flutter` or Flutter Version Management (`fvm flutter`) is configured in the environment, falling back smoothly and outputting actionable errors if neither is found on `PATH`.
- **Command Preview & Approval**: Added a clean command preview screen showing a formatted, multi-line visualization of the generated `flutter create` command before executing. Users can approve or abort cleanly.
- **Rich Visual Terminal Feedback**: Implemented vibrant colors, interactive section breaks, customized checkmarks, and intuitive helper guides (e.g., `↑↓ navigate  space toggle  enter confirm`).
- **Comprehensive API & Documentation**:
  - Added clean exports in `flutter_createx.dart` exposing the configuration model and interactive wizard.
  - Implemented thorough Dartdoc comments across all public interfaces and configurations.
  - Set up `package:lints/recommended.yaml` static analyzer guidelines for clean Dart style.
- **Robust Test Suite**:
  - Wrote detailed unit tests in `test/flutter_createx_test.dart` to verify default package config values, runtime mutations, platform list joining, Boolean flag logic, and accurate multi-line shell command serialization.
- **Automation & Workflow CI**:
  - Added GitHub Actions workflow (`pr_title.yml`) to enforce conventional commits rules on PR titles.
  - Configured Dependabot (`dependabot.yml`) for automated daily dependency upgrades.
  - Added MIT License and clean conventional commits guidelines for contributions.

