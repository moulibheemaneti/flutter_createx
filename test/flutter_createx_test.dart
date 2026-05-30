import 'package:flutter_createx/flutter_createx.dart';
import 'package:test/test.dart';

void main() {
  group('FlutterCreateConfig defaults', () {
    late FlutterCreateConfig config;

    setUp(() => config = FlutterCreateConfig());

    test('projectName defaults to my_flutter_app', () {
      expect(config.projectName, 'my_flutter_app');
    });

    test('org defaults to com.example', () {
      expect(config.org, 'com.example');
    });

    test('description defaults to A new Flutter project.', () {
      expect(config.description, 'A new Flutter project.');
    });

    test('outputDir defaults to .', () {
      expect(config.outputDir, '.');
    });

    test('template defaults to app', () {
      expect(config.template, 'app');
    });

    test('platforms defaults to android and ios', () {
      expect(config.platforms, ['android', 'ios']);
    });

    test('androidLanguage defaults to kotlin', () {
      expect(config.androidLanguage, 'kotlin');
    });

    test('iosLanguage defaults to swift', () {
      expect(config.iosLanguage, 'swift');
    });

    test('empty defaults to false', () {
      expect(config.empty, isFalse);
    });

    test('overwrite defaults to false', () {
      expect(config.overwrite, isFalse);
    });

    test('offline defaults to false', () {
      expect(config.offline, isFalse);
    });

    test('noPub defaults to false', () {
      expect(config.noPub, isFalse);
    });
  });

  group('buildCommand — structure', () {
    test('starts with flutter create', () {
      final cmd = FlutterCreateConfig().buildCommand();
      expect(cmd, startsWith('flutter create'));
    });

    test('ends with quoted output path', () {
      final config = FlutterCreateConfig(
        projectName: 'my_app',
        outputDir: '/tmp',
      );
      expect(config.buildCommand(), endsWith('"/tmp/my_app"'));
    });

    test('output path combines outputDir and projectName', () {
      final config = FlutterCreateConfig(
        projectName: 'cool_app',
        outputDir: '/home/user/projects',
      );
      expect(config.buildCommand(), contains('"/home/user/projects/cool_app"'));
    });

    test('default config produces a valid command', () {
      final cmd = FlutterCreateConfig().buildCommand();
      expect(cmd, contains('flutter create'));
      expect(cmd, contains('--project-name=my_flutter_app'));
      expect(cmd, contains('--org=com.example'));
      expect(cmd, contains('--template=app'));
      expect(cmd, contains('--platforms=android,ios'));
      expect(cmd, contains('-a kotlin'));
      expect(cmd, contains('-i swift'));
    });
  });

  group('buildCommand — project name', () {
    test('includes provided project name', () {
      final cmd = FlutterCreateConfig(projectName: 'my_app').buildCommand();
      expect(cmd, contains('--project-name=my_app'));
    });

    test('includes snake_case project name', () {
      final cmd = FlutterCreateConfig(
        projectName: 'hello_world',
      ).buildCommand();
      expect(cmd, contains('--project-name=hello_world'));
    });
  });

  group('buildCommand — org', () {
    test('includes org', () {
      final cmd = FlutterCreateConfig(org: 'com.acme').buildCommand();
      expect(cmd, contains('--org=com.acme'));
    });

    test('includes multi-segment org', () {
      final cmd = FlutterCreateConfig(
        org: 'io.flutter.examples',
      ).buildCommand();
      expect(cmd, contains('--org=io.flutter.examples'));
    });
  });

  group('buildCommand — description', () {
    test('includes description in quotes', () {
      final cmd = FlutterCreateConfig(
        description: 'My cool app',
      ).buildCommand();
      expect(cmd, contains('--description="My cool app"'));
    });

    test('description with special characters is quoted', () {
      final cmd = FlutterCreateConfig(description: 'App & more').buildCommand();
      expect(cmd, contains('--description="App & more"'));
    });
  });

  group('buildCommand — template', () {
    const validTemplates = [
      'app',
      'module',
      'package',
      'plugin',
      'plugin_ffi',
      'skeleton',
    ];

    for (final t in validTemplates) {
      test('includes --template=$t', () {
        final cmd = FlutterCreateConfig(template: t).buildCommand();
        expect(cmd, contains('--template=$t'));
      });
    }
  });

  group('buildCommand — platforms', () {
    test('joins multiple platforms with comma', () {
      final cmd = FlutterCreateConfig(
        platforms: ['android', 'ios', 'web'],
      ).buildCommand();
      expect(cmd, contains('--platforms=android,ios,web'));
    });

    test('single platform', () {
      final cmd = FlutterCreateConfig(platforms: ['web']).buildCommand();
      expect(cmd, contains('--platforms=web'));
    });

    test('all platforms', () {
      final cmd = FlutterCreateConfig(
        platforms: ['android', 'ios', 'web', 'linux', 'macos', 'windows'],
      ).buildCommand();
      expect(cmd, contains('--platforms=android,ios,web,linux,macos,windows'));
    });

    test('preserves platform order', () {
      final cmd = FlutterCreateConfig(
        platforms: ['windows', 'linux', 'android'],
      ).buildCommand();
      expect(cmd, contains('--platforms=windows,linux,android'));
    });

    test('empty platforms list', () {
      final cmd = FlutterCreateConfig(platforms: []).buildCommand();
      expect(cmd, contains('--platforms='));
    });
  });

  group('buildCommand — android language', () {
    test('includes kotlin', () {
      final cmd = FlutterCreateConfig(androidLanguage: 'kotlin').buildCommand();
      expect(cmd, contains('-a kotlin'));
    });

    test('includes java', () {
      final cmd = FlutterCreateConfig(androidLanguage: 'java').buildCommand();
      expect(cmd, contains('-a java'));
    });
  });

  group('buildCommand — ios language', () {
    test('includes swift', () {
      final cmd = FlutterCreateConfig(iosLanguage: 'swift').buildCommand();
      expect(cmd, contains('-i swift'));
    });

    test('includes objc', () {
      final cmd = FlutterCreateConfig(iosLanguage: 'objc').buildCommand();
      expect(cmd, contains('-i objc'));
    });
  });

  group('buildCommand — boolean flags', () {
    test('includes --empty when true', () {
      expect(
        FlutterCreateConfig(empty: true).buildCommand(),
        contains('--empty'),
      );
    });

    test('omits --empty when false', () {
      expect(
        FlutterCreateConfig(empty: false).buildCommand(),
        isNot(contains('--empty')),
      );
    });

    test('includes --overwrite when true', () {
      expect(
        FlutterCreateConfig(overwrite: true).buildCommand(),
        contains('--overwrite'),
      );
    });

    test('omits --overwrite when false', () {
      expect(
        FlutterCreateConfig(overwrite: false).buildCommand(),
        isNot(contains('--overwrite')),
      );
    });

    test('includes --offline when true', () {
      expect(
        FlutterCreateConfig(offline: true).buildCommand(),
        contains('--offline'),
      );
    });

    test('omits --offline when false', () {
      expect(
        FlutterCreateConfig(offline: false).buildCommand(),
        isNot(contains('--offline')),
      );
    });

    test('includes --no-pub when true', () {
      expect(
        FlutterCreateConfig(noPub: true).buildCommand(),
        contains('--no-pub'),
      );
    });

    test('omits --no-pub when false', () {
      expect(
        FlutterCreateConfig(noPub: false).buildCommand(),
        isNot(contains('--no-pub')),
      );
    });

    test('all flags true appear together', () {
      final cmd = FlutterCreateConfig(
        empty: true,
        overwrite: true,
        offline: true,
        noPub: true,
      ).buildCommand();
      expect(cmd, contains('--empty'));
      expect(cmd, contains('--overwrite'));
      expect(cmd, contains('--offline'));
      expect(cmd, contains('--no-pub'));
    });

    test('no boolean flags appear when all false', () {
      final cmd = FlutterCreateConfig(
        empty: false,
        overwrite: false,
        offline: false,
        noPub: false,
      ).buildCommand();
      expect(cmd, isNot(contains('--empty')));
      expect(cmd, isNot(contains('--overwrite')));
      expect(cmd, isNot(contains('--offline')));
      expect(cmd, isNot(contains('--no-pub')));
    });
  });

  group('buildCommand — field mutation', () {
    test('reflects projectName change after construction', () {
      final config = FlutterCreateConfig();
      config.projectName = 'updated_app';
      expect(config.buildCommand(), contains('--project-name=updated_app'));
    });

    test('reflects template change after construction', () {
      final config = FlutterCreateConfig();
      config.template = 'plugin';
      expect(config.buildCommand(), contains('--template=plugin'));
    });

    test('reflects platforms change after construction', () {
      final config = FlutterCreateConfig();
      config.platforms = ['web', 'macos'];
      expect(config.buildCommand(), contains('--platforms=web,macos'));
    });

    test('reflects boolean flag change after construction', () {
      final config = FlutterCreateConfig();
      config.empty = true;
      expect(config.buildCommand(), contains('--empty'));
    });
  });
}
