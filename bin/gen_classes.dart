import 'completeness_check.dart';
import 'extensions.dart';
import 'fs_utils.dart';
import 'init.dart';
import 'locale_generator.dart';

LocaleGenerator genLocale(
    {required String localeCode, bool superClass = false}) {
  final locale = LocaleGenerator(FS.readYamlFile(localeCode),
      localeCode: localeCode, superClass: superClass);
  FS.writeLocaleFile(!superClass ? localeCode : 'inu', locale.generatedClass);
  return locale;
}

void regenClasses({LocaleGenerator? superClass}) {
  if (!FS.inuIsConfigured) {
    initInu();
    return;
  }

  superClass ??=
      genLocale(superClass: true, localeCode: FS.superClassLocaleCode);

  // build locale class for every localization file that extends Inu
  for (var file in FS.getYamlFiles) {
    checkCompleteness(superClass, genLocale(localeCode: file.basenameNoSuffix));
  }
}

void main() {
  regenClasses();
}
