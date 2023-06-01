import 'dart:io';

import 'package:neko/src/completeness_check.dart';
import 'package:neko/src/gen_locale.dart';
import 'package:neko/src/locale_generator.dart';
import 'package:path/path.dart';

import 'init.dart';

void regenClasses({LocaleGenerator? superClass}) {
  // check if init was run before
  if (!Directory('lib/neko_classes').existsSync() ||
      !File('lib/neko_classes/neko.g.dart').existsSync()) {
    initNeko();
    return;
  }

  if (superClass == null) {
    final String superClassLocaleCode = File('lib/neko_classes/neko.g.dart')
        .readAsLinesSync()
        .first
        .replaceFirst('/// ', '');

    superClass = genLocale(superClass: true, localeCode: superClassLocaleCode);
  }

  // build locale class for every localization file that extends Neko
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
