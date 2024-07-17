import 'dart:io';

import 'package:path/path.dart';

/// Changes Android name of the project.
void changeAndroidName({
  required String baseFolderPath,
  required String oldName,
  required String newNameSnakeCase,
  required String newNameUpperedFirstChars,
}) {
  final basePath = join(baseFolderPath, 'android', 'app');
  final List<File> filesToChange = [
    File(join(basePath, 'build.gradle')),
    File(join(basePath, 'src', 'debug', 'AndroidManifest.xml')),
    //androidManifest,
    File(join(basePath, 'src', 'main', 'AndroidManifest.xml')),
    File(
      join(
        basePath,
        'src',
        'main',
        'kotlin',
        'com',
        'example',
        oldName,
        'MainActivity.kt',
      ),
    ),
    File(join(basePath, 'src', 'profile', 'AndroidManifest.xml')),
  ];

  for (final file in filesToChange) {
    try {
      file.writeAsStringSync(
        file.readAsStringSync().replaceAll(oldName, newNameSnakeCase),
      );
    } catch (e) {
      // Ignore.
    }
  }

  //! Double check to make sure 'android label: ....' name is changed.
  final androidManifest =
      File(join(basePath, 'src', 'main', 'AndroidManifest.xml'));
  final androidManifestLines = androidManifest.readAsLinesSync();

  final newLines = androidManifestLines.map((e) {
    if (e.contains('android:label')) {
      return 'android:label="$newNameUpperedFirstChars"';
    } else {
      return e;
    }
  }).toList();

  androidManifest.writeAsStringSync(newLines.join('\n'));
}
