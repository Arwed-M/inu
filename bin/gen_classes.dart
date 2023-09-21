import 'dart:io';

import 'package:path/path.dart';

import 'completeness_check.dart';
import 'constants.dart';
import 'gen_locale.dart';
import 'init.dart';
import 'locale_generator.dart';

void regenClasses({LocaleGenerator? superClass}) {
  final bool initHasBeenRun = !Locations.classesDir.existsSync() ||
      !File(Locations.generatedFilePath).existsSync();

  if (initHasBeenRun) {
    initInu();
    return;
  }

  if (superClass == null) {
    final String superClassLocaleCode = Locations.generatedFile
        .readAsLinesSync()
        .first
        .replaceFirst('/// ', '');

    superClass = genLocale(superClass: true, localeCode: superClassLocaleCode);
  }

  // build locale class for every localization file that extends Inu
  Locations.translationDir.list(followLinks: false).map((file) {
    final String fileName = basename(file.path);
    if (fileName.contains(Locations.yamlFileSuffix)) {
      checkCompleteness(
          superClass!,
          genLocale(
              localeCode: fileName.replaceAll(Locations.yamlFileSuffix, '')));
    }
  }).toList();
}

void main() {
  regenClasses();
}
