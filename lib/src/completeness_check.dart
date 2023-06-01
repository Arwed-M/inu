import 'dart:convert';
import 'dart:io';

import 'package:neko/src/gen_locale.dart';
import 'package:yaml_mapper/yaml_mapper.dart';

import 'locale_generator.dart';
import 'translation.dart';

void checkCompleteness(LocaleGenerator superClass, LocaleGenerator locale) {
  List<String> missingKeys = findMissingKeys(superClass, locale);

  final String lang = locale.localeCode;

  if (missingKeys.isEmpty) return;

  print(
      "\nFound ${missingKeys.length} missing translation${missingKeys.length > 1 ? "s" : ""} for $lang:");
  missingKeys.map((key) => print("  - $key")).toList();

  print('\nDo you wish to translate them? [y/n]');
  String? answer = stdin.readLineSync(encoding: utf8);

  missingKeys.map((missingKey) {
    final List<String> keyPath = missingKey.split('.');
    Map<String, dynamic> map = answer == 'y'
        ? translate(
            keyPath, getPathValue(keyPath, superClass.yaml).trim(), locale)
        : addPathToMap(locale.yaml, keyPath, null);

    // regenerate class
    locale = LocaleGenerator(map, localeCode: locale.localeCode);
    createClassFile(locale.localeCode, locale.generatedClass);
    writeYAML(map, 'assets/translations/${locale.localeCode}.yaml');
  }).toList();
}

List<String> findMissingKeys(
    LocaleGenerator superClass, LocaleGenerator locale) {
  List<String> keys = [];
  superClass.keys.map((String masterKey) {
    if (!locale.keys.contains(masterKey)) {
      keys.add(masterKey);
    }
  }).toList();

  return keys;
}
