import 'dart:convert';
import 'dart:io';

import 'package:neko/src/locale_generator.dart';
import 'package:yaml_mapper/yaml_mapper.dart';

Map<String, dynamic> translate(
    List<String> missingKeyPath, String text, LocaleGenerator locale) {
  print("\nTranslation for \"$text\":");
  String? translation = stdin.readLineSync(encoding: utf8);
  if (translation == null) {
    print("Please provide an utf-8 formatted String!\nAborting ...");
    return locale.yaml;
  }

  return addPathToMap(locale.yaml, missingKeyPath, translation);
}
