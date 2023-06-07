import 'dart:convert';
import 'dart:io';

import 'package:yaml_mapper/yaml_mapper.dart';

Map<String, dynamic> translate(
    List<String> missingKeyPath, String text, Map<String, dynamic> map) {
  print("\nTranslation for \"$text\":");
  String? translation = stdin.readLineSync(encoding: utf8);
  if (translation == null) {
    print("Please provide an utf-8 formatted String!\nAborting ...");
    return map;
  }

  return addPathToMap(map, missingKeyPath, translation);
}
