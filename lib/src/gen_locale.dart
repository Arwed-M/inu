import 'dart:io';

import 'package:inu/src/locale_generator.dart';
import 'package:yaml_mapper/yaml_mapper.dart';

LocaleGenerator genLocale(
    {required String localeCode, bool superClass = false}) {
  final File asset = File('assets/translations/$localeCode.yaml');

  final List<String> lines = asset.readAsLinesSync();
  final String indentMarker = determineWhitespace(lines);

  final locale = LocaleGenerator(parseMap(lines, indentMarker),
      localeCode: localeCode, superClass: superClass);
  createClassFile(!superClass ? localeCode : 'inu', locale.generatedClass);
  return locale;
}

void createClassFile(String className, String content) =>
    File('lib/inu_classes/$className.g.dart').writeAsStringSync(content);
