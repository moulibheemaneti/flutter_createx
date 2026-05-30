<div align="center">

<img src="https://raw.githubusercontent.com/moulibheemaneti/flutter_createx/main/.github/assets/logo.png" alt="flutter_createx" width="80" />

# flutter_createx

**Interactive terminal wizard for `flutter create` — configure all flags visually, preview the command, then execute.**

[![pub version](https://img.shields.io/pub/v/flutter_createx.svg?style=flat-square&color=0175C2&labelColor=1a1a2e)](https://pub.dev/packages/flutter_createx)
[![pub points](https://img.shields.io/pub/points/flutter_createx?style=flat-square&color=0175C2&labelColor=1a1a2e)](https://pub.dev/packages/flutter_createx/score)
[![license](https://img.shields.io/badge/license-MIT-0175C2?style=flat-square&labelColor=1a1a2e)](LICENSE)
[![dart](https://img.shields.io/badge/dart-%3E%3D3.12.0-0175C2?style=flat-square&labelColor=1a1a2e)](https://dart.dev)

No flags to memorise. No docs to look up.  
Just run `flutter createx` and walk through every option interactively.

</div>

---

## Why flutter_createx?

`flutter create` is powerful — but it has 11 flags, 6 templates, and 6 platform options. Nobody memorises all of them.

`flutter_createx` turns it into a guided wizard:

```
✦ Visual flag selection — arrow keys, space to toggle, enter to confirm
✦ All flutter create flags exposed — nothing hidden
✦ Command preview — see the exact command before it runs
✦ Approval step — nothing executes without your confirmation
✦ FVM aware — works with flutter or fvm flutter automatically
✦ Zero config — install once, run anywhere
```

---

## Installation

```sh
dart pub global activate flutter_createx
```

That's it. No config files, no project setup.

---

## Usage

```sh
flutter createx
```

The wizard walks you through every option step by step:

```
  ╔══════════════════════════════════════════╗
  ║     🐦  flutter createx  —  v1.0.0      ║
  ╚══════════════════════════════════════════╝

  ── Project ────────────────────────────────
  › Project name (snake_case) [my_flutter_app]:
  › Organisation (reverse domain) [com.example]:
  › Short description [A new Flutter project.]:
  › Output directory [.]:

  ── Template ───────────────────────────────
  › Project template
    ↑↓ navigate   enter select
  ❯ app        — full Flutter application (default)
    module     — embed into existing native app
    package    — reusable Dart/Flutter library
    ...

  ── Platforms ──────────────────────────────
  › Target platforms
    ↑↓ navigate   space toggle   enter confirm
  ❯ ◉ android
    ◉ ios
    ◯ web
    ...

  ── Command Preview ────────────────────────
  flutter create \
    --project-name=my_app \
    --org=com.acme \
    --template=app \
    --platforms=android,ios \
    -a kotlin -i swift \
    "./projects/my_app"

  ▶  Run this command? [Y/n]:
```

---

## Sections

| Section | What you configure |
|---|---|
| **Project** | Name, organisation, description, output directory |
| **Template** | app, module, package, plugin, plugin_ffi, skeleton |
| **Platforms** | android, ios, web, linux, macos, windows |
| **Languages** | Kotlin / Java for Android, Swift / ObjC for iOS |
| **Options** | --empty, --overwrite, --offline, --no-pub |

---

## Templates

| Template | Use case |
|---|---|
| `app` | Full Flutter application — the default |
| `module` | Embed Flutter into an existing native app |
| `package` | Reusable Dart/Flutter library for pub.dev |
| `plugin` | Platform plugin with native Kotlin/Swift code |
| `plugin_ffi` | Native C/C++ interop via Dart FFI |
| `skeleton` | Opinionated app with navigation & theming |

---

## How It Works

```
you run: flutter createx
         └── Flutter CLI looks for executable: flutter_createx
                  └── finds dart pub global binary
                           └── launches interactive wizard
                                    └── builds flutter create command
                                             └── shows preview + waits for approval
                                                      └── executes flutter create ✅
```

`dart pub global activate` places the `flutter_createx` binary on your PATH. Flutter's CLI automatically delegates unknown subcommands to binaries named `flutter_<subcommand>` — no shell tricks, no aliases.

---

## Requirements

- Dart SDK `>=3.12.0`
- Flutter installed — `flutter` or `fvm flutter` (auto-detected)

---

## Contributing

Contributions are welcome! Please make sure your commits follow the conventional commits format.

---

<div align="center">

Made with 🎯 by [@moulibheemaneti](https://github.com/moulibheemaneti)  
MIT License

</div>
