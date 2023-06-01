import 'dart:io';

import 'package:inu/src/completeness_check.dart';
import 'package:inu/src/gen_locale.dart';
import 'package:inu/src/locale_generator.dart';
import 'package:path/path.dart';

import 'init.dart';

void regenClasses({LocaleGenerator? superClass}) {
  // check if init was run before
  if (!Directory('lib/inu_classes').existsSync() ||
      !File('lib/inu_classes/inu.g.dart').existsSync()) {
    initInu();
    return;
  }

  if (superClass == null) {
    final String superClassLocaleCode = File('lib/inu_classes/inu.g.dart')
        .readAsLinesSync()
        .first
        .replaceFirst('/// ', '');

    superClass = genLocale(superClass: true, localeCode: superClassLocaleCode);
  }

  // build locale class for every localization file that extends Inu
  Directory('assets/translations').list(followLinks: false).map((file) {
    final String fileName = basename(file.path);
    if (fileName.contains('.yaml')) {
      final locale = genLocale(localeCode: fileName.replaceAll('.yaml', ''));
      checkCompleteness(superClass!, locale);
    }
  }).toList();
}

void main() {
  regenClasses();
}
