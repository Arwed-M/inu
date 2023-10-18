// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:inu/src/translation.dart';
import 'package:yaml_mapper/yaml_mapper.dart';

import 'fs_utils.dart';
import 'models/node.dart';

void checkCompleteness(SuperClass superLocale, LocaleClass locale) {
  Set<String> missingKeys = superLocale.keysNotIn(locale);

  final yaml = _cleanEmptyKeys(superLocale, locale);

  _genLocalization(_addMissingKeysToYaml(missingKeys, yaml, superLocale.yaml),
      locale.locale);

  if (missingKeys.isNotEmpty) {
    _printMissingStringsAndPrompt(missingKeys, locale.locale);
    String? answer = stdin.readLineSync(encoding: utf8)?.trim();
    if (answer != null && RegExp("(y|Y|j|J)").hasMatch(answer)) {
      _genLocalization(
          _addMissingKeysToYaml(missingKeys, yaml, superLocale.yaml,
              promtTranslation: true),
          locale.locale);
    }
  }
}

void _printMissingStringsAndPrompt(Set<String> missingKeys, String lang) {
  print(
      "\nFound ${missingKeys.length} missing translation${missingKeys.length > 1 ? "s" : ""} for $lang:");

  for (var key in missingKeys) {
    print("  - $key");
  }

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
  FS.writeLocaleFile(
      localeCode, LocaleClass(yaml: yaml, locale: localeCode).renderDartFile());
  FS.updateYamlFile(localeCode, yaml);
}

/// Removes all empty keys in locale files which are not declared in Inu superclass.
/// Returns true if keys have been removed
Yaml _cleanEmptyKeys(LocaleClass superLocale, LocaleClass locale) {
  final yaml = locale.yaml;
  locale
      .keysNotIn(superLocale)
      .forEach((key) => removeFromMap(yaml, key.split('.')));
  return yaml;
}

extension LocaleClassExtensions on LocaleClass {
  Yaml get yaml => FS.readYamlFile(locale);

  Set<String> keysNotIn(LocaleClass other) {
    final keys = this.keys;
    keys.removeAll(other.keys);
    return keys;
  }
}
