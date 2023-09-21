import 'dart:io';

import 'package:yaml_mapper/yaml_mapper.dart';

import 'constants.dart';
import 'locale_generator.dart';

LocaleGenerator genLocale(
    {required String localeCode, bool superClass = false}) {

  final locale = LocaleGenerator(_readYamlFile(localeCode),
      localeCode: localeCode, superClass: superClass);

  _createClassFile(!superClass ? localeCode : 'inu', locale.generatedClass);
  return locale;
}

Yaml _readYamlFile(String localeCode) {
  final File asset = Locations.localeFile(localeCode);
  final List<String> lines = asset.readAsLinesSync();
  final String indentMarker = determineWhitespace(lines);
  return parseMap(lines, indentMarker);
}

void _createClassFile(String className, String content) =>
    Locations.classFile(className).writeAsStringSync(content);
