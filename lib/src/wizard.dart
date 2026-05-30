import 'dart:io';

import 'package:dart_console/dart_console.dart';

import 'flags.dart';

class FlutterCreateWizard {
  final console = Console();
  final config = FlutterCreateConfig();

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

  String _choose(String prompt, List<String> options) {
    console.setForegroundColor(ConsoleColor.white);
    console.writeLine('  › $prompt');
    console.resetColorAttributes();
    for (var i = 0; i < options.length; i++) {
      console.setForegroundColor(ConsoleColor.brightBlack);
      stdout.write('    ${i + 1}) ');
      console.resetColorAttributes();
      console.writeLine(options[i]);
    }
    stdout.write('  → choice [1-${options.length}]: ');
    final input = stdin.readLineSync()?.trim() ?? '1';
    final index = (int.tryParse(input) ?? 1) - 1;
    return options[index.clamp(0, options.length - 1)].split(' ').first;
  }

  bool _yesNo(String prompt, bool defaultValue) {
    final hint = defaultValue ? 'Y/n' : 'y/N';
    stdout.write('  › $prompt [$hint]: ');
    final input = stdin.readLineSync()?.trim().toLowerCase() ?? '';
    if (input.isEmpty) return defaultValue;
    return input.startsWith('y');
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
    config.template = _choose('Project template', [
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
    final all = ['android', 'ios', 'web', 'linux', 'macos', 'windows'];
    config.platforms = all.where((p) {
      final def = ['android', 'ios'].contains(p);
      return _yesNo('Include $p?', def);
    }).toList();
  }

  Future<void> _sectionLanguages() async {
    _printSection('Languages');
    config.androidLanguage = _choose('Android language', [
      'kotlin (recommended)',
      'java',
    ]);
    config.iosLanguage = _choose('iOS language', [
      'swift (recommended)',
      'objc',
    ]);
  }

  Future<void> _sectionOptions() async {
    _printSection('Options');
    config.empty = _yesNo('Empty project? (no sample code)', config.empty);
    config.overwrite = _yesNo(
      'Overwrite if directory exists?',
      config.overwrite,
    );
    config.offline = _yesNo('Force offline (cached packages)?', config.offline);
    config.noPub = _yesNo('Skip flutter pub get?', config.noPub);
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

    // Detect flutter executable
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
