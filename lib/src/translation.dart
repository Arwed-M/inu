import 'dart:convert';
import 'dart:io';

import 'package:yaml_mapper/yaml_mapper.dart';

Map<String, dynamic> translate(
    List<String> missingKeyPath, String text, Map<String, dynamic> map) {
  String? translation = stdin.readLineSync(encoding: utf8);
  if (translation == null) {
    return map;
  }

  return addValToMap(map, missingKeyPath, translation);
}
