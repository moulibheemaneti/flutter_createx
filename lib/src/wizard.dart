import 'dart:io';

import 'package:dart_console/dart_console.dart';

import 'flags.dart';

/// Interactive terminal wizard that guides the user through every
/// `flutter create` option and executes the resulting command.
///
/// Uses arrow-key navigation for single-select and multi-select prompts,
/// then shows a preview of the generated command before asking for
/// confirmation.
///
/// ```dart
/// await FlutterCreateWizard().run();
/// ```
class FlutterCreateWizard {
  final console = Console();
  final config = FlutterCreateConfig();

  /// Runs the full wizard: clears the screen, steps through each section,
  /// displays a command preview, and executes `flutter create` on confirmation.
  Future<void> run() async {
    console.clearScreen();
    _printHeader();

    await _sectionProject();
    await _sectionTemplate();
    await _sectionPlatforms();
    await _sectionLanguages();
    await _sectionOptions();

    _printPreview();
    await _confirm();
  }

  // ── Header ──────────────────────────────────────────────────────────────

  void _printHeader() {
    console.setForegroundColor(ConsoleColor.cyan);
    console.writeLine('  ╔══════════════════════════════════════════╗');
    console.writeLine('  ║     🐦  flutter createx  —  v1.0.0      ║');
    console.writeLine('  ╚══════════════════════════════════════════╝');
    console.resetColorAttributes();
    console.writeLine('');
  }

  void _printSection(String title) {
    console.writeLine('');
    console.setForegroundColor(ConsoleColor.yellow);
    console.writeLine('  ── $title ${'─' * (40 - title.length)}');
    console.resetColorAttributes();
  }

  // ── Input helpers ────────────────────────────────────────────────────────

  String _ask(String prompt, String defaultValue) {
    console.setForegroundColor(ConsoleColor.white);
    stdout.write('  › $prompt ');
    console.setForegroundColor(ConsoleColor.brightBlack);
    stdout.write('[$defaultValue]: ');
    console.resetColorAttributes();
    final input = stdin.readLineSync()?.trim() ?? '';
    return input.isEmpty ? defaultValue : input;
  }

  // Arrow keys + enter — returns first word of selected option.
  String _selectOne(String prompt, List<String> options) {
    console.setForegroundColor(ConsoleColor.white);
    console.writeLine('  › $prompt');
    console.resetColorAttributes();
    console.setForegroundColor(ConsoleColor.brightBlack);
    console.writeLine('  ↑↓ navigate   enter select');
    console.resetColorAttributes();

    var cursor = 0;

    void render() {
      for (var i = 0; i < options.length; i++) {
        stdout.write('\r');
        console.eraseLine();
        if (i == cursor) {
          console.setForegroundColor(ConsoleColor.cyan);
          stdout.write('    ● ${options[i]}');
        } else {
          console.setForegroundColor(ConsoleColor.brightBlack);
          stdout.write('    ○ ${options[i]}');
        }
        console.resetColorAttributes();
        stdout.write('\n');
      }
    }

    void moveToFirstOption() {
      for (var i = 0; i < options.length; i++) {
        stdout.write('\x1b[1A');
      }
    }

    console.hideCursor();
    render();

    while (true) {
      final key = console.readKey();
      if (!key.isControl) continue;

      switch (key.controlChar) {
        case ControlCharacter.arrowUp:
          cursor = (cursor - 1 + options.length) % options.length;
          moveToFirstOption();
          render();
        case ControlCharacter.arrowDown:
          cursor = (cursor + 1) % options.length;
          moveToFirstOption();
          render();
        case ControlCharacter.enter:
          console.showCursor();
          final label = options[cursor].split(' ').first;
          moveToFirstOption();
          stdout.write('\r');
          console.eraseCursorToEnd();
          console.setForegroundColor(ConsoleColor.green);
          stdout.write('  ✓ $label\n');
          console.resetColorAttributes();
          return label;
        case ControlCharacter.ctrlC:
          console.showCursor();
          exit(0);
        default:
          break;
      }
    }
  }

  // Arrow keys + space toggle + enter — returns sorted list of selected indices.
  List<int> _selectMany(
    String prompt,
    List<String> options,
    List<int> defaultSelected,
  ) {
    console.setForegroundColor(ConsoleColor.white);
    console.writeLine('  › $prompt');
    console.resetColorAttributes();
    console.setForegroundColor(ConsoleColor.brightBlack);
    console.writeLine('  ↑↓ navigate   space toggle   enter confirm');
    console.resetColorAttributes();

    var cursor = 0;
    final selected = <int>{...defaultSelected};

    void render() {
      for (var i = 0; i < options.length; i++) {
        stdout.write('\r');
        console.eraseLine();
        final isCursor = i == cursor;
        final isSelected = selected.contains(i);

        if (isCursor) {
          console.setForegroundColor(ConsoleColor.cyan);
          stdout.write('    ❯ ');
        } else {
          console.setForegroundColor(ConsoleColor.brightBlack);
          stdout.write('      ');
        }

        if (isSelected) {
          console.setForegroundColor(ConsoleColor.green);
          stdout.write('■ ');
        } else {
          console.setForegroundColor(ConsoleColor.brightBlack);
          stdout.write('□ ');
        }

        if (isCursor) {
          console.setForegroundColor(ConsoleColor.white);
        } else {
          console.setForegroundColor(ConsoleColor.brightBlack);
        }
        stdout.write(options[i]);
        console.resetColorAttributes();
        stdout.write('\n');
      }
    }

    void moveToFirstOption() {
      for (var i = 0; i < options.length; i++) {
        stdout.write('\x1b[1A');
      }
    }

    console.hideCursor();
    render();

    while (true) {
      final key = console.readKey();

      if (!key.isControl && key.char == ' ') {
        if (selected.contains(cursor)) {
          selected.remove(cursor);
        } else {
          selected.add(cursor);
        }
        moveToFirstOption();
        render();
        continue;
      }

      if (!key.isControl) continue;

      switch (key.controlChar) {
        case ControlCharacter.arrowUp:
          cursor = (cursor - 1 + options.length) % options.length;
          moveToFirstOption();
          render();
        case ControlCharacter.arrowDown:
          cursor = (cursor + 1) % options.length;
          moveToFirstOption();
          render();
        case ControlCharacter.enter:
          console.showCursor();
          final result = selected.toList()..sort();
          final summary = result.isEmpty
              ? 'none'
              : result.map((i) => options[i].split(' ').first).join(', ');
          moveToFirstOption();
          stdout.write('\r');
          console.eraseCursorToEnd();
          console.setForegroundColor(ConsoleColor.green);
          stdout.write('  ✓ $summary\n');
          console.resetColorAttributes();
          return result;
        case ControlCharacter.ctrlC:
          console.showCursor();
          exit(0);
        default:
          break;
      }
    }
  }

  // ── Sections ─────────────────────────────────────────────────────────────

  Future<void> _sectionProject() async {
    _printSection('Project');
    config.projectName = _ask('Project name (snake_case)', config.projectName);
    config.org = _ask('Organisation (reverse domain)', config.org);
    config.description = _ask('Short description', config.description);
    config.outputDir = _ask('Output directory', config.outputDir);
  }

  Future<void> _sectionTemplate() async {
    _printSection('Template');
    config.template = _selectOne('Project template', [
      'app        — full Flutter application (default)',
      'module     — embed into existing native app',
      'package    — reusable Dart/Flutter library',
      'plugin     — platform plugin with native code',
      'plugin_ffi — native C/C++ via Dart FFI',
      'skeleton   — opinionated app with nav & theming',
    ]);
  }

  Future<void> _sectionPlatforms() async {
    _printSection('Platforms');
    const all = ['android', 'ios', 'web', 'linux', 'macos', 'windows'];
    final indices = _selectMany('Platforms', all, [0, 1]);
    config.platforms = indices.map((i) => all[i]).toList();
  }

  Future<void> _sectionLanguages() async {
    _printSection('Languages');
    config.androidLanguage = _selectOne('Android language', [
      'kotlin (recommended)',
      'java',
    ]);
    config.iosLanguage = _selectOne('iOS language', [
      'swift (recommended)',
      'objc',
    ]);
  }

  Future<void> _sectionOptions() async {
    _printSection('Options');
    const displays = [
      'empty     — no sample code',
      'overwrite — if directory exists',
      'offline   — use cached packages',
      'noPub     — skip flutter pub get',
    ];
    final defaults = <int>[
      if (config.empty) 0,
      if (config.overwrite) 1,
      if (config.offline) 2,
      if (config.noPub) 3,
    ];
    final selected = _selectMany('Project options', displays, defaults);
    config.empty = selected.contains(0);
    config.overwrite = selected.contains(1);
    config.offline = selected.contains(2);
    config.noPub = selected.contains(3);
  }

  // ── Preview ───────────────────────────────────────────────────────────────

  void _printPreview() {
    console.writeLine('');
    console.setForegroundColor(ConsoleColor.cyan);
    console.writeLine('  ╔══════════════════════════════════════════╗');
    console.writeLine('  ║           📋  Command Preview            ║');
    console.writeLine('  ╚══════════════════════════════════════════╝');
    console.resetColorAttributes();
    console.writeLine('');
    console.setForegroundColor(ConsoleColor.white);
    console.writeLine('  ${config.buildCommand()}');
    console.resetColorAttributes();
    console.writeLine('');
  }

  // ── Confirm & Execute ─────────────────────────────────────────────────────

  Future<void> _confirm() async {
    console.setForegroundColor(ConsoleColor.yellow);
    stdout.write('  ▶  Run this command? [Y/n]: ');
    console.resetColorAttributes();

    final input = stdin.readLineSync()?.trim().toLowerCase() ?? '';
    if (input.isNotEmpty && !input.startsWith('y')) {
      console.writeLine('');
      console.setForegroundColor(ConsoleColor.brightBlack);
      console.writeLine('  Aborted. Nothing was created.');
      console.resetColorAttributes();
      return;
    }

    console.writeLine('');
    console.setForegroundColor(ConsoleColor.green);
    console.writeLine('  Creating project…');
    console.resetColorAttributes();
    console.writeLine('');

    final flutterBin = await _resolveFlutter();

    final result = await Process.run(flutterBin, [
      'create',
      '--project-name=${config.projectName}',
      '--org=${config.org}',
      '--description=${config.description}',
      '--template=${config.template}',
      '--platforms=${config.platforms.join(',')}',
      '-a',
      config.androidLanguage,
      '-i',
      config.iosLanguage,
      if (config.empty) '--empty',
      if (config.overwrite) '--overwrite',
      if (config.offline) '--offline',
      if (config.noPub) '--no-pub',
      '${config.outputDir}/${config.projectName}',
    ], runInShell: true);
    stdout.write(result.stdout);
    stderr.write(result.stderr);

    if (result.exitCode == 0) {
      console.setForegroundColor(ConsoleColor.green);
      console.writeLine('  ✅ Done! Project "${config.projectName}" created.');
      console.setForegroundColor(ConsoleColor.brightBlack);
      console.writeLine(
        '  cd ${config.outputDir}/${config.projectName} && flutter run',
      );
      console.resetColorAttributes();
    } else {
      console.setForegroundColor(ConsoleColor.red);
      console.writeLine('  ❌ flutter create failed. See output above.');
      console.resetColorAttributes();
    }
  }

  Future<String> _resolveFlutter() async {
    final check = await Process.run('flutter', ['--version'], runInShell: true);
    if (check.exitCode == 0) return 'flutter';

    final fvmCheck = await Process.run('fvm', [
      'flutter',
      '--version',
    ], runInShell: true);
    if (fvmCheck.exitCode == 0) return 'fvm flutter';

    console.setForegroundColor(ConsoleColor.red);
    console.writeLine('  ❌ Neither flutter nor fvm found on PATH.');
    console.resetColorAttributes();
    exit(1);
  }
}
