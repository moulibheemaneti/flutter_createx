class FlutterCreateConfig {
  String projectName;
  String org;
  String description;
  String outputDir;
  String template;
  List<String> platforms;
  String androidLanguage;
  String iosLanguage;
  bool empty;
  bool overwrite;
  bool offline;
  bool noPub;

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
