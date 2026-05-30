/// Holds every flag that can be passed to `flutter create` and builds
/// the final shell command string.
class FlutterCreateConfig {
  /// The Dart package name for the new project, must be `snake_case`.
  ///
  /// Passed as `--project-name`. Defaults to `'my_flutter_app'`.
  String projectName;

  /// Reverse-domain organisation identifier, e.g. `com.example`.
  ///
  /// Passed as `--org`. Defaults to `'com.example'`.
  String org;

  /// A short human-readable description of the project.
  ///
  /// Passed as `--description`. Defaults to `'A new Flutter project.'`.
  String description;

  /// Directory under which the project folder will be created.
  ///
  /// The final output path is `$outputDir/$projectName`.
  /// Defaults to the current working directory `'.'`.
  String outputDir;

  /// The `flutter create` template to use.
  ///
  /// Passed as `--template`. Valid values:
  /// `app`, `module`, `package`, `plugin`, `plugin_ffi`, `skeleton`.
  /// Defaults to `'app'`.
  String template;

  /// Target platforms to enable for the project.
  ///
  /// Passed as `--platforms` with values joined by commas.
  /// Valid values: `android`, `ios`, `web`, `linux`, `macos`, `windows`.
  /// Defaults to `['android', 'ios']`.
  List<String> platforms;

  /// Language to use for Android-specific code.
  ///
  /// Passed as `-a`. Valid values: `'kotlin'`, `'java'`.
  /// Defaults to `'kotlin'`.
  String androidLanguage;

  /// Language to use for iOS-specific code.
  ///
  /// Passed as `-i`. Valid values: `'swift'`, `'objc'`.
  /// Defaults to `'swift'`.
  String iosLanguage;

  /// Whether to generate an empty project with no sample code.
  ///
  /// Adds `--empty` when `true`. Defaults to `false`.
  bool empty;

  /// Whether to overwrite the target directory if it already exists.
  ///
  /// Adds `--overwrite` when `true`. Defaults to `false`.
  bool overwrite;

  /// Whether to use only locally cached pub packages (no network).
  ///
  /// Adds `--offline` when `true`. Defaults to `false`.
  bool offline;

  /// Whether to skip running `flutter pub get` after project creation.
  ///
  /// Adds `--no-pub` when `true`. Defaults to `false`.
  bool noPub;

  /// Creates a [FlutterCreateConfig] with sensible defaults.
  ///
  /// Every parameter is optional; omitted values fall back to the defaults
  /// documented on each field.
  FlutterCreateConfig({
    this.projectName = 'my_flutter_app',
    this.org = 'com.example',
    this.description = 'A new Flutter project.',
    this.outputDir = '.',
    this.template = 'app',
    this.platforms = const ['android', 'ios'],
    this.androidLanguage = 'kotlin',
    this.iosLanguage = 'swift',
    this.empty = false,
    this.overwrite = false,
    this.offline = false,
    this.noPub = false,
  });

  /// Builds and returns the full `flutter create` shell command string.
  ///
  /// The command is formatted across multiple lines with `\\\n  ` separators
  /// for readability. Boolean flags are omitted when `false`.
  ///
  /// Example output:
  /// ```
  /// flutter create \
  ///   --project-name=my_flutter_app \
  ///   --org=com.example \
  ///   ...
  /// ```
  String buildCommand() {
    final parts = <String>['flutter create'];

    parts.add('--project-name=$projectName');
    parts.add('--org=$org');
    parts.add('--description="$description"');
    parts.add('--template=$template');
    parts.add('--platforms=${platforms.join(',')}');
    parts.add('-a $androidLanguage');
    parts.add('-i $iosLanguage');

    if (empty) parts.add('--empty');
    if (overwrite) parts.add('--overwrite');
    if (offline) parts.add('--offline');
    if (noPub) parts.add('--no-pub');

    parts.add('"$outputDir/$projectName"');

    return parts.join(' \\\n  ');
  }
}
