import 'completeness_check.dart';
import 'fs_utils.dart';
import 'init.dart';
import 'models/node.dart';

LocaleClass genLocale({required String localeCode, bool superClass = false}) {
  final yaml = FS.readLocaleFile(localeCode);
  final locale = superClass
      ? SuperClass(yaml: yaml, locale: localeCode)
      : LocaleClass(yaml: yaml, locale: localeCode);
  FS.writeLocaleFile(superClass ? 'inu' : localeCode, locale.renderDartFile());
  return locale;
}

void regenClasses({SuperClass? superClass}) {
  if (!FS.inuIsConfigured) {
    initInu();
    return;
  }

  superClass ??=
      genLocale(superClass: true, localeCode: FS.superClassLocaleCode)
          as SuperClass;

  // build locale class for every localization file that extends Inu
  for (var file in FS.getYamlFiles) {
    checkCompleteness(superClass, genLocale(localeCode: file.basenameNoSuffix));
  }
}

void main() => regenClasses();
