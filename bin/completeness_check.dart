// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:inu/src/translation.dart';
import 'package:yaml_mapper/yaml_mapper.dart';

import 'constants.dart';
import 'locale_generator.dart';

void checkCompleteness(LocaleGenerator superLocale, LocaleGenerator locale) {
  Set<String> missingKeys = findMissingKeys(superLocale, locale);

  _cleanEmptyKeys(locale);

  _genLocalization(
      _addMissingKeysToYaml(missingKeys, locale.yaml, superLocale.yaml),
      locale.localeCode);

  if (missingKeys.isNotEmpty) {
    _printMissingStringsAndPrompt(missingKeys, locale.localeCode);
    String? answer = stdin.readLineSync(encoding: utf8)?.trim();
    if (answer != null && RegExp("(y|Y|j|J)").hasMatch(answer)) {
      _genLocalization(
          _addMissingKeysToYaml(missingKeys, locale.yaml, superLocale.yaml,
              promtTranslation: true),
          locale.localeCode);
    }
  }
}

void _printMissingStringsAndPrompt(Set<String> missingKeys, String lang) {
  print(
      "\nFound ${missingKeys.length} missing translation${missingKeys.length > 1 ? "s" : ""} for $lang:");

  for (var key in missingKeys) print("  - $key");

  print('\nDo you wish to translate them? [y/n]');
}

Yaml _addMissingKeysToYaml(Set<String> missingKeys, Yaml yaml, Yaml superYaml,
    {bool promtTranslation = false}) {
  for (var missingKey in missingKeys) {
    final List<String> keyPath = missingKey.split('.');
    yaml = promtTranslation
        ? translate(keyPath, getPathValue(keyPath, superYaml).trim(), yaml)
        : addPathToMap(yaml, keyPath, null);
  }
  return yaml;
}

void _genLocalization(Yaml yaml, String localeCode) {
  final locale = LocaleGenerator(yaml, localeCode: localeCode);
  _createClassFile(locale.localeCode, locale.localeCode);
  writeYAML(locale.yaml, 'assets/translations/${locale.localeCode}.yaml');
}

void _createClassFile(String className, String contents) =>
    Locations.classFile(className).writeAsStringSync(contents);

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
