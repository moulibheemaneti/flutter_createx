/// An interactive terminal wizard for `flutter create`.
///
/// Browse and configure all `flutter create` flags visually using an
/// arrow-key driven UI, then review the generated command and execute
/// it with a single confirmation.
///
/// ```dart
/// import 'package:flutter_createx/flutter_createx.dart';
///
/// void main() async {
///   await FlutterCreateWizard().run();
/// }
/// ```
library;

export 'src/flags.dart';
export 'src/flutter_createx_base.dart';
export 'src/wizard.dart';
