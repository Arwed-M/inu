import 'dart:convert';
import 'dart:io';

import 'package:inu/src/gen_locale.dart';
import 'package:yaml_mapper/yaml_mapper.dart';

import 'locale_generator.dart';
import 'translation.dart';

void checkCompleteness(LocaleGenerator superClass, LocaleGenerator locale) {
  Map<String, dynamic> map = locale.yaml;
  Set<String> missingKeys = findMissingKeys(superClass, locale);

  final String lang = locale.localeCode;
  final bool cleanedEmptyKeys = _cleanEmptyKeys(locale);

  if (missingKeys.isNotEmpty) {
    print(
        "\nFound ${missingKeys.length} missing translation${missingKeys.length > 1 ? "s" : ""} for $lang:");
    missingKeys.map((key) => print("  - $key")).toList();

    print('\nDo you wish to translate them? [y/n]');
    String? answer = stdin.readLineSync(encoding: utf8);

    missingKeys.map((missingKey) {
      final List<String> keyPath = missingKey.split('.');
      map = answer == 'y'
          ? translate(
              keyPath, getPathValue(keyPath, superClass.yaml).trim(), map)
          : addPathToMap(map, keyPath, null);
    }).toList();
  }

  if (missingKeys.isNotEmpty || cleanedEmptyKeys) {
    // regenerate class
    locale = LocaleGenerator(map, localeCode: locale.localeCode);
    createClassFile(locale.localeCode, locale.generatedClass);
    writeYAML(map, 'assets/translations/${locale.localeCode}.yaml');
  }
}

/// Finds all keys that aren't translated in the locale files
Set<String> findMissingKeys(
        LocaleGenerator superClass, LocaleGenerator locale) =>
    superClass.keys.difference(locale.keys);

/// Removes all empty keys in locale files which are not declared in Inu superclass.
/// Returns true if keys have been removed
bool _cleanEmptyKeys(LocaleGenerator locale) {
  locale.nullKeys
      .map((key) => removeFromMap(locale.yaml, key.split('.')))
      .toList();
  return locale.nullKeys.isNotEmpty;
}
